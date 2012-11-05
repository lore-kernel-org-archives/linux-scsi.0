From: Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH] [SCSI] aic94xx: Remove broken fallback for missing 'Ctrl-A'
 user settings
Date: Mon, 05 Nov 2012 13:18:52 +0000
Message-ID: <1352121532.3043.95.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57633 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751272Ab2KENS5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Nov 2012 08:18:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

asd_process_ctrl_a_user() attempts to find user settings in flash, and
if they are missing it prepares a substitute structure containing
default values for PHY settings.  But having done so, it will still
try to read user settings - from some random address in flash, as the
local variable 'offs' has not been initialised.

Since asd_common_setup() already sets default PHY settings, there
seems to be no need to repeat them here, and we can just return 0.
This matches what is done if any empty user settings area is found.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
Compile-tested only.

Ben.

 drivers/scsi/aic94xx/aic94xx_sds.c |   19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_sds.c b/drivers/scsi/aic94xx/aic94xx_sds.c
index edb43fd..7b13ccc 100644
--- a/drivers/scsi/aic94xx/aic94xx_sds.c
+++ b/drivers/scsi/aic94xx/aic94xx_sds.c
@@ -981,29 +981,16 @@ static int asd_process_ctrla_phy_settings(struct asd_ha_struct *asd_ha,
 static int asd_process_ctrl_a_user(struct asd_ha_struct *asd_ha,
 				   struct asd_flash_dir *flash_dir)
 {
-	int err, i;
+	int err;
 	u32 offs, size;
 	struct asd_ll_el *el;
 	struct asd_ctrla_phy_settings *ps;
-	struct asd_ctrla_phy_settings dflt_ps;
 
 	err = asd_find_flash_de(flash_dir, FLASH_DE_CTRL_A_USER, &offs, &size);
 	if (err) {
 		ASD_DPRINTK("couldn't find CTRL-A user settings section\n");
-		ASD_DPRINTK("Creating default CTRL-A user settings section\n");
-
-		dflt_ps.id0 = 'h';
-		dflt_ps.num_phys = 8;
-		for (i =0; i < ASD_MAX_PHYS; i++) {
-			memcpy(dflt_ps.phy_ent[i].sas_addr,
-			       asd_ha->hw_prof.sas_addr, SAS_ADDR_SIZE);
-			dflt_ps.phy_ent[i].sas_link_rates = 0x98;
-			dflt_ps.phy_ent[i].flags = 0x0;
-			dflt_ps.phy_ent[i].sata_link_rates = 0x0;
-		}
-
-		size = sizeof(struct asd_ctrla_phy_settings);
-		ps = &dflt_ps;
+		ASD_DPRINTK("Using default settings\n");
+		return 0;
 	}
 
 	if (size == 0)


