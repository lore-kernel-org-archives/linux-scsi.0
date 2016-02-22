From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 111441] iscsi fails to attach to targets
Date: Mon, 22 Feb 2016 07:08:26 +0000
Message-ID: <bug-111441-11613-W2CriLaZeS@https.bugzilla.kernel.org/>
References: <bug-111441-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52342 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753323AbcBVHIa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Feb 2016 02:08:30 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 922052039E
	for <linux-scsi@vger.kernel.org>; Mon, 22 Feb 2016 07:08:29 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id A8B32203AC
	for <linux-scsi@vger.kernel.org>; Mon, 22 Feb 2016 07:08:26 +0000 (UTC)
In-Reply-To: <bug-111441-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=111441

--- Comment #17 from Hannes Reinecke <hare@suse.de> ---
On 02/22/2016 01:45 AM, Serguei Bezverkhi (sbezverk) wrote:
> Hi Mike,
> 
> I just wanted to follow up with you to see if the patch got committed to an upstream kernel if yes, please let me into which version it went.
> 
> Thank you
> 
> Serguei
> 
> 
> Serguei Bezverkhi,
> TECHNICAL LEADER.SERVICES
> Global SP Services
> sbezverk@cisco.com
> Phone: +1 416 306 7312
> Mobile: +1 514 234 7374
> 
> CCIE (R&S,SP,Sec) - #9527
> 
> Cisco.com
> 
> 
> 
>  Think before you print.
> This email may contain confidential and privileged material for the sole use of the intended recipient. Any review, use, distribution or disclosure by others is strictly prohibited. If you are not the intended recipient (or authorized to receive for the recipient), please contact the sender by reply email and delete all copies of this message.
> Please click here for Company Registration Information.
> 
> 
> 
> -----Original Message-----
> From: Mike Christie [mailto:michaelc@cs.wisc.edu] 
> Sent: Friday, January 29, 2016 6:33 PM
> To: Serguei Bezverkhi (sbezverk) <sbezverk@cisco.com>
> Cc: bugzilla-daemon@bugzilla.kernel.org; linux-scsi@vger.kernel.org; Christoph Hellwig <hch@infradead.org>; Hannes Reinecke <hare@suse.de>
> Subject: Re: [Bug 111441] New: iscsi fails to attach to targets
> 
> On 01/29/2016 04:21 PM, Serguei Bezverkhi (sbezverk) wrote:
>> HI Mike,
>>
>> I tried your patch and it is has eliminated first traceback but I still do not see my remote targets.
>>
> 
> That is sort of expected. Your target is not setup for ALUA properly. It says it supports ALUA, but when scsi_dh_alua asks about the ports it is reporting there are none. Ccing the people that made the patch that added the issue and own the code.
> 
> Hey Christoph and Hannes,
> 
> The dh/alua changes that added this:
> 
>         error = scsi_dh_add_device(sdev);
>         if (error) {
>                 sdev_printk(KERN_INFO, sdev,
>                                 "failed to add device handler: %d\n", error);
>                 return error;
>         }
> 
> to scsi_sysfs_add_sdev are adding a regression.
> 
> 1. If that fails, then we forget to do device_del before doing the return. My patch in this thread added that back, so we do not see the sysfs oopses anymore. But.....
> 
> 2. It looks like in older kernels, we would allow misconfigured targets like this one to still setup devices. Do we want that old behavior back?
> Should we just ignore the return value from scsi_dh_add_device above?
> Note that in this case, it is LIO so it can be easily fixed on the target side by just setting it up properly. I do not think other targets would hit this type of issue.
> 
> 
This has been fixed up with my patchset to update the ALUA handler, most
notably the commit 'scsi: ignore errors from scsi_dh_add_device()' which
was included in 4.5.

Cheers,

Hannes

-- 
You are receiving this mail because:
You are the assignee for the bug.
