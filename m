From: Oleksandr Khoshaba <oleksandr.khoshaba@gmail.com>
Subject: [PATCH 2/2] scsi: qla2xxx: change some variables to hexadecimal string via %*phN format
Date: Sat, 29 Jun 2013 14:40:42 +0300
Message-ID: <1372506042-1317-1-git-send-email-Oleksandr.Khoshaba@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:43359 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468Ab3F2Lkv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Jun 2013 07:40:51 -0400
Received: by mail-wi0-f177.google.com with SMTP id ey16so1631629wid.10
        for <linux-scsi@vger.kernel.org>; Sat, 29 Jun 2013 04:40:49 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-driver@qlogic.com, "James E.J. Bottomley" <JBottomley@parallels.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>, Oleksandr Khoshaba <Oleksandr.Khoshaba@gmail.com>

The patch modifies some variables using the format '%*phN' and prints them as a hexadecimal string with the separator ''.

Signed-off-by: Oleksandr Khoshaba <Oleksandr.Khoshaba@gmail.com>
---
 drivers/scsi/qla2xxx/qla_gs.c  |   12 ++----------
 drivers/scsi/qla2xxx/qla_isr.c |    9 ++-------
 drivers/scsi/qla2xxx/qla_mr.c  |   10 ++--------
 3 files changed, 6 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 8b2f75a..4155e15 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1394,16 +1394,8 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *vha)
 	qla2x00_update_ms_fdmi_iocb(vha, size + 16);
 
 	ql_dbg(ql_dbg_disc, vha, 0x202e,
-	    "RHBA identifier = "
-	    "%02x%02x%02x%02x%02x%02x%02x%02x size=%d.\n",
-	    ct_req->req.rhba.hba_identifier[0],
-	    ct_req->req.rhba.hba_identifier[1],
-	    ct_req->req.rhba.hba_identifier[2],
-	    ct_req->req.rhba.hba_identifier[3],
-	    ct_req->req.rhba.hba_identifier[4],
-	    ct_req->req.rhba.hba_identifier[5],
-	    ct_req->req.rhba.hba_identifier[6],
-	    ct_req->req.rhba.hba_identifier[7], size);
+	    "RHBA identifier = %8phN size=%d.\n",
+	    ct_req->req.rhba.hba_identifier, size);
 	ql_dump_buffer(ql_dbg_disc + ql_dbg_buffer, vha, 0x2076,
 	    entries, size);
 
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index d2a4c75..b269682 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2212,16 +2212,11 @@ check_scsi_status:
 out:
 	if (logit)
 		ql_dbg(ql_dbg_io, fcport->vha, 0x3022,
-		    "FCP command status: 0x%x-0x%x (0x%x) "
-		    "nexus=%ld:%d:%d portid=%02x%02x%02x oxid=0x%x "
-		    "cdb=%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x len=0x%x "
-		    "rsp_info=0x%x resid=0x%x fw_resid=0x%x.\n",
+		    "FCP command status: 0x%x-0x%x (0x%x) nexus=%ld:%d:%d portid=%02x%02x%02x oxid=0x%x cdb=%10phN len=0x%x rsp_info=0x%x resid=0x%x fw_resid=0x%x.\n",
 		    comp_status, scsi_status, res, vha->host_no,
 		    cp->device->id, cp->device->lun, fcport->d_id.b.domain,
 		    fcport->d_id.b.area, fcport->d_id.b.al_pa, ox_id,
-		    cp->cmnd[0], cp->cmnd[1], cp->cmnd[2], cp->cmnd[3],
-		    cp->cmnd[4], cp->cmnd[5], cp->cmnd[6], cp->cmnd[7],
-		    cp->cmnd[8], cp->cmnd[9], scsi_bufflen(cp), rsp_info_len,
+		    cp->cmnd, scsi_bufflen(cp), rsp_info_len,
 		    resid_len, fw_resid_len);
 
 	if (!res)
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index a6df558..8c3ffcc 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -2517,16 +2517,10 @@ check_scsi_status:
 
 	if (logit)
 		ql_dbg(ql_dbg_io, fcport->vha, 0x3058,
-		    "FCP command status: 0x%x-0x%x (0x%x) "
-		    "nexus=%ld:%d:%d tgt_id: 0x%x lscsi_status: 0x%x"
-		    "cdb=%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x len=0x%x "
-		    "rsp_info=0x%x resid=0x%x fw_resid=0x%x "
-		    "sense_len=0x%x, par_sense_len=0x%x, rsp_info_len=0x%x\n",
+		    "FCP command status: 0x%x-0x%x (0x%x) nexus=%ld:%d:%d tgt_id: 0x%x lscsi_status: 0x%x cdb=%10phN len=0x%x rsp_info=0x%x resid=0x%x fw_resid=0x%x sense_len=0x%x, par_sense_len=0x%x, rsp_info_len=0x%x\n",
 		    comp_status, scsi_status, res, vha->host_no,
 		    cp->device->id, cp->device->lun, fcport->tgt_id,
-		    lscsi_status, cp->cmnd[0], cp->cmnd[1], cp->cmnd[2],
-		    cp->cmnd[3], cp->cmnd[4], cp->cmnd[5], cp->cmnd[6],
-		    cp->cmnd[7], cp->cmnd[8], cp->cmnd[9], scsi_bufflen(cp),
+		    lscsi_status, cp->cmnd, scsi_bufflen(cp),
 		    rsp_info_len, resid_len, fw_resid_len, sense_len,
 		    par_sense_len, rsp_info_len);
 
-- 
1.7.9.5

