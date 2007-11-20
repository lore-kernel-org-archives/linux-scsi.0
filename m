From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [Bugme-new] [Bug 9405] New: iSCSI does not implement ordering
 guarantees required by e.g. journaling filesystems
Date: Tue, 20 Nov 2007 19:15:41 +0300
Message-ID: <4743082D.7030302@vlnb.net>
References: <bug-9405-10286@http.bugzilla.kernel.org/>	 <20071119125040.9f6eb1e2.akpm@linux-foundation.org>	 <1195505766.3963.1.camel@localhost.localdomain>	 <4741FE89.4020307@cs.wisc.edu>	 <1195507720.3963.4.camel@localhost.localdomain> <4742F78B.8010004@vlnb.net> <1195572482.3131.28.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-01.mailcluster.net ([77.221.130.213]:42511 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758665AbXKTQP6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Nov 2007 11:15:58 -0500
In-Reply-To: <1195572482.3131.28.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, bugme-daemon@bugzilla.kernel.org, bart.vanassche@gmail.com

James Bottomley wrote:
> On Tue, 2007-11-20 at 18:04 +0300, Vladislav Bolkhovitin wrote:
> 
>>James Bottomley wrote:
>>
>>>>>And please close this as invalid.  FS ordering guarantees in linux
>>>>>aren't done via ordered tags.
>>>>
>>>>I had a related question. I was working on the attached patch for soe 
>>>>other testing (patch made against scsi-rc-fixes, but is not stable so do 
>>>>not apply), which does the scsi_populate_tag_msg conversion from MSG_* 
>>>>to ISCSI_ATTR and sets the proper iscsi bits.
>>>>
>>>>If I do this patch where I call scsi_activate_tcq on a device and that 
>>>>concertsion, does this require that my driver not reorder commands? I 
>>>>was just a little worried on some of the error handling paths where we 
>>>>requeue commands to the mid layer.
>>>
>>>Right, there's no way of guaranteeing that commands aren't reordered in
>>>the error path (or even the queue full submission path) which is why we
>>>don't use ordered tags to enforce barriers.
>>
>>May I make your answer more precise? SCSI for non-caching and 
>>write-through caching devices provides a way to guarantee order of 
>>commands on the error path via ACA and UA_INTLCK facilities, if they are 
>>supported by device. For write-back caching devices it's different, 
>>because cache may reorder commands after they are reported as completed 
>>to the initiator as well as there is a possibility for deferred errors.
> 
> Yes, I know this.  The problem is that because we can't rely on the
> ordering guarantees in *every* situation, it's unsafe to rely on them
> for barrier support (the case you most need them is the one where the
> guarantees have likely failed).  Thus, linux fs on SCSI implement
> barriers by waiting for completions.  The only case we could implement
> flush barriers in SCSI, as they do in IDE is in the single outstanding
> command case where we don't have any reordering to worry about (i.e.
> queue depth of one).

...if we are going to work only with devices with write-back cache only 
or not supporting ACA/UA_INTLCK facilities. It might be well possible 
that some hypothetic SCSI device with write-through cache (WCE bit is 0 
or set to 0), ACA/UA_INTLCK and ORDERED commands support would perform 
considerebly better with barriers by ORDERED tags, than with barriers by 
waiting for completions and write-back cache, especially for file 
systems like XFS, because with barriers by ORDERED tags it is possible 
to keep SCSI tarnsport wire pipe full, where it has to be drained with 
barriers by waiting for completions. But, since AFAIK the majority of 
SCSI disks don't support ACA/UA_INTLCK, I have to agree with you, there 
is not much point currently to implement barriers by ORDERED tags in the 
SCSI ML.

>>So, there is no way to guarantee commands order in case of errors, 
>>because Linux doesn't implement that.
>>
>>BTW, there is still something wrong in the SCSI/block/FS layers error 
>>processing. Playing with my SCSI target I've noticed that if it returns 
>>pretty valid TASK ABORTED status for some SCSI command, FS on initiator 
>>(ext3) immediately gets corrupted and journal replay on remount doesn't 
>>repair it, only manual e2fsck helps. So, apparently:
>>
>>1. SCSI ML handles well not all status codes, which it should.
> 
> 
> It certainly handles TASK ABORTED.
> 
> 
>>2. Block/FS levels (sometimes) don't handle I/O errors well enough 
>>without corrupting file systems.
> 
> 
> I'm not sure your conclusions necessarily follow your data.  What was
> the reason for the TASK ABORTED (I'd guess QErr settings, right)?

It was my desire/curiosity during tests of SCST (http://scst.sf.net), 
when it working with several initiators with different transports over 
the same set of devices, each of them having with TAS bit in the control 
mode page set. According to SAM, in this case TASK ABORTED status can be 
returned at any time, similarly to QUEUE FULL, i.e. IMHO such command 
just should be retried. But QUEUE FULL status handled well, but TASK 
ABORTED leads to filesystem corruption.

> Journals can fail to recover in cases where the underlying medium is
> corrupted.  If TASK ABORTED was because of QErr, what was the original
> failure?

See above. No "medium" corruption happened.

> Also, what was going on in the system (and what device was this ...
> iSCSI I guess) ...

It doesn't matter. It happens with FC transport as well.

> I assume nothing powered down, so it's not a caching
> problem (and that, since you seem to be using TCQ you do have your
> caches set to write through).

The target stays pretty well and healthy.

>>I don't have time for further investigations, but, if somebody prepare a 
>>patch to fix that, I'm willing to assist in testing.
> 
> We'll need a bit more data to identify an actual root cause for this
> problem before anyone can prepare a patch to fix it.
> 
> James
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

