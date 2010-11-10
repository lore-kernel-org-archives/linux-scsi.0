From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH 09/16] BNX2I: Removed the dynamic registration of CNIC
Date: Wed, 10 Nov 2010 15:04:50 -0800
Message-ID: <1289430297-30221-10-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1895 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757394Ab0KJXDI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Nov 2010 18:03:08 -0500
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@novell.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

The code no longer needs to dynamically register and unregister
the CNIC device.  The CNIC device will be kept registered until
module unload.

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
Reviewed-by: Michael Chan <mchan@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i.h       |    3 -
 drivers/scsi/bnx2i/bnx2i_init.c  |   82 --------------------------------------
 drivers/scsi/bnx2i/bnx2i_iscsi.c |    9 +----
 3 files changed, 1 insertions(+), 93 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i.h b/drivers/scsi/bnx2i/bnx2i.h
index 1aeb9f0..d153607 100644
--- a/drivers/scsi/bnx2i/bnx2i.h
+++ b/drivers/scsi/bnx2i/bnx2i.h
@@ -720,14 +720,11 @@ extern struct device_attribute *bnx2i_dev_attributes[];
  * Function Prototypes
  */
 extern void bnx2i_identify_device(struct bnx2i_hba *hba);
-extern void bnx2i_register_device(struct bnx2i_hba *hba);
 
 extern void bnx2i_ulp_init(struct cnic_dev *dev);
 extern void bnx2i_ulp_exit(struct cnic_dev *dev);
 extern void bnx2i_start(void *handle);
 extern void bnx2i_stop(void *handle);
-extern void bnx2i_reg_dev_all(void);
-extern void bnx2i_unreg_dev_all(void);
 extern struct bnx2i_hba *get_adapter_list_head(void);
 
 struct bnx2i_conn *bnx2i_get_conn_from_id(struct bnx2i_hba *hba,
diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_init.c
index c8e929d..338caac 100644
--- a/drivers/scsi/bnx2i/bnx2i_init.c
+++ b/drivers/scsi/bnx2i/bnx2i_init.c
@@ -65,8 +65,6 @@ MODULE_PARM_DESC(rq_size, "Configure RQ size");
 
 u64 iscsi_error_mask = 0x00;
 
-static void bnx2i_unreg_one_device(struct bnx2i_hba *hba) ;
-
 
 /**
  * bnx2i_identify_device - identifies NetXtreme II device type
@@ -252,86 +250,6 @@ void bnx2i_stop(void *handle)
 
 
 /**
- * bnx2i_register_device - register bnx2i adapter instance with the cnic driver
- * @hba:	Adapter instance to register
- *
- * registers bnx2i adapter instance with the cnic driver while holding the
- *	adapter structure lock
- */
-void bnx2i_register_device(struct bnx2i_hba *hba)
-{
-	int rc;
-
-	if (test_bit(ADAPTER_STATE_GOING_DOWN, &hba->adapter_state) ||
-	    test_bit(BNX2I_CNIC_REGISTERED, &hba->reg_with_cnic)) {
-		return;
-	}
-
-	rc = hba->cnic->register_device(hba->cnic, CNIC_ULP_ISCSI, hba);
-
-	if (!rc)
-		set_bit(BNX2I_CNIC_REGISTERED, &hba->reg_with_cnic);
-}
-
-
-/**
- * bnx2i_reg_dev_all - registers all adapter instances with the cnic driver
- *
- * registers all bnx2i adapter instances with the cnic driver while holding
- *	the global resource lock
- */
-void bnx2i_reg_dev_all(void)
-{
-	struct bnx2i_hba *hba, *temp;
-
-	mutex_lock(&bnx2i_dev_lock);
-	list_for_each_entry_safe(hba, temp, &adapter_list, link)
-		bnx2i_register_device(hba);
-	mutex_unlock(&bnx2i_dev_lock);
-}
-
-
-/**
- * bnx2i_unreg_one_device - unregister adapter instance with the cnic driver
- * @hba:	Adapter instance to unregister
- *
- * registers bnx2i adapter instance with the cnic driver while holding
- *	the adapter structure lock
- */
-static void bnx2i_unreg_one_device(struct bnx2i_hba *hba)
-{
-	if (hba->ofld_conns_active ||
-	    !test_bit(BNX2I_CNIC_REGISTERED, &hba->reg_with_cnic) ||
-	    test_bit(ADAPTER_STATE_GOING_DOWN, &hba->adapter_state))
-		return;
-
-	hba->cnic->unregister_device(hba->cnic, CNIC_ULP_ISCSI);
-
-	/* ep_disconnect could come before NETDEV_DOWN, driver won't
-	 * see NETDEV_DOWN as it already unregistered itself.
-	 */
-	hba->adapter_state = 0;
-	clear_bit(BNX2I_CNIC_REGISTERED, &hba->reg_with_cnic);
-}
-
-/**
- * bnx2i_unreg_dev_all - unregisters all bnx2i instances with the cnic driver
- *
- * unregisters all bnx2i adapter instances with the cnic driver while holding
- *	the global resource lock
- */
-void bnx2i_unreg_dev_all(void)
-{
-	struct bnx2i_hba *hba, *temp;
-
-	mutex_lock(&bnx2i_dev_lock);
-	list_for_each_entry_safe(hba, temp, &adapter_list, link)
-		bnx2i_unreg_one_device(hba);
-	mutex_unlock(&bnx2i_dev_lock);
-}
-
-
-/**
  * bnx2i_init_one - initialize an adapter instance and allocate memory resources
  * @hba:	bnx2i adapter instance
  * @cnic:	cnic device handle
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 6951969..58515ee 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1620,8 +1620,6 @@ static struct bnx2i_hba *bnx2i_check_route(struct sockaddr *dst_addr)
 	struct bnx2i_hba *hba;
 	struct cnic_dev *cnic = NULL;
 
-	bnx2i_reg_dev_all();
-
 	hba = get_adapter_list_head();
 	if (hba && hba->cnic)
 		cnic = hba->cnic->cm_select_dev(desti, CNIC_ULP_ISCSI);
@@ -1732,8 +1730,6 @@ static struct iscsi_endpoint *bnx2i_ep_connect(struct Scsi_Host *shost,
 	if (shost) {
 		/* driver is given scsi host to work with */
 		hba = iscsi_host_priv(shost);
-		/* Register the device with cnic if not already done so */
-		bnx2i_register_device(hba);
 	} else
 		/*
 		 * check if the given destination can be reached through
@@ -1859,7 +1855,6 @@ qp_resc_err:
 check_busy:
 	mutex_unlock(&hba->net_dev_lock);
 nohba:
-	bnx2i_unreg_dev_all();
 	return ERR_PTR(rc);
 }
 
@@ -2095,9 +2090,7 @@ return_bnx2i_ep:
 
 	bnx2i_free_ep(ep);
 	mutex_unlock(&hba->net_dev_lock);
-	if (!hba->ofld_conns_active)
-		bnx2i_unreg_dev_all();
-
+	
 	wake_up_interruptible(&hba->eh_wait);
 }
 
-- 
1.7.0.5


