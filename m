From: Jesse Barnes <jbarnes@engr.sgi.com>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Thu, 16 Sep 2004 14:09:20 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200409161409.20896.jbarnes@engr.sgi.com>
References: <B179AE41C1147041AA1121F44614F0B060EF48@AVEXCH02.qlogic.org> <200409161305.02947.jbarnes@engr.sgi.com> <1095368210.16820.6.camel@praka>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_AEgSBCGxcpWtgwy"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:2252 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S268260AbUIPVJb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Sep 2004 17:09:31 -0400
In-Reply-To: <1095368210.16820.6.camel@praka>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Paul Jackson <pj@sgi.com>, linux-scsi@vger.kernel.org, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, jbarnes@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

--Boundary-00=_AEgSBCGxcpWtgwy
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday, September 16, 2004 1:56 pm, Andrew Vasquez wrote:
> On Thu, 2004-09-16 at 13:05, Jesse Barnes wrote:
> > On Thursday, September 16, 2004 12:56 pm, Paul Jackson wrote:
> > > Andrew Vasquez has been looking at this, via private email with just
> > > me (no progress yet).  Figured I update the larger list with this much
> > > ...
> >
> > It seems to be failing on one of the accesses to PCI_COMMAND in config
> > space in qla2x00_reset_chip().  I'm checking now to see if we're
> > accessing the card right after a reset but before the card has finished. 
> > That would cause a master abort, the symptom I'm seeing at least.
>
> Interesting, the only changes in reset_chip() are for PCI posting
> issues.  Relevant diff attached.

Yeah, I think one of these is the culprit.  Before I got your message, I fixed 
some of them in my tree already (see attached) and things seem to work.

        WRT_REG_WORD(&reg->hccr, HCCR_CLR_RISC_INT);
+       RD_REG_WORD(&reg->hccr);                        /* PCI Posting. */
        WRT_REG_WORD(&reg->hccr, HCCR_CLR_HOST_INT);
+       RD_REG_WORD(&reg->hccr);                        /* PCI Posting. */
 
        /* Reset ISP chip. */
        WRT_REG_WORD(&reg->ctrl_status, CSR_ISP_SOFT_RESET);
+       RD_REG_WORD(&reg->ctrl_status);                 /* PCI Posting. */
 
In particular, are the above ok?  If the chip is resetting, won't doing a read 
cause a machine check (or at the very least, a device select timeout, which 
will return all ones on friendlier platforms).

        WRT_REG_WORD(&reg->ctrl_status, CSR_ISP_SOFT_RESET);
+       RD_REG_WORD(&reg->ctrl_status);                 /* PCI Posting. */

Same here?

Thanks,
Jesse

--Boundary-00=_AEgSBCGxcpWtgwy
Content-Type: text/plain;
  charset="iso-8859-1";
  name="qla2xxx-less-posting.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="qla2xxx-less-posting.patch"

diff -Napur -X /home/jbarnes/dontdiff linux-2.6.9-rc2-mm1.orig/drivers/scsi/qla2xxx/qla_init.c linux-2.6.9-rc2-mm1/drivers/scsi/qla2xxx/qla_init.c
--- linux-2.6.9-rc2-mm1.orig/drivers/scsi/qla2xxx/qla_init.c	2004-09-16 09:35:50.000000000 -0700
+++ linux-2.6.9-rc2-mm1/drivers/scsi/qla2xxx/qla_init.c	2004-09-16 14:00:32.000000000 -0700
@@ -463,13 +463,10 @@ qla2x00_reset_chip(scsi_qla_host_t *ha) 
 	}
 
 	WRT_REG_WORD(&reg->hccr, HCCR_CLR_RISC_INT);
-	RD_REG_WORD(&reg->hccr);			/* PCI Posting. */
 	WRT_REG_WORD(&reg->hccr, HCCR_CLR_HOST_INT);
-	RD_REG_WORD(&reg->hccr);			/* PCI Posting. */
 
 	/* Reset ISP chip. */
 	WRT_REG_WORD(&reg->ctrl_status, CSR_ISP_SOFT_RESET);
-	RD_REG_WORD(&reg->ctrl_status);			/* PCI Posting. */
 
 	/* Wait for RISC to recover from reset. */
 	if (IS_QLA2100(ha) || IS_QLA2200(ha) || IS_QLA2300(ha)) {
@@ -490,7 +487,6 @@ qla2x00_reset_chip(scsi_qla_host_t *ha) 
 
 	/* Reset RISC processor. */
 	WRT_REG_WORD(&reg->hccr, HCCR_RESET_RISC);
-	RD_REG_WORD(&reg->hccr);			/* PCI Posting. */
 
 	WRT_REG_WORD(&reg->semaphore, 0);
 
@@ -559,7 +555,6 @@ qla2x00_chip_diag(scsi_qla_host_t *ha)
 
 	/* Reset ISP chip. */
 	WRT_REG_WORD(&reg->ctrl_status, CSR_ISP_SOFT_RESET);
-	RD_REG_WORD(&reg->ctrl_status);			/* PCI Posting. */
 
 	/*
 	 * We need to have a delay here since the card will not respond while
@@ -581,9 +576,7 @@ qla2x00_chip_diag(scsi_qla_host_t *ha)
 
 	/* Reset RISC processor. */
 	WRT_REG_WORD(&reg->hccr, HCCR_RESET_RISC);
-	RD_REG_WORD(&reg->hccr);			/* PCI Posting. */
 	WRT_REG_WORD(&reg->hccr, HCCR_RELEASE_RISC);
-	RD_REG_WORD(&reg->hccr);			/* PCI Posting. */
 
 	/* Workaround for QLA2312 PCI parity error */
 	if (IS_QLA2100(ha) || IS_QLA2200(ha) || IS_QLA2300(ha)) {

--Boundary-00=_AEgSBCGxcpWtgwy--
