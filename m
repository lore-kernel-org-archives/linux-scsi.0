From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 9/11] [SYM2] Allow NVRAM settings to limit speed and width
Date: Tue, 29 Nov 2005 23:08:44 -0500 (EST)
Message-ID: <20051130040844.A3CA37626C@gonzo>
References: <20051130040537.GC1597@parisc-linux.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.magmacom.com ([206.191.0.217]:61141 "EHLO mx1.magmacom.com")
	by vger.kernel.org with ESMTP id S1750865AbVK3EIr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Nov 2005 23:08:47 -0500
Received: from mail2.magma.ca (mail2.magma.ca [206.191.0.214])
	by mx1.magmacom.com (8.13.0/8.13.0) with ESMTP id jAU48kvC002610
	for <linux-scsi@vger.kernel.org>; Tue, 29 Nov 2005 23:08:47 -0500
Received: from gonzo (ottawa-hs-209-217-123-220.d-ip.magma.ca [209.217.123.220])
	by mail2.magma.ca (8.13.0/8.13.0) with ESMTP id jAU48i7Y002672
	for <linux-scsi@vger.kernel.org>; Tue, 29 Nov 2005 23:08:45 -0500
In-Reply-To: <20051130040537.GC1597@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The NVRAM for both Tekram and Symbios boards allows the user to set the
speed and width for individual targets.  I took that code out in March
2004 when we introduced Domain Validation, but it seems there's still
a legitimate need for it in some configurations.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

---

 drivers/scsi/sym53c8xx_2/sym_glue.c  |    3 +++
 drivers/scsi/sym53c8xx_2/sym_hipd.c  |    2 +-
 drivers/scsi/sym53c8xx_2/sym_hipd.h  |    6 ++++--
 drivers/scsi/sym53c8xx_2/sym_nvram.c |   29 ++++++++++++++++-------------
 drivers/scsi/sym53c8xx_2/sym_nvram.h |    4 ++--
 5 files changed, 26 insertions(+), 18 deletions(-)

