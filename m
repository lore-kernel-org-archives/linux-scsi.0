From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 32/47] scsi: Use scsi_target as argument for
 eh_target_reset_handler()
Date: Tue, 25 Jul 2017 16:19:38 +0200
Message-ID: <ea13f9c2-7e68-fb29-3957-bbb3eb2cd091@suse.de>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
 <1498638793-44672-33-git-send-email-hare@suse.de>
 <e459fe23-44e8-1149-82b0-2eb794de65d0@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60330 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751812AbdGYOTo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Jul 2017 10:19:44 -0400
In-Reply-To: <e459fe23-44e8-1149-82b0-2eb794de65d0@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>, Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 07/24/2017 08:10 PM, Steffen Maier wrote:
> 
> On 06/28/2017 10:32 AM, Hannes Reinecke wrote:
>> The target reset function should only depend on the scsi target,
>> not the scsi command.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>> ---
> 
>>   drivers/s390/scsi/zfcp_scsi.c               | 20 ++++++++++--
> 
>>   drivers/scsi/scsi_debug.c                   | 21 ++++---------
>>   drivers/scsi/scsi_error.c                   |  5 +--
> 
>>   include/scsi/scsi_host.h                    |  2 +-
> 
>>   33 files changed, 214 insertions(+), 174 deletions(-)
> 
>> diff --git a/drivers/s390/scsi/zfcp_scsi.c
>> b/drivers/s390/scsi/zfcp_scsi.c
>> index dd7bea0..92a3902 100644
>> --- a/drivers/s390/scsi/zfcp_scsi.c
>> +++ b/drivers/s390/scsi/zfcp_scsi.c
>> @@ -309,9 +309,25 @@ static int
>> zfcp_scsi_eh_device_reset_handler(struct scsi_cmnd *scpnt)
>>       return zfcp_task_mgmt_function(scpnt->device, FCP_TMF_LUN_RESET);
>>   }
>>
>> -static int zfcp_scsi_eh_target_reset_handler(struct scsi_cmnd *scpnt)
>> +/*
>> + * Note: We need to select a LUN as the storage array doesn't
>> + * necessarily supports LUN 0 and might refuse the target reset.
>> + */
> 
> Do you have any real experience with targets regarding this?
> 
> Did you even try this and it failed?
> If so, how did it fail?
> 
Hehe.

Actually, it was _you_ (well, not you personally, but the zfcp
maintainer at that time) who insisted on _not_ having to rely on LUN 0,
as that LUN might not be available on non-NPIV setups.
In the same vein he argued that we should be using the WLUN here.

> It seems other drivers hardcode LUN 0 for target reset [see below].
> 
> At least you made a similar loop to search for a suitable "victim"
> scsi_device with some other driver changes below, so zfcp is not the
> only one.
> 
> In fact, this is one of my open questions in my own patch set:
> Is the TMF flag in the FCP_CMND IU sufficient or does the transmission
> path require a valid FCP_LUN also in the same IU even for a target reset.
> 
Technically, you need an IT nexus for the target reset.
As the SCSI target is somewhat under-represented in the linux SCSI stack
typically it's easier to use a scsi device for this, and derive the IT
nexus from there.
And target reset is a tad tricky anyway; it got deprecated with later
SCSI releases (SPC-3?), so chances is that it doesn't do anything.

(You could do yourself a favour and enquire with your friendly array
vendors if _they_ support target reset; I have a strong feeling that
they don't. In which case you might as well drop it completely, and
target reset doing an IT nexus reset.)

>> +static int zfcp_scsi_eh_target_reset_handler(struct scsi_target
>> *starget)
>>   {
>> -    return zfcp_task_mgmt_function(scpnt->device, FCP_TMF_TGT_RESET);
>> +    struct fc_rport *rport = starget_to_rport(starget);
>> +    struct Scsi_Host *shost = rport_to_shost(rport);
>> +    struct scsi_device *sdev = NULL, *tmp_sdev;
>> +
> 
> In "[PATCH 09/47] zfcp: open-code fc_block_scsi_eh() for host reset" you
> introduced a shost lock, but here you did not?
> 
> Does the midlayer already hold an shost lock when calling any of these
> eh callbacks?
> 
Yes.

> Not sure if that's the corresponding part of
> Documentation/scsi/scsi_eh.txt (but even if, I don't understand who's
> supposed to have the shost lock):
>> [2-1-2] Flow of scmds through EH
>>  2. EH starts
>>     ACTION: move all scmds to EH's local eh_work_q.  shost->eh_cmd_q
>>         is cleared.
>>     LOCKING: shost->host_lock (not strictly necessary, just for
>>              consistency)
>> [2-2-3] Things to consider
>>  - For consistency, when accessing/modifying shost data structure,
>>    grab shost->host_lock.
> 
> 
>> +    shost_for_each_device(tmp_sdev, shost) {
>> +        if (tmp_sdev->id == starget->id) {
>> +            sdev = tmp_sdev;
>> +            break;
>> +        }
>> +    }
>> +    if (!sdev)
>> +        return FAILED;
>> +    return zfcp_task_mgmt_function(sdev, FCP_TMF_TGT_RESET);
>>   }
> 
> Ah, this "solves" the problem of needing a scsi_device even though we
> only get scsi_target as scope argument.
> 
>> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c
>> b/drivers/scsi/lpfc/lpfc_scsi.c
>> index 107c0f6..573bd43 100644
>> --- a/drivers/scsi/lpfc/lpfc_scsi.c
>> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
>> @@ -5226,16 +5226,16 @@ void lpfc_poll_timeout(unsigned long ptr)
>>    *  0x2002 - Success
>>    **/
>>   static int
>> -lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
>> +lpfc_target_reset_handler(struct scsi_target *starget)
>>   {
>> -    struct Scsi_Host  *shost = cmnd->device->host;
>> +    struct fc_rport *rport = starget_to_rport(starget);
>> +    struct Scsi_Host  *shost = rport_to_shost(rport);
>>       struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
>>       struct lpfc_rport_data *rdata;
>>       struct lpfc_nodelist *pnode;
>> -    unsigned tgt_id = cmnd->device->id;
>> -    uint64_t lun_id = cmnd->device->lun;
>> +    unsigned tgt_id = starget->id;
>> +    uint64_t lun_id = 0;
> 
> 
> 
>> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>> b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>> index f990ab4d..db40ddf 100644
>> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> 
>> @@ -4038,42 +4040,43 @@ int megasas_reset_target_fusion(struct
>> scsi_cmnd *scmd)
> 
>> +    shost_for_each_device(sdev, shost) {
>> +        if (!sdev->hostdata)
>> +            continue;
>> +        mr_device_priv_data = sdev->hostdata;
>> +        if (mr_device_priv_data->is_tm_capable) {
>> +            devhandle = megasas_get_tm_devhandle(sdev);
>> +            break;
>> +        }
>> +    }
>> +
> 
>> -    devhandle = megasas_get_tm_devhandle(scmd->device);
> 
>>       ret = megasas_issue_tm(instance, devhandle,
>> -            scmd->device->channel, scmd->device->id, 0,
>> +            starget->channel, starget->id, 0,
>>               MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET);
> 
> The called function seems to internally have hardcoded LUN 0:
> 
> static int
> megasas_issue_tm(struct megasas_instance *instance, u16 device_handle,
>     uint channel, uint id, u16 smid_task, u8 type)
> {
> ...
>     mpi_request->LUN[1] = 0;
> 
Indeed. But that's megaraid_sas specific; other drivers have different
requirements here.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
