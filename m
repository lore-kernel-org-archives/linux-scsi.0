From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: SCSI QLA not working on latest *-mm SN2
Date: Tue, 21 Sep 2004 14:22:48 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B0DD04E5@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch01.qlogic.com ([198.70.193.200]:31559 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S268072AbUIUV1U convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 17:27:20 -0400
Content-Class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: Matthew Wilcox <matthew@wil.cx>, James Bottomley <James.Bottomley@SteelEye.com>, Jesse Barnes <jbarnes@engr.sgi.com>, Grant Grundler <grundler@parisc-linux.org>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Tuesday, September 21, 2004 2:06 PM, Jeremy Higdon wrote:
> On Tue, Sep 21, 2004 at 01:50:02PM -0700, Andrew Vasquez wrote:
> > The only requirement after reception of a soft-reset request (by PIO
> > or MMIO) by the RISC is for the driver to wait 16 PCI clocks before
> > issuing another request.  The problem of course is determining when
> > to start timing within the driver.
> 
> So I think that we just wait for some reasonable worst case time for
> the write to complete.  We can't really do anything else.
>

That seems to be the case.
 
> Are these resets done as part of error recovery?  I.e., do we have
> to be concerned about long the write will take on a busy system?
> 

Just during initialization (qla2x00_chip_diag() and qla2x00_setup_chip())
and after a firmware dump (qla_dbg.c -- which requires a full 
re-initialization to recover).  If the driver is in the process of
performing a firmware-dump, the RISC has already been paused and nothing
is executing within the firmware.

--
Andrew
