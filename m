From: David C Somayajulu <david.somayajulu@qlogic.com>
Subject: [PATCH] qla4xxx: allow hba to be online when initiator ip address
	is uninitialized
Date: Fri, 08 Jun 2007 17:29:21 -0700
Message-ID: <1181348961.8711.4.camel@q-iscsi-upstream.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:28327 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968694AbXFIAaS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jun 2007 20:30:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, David Wagner <david.wagner@qlogic.com>, David Somayajulu <david.somayajulu@qlogic.com>

This patch provides the following:
1. remove warning ignoring the return value of pci_set_mwi()
2. allows HBA to be online when the initiator ip address is uninitialized.

 drivers/scsi/qla4xxx/ql4_init.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index d8c064c..1e29f51 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -883,11 +883,12 @@ static int qla4xxx_config_nvram(struct s
 static void qla4x00_pci_config(struct scsi_qla_host *ha)
 {
 	uint16_t w;
+	int status;
 
 	dev_info(&ha->pdev->dev, "Configuring PCI space...\n");
 
 	pci_set_master(ha->pdev);
-	pci_set_mwi(ha->pdev);
+	status = pci_set_mwi(ha->pdev);
 	/*
 	 * We want to respect framework's setting of PCI configuration space
 	 * command register and also want to make sure that all bits of
@@ -1143,32 +1144,30 @@ int qla4xxx_initialize_adapter(struct sc
 
 	/* Initialize the Host adapter request/response queues and firmware */
 	if (qla4xxx_start_firmware(ha) == QLA_ERROR)
-		return status;
+		goto exit_init_hba;
 
 	if (qla4xxx_validate_mac_address(ha) == QLA_ERROR)
-		return status;
+		goto exit_init_hba;
 
 	if (qla4xxx_init_local_data(ha) == QLA_ERROR)
-		return status;
+		goto exit_init_hba;
 
 	status = qla4xxx_init_firmware(ha);
 	if (status == QLA_ERROR)
-		return status;
+		goto exit_init_hba;
 
 	/*
 	 * FW is waiting to get an IP address from DHCP server: Skip building
 	 * the ddb_list and wait for DHCP lease acquired aen to come in
 	 * followed by 0x8014 aen" to trigger the tgt discovery process.
 	 */
-	if (ha->firmware_state & FW_STATE_DHCP_IN_PROGRESS){
-		set_bit(AF_ONLINE, &ha->flags);
-		return status;
-	}
+	if (ha->firmware_state & FW_STATE_DHCP_IN_PROGRESS)
+		goto exit_init_online;
 
 	/* Skip device discovery if ip and subnet is zero */
 	if (memcmp(ha->ip_address, ip_address, IP_ADDR_LEN) == 0 ||
 	    memcmp(ha->subnet_mask, ip_address, IP_ADDR_LEN) == 0)
-		return status;
+		goto exit_init_online;
 
 	if (renew_ddb_list == PRESERVE_DDB_LIST) {
 		/*
@@ -1197,10 +1196,10 @@ int qla4xxx_initialize_adapter(struct sc
 			      ha->host_no));
 	}
 
+exit_init_online:
 	set_bit(AF_ONLINE, &ha->flags);
- exit_init_hba:
+exit_init_hba:
 	return status;
-
 }
 
 /**

