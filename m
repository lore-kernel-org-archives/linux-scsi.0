From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] aic94xx: fix smartctl utility problem
Date: Sun, 16 Sep 2007 18:21:11 -0500
Message-ID: <1189984871.3383.17.camel@localhost.localdomain>
References: <1189792710.6030.3.camel@linux.site>
	 <1189875940.3339.12.camel@localhost.localdomain>
	 <1189960632.3383.4.camel@localhost.localdomain> <46EDB5B7.10101@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:55193 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753897AbXIPXVN (ORCPT
	<rfc822;Linux-scsi@vger.kernel.org>); Sun, 16 Sep 2007 19:21:13 -0400
In-Reply-To: <46EDB5B7.10101@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Gilbert Wu <Gilbert_Wu@adaptec.com>, Linux-scsi@vger.kernel.org

On Sun, 2007-09-16 at 19:01 -0400, Douglas Gilbert wrote:
> James Bottomley wrote:
> > On Sat, 2007-09-15 at 12:05 -0500, James Bottomley wrote:
> >> On Fri, 2007-09-14 at 10:58 -0700, Gilbert Wu wrote:
> >>> Fixed the problem that "smartctl -a /dev/some_sata_disk -d ata"  does
> >>> not work on SATA device. ( The smartctl v5.38 does need "-d ata"
> >>> option.)
> >>>   The aic94xx need to return ATA output register for all ATA commands
> >>> except ATA Read/Write commands.
> >>>   The aic94xx also mark out the DRQ bit from status register which is
> >>> treated as AC_ERR_HSM (host state machine violation) error by top layer
> >>> if it set to one.
> >>>  The firmware of aic94xx chip handle all ATA handshaking, data transfer
> >>> and return ATA output register which is sent by the device.  So the DRQ
> >>> bit may not reflect the last state of device when the command finished
> >>> and it is no meaning for the caller.
> >>>
> >>> Signed-off-by: Gilbert Wu <gilbert_wu@adaptec.com>
> >> I'm afraid this can't go in.  It has a bad effect on my expander remote
> >> ATAPI device:
> > 
> > OK, found the root cause: your CSMI_TASK flag is getting set on all
> > packet commands.  I can think of two fixes: either smartctl should never
> > be used on ATAPI devices (reasonable, since smart is a disc protocol),
> 
> Feature code 101h in MMC seems to sink your argument for
> cd/dvd drives.

I was more thinking that smartctl is a pure ATA type thing (The problem
which the flag is set for is to allow smartctl to muck with ATA
commands)... the MMC devices supporting smart features report this via
the informational exceptions mode page to conform to the MMC command
set.  So, when smartctl does SCSI transports, they'll go via a packet
command anyway.

> Also tape drives may support SMART and if they do,
> smartmontools can access the associated data. And tape
> drives may be on an ATAPI transport.

That's probably via the same mechanism, isn't it?

James


