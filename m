From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH v3 08/13] BNX2I: Removed the dynamic registration of
 CNIC
Date: Tue, 23 Nov 2010 15:29:27 -0800
Message-ID: <1290554972-16928-9-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1055 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754061Ab0KWX1g (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Nov 2010 18:27:36 -0500
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
 drivers/scsi/bnx2i/bnx2i_iscsi.c |    7 ---
 3 files changed, 0 insertions(+), 92 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i.h b/drivers/scsi/bnx2i/bnx2i.h
index a44b1b3..2c34e22 100644
--- a/drivers/scsi/bnx2i/bnx2i.h
+++ b/drivers/scsi/bnx2i/bnx2i.h
@@ -717,14 +717,11 @@ extern struct device_attribute *bnx2i_dev_attributes[];
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
index 50c2aa3..769311f 100644
--- a/drivers/scsi/bnx2i/bnx2i_init.c
+++ b/drivers/scsi/bnx2i/bnx2i_init.c
@@ -65,8 +65,6 @@ MODULE_PARM_DESC(rq_size, "Configure RQ size");
 
 u64 iscsi_error_mask = 0x00;
 
-static void bnx2i_unreg_one_device(struct bnx2i_hba *hba) ;
-
 
 /**
  * bnx2i_identify_device - identifies NetXtreme II device type
@@ -239,86 +237,6 @@ void bnx2i_stop(void *handle)
 }
 
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
index 07dd4f9..43b7dad 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1606,8 +1606,6 @@ static struct bnx2i_hba *bnx2i_check_route(struct sockaddr *dst_addr)
 	struct bnx2i_hba *hba;
 	struct cnic_dev *cnic = NULL;
 
-	bnx2i_reg_dev_all();
-
 	hba = get_adapter_list_head();
 	if (hba && hba->cnic)
 		cnic = hba->cnic->cm_select_dev(desti, CNIC_ULP_ISCSI);
@@ -1726,8 +1724,6 @@ static struct iscsi_endpoint *bnx2i_ep_connect(struct Scsi_Host *shost,
 	if (shost) {
 		/* driver is given scsi host to work with */
 		hba = iscsi_host_priv(shost);
-		/* Register the device with cnic if not already done so */
-		bnx2i_register_device(hba);
 	} else
 		/*
 		 * check if the given destination can be reached through
@@ -1853,7 +1849,6 @@ qp_resc_err:
 check_busy:
 	mutex_unlock(&hba->net_dev_lock);
 nohba:
-	bnx2i_unreg_dev_all();
 	return ERR_PTR(rc);
 }
 
@@ -2089,8 +2084,6 @@ return_bnx2i_ep:
 
 	bnx2i_free_ep(ep);
 	mutex_unlock(&hba->net_dev_lock);
-	if (!hba->ofld_conns_active)
-		bnx2i_unreg_dev_all();
 
 	wake_up_interruptible(&hba->eh_wait);
 }
-- 
1.7.0.5


