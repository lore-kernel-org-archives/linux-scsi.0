From: Peter Fox <fox@roestock.demon.co.uk>
Subject: usb-scsi fails to report bad block correctly
Date: Fri, 12 Dec 2008 16:05:54 +0000
Message-ID: <20081212160554.GA22631@roestock.demon.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:48742 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758844AbYLLQqm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Dec 2008 11:46:42 -0500
Received: from roestock.demon.co.uk ([83.104.43.136])
	by anchor-post-3.mail.demon.net with esmtp (Exim 4.69)
	id 1LBAWY-0005N7-oR
	for linux-scsi@vger.kernel.org; Fri, 12 Dec 2008 16:05:54 +0000
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I've recently been having trouble using a failing disk drive in
usb-adaptors using kernels 2.6.26, 2.6.27 and 2.6.28-rc8.  The entire
saga is in gentoo bugs
<https://bugs.gentoo.org/show_bug.cgi?id=248698>,
<https://bugs.gentoo.org/show_bug.cgi?id=249936>, and
<https://bugs.gentoo.org/show_bug.cgi?id=249938>.

The problem is that one of my usb disk adaptors seems to report an
error then, when queried about it, denies everything.

Daniel Drake analysed my usbmod dumps, and this is what he said:

-------------------------------------------
for the "unknown" device:

get message 10, sector 3805344, len 2048
f48c13c0 28.169737 S Bo:1:013:2 - 31 = 55534243 21000000 00100000 80000a28
00003a10 a0000008 00000000 000000
f48c13c0 28.169771 C Bo:1:013:2 0 31 >
f4927d40 28.169804 S Bi:1:013:1 - 4096 <

short read with error -EREMOTEIO
f4927d40 30.687942 C Bi:1:013:1 -121 1026 = 48008126 00008226 00008326 00008426
00008526 00008626 00008726 00008826

get CSW
f48c13c0 30.687953 S Bi:1:013:1 - 13 <
residue and failure
f48c13c0 30.688439 C Bi:1:013:1 0 13 = 55534253 21000000 fe0b0000 01

request sense
f48c13c0 30.688444 S Bo:1:013:2 - 31 = 55534243 22000000 12000000 80000603
00000012 00000000 00000000 000000
f48c13c0 30.689439 C Bo:1:013:2 0 31 >
f4927d40 30.689444 S Bi:1:013:1 - 18 <

sense data: response 0x70, sense code 0, asc=0 ascq=0
f4927d40 30.690439 C Bi:1:013:1 0 18 = 70000000 0000000a 00000000 00000000 0000
f48c13c0 30.690443 S Bi:1:013:1 - 13 <
f48c13c0 30.690564 C Bi:1:013:1 0 13 = 55534253 22000000 00000000 00


Conclusion: the device transferred some data, but said that it was all
"residue" (meaning junk data) and reports an error. When the kernel tries to
retrieve the error information (sense data), it gets code 0:
"NO SENSE: Indicates that there is no specific sense key information to be
reported. This may occur for a successful command"

I don't know what to make of this. This is the behaviour you would expect for
when the device did not encounter a problem. But it only says "may" -- doesn't
imply that sense code 0 always means success.

I think this is potentially a bug, in that there was some evidence of error (in
the CSW), and dd should have failed the same way both times (which I'm
presuming it didn't?).

However, I also think your device is being a little less than compliant with
the scsi specs.

If you want to take this further, you should write to the
linux-scsi@vger.kernel.org mailing list (no subscription required, send email
in plain text). Include the annotations I made above. They will have more of a
clue than me.
-------------------------------------------

If the drive says the data is junk, shouldn't the kernel throw it away
immediately, and if the drive says it can't say what the error is simply
report some kind of IO error?

By covering over the error, I'm developing corrupted filesystems on these
disks.

-- 
Peter Fox

http://www.roestock.demon.co.uk/
fax: +44(0)870 0510209
