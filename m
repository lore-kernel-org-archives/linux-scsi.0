From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH / RFC] scsi_error handler update. (3/4)
Date: 12 Feb 2003 17:34:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1045087146.1623.11.camel@mulgrave>
References: <20030211081351.GA1368@beaverton.ibm.com>
	<20030211081536.GB1368@beaverton.ibm.com>
	<20030211081744.GC1368@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id OAA06616
	for <linux-scsi@vger.kernel.org>; Wed, 12 Feb 2003 14:34:37 -0800
In-Reply-To: <20030211081744.GC1368@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2003-02-11 at 03:17, Mike Anderson wrote: 
> This patch series is against scsi-misc-2.5.
> 
> 02_serror-hndlr-1.diff:
> 	- Change to using eh_cmd_list.
> 	- Change scsi_unjam_host to get sense, abort cmds, ready
> 	  devices, and disposition cmds for retry or finish.
> 	- Moved retries outside of eh.
> 
> -andmike
> --
> Michael Anderson
> andmike@us.ibm.com
> 
>  scsi_error.c |  477 +++++++++++++++++++++++++++++------------------------------
>  1 files changed, 241 insertions(+), 236 deletions(-)
> ------
> 
> diff -Nru a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> --- a/drivers/scsi/scsi_error.c	Mon Feb 10 22:25:47 2003
> +++ b/drivers/scsi/scsi_error.c	Mon Feb 10 22:25:47 2003
> @@ -211,36 +211,36 @@
>   * @sc_list:	List for failed cmds.
>   * @shost:	scsi host being recovered.
>   **/
> -static void scsi_eh_prt_fail_stats(Scsi_Cmnd *sc_list, struct Scsi_Host *shost)
> +static inline void scsi_eh_prt_fail_stats(struct Scsi_Host *shost)
>  {
> -	Scsi_Cmnd *scmd;
> -	Scsi_Device *sdev;
> +	struct scsi_cmnd *scmd;
> +	struct scsi_device *sdev;
>  	int total_failures = 0;
>  	int cmd_failed = 0;
> -	int cmd_timed_out = 0;
> +	int cmd_cancel = 0;
>  	int devices_failed = 0;
>  
>  
>  	list_for_each_entry(sdev, &shost->my_devices, siblings) {
Your eh_list here is per host, so there's no need to loop over all the
devices above. 

> -		for (scmd = sc_list; scmd; scmd = scmd->bh_next) {
> +		list_for_each_entry(scmd, &shost->eh_cmd_list, eh_list) {
>  			if (scmd->device == sdev) {
>  				++total_failures;
>  				if (scsi_eh_eflags_chk(scmd,
[...] 
> -static int scsi_eh_bus_device_reset(Scsi_Cmnd *sc_todo, struct Scsi_Host *shost)
> +static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
> +				    struct list_head *done_list)
>  {
>  	int rtn;
> -	Scsi_Cmnd *scmd;
> -	Scsi_Device *sdev;
> -
> -	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Trying BDR\n", __FUNCTION__));
> +	struct list_head *lh, *lh_sf;
> +	struct scsi_cmnd *scmd, *bdr_scmd;
> +	struct scsi_device *sdev;
>  
>  	list_for_each_entry(sdev, &shost->my_devices, siblings) {

Same problem here. 

> -		for (scmd = sc_todo; scmd; scmd = scmd->bh_next)
> -			if ((scmd->device == sdev) &&
> -			    scsi_eh_eflags_chk(scmd, SCSI_EH_CMD_ERR))
> +		bdr_scmd = NULL;
> +		list_for_each_entry(scmd, &shost->eh_cmd_list, eh_list)
> +			if (scmd->device == sdev) {
> +				bdr_scmd = scmd;
>  				break;
[...]
> @@ -1477,6 +1469,8 @@
>  
>  	ASSERT_LOCK(shost->host_lock, 0);
>  
> +	shost->in_recovery = 0;
> +
>  	/*
>  	 * If the door was locked, we need to insert a door lock request
>  	 * onto the head of the SCSI request queue for the device.  There

This is a lot better than we had previously, but still, I think resetting
in_recovery should happen after we've potentially queued door lock commands
on the queue head, since as soon as we reset this, the queue can potentially
be restarted (even without the necessary restart below this in the code).


James

