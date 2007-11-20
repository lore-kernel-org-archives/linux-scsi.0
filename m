From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [Bugme-new] [Bug 9405] New: iSCSI does not implement ordering
 guarantees required by e.g. journaling filesystems
Date: Tue, 20 Nov 2007 18:04:43 +0300
Message-ID: <4742F78B.8010004@vlnb.net>
References: <bug-9405-10286@http.bugzilla.kernel.org/>	 <20071119125040.9f6eb1e2.akpm@linux-foundation.org>	 <1195505766.3963.1.camel@localhost.localdomain>	 <4741FE89.4020307@cs.wisc.edu> <1195507720.3963.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-01.mailcluster.net ([77.221.130.213]:56056 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754940AbXKTPE4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Nov 2007 10:04:56 -0500
In-Reply-To: <1195507720.3963.4.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, bugme-daemon@bugzilla.kernel.org, bart.vanassche@gmail.com

James Bottomley wrote:
>>>And please close this as invalid.  FS ordering guarantees in linux
>>>aren't done via ordered tags.
>>
>>I had a related question. I was working on the attached patch for soe 
>>other testing (patch made against scsi-rc-fixes, but is not stable so do 
>>not apply), which does the scsi_populate_tag_msg conversion from MSG_* 
>>to ISCSI_ATTR and sets the proper iscsi bits.
>>
>>If I do this patch where I call scsi_activate_tcq on a device and that 
>>concertsion, does this require that my driver not reorder commands? I 
>>was just a little worried on some of the error handling paths where we 
>>requeue commands to the mid layer.
> 
> Right, there's no way of guaranteeing that commands aren't reordered in
> the error path (or even the queue full submission path) which is why we
> don't use ordered tags to enforce barriers.

May I make your answer more precise? SCSI for non-caching and 
write-through caching devices provides a way to guarantee order of 
commands on the error path via ACA and UA_INTLCK facilities, if they are 
supported by device. For write-back caching devices it's different, 
because cache may reorder commands after they are reported as completed 
to the initiator as well as there is a possibility for deferred errors.

So, there is no way to guarantee commands order in case of errors, 
because Linux doesn't implement that.

BTW, there is still something wrong in the SCSI/block/FS layers error 
processing. Playing with my SCSI target I've noticed that if it returns 
pretty valid TASK ABORTED status for some SCSI command, FS on initiator 
(ext3) immediately gets corrupted and journal replay on remount doesn't 
repair it, only manual e2fsck helps. So, apparently:

1. SCSI ML handles well not all status codes, which it should.

2. Block/FS levels (sometimes) don't handle I/O errors well enough 
without corrupting file systems.

I don't have time for further investigations, but, if somebody prepare a 
patch to fix that, I'm willing to assist in testing.

Vlad
