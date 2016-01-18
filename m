From: Insu Yun <wuninsu@gmail.com>
Subject: [PATCH] aic94xx: fix potential integer signedness error
Date: Mon, 18 Jan 2016 10:15:03 -0500
Message-ID: <1453130103-10645-1-git-send-email-wuninsu@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yk0-f179.google.com ([209.85.160.179]:36131 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347AbcARPNK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jan 2016 10:13:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: taesoo@gatech.edu, yeongjin.jang@gatech.edu, insu@gatech.edu, changwoo@gatech.edu, Insu Yun <wuninsu@gmail.com>

In asd_turn_led and asd_control_led, phy_id's upper bound is checked.
However, since phy_id is signed integer type, it can be less than 0.
Since phy_id is unsigned variable, for safety, it is better to change
a type of phy_id into unsigned integer variable. 

Signed-off-by: Insu Yun <wuninsu@gmail.com>
---
 drivers/scsi/aic94xx/aic94xx_hwi.c | 4 ++--
 drivers/scsi/aic94xx/aic94xx_hwi.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_hwi.c b/drivers/scsi/aic94xx/aic94xx_hwi.c
index 9f636a3..f6ebc9b 100644
--- a/drivers/scsi/aic94xx/aic94xx_hwi.c
+++ b/drivers/scsi/aic94xx/aic94xx_hwi.c
@@ -1276,7 +1276,7 @@ int asd_post_escb_list(struct asd_ha_struct *asd_ha, struct asd_ascb *ascb,
  * @phy_id: the PHY id whose LED we want to manupulate
  * @op: 1 to turn on, 0 to turn off
  */
-void asd_turn_led(struct asd_ha_struct *asd_ha, int phy_id, int op)
+void asd_turn_led(struct asd_ha_struct *asd_ha, u32 phy_id, int op)
 {
 	if (phy_id < ASD_MAX_PHYS) {
 		u32 v = asd_read_reg_dword(asd_ha, LmCONTROL(phy_id));
@@ -1297,7 +1297,7 @@ void asd_turn_led(struct asd_ha_struct *asd_ha, int phy_id, int op)
  * First we output enable the LED, then we set the source
  * to be an external module.
  */
-void asd_control_led(struct asd_ha_struct *asd_ha, int phy_id, int op)
+void asd_control_led(struct asd_ha_struct *asd_ha, u32 phy_id, int op)
 {
 	if (phy_id < ASD_MAX_PHYS) {
 		u32 v;
diff --git a/drivers/scsi/aic94xx/aic94xx_hwi.h b/drivers/scsi/aic94xx/aic94xx_hwi.h
index 8c1c282..0a22dda 100644
--- a/drivers/scsi/aic94xx/aic94xx_hwi.h
+++ b/drivers/scsi/aic94xx/aic94xx_hwi.h
@@ -388,8 +388,8 @@ int  asd_post_escb_list(struct asd_ha_struct *asd_ha, struct asd_ascb *ascb,
 
 int  asd_init_post_escbs(struct asd_ha_struct *asd_ha);
 void asd_build_control_phy(struct asd_ascb *ascb, int phy_id, u8 subfunc);
-void asd_control_led(struct asd_ha_struct *asd_ha, int phy_id, int op);
-void asd_turn_led(struct asd_ha_struct *asd_ha, int phy_id, int op);
+void asd_control_led(struct asd_ha_struct *asd_ha, u32 phy_id, int op);
+void asd_turn_led(struct asd_ha_struct *asd_ha, u32 phy_id, int op);
 int  asd_enable_phys(struct asd_ha_struct *asd_ha, const u8 phy_mask);
 
 void asd_ascb_timedout(unsigned long data);
-- 
1.9.1

