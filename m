From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 07/10] Allow nvram settings to determine bus mode
Date: Tue, 28 Mar 2006 11:03:44 -0500
Message-ID: <1143561824482-git-send-email-matthew@wil.cx>
Reply-To: Matthew Wilcox <matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.magmacom.com ([206.191.0.217]:62143 "EHLO mx1.magmacom.com")
	by vger.kernel.org with ESMTP id S1751214AbWC1QDb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Mar 2006 11:03:31 -0500
In-Reply-To: 20060328160156.GJ3486@parisc-linux.org
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

The PDC code can set the bus mode, but we were ignoring that setting.
Also move the code that determines bus mode into its own function.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

---

 drivers/scsi/sym53c8xx_2/sym_hipd.c |   65 ++++++++++++++++++-----------------
 1 files changed, 34 insertions(+), 31 deletions(-)

c3e865e913823aaaf1e8aef80d889f4930db509f
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index 1d01c24..a671bdc 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -648,6 +648,37 @@ static void sym_save_initial_setting (st
 }
 
 /*
+ *  Set SCSI BUS mode.
+ *  - LVD capable chips (895/895A/896/1010) report the current BUS mode
+ *    through the STEST4 IO register.
+ *  - For previous generation chips (825/825A/875), the user has to tell us
+ *    how to check against HVD, since a 100% safe algorithm is not possible.
+ */
+static void sym_set_bus_mode(struct sym_hcb *np, struct sym_nvram *nvram)
+{
+	if (np->scsi_mode)
+		return;
+
+	np->scsi_mode = SMODE_SE;
+	if (np->features & (FE_ULTRA2|FE_ULTRA3))
+		np->scsi_mode = (np->sv_stest4 & SMODE);
+	else if	(np->features & FE_DIFF) {
+		if (SYM_SETUP_SCSI_DIFF == 1) {
+			if (np->sv_scntl3) {
+				if (np->sv_stest2 & 0x20)
+					np->scsi_mode = SMODE_HVD;
+			} else if (nvram->type == SYM_SYMBIOS_NVRAM) {
+				if (!(INB(np, nc_gpreg) & 0x08))
+					np->scsi_mode = SMODE_HVD;
+			}
+		} else if (SYM_SETUP_SCSI_DIFF == 2)
+			np->scsi_mode = SMODE_HVD;
+	}
+	if (np->scsi_mode == SMODE_HVD)
+		np->rv_stest2 |= 0x20;
+}
+
+/*
  *  Prepare io register values used by sym_start_up() 
  *  according to selected and supported features.
  */
@@ -657,10 +688,7 @@ static int sym_prepare_setting(struct Sc
 	u32	period;
 	int i;
 
-	/*
-	 *  Wide ?
-	 */
-	np->maxwide	= (np->features & FE_WIDE)? 1 : 0;
+	np->maxwide = (np->features & FE_WIDE) ? 1 : 0;
 
 	/*
 	 *  Guess the frequency of the chip's clock.
@@ -841,6 +869,7 @@ static int sym_prepare_setting(struct Sc
 	 *  Get parity checking, host ID and verbose mode from NVRAM
 	 */
 	np->myaddr = 255;
+	np->scsi_mode = 0;
 	sym_nvram_setup_host(shost, np, nvram);
 
 	/*
@@ -857,33 +886,7 @@ static int sym_prepare_setting(struct Sc
 	 */
 	sym_init_burst(np, burst_max);
 
-	/*
-	 *  Set SCSI BUS mode.
-	 *  - LVD capable chips (895/895A/896/1010) report the 
-	 *    current BUS mode through the STEST4 IO register.
-	 *  - For previous generation chips (825/825A/875), 
-	 *    user has to tell us how to check against HVD, 
-	 *    since a 100% safe algorithm is not possible.
-	 */
-	np->scsi_mode = SMODE_SE;
-	if (np->features & (FE_ULTRA2|FE_ULTRA3))
-		np->scsi_mode = (np->sv_stest4 & SMODE);
-	else if	(np->features & FE_DIFF) {
-		if (SYM_SETUP_SCSI_DIFF == 1) {
-			if (np->sv_scntl3) {
-				if (np->sv_stest2 & 0x20)
-					np->scsi_mode = SMODE_HVD;
-			}
-			else if (nvram->type == SYM_SYMBIOS_NVRAM) {
-				if (!(INB(np, nc_gpreg) & 0x08))
-					np->scsi_mode = SMODE_HVD;
-			}
-		}
-		else if	(SYM_SETUP_SCSI_DIFF == 2)
-			np->scsi_mode = SMODE_HVD;
-	}
-	if (np->scsi_mode == SMODE_HVD)
-		np->rv_stest2 |= 0x20;
+	sym_set_bus_mode(np, nvram);
 
 	/*
 	 *  Set LED support from SCRIPTS.
-- 
1.2.4.g375a5


