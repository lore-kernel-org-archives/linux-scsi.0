From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 2/2] ibmvscsi: use shost_priv
Date: Mon, 23 Jul 2007 09:28:40 +0900
Message-ID: <20070723092840W.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:59821 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835AbXGWA2x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Jul 2007 20:28:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com, santil@us.ibm.com

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c |   34 +++++++++++-----------------------
 1 files changed, 11 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 6735260..65f7fc1 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -702,8 +702,7 @@ static int ibmvscsi_queuecommand(struct scsi_cmnd *cmnd,
 	struct srp_cmd *srp_cmd;
 	struct srp_event_struct *evt_struct;
 	struct srp_indirect_buf *indirect;
-	struct ibmvscsi_host_data *hostdata =
-		(struct ibmvscsi_host_data *)&cmnd->device->host->hostdata;
+	struct ibmvscsi_host_data *hostdata = shost_priv(cmnd->device->host);
 	u16 lun = lun_from_dev(cmnd->device);
 	u8 out_fmt, in_fmt;
 
@@ -954,8 +953,7 @@ static void sync_completion(struct srp_event_struct *evt_struct)
  */
 static int ibmvscsi_eh_abort_handler(struct scsi_cmnd *cmd)
 {
-	struct ibmvscsi_host_data *hostdata =
-	    (struct ibmvscsi_host_data *)cmd->device->host->hostdata;
+	struct ibmvscsi_host_data *hostdata = shost_priv(cmd->device->host);
 	struct srp_tsk_mgmt *tsk_mgmt;
 	struct srp_event_struct *evt;
 	struct srp_event_struct *tmp_evt, *found_evt;
@@ -1078,9 +1076,7 @@ static int ibmvscsi_eh_abort_handler(struct scsi_cmnd *cmd)
  */
 static int ibmvscsi_eh_device_reset_handler(struct scsi_cmnd *cmd)
 {
-	struct ibmvscsi_host_data *hostdata =
-	    (struct ibmvscsi_host_data *)cmd->device->host->hostdata;
-
+	struct ibmvscsi_host_data *hostdata = shost_priv(cmd->device->host);
 	struct srp_tsk_mgmt *tsk_mgmt;
 	struct srp_event_struct *evt;
 	struct srp_event_struct *tmp_evt, *pos;
@@ -1177,8 +1173,7 @@ static int ibmvscsi_eh_device_reset_handler(struct scsi_cmnd *cmd)
 static int ibmvscsi_eh_host_reset_handler(struct scsi_cmnd *cmd)
 {
 	unsigned long wait_switch = 0;
-	struct ibmvscsi_host_data *hostdata =
-		(struct ibmvscsi_host_data *)cmd->device->host->hostdata;
+	struct ibmvscsi_host_data *hostdata = shost_priv(cmd->device->host);
 
 	dev_err(hostdata->dev, "Resetting connection due to error recovery\n");
 
@@ -1406,8 +1401,7 @@ static int ibmvscsi_change_queue_depth(struct scsi_device *sdev, int qdepth)
 static ssize_t show_host_srp_version(struct class_device *class_dev, char *buf)
 {
 	struct Scsi_Host *shost = class_to_shost(class_dev);
-	struct ibmvscsi_host_data *hostdata =
-	    (struct ibmvscsi_host_data *)shost->hostdata;
+	struct ibmvscsi_host_data *hostdata = shost_priv(shost);
 	int len;
 
 	len = snprintf(buf, PAGE_SIZE, "%s\n",
@@ -1427,8 +1421,7 @@ static ssize_t show_host_partition_name(struct class_device *class_dev,
 					char *buf)
 {
 	struct Scsi_Host *shost = class_to_shost(class_dev);
-	struct ibmvscsi_host_data *hostdata =
-	    (struct ibmvscsi_host_data *)shost->hostdata;
+	struct ibmvscsi_host_data *hostdata = shost_priv(shost);
 	int len;
 
 	len = snprintf(buf, PAGE_SIZE, "%s\n",
@@ -1448,8 +1441,7 @@ static ssize_t show_host_partition_number(struct class_device *class_dev,
 					  char *buf)
 {
 	struct Scsi_Host *shost = class_to_shost(class_dev);
-	struct ibmvscsi_host_data *hostdata =
-	    (struct ibmvscsi_host_data *)shost->hostdata;
+	struct ibmvscsi_host_data *hostdata = shost_priv(shost);
 	int len;
 
 	len = snprintf(buf, PAGE_SIZE, "%d\n",
@@ -1468,8 +1460,7 @@ static struct class_device_attribute ibmvscsi_host_partition_number = {
 static ssize_t show_host_mad_version(struct class_device *class_dev, char *buf)
 {
 	struct Scsi_Host *shost = class_to_shost(class_dev);
-	struct ibmvscsi_host_data *hostdata =
-	    (struct ibmvscsi_host_data *)shost->hostdata;
+	struct ibmvscsi_host_data *hostdata = shost_priv(shost);
 	int len;
 
 	len = snprintf(buf, PAGE_SIZE, "%d\n",
@@ -1488,8 +1479,7 @@ static struct class_device_attribute ibmvscsi_host_mad_version = {
 static ssize_t show_host_os_type(struct class_device *class_dev, char *buf)
 {
 	struct Scsi_Host *shost = class_to_shost(class_dev);
-	struct ibmvscsi_host_data *hostdata =
-	    (struct ibmvscsi_host_data *)shost->hostdata;
+	struct ibmvscsi_host_data *hostdata = shost_priv(shost);
 	int len;
 
 	len = snprintf(buf, PAGE_SIZE, "%d\n", hostdata->madapter_info.os_type);
@@ -1507,8 +1497,7 @@ static struct class_device_attribute ibmvscsi_host_os_type = {
 static ssize_t show_host_config(struct class_device *class_dev, char *buf)
 {
 	struct Scsi_Host *shost = class_to_shost(class_dev);
-	struct ibmvscsi_host_data *hostdata =
-	    (struct ibmvscsi_host_data *)shost->hostdata;
+	struct ibmvscsi_host_data *hostdata = shost_priv(shost);
 
 	/* returns null-terminated host config data */
 	if (ibmvscsi_do_host_config(hostdata, buf, PAGE_SIZE) == 0)
@@ -1576,8 +1565,7 @@ static int ibmvscsi_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 		goto scsi_host_alloc_failed;
 	}
 
-	hostdata = (struct ibmvscsi_host_data *)host->hostdata;
-	memset(hostdata, 0x00, sizeof(*hostdata));
+	hostdata = shost_priv(host);
 	INIT_LIST_HEAD(&hostdata->sent);
 	hostdata->host = host;
 	hostdata->dev = dev;
-- 
1.5.2.4

