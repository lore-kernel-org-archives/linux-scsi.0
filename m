From: worley@alum.mit.edu (Dale R. Worley)
Subject: Re: Write cache and surface error behaviour
Date: Mon, 28 Jul 2014 16:37:31 -0400
Message-ID: <201407282037.s6SKbVku032675@hobgoblin.ariadne.com>
References: <53CC3A92.5000501@shiftmail.org> <201407211455.s6LEtVfJ001124@hobgoblin.ariadne.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from qmta02.westchester.pa.mail.comcast.net ([76.96.62.24]:39984
	"EHLO qmta02.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751915AbaG1Uhe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jul 2014 16:37:34 -0400
In-reply-to: <201407211455.s6LEtVfJ001124@hobgoblin.ariadne.com>
	(worley@alum.mit.edu)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joystick@shiftmail.org, linux-scsi@vger.kernel.org

> From: joystick <joystick@shiftmail.org>
> 
> I don't really understand this disk cache thing.
> Suppose a disk with write cache enabled of writeback type: Linux 
> receives a write completed notification (a message from the disk) when 
> the data has reached the cache of the disk. Correct? At that point it is 
> not considered an in-flight I/O anymore. Correct?
> So what happens when the disk tries to write it to the platter and 
> discovers that there is a media error on that sector? (suppose 
> relocation does not happen ; maybe sectors exhausted)
> Does Linux receive the write error upon the next flush it issues? So the 
> error is related to the flush? And what happens if Linux never issues 
> such flush?

Thinking about this some more, there's no particular reason for the
kernel to use write-back caching in the disk, since the kernel itself
maintains a write-back cache.  So the kernel can be quite patient
about when the disk writes the block to the platters.  Given all the
complexities of coordinating with a disk that is doing write-back
caching, it seems like it would be easier for the kernel to tell the
disk to write-through, that is, don't notify the kernel that the write
is done until the data is actually on the platter.  Most of the time,
the kernel can be patient about writing; the only time the kernel has
to care is when an application forces synchronization on the disk I/O
subsystem.  (I vaguely recall this is done only on close() or
fsync().)  And when that happens, the kernel has to know the data is
on the platter.

Dale
