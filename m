From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Tue, 21 Sep 2004 15:49:24 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040921224924.GB147518@sgi.com>
References: <B179AE41C1147041AA1121F44614F0B0DD04E5@AVEXCH02.qlogic.org> <20040921214434.GH146363@sgi.com> <200409211837.46923.jbarnes@engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.20]:47773 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S267314AbUIUWt6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 18:49:58 -0400
Content-Disposition: inline
In-Reply-To: <200409211837.46923.jbarnes@engr.sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jesse Barnes <jbarnes@engr.sgi.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Matthew Wilcox <matthew@wil.cx>, James Bottomley <James.Bottomley@steeleye.com>, Grant Grundler <grundler@parisc-linux.org>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Tue, Sep 21, 2004 at 06:37:46PM -0400, Jesse Barnes wrote:
> On Tuesday, September 21, 2004 5:44 pm, Jeremy Higdon wrote:
> > > Just during initialization (qla2x00_chip_diag() and qla2x00_setup_chip())
> > > and after a firmware dump (qla_dbg.c -- which requires a full
> > > re-initialization to recover).  If the driver is in the process of
> > > performing a firmware-dump, the RISC has already been paused and nothing
> > > is executing within the firmware.
> >
> > Well then 10us should be plenty of time.  Maybe 20 just to be extra sure.
> 
> Don't forget the case of a driver that's insmod'd into a running, busy system.

Hopefully we don't have anyone insmodding qla2xxx on a 512p system
while it's running a numa stress test.  If so, they'll learn not
to.  :-)

It would be nice the have a solution for that case, but I don't
see it.  The only way to ensure the write is complete is to read
afterward, but the read afterward can bring the system down, so
we have to do without it and add some padding.  I think that's
the conclusion we're narrowing down to.

We can narrow the window with an sn_mmiob() on Altix.  I'm don't
think we want to clutter the driver with a platform-specific call
that is really intended just to imply ordering and not completion.
It just so happens that in order to guarantee ordering, the mmio
write will be partly completed.

jeremy
