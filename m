From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: SG_IO open flags are which
Date: 05 Apr 2004 18:49:29 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1081212569.3439.32.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:40397 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S263595AbUDFBwO
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Apr 2004 21:52:14 -0400
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

Doug G:

> > Re: SG_IO open flags are which
> > http://marc.theaimsgroup.com/?t=107150658300002
> > ...
> > So first try and open() with the (O_NONBLOCK
> > | O_RDWR) flags.  If that yields ENOMEDIUM
> > look for the corresponding sg device name.
> > If the initial open() yields EROFS or EACESS
> > then try to open it (O_NONBLOCK | O_RDONLY).
> > ...

Clear workarounds for three possible results, yes, thank you.

Naturally I fear uncertainly and doubt the effects of defaulting to
O_RDWR or O_RDONLY.

> > Confused enough yet :-)

I can confirm ioctl SG_IO op x2A, in Linux-2.6.5, passes:

thru open O_NONBLOCK of mountable /dev/scd$n, and
thru open (O_NONBLOCK | O_RDWR) of unmountable /dev/sg$n, but
NOT thru open O_NONBLOCK of unmountable /dev/sg$n.

I get these same results no matter disc absent or present.

Next steps may include:

a) Contrast PDT x05 ioctl CDROM_SEND_PACKET with ioctl SG_IO.

b) Trace when open/ close implies op x1E "PREVENT" "ALLOW" around ioctl,
even ioctl of op x1B "START" "STOP" Eject.

Pat LaVarre


