From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH] scsi_error: count medium access timeout only once per
 EH run
Date: Mon, 27 Feb 2017 14:33:13 -0500
Message-ID: <1488223993.10197.146.camel@localhost.localdomain>
References: <1487845639-73322-1-git-send-email-hare@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47262 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751852AbdB0TdO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 27 Feb 2017 14:33:14 -0500
In-Reply-To: <1487845639-73322-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Lawrence Oberman <loberman@redhat.com>, Benjamin Block <bblock@linux.vnet.ibm.vom>, Steffen Maier <maier@de.ibm.com>, Hannes Reinecke <hare@suse.com>

On Thu, 2017-02-23 at 11:27 +0100, Hannes Reinecke wrote:
> The current medium access timeout counter will be increased for
> each command, so if there are enough failed commands we'll hit
> the medium access timeout for even a single failure.
> Fix this by making the timeout per EH run, ie the counter will
> only be increased once per device and EH run.

So, this is good, the current implementation has a flaw in that
under certain conditions, a device will get offlined immediately,
(i.e. if there are a few medium access commands pending, and
they all timeout), which isn't what was intended.

It means, of course, that we will no longer detect cases like:

<timeout>, <timeout>, SUCCESS, SUCCESS, SUCCESS, <timeout>

as separate medium access timeouts, but I think the original
intent of Martin's change wasn't to operate on such a short
time-scale, am I right, Martin?

I made a few notes on the coding/implementation (below), but that
doesn't affect the functional change.  We should definitely change
what we have now, it is causing people problems.

> 
> Cc: Ewan Milne <emilne@redhat.com>
> Cc: Lawrence Oberman <loberman@redhat.com>
> Cc: Benjamin Block <bblock@linux.vnet.ibm.vom>
> Cc: Steffen Maier <maier@de.ibm.com>
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/scsi_error.c |  2 ++
>  drivers/scsi/sd.c         | 16 ++++++++++++++--
>  drivers/scsi/sd.h         |  1 +
>  include/scsi/scsi.h       |  1 +
>  4 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index f2cafae..481ea1b 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -58,6 +58,7 @@
>  static int scsi_eh_try_stu(struct scsi_cmnd *scmd);
>  static int scsi_try_to_abort_cmd(struct scsi_host_template *,
>  				 struct scsi_cmnd *);
> +static int scsi_eh_action(struct scsi_cmnd *scmd, int rtn);
>  
>  /* called with shost->host_lock held */
>  void scsi_eh_wakeup(struct Scsi_Host *shost)
> @@ -249,6 +250,7 @@ int scsi_eh_scmd_add(struct scsi_cmnd *scmd, int eh_flag)
>  	if (scmd->eh_eflags & SCSI_EH_ABORT_SCHEDULED)
>  		eh_flag &= ~SCSI_EH_CANCEL_CMD;
>  	scmd->eh_eflags |= eh_flag;
> +	scsi_eh_action(scmd, NEEDS_RESET);

So here we are overloading the eh_disp argument with a flag to reset the
medium_access_reset variable.  James changed the calling sequence of
this function already to remove arguments, we could just add another
boolean parameter "reset".  scsi_driver.eh_action() would need it too.

>  	list_add_tail(&scmd->eh_entry, &shost->eh_cmd_q);
>  	shost->host_failed++;
>  	scsi_eh_wakeup(shost);
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index be535d4..cd9f290 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1696,12 +1696,21 @@ static int sd_pr_clear(struct block_device *bdev, u64 key)
>   *	the eh command is passed in eh_disp.  We're looking for devices that
>   *	fail medium access commands but are OK with non access commands like
>   *	test unit ready (so wrongly see the device as having a successful
> - *	recovery)
> + *	recovery).
> + *	We have to be careful to count a medium access failure only once
> + *	per SCSI EH run; there might be several timed out commands which
> + *	will cause the 'max_medium_access_timeouts' counter to trigger
> + *	after the first SCSI EH run already and set the device to offline.
>   **/
>  static int sd_eh_action(struct scsi_cmnd *scmd, int eh_disp)
>  {
>  	struct scsi_disk *sdkp = scsi_disk(scmd->request->rq_disk);
>  
> +	if (eh_disp == NEEDS_RESET) {
> +		/* New SCSI EH run, reset gate variable */
> +		sdkp->medium_access_reset = 0;
> +		return eh_disp;
> +	}
>  	if (!scsi_device_online(scmd->device) ||
>  	    !scsi_medium_access_command(scmd) ||
>  	    host_byte(scmd->result) != DID_TIME_OUT ||
> @@ -1715,7 +1724,10 @@ static int sd_eh_action(struct scsi_cmnd *scmd, int eh_disp)
>  	 * process of recovering or has it suffered an internal failure
>  	 * that prevents access to the storage medium.
>  	 */
> -	sdkp->medium_access_timed_out++;
> +	if (!sdkp->medium_access_reset) {
> +		sdkp->medium_access_timed_out++;
> +		sdkp->medium_access_reset++;
> +	}

If we only increment sdkp->medium_access_reset when it was 0, then it
will only have the values 0 and 1, and does not need to have the full
unsigned int precision.  A single bit field is sufficient, in which
case the code would be:  sdkp->medium_access_reset = 1;

>  
>  	/*
>  	 * If the device keeps failing read/write commands but TEST UNIT
> diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
> index 4dac35e..19e0bab 100644
> --- a/drivers/scsi/sd.h
> +++ b/drivers/scsi/sd.h
> @@ -85,6 +85,7 @@ struct scsi_disk {
>  	unsigned int	physical_block_size;
>  	unsigned int	max_medium_access_timeouts;
>  	unsigned int	medium_access_timed_out;
> +	unsigned int	medium_access_reset;

This could be an unsigned int : 1 with the other single bit fields at
the end of the structure, with the change above.

>  	u8		media_present;
>  	u8		write_prot;
>  	u8		protection_type;/* Data Integrity Field */
> diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
> index a1e1930..b6c750f 100644
> --- a/include/scsi/scsi.h
> +++ b/include/scsi/scsi.h
> @@ -185,6 +185,7 @@ static inline int scsi_is_wlun(u64 lun)
>  #define TIMEOUT_ERROR   0x2007
>  #define SCSI_RETURN_NOT_HANDLED   0x2008
>  #define FAST_IO_FAIL	0x2009
> +#define NEEDS_RESET     0x2010

See above, this is overloading the use of the parameter.

>  
>  /*
>   * Midlevel queue return values.

Reviewed-by: Ewan D. Milne <emilne@redhat.com>
