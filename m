From: worley@alum.mit.edu (Dale R. Worley)
Subject: Re: Write cache and surface error behaviour
Date: Mon, 21 Jul 2014 10:55:31 -0400
Message-ID: <201407211455.s6LEtVfJ001124@hobgoblin.ariadne.com>
References: <53CC3A92.5000501@shiftmail.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from qmta06.westchester.pa.mail.comcast.net ([76.96.62.56]:48971
	"EHLO qmta06.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752518AbaGUPBi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jul 2014 11:01:38 -0400
In-reply-to: <53CC3A92.5000501@shiftmail.org> (joystick@shiftmail.org)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joystick <joystick@shiftmail.org>
Cc: linux-scsi@vger.kernel.org

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

I'm no expert...  But modern disks play a lot of games beneath the
covers, including patching around bad blocks.  So in most cases, if
the first write shows a media error, the controller will assign a
replacement sector and write the data there.

Of course the risks you discuss still exist.  My guess is that if
people are really worried about their data, they don't use write-back
caching.  I notice that the startup messages of my system talk of
"writethrough" caching, which (IIRC) means that the kernel isn't told
that the write is complete until the controller can guarantee the data
is in non-volatile memory.

In the end, the biggest risk is that the entire disk will suddenly
become unreadable.

Dale
