From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: SCSI QLA not working on latest *-mm SN2
Date: 17 Sep 2004 19:55:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1095465337.1944.3.camel@mulgrave>
References: <B179AE41C1147041AA1121F44614F0B0DD04CA@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:4804 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S269046AbUIQX4G (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Sep 2004 19:56:06 -0400
In-Reply-To: <B179AE41C1147041AA1121F44614F0B0DD04CA@AVEXCH02.qlogic.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Jeremy Higdon <jeremy@sgi.com>, Jesse Barnes <jbarnes@engr.sgi.com>, Paul Jackson <pj@sgi.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, jbarnes@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Fri, 2004-09-17 at 18:55, Andrew Vasquez wrote:
> The reads are there to ensure ordering of the writes at each stage of
> the reset (in qla_init.c) and fw dumps (qla_dbg.c).  After speaking
> with the hardware and firmware folks, the readw() after the
> soft-reset in qla_init.c was probably what triggered the MCA.  Seems
> we will have to settle for some sort of udelay() as what was done in
> reset_chip().

Just to confirm if we absolutely have to do this...the offending reads
to issue the posting flush were to the register you just wrote to to get
the chip to reset.  However, any MMIO read to any region of that card
would also trigger a posted write flush.  Does the chip drop entirely
off the PCI bus during the execution of reset, or could we perhaps issue
an innocuous read to somewhere in PCI configuration space for the card?

James


