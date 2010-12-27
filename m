From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 5/8] [SCSI] scst: Improve sysfs parsing robustness
Date: Mon, 27 Dec 2010 14:39:40 +0100
Message-ID: <201012271439.40202.bvanassche@acm.org>
References: <201012271435.33778.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jester.euphonynet.be ([212.87.96.13]:52121 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777Ab0L0Nju (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Dec 2010 08:39:50 -0500
In-Reply-To: <201012271435.33778.bvanassche@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: scst-devel@lists.sourceforge.net, Greg Kroah-Hartman <gregkh@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Vladislav Bolkhovitin <vst@vlnb.net>, Richard Sharpe <realrichardsharpe@gmail.com>

Improve the robustness of the code for parsing management commands
received via the sysfs file /sys/devices/scst/mgmt. Allow several spaces
between parameters where only a single space was allowed, and consistenly
ignore trailing newlines.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scst/scst_sysfs.c |   85 ++++++++++++++++++++++++--------------------
 1 files changed, 46 insertions(+), 39 deletions(-)

diff --git a/drivers/scst/scst_sysfs.c b/drivers/scst/scst_sysfs.c
index ed10475..525f368 100644
--- a/drivers/scst/scst_sysfs.c
+++ b/drivers/scst/scst_sysfs.c
@@ -937,20 +937,24 @@ out_free:
 
 static int scst_process_tgt_mgmt_store(char *cmd, struct scst_tgt *tgt)
 {
+	char *arg, *tail;
 	int res;
 
 	res = -EINVAL;
+	arg = cmd;
+	cmd = scst_get_next_lexem(&arg);
+	tail = arg;
+	scst_get_next_lexem(&tail);
 	if (strcmp(cmd, "enable") == 0)
 		res = scst_process_tgt_enable_store(tgt, true);
 	else if (strcmp(cmd, "disable") == 0)
 		res = scst_process_tgt_enable_store(tgt, false);
-	else if (strncmp(cmd, "set_cpu_mask ", 13) == 0) {
+	else if (strcmp(cmd, "set_cpu_mask") == 0) {
 		cpumask_t *cpumask;
 
 		BUG_ON(!tgt->default_acg);
 
-		res = scst_alloc_and_parse_cpumask(&cpumask, cmd + 13,
-						   strlen(cmd + 13));
+		res = scst_alloc_and_parse_cpumask(&cpumask, arg, strlen(arg));
 		if (res)
 			goto out;
 		res = __scst_acg_process_cpu_mask_store(tgt, tgt->default_acg,
@@ -1264,20 +1268,25 @@ static const struct device_attribute *scst_devt_dev_attrs[] = {
 
 static int scst_process_dev_mgmt_store(char *cmd, struct scst_device *dev)
 {
+	char *arg, *tail;
 	int res;
 
 	res = -EINVAL;
-	if (strncmp(cmd, "set_filename ", 13) == 0) {
+	arg = cmd;
+	cmd = scst_get_next_lexem(&arg);
+	tail = arg;
+	scst_get_next_lexem(&tail);
+	if (strcmp(cmd, "set_filename") == 0) {
 		res = -EPERM;
 		if (!dev->handler->set_filename)
 			goto out;
-		res = dev->handler->set_filename(dev, cmd + 13);
-	} else if (strncmp(cmd, "set_threads_num ", 16) == 0) {
+		res = dev->handler->set_filename(dev, arg);
+	} else if (strcmp(cmd, "set_threads_num") == 0) {
 		long num_threads;
 
-		res = strict_strtol(cmd + 16, 0, &num_threads);
+		res = strict_strtol(arg, 0, &num_threads);
 		if (res) {
-			PRINT_ERROR("Bad thread count %s", cmd + 16);
+			PRINT_ERROR("Bad thread count %s", arg);
 			goto out;
 		}
 		if (num_threads < 0) {
@@ -1285,13 +1294,12 @@ static int scst_process_dev_mgmt_store(char *cmd, struct scst_device *dev)
 			goto out;
 		}
 		res = scst_dev_set_threads_num(dev, num_threads);
-	} else if (strncmp(cmd, "set_thread_pool_type ", 21) == 0) {
+	} else if (strcmp(cmd, "set_thread_pool_type") == 0) {
 		enum scst_dev_type_threads_pool_type newtpt;
 
-		newtpt = scst_parse_threads_pool_type(cmd + 21,
-						      strlen(cmd + 21));
+		newtpt = scst_parse_threads_pool_type(arg, strlen(arg));
 		if (newtpt == SCST_THREADS_POOL_TYPE_INVALID) {
-			PRINT_ERROR("Invalid thread pool type %s", cmd + 21);
+			PRINT_ERROR("Invalid thread pool type %s", arg);
 			goto out;
 		}
 		res = scst_dev_set_thread_pool_type(dev, newtpt);
@@ -2095,16 +2103,20 @@ out_del:
  ** ini_groups directory implementation.
  **/
 
-static int scst_process_acg_mgmt_store(const char *cmd, struct scst_acg *acg)
+static int scst_process_acg_mgmt_store(char *cmd, struct scst_acg *acg)
 {
+	char *arg, *tail;
 	int res;
 
 	res = -EINVAL;
-	if (strncmp(cmd, "set_cpu_mask ", 13) == 0) {
+	arg = cmd;
+	cmd = scst_get_next_lexem(&arg);
+	tail = arg;
+	scst_get_next_lexem(&tail);
+	if (strcmp(cmd, "set_cpu_mask") == 0) {
 		cpumask_t *cpumask;
 
-		res = scst_alloc_and_parse_cpumask(&cpumask, cmd + 13,
-						   strlen(cmd + 13));
+		res = scst_alloc_and_parse_cpumask(&cpumask, arg, strlen(arg));
 		if (res)
 			goto out;
 		res = __scst_acg_process_cpu_mask_store(acg->tgt, acg, cpumask);
@@ -3390,7 +3402,7 @@ static ssize_t scst_mgmt_store(struct device *device,
 	struct device_attribute *attr, const char *buf, size_t count)
 {
 	ssize_t res;
-	char *buffer, *path, *path_end, *cmd;
+	char *buffer, *path, *cmd, *tail;
 	enum mgmt_path_type mgmt_path_type;
 	struct scst_dev_type *devt;
 	struct scst_device *dev;
@@ -3409,19 +3421,13 @@ static ssize_t scst_mgmt_store(struct device *device,
 		goto out;
 
 	res = -EINVAL;
-	if (strncmp(buffer, "in ", 3) != 0)
+	path = buffer;
+	cmd = scst_get_next_lexem(&path);
+	if (strcmp(cmd, "in") != 0)
 		goto out;
 
-	path = buffer + 3;
-	while (*path && isspace((u8)*path))
-		path++;
-	path_end = path;
-	while (*path_end && !isspace((u8)*path_end))
-		path_end++;
-	*path_end++ = '\0';
-	cmd = path_end;
-	while (*cmd && isspace((u8)*cmd))
-		cmd++;
+	tail = path;
+	scst_get_next_lexem(&tail);
 
 	res = scst_suspend_activity(true);
 	if (res)
@@ -3437,36 +3443,37 @@ static ssize_t scst_mgmt_store(struct device *device,
 	res = -EINVAL;
 	switch (mgmt_path_type) {
 	case DEVICE_PATH:
-		res = scst_process_dev_mgmt_store(cmd, dev);
+		res = scst_process_dev_mgmt_store(tail, dev);
 		break;
 	case DEVICE_TYPE_PATH:
 		if (devt->add_device)
-			res = scst_process_devt_mgmt_store(cmd, devt);
+			res = scst_process_devt_mgmt_store(tail, devt);
 		else
-			res = scst_process_devt_pass_through_mgmt_store(cmd,
+			res = scst_process_devt_pass_through_mgmt_store(tail,
 									devt);
 		break;
 	case TARGET_TEMPLATE_PATH:
-		res = scst_process_tgtt_mgmt_store(cmd, tgtt);
+		res = scst_process_tgtt_mgmt_store(tail, tgtt);
 		break;
 	case TARGET_PATH:
-		res = scst_process_tgt_mgmt_store(cmd, tgt);
+		res = scst_process_tgt_mgmt_store(tail, tgt);
 		break;
 	case TARGET_LUNS_PATH:
-		res = __scst_process_luns_mgmt_store(cmd, tgt, tgt->default_acg,
-						     true);
+		res = __scst_process_luns_mgmt_store(tail, tgt,
+						     tgt->default_acg, true);
 		break;
 	case TARGET_INI_GROUPS_PATH:
-		res = scst_process_ini_group_mgmt_store(cmd, tgt);
+		res = scst_process_ini_group_mgmt_store(tail, tgt);
 		break;
 	case ACG_PATH:
-		res = scst_process_acg_mgmt_store(cmd, acg);
+		res = scst_process_acg_mgmt_store(tail, acg);
 		break;
 	case ACG_LUNS_PATH:
-		res = __scst_process_luns_mgmt_store(cmd, acg->tgt, acg, false);
+		res = __scst_process_luns_mgmt_store(tail, acg->tgt, acg,
+						     false);
 		break;
 	case ACG_INITIATOR_GROUPS_PATH:
-		res = scst_process_acg_ini_mgmt_store(cmd, acg->tgt, acg);
+		res = scst_process_acg_ini_mgmt_store(tail, acg->tgt, acg);
 		break;
 	case PATH_NOT_RECOGNIZED:
 		break;
-- 
1.7.1

