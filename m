From: Pat LaVarre <p.lavarre@ieee.org>
Subject: SG_IO open flags are which
Date: 15 Dec 2003 09:39:42 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1071506381.3389.22.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:3826 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S263793AbTLOQkA
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Dec 2003 11:40:00 -0500
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

Doug G:

What open flags should apps use to talk SG_IO?

O_RDWR?  O_RDONLY?  O_NONBLOCK?  Other?  Combination?

Wrong info in Google includes:

> List: linux-scsi
> Date: 2003-12-03 0:17:56
> Re: sg utils sg_io -i 0x24 -y "12 00:00:00 24 00"
> ...
> > > - O_RDWR
> > > + O_RDONLY|O_NONBLOCK
> > ... not from reading a document anywhere ...
> ...
> Possibly we recommend open O_NONBLOCK for SG_IO ...
> Evidence in favour ... includes ...
> From: linux-2.6.0-test11/Documentation/cdrom/cdrom-standard.tex
> ...
> 1997/12/28 ... propose ... $O_NONBLOCK$ to indicate
> that the device is opened just for issuing $ioctl$
> commands.

Wrong guess, if we try 2.6.0-test11 with the three commands:

-i x24 -y "12 00:00:00 24 00" // standard Inquiry
-y "1B 00:00:00 00 00" // Stop Unit
-y "1B 00:00:00 01 00" // Start Unit

Either open O_NONBLOCK or open O_RDWR allows pass thru of standard
Inquiry.  And open O_RDWR allows pass thru of Stop Unit.  But open
O_NONBLOCK rejects pass thru of Stop Unit:

$ sudo plscsi /dev/sg0 -x "1B 00:00:00 00 00"
...
$ grep -i 'Operation not permitted' /usr/include/asm/errno.h
#define EPERM            1      /* Operation not permitted */
$

Perhaps lk has no open that allows all of SG_IO without closing trays,
spinning up discs, etc.?  If we do face that limit, then often we can
settle for O_NONBLOCK to list device names (e.g. sg_scan) and O_RDWR
otherwise (e.g. sg_dd).

Wish I knew where in the lk source we're choosing to have the privilege
of the open vary the transparency of the pass thru.

Pat LaVarre


