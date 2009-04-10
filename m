From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12207] block reads/writes > 122880 bytes to USB tape drive
 gives EBUSY
Date: Fri, 10 Apr 2009 15:19:24 GMT
Message-ID: <200904101519.n3AFJOij032488@demeter.kernel.org>
References: <bug-12207-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:48011 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764868AbZDJPTZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Apr 2009 11:19:25 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n3AFJOd6032489
	for <linux-scsi@vger.kernel.org>; Fri, 10 Apr 2009 15:19:24 GMT
In-Reply-To: <bug-12207-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12207





--- Comment #28 from Alan Stern <stern@rowland.harvard.edu>  2009-04-10 15:19:23 ---
On Fri, 10 Apr 2009 bugzilla-daemon@bugzilla.kernel.org wrote:

> --- Comment #27 from oshida@bb-next.net  2009-04-10 09:48:44 ---
> Thanks for reading.
> 
> Please share that this is just for tape device.

Your patch affects the max_sectors attribute file for all devices, not 
just for tape devices.

> > Where did your limit come from?
> 
> Just above experiments.
> But 4MB (or twiced 8MB) is not my recommend. For reguralizing I hope you to
> decide which is reasonable value.
> 
> Generally, there is no device which can operate the block size larger than
> 0xffffff bytes. This is from the SCSI tape device specification. (T10/SSC)

So there is no _tape_ device which can operate with larger block size.  
But maybe a non-tape device can.

Besides, the block size isn't the same as max_sectors.  max_sectors is 
allowed to be larger than the block size (but it mustn't be smaller).

> > Why do you want to do this?  The attribute is named "max_sectors", so 
> > shouldn't it return the value of max_sectors?
> 
> I can agree your suggestion but then I need declaring the read only attribute
> named "max_hw_sectors".

Why?

> I don't know the restrictions arround scsi driver stacks, ex, what max_sectors
> is used for and max_hw_sectors is used for. But by simple image, if a really
> effective value can be set onto a variable, it should be verifiable by reading
> same variable.

max_hw_sectors is supposed to be the largest transfer size supported by 
the hardware.  max_sectors is supposed to be the largest transfer size 
the kernel will use.  Therefore we should always have max_sectors <= 
max_hw_sectors.

With USB mass-storage devices this is difficult, because the driver 
doesn't know what transfer sizes are supported by the hardware.  The 
USB protocol doesn't provide this information.

> > Did you know that max_sectors can also be changed through the block 
> > interface?
> 
> I'm sorry I did not. Thanks for teaching.
> But I could not find the device (of course tape drive) under that tree. I think
> that is just for kinds of block device which can be manipulated with T10/SBC
> command set.

No, it is for all block devices.  If you can't find your device under 
/sys/block/ then look for it somewhere else, such as under 
/sys/bus/scsi/devices/.

Alan Stern

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
