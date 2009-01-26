From: "ed.lin" <ed.lin@promise.com>
Subject: [PATCH 3/5][resend 2] stex: Fix for controller type st_yosemite
Date: Tue, 27 Jan 2009 06:36:12 +0800
Message-ID: <200901270636.12566.ed.lin@promise.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gateway.promise.com ([67.111.72.2]:23240 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752113AbZA0GgE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jan 2009 01:36:04 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org

This is the fix for controller type st_yosemite, including:
- max_lun is 256 (backward compatible)
- remove unneeded special handling of INQUIRY
- remove unnecessary listing of sub device ids

Signed-off-by: Ed Lin <ed.lin@promise.com>
---

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 12dc0d1..425a61c 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -153,35 +153,6 @@ enum {
  ST_ADDITIONAL_MEM   = 0x200000,
 };
 
-/* SCSI inquiry data */
-typedef struct st_inq {
- u8 DeviceType   :5;
- u8 DeviceTypeQualifier  :3;
- u8 DeviceTypeModifier  :7;
- u8 RemovableMedia  :1;
- u8 Versions;
- u8 ResponseDataFormat  :4;
- u8 HiSupport   :1;
- u8 NormACA   :1;
- u8 ReservedBit   :1;
- u8 AERC    :1;
- u8 AdditionalLength;
- u8 Reserved[2];
- u8 SoftReset   :1;
- u8 CommandQueue   :1;
- u8 Reserved2   :1;
- u8 LinkedCommands  :1;
- u8 Synchronous   :1;
- u8 Wide16Bit   :1;
- u8 Wide32Bit   :1;
- u8 RelativeAddressing  :1;
- u8 VendorId[8];
- u8 ProductId[16];
- u8 ProductRevisionLevel[4];
- u8 VendorSpecific[20];
- u8 Reserved3[40];
-} ST_INQ;
-
 struct st_sgitem {
  u8 ctrl; /* SG_CF_xxx */
  u8 reserved[3];
@@ -285,7 +256,7 @@ struct st_drvver {
 #define MU_REQ_BUFFER_SIZE (MU_REQ_COUNT * sizeof(struct req_msg))
 #define MU_STATUS_BUFFER_SIZE (MU_STATUS_COUNT * sizeof(struct status_msg))
 #define MU_BUFFER_SIZE  (MU_REQ_BUFFER_SIZE + MU_STATUS_BUFFER_SIZE)
-#define STEX_EXTRA_SIZE  max(sizeof(struct st_frame), sizeof(ST_INQ))
+#define STEX_EXTRA_SIZE  sizeof(struct st_frame)
 #define STEX_BUFFER_SIZE (MU_BUFFER_SIZE + STEX_EXTRA_SIZE)
 
 struct st_ccb {
@@ -662,24 +633,6 @@ static void stex_ys_commands(struct st_hba *hba,
   resp->scsi_status != SAM_STAT_CHECK_CONDITION) {
   scsi_set_resid(ccb->cmd, scsi_bufflen(ccb->cmd) -
    le32_to_cpu(*(__le32 *)&resp->variable[0]));
-  return;
- }
-
- if (resp->srb_status != 0)
-  return;
-
- /* determine inquiry command status by DeviceTypeQualifier */
- if (ccb->cmd->cmnd[0] == INQUIRY &&
-  resp->scsi_status == SAM_STAT_GOOD) {
-  ST_INQ *inq_data;
-
-  scsi_sg_copy_to_buffer(ccb->cmd, hba->copy_buffer,
-           STEX_EXTRA_SIZE);
-  inq_data = (ST_INQ *)hba->copy_buffer;
-  if (inq_data->DeviceTypeQualifier != 0)
-   ccb->srb_status = SRB_STATUS_SELECTION_TIMEOUT;
-  else
-   ccb->srb_status = SRB_STATUS_SUCCESS;
  }
 }
 
@@ -1148,7 +1101,7 @@ stex_probe(struct pci_dev *pdev, const struct pci_device_id *id)
   host->max_lun = 8;
   host->max_id = 16 + 1;
  } else if (hba->cardtype == st_yosemite) {
-  host->max_lun = 128;
+  host->max_lun = 256;
   host->max_id = 1 + 1;
  } else {
   /* st_vsc , st_vsc1 and st_seq */
@@ -1301,18 +1254,7 @@ static struct pci_device_id stex_pci_tbl[] = {
  { 0x105a, 0x7250, PCI_ANY_ID, PCI_ANY_ID, 0, 0, st_vsc },
 
  /* st_yosemite */
- { 0x105a, 0x8650, PCI_ANY_ID, 0x4600, 0, 0,
-  st_yosemite }, /* SuperTrak EX4650 */
- { 0x105a, 0x8650, PCI_ANY_ID, 0x4610, 0, 0,
-  st_yosemite }, /* SuperTrak EX4650o */
- { 0x105a, 0x8650, PCI_ANY_ID, 0x8600, 0, 0,
-  st_yosemite }, /* SuperTrak EX8650EL */
- { 0x105a, 0x8650, PCI_ANY_ID, 0x8601, 0, 0,
-  st_yosemite }, /* SuperTrak EX8650 */
- { 0x105a, 0x8650, PCI_ANY_ID, 0x8602, 0, 0,
-  st_yosemite }, /* SuperTrak EX8654 */
- { 0x105a, 0x8650, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-  st_yosemite }, /* generic st_yosemite */
+ { 0x105a, 0x8650, PCI_ANY_ID, PCI_ANY_ID, 0, 0, st_yosemite },
 
  /* st_seq */
  { 0x105a, 0x3360, PCI_ANY_ID, PCI_ANY_ID, 0, 0, st_seq },
