From: Jens Axboe <axboe@suse.de>
Subject: Re: SuSE hwinfo/yast2 still confusing SYM53C8XX, killing tape backups (was: [BK PATCH] SCSI -rc1 fixes)
Date: Mon, 22 Nov 2004 12:17:23 +0100
Message-ID: <20041122111722.GC10463@suse.de>
References: <1100467267.23710.7.camel@mulgrave> <4197E4B7.3050008@pobox.com> <1100473795.23649.26.camel@mulgrave> <m3hdnsvvfd.fsf@merlin.emma.line.org> <1100477105.24921.3.camel@mulgrave> <m34qjrx6iy.fsf_-_@merlin.emma.line.org> <Pine.LNX.4.61.0411221102280.22230@ligeti.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:28049 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S262025AbUKVLSi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Nov 2004 06:18:38 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0411221102280.22230@ligeti.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steffen Winterfeldt <snwint@suse.de>
Cc: Matthias Andree <ma@dt.e-technik.uni-dortmund.de>, James Bottomley <James.Bottomley@SteelEye.com>, Jeff Garzik <jgarzik@pobox.com>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Nov 22 2004, Steffen Winterfeldt wrote:
> On Mon, 15 Nov 2004, Matthias Andree wrote:
> 
> > James Bottomley <James.Bottomley@SteelEye.com> writes:
> > 
> > > Well, I think we're stuck on that one.  SUSE doesn't seem willing to
> > > debug hwscan enough to give a coherent description of the problem or a
> > > non hwscan test case and no-one else wants to take hwscan apart to find
> > > out exactly what it is doing.
> 
> Sorry for the late response; I'm just back from vacation.
> 
> > Steffen, SuSE's hwinfo package throws parity errors on SYM53C8xx
> > hardware.  Same issue with all kernels SuSE shipped for 9.1 including
> > the current 2.6.5-7.111 kernel as well as vanilla 2.6.9.
> > hwinfo-8.62-0.2. hotplugctl-0.08-256 - yet another undocumented piece of
> > who-knows-what-its-good-for.
> > 
> > Common trouble introduced by running yast2 or hwinfo is SCSI parity
> > error, phase mismatch, bus reset and sometimes the machine going out to
> > lunch for 2 minutes. It is unclear whether hwinfo probes the hardware
> > directly, confusing the sym53c8xx, or uses some SCSI ioctl that confuses
> > the adaptor. Please help finding _this_ out and if it's hwinfo hacking
> > PCI registers directly, don't do that on ncr/sym/lsi53c8xx and 53c1010
> > chips.
> 
> hwinfo is just a normal program and doesn't do any special tricks on
> hardware. In particular, it issues an scsi inquiry command to get the serial
> number, but that's about all.
> 
> If running just hwinfo breaks things for you, you might try running it
> through strace and look at the files it accesses. Maybe that gives some hint
> to narrow things down.

hwinfo needs to be updated to use SG_IO, there are too many things that
can go wrong with SCSI_IOCTL_SEND_COMMAND (it's far too easy to confuse
the device or adapter).

-- 
Jens Axboe

