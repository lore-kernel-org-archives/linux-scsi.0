From: "Bhanu Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH] bnx2fc: Fix MTU issue by using static MTU
Date: Mon, 14 Mar 2011 07:42:02 -0700
Message-ID: <1300113722.1360.20.camel@LTSJC-BPRAKASH.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3880 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763Ab1CNOmK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Mar 2011 10:42:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, devel@open-fcoe.org

bnx2x now uses seperate MTUs for networking and FCoE. FCoE MTU is fixed to 2500
and bnx2fc now needs to match this logic by using FCOE_MTU instead of
netdev->mtu.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |   35 +----------------------------------
 drivers/scsi/bnx2fc/bnx2fc_hwi.c  |    2 +-
 2 files changed, 2 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index b3e9edc..9ea018d 100644
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
+	if (fc_set_mfs(lport, FCOE_MTU))
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
index 3de1ce7..4296d21 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -87,7 +87,7 @@ int bnx2fc_send_fw_fcoe_init_msg(struct bnx2fc_hba *hba)
 	fcoe_init1.task_list_pbl_addr_lo = (u32) hba->task_ctx_bd_dma;
 	fcoe_init1.task_list_pbl_addr_hi =
 				(u32) ((u64) hba->task_ctx_bd_dma >> 32);
-	fcoe_init1.mtu = hba->netdev->mtu;
+	fcoe_init1.mtu = FCOE_MTU;
 
 	fcoe_init1.flags = (PAGE_SHIFT <<
 				FCOE_KWQE_INIT1_LOG_PAGE_SIZE_SHIFT);
-- 
1.7.0.6




