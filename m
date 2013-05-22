From: James Smart <James.Smart@emulex.com>
Subject: Re: [PATCH 0/5] scsi: Allow fast io fail without waiting through
 timeout
Date: Wed, 22 May 2013 14:04:45 -0400
Message-ID: <519D08BD.9080103@emulex.com>
References: <1369034103-31644-1-git-send-email-renmx@cn.fujitsu.com> <519A4716.7000001@emulex.com> <519C6FD6.4090607@cn.fujitsu.com>
Reply-To: <James.Smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <519C6FD6.4090607@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ren Mingxin <renmx@cn.fujitsu.com>
Cc: James.Bottomley@HansenPartnership.com, Nagalakshmi.Nandigama@lsi.com, Sreekanth.Reddy@lsi.com, michaelc@cs.wisc.edu, robert.w.love@intel.com, dgilbert@interlog.com, hare@suse.de, bprakash@broadcom.com, agk@redhat.com, neilb@suse.de, gregkh@linuxfoundation.org, axboe@kernel.dk, tj@kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

yes - that was the session. Granted the posted notes were rather terse.

More of the ideas were presented in this recent email thread: 
http://marc.info/?l=linux-scsi&m=136819142000596&w=2

In general - we're going to create a LLD library for error handling, 
using paradigms in libsas, that:
- no longer stops the whole host on the 1st error and doesn't start 
error handling till all outstanding io is finished/timedout
- sends per-io aborts immediately, and in parallel. LLD handlers will be 
asynchronous.
- no lun/target will be stopped until i/o aborts start to fail.
- do smart handling of lun resets, target resets, bus resets, etc and 
don't potentially do it for every i/o.

Several of these topics were touched on in the email thread.

the patches are being worked on now - hopefully to be posted as an RFC 
within the next couple of weeks.

-- james s



On 5/22/2013 3:12 AM, Ren Mingxin wrote:
> Hi, James,
>
> On 05/20/2013 11:53 PM, James Smart wrote:
>> Based on the discussion recently held at LSF 2013, we are
>> reworking the error recovery path to address all the issues
>> you are mentioning. That work contradicts these patches.
>> So for now, these should be held off.
>
> Interesting. Can I have your general goal/idea briefly even
> though via a reference? Will the URL below be one you will
> refer to?
>   http://lwn.net/Articles/548500
>
> And, could I know your current progress/schedule? Especially
> when can we see your patches?
>
> Much appreciated!
>
> Thanks,
> Ren
>
>>
>> On 5/20/2013 3:14 AM, Ren Mingxin wrote:
>>> When there is a scsi command timed-out or failed, the scsi eh
>>> tries a thorugh recovery, which is necessary for non-redundant
>>> systems. However, the thorugh recovery usually takes much time,
>>> which is not acceptable for misson critical systems. To improve
>>> this latency, if we are working on a redundant system, we should
>>> avoid the scsi eh for its long time failing recovery, and quick
>>> failover to another path.
>>>
>>> This set of patches is trying to implement above.
>>>
>>> NOTE: the userland tools need to eusure the environment
>>> restriction, which will be implemented later.
>>>
>>> Thanks,
>>> Ren
>>>
>>> Ren Mingxin (5):
>>>    scsi: rename return code FAST_IO_FAIL to FAST_IO
>>>    FC transport: Add interface to specify fast io level for 
>>> timed-out cmds
>>>    SAS transport: Add interface to specify fast io level for 
>>> timed-out cmds
>>>    lpfc: Allow fast timed-out io recovery
>>>    mptfusion: Allow fast timed-out io recovery
>>>
>>>   drivers/message/fusion/mptscsih.c   |   29 ++++++++-
>>>   drivers/scsi/lpfc/lpfc_scsi.c       |   34 ++++++++++
>>>   drivers/scsi/scsi_error.c           |   18 ++---
>>>   drivers/scsi/scsi_sas_internal.h    |    4 -
>>>   drivers/scsi/scsi_transport_fc.c    |  112 
>>> ++++++++++++++++++++++++++++++++++--
>>>   drivers/scsi/scsi_transport_iscsi.c |    6 -
>>>   drivers/scsi/scsi_transport_sas.c   |  103 
>>> ++++++++++++++++++++++++++++++++-
>>>   include/scsi/scsi.h                 |    2
>>>   include/scsi/scsi_transport_fc.h    |   11 +++
>>>   include/scsi/scsi_transport_sas.h   |    8 ++
>>>   10 files changed, 303 insertions(+), 24 deletions(-)
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
