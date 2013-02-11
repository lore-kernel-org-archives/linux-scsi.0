From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v8 0/10] More device removal fixes
Date: Mon, 11 Feb 2013 21:36:44 +0100
Message-ID: <5119565C.1050701@acm.org>
References: <5110FE98.8030209@acm.org> <alpine.DEB.2.02.1302061727030.11804@jlaw-desktop.mno.stratus.com> <5113910D.2060100@acm.org> <alpine.DEB.2.02.1302081813170.13267@jlaw-desktop.mno.stratus.com> <511616A9.7040904@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:51497 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759394Ab3BKUgs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Feb 2013 15:36:48 -0500
In-Reply-To: <511616A9.7040904@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: Joe Lawrence <Joe.Lawrence@stratus.com>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, David Milburn <dmilburn@redhat.com>

On 02/09/13 10:28, Bart Van Assche wrote:
> On 02/09/13 00:29, Joe Lawrence wrote:
>> I haven't had time to rerun the test without the two patches that wait in
>> scsi_remove_host(), however I did rerun the test and verify the same
>> behavior as in my earlier mail.  I didn't see any __scsi_remove_device()
>> instances running.
>>
>> Some more investigation revealed that MD RAID was holding a reference to
>> the removed device.  (In short, mdadm --remove had failed and left the
>> device as a faulty member of the array.)  When I did finally manage to
>> kick that disk from the MD device, scsi host/device removal continued to
>> completion as expected.
>>
>> There's a bit more context to the MD situation that I'll post to the raid
>> list once I get the details together for Neil.  I will CC you if you are
>> interested in following.
>
> The loop in scsi_remove_host() waits too long. It should stop waiting as
> soon as the blk_cleanup_queue() calls for all sdev's have finished
> instead of waiting until all sdev users have closed these sdev's. I will
> repost patches 07/10 and 08/10.

(replying to my own e-mail)

Hello Joe,

It would be appreciated if you could repeat your test with this kernel 
tree (tested with iSCSI and SRP): 
http://github.com/bvanassche/linux/tree/device-removal-fixes. If that 
test succeed I will repost the patches in that tree.

Thanks,

Bart.
