From: PinkFreud <pf-linux-scsi-20040717@mirkwood.net>
Subject: Re: sym53c8xx_2 funkiness...
Date: Mon, 26 Jul 2004 12:02:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040726160214.GB1105@eriador.mirkwood.net>
References: <20040718030514.GJ1105@eriador.mirkwood.net> <20040724165625.GA1105@eriador.mirkwood.net> <m3zn5nxi6j.fsf@merlin.emma.line.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pcp09895235pcs.ewndsr01.nj.comcast.net ([68.36.161.84]:58894
	"HELO rivendell.mirkwood.net") by vger.kernel.org with SMTP
	id S266198AbUGZQCQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jul 2004 12:02:16 -0400
Content-Disposition: inline
In-Reply-To: <m3zn5nxi6j.fsf@merlin.emma.line.org>
List-Id: linux-scsi@vger.kernel.org
To: Matthias Andree <ma@dt.e-technik.uni-dortmund.de>
Cc: linux-scsi@vger.kernel.org

On Mon, Jul 26, 2004 at 10:54:12AM +0200, Matthias Andree babbled thus:
> > Any ideas on why this is happening?  This system has become quite
> > unstable...
> >> I have a box with an old NCR 53c810 scsi card.  It was running fine
> >> with Slackware and a vanilla 2.4.19 kernel for the past year or so.
> >> I recently decided to install Debian on it, and started out with the
> >> Debian 2.4.26 package.  It wasn't long before I started noticing
> >> messages like
> >> sym0: SCSI BUS reset detected.
> >> sym0: SCSI BUS has been reset.
> >> in dmesg.  This also seems to hose the box more often than not...
> 
> Try booting with ACPI switched off
> and also check if you have devices on the bus that misbehave.

$ dmesg | grep -i acpi
ACPI: Unable to locate RSDP
ACPI: Subsystem revision 20040326
ACPI: Interpreter disabled.
PCI: ACPI tables contain no PCI IRQ routing entries

The box in question is an old Digital Multia (Intel variety).  Doesn't
appear to have ACPI support, unsurprisingly.

> 
> I've found it necessary to prohibit SCSI disconnect by module option for
> an elderly Tandberg TDC3800 tape drive after switching from 2.4's
> ncr53c8xx driver to the only official 2.6 driver, sym53c8xx_2; the
> controller in question was a Tekram DC-310U (SYM53C860) that was
> accompanied by a Plextor PX-40TSi (that also provides the active
> termination).

The ncr53c8xx driver was the source of a major headache for me a few
years back.  The sym53c8xx driver worked through vanilla 2.4.19 -
however, it doesn't seem to work now.  Blegh.

Can one safely disable disconnect if there are multiple devices on the
bus?  In particular, the system has a hard disk and a cdrom (both
external - and yes, I tried replacing the cable from the box to the
drives, and at the moment, I only have the hd plugged in).

> 
> I haven't bothered to check if there's a driver bug or a bug of the
> drive, a TDC4222 and an SLR6 work fine with a both a Tekram DC-390U and
> a Tekram DC-390F (both SYM53C875).

It's possible I just need to provide some options to the driver - I
wouldn't be surprised if some defaults have changed to favor newer
hardware.  I merely need to find out *what* needs changing...

> 
> -- 
> Matthias Andree
> 
> Encrypted mail welcome: my GnuPG key ID is 0x052E7D95 (PGP/MIME preferred)

-- 
                                                                      
Mike Edwards                    |   If this email address disappears,   
Unsolicited advertisments to    |   assume it was spammed to death.  To
this address are not welcome.   |   reach me in that case, s/-.*@/@/
(This means you, Cogent!)       |                                   
