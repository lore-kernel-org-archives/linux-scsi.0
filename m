From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 6/11] [SYM2] Disable IU and QAS negotiation
Date: Tue, 29 Nov 2005 23:08:38 -0500 (EST)
Message-ID: <20051130040838.446D27626C@gonzo>
References: <20051130040537.GC1597@parisc-linux.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.magmacom.com ([206.191.0.217]:54741 "EHLO mx1.magmacom.com")
	by vger.kernel.org with ESMTP id S1750848AbVK3EIl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Nov 2005 23:08:41 -0500
Received: from mail3.magma.ca (mail3.magma.ca [206.191.0.221])
	by mx1.magmacom.com (8.13.0/8.13.0) with ESMTP id jAU48d3D002585
	for <linux-scsi@vger.kernel.org>; Tue, 29 Nov 2005 23:08:40 -0500
Received: from gonzo (ottawa-hs-209-217-123-220.d-ip.magma.ca [209.217.123.220])
	by mail3.magma.ca (8.13.0/8.13.0) with ESMTP id jAU48c2s005445
	for <linux-scsi@vger.kernel.org>; Tue, 29 Nov 2005 23:08:39 -0500
In-Reply-To: <20051130040537.GC1597@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Enabling these features causes problems with some drives, so disable
them until they're debugged

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

---

 drivers/scsi/sym53c8xx_2/sym_glue.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

applies-to: 4cb76e47503c6282ad75599ccc17f19d74a8c010
adf11e5111a559aedf0160ebd56708b625ca38d4
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 46a132e..bb90ef9 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -2122,6 +2122,7 @@ static void sym2_set_dt(struct scsi_targ
 	tp->tgoal.check_nego = 1;
 }
 
+#if 0
 static void sym2_set_iu(struct scsi_target *starget, int iu)
 {
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
@@ -2147,7 +2148,7 @@ static void sym2_set_qas(struct scsi_tar
 		tp->tgoal.qas = 0;
 	tp->tgoal.check_nego = 1;
 }
-
+#endif
 
 static struct spi_function_template sym2_transport_functions = {
 	.set_offset	= sym2_set_offset,
@@ -2158,10 +2159,12 @@ static struct spi_function_template sym2
 	.show_width	= 1,
 	.set_dt		= sym2_set_dt,
 	.show_dt	= 1,
+#if 0
 	.set_iu		= sym2_set_iu,
 	.show_iu	= 1,
 	.set_qas	= sym2_set_qas,
 	.show_qas	= 1,
+#endif
 	.get_signalling	= sym2_get_signalling,
 };
 
---
0.99.9.GIT
