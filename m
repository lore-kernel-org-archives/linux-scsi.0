From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] instrument ide-scsi in 2.5.68
Date: Fri, 02 May 2003 09:29:55 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EB1ADF3.5080008@torque.net>
References: <3EB11AD3.2070503@torque.net> <20030501155225.7df14e51.rddunlap@osdl.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:63504 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S262763AbTEAXPX
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 May 2003 19:15:23 -0400
In-Reply-To: <20030501155225.7df14e51.rddunlap@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>
Cc: linux-scsi@vger.kernel.org, alan@lxorguk.ukuu.org.uk

Randy.Dunlap wrote:
<snip/>

> Hi Doug,
> 
> I have ATAPI CD-ROM as hdc and CD-RW as hdd.  I boot with
> "hdd=icd-scsi ide-scsi.debug=3".  Is that right/OK so far?
> If not, what should it be?

Randy,
I thought so but it's not picking "ide-scsi.debug=3" up:

 > Kernel command line: auto BOOT_IMAGE=lin2568isc ro root=304
   >  devfs=nomount hdd=ide-scsi ide-scsi.debug=3 console=tty0
   >  console=ttyS0,38400n8 debug
 > ide_setup: hdd=ide-scsi
 > ide_setup: ide-scsi.debug=3 -- BAD OPTION

The code uses Rusty's moduleparam.h and it worked
for me with scsi_debug. [It is some time since I checked
scsi_debug built-in.] Could you try "idescsi.debug=3"
(i.e. drop the hyphen). Failing that perhaps you could
build ide-scsi as a module.

> Anyway, it never gets thru the boot sequence (with or without this
> patch).  It hangs with these last messages:
> 
> scsi2 : SCSI host adapter emulation for IDE ATAPI devices
> ide-scsi: abort called for cmd serial #32
> hdd: lost interrupt
> ide-scsi: CoD != 0 in idescsi_pc_intr
> hdd: DMA disabled
> hdd: ATAPI reset complete
> hdd: irq timeout: status=0x80 { Busy }
> hdd: ATAPI reset complete
> hdd: irq timeout: status=0x80 { Busy }
> hdd: ATAPI reset complete
> hdd: irq timeout: status=0x80 { Busy }

It would be interesting to see what effect "suppress_reset=1"
has on this failure.

Doug Gilbert

