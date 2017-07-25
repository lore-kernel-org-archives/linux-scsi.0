From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [RFC 9/9] zfcp: decouple our scsi_eh callbacks from scsi_cmnd
Date: Tue, 25 Jul 2017 16:14:27 +0200
Message-ID: <20170725141427.35258-10-maier@linux.vnet.ibm.com>
References: <20170725141427.35258-1-maier@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38200 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752385AbdGYOPO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Jul 2017 10:15:14 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6PEEs8B145520
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2017 10:15:13 -0400
Received: from e06smtp13.uk.ibm.com (e06smtp13.uk.ibm.com [195.75.94.109])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2bx6c2c1wn-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2017 10:15:13 -0400
Received: from localhost
        by e06smtp13.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
        Tue, 25 Jul 2017 15:15:11 +0100
In-Reply-To: <20170725141427.35258-1-maier@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Cc: linux-s390@vger.kernel.org, Steffen Maier <maier@linux.vnet.ibm.com>, Benjamin Block <bblock@linux.vnet.ibm.com>

zfcp_scsi_eh_device_reset_handler() now only depends on scsi_device.
zfcp_scsi_eh_target_reset_handler() now only depends on scsi_target.
zfcp_scsi_eh_host_reset_handler() now only depends on Scsi_Host.
All derive other objects from these intended callback arguments.

Actually change the signature of zfcp_task_mgmt_function() used by
zfcp_scsi_eh_device_reset_handler() & zfcp_scsi_eh_target_reset_handler().
Since it was prepared in a previous patch, we only need to delete
some local auto variables which are now the intended arguments.

Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_scsi.c | 40 ++++++++++++++++++++++++++++++++--------
 1 file changed, 32 insertions(+), 8 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 11cf33ea8c14..4cb38cfd46e3 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -266,11 +266,17 @@ static void zfcp_scsi_forget_cmnds(struct zfcp_port *port,
 	write_unlock_irqrestore(&adapter->abort_lock, flags);
 }
 
-static int zfcp_task_mgmt_function(struct scsi_cmnd *scpnt, u8 tm_flags)
+/**
+ * zfcp_task_mgmt_function() - Synchronously send a task management function.
+ * @port: Pointer to zfcp port indicating scope.
+ * @sdev: Pointer to SCSI device as scope, or %NULL if scope is only port.
+ * @tm_flags: Task management flags,
+ *            here we only handle %FCP_TMF_TGT_RESET or %FCP_TMF_LUN_RESET.
+ */
+static int zfcp_task_mgmt_function(struct zfcp_port *port,
+				   struct scsi_device *sdev, u8 tm_flags)
 {
-	struct scsi_device *sdev = scpnt->device;
-	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
-	struct zfcp_port *port = zfcp_sdev->port;
+	struct zfcp_scsi_dev *zfcp_sdev = sdev ? sdev_to_zfcp(sdev) : NULL;
 	struct zfcp_adapter *adapter = port->adapter;
 	unsigned int scsi_id = port->starget_id;
 	u64 scsi_lun = ZFCP_DBF_INVALID_LUN;
@@ -325,18 +331,36 @@ static int zfcp_task_mgmt_function(struct scsi_cmnd *scpnt, u8 tm_flags)
 
 static int zfcp_scsi_eh_device_reset_handler(struct scsi_cmnd *scpnt)
 {
-	return zfcp_task_mgmt_function(scpnt, FCP_TMF_LUN_RESET);
+	struct scsi_device *sdev = scpnt->device;
+	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
+	struct zfcp_port *port = zfcp_sdev->port;
+
+	return zfcp_task_mgmt_function(port, sdev, FCP_TMF_LUN_RESET);
 }
 
 static int zfcp_scsi_eh_target_reset_handler(struct scsi_cmnd *scpnt)
 {
-	return zfcp_task_mgmt_function(scpnt, FCP_TMF_TGT_RESET);
+	struct scsi_target *starget = scsi_target(scpnt->device);
+	struct fc_rport *rport = starget_to_rport(starget);
+	struct zfcp_adapter *adapter =
+		(struct zfcp_adapter *)rport_to_shost(rport)->hostdata[0];
+	struct zfcp_port *port = zfcp_get_port_by_wwpn(adapter,
+						       rport->port_name);
+	if (!port) {
+		zfcp_dbf_scsi_devreset("nopt", adapter, FCP_TMF_TGT_RESET,
+				       NULL, port->starget_id,
+				       ZFCP_DBF_INVALID_LUN);
+		return 0;
+	}
+
+	return zfcp_task_mgmt_function(port, NULL, FCP_TMF_TGT_RESET);
 }
 
 static int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
 {
-	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(scpnt->device);
-	struct zfcp_adapter *adapter = zfcp_sdev->port->adapter;
+	struct Scsi_Host *shost = scpnt->device->host;
+	struct zfcp_adapter *adapter =
+		(struct zfcp_adapter *)shost->hostdata[0];
 	struct zfcp_port *port;
 	int ret = SUCCESS;
 
-- 
2.11.2
