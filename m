From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 10/11] [SYM2] Report disabled devices and LUNs more attractively
Date: Tue, 29 Nov 2005 23:08:46 -0500 (EST)
Message-ID: <20051130040846.E251F7626C@gonzo>
References: <20051130040537.GC1597@parisc-linux.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2-old.magma.ca ([206.191.0.250]:61374 "EHLO mx2.magma.ca")
	by vger.kernel.org with ESMTP id S1750872AbVK3EIt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Nov 2005 23:08:49 -0500
Received: from mail2.magma.ca (mail2.magma.ca [206.191.0.214])
	by mx2.magma.ca (8.13.0/8.13.0) with ESMTP id jAU48m2f014273
	for <linux-scsi@vger.kernel.org>; Tue, 29 Nov 2005 23:08:49 -0500
Received: from gonzo (ottawa-hs-209-217-123-220.d-ip.magma.ca [209.217.123.220])
	by mail2.magma.ca (8.13.0/8.13.0) with ESMTP id jAU48lYP002702
	for <linux-scsi@vger.kernel.org>; Tue, 29 Nov 2005 23:08:48 -0500
In-Reply-To: <20051130040537.GC1597@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Rather than print a list of targets at driver init time, print each
disabled target as we attempt to scan it.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

---

 drivers/scsi/sym53c8xx_2/sym_glue.c |   14 +++++++++++---
 drivers/scsi/sym53c8xx_2/sym_hipd.c |   30 ------------------------------
 2 files changed, 11 insertions(+), 33 deletions(-)

applies-to: 4ce895552fb045694ebbcf767bf85eeecaa6331a
2d9e3ce82a8a754cf84be377165dc7214944e55b
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index cb3d195..1fffd2b 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -1018,6 +1018,7 @@ static int sym53c8xx_slave_alloc(struct 
 	if (sdev->id >= SYM_CONF_MAX_TARGET || sdev->lun >= SYM_CONF_MAX_LUN)
 		return -ENXIO;
 
+	tp->starget = sdev->sdev_target;
 	/*
 	 * Fail the device init if the device is flagged NOSCAN at BOOT in
 	 * the NVRAM.  This may speed up boot and maintain coherency with
@@ -1027,17 +1028,24 @@ static int sym53c8xx_slave_alloc(struct 
 	 * lun devices behave badly when asked for a non zero LUN.
 	 */
 
-	if ((tp->usrflags & SYM_SCAN_BOOT_DISABLED) ||
-	    ((tp->usrflags & SYM_SCAN_LUNS_DISABLED) && sdev->lun != 0)) {
+	if (tp->usrflags & SYM_SCAN_BOOT_DISABLED) {
 		tp->usrflags &= ~SYM_SCAN_BOOT_DISABLED;
+		starget_printk(KERN_INFO, tp->starget,
+				"Scan at boot disabled in NVRAM\n");
 		return -ENXIO;
 	}
 
+	if (tp->usrflags & SYM_SCAN_LUNS_DISABLED) {
+		if (sdev->lun != 0)
+			return -ENXIO;
+		starget_printk(KERN_INFO, tp->starget,
+				"Multiple LUNs disabled in NVRAM\n");
+	}
+
 	lp = sym_alloc_lcb(np, sdev->id, sdev->lun);
 	if (!lp)
 		return -ENOMEM;
 
-	tp->starget = sdev->sdev_target;
 	spi_min_period(tp->starget) = tp->usr_period;
 	spi_max_width(tp->starget) = tp->usr_width;
 
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index cea2bc6..1010e71 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -616,29 +616,6 @@ static __inline void sym_init_burst(stru
 	}
 }
 
-
-/*
- * Print out the list of targets that have some flag disabled by user.
- */
-static void sym_print_targets_flag(struct sym_hcb *np, int mask, char *msg)
-{
-	int cnt;
-	int i;
-
-	for (cnt = 0, i = 0 ; i < SYM_CONF_MAX_TARGET ; i++) {
-		if (i == np->myaddr)
-			continue;
-		if (np->target[i].usrflags & mask) {
-			if (!cnt++)
-				printf("%s: %s disabled for targets",
-					sym_name(np), msg);
-			printf(" %d", i);
-		}
-	}
-	if (cnt)
-		printf(".\n");
-}
-
 /*
  *  Save initial settings of some IO registers.
  *  Assumed to have been set by BIOS.
@@ -986,13 +963,6 @@ static int sym_prepare_setting(struct Sc
 			sym_name(np), np->rv_scntl3, np->rv_dmode, np->rv_dcntl,
 			np->rv_ctest3, np->rv_ctest4, np->rv_ctest5);
 	}
-	/*
-	 *  Let user be aware of targets that have some disable flags set.
-	 */
-	sym_print_targets_flag(np, SYM_SCAN_BOOT_DISABLED, "SCAN AT BOOT");
-	if (sym_verbose)
-		sym_print_targets_flag(np, SYM_SCAN_LUNS_DISABLED,
-				       "SCAN FOR LUNS");
 
 	return 0;
 }
---
0.99.9.GIT
