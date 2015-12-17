From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH v2 14/16] qla2xxx: Set all queues to 4k
Date: Thu, 17 Dec 2015 14:57:09 -0500
Message-ID: <1450382231-4259-15-git-send-email-himanshu.madhani@qlogic.com>
References: <1450382231-4259-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:64810 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755839AbbLQUiB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Dec 2015 15:38:01 -0500
In-Reply-To: <1450382231-4259-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org, himanshu.madhani@qlogic.com

From: Quinn Tran <quinn.tran@qlogic.com>

set ATIO/Request/Response Queues and Default number
of outstanding command to 4k.

Signed-off-by: Quinn Tran <quinn.tran@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h |    3 ++-
 drivers/scsi/qla2xxx/qla_os.c  |    6 +++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 96c5ffe..9872f34 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -259,7 +259,7 @@
 #define LOOP_DOWN_TIME			255	/* 240 */
 #define	LOOP_DOWN_RESET			(LOOP_DOWN_TIME - 30)
 
-#define DEFAULT_OUTSTANDING_COMMANDS	1024
+#define DEFAULT_OUTSTANDING_COMMANDS	4096
 #define MIN_OUTSTANDING_COMMANDS	128
 
 /* ISP request and response entry counts (37-65535) */
@@ -267,6 +267,7 @@
 #define REQUEST_ENTRY_CNT_2200		2048	/* Number of request entries. */
 #define REQUEST_ENTRY_CNT_24XX		2048	/* Number of request entries. */
 #define REQUEST_ENTRY_CNT_83XX		8192	/* Number of request entries. */
+#define RESPONSE_ENTRY_CNT_83XX		4096	/* Number of response entries.*/
 #define RESPONSE_ENTRY_CNT_2100		64	/* Number of response entries.*/
 #define RESPONSE_ENTRY_CNT_2300		512	/* Number of response entries.*/
 #define RESPONSE_ENTRY_CNT_MQ		128	/* Number of response entries.*/
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index ad121fa..f1788db 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2483,7 +2483,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		ha->max_fibre_devices = MAX_FIBRE_DEVICES_2400;
 		ha->mbx_count = MAILBOX_REGISTER_COUNT;
 		req_length = REQUEST_ENTRY_CNT_83XX;
-		rsp_length = RESPONSE_ENTRY_CNT_2300;
+		rsp_length = RESPONSE_ENTRY_CNT_83XX;
 		ha->tgt.atio_q_length = ATIO_ENTRY_CNT_24XX;
 		ha->max_loop_id = SNS_LAST_LOOP_ID_2300;
 		ha->init_cb_size = sizeof(struct mid_init_cb_81xx);
@@ -2513,8 +2513,8 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		ha->portnum = PCI_FUNC(ha->pdev->devfn);
 		ha->max_fibre_devices = MAX_FIBRE_DEVICES_2400;
 		ha->mbx_count = MAILBOX_REGISTER_COUNT;
-		req_length = REQUEST_ENTRY_CNT_24XX;
-		rsp_length = RESPONSE_ENTRY_CNT_2300;
+		req_length = REQUEST_ENTRY_CNT_83XX;
+		rsp_length = RESPONSE_ENTRY_CNT_83XX;
 		ha->tgt.atio_q_length = ATIO_ENTRY_CNT_24XX;
 		ha->max_loop_id = SNS_LAST_LOOP_ID_2300;
 		ha->init_cb_size = sizeof(struct mid_init_cb_81xx);
-- 
1.7.7

