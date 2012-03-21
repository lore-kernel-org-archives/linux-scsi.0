From: santosh nayak <santoshprasadnayak@gmail.com>
Subject: [PATCH] [SCSI] pm8001: Add error handler in pm8001_init_sas_add() if kzalloc fails.
Date: Wed, 21 Mar 2012 14:08:14 +0530
Message-ID: <1332319094-11864-1-git-send-email-santoshprasadnayak@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63613 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471Ab2CUIjp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Mar 2012 04:39:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jack_wang@usish.com
Cc: mark_salyzyn@xyratex.com, lindar_liu@usish.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, Santosh Nayak <santoshprasadnayak@gmail.com>

From: Santosh Nayak <santoshprasadnayak@gmail.com>

We need to add error handler if kzalloc fails to allocate and initialize.
Otherwise it may lead to Null derefernce error in 
'pm8001_chip_get_nvmd_req()'.

Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
---
 drivers/scsi/pm8001/pm8001_init.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 36efaa7..fdce28e 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -519,6 +519,10 @@ static void pm8001_init_sas_add(struct pm8001_hba_info *pm8001_ha)
 	payload.minor_function = 0;
 	payload.length = 128;
 	payload.func_specific = kzalloc(128, GFP_KERNEL);
+	if (unlikely(!payload.func_specific)) {
+		printk(KERN_ERR "%s: failed to alloc memory\n", __func__);
+		return;
+	}
 	PM8001_CHIP_DISP->get_nvmd_req(pm8001_ha, &payload);
 	wait_for_completion(&completion);
 	for (i = 0; i < pm8001_ha->chip->n_phy; i++) {
-- 
1.7.4.4

