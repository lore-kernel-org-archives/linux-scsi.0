From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 111441] iscsi fails to attach to targets
Date: Tue, 02 Feb 2016 20:25:13 +0000
Message-ID: <bug-111441-11613-s9aXVvnpJC@https.bugzilla.kernel.org/>
References: <bug-111441-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:60519 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756492AbcBBUZR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Feb 2016 15:25:17 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 7531820218
	for <linux-scsi@vger.kernel.org>; Tue,  2 Feb 2016 20:25:16 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id E036C202BE
	for <linux-scsi@vger.kernel.org>; Tue,  2 Feb 2016 20:25:13 +0000 (UTC)
In-Reply-To: <bug-111441-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=111441

--- Comment #11 from Serguei Bezverkhi <sbezverk@cisco.com> ---
Sure thing, I will test it tonight and let you know the result.

Thank you

Serguei

-----Original Message-----
From: Mike Christie [mailto:michaelc@cs.wisc.edu] 
Sent: Tuesday, February 02, 2016 3:12 PM
To: Christoph Hellwig <hch@infradead.org>
Cc: Serguei Bezverkhi (sbezverk) <sbezverk@cisco.com>;
bugzilla-daemon@bugzilla.kernel.org; linux-scsi@vger.kernel.org; Hannes
Reinecke <hare@suse.de>
Subject: Re: [Bug 111441] New: iscsi fails to attach to targets

On 02/02/2016 12:09 PM, Christoph Hellwig wrote:
> On Fri, Jan 29, 2016 at 05:32:54PM -0600, Mike Christie wrote:
>> Hey Christoph and Hannes,
>>
>> The dh/alua changes that added this:
>>
>>         error = scsi_dh_add_device(sdev);
>>         if (error) {
>>                 sdev_printk(KERN_INFO, sdev,
>>                                 "failed to add device handler: %d\n", 
>> error);
>>                 return error;
>>         }
>>
>> to scsi_sysfs_add_sdev are adding a regression.
>>
>> 1. If that fails, then we forget to do device_del before doing the 
>> return. My patch in this thread added that back, so we do not see the 
>> sysfs oopses anymore. But.....
> 
> Ok.
> 
>> 2. It looks like in older kernels, we would allow misconfigured 
>> targets like this one to still setup devices. Do we want that old behavior back?
>> Should we just ignore the return value from scsi_dh_add_device above?
>> Note that in this case, it is LIO so it can be easily fixed on the 
>> target side by just setting it up properly. I do not think other 
>> targets would hit this type of issue.
> 
> Be liberal in what you accept..  I guess we need to continue allowing 
> to connect to these broken targets, but a warning would be useful.
> 
> Can you send a patch?

Serguei, can you try the attached patch? Drop the other one I sent.

-- 
You are receiving this mail because:
You are the assignee for the bug.
