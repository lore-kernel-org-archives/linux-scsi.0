From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv4 12/12] mpt3sas: lockless command submission
Date: Fri, 3 Mar 2017 14:59:29 +0100
Message-ID: <fb50be90-81c4-06dd-d7af-ab4726065580@suse.de>
References: <1487759512-3873-1-git-send-email-hare@suse.de>
 <1487759512-3873-13-git-send-email-hare@suse.de>
 <CAK=zhgr6w4-cq1FTb5LcEEf7aGnGxbsEXGOxqUmnFTTW2dJO6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52351 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752198AbdCCOMo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 3 Mar 2017 09:12:44 -0500
In-Reply-To: <CAK=zhgr6w4-cq1FTb5LcEEf7aGnGxbsEXGOxqUmnFTTW2dJO6A@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.com>

On 03/03/2017 01:32 PM, Sreekanth Reddy wrote:
> On Wed, Feb 22, 2017 at 4:01 PM, Hannes Reinecke <hare@suse.de> wrote:
>> Instead of holding 'struct scsiio_tracker' in its own pool we
>> can embed it into the payload of the scsi command. This allows
>> us to get rid of the lock when submitting and receiving commands
>> and streamline operations.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>> ---
>>  drivers/scsi/mpt3sas/mpt3sas_base.c      | 120 +++++++++++++------------------
>>  drivers/scsi/mpt3sas/mpt3sas_base.h      |  23 +++---
>>  drivers/scsi/mpt3sas/mpt3sas_ctl.c       |  17 +++--
>>  drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 118 +++++++++---------------------
>>  drivers/scsi/mpt3sas/mpt3sas_warpdrive.c |  35 +--------
>>  5 files changed, 105 insertions(+), 208 deletions(-)
>>
>> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
>> index 169d185..966a775 100644
>> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
>> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
>> @@ -863,12 +863,19 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
>>  }
>>
>>  struct scsiio_tracker *
>> -mpt3sas_get_st_from_smid(struct MPT3SAS_ADAPTER *ioc, u16 smid)
>> +_get_st_from_smid(struct MPT3SAS_ADAPTER *ioc, u16 smid)
>
> Can we rename the name of this function as  _base_get_st_from_smid(),
> Since we always try to follow below notations,
>  * prefix with "_<filenamePart(i.e. base)>" if the function is used
> within this file other wise prefix with "mpt3sas_<filename>" if this
> function is shared between more than one file.
>
Sure, will do.

>>  {
>> +       struct scsi_cmnd *cmd;
>> +
>>         if (WARN_ON(!smid) ||
>>             WARN_ON(smid >= ioc->hi_priority_smid))
>>                 return NULL;
>> -       return &ioc->scsi_lookup[smid - 1];
>> +
>> +       cmd = mpt3sas_scsih_scsi_lookup_get(ioc, smid);
>> +       if (cmd)
>> +               return scsi_cmd_priv(cmd);
>> +
>> +       return NULL;
>>  }
>>
>>  /**
>> @@ -889,7 +896,7 @@ struct scsiio_tracker *
>>                 struct scsiio_tracker *st;
>>
>>                 if (smid < ctl_smid) {
>> -                       st = mpt3sas_get_st_from_smid(ioc, smid);
>> +                       st = _get_st_from_smid(ioc, smid);
>>                         if (st)
>>                                 cb_idx = st->cb_idx;
>
> I think, here we can safely assign "cb_idx"  as "ioc->scsi_io_cb_idx",
> no need to get it from scsiio_tracker. since all the smid's below
> ctl_smid will we used for SCSI IO's recieved from scsih_qcmd.
>
In theory, yes.
However, 'cb_idx' get reset to 0xFF once we're done with the command,
so this serves the dual purpose of getting us the callback index _and_ 
telling us if the command is in flight.

[ .. ]
>> @@ -1297,9 +1305,7 @@ struct scsiio_tracker *
>>         chain_req = list_entry(ioc->free_chain_list.next,
>>             struct chain_tracker, tracker_list);
>>         list_del_init(&chain_req->tracker_list);
>> -       st = mpt3sas_get_st_from_smid(ioc, smid);
>> -       if (st)
>> -               list_add_tail(&chain_req->tracker_list, &st->chain_list);
>> +       list_add_tail(&chain_req->tracker_list, &st->chain_list);
>>         spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
>
> Still we have this lock in the IO path. May be we can remove this lock
> too by allocating "ioc->ioc->chains_needed_per_io * shost->can_queue"
> number of chain buffers and we can acces the required chain buffer
> using scmd's tag pluse chain_offset_per_io coressponding to that
> repective tag.
>
> May be we will post a separate patch for this after some time.
>
Actually, I tried this (and I have a patch to move that to use sbitmap), 
but didn't notice any significant improvement.
(But then as I only ran against a middle-range SSD setup this wasn't 
really surprising).
But sure, I can dig it up and include in this patchset.

[ .. ]
>> @@ -2359,9 +2316,8 @@ int mpt3sas_scsih_issue_locked_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle,
>>                 goto out;
>>         }
>>
>> -       /* search for the command */
>> -       st = _scsih_scsi_lookup_find_by_scmd(ioc, scmd);
>> -       if (!st) {
>> +       /* check for completed command */
>> +       if (st->cb_idx == 0xFF); {
>
> ";" should be removed from above line, otherwise always we return task
> abort TM with "SUCCESS" status without issueing the TM to Firmware.
>
>
Ouch. Of course. Thanks for catching this.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
