From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [regression/bisected] corrupt CD data after media change and
	delay
Date: Fri, 06 Jun 2008 10:13:22 -0500
Message-ID: <1212765202.16182.5.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0806061458300.6228@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42195 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757736AbYFFPN3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2008 11:13:29 -0400
In-Reply-To: <Pine.LNX.4.64.0806061458300.6228@vixen.sonytel.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: David Martin <tasio@tasio.net>, Maarten Bressers <mbres@gentoo.org>, Daniel Drake <dsd@gentoo.org>, linux-scsi@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>, Cell Broadband Engine OSS Development <cbe-oss-dev@ozlabs.org>

On Fri, 2008-06-06 at 16:06 +0200, Geert Uytterhoeven wrote:
> 	Hi all,
> 
> When mounting a CD/DVD more than 30 seconds after inserting it, and reading
> from it, we get:
> 
>     attempt to access beyond end of device
>     sr0: rw=0, want=371932, limit=371928
>     Buffer I/O error on device sr0, logical block 92982
>     attempt to access beyond end of device
>     sr0: rw=0, want=371936, limit=371928
>     Buffer I/O error on device sr0, logical block 92983
>     attempt to access beyond end of device
>     sr0: rw=0, want=371940, limit=371928
>     Buffer I/O error on device sr0, logical block 92984
>     attempt to access beyond end of device
>     sr0: rw=0, want=371944, limit=371928
>     Buffer I/O error on device sr0, logical block 92985
>     attempt to access beyond end of device
>     sr0: rw=0, want=371948, limit=371928
>     Buffer I/O error on device sr0, logical block 92986
>     ...
> 
> It can be reproduced on a PS3 with busybox userland using:
> 
>     # Insert first CD
>     $ mount /dev/sr0 /mnt
>     $ ls -R /mnt
>     $ umount /mnt
>     $ eject
>     # Remove first CD
> 
>     # Insert second CD
>     # Wait at least 30 seconds
>     $ mount /dev/sr0 /mnt
>     $ tar cf /dev/null /mnt
> 
> It does not happen when mounting the second CD within 30 seconds after
> inserting it, which is consistent with
> 
>     #define SR_TIMEOUT     (30 * HZ)
> 
> I can't seem to reproduce it with a Debian or Fedora Core 6 userland.
> 
> The problem is present in 2.6.25.
> 2.6.24 is OK.

Hmm ... how are you preventing HAL from automatically mounting the CD?

Also, in the two different situations, what does

cat /sys/block/sr0/size

(assuming your cd is sr0) give you?  My first theory is an incorrect
size propagating from something.

James


