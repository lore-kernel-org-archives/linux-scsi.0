From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Tue, 21 Sep 2004 14:44:34 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040921214434.GH146363@sgi.com>
References: <B179AE41C1147041AA1121F44614F0B0DD04E5@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:61635 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S268082AbUIUVos (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 17:44:48 -0400
Content-Disposition: inline
In-Reply-To: <B179AE41C1147041AA1121F44614F0B0DD04E5@AVEXCH02.qlogic.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Matthew Wilcox <matthew@wil.cx>, James Bottomley <James.Bottomley@SteelEye.com>, Jesse Barnes <jbarnes@engr.sgi.com>, Grant Grundler <grundler@parisc-linux.org>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Tue, Sep 21, 2004 at 02:22:48PM -0700, Andrew Vasquez wrote:
> On Tuesday, September 21, 2004 2:06 PM, Jeremy Higdon wrote:
> > On Tue, Sep 21, 2004 at 01:50:02PM -0700, Andrew Vasquez wrote:
> > > The only requirement after reception of a soft-reset request (by PIO
> > > or MMIO) by the RISC is for the driver to wait 16 PCI clocks before
> > > issuing another request.  The problem of course is determining when
> > > to start timing within the driver.
> > 
> > So I think that we just wait for some reasonable worst case time for
> > the write to complete.  We can't really do anything else.
> >
> 
> That seems to be the case.
>  
> > Are these resets done as part of error recovery?  I.e., do we have
> > to be concerned about long the write will take on a busy system?
> > 
> 
> Just during initialization (qla2x00_chip_diag() and qla2x00_setup_chip())
> and after a firmware dump (qla_dbg.c -- which requires a full 
> re-initialization to recover).  If the driver is in the process of
> performing a firmware-dump, the RISC has already been paused and nothing
> is executing within the firmware.
> 
> --
> Andrew

Well then 10us should be plenty of time.  Maybe 20 just to be extra sure.

jeremy
