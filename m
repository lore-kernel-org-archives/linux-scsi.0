From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12207] block reads/writes > 122880 bytes to USB tape drive
 gives EBUSY
Date: Thu, 9 Apr 2009 21:08:17 GMT
Message-ID: <200904092108.n39L8He4011331@demeter.kernel.org>
References: <bug-12207-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:58557 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764829AbZDIVIT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Apr 2009 17:08:19 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n39L8H4s011332
	for <linux-scsi@vger.kernel.org>; Thu, 9 Apr 2009 21:08:17 GMT
In-Reply-To: <bug-12207-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12207





--- Comment #26 from Alan Stern <stern@rowland.harvard.edu>  2009-04-09 21:08:16 ---
On Tue, 7 Apr 2009 bugzilla-daemon@bugzilla.kernel.org wrote:

> Now I attached another patch including more features;
> 
> - returning max_hw_sectors for reading max_sectors

Why do you want to do this?  The attribute is named "max_sectors", so 
shouldn't it return the value of max_sectors?

> - to limit max_sectors by the special value for usb storage

Where did your limit come from?  I agree, the value should be limited, 
but the limit should be 4 GB - 1.  Not 8 MB.

> I think these features are required.
> Of course they are useful for me, I may run my code on many versions of kernel
> so max_sectors should be checkable and changeable at anytime.

Did you know that max_sectors can also be changed through the block 
interface?  For example, under /sys/block/sda/queue/ you can write to 
max_sectors_kb and you can read max_hw_sectors_kb.

> For addition, my PC can send/recv 4MB block but with 8MB ioctl() will report
> ENOMEM. Usually the PC is running with 1GB RAM and increasing RAM is not
> effective.

You'll have to trace this down by yourself.

Alan Stern

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
