From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [patch 4/6] ps3: Disk Storage Driver
Date: Sat, 16 Jun 2007 08:21:52 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0706160819200.15507@pademelon.sonytel.be>
References: <1181918159.25228.543.camel@pmac.infradead.org>
 <Pine.LNX.4.62.0706151642010.8248@pademelon.sonytel.be>
 <20070615171545.316dfac7@the-village.bc.nu> <20070615.141917.85409547.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-540623539-1181974912=:15507"
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753316AbXFPGWK@vger.kernel.org>
In-Reply-To: <20070615.141917.85409547.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: alan@lxorguk.ukuu.org.uk, dwmw2@infradead.org, axboe@kernel.dk, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org
List-Id: linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-540623539-1181974912=:15507
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 15 Jun 2007, David Miller wrote:
> From: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Date: Fri, 15 Jun 2007 17:15:45 +0100
> 
> > > > Any particular reason why this is done as a separate block device driver
> > > > rather than as SCSI?
> > > 
> > > Because no new fake SCSI drivers are accepted anymore.
> > 
> > Where did drivers/ata come from ;)
> > 
> > How about making it a fake ata driver if James is being fussy 8)
> 
> That sounds like a good idea for my virtual I/O case on
> Niagara too actually :-)
> 
> Another quirk I have to deal with is that under LDOMs you
> can export full disks and also just slices.  So I'll have
> to get down into the partition machinery to support that
> somehow.

The PS3 hypervisor also splits each device in regions (cfr. partitions), with
different access rights depending the OS that runs on top of it. The old
virtual SCSI driver treated each region as a separate LUN.

As currently only one region can be accessed by Linux anyway, I didn't bother
supporting multiple accessible regions in the new storage drivers.

With kind regards,
 
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
 
Phone:    +32 (0)2 700 8453	
Fax:      +32 (0)2 700 8622	
E-mail:   Geert.Uytterhoeven@sonycom.com	
Internet: http://www.sony-europe.com/
 	
Sony Network and Software Technology Center Europe	
A division of Sony Service Centre (Europe) N.V.	
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium	
VAT BE 0413.825.160 · RPR Brussels	
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619
---584337861-540623539-1181974912=:15507--
