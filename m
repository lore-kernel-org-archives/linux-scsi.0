From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] aic94xx: Skip reading user settings if flash is not found
Date: Mon,  6 Jul 2015 13:07:58 +0200
Message-ID: <1436180878-81565-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36885 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753851AbbGFLID (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Jul 2015 07:08:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

If no user settings are found it's pointless trying to
read them from flash. So skip that step.
This also fixes a compilation warning about uninitialized variables in
aic94xx.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/aic94xx/aic94xx_sds.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_sds.c b/drivers/scsi/aic94xx/aic94xx_sds.c
index edb43fd..c831e30 100644
--- a/drivers/scsi/aic94xx/aic94xx_sds.c
+++ b/drivers/scsi/aic94xx/aic94xx_sds.c
@@ -983,7 +983,7 @@ static int asd_process_ctrl_a_user(struct asd_ha_struct *asd_ha,
 {
 	int err, i;
 	u32 offs, size;
-	struct asd_ll_el *el;
+	struct asd_ll_el *el = NULL;
 	struct asd_ctrla_phy_settings *ps;
 	struct asd_ctrla_phy_settings dflt_ps;
 
@@ -1004,6 +1004,7 @@ static int asd_process_ctrl_a_user(struct asd_ha_struct *asd_ha,
 
 		size = sizeof(struct asd_ctrla_phy_settings);
 		ps = &dflt_ps;
+		goto out_process;
 	}
 
 	if (size == 0)
@@ -1028,7 +1029,7 @@ static int asd_process_ctrl_a_user(struct asd_ha_struct *asd_ha,
 		ASD_DPRINTK("couldn't find ctrla phy settings struct\n");
 		goto out2;
 	}
-
+out_process:
 	err = asd_process_ctrla_phy_settings(asd_ha, ps);
 	if (err) {
 		ASD_DPRINTK("couldn't process ctrla phy settings\n");
-- 
1.8.5.2

