From: Andrew Morton <akpm@osdl.org>
Subject: Fw: SCSI device not spinning up on rw
Date: Sat, 3 Jun 2006 18:23:02 -0700
Message-ID: <20060603182302.7136831f.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:19939 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751113AbWFDBXH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Jun 2006 21:23:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Ruben Faelens <parasietje@gmail.com>



Begin forwarded message:

Date: Sat, 03 Jun 2006 21:47:48 +0200
From: Ruben Faelens <parasietje@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: SCSI device not spinning up on rw


I have a SCSI disk, which I want to spin down when the system is not in
use. I do this by using sdparm, scsi-spin or sg-utils. These tools all
spin down the SCSI drive by using an IOCTL.

Problem is that the kernel doesn't spin the drive back up. When a
process requests data from the disk (a simple ls), the kernel responds
with an I/O error. After some of these errors, reiserfs marks the drive
read-only.

This bug is also described here:
http://bugzilla.kernel.org/show_bug.cgi?id=6627

This bug was solved by scsi-idle (http://lost-habit.com/scsi.html) in
2.4 kernels, but the patch hasn't been ported to 2.6. It's also a dirty
hack, by someone who knows little of the internals of the SCSI system.

I read the LKML-archives, and they turned up some old posts in 09-2005
about this subject, where somebody says implementing this in SCSI could
get messy.

However, it seems to me that all it takes is a call to sd_spinup_disk()
in sd.c. When I add this in sd_init_command, the kernel crashes when
confronted with a SCSI disk. Then again, I'm no kernel hacker, this is
the first time I even read the source...

Could someone more experienced than me look into this? IMHO this should
be doable, because the spinup-on-read/write has been implemented in SATA
and IDE I/O subsystems. Then again, I read SATA and IDE disks handle
this for themselves.

So if someone would enlighten me, that would be great!

As a side note: maybe it's my disk that's having these problems? It's an
old SCSI disk in a HP 712/80 from 1994. Manual spinup does work however...


Ruben Faelens
BELGIUM
-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