applies-to: c8f292d80746e13d8d2eefc2bc500622e1c67c87
334ca2a5a0cd5d4e8b5d68ce81ef1baa0acd3cbc
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index bb90ef9..cb3d195 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -1038,6 +1038,9 @@ static int sym53c8xx_slave_alloc(struct 
 		return -ENOMEM;
 
 	tp->starget = sdev->sdev_target;
+	spi_min_period(tp->starget) = tp->usr_period;
+	spi_max_width(tp->starget) = tp->usr_width;
+
 	return 0;
 }
 
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index 5cc1420..cea2bc6 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -943,7 +943,7 @@ static int sym_prepare_setting(struct Sc
 		tp->usrflags |= (SYM_DISC_ENABLED | SYM_TAGS_ENABLED);
 		tp->usrtags = SYM_SETUP_MAX_TAG;
 
-		sym_nvram_setup_target(np, i, nvram);
+		sym_nvram_setup_target(tp, i, nvram);
 
 		if (!tp->usrtags)
 			tp->usrflags &= ~SYM_TAGS_ENABLED;
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.h b/drivers/scsi/sym53c8xx_2/sym_hipd.h
index 1718110..2456090 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.h
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.h
@@ -434,8 +434,10 @@ struct sym_tcb {
 	 *  Other user settable limits and options.
 	 *  These limits are read from the NVRAM if present.
 	 */
-	u_char	usrflags;
-	u_short	usrtags;
+	unsigned char	usrflags;
+	unsigned char	usr_period;
+	unsigned char	usr_width;
+	unsigned short	usrtags;
 	struct scsi_target *starget;
 };
 
diff --git a/drivers/scsi/sym53c8xx_2/sym_nvram.c b/drivers/scsi/sym53c8xx_2/sym_nvram.c
index 994b756..15d6929 100644
--- a/drivers/scsi/sym53c8xx_2/sym_nvram.c
+++ b/drivers/scsi/sym53c8xx_2/sym_nvram.c
@@ -92,29 +92,32 @@ void sym_nvram_setup_host(struct Scsi_Ho
  *  Get target set-up from Symbios format NVRAM.
  */
 static void
-sym_Symbios_setup_target(struct sym_hcb *np, int target, Symbios_nvram *nvram)
+sym_Symbios_setup_target(struct sym_tcb *tp, int target, Symbios_nvram *nvram)
 {
-	struct sym_tcb *tp = &np->target[target];
 	Symbios_target *tn = &nvram->target[target];
 
-	tp->usrtags =
-		(tn->flags & SYMBIOS_QUEUE_TAGS_ENABLED)? SYM_SETUP_MAX_TAG : 0;
-
+	if (!(tn->flags & SYMBIOS_QUEUE_TAGS_ENABLED))
+		tp->usrtags = 0;
 	if (!(tn->flags & SYMBIOS_DISCONNECT_ENABLE))
 		tp->usrflags &= ~SYM_DISC_ENABLED;
 	if (!(tn->flags & SYMBIOS_SCAN_AT_BOOT_TIME))
 		tp->usrflags |= SYM_SCAN_BOOT_DISABLED;
 	if (!(tn->flags & SYMBIOS_SCAN_LUNS))
 		tp->usrflags |= SYM_SCAN_LUNS_DISABLED;
+	tp->usr_period = (tn->sync_period + 3) / 4;
+	tp->usr_width = (tn->bus_width == 0x8) ? 0 : 1;
 }
 
+static const unsigned char Tekram_sync[16] = {
+	25, 31, 37, 43, 50, 62, 75, 125, 12, 15, 18, 21, 6, 7, 9, 10
+};
+
 /*
  *  Get target set-up from Tekram format NVRAM.
  */
 static void
-sym_Tekram_setup_target(struct sym_hcb *np, int target, Tekram_nvram *nvram)
+sym_Tekram_setup_target(struct sym_tcb *tp, int target, Tekram_nvram *nvram)
 {
-	struct sym_tcb *tp = &np->target[target];
 	struct Tekram_target *tn = &nvram->target[target];
 
 	if (tn->flags & TEKRAM_TAGGED_COMMANDS) {
@@ -124,22 +127,22 @@ sym_Tekram_setup_target(struct sym_hcb *
 	if (tn->flags & TEKRAM_DISCONNECT_ENABLE)
 		tp->usrflags |= SYM_DISC_ENABLED;
  
-	/* If any device does not support parity, we will not use this option */
-	if (!(tn->flags & TEKRAM_PARITY_CHECK))
-		np->rv_scntl0  &= ~0x0a; /* SCSI parity checking disabled */
+	if (tn->flags & TEKRAM_SYNC_NEGO)
+		tp->usr_period = Tekram_sync[tn->sync_index & 0xf];
+	tp->usr_width = (tn->flags & TEKRAM_WIDE_NEGO) ? 1 : 0;
 }
 
 /*
  *  Get target setup from NVRAM.
  */
-void sym_nvram_setup_target(struct sym_hcb *np, int target, struct sym_nvram *nvp)
+void sym_nvram_setup_target(struct sym_tcb *tp, int target, struct sym_nvram *nvp)
 {
 	switch (nvp->type) {
 	case SYM_SYMBIOS_NVRAM:
-		sym_Symbios_setup_target(np, target, &nvp->data.Symbios);
+		sym_Symbios_setup_target(tp, target, &nvp->data.Symbios);
 		break;
 	case SYM_TEKRAM_NVRAM:
-		sym_Tekram_setup_target(np, target, &nvp->data.Tekram);
+		sym_Tekram_setup_target(tp, target, &nvp->data.Tekram);
 		break;
 	default:
 		break;
diff --git a/drivers/scsi/sym53c8xx_2/sym_nvram.h b/drivers/scsi/sym53c8xx_2/sym_nvram.h
index 1538bed..bdfbbb0 100644
--- a/drivers/scsi/sym53c8xx_2/sym_nvram.h
+++ b/drivers/scsi/sym53c8xx_2/sym_nvram.h
@@ -194,12 +194,12 @@ struct sym_nvram {
 
 #if SYM_CONF_NVRAM_SUPPORT
 void sym_nvram_setup_host(struct Scsi_Host *shost, struct sym_hcb *np, struct sym_nvram *nvram);
-void sym_nvram_setup_target (struct sym_hcb *np, int target, struct sym_nvram *nvp);
+void sym_nvram_setup_target (struct sym_tcb *tp, int target, struct sym_nvram *nvp);
 int sym_read_nvram (struct sym_device *np, struct sym_nvram *nvp);
 char *sym_nvram_type(struct sym_nvram *nvp);
 #else
 static inline void sym_nvram_setup_host(struct Scsi_Host *shost, struct sym_hcb *np, struct sym_nvram *nvram) { }
-static inline void sym_nvram_setup_target(struct sym_hcb *np, struct sym_nvram *nvram) { }
+static inline void sym_nvram_setup_target(struct sym_tcb *tp, struct sym_nvram *nvram) { }
 static inline int sym_read_nvram(struct sym_device *np, struct sym_nvram *nvp)
 {
 	nvp->type = 0;
---
0.99.9.GIT
