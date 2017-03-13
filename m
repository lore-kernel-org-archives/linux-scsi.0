From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv3 1/6] scsi_error: count medium access timeout only once
 per EH run
Date: Mon, 13 Mar 2017 15:48:25 +0100
Message-ID: <7d908388-cfff-3c02-c185-9a0ccbcd3d45@suse.de>
References: <1488359720-130871-1-git-send-email-hare@suse.de>
 <1488359720-130871-2-git-send-email-hare@suse.de>
 <10894b48-b215-f2ef-6df0-d48a94ec7158@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41993 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751061AbdCMOs2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Mar 2017 10:48:28 -0400
In-Reply-To: <10894b48-b215-f2ef-6df0-d48a94ec7158@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Lawrence Obermann <loberman@redhat.com>, Benjamin Block <bblock@linux.vnet.ibm.com>, Steffen Maier <maier@de.ibm.com>, Hannes Reinecke <hare@suse.com>

On 03/13/2017 02:37 PM, Mauricio Faria de Oliveira wrote:
> Hannes,
> 
> On 03/01/2017 06:15 AM, Hannes Reinecke wrote:
>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>> index f2cafae..cec439c 100644
>> --- a/drivers/scsi/scsi_error.c
>> +++ b/drivers/scsi/scsi_error.c
>> @@ -58,6 +58,7 @@
>>  static int scsi_eh_try_stu(struct scsi_cmnd *scmd);
>>  static int scsi_try_to_abort_cmd(struct scsi_host_template *,
>>                   struct scsi_cmnd *);
>> +static int scsi_eh_reset(struct scsi_cmnd *scmd);
>>
>>  /* called with shost->host_lock held */
>>  void scsi_eh_wakeup(struct Scsi_Host *shost)
>> @@ -249,6 +250,7 @@ int scsi_eh_scmd_add(struct scsi_cmnd *scmd, int
>> eh_flag)
>>      if (scmd->eh_eflags & SCSI_EH_ABORT_SCHEDULED)
>>          eh_flag &= ~SCSI_EH_CANCEL_CMD;
>>      scmd->eh_eflags |= eh_flag;
>> +    scsi_eh_reset(scmd);
>>      list_add_tail(&scmd->eh_entry, &shost->eh_cmd_q);
>>      shost->host_failed++;
>>      scsi_eh_wakeup(shost);
>> @@ -1107,7 +1109,19 @@ static int scsi_eh_action(struct scsi_cmnd
>> *scmd, int rtn)
>>      if (!blk_rq_is_passthrough(scmd->request)) {
>>          struct scsi_driver *sdrv = scsi_cmd_to_driver(scmd);
>>          if (sdrv->eh_action)
>> -            rtn = sdrv->eh_action(scmd, rtn);
>> +            rtn = sdrv->eh_action(scmd, rtn, false);
>> +    }
>> +    return rtn;
>> +}
>> +
>> +static int scsi_eh_reset(struct scsi_cmnd *scmd)
>> +{
>> +    int rtn = SUCCESS;
>> +
>> +    if (!blk_rq_is_passthrough(scmd->request)) {
>> +        struct scsi_driver *sdrv = scsi_cmd_to_driver(scmd);
>> +        if (sdrv->eh_action)
>> +            rtn = sdrv->eh_action(scmd, rtn, true);
>>      }
>>      return rtn;
>>  }
> 
> Apparently we can de-duplicate code in scsi_eh_reset()/scsi_eh_action(),
> and change less of sd_eh_action() (i.e., no new parameter).
> 
> Something like this.  Thoughts?
> 
> 
> - Deduplicate code in scsi_eh_reset() and scsi_eh_action()
>   - A call to scsi_eh_reset() with reset == false calls into eh_action()
> 
>   - A call to scsi_eh_reset() with reset == true returns early,
>     (as happens with/if sd_eh_action() is called in your patch)
> 
>   - A call to scsi_eh_reset() in scsi_eh_scmd_add() uses SUCCESS just
>     for consistency with scsi_eh_reset() in your patch, as the return
>     value is ignored in it.
> 
> - Less changes to sd_eh_action()
>   - Removed one chunk in sd_eh_action() ('reset gate variable')
>   - No more parameter changes in sd_eh_action() (no 'reset' parameter)
> 
> - Removed forward declaration of scsi_eh_reset(), as already suggested
> 
> 
> 
> static int scsi_eh_reset(struct scsi_cmnd *scmd, int eh_disp, bool reset)
> {
>     int rtn = eh_disp;
> 
>     if (!blk_rq_is_passthrough(scmd->request)) {
>         struct scsi_driver *sdrv = scsi_cmd_to_driver(scmd);
>         if (sdrv->eh_action) {
>             if (reset) {
>                  struct scsi_disk *sdkp =
> scsi_disk(scmd->request->rq_disk);
> 
>                 /* New SCSI EH run, reset gate variable */
>                 sdkp->medium_access_reset = 0;
>                 return rtn;
>             }
>             rtn = sdrv->eh_action(scmd, rtn);
>         }
>      }
>      return rtn;
> }
> 
Nope.

This is assuming that we're always running on a scsi_disk, and that
scsi_disk is the only one implementing 'eh_action'.
Neither of which is necessarily true.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
