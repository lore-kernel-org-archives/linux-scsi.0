From: John Soni Jose <sony.john-n@emulex.com>
Subject: [PATCH v2 08/19] be2iscsi: Fix return value and typo.
Date: Sat, 20 Oct 2012 04:43:03 +0530
Message-ID: <4428bcf0-7ac8-41fb-a241-8c39fe8962ea@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:4716 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090Ab2JSXOK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Oct 2012 19:14:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org
Cc: John Soni Jose <sony.john-n@emulex.com>, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

 Fix return value and typo in the message displayed.
 Fix the goto label when wrb_hanlde allocation fails.
 Fix the error message display in beiscsi_alloc_pdu

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_iscsi.c |   13 +++----
 drivers/scsi/be2iscsi/be_main.c  |   67 ++++++++++++++++++++++++++++++-------
 2 files changed, 60 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index aedb0d9..3f41fc0 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -531,9 +531,9 @@ static int be2iscsi_get_if_param(struct beiscsi_hba *phba,
 		break;
 	case ISCSI_NET_PARAM_IPV4_BOOTPROTO:
 		if (!if_info.dhcp_state)
-			len = sprintf(buf, "static");
+			len = sprintf(buf, "static\n");
 		else
-			len = sprintf(buf, "dhcp");
+			len = sprintf(buf, "dhcp\n");
 		break;
 	case ISCSI_NET_PARAM_IPV4_SUBNET:
 		len = sprintf(buf, "%pI4\n", &if_info.ip_addr.subnet_mask);
@@ -541,7 +541,7 @@ static int be2iscsi_get_if_param(struct beiscsi_hba *phba,
 	case ISCSI_NET_PARAM_VLAN_ENABLED:
 		len = sprintf(buf, "%s\n",
 			     (if_info.vlan_priority == BEISCSI_VLAN_DISABLE)
-			     ? "Disabled" : "Enabled");
+			     ? "Disabled\n" : "Enabled\n");
 		break;
 	case ISCSI_NET_PARAM_VLAN_ID:
 		if (if_info.vlan_priority == BEISCSI_VLAN_DISABLE)
@@ -586,7 +586,7 @@ int be2iscsi_iface_get_param(struct iscsi_iface *iface,
 		len = be2iscsi_get_if_param(phba, iface, param, buf);
 		break;
 	case ISCSI_NET_PARAM_IFACE_ENABLE:
-		len = sprintf(buf, "enabled");
+		len = sprintf(buf, "enabled\n");
 		break;
 	case ISCSI_NET_PARAM_IPV4_GW:
 		memset(&gateway, 0, sizeof(gateway));
@@ -731,7 +731,6 @@ static int beiscsi_get_initname(char *buf, struct beiscsi_hba *phba)
  * beiscsi_get_port_state - Get the Port State
  * @shost : pointer to scsi_host structure
  *
- * returns number of bytes
  */
 static void beiscsi_get_port_state(struct Scsi_Host *shost)
 {
@@ -1150,8 +1149,8 @@ beiscsi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 
 	if (phba->state != BE_ADAPTER_UP) {
 		ret = -EBUSY;
-		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-			    "BS_%d : The Adapter state is Not UP\n");
+		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_CONFIG,
+			    "BS_%d : The Adapter Port state is Down!!!\n");
 		return ERR_PTR(ret);
 	}
 
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 0217997..0df2b2a 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -4105,13 +4105,25 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 		spin_lock(&phba->io_sgl_lock);
 		io_task->psgl_handle = alloc_io_sgl_handle(phba);
 		spin_unlock(&phba->io_sgl_lock);
-		if (!io_task->psgl_handle)
+		if (!io_task->psgl_handle) {
+			beiscsi_log(phba, KERN_ERR,
+				    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
+				    "BM_%d : Alloc of IO_SGL_ICD Failed"
+				    "for the CID : %d\n",
+				    beiscsi_conn->beiscsi_conn_cid);
 			goto free_hndls;
+		}
 		io_task->pwrb_handle = alloc_wrb_handle(phba,
 					beiscsi_conn->beiscsi_conn_cid -
 					phba->fw_config.iscsi_cid_start);
-		if (!io_task->pwrb_handle)
+		if (!io_task->pwrb_handle) {
+			beiscsi_log(phba, KERN_ERR,
+				    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
+				    "BM_%d : Alloc of WRB_HANDLE Failed"
+				    "for the CID : %d\n",
+				    beiscsi_conn->beiscsi_conn_cid);
 			goto free_io_hndls;
+		}
 	} else {
 		io_task->scsi_cmnd = NULL;
 		if ((opcode & ISCSI_OPCODE_MASK) == ISCSI_OP_LOGIN) {
@@ -4120,8 +4132,16 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 				io_task->psgl_handle = (struct sgl_handle *)
 						alloc_mgmt_sgl_handle(phba);
 				spin_unlock(&phba->mgmt_sgl_lock);
-				if (!io_task->psgl_handle)
+				if (!io_task->psgl_handle) {
+					beiscsi_log(phba, KERN_ERR,
+						    BEISCSI_LOG_IO |
+						    BEISCSI_LOG_CONFIG,
+						    "BM_%d : Alloc of MGMT_SGL_ICD Failed"
+						    "for the CID : %d\n",
+						    beiscsi_conn->
+						    beiscsi_conn_cid);
 					goto free_hndls;
+				}
 
 				beiscsi_conn->login_in_progress = 1;
 				beiscsi_conn->plogin_sgl_handle =
@@ -4130,8 +4150,16 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 					alloc_wrb_handle(phba,
 					beiscsi_conn->beiscsi_conn_cid -
 					phba->fw_config.iscsi_cid_start);
-				if (!io_task->pwrb_handle)
-					goto free_io_hndls;
+				if (!io_task->pwrb_handle) {
+					beiscsi_log(phba, KERN_ERR,
+						    BEISCSI_LOG_IO |
+						    BEISCSI_LOG_CONFIG,
+						    "BM_%d : Alloc of WRB_HANDLE Failed"
+						    "for the CID : %d\n",
+						    beiscsi_conn->
+						    beiscsi_conn_cid);
+					goto free_mgmt_hndls;
+				}
 				beiscsi_conn->plogin_wrb_handle =
 							io_task->pwrb_handle;
 
@@ -4146,14 +4174,28 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 			spin_lock(&phba->mgmt_sgl_lock);
 			io_task->psgl_handle = alloc_mgmt_sgl_handle(phba);
 			spin_unlock(&phba->mgmt_sgl_lock);
-			if (!io_task->psgl_handle)
+			if (!io_task->psgl_handle) {
+				beiscsi_log(phba, KERN_ERR,
+					    BEISCSI_LOG_IO |
+					    BEISCSI_LOG_CONFIG,
+					    "BM_%d : Alloc of MGMT_SGL_ICD Failed"
+					    "for the CID : %d\n",
+					    beiscsi_conn->
+					    beiscsi_conn_cid);
 				goto free_hndls;
+			}
 			io_task->pwrb_handle =
 					alloc_wrb_handle(phba,
 					beiscsi_conn->beiscsi_conn_cid -
 					phba->fw_config.iscsi_cid_start);
-			if (!io_task->pwrb_handle)
+			if (!io_task->pwrb_handle) {
+				beiscsi_log(phba, KERN_ERR,
+					    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
+					    "BM_%d : Alloc of WRB_HANDLE Failed"
+					    "for the CID : %d\n",
+					    beiscsi_conn->beiscsi_conn_cid);
 				goto free_mgmt_hndls;
+			}
 
 		}
 	}
