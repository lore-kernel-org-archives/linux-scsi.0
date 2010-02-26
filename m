From: Krishna Gudipati <kgudipat@brocade.com>
Subject: [PATCH 30/32] bfa: Handle SCSI IO underrun case.
Date: Thu, 25 Feb 2010 17:50:06 -0800
Message-ID: <1267149006-23668-1-git-send-email-kgudipat@blc-10-2.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.82]:59517 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934930Ab0BZBwS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2010 20:52:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, huangj@brocade.com, kgudipat@brocade.comKrishna Gudipati <kgudipat@brocade.com>

Change details:

	- When IO is completed with underrun and with good SCSI status, check if the
	  transferred bytes against scsi_cmnd->underflow, which is set to minimum
	  number of bytes that must be transferred for this command, if is less
	  than required minimum, complete the IO with DID_ERROR.
---
 drivers/scsi/bfa/bfad_im.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index cee3d89..fb7aefa 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -43,11 +43,11 @@ bfa_cb_ioim_done(void *drv, struct bfad_ioim_s *dio,
 	struct bfad_s         *bfad = drv;
 	struct bfad_itnim_data_s *itnim_data;
 	struct bfad_itnim_s *itnim;
+	u8         host_status = DID_OK;
 
 	switch (io_status) {
 	case BFI_IOIM_STS_OK:
 		bfa_trc(bfad, scsi_status);
-		cmnd->result = ScsiResult(DID_OK, scsi_status);
 		scsi_set_resid(cmnd, 0);
 
 		if (sns_len > 0) {
@@ -56,8 +56,18 @@ bfa_cb_ioim_done(void *drv, struct bfad_ioim_s *dio,
 				sns_len = SCSI_SENSE_BUFFERSIZE;
 			memcpy(cmnd->sense_buffer, sns_info, sns_len);
 		}
-		if (residue > 0)
+		if (residue > 0) {
+			bfa_trc(bfad, residue);
 			scsi_set_resid(cmnd, residue);
+			if (!sns_len && (scsi_status == SAM_STAT_GOOD) &&
+				(scsi_bufflen(cmnd) - residue) <
+					cmnd->underflow) {
+				bfa_trc(bfad, 0);
+				host_status = DID_ERROR;
+			}
+		}
+		cmnd->result = ScsiResult(host_status, scsi_status);
+
 		break;
 
 	case BFI_IOIM_STS_ABORTED:
-- 
1.6.5.3

