From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16058] [BUG] Cannot boot any kernel from 2.6.27 on if a 256
 byte sector SCSI disk is attached
Date: Thu, 27 May 2010 22:05:46 GMT
Message-ID: <201005272205.o4RM5kkF018411@demeter.kernel.org>
References: <bug-16058-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:49629 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932811Ab0E0WFr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 May 2010 18:05:47 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o4RM5koI018412
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 27 May 2010 22:05:46 GMT
In-Reply-To: <bug-16058-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=16058





--- Comment #3 from Mark Hounschell <markh@compro.net>  2010-05-27 22:05:35 ---
On 05/27/2010 04:30 PM, Alan Stern wrote:
> On Thu, 27 May 2010, Andrew Morton wrote:
> 
>> https://bugzilla.kernel.org/show_bug.cgi?id=16058
>>
>>            Summary: [BUG] Cannot boot any kernel from 2.6.27 on if a 256
>>                     byte sector SCSI disk is attached
> 
>> As of 2.6.27 if any SCSI disk is attached that has been formatted with a 256
>> byte sector size, the boot process hangs. 512, 768, and 1024 byte sector disks
>> do not seem to trigger this. The disks in use do NOT have a partition table.
>> They are being used by out applications via the sg_io interface only.
>>
>> A 2.6.26.8 kernel works fine. 
>>
>> I have bisected this problem to the following commit:
>>
>> # git bisect good
>> 427e59f09fdba387547106de7bab980b7fff77be is first bad commit
>> commit 427e59f09fdba387547106de7bab980b7fff77be
>> Author: James Bottomley <James.Bottomley@HansenPartnership.com>
>> Date:   Sat Mar 8 18:24:17 2008 -0600
>>
>>     [SCSI] make use of the residue value
>>
>>     USB sometimes doesn't return an error but instead returns a residue
>>     value indicating part (or all) of the command wasn't completed.  So if
>>     the driver _done() error processing indicates the command was fully
>>     processed, subtract off the residue so that this USB error gets
>>     propagated.
>>
>>     Cc: Alan Stern <stern@rowland.harvard.edu>
>>     Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
>>
>> :040000 040000 d3bad84ebe1bc231e8e7d6267907ca62fd4d0dcd
>> c85f8cb8bd4910724f0101e41054555980727e16 M      drivers
>>
>> Now, what USB has to do with my SCSI disks is beyond me. I have a
>> feeling that this commit is just uncovering another problem. I've attached
>> a bootlog from a serial console that ends where the boot hangs.
>>
>> The does the same thing on a 2.6.34 kernel. Anything I can do to help, I'm
>> available.
> 
> I'd guess that this has nothing to do with the sector size.  Instead
> the drive probably reports a non-zero residue when it shouldn't.  Can
> you add some debugging printk's to the patch to find out in more detail
> what's going wrong?
> 
> Alan Stern
> 
> 

Yes, I can. But first let me ask, since reverting this patch on at least
2.6.32 - 2.6.34 does not help, would it possibly be better if I did a
little more work to find out where it stops working with the above patch
reverted or not?

Mark

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
