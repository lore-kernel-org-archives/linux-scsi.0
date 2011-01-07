From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] target: Add missing core_scsi3_put_pr_reg() for explict REGISTER key change
Date: Fri,  7 Jan 2011 11:51:39 -0800
Message-ID: <1294429899-6382-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp106.sbc.mail.mud.yahoo.com ([68.142.198.104]:35707 "HELO
	smtp106.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753624Ab1AGTwD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Jan 2011 14:52:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@suse.de>, Gustavo Panizzo <gfaraway@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a bug in core_scsi3_emulate_pro_register() with APTPL=0
where explictly changing the reservation key via REGISTER_* for an existing
registration was missing the final core_scsi3_put_pr_reg() to drop pr_res_holders
reference back to zero before returning.

This bug would then manifest itself in __core_scsi3_free_registration() where
we would end up waiting indefinately for t10_pr_registration->pr_res_holders
to return to zero.

[  269.532906] SPC-3 PR [iSCSI] Service Action: REGISTER_AND_IGNORE_EXISTING_KEY Initiator Node: iqn.1994-05.com.redhat.cluster1:7f3715a3da22,i,0x00023d010000
[  269.547412] SPC-3 PR [iSCSI] registration on Target Port: iqn.2010.ar.com.zumbi:disk0,0x0001
[  269.555871] SPC-3 PR [iSCSI] for SINGLE TCM Subsystem iblock Object Target Port(s)
[  269.563978] SPC-3 PR [iSCSI] SA Res Key: 0x4b6579412d2d2d2d PRgeneration: 0x00000007  APTPL: 0
[  269.573005] SPC-3 PR: Set APTPL Bit Deactivated for REGISTER
[  269.990649] SPC-3 PR [iSCSI] REGISTER_AND_IGNORE_EXISTING_KEY: Changed Reservation Key for iqn.1994-05.com.redhat.cluster1:7f3715a3da22 to: 0x4b6579422d2d2d2d PRgeneration: 0x00000008
[  270.007747] SPC-3 PR: Set APTPL Bit Deactivated for REGISTER
[  270.453160] SPC-3 PR [iSCSI] waiting for pr_res_holders
[  270.460294] SPC-3 PR [iSCSI] waiting for pr_res_holders
[  270.465543] SPC-3 PR [iSCSI] waiting for pr_res_holders
[  270.471450] SPC-3 PR [iSCSI] waiting for pr_res_holders

Reported-by: Gustavo Panizzo <gfaraway@gmail.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_pr.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index c36eaa6..307940d 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -2327,6 +2327,7 @@ static int core_scsi3_emulate_pro_register(
 			if (!(aptpl)) {
 				pr_tmpl->pr_aptpl_active = 0;
 				core_scsi3_update_and_write_aptpl(dev, NULL, 0);
+				core_scsi3_put_pr_reg(pr_reg);
 				printk("SPC-3 PR: Set APTPL Bit Deactivated"
 						" for REGISTER\n");
 				return 0;
-- 
1.7.3.5

