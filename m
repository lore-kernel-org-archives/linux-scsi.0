From: Dominic Driver <dominic.driver@paragon.co.nz>
Subject: SCSI Driver Regression and Missing Code Block?
Date: Wed, 22 Apr 2009 12:50:06 +1200 (NZST)
Message-ID: <5313655.7301240361406269.JavaMail.root@mail.paragon.co.nz>
References: <30274704.7281240360796458.JavaMail.root@mail.paragon.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mxrelay1.xtreme.net.nz ([203.171.32.73]:3797 "EHLO
	mxrelay1.xtreme.net.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbZDVBKT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Apr 2009 21:10:19 -0400
Received: from mail.paragon.co.nz ([203.171.42.7])
	by mxrelay1.xtreme.net.nz (mxrelay1.xtreme.net.nz [203.171.32.73])
	(MDaemon PRO v10.0.5)
	with ESMTP id md50006703204.msg
	for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2009 12:50:00 +1200
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.paragon.co.nz (Postfix) with ESMTP id D2B11137DDA
	for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2009 12:50:09 +1200 (NZST)
Received: from mail.paragon.co.nz ([127.0.0.1])
	by localhost (mail.paragon.co.nz [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id M92W3sZyV3Sc for <linux-scsi@vger.kernel.org>;
	Wed, 22 Apr 2009 12:50:06 +1200 (NZST)
Received: from mail.paragon.co.nz (mail.paragon.co.nz [192.168.2.7])
	by mail.paragon.co.nz (Postfix) with ESMTP id 84AC8137DC2
	for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2009 12:50:06 +1200 (NZST)
In-Reply-To: <30274704.7281240360796458.JavaMail.root@mail.paragon.co.nz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi Guys,

I had an interesting experience with my SATA DVD-RW Drives following a Kernel Upgrade from:

2.6.27.19-170.2.35.fc10.i686
to 
2.6.28.6 (Vanilla)

I had been previously using a Fedora 10 release, but required the 2.6.28 kernel in order to update the driver for my onboard Intel Graphics chip (apparently some modules required for this process had been moved into the kernel from 27->28). This was required to fix an issue which was preventing correct functionality of a C++ application I'm working on. This C++ application also has a heavy bias on DVD-ROM burning, and this is where my two problems lie.

Rebuilding went smoothly, and the 2.6.28.6 kernel ran as expected in all but 2 areas:
1) When reading from the disc in a DVD-RW Drive, The return values of the IOCTL Call CDROM_DRIVE_STATUS were not the same as the previous kernel values.

2) Maximum burning speed of the drive seems to be very slow; averaging 2.2X instead of the previous 10+X.

I rooted around in the source code to fix issue 1), and found the following code was completely omitted from the function

int sr_drive_status(struct cdrom_device_info *cdi, int slot)

in the file 

sr_ioctl.c:

	/* SK/ASC/ASCQ of 2/4/1 means "unit is becoming ready" */
	if (scsi_sense_valid(&sshdr) && sshdr.sense_key == NOT_READY
			&& sshdr.asc == 0x04 && sshdr.ascq == 0x01)
		return CDS_DRIVE_NOT_READY;

My Question is: Is this an intentional change, or an accidental omission? It's pretty weird to have a whole chunk like that missing from a function without a comment. I've had to manually replace this bit of code to regain the functionality I had in the 2.6.27 kernel. This is the only change I had to make, which is even stranger. How come it's different in 2.6.28.6?



Regarding issue 2) - I haven't found a solution to this yet. I've used various tools to check the speed of the drive, and it's set at maximum 16.4X. Using Growisofs to burn the DVDs also displays that the application is attempting to burn at 16.4X, but in reality it only averages 2.2X. This is a major issue for my application, as burn times are absolutely critical. 

If I boot my Linux machine using the previous kernel (2.6.27...) I get the maximum burn speeds back. Something has definitely changed in upgrading kernels. I even used the 2.6.27 config file when building the 2.6.28 kernel, so I know all the settings are the same. 

Have there been any fundamental changes in the SCSI driver from 2.6.27-19 to 2.6.28.6? how can I get my top burn speeds back?

Thanks in advance for any help or pointers you can give me. I've trawled the net, but the only posts I have found are for IDE drives, and the top solution is to fiddle with uDMA settings - obviously not an option here.

Best regards,
-- 
Dominic Driver
Engineer
Paragon Electronic Design Limited
Level 2 21-23 Andrews Avenue
ANZ House
PO Box 30-449, Lower Hutt
New Zealand

Direct: +64 4 5703892
Fax: +64 4 5703 871
mailto:dominic.driver@paragon.co.nz
http://www.paragon.co.nz

