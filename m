From: Nathan Hunsperger <nathan@munchnet.com>
Subject: Re: Are QLA2000's doomed under 2.4?
Date: Wed, 11 Jun 2003 12:56:18 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030611195618.GA21393@munchnet.com>
References: <20030609042014.GH4373@munchnet.com> <20030609162047.GA24926@praka.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adsl-66-120-172-74.dsl.sntc01.pacbell.net ([66.120.172.74]:43005
	"EHLO server-linux.munchnet.com") by vger.kernel.org with ESMTP
	id S263458AbTFKTmi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jun 2003 15:42:38 -0400
Content-Disposition: inline
In-Reply-To: <20030609162047.GA24926@praka.local.home>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <praka@san.rr.com>, linux-scsi@vger.kernel.org

On Mon, Jun 09, 2003 at 09:20:47AM -0700, Andrew Vasquez wrote:
> Which version of the QLogic driver are you trying to you trying to
> use?  The latest beta 6.05.00b9 and the latest formal release
> (6.04.00) contain no strings in the source which read as 'this should
> not happen.'  The qlogicfc.c driver (in the kernel) contains the
> following printk:
> 
> 	printk("qlogicfc%d : no handle slots, this should not happen.\n",
> 		hostdata->host_id)
> 
> Is this the message you are referring to? 

Yeah, thanks for calling me on that.  I've been beating my head on the
wall over this for about 2 months, so I managed to confuse myself a bit.
I've just re-run some tests with the various drivers, and have attached
the kernel logs.

> IAC: Could you try the 6.05.00b9 which is available on the web:
> 
> 	http://www.qlogic.com/support/os_detail.asp?productid=255&osid=26

No luck.  This driver performs the same as 6.04.

> QLogic doesn't formally support the EOLd ISP2100 chip, but the driver
> has worked for a few others, and I'll try to help as best as I can.

Thanks.  Unfortunatly the lack of QLogic support makes it that much
harder for me to debug.


qlogic v6.05.00b9 (f/w 1.19.24):

Jun 10 11:10:38 delta kernel: qla2x00(3): Performing ISP error recovery - ha= f7af807c.
Jun 10 11:10:38 delta kernel: scsi(3): LIP reset occurred.
Jun 10 11:10:38 delta kernel: scsi(3): Waiting for LIP to complete...
Jun 10 11:10:38 delta kernel: scsi(3): Waiting for LIP to complete...
Jun 10 11:10:39 delta kernel: scsi(3): LIP occurred.
Jun 10 11:10:39 delta kernel: scsi(3): LOOP UP detected.
Jun 10 11:10:39 delta kernel: scsi(3): Topology - (Loop), Host Loop address 0x7

or

Jun 10 11:25:32 delta kernel: qla2xxx_eh_abort Exiting: status=Failed
...
Jun 10 12:16:08 delta kernel: scsi(3:0:0:0): DEVICE RESET ISSUED.
...
Jun 10 12:16:08 delta kernel: scsi(3:0:0:0): LOOP RESET ISSUED.
Jun 10 12:16:08 delta kernel: qla2xxx_eh_bus_reset Exiting: Reset Failed

(above 2 entries 10 times for each of 14 drives on loop, @ 5s interval)

Jun 10 12:28:06 delta kernel: scsi(3:0:0:0): now issue ADAPTER RESET.
Jun 10 12:28:06 delta kernel: qla2x00(3): Performing ISP error recovery - ha= f7af807c.
Jun 10 12:28:07 delta kernel: scsi(3): LIP reset occurred.
Jun 10 12:28:07 delta kernel: scsi(3): Waiting for LIP to complete...
Jun 10 12:28:07 delta kernel: scsi(3): LIP occurred.
Jun 10 12:28:07 delta kernel: scsi(3): LOOP UP detected.
Jun 10 12:28:07 delta kernel: scsi(3): Topology - (Loop), Host Loop address 0x7
Jun 10 12:28:07 delta kernel: qla2xxx_eh_host_reset Exiting: status=SUCCESS

qlogic v6.04.00 (f/w 1.19.24):

<same as v6.05.00b9>

qlogicfc:

qlogicfc0 : no handle slots, this should not happen.
hostdata->queued is 4e, in_ptr: xx
(above 2 several times, then lockup)

- Nathan
