From: Baoyou Xie <baoyou.xie@linaro.org>
Subject: [PATCH] scsi: be2iscsi: mark symbols static where possible
Date: Mon, 26 Sep 2016 20:00:59 +0800
Message-ID: <1474891259-20031-1-git-send-email-baoyou.xie@linaro.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:34881 "EHLO
        mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965898AbcIZMBT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Sep 2016 08:01:19 -0400
Received: by mail-pa0-f42.google.com with SMTP id oz2so62480604pac.2
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2016 05:01:19 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: subbu.seetharaman@broadcom.com, ketan.mukadam@broadcom.com, jitendra.bhivare@broadcom.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, baoyou.xie@linaro.org, xie.baoyou@zte.com.cn, han.fei@zte.com.cn, tang.qiang007@zte.com.cn

We get 6 warnings when building kernel with W=1:
drivers/scsi/be2iscsi/be_main.c:65:1: warning: no previous prototype for 'beiscsi_log_enable_disp' [-Wmissing-prototypes]
drivers/scsi/be2iscsi/be_main.c:78:1: warning: no previous prototype for 'beiscsi_log_enable_change' [-Wmissing-prototypes]
drivers/scsi/be2iscsi/be_main.c:97:1: warning: no previous prototype for 'beiscsi_log_enable_store' [-Wmissing-prototypes]
drivers/scsi/be2iscsi/be_main.c:116:1: warning: no previous prototype for 'beiscsi_log_enable_init' [-Wmissing-prototypes]
drivers/scsi/be2iscsi/be_main.c:4587:5: warning: no previous prototype for 'beiscsi_iotask_v2' [-Wmissing-prototypes]
drivers/scsi/be2iscsi/be_main.c:4976:6: warning: no previous prototype for 'beiscsi_hba_attrs_init' [-Wmissing-prototypes]

In fact, these functions are only used in the file in which they are
declared and don't need a declaration, but can be made static.

So this patch marks these functions with 'static'.

Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>
---
 drivers/scsi/be2iscsi/be_main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 6a6906f..68138a6 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -61,7 +61,7 @@ MODULE_PARM_DESC(be_max_phys_size,
 		"memory that can be allocated. Range is 16 - 128");
 
 #define beiscsi_disp_param(_name)\
-ssize_t	\
+static ssize_t	\
 beiscsi_##_name##_disp(struct device *dev,\
 			struct device_attribute *attrib, char *buf)	\
 {	\
@@ -74,7 +74,7 @@ beiscsi_##_name##_disp(struct device *dev,\
 }
 
 #define beiscsi_change_param(_name, _minval, _maxval, _defaval)\
-int \
+static int \
 beiscsi_##_name##_change(struct beiscsi_hba *phba, uint32_t val)\
 {\
 	if (val >= _minval && val <= _maxval) {\
@@ -93,7 +93,7 @@ beiscsi_##_name##_change(struct beiscsi_hba *phba, uint32_t val)\
 }
 
 #define beiscsi_store_param(_name)  \
-ssize_t \
+static ssize_t \
 beiscsi_##_name##_store(struct device *dev,\
 			 struct device_attribute *attr, const char *buf,\
 			 size_t count) \
@@ -112,7 +112,7 @@ beiscsi_##_name##_store(struct device *dev,\
 }
 
 #define beiscsi_init_param(_name, _minval, _maxval, _defval) \
-int \
+static int \
 beiscsi_##_name##_init(struct beiscsi_hba *phba, uint32_t val) \
 { \
 	if (val >= _minval && val <= _maxval) {\
@@ -4584,7 +4584,7 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 	io_task->cmd_bhs = NULL;
 	return -ENOMEM;
 }
-int beiscsi_iotask_v2(struct iscsi_task *task, struct scatterlist *sg,
+static int beiscsi_iotask_v2(struct iscsi_task *task, struct scatterlist *sg,
 		       unsigned int num_sg, unsigned int xferlen,
 		       unsigned int writedir)
 {
@@ -4973,7 +4973,7 @@ static int beiscsi_bsg_request(struct bsg_job *job)
 	return rc;
 }
 
-void beiscsi_hba_attrs_init(struct beiscsi_hba *phba)
+static void beiscsi_hba_attrs_init(struct beiscsi_hba *phba)
 {
 	/* Set the logging parameter */
 	beiscsi_log_enable_init(phba, beiscsi_log_enable);
-- 
2.7.4

