From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv3 1/6] scsi_error: count medium access timeout only once
 per EH run
Date: Mon, 13 Mar 2017 11:20:04 +0100
Message-ID: <4c254979-d997-6836-ac07-e3892bc772af@suse.de>
References: <1488359720-130871-1-git-send-email-hare@suse.de>
 <1488359720-130871-2-git-send-email-hare@suse.de>
 <20170302201629.GB7420@bblock-ThinkPad-W530>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46709 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750790AbdCMKUN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Mar 2017 06:20:13 -0400
In-Reply-To: <20170302201629.GB7420@bblock-ThinkPad-W530>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Block <bblock@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Lawrence Obermann <loberman@redhat.com>, Steffen Maier <maier@de.ibm.com>, Hannes Reinecke <hare@suse.com>

On 03/02/2017 09:16 PM, Benjamin Block wrote:
> Hej Hannes,
> 
> On Wed, Mar 01, 2017 at 10:15:15AM +0100, Hannes Reinecke wrote:
>> The current medium access timeout counter will be increased for
>> each command, so if there are enough failed commands we'll hit
>> the medium access timeout for even a single failure.
>> Fix this by making the timeout per EH run, ie the counter will
>> only be increased once per device and EH run.
>>
>> Cc: Ewan Milne <emilne@redhat.com>
>> Cc: Lawrence Obermann <loberman@redhat.com>
>> Cc: Benjamin Block <bblock@linux.vnet.ibm.com>
>> Cc: Steffen Maier <maier@de.ibm.com>
>> Signed-off-by: Hannes Reinecke <hare@suse.com>
> 
> Steffen already suggested it, It would be nice to have a stable-tag
> here. This already caused multiple real-world false-positive outages, I
> think that qualifies for stable :)
> 
>> ---
>>  drivers/scsi/scsi_error.c  | 16 +++++++++++++++-
>>  drivers/scsi/sd.c          | 21 +++++++++++++++++----
>>  drivers/scsi/sd.h          |  1 +
>>  include/scsi/scsi_driver.h |  2 +-
>>  4 files changed, 34 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>> index f2cafae..cec439c 100644
>> --- a/drivers/scsi/scsi_error.c
>> +++ b/drivers/scsi/scsi_error.c
>> @@ -58,6 +58,7 @@
>>  static int scsi_eh_try_stu(struct scsi_cmnd *scmd);
>>  static int scsi_try_to_abort_cmd(struct scsi_host_template *,
>>  				 struct scsi_cmnd *);
>> +static int scsi_eh_reset(struct scsi_cmnd *scmd);
>>
>>  /* called with shost->host_lock held */
>>  void scsi_eh_wakeup(struct Scsi_Host *shost)
>> @@ -249,6 +250,7 @@ int scsi_eh_scmd_add(struct scsi_cmnd *scmd, int eh_flag)
>>  	if (scmd->eh_eflags & SCSI_EH_ABORT_SCHEDULED)
>>  		eh_flag &= ~SCSI_EH_CANCEL_CMD;
>>  	scmd->eh_eflags |= eh_flag;
>> +	scsi_eh_reset(scmd);
>>  	list_add_tail(&scmd->eh_entry, &shost->eh_cmd_q);
>>  	shost->host_failed++;
>>  	scsi_eh_wakeup(shost);
>> @@ -1107,7 +1109,19 @@ static int scsi_eh_action(struct scsi_cmnd *scmd, int rtn)
>>  	if (!blk_rq_is_passthrough(scmd->request)) {
>>  		struct scsi_driver *sdrv = scsi_cmd_to_driver(scmd);
>>  		if (sdrv->eh_action)
>> -			rtn = sdrv->eh_action(scmd, rtn);
>> +			rtn = sdrv->eh_action(scmd, rtn, false);
>> +	}
>> +	return rtn;
>> +}
>> +
>> +static int scsi_eh_reset(struct scsi_cmnd *scmd)
>> +{
>> +	int rtn = SUCCESS;
>> +
>> +	if (!blk_rq_is_passthrough(scmd->request)) {
>> +		struct scsi_driver *sdrv = scsi_cmd_to_driver(scmd);
>> +		if (sdrv->eh_action)
>> +			rtn = sdrv->eh_action(scmd, rtn, true);
>>  	}
>>  	return rtn;
>>  }
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index c7839f6..c794686 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -115,7 +115,7 @@
>>  static int sd_init_command(struct scsi_cmnd *SCpnt);
>>  static void sd_uninit_command(struct scsi_cmnd *SCpnt);
>>  static int sd_done(struct scsi_cmnd *);
>> -static int sd_eh_action(struct scsi_cmnd *, int);
>> +static int sd_eh_action(struct scsi_cmnd *, int, bool);
>>  static void sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer);
>>  static void scsi_disk_release(struct device *cdev);
>>  static void sd_print_sense_hdr(struct scsi_disk *, struct scsi_sense_hdr *);
>> @@ -1689,18 +1689,28 @@ static int sd_pr_clear(struct block_device *bdev, u64 key)
>>   *	sd_eh_action - error handling callback
>>   *	@scmd:		sd-issued command that has failed
>>   *	@eh_disp:	The recovery disposition suggested by the midlayer
>> + *	@reset:		Reset medium access counter
>>   *
>>   *	This function is called by the SCSI midlayer upon completion of an
>>   *	error test command (currently TEST UNIT READY). The result of sending
>>   *	the eh command is passed in eh_disp.  We're looking for devices that
>>   *	fail medium access commands but are OK with non access commands like
>>   *	test unit ready (so wrongly see the device as having a successful
>> - *	recovery)
>> + *	recovery).
>> + *	We have to be careful to count a medium access failure only once
>> + *	per SCSI EH run; there might be several timed out commands which
>> + *	will cause the 'max_medium_access_timeouts' counter to trigger
>> + *	after the first SCSI EH run already and set the device to offline.
>>   **/
>> -static int sd_eh_action(struct scsi_cmnd *scmd, int eh_disp)
>> +static int sd_eh_action(struct scsi_cmnd *scmd, int eh_disp, bool reset)
>>  {
>>  	struct scsi_disk *sdkp = scsi_disk(scmd->request->rq_disk);
>>
>> +	if (reset) {
>> +		/* New SCSI EH run, reset gate variable */
>> +		sdkp->medium_access_reset = 0;
>> +		return eh_disp;
>> +	}
>>  	if (!scsi_device_online(scmd->device) ||
>>  	    !scsi_medium_access_command(scmd) ||
>>  	    host_byte(scmd->result) != DID_TIME_OUT ||
>> @@ -1714,7 +1724,10 @@ static int sd_eh_action(struct scsi_cmnd *scmd, int eh_disp)
>>  	 * process of recovering or has it suffered an internal failure
>>  	 * that prevents access to the storage medium.
>>  	 */
>> -	sdkp->medium_access_timed_out++;
>> +	if (!sdkp->medium_access_reset) {
>> +		sdkp->medium_access_timed_out++;
>> +		sdkp->medium_access_reset = 1;
>> +	}
>>
>>  	/*
>>  	 * If the device keeps failing read/write commands but TEST UNIT
>> diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
>> index 4dac35e..6a4f75a 100644
>> --- a/drivers/scsi/sd.h
>> +++ b/drivers/scsi/sd.h
>> @@ -106,6 +106,7 @@ struct scsi_disk {
>>  	unsigned	rc_basis: 2;
>>  	unsigned	zoned: 2;
>>  	unsigned	urswrz : 1;
>> +	unsigned	medium_access_reset : 1;
>>  };
>>  #define to_scsi_disk(obj) container_of(obj,struct scsi_disk,dev)
>>
>> diff --git a/include/scsi/scsi_driver.h b/include/scsi/scsi_driver.h
>> index 891a658..d5e0012 100644
>> --- a/include/scsi/scsi_driver.h
>> +++ b/include/scsi/scsi_driver.h
>> @@ -15,7 +15,7 @@ struct scsi_driver {
>>  	int (*init_command)(struct scsi_cmnd *);
>>  	void (*uninit_command)(struct scsi_cmnd *);
>>  	int (*done)(struct scsi_cmnd *);
>> -	int (*eh_action)(struct scsi_cmnd *, int);
>> +	int (*eh_action)(struct scsi_cmnd *, int, bool);
>>  };
>>  #define to_scsi_driver(drv) \
>>  	container_of((drv), struct scsi_driver, gendrv)
>> --
>> 1.8.5.6
>>
> 
> Bart already made some suggestions that I think are good, otherwise I
> have nothing big to add. Should work just fine.
> 
> The only thing that still bugs me about this is the corner-case we
> talked about the last time we talked about this. No show-stopper for me,
> but I though I might as well mention it.
> 
> When we do the different escalation-stages in scsi_unjam_host(), we
> always have the same basic pattern:
> 
>   for_all_in(work_q)) {
>       cmd = get_next(eh_work_q);
> 
>       do_action(cmd); /* might be abort, lun_reset, target_reset, ... */
> 
>       if (was_ok()) {
>           move_to(check_list, cmd);
> 	  move_same_scope_to(check_list, work_q);
>       }
>   }
> 
>   for_all_in(check_list) {
>       cmd  = get_next(eh_work_q);
>       sdev = get_sdev(cmd);
> 
>       test_device(sdev); /* TUR and maybe STU */
> 
>       for_all_in_same_scope_in(check_list) {
>           if (test_was_ok() && scsi_eh_action(scmd, SUCCESS) == SUCCESS)
>               move_to(done_q, cmd)
>           else
>               move_to(work_q, cmd)
>       }
>   }
> 
>   return list_empty(eh_work_q)
> 
> (I hope I have this right, irritatingly this 'looks' different for no
> reason I can see for the different stages).
> 
> The corner-case being, if we have a cmd that failes in scsi_eh_action(),
> it will be put back into the work_q. But all other command for the same
> scope will be put into the done_q because for them, sd_eh_action()
> will early-return with SUCCESS (sdev is not online anymore).
> 
> Then, because the work_q is not empty, we will escalate to the next
> step. Worst case being, we escalate to host_reset, although EH is
> actually already done - we already decided that this sdev is offline in
> SD and even when we go through host-reset it will not become running
> anymore..  which makes the whole host-reset a big waste of time.
> 
> AFAIK the escalate to Host-Reset can only happen if the LLD has no
> pointer for STU, LUN-, Target- and Bus-Reset, so its actually not as
> bad, but I still think its something we should correct.
> 
> If you don't wanna change this here, I can probably send a part of the
> patch I made for this some time ago.
> 
Hmm. Shouldn't this resolved by simply returning 'SUCCESS' in
sd_eh_action() when it decides to take the device offline?

IE doing something like this:

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c794686..311ac3c 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1739,7 +1739,7 @@ static int sd_eh_action(struct scsi_cmnd *scmd,
int eh_dis
p, bool reset)
                            "Medium access timeout failure. Offlining
disk!\n");
                scsi_device_set_state(scmd->device, SDEV_OFFLINE);

-               return FAILED;
+               return SUCCESS;
        }

        return eh_disp;

would help, no?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
