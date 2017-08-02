From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: Re: [PATCH 32/47] scsi: Use scsi_target as argument for
 eh_target_reset_handler()
Date: Wed, 2 Aug 2017 18:52:53 +0200
Message-ID: <be04c937-67d9-a75e-b2b3-e32a54e5002e@linux.vnet.ibm.com>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
 <1498638793-44672-33-git-send-email-hare@suse.de>
 <e459fe23-44e8-1149-82b0-2eb794de65d0@linux.vnet.ibm.com>
 <ea13f9c2-7e68-fb29-3957-bbb3eb2cd091@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48238 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751172AbdHBQw7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Aug 2017 12:52:59 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v72GnHgt104337
        for <linux-scsi@vger.kernel.org>; Wed, 2 Aug 2017 12:52:58 -0400
Received: from e06smtp12.uk.ibm.com (e06smtp12.uk.ibm.com [195.75.94.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2c3fxwr734-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 02 Aug 2017 12:52:58 -0400
Received: from localhost
        by e06smtp12.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
        Wed, 2 Aug 2017 17:52:56 +0100
In-Reply-To: <ea13f9c2-7e68-fb29-3957-bbb3eb2cd091@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

just an intermediate update on storage processing of target reset...

On 07/25/2017 04:19 PM, Hannes Reinecke wrote:
> On 07/24/2017 08:10 PM, Steffen Maier wrote:
>> On 06/28/2017 10:32 AM, Hannes Reinecke wrote:
>>> The target reset function should only depend on the scsi target,
>>> not the scsi command.
>>>
>>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>>> ---
>>
>>>    drivers/s390/scsi/zfcp_scsi.c               | 20 ++++++++++--

>>>    33 files changed, 214 insertions(+), 174 deletions(-)
>>
>>> diff --git a/drivers/s390/scsi/zfcp_scsi.c
>>> b/drivers/s390/scsi/zfcp_scsi.c
>>> index dd7bea0..92a3902 100644
>>> --- a/drivers/s390/scsi/zfcp_scsi.c
>>> +++ b/drivers/s390/scsi/zfcp_scsi.c
>>> @@ -309,9 +309,25 @@ static int
>>> zfcp_scsi_eh_device_reset_handler(struct scsi_cmnd *scpnt)
>>>        return zfcp_task_mgmt_function(scpnt->device, FCP_TMF_LUN_RESET);
>>>    }
>>>
>>> -static int zfcp_scsi_eh_target_reset_handler(struct scsi_cmnd *scpnt)
>>> +/*
>>> + * Note: We need to select a LUN as the storage array doesn't
>>> + * necessarily supports LUN 0 and might refuse the target reset.
>>> + */
>>
>> Do you have any real experience with targets regarding this?
>>
>> Did you even try this and it failed?
>> If so, how did it fail?
>>
> Hehe.
> 
> Actually, it was _you_ (well, not you personally, but the zfcp
> maintainer at that time) who insisted on _not_ having to rely on LUN 0,
> as that LUN might not be available on non-NPIV setups.
> In the same vein he argued that we should be using the WLUN here.

Thanks a lot for letting me know!

>> It seems other drivers hardcode LUN 0 for target reset [see below].
>>
>> At least you made a similar loop to search for a suitable "victim"
>> scsi_device with some other driver changes below, so zfcp is not the
>> only one.
>>
>> In fact, this is one of my open questions in my own patch set:
>> Is the TMF flag in the FCP_CMND IU sufficient or does the transmission
>> path require a valid FCP_LUN also in the same IU even for a target reset.
>>
> Technically, you need an IT nexus for the target reset.
> As the SCSI target is somewhat under-represented in the linux SCSI stack
> typically it's easier to use a scsi device for this, and derive the IT
> nexus from there.
> And target reset is a tad tricky anyway; it got deprecated with later
> SCSI releases (SPC-3?), so chances is that it doesn't do anything.
> 
> (You could do yourself a favour and enquire with your friendly array
> vendors if _they_ support target reset; I have a strong feeling that
> they don't. In which case you might as well drop it completely, and
> target reset doing an IT nexus reset.)

# lsscsi
[0:0:0:1073758277]disk    IBM      2107900          .280  /dev/sdc
[0:0:0:1073823813]disk    IBM      2107900          .280  /dev/sda
[0:0:0:1073889349]disk    IBM      2107900          .280  /dev/sdb

With test code I made the following request run into a timeout:

# dd count=1 of=/dev/null if=/dev/sda iflag=direct

> [  633.459218] sd 0:0:0:1073823813: [sda] tag#0 Done: TIMEOUT_ERROR Result: hostbyte=DID_OK driverbyte=DRIVER_OK
> [  633.459267] sd 0:0:0:1073823813: [sda] tag#0 CDB: Read(10) 28 00 00 00 00 00 00 00 01 00
> [  633.459277] sd 0:0:0:1073823813: [sda] tag#0 abort scheduled
> [  633.479364] sd 0:0:0:1073823813: [sda] tag#0 aborting command
> [  633.479382] sd 0:0:0:1073823813: [sda] tag#0 cmd abort failed

More test code makes the abort fail (before even attempting it).

> [  633.479456] scsi host0: scsi_eh_0: waking up 0/1/1
> [  633.479483] scsi host0: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 1
> [  633.479492] scsi host0: Total of 1 commands on 1 devices require eh work
> [  633.479502] sd 0:0:0:1073823813: scsi_eh_0: Sending BDR
> [  633.479512] sd 0:0:0:1073823813: scsi_eh_0: BDR failed

More test code makes the LUN reset fail (before even attempting it).

> [  633.479519] scsi host0: scsi_eh_0: Sending target reset to target 0
> [  633.483654] sd 0:0:0:1073823813: [sda] tag#0 scsi_eh_done result: 2
> [  633.483729] sd 0:0:0:1073823813: [sda] tag#0 Done: SUCCESS Result: hostbyte=DID_OK driverbyte=DRIVER_OK
> [  633.483736] sd 0:0:0:1073823813: [sda] tag#0 CDB: Test Unit Ready 00 00 00 00 00 00
> [  633.483741] sd 0:0:0:1073823813: [sda] tag#0 Sense Key : Unit Attention [current] 
> [  633.483747] sd 0:0:0:1073823813: [sda] tag#0 Add. Sense: Power on, reset, or bus device reset occurred
> [  633.483753] sd 0:0:0:1073823813: [sda] tag#0 scsi_send_eh_cmnd timeleft: 1000
> [  633.483758] sd 0:0:0:1073823813: [sda] tag#0 scsi_send_eh_cmnd: scsi_eh_completed_normally 2001
> [  633.483764] sd 0:0:0:1073823813: [sda] tag#0 scsi_eh_tur return: 2001
> [  633.484074] sd 0:0:0:1073823813: [sda] tag#0 scsi_eh_done result: 0
> [  633.484093] sd 0:0:0:1073823813: [sda] tag#0 scsi_send_eh_cmnd timeleft: 1000
> [  633.484118] sd 0:0:0:1073823813: [sda] tag#0 scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
> [  633.484124] sd 0:0:0:1073823813: [sda] tag#0 scsi_eh_tur return: 2002
> [  633.484130] sd 0:0:0:1073823813: [sda] tag#0 scsi_eh_0: flush retry cmd
> [  633.484260] scsi host0: waking up host to restart
> [  633.484299] scsi host0: scsi_eh_0: sleeping

The target reset succeeds and scsi_eh finishes.

For the first I/O request to each of the other LUNs behind the same 
target port, I do get UA sense data:

> [  654.479419] sd 0:0:0:1073758277: [sdc] tag#0 Done: NEEDS_RETRY Result: hostbyte=DID_OK driverbyte=DRIVER_OK
> [  654.479429] sd 0:0:0:1073758277: [sdc] tag#0 CDB: Read(10) 28 00 00 00 00 00 00 00 01 00
> [  654.479434] sd 0:0:0:1073758277: [sdc] tag#0 Sense Key : Unit Attention [current] 
> [  654.479439] sd 0:0:0:1073758277: [sdc] tag#0 Add. Sense: Power on, reset, or bus device reset occurred
> [  660.112234] sd 0:0:0:1073889349: [sdb] tag#0 Done: NEEDS_RETRY Result: hostbyte=DID_OK driverbyte=DRIVER_OK
> [  660.112245] sd 0:0:0:1073889349: [sdb] tag#0 CDB: Read(10) 28 00 00 00 00 00 00 00 01 00
> [  660.112250] sd 0:0:0:1073889349: [sdb] tag#0 Sense Key : Unit Attention [current] 
> [  660.112256] sd 0:0:0:1073889349: [sdb] tag#0 Add. Sense: Power on, reset, or bus device reset occurred

 From this pending UA on the relevant scope, I conclude that DS8000 does 
handle target reset.
Therefore, I'd like to keep our eh handler code for the time being.

-- 
Mit freundlichen Grüßen / Kind regards
Steffen Maier

Linux on z Systems Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