@@ -4185,9 +4227,6 @@ free_hndls:
 	pci_pool_free(beiscsi_sess->bhs_pool, io_task->cmd_bhs,
 		      io_task->bhs_pa.u.a64.address);
 	io_task->cmd_bhs = NULL;
-	beiscsi_log(phba, KERN_ERR,
-		    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
-		    "BM_%d : Alloc of SGL_ICD Failed\n");
 	return -ENOMEM;
 }
 
@@ -4387,13 +4426,13 @@ static int beiscsi_bsg_request(struct bsg_job *job)
 			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
 				    "BM_%d : Failed to allocate memory for "
 				    "beiscsi_bsg_request\n");
-			return -EIO;
+			return -ENOMEM;
 		}
 		tag = mgmt_vendor_specific_fw_cmd(&phba->ctrl, phba, job,
 						  &nonemb_cmd);
 		if (!tag) {
 			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-				    "BM_%d : be_cmd_get_mac_addr Failed\n");
+				    "BM_%d : MBX Tag Allocation Failed\n");
 
 			pci_free_consistent(phba->ctrl.pdev, nonemb_cmd.size,
 					    nonemb_cmd.va, nonemb_cmd.dma);
@@ -4417,11 +4456,13 @@ static int beiscsi_bsg_request(struct bsg_job *job)
 				    nonemb_cmd.va, nonemb_cmd.dma);
 		if (status || extd_status) {
 			beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
-				    "BM_%d : be_cmd_get_mac_addr Failed"
+				    "BM_%d : MBX Cmd Failed"
 				    " status = %d extd_status = %d\n",
 				    status, extd_status);
 
 			return -EIO;
+		} else {
+			rc = 0;
 		}
 		break;
 
-- 
1.7.2

