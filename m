From: madhu.iyengar@qlogic.com
Subject: [PATCH 02/14] qla2xxx: list cursors are not null
Date: Tue, 21 Dec 2010 16:00:15 -0800
Message-ID: <1292976027-12034-3-git-send-email-madhu.iyengar@qlogic.com>
References: <1292976027-12034-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:36145 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1752865Ab0LVADX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Dec 2010 19:03:23 -0500
In-Reply-To: <1292976027-12034-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Dan Carpenter <error27@gmail.com>

From: Dan Carpenter <error27@gmail.com>

This is just a cleanup.

The unneeded NULL check annoys static checkers because we already
derefenced it and the we check it and then (if it's not the _safe()
version) we dereference it again without checking.  And the static
checker is all, "Wah?  Is it null or not?"

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    2 +-
 drivers/scsi/qla2xxx/qla_os.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 6f7cf39..e9b800e 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3888,7 +3888,7 @@ qla2x00_update_fcports(scsi_qla_host_t *base_vha)
 	list_for_each_entry(vha, &base_vha->hw->vp_list, list) {
 		atomic_inc(&vha->vref_count);
 		list_for_each_entry(fcport, &vha->vp_fcports, list) {
-			if (fcport && fcport->drport &&
+			if (fcport->drport &&
 			    atomic_read(&fcport->state) != FCS_UNCONFIGURED) {
 				spin_unlock_irqrestore(&ha->vport_slock, flags);
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index df2c1e7..1814df8 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2371,7 +2371,7 @@ qla2x00_remove_one(struct pci_dev *pdev)
 	list_for_each_entry(vha, &ha->vp_list, list) {
 		atomic_inc(&vha->vref_count);
 
-		if (vha && vha->fc_vport) {
+		if (vha->fc_vport) {
 			spin_unlock_irqrestore(&ha->vport_slock, flags);
 
 			fc_vport_terminate(vha->fc_vport);
-- 
1.6.0.2

