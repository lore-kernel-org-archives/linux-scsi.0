From: Matthias Andree <ma@dt.e-technik.uni-dortmund.de>
Subject: Re: cpio problems with SCSI tape drive
Date: Thu, 27 May 2004 14:27:24 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <m3n03um4wj.fsf@merlin.emma.line.org>
References: <200405270617.i4R6HBB08441@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from krusty.dt.e-technik.Uni-Dortmund.DE ([129.217.163.1]:57786 "EHLO
	mail.dt.e-technik.uni-dortmund.de") by vger.kernel.org with ESMTP
	id S262060AbUE0M11 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 May 2004 08:27:27 -0400
In-Reply-To: <200405270617.i4R6HBB08441@www.watkins-home.com>
	(bugzilla@watkins-home.com's message of "Thu, 27 May 2004 02:17:05
	-0400")
List-Id: linux-scsi@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: linux-scsi@vger.kernel.org

"Guy" <bugzilla@watkins-home.com> writes:

> Maybe a clue:  While cpio is waiting for me to type the "device/file name"
> the tape drive is busy.  From another shell/window I tried to list the
> contents of another tape.  I could not, I got this error: "/dev/nst0: Device
> or resource busy".

Try using lsof to find out who uses the device.

Might be that cpio just holds the device open so nothing gets in the
way. You can also try to attach strace to cpio as soon as it requests
the 2nd tape (strace -p 12345, where 12345 is cpio's process ID) and see
what it does and where it fails.

-- 
Matthias Andree

Encrypted mail welcome: my GnuPG key ID is 0x052E7D95
