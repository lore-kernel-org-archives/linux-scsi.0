From: Lad Prabhakar <prabhakar.csengg@gmail.com>
Subject: [PATCH] scsi: qla1280: fix sparse warnings
Date: Thu,  5 Feb 2015 12:34:56 +0000
Message-ID: <1423139696-397-1-git-send-email-prabhakar.csengg@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch fixes following sparse warnings:

qla1280.c:557:1: warning: symbol 'qla1280_firmware_mutex' was not declared. Should it be static?
qla1280.c:566:15: warning: symbol 'qla1280_fw_tbl' was not declared. Should it be static?

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 Found this issue on linux-next (gcc  version 4.9.2,
 sparse version  0.4.5-rc1)and applies on top linux-next.

 drivers/scsi/qla1280.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index c68a66e..cc99aa9 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -554,7 +554,7 @@ static struct pci_device_id qla1280_pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, qla1280_pci_tbl);
 
-DEFINE_MUTEX(qla1280_firmware_mutex);
+static DEFINE_MUTEX(qla1280_firmware_mutex);
 
 struct qla_fw {
 	char *fwname;
@@ -563,7 +563,7 @@ struct qla_fw {
 
 #define QL_NUM_FW_IMAGES 3
 
-struct qla_fw qla1280_fw_tbl[QL_NUM_FW_IMAGES] = {
+static struct qla_fw qla1280_fw_tbl[QL_NUM_FW_IMAGES] = {
 	{"qlogic/1040.bin",  NULL},	/* image 0 */
 	{"qlogic/1280.bin",  NULL},	/* image 1 */
 	{"qlogic/12160.bin", NULL},	/* image 2 */
-- 
1.9.1
