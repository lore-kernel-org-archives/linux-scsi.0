From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12207] block reads/writes > 122880 bytes to USB tape drive
 gives EBUSY
Date: Fri, 10 Apr 2009 09:48:46 GMT
Message-ID: <200904100948.n3A9mkiW002846@demeter.kernel.org>
References: <bug-12207-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:52194 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093AbZDJJsr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Apr 2009 05:48:47 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n3A9mkaQ002847
	for <linux-scsi@vger.kernel.org>; Fri, 10 Apr 2009 09:48:46 GMT
In-Reply-To: <bug-12207-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12207


oshida@bb-next.net changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |oshida@bb-next.net




--- Comment #27 from oshida@bb-next.net  2009-04-10 09:48:44 ---
Thanks for reading.

Please share that this is just for tape device.


> You'll have to trace this down by yourself.

Yes of course, but this is not a matter for me because I was satisfied with 4MB
limit.

#Via SAS interface, the block size limit for tape device is 4MB w/o any
configurations.
#It can be also one of the reason to apply the value for me.
##On Solaris 10, it is larger than 4MB and I've not found the limit.


> Where did your limit come from?

Just above experiments.
But 4MB (or twiced 8MB) is not my recommend. For reguralizing I hope you to
decide which is reasonable value.

Generally, there is no device which can operate the block size larger than
0xffffff bytes. This is from the SCSI tape device specification. (T10/SSC)


> Why do you want to do this?  The attribute is named "max_sectors", so 
> shouldn't it return the value of max_sectors?

I can agree your suggestion but then I need declaring the read only attribute
named "max_hw_sectors".

I don't know the restrictions arround scsi driver stacks, ex, what max_sectors
is used for and max_hw_sectors is used for. But by simple image, if a really
effective value can be set onto a variable, it should be verifiable by reading
same variable.


> Did you know that max_sectors can also be changed through the block 
> interface?

I'm sorry I did not. Thanks for teaching.
But I could not find the device (of course tape drive) under that tree. I think
that is just for kinds of block device which can be manipulated with T10/SBC
command set.


Sincerely,
Teruo Oshida

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
