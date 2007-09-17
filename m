From: "Wu, Gilbert" <Gilbert_Wu@adaptec.com>
Subject: RE: [PATCH] aic94xx: fix smartctl utility problem
Date: Mon, 17 Sep 2007 13:53:54 -0700
Message-ID: <BC382691D59EC94C8E57543C47EF8ED55B20E1@aime2k302.adaptec.com>
References: <1189984871.3383.17.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ts.adaptec.com ([162.62.93.58]:32797 "HELO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753589AbXIQUx7 convert rfc822-to-8bit (ORCPT
	<rfc822;Linux-scsi@vger.kernel.org>); Mon, 17 Sep 2007 16:53:59 -0400
Content-class: urn:content-classes:message
In-Reply-To: <1189984871.3383.17.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, dougg@torque.net
Cc: Linux-scsi@vger.kernel.org

Hi All,

   I tested the SATA DVD Plextor model 716SA and 755SA with direct
attached. Both failed in my tested system and it end up with System
Panic even without my patch. The CSMI_TASK should not make any
difference between ATA and ATAPI device. I am digging into it for root
cause.

Thanks!
Gilbert

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@SteelEye.com] 
Sent: Sunday, September 16, 2007 4:21 PM
To: dougg@torque.net
Cc: Wu, Gilbert; Linux-scsi@vger.kernel.org
Subject: Re: [PATCH] aic94xx: fix smartctl utility problem

On Sun, 2007-09-16 at 19:01 -0400, Douglas Gilbert wrote:
> James Bottomley wrote:
> > On Sat, 2007-09-15 at 12:05 -0500, James Bottomley wrote:
> >> On Fri, 2007-09-14 at 10:58 -0700, Gilbert Wu wrote:
> >>> Fixed the problem that "smartctl -a /dev/some_sata_disk -d ata"
does
> >>> not work on SATA device. ( The smartctl v5.38 does need "-d ata"
> >>> option.)
> >>>   The aic94xx need to return ATA output register for all ATA
commands
> >>> except ATA Read/Write commands.
> >>>   The aic94xx also mark out the DRQ bit from status register which
is
> >>> treated as AC_ERR_HSM (host state machine violation) error by top
layer
> >>> if it set to one.
> >>>  The firmware of aic94xx chip handle all ATA handshaking, data
transfer
> >>> and return ATA output register which is sent by the device.  So
the DRQ
> >>> bit may not reflect the last state of device when the command
finished
> >>> and it is no meaning for the caller.
> >>>
> >>> Signed-off-by: Gilbert Wu <gilbert_wu@adaptec.com>
> >> I'm afraid this can't go in.  It has a bad effect on my expander
remote
> >> ATAPI device:
> > 
> > OK, found the root cause: your CSMI_TASK flag is getting set on all
> > packet commands.  I can think of two fixes: either smartctl should
never
> > be used on ATAPI devices (reasonable, since smart is a disc
protocol),
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


