From: "Bhanu Gollapudi" <bprakash@broadcom.com>
Subject: [V2 PATCH 6/8] bnx2fc: Fix MTU issue by using static MTU
Date: Thu, 17 Mar 2011 17:13:34 -0700
Message-ID: <1300407214.644.409.camel@LTSJC-BPRAKASH.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4470 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756055Ab1CRANq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Mar 2011 20:13:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@suse.de" <James.Bottomley@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "devel@open-fcoe.org" <devel@open-fcoe.org>, Nithin Sujir <nsujir@broadcom.com>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, Michael Chan <mchan@broadcom.com>Nithin Sujir <nsujir@broadcom.com>

bnx2x now uses seperate MTUs for networking and FCoE. FCoE MTU is fixed to 2500
and bnx2fc now needs to match this logic by using FCOE_MTU instead of
netdev->mtu.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc.h      |    5 ++++-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |   35 +----------------------------------
 drivers/scsi/bnx2fc/bnx2fc_hwi.c  |    2 +-
 3 files changed, 6 insertions(+), 36 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index 464d71e..d869a4c 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -89,6 +89,10 @@
 #define BNX2FC_ELSTM_XIDS		BNX2FC_CAN_QUEUE
 #define BNX2FC_MIN_PAYLOAD		256
 #define BNX2FC_MAX_PAYLOAD		2048
+#define BNX2FC_MFS			\
+			(BNX2FC_MAX_PAYLOAD + sizeof(struct fc_frame_header))
+#define BNX2FC_MINI_JUMBO_MTU		2500
+
 
 #define BNX2FC_RQ_BUF_SZ		256
 #define BNX2FC_RQ_BUF_LOG_SZ		(ilog2(BNX2FC_RQ_BUF_SZ))
@@ -128,7 +132,6 @@
 
 #define BNX2FC_WAIT_CNT			120
 #define BNX2FC_FW_TIMEOUT		(3 * HZ)
-
 #define PORT_MAX			2
 
 #define CMD_SCSI_STATUS(Cmnd)		((Cmnd)->SCp.Status)
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 0eec4e0..aab55e2 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -661,31 +661,6 @@ static int bnx2fc_shost_config(struct fc_lport *lport, struct device *dev)
 	return 0;
 }
 
-static int  bnx2fc_mfs_update(struct fc_lport *lport)
-{
-	struct fcoe_port *port = lport_priv(lport);
-	struct bnx2fc_hba *hba = port->priv;
-	struct net_device *netdev = hba->netdev;
-	u32 mfs;
-	u32 max_mfs;
-
-	mfs = netdev->mtu - (sizeof(struct fcoe_hdr) +
-			     sizeof(struct fcoe_crc_eof));
-	max_mfs = BNX2FC_MAX_PAYLOAD + sizeof(struct fc_frame_header);
-	BNX2FC_HBA_DBG(lport, "mfs = %d, max_mfs = %d\n", mfs, max_mfs);
-	if (mfs > max_mfs)
-		mfs = max_mfs;
-
-	/* Adjust mfs to be a multiple of 256 bytes */
-	mfs = (((mfs - sizeof(struct fc_frame_header)) / BNX2FC_MIN_PAYLOAD) *
-			BNX2FC_MIN_PAYLOAD);
-	mfs = mfs + sizeof(struct fc_frame_header);
-
-	BNX2FC_HBA_DBG(lport, "Set MFS = %d\n", mfs);
-	if (fc_set_mfs(lport, mfs))
-		return -EINVAL;
-	return 0;
-}
 static void bnx2fc_link_speed_update(struct fc_lport *lport)
 {
 	struct fcoe_port *port = lport_priv(lport);
@@ -754,7 +729,7 @@ static int bnx2fc_net_config(struct fc_lport *lport)
 	    !hba->phys_dev->ethtool_ops->get_pauseparam)
 		return -EOPNOTSUPP;
 
-	if (bnx2fc_mfs_update(lport))
+	if (fc_set_mfs(lport, BNX2FC_MFS))
 		return -EINVAL;
 
 	skb_queue_head_init(&port->fcoe_pending_queue);
@@ -825,14 +800,6 @@ static void bnx2fc_indicate_netevent(void *context, unsigned long event)
 		if (!test_bit(ADAPTER_STATE_UP, &hba->adapter_state))
 			printk(KERN_ERR "indicate_netevent: "\
 					"adapter is not UP!!\n");
-		/* fall thru to update mfs if MTU has changed */
-	case NETDEV_CHANGEMTU:
-		BNX2FC_HBA_DBG(lport, "NETDEV_CHANGEMTU event\n");
-		bnx2fc_mfs_update(lport);
-		mutex_lock(&lport->lp_mutex);
-		list_for_each_entry(vport, &lport->vports, list)
-			bnx2fc_mfs_update(vport);
-		mutex_unlock(&lport->lp_mutex);
 		break;
 
 	case NETDEV_DOWN:
diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
index 3de1ce7..1b680e2 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -87,7 +87,7 @@ int bnx2fc_send_fw_fcoe_init_msg(struct bnx2fc_hba *hba)
 	fcoe_init1.task_list_pbl_addr_lo = (u32) hba->task_ctx_bd_dma;
 	fcoe_init1.task_list_pbl_addr_hi =
 				(u32) ((u64) hba->task_ctx_bd_dma >> 32);
-	fcoe_init1.mtu = hba->netdev->mtu;
+	fcoe_init1.mtu = BNX2FC_MINI_JUMBO_MTU;
 
 	fcoe_init1.flags = (PAGE_SHIFT <<
 				FCOE_KWQE_INIT1_LOG_PAGE_SIZE_SHIFT);
-- 
1.7.0.6




