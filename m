From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: request sense
Date: Fri, 25 Feb 2005 08:58:28 -0800
Message-ID: <20050225165828.GA8539@us.ibm.com>
References: <20050224231901.GT28741@parcelfarce.linux.theplanet.co.uk> <421EA34C.1060002@torque.net> <20050225153750.GU28741@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from e3.ny.us.ibm.com ([32.97.182.143]:64232 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262747AbVBYQ6k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Feb 2005 11:58:40 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j1PGwd9D010794
	for <linux-scsi@vger.kernel.org>; Fri, 25 Feb 2005 11:58:39 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j1PGwdW6247320
	for <linux-scsi@vger.kernel.org>; Fri, 25 Feb 2005 11:58:39 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j1PGwdcM002352
	for <linux-scsi@vger.kernel.org>; Fri, 25 Feb 2005 11:58:39 -0500
Content-Disposition: inline
In-Reply-To: <20050225153750.GU28741@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Douglas Gilbert <dougg@torque.net>, linux-scsi@vger.kernel.org

On Fri, Feb 25, 2005 at 03:37:50PM +0000, Matthew Wilcox wrote:
> On Fri, Feb 25, 2005 at 02:02:20PM +1000, Douglas Gilbert wrote:

> > Back in SCSI-2 (final t10 draft in 1993, standard in 1994) all
> > SCSI commands (I believe) used the top 3 bits of byte 1 of a cdb
> > for the logical unit number (lun). In those days SCSI had only
> > one transport (now called SPI) and luns were limited to 8 (3 bits)
> > for each target.
> > 
> > By SPC (part of the original "SCSI-3") those 3 bits were reserved
> > and luns had increased to 32 bits and were conveyed across the
> > SCSI transport by soem other mechanism (i.e. not the cdb). SPC was
> > standardized in 1997 and the final draft is dated almost 8 years
> > ago.
> 
> Thanks for the extremely clear explanation.  I suppose the effect of this
> bug is pretty minimal -- it only affects multi-lun scsi-2 devices, and even
> with those, it simply gets the sense data from the wrong LUN.  

I assume you mean _potentially_ affects affects only multi-lun scsi-2
earlier devices?

> That argues in favour of having scsi_error's implementation set the lun
> bits, conditional on sdev->scsi_level, right?

It already does so for all commands, see scsi_send_eh_cmnd():

	if (scmd->device->scsi_level <= SCSI_2)
		scmd->cmnd[1] = (scmd->cmnd[1] & 0x1f) |
		(scmd->device->lun << 5 & 0xe0);

And scsi_dispatch_cmd() has the same code for the normal IO paths.

-- Patrick Mansfield
