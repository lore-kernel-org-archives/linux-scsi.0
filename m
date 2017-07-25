From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [RFC 7/9] zfcp: use fc_block_rport for TMFs and host reset to decouple from scsi_cmnd
Date: Tue, 25 Jul 2017 16:14:25 +0200
Message-ID: <20170725141427.35258-8-maier@linux.vnet.ibm.com>
References: <20170725141427.35258-1-maier@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34972 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752371AbdGYOPG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Jul 2017 10:15:06 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6PEARdr102565
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2017 10:15:05 -0400
Received: from e06smtp12.uk.ibm.com (e06smtp12.uk.ibm.com [195.75.94.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2bx3am4epq-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2017 10:15:05 -0400
Received: from localhost
        by e06smtp12.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
        Tue, 25 Jul 2017 15:15:03 +0100
In-Reply-To: <20170725141427.35258-1-maier@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Cc: linux-s390@vger.kernel.org, Steffen Maier <maier@linux.vnet.ibm.com>, Benjamin Block <bblock@linux.vnet.ibm.com>

Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_scsi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 05c823ccb959..8e96196fa877 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -287,7 +287,7 @@ static int zfcp_task_mgmt_function(struct scsi_cmnd *scpnt, u8 tm_flags)
 			break;
 
 		zfcp_erp_wait(adapter);
-		ret = fc_block_scsi_eh(scpnt);
+		ret = port->rport ? fc_block_rport(port->rport) : 0;
 		if (ret) {
 			zfcp_dbf_scsi_devreset("fiof", adapter, tm_flags, NULL,
 					       scsi_id, scsi_lun);
@@ -337,11 +337,13 @@ static int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
 {
 	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(scpnt->device);
 	struct zfcp_adapter *adapter = zfcp_sdev->port->adapter;
+	struct zfcp_port *port;
 	int ret;
 
 	zfcp_erp_adapter_reopen(adapter, 0, "schrh_1");
 	zfcp_erp_wait(adapter);
-	ret = fc_block_scsi_eh(scpnt);
+	port = zfcp_sdev->port;
+	ret = port->rport ? fc_block_rport(port->rport) : 0;
 	if (ret)
 		return ret;
 
-- 
2.11.2
