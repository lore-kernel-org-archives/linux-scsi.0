From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: [SAS ANNOUNCEMENT] MPT Fusion driver 3.02.07.02 update
Date: Mon, 15 Nov 2004 15:15:06 -0700
Message-ID: <91888D455306F94EBD4D168954A9457C3FFD67@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:24764 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261459AbUKOWPg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Nov 2004 17:15:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>, Jens Axboe <axboe@suse.de>

Here are my concerns:

(1) In addition to PHY, there is a link layer. How about
a transport layer for that?  Some of the things we report
are { Current/Previous Negotiated Link Rate, Phy enable/disable, SATA OOB
complete,
Invalid Dword Count, Loss  Dword Sync Count, Phy Reset Problem Count }.

(2) Reporting PHYS that are not direct attached to HBA; e.g. SMP Protocal
for Exander Management.  This SMP passthru is addressed by the SAS Address. 
How can the SAS address be sent down to the LLDs?

(3) SATA Drives in SAS topology - STP/SATA Passthru Protocal need to report
such
things as SMART DATA, Identify DATA, etc.   This is address by target, bus,
channel.
How SATA/IDE info be made available to upper transport layers?

(4) Douglas concern on dual ported SAS drives in /dev/sg?? multipath eh?

Eric

Monday, November 15, 2004 11:01 AM, James Bottomley wrote:

> 
> 
> On Fri, 2004-11-12 at 17:15, Moore, Eric Dean wrote:
> > Highlights for this release:
> > 
> > In addition to SAS support =>
> > 
> 
> Actually, before we begin on a SAS implementation, I'd rather 
> like us to
> get the architecture and design correct.  Reading all the SAS and SATA
> documentation is still on my todo list.  However, this is my 
> brief take
> on the architecture:
> 
> SAS itself is a bit of a monster because the PHY layer characteristics
> are identical to those of SATA.  Therefore, it seems like we need two
> separate transport classes, one for the PHY layer which would control
> the PHY transport characteristics and would be shareable with SATA and
> one for SAS only which would cover a large swath of the SAS specific
> ioctls and the useful bits of CMSI.
> 
> As far as the controller and expander protocols to which Doug Gilbert
> has been referring, I really have no current idea how to do 
> them, but if
> anyone else does now would be a good time to say something.
> 
> So does the above look like an acceptable way to move 
> forward? (having a
> PHY transport class is going to mean changes in both SCSI and SATA and
> probably block as well, since this may ultimately not be a 
> SCSI specific
> transport class).
> 
> James
> 
> 
