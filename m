From: Jesse Barnes <jbarnes@engr.sgi.com>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Thu, 16 Sep 2004 15:29:10 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200409161529.10122.jbarnes@engr.sgi.com>
References: <B179AE41C1147041AA1121F44614F0B060EF48@AVEXCH02.qlogic.org> <1095370854.16820.34.camel@praka> <20040916152552.232ccbe7.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_2OhSBrHRGYttWor"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:8353 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S268105AbUIPW3W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Sep 2004 18:29:22 -0400
In-Reply-To: <20040916152552.232ccbe7.akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, pj@sgi.com, linux-scsi@vger.kernel.org, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, jbarnes@cthulhu.engr.sgi.com

--Boundary-00=_2OhSBrHRGYttWor
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday, September 16, 2004 3:25 pm, Andrew Morton wrote:
> Andrew Vasquez <andrew.vasquez@qlogic.com> wrote:
> > Andrew, please add Jesse's patch along with the patch I'm attaching to
> > your tree.  I'll be sure to add the ia64 machine back into our test
> > ring.
>
> Could someone send me Jesse's patch?

Here it is.

Reduce some overaggressive compensation for PCI write posting.  In some cases 
we don't actually want to read a value back, since the card could be 
resetting.

Signed-off-by: Jesse Barnes <jbarnes@sgi.com>

Thanks,
Jesse

--Boundary-00=_2OhSBrHRGYttWor
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

--Boundary-00=_2OhSBrHRGYttWor--
