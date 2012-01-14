From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH] scsi: Sparse fixes
Date: Sat, 14 Jan 2012 16:39:37 +0000
Message-ID: <1352978.xR7YmcYmPS@asus>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay01ant.iops.be ([212.53.4.34]:58219 "EHLO
	relay01ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419Ab2ANQjm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Jan 2012 11:39:42 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by relay01ant.iops.be (Postfix) with ESMTP id 7F336208A6
	for <linux-scsi@vger.kernel.org>; Sat, 14 Jan 2012 17:39:41 +0100 (CET)
Received: from relay01ant.iops.be ([127.0.0.1])
	by localhost (bdell034.dcn.iops.be [127.0.0.1]) (amavisd-new, port 10026)
	with LMTP id 02ZkzZrH+zkp for <linux-scsi@vger.kernel.org>;
	Sat, 14 Jan 2012 17:39:40 +0100 (CET)
Received: from asus.localnet (cust-30-27-110-94.dyn.as47377.net [94.110.27.30])
	by relay01ant.iops.be (Postfix) with ESMTP id EEA81208AB
	for <linux-scsi@vger.kernel.org>; Sat, 14 Jan 2012 17:39:37 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Reduce the number of complaints reported by sparse on the SCSI
midlayer.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/libiscsi.c   |    4 +++-
 drivers/scsi/scsi_lib.c   |    2 ++
 drivers/scsi/scsi_sysfs.c |    4 ++--
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 143bbe4..3faa45a 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1762,6 +1762,8 @@ static void iscsi_tmf_timedout(unsigned long data)
 static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
 				   struct iscsi_tm *hdr, int age,
 				   int timeout)
+	__releases(&conn->session->lock)
+	__acquires(&conn->session->lock)
 {
 	struct iscsi_session *session = conn->session;
 	struct iscsi_task *task;
@@ -2384,7 +2386,7 @@ static void iscsi_prep_tgt_reset_pdu(struct scsi_cmnd *sc, struct iscsi_tm *hdr)
  *
  * This will attempt to send a warm target reset.
  */
-int iscsi_eh_target_reset(struct scsi_cmnd *sc)
+static int iscsi_eh_target_reset(struct scsi_cmnd *sc)
 {
 	struct iscsi_cls_session *cls_session;
 	struct iscsi_session *session;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f85cfa6..67b60ea 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1485,6 +1485,8 @@ static void scsi_softirq_done(struct request *rq)
  * Lock status: IO request lock assumed to be held when called.
  */
 static void scsi_request_fn(struct request_queue *q)
+	__releases(q->queue_lock)
+	__acquires(q->queue_lock)
 {
 	struct scsi_device *sdev = q->queuedata;
 	struct Scsi_Host *shost;
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 04c2a27..fbff014 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -197,7 +197,7 @@ show_shost_state(struct device *dev, struct device_attribute *attr, char *buf)
 }
 
 /* DEVICE_ATTR(state) clashes with dev_attr_state for sdev */
-struct device_attribute dev_attr_hstate =
+static struct device_attribute dev_attr_hstate =
 	__ATTR(state, S_IRUGO | S_IWUSR, show_shost_state, store_shost_state);
 
 static ssize_t
@@ -313,7 +313,7 @@ static struct attribute *scsi_sysfs_shost_attrs[] = {
 	NULL
 };
 
-struct attribute_group scsi_shost_attr_group = {
+static struct attribute_group scsi_shost_attr_group = {
 	.attrs =	scsi_sysfs_shost_attrs,
 };
 
-- 
1.7.7


