From: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: Proposal for new generic device API: dma_get_required_mask()
Date: Sun, 20 Jun 2004 20:47:23 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040620204723.B641@flint.arm.linux.org.uk>
References: <1087481331.2210.27.camel@mulgrave> <m33c4tsnex.fsf@defiant.pm.waw.pl> <20040618102120.A29213@flint.arm.linux.org.uk> <m3brjg7994.fsf@defiant.pm.waw.pl> <20040619212246.B8063@flint.arm.linux.org.uk> <m3zn6zf68l.fsf@defiant.pm.waw.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([212.18.232.186]:18182 "EHLO
	caramon.arm.linux.org.uk") by vger.kernel.org with ESMTP
	id S263770AbUFTTri (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Jun 2004 15:47:38 -0400
Content-Disposition: inline
In-Reply-To: <m3zn6zf68l.fsf@defiant.pm.waw.pl>; from khc@pm.waw.pl on Sun, Jun 20, 2004 at 02:00:42AM +0200
List-Id: linux-scsi@vger.kernel.org
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

> Wouldn't it be better to not touch the masks (which are device
> capabilities rather than platform limitations) and let alloc/map
> functions always use the correct half of RAM?

They are device limitations - the SA1111 device (which is a bus master
device in its own right) itself is the cause of the problem, so the
devices integrated inside it need to know.

Eg:

+------------------------+           +---------------------------+
|                        |           |                           |
| SSP       CPU--bus i/f-|-----+-----|-bus i/f   OHCI  SSP  SAC  |
|  |                |    |     |     |    |       |     |    |   |
|  +----------------+    |     |     |    +-------+-----+----+   |
|       SA11x0           | +-------+ |          SA1111           |
+------------------------+ | SDRAM | +---------------------------+
                           +-------+

The SDRAM bus is shared between the SA11x0 and SA1111 devices, and
there is an arbitration protocol to hand off the SDRAM bus between
the two devices.

The SSP and CPU itself inside the SA11x0 can access all SDRAM memory,
but the OHCI, SSP and SAC devices within the SA1111 are affected by
the problem.

So it's quite correct for this to be a device thing not a platform
thing.  It _is_ the SA1111 device itself which has the problem.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:  2.6 PCMCIA      - http://pcmcia.arm.linux.org.uk/
                 2.6 Serial core
