From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 01/29] qla2xxx: Print some variables to hexadecimal string via %*phN format
Date: Tue, 27 Aug 2013 01:37:27 -0400
Message-ID: <1377581875-8574-2-git-send-email-saurav.kashyap@qlogic.com>
References: <1377581875-8574-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:51744 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752643Ab3H0GGd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Aug 2013 02:06:33 -0400
Received: from pps.filterd (m0000643.ppops.net [127.0.0.1])
	by mx0b-0016ce01.pphosted.com (8.14.5/8.14.5) with SMTP id r7R63vVf012060
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 23:06:32 -0700
Received: from avcashub1.qlogic.com (avcashub1.qlogic.com [198.70.193.115])
	by mx0b-0016ce01.pphosted.com with ESMTP id 1e5gq13pa5-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 23:06:32 -0700
In-Reply-To: <1377581875-8574-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Oleksandr Khoshaba <Oleksandr.Khoshaba@gmail.com>

The patch changes a specifier used to output some variables. Instead of using
stack for each byte the '%*ph[CN]' allows to take a one pointer and prints
entire buffer as a hexadecimal string with the separator ':' or ''.

Signed-off-by: Oleksandr Khoshaba <Oleksandr.Khoshaba@gmail.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c     |    9 +--
 drivers/scsi/qla2xxx/qla_gs.c      |   91 ++++++------------------------------
 drivers/scsi/qla2xxx/qla_init.c    |   24 ++--------
 drivers/scsi/qla2xxx/qla_isr.c     |    9 +--
 drivers/scsi/qla2xxx/qla_mr.c      |   13 ++---
 drivers/scsi/qla2xxx/qla_os.c      |   10 +---
 drivers/scsi/qla2xxx/qla_target.c  |   69 ++++++++-------------------
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |   14 ++----
 8 files changed, 58 insertions(+), 181 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 417eaad..2dbae07 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1318,12 +1318,9 @@ qla24xx_iidma(struct fc_bsg_job *bsg_job)
 
 	if (rval) {
 		ql_log(ql_log_warn, vha, 0x704c,
-		    "iIDMA cmd failed for %02x%02x%02x%02x%02x%02x%02x%02x -- "
-		    "%04x %x %04x %04x.\n", fcport->port_name[0],
-		    fcport->port_name[1], fcport->port_name[2],
-		    fcport->port_name[3], fcport->port_name[4],
-		    fcport->port_name[5], fcport->port_name[6],
-		    fcport->port_name[7], rval, fcport->fp_speed, mb[0], mb[1]);
+		    "iIDMA cmd failed for %8phN -- "
+		    "%04x %x %04x %04x.\n", fcport->port_name,
+		    rval, fcport->fp_speed, mb[0], mb[1]);
 		rval = (DID_ERROR << 16);
 	} else {
 		if (!port_param->mode) {
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 0926451..84cce36 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -226,17 +226,9 @@ qla2x00_ga_nxt(scsi_qla_host_t *vha, fc_port_t *fcport)
 			fcport->d_id.b.domain = 0xf0;
 
 		ql_dbg(ql_dbg_disc, vha, 0x2063,
-		    "GA_NXT entry - nn %02x%02x%02x%02x%02x%02x%02x%02x "
-		    "pn %02x%02x%02x%02x%02x%02x%02x%02x "
+		    "GA_NXT entry - nn %8phN pn %8phN "
 		    "port_id=%02x%02x%02x.\n",
-		    fcport->node_name[0], fcport->node_name[1],
-		    fcport->node_name[2], fcport->node_name[3],
-		    fcport->node_name[4], fcport->node_name[5],
-		    fcport->node_name[6], fcport->node_name[7],
-		    fcport->port_name[0], fcport->port_name[1],
-		    fcport->port_name[2], fcport->port_name[3],
-		    fcport->port_name[4], fcport->port_name[5],
-		    fcport->port_name[6], fcport->port_name[7],
+		    fcport->node_name, fcport->port_name,
 		    fcport->d_id.b.domain, fcport->d_id.b.area,
 		    fcport->d_id.b.al_pa);
 	}
@@ -447,17 +439,9 @@ qla2x00_gnn_id(scsi_qla_host_t *vha, sw_info_t *list)
 			    ct_rsp->rsp.gnn_id.node_name, WWN_SIZE);
 
 			ql_dbg(ql_dbg_disc, vha, 0x2058,
-			    "GID_PT entry - nn %02x%02x%02x%02x%02x%02x%02X%02x "
-			    "pn %02x%02x%02x%02x%02x%02x%02X%02x "
+			    "GID_PT entry - nn %8phN pn %8phN "
 			    "portid=%02x%02x%02x.\n",
-			    list[i].node_name[0], list[i].node_name[1],
-			    list[i].node_name[2], list[i].node_name[3],
-			    list[i].node_name[4], list[i].node_name[5],
-			    list[i].node_name[6], list[i].node_name[7],
-			    list[i].port_name[0], list[i].port_name[1],
-			    list[i].port_name[2], list[i].port_name[3],
-			    list[i].port_name[4], list[i].port_name[5],
-			    list[i].port_name[6], list[i].port_name[7],
+			    list[i].node_name, list[i].port_name,
 			    list[i].d_id.b.domain, list[i].d_id.b.area,
 			    list[i].d_id.b.al_pa);
 		}
@@ -796,17 +780,9 @@ qla2x00_sns_ga_nxt(scsi_qla_host_t *vha, fc_port_t *fcport)
 			fcport->d_id.b.domain = 0xf0;
 
 		ql_dbg(ql_dbg_disc, vha, 0x2061,
-		    "GA_NXT entry - nn %02x%02x%02x%02x%02x%02x%02x%02x "
-		    "pn %02x%02x%02x%02x%02x%02x%02x%02x "
+		    "GA_NXT entry - nn %8phN pn %8phN "
 		    "port_id=%02x%02x%02x.\n",
-		    fcport->node_name[0], fcport->node_name[1],
-		    fcport->node_name[2], fcport->node_name[3],
-		    fcport->node_name[4], fcport->node_name[5],
-		    fcport->node_name[6], fcport->node_name[7],
-		    fcport->port_name[0], fcport->port_name[1],
-		    fcport->port_name[2], fcport->port_name[3],
-		    fcport->port_name[4], fcport->port_name[5],
-		    fcport->port_name[6], fcport->port_name[7],
+		    fcport->node_name, fcport->port_name,
 		    fcport->d_id.b.domain, fcport->d_id.b.area,
 		    fcport->d_id.b.al_pa);
 	}
@@ -991,17 +967,9 @@ qla2x00_sns_gnn_id(scsi_qla_host_t *vha, sw_info_t *list)
 			    WWN_SIZE);
 
 			ql_dbg(ql_dbg_disc, vha, 0x206e,
-			    "GID_PT entry - nn %02x%02x%02x%02x%02x%02x%02x%02x "
-			    "pn %02x%02x%02x%02x%02x%02x%02x%02x "
+			    "GID_PT entry - nn %8phN pn %8phN "
 			    "port_id=%02x%02x%02x.\n",
-			    list[i].node_name[0], list[i].node_name[1],
-			    list[i].node_name[2], list[i].node_name[3],
-			    list[i].node_name[4], list[i].node_name[5],
-			    list[i].node_name[6], list[i].node_name[7],
-			    list[i].port_name[0], list[i].port_name[1],
-			    list[i].port_name[2], list[i].port_name[3],
-			    list[i].port_name[4], list[i].port_name[5],
-			    list[i].port_name[6], list[i].port_name[7],
+			    list[i].node_name, list[i].port_name,
 			    list[i].d_id.b.domain, list[i].d_id.b.area,
 			    list[i].d_id.b.al_pa);
 		}
@@ -1321,11 +1289,7 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *vha)
 	size += 4 + WWN_SIZE;
 
 	ql_dbg(ql_dbg_disc, vha, 0x2025,
-	    "NodeName = %02x%02x%02x%02x%02x%02x%02x%02x.\n",
-	    eiter->a.node_name[0], eiter->a.node_name[1],
-	    eiter->a.node_name[2], eiter->a.node_name[3],
-	    eiter->a.node_name[4], eiter->a.node_name[5],
-	    eiter->a.node_name[6], eiter->a.node_name[7]);
+	    "NodeName = %8phN.\n", eiter->a.node_name);
 
 	/* Manufacturer. */
 	eiter = (struct ct_fdmi_hba_attr *) (entries + size);
@@ -1428,16 +1392,8 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *vha)
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
 
@@ -1494,11 +1450,7 @@ qla2x00_fdmi_dhba(scsi_qla_host_t *vha)
 	memcpy(ct_req->req.dhba.port_name, vha->port_name, WWN_SIZE);
 
 	ql_dbg(ql_dbg_disc, vha, 0x2036,
-	    "DHBA portname = %02x%02x%02x%02x%02x%02x%02x%02x.\n",
-	    ct_req->req.dhba.port_name[0], ct_req->req.dhba.port_name[1],
-	    ct_req->req.dhba.port_name[2], ct_req->req.dhba.port_name[3],
-	    ct_req->req.dhba.port_name[4], ct_req->req.dhba.port_name[5],
-	    ct_req->req.dhba.port_name[6], ct_req->req.dhba.port_name[7]);
+	    "DHBA portname = %8phN.\n", ct_req->req.dhba.port_name);
 
 	/* Execute MS IOCB */
 	rval = qla2x00_issue_iocb(vha, ha->ms_iocb, ha->ms_iocb_dma,
@@ -1678,12 +1630,7 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *vha)
 	qla2x00_update_ms_fdmi_iocb(vha, size + 16);
 
 	ql_dbg(ql_dbg_disc, vha, 0x203e,
-	    "RPA portname= %02x%02x%02x%02x%02X%02x%02x%02x size=%d.\n",
-	    ct_req->req.rpa.port_name[0], ct_req->req.rpa.port_name[1],
-	    ct_req->req.rpa.port_name[2], ct_req->req.rpa.port_name[3],
-	    ct_req->req.rpa.port_name[4], ct_req->req.rpa.port_name[5],
-	    ct_req->req.rpa.port_name[6], ct_req->req.rpa.port_name[7],
-	    size);
+	    "RPA portname= %8phN size=%d.\n", ct_req->req.rpa.port_name, size);
 	ql_dump_buffer(ql_dbg_disc + ql_dbg_buffer, vha, 0x2079,
 	    entries, size);
 
@@ -1940,16 +1887,8 @@ qla2x00_gpsc(scsi_qla_host_t *vha, sw_info_t *list)
 
 			ql_dbg(ql_dbg_disc, vha, 0x205b,
 			    "GPSC ext entry - fpn "
-			    "%02x%02x%02x%02x%02x%02x%02x%02x speeds=%04x "
-			    "speed=%04x.\n",
-			    list[i].fabric_port_name[0],
-			    list[i].fabric_port_name[1],
-			    list[i].fabric_port_name[2],
-			    list[i].fabric_port_name[3],
-			    list[i].fabric_port_name[4],
-			    list[i].fabric_port_name[5],
-			    list[i].fabric_port_name[6],
-			    list[i].fabric_port_name[7],
+			    "%8phN speeds=%04x speed=%04x.\n",
+			    list[i].fabric_port_name,
 			    be16_to_cpu(ct_rsp->rsp.gpsc.speeds),
 			    be16_to_cpu(ct_rsp->rsp.gpsc.speed));
 		}
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index f2216ed..d60e2c1 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -564,12 +564,7 @@ qla2x00_initialize_adapter(scsi_qla_host_t *vha)
 	if (ha->flags.disable_serdes) {
 		/* Mask HBA via NVRAM settings? */
 		ql_log(ql_log_info, vha, 0x0077,
-		    "Masking HBA WWPN "
-		    "%02x%02x%02x%02x%02x%02x%02x%02x (via NVRAM).\n",
-		    vha->port_name[0], vha->port_name[1],
-		    vha->port_name[2], vha->port_name[3],
-		    vha->port_name[4], vha->port_name[5],
-		    vha->port_name[6], vha->port_name[7]);
+		    "Masking HBA WWPN %8phN (via NVRAM).\n", vha->port_name);
 		return QLA_FUNCTION_FAILED;
 	}
 
@@ -3061,22 +3056,13 @@ qla2x00_iidma_fcport(scsi_qla_host_t *vha, fc_port_t *fcport)
 	    mb);
 	if (rval != QLA_SUCCESS) {
 		ql_dbg(ql_dbg_disc, vha, 0x2004,
-		    "Unable to adjust iIDMA "
-		    "%02x%02x%02x%02x%02x%02x%02x%02x -- %04x %x %04x "
-		    "%04x.\n", fcport->port_name[0], fcport->port_name[1],
-		    fcport->port_name[2], fcport->port_name[3],
-		    fcport->port_name[4], fcport->port_name[5],
-		    fcport->port_name[6], fcport->port_name[7], rval,
-		    fcport->fp_speed, mb[0], mb[1]);
+		    "Unable to adjust iIDMA %8phN -- %04x %x %04x %04x.\n",
+		    fcport->port_name, rval, fcport->fp_speed, mb[0], mb[1]);
 	} else {
 		ql_dbg(ql_dbg_disc, vha, 0x2005,
-		    "iIDMA adjusted to %s GB/s "
-		    "on %02x%02x%02x%02x%02x%02x%02x%02x.\n",
+		    "iIDMA adjusted to %s GB/s on %8phN.\n",
 		    qla2x00_get_link_speed_str(ha, fcport->fp_speed),
-		    fcport->port_name[0], fcport->port_name[1],
-		    fcport->port_name[2], fcport->port_name[3],
-		    fcport->port_name[4], fcport->port_name[5],
-		    fcport->port_name[6], fcport->port_name[7]);
+		    fcport->port_name);
 	}
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 2d8e7b8..e779506 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2212,16 +2212,13 @@ check_scsi_status:
 out:
 	if (logit)
 		ql_dbg(ql_dbg_io, fcport->vha, 0x3022,
-		    "FCP command status: 0x%x-0x%x (0x%x) "
-		    "nexus=%ld:%d:%d portid=%02x%02x%02x oxid=0x%x "
-		    "cdb=%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x len=0x%x "
+		    "FCP command status: 0x%x-0x%x (0x%x) nexus=%ld:%d:%d "
+		    "portid=%02x%02x%02x oxid=0x%x cdb=%10phN len=0x%x "
 		    "rsp_info=0x%x resid=0x%x fw_resid=0x%x.\n",
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
index d799379..413f050 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -2526,16 +2526,13 @@ check_scsi_status:
 
 	if (logit)
 		ql_dbg(ql_dbg_io, fcport->vha, 0x3058,
-		    "FCP command status: 0x%x-0x%x (0x%x) "
-		    "nexus=%ld:%d:%d tgt_id: 0x%x lscsi_status: 0x%x"
-		    "cdb=%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x len=0x%x "
-		    "rsp_info=0x%x resid=0x%x fw_resid=0x%x "
-		    "sense_len=0x%x, par_sense_len=0x%x, rsp_info_len=0x%x\n",
+		    "FCP command status: 0x%x-0x%x (0x%x) nexus=%ld:%d:%d "
+		    "tgt_id: 0x%x lscsi_status: 0x%x cdb=%10phN len=0x%x "
+		    "rsp_info=0x%x resid=0x%x fw_resid=0x%x sense_len=0x%x, "
+		    "par_sense_len=0x%x, rsp_info_len=0x%x\n",
 		    comp_status, scsi_status, res, vha->host_no,
 		    cp->device->id, cp->device->lun, fcport->tgt_id,
-		    lscsi_status, cp->cmnd[0], cp->cmnd[1], cp->cmnd[2],
-		    cp->cmnd[3], cp->cmnd[4], cp->cmnd[5], cp->cmnd[6],
-		    cp->cmnd[7], cp->cmnd[8], cp->cmnd[9], scsi_bufflen(cp),
+		    lscsi_status, cp->cmnd, scsi_bufflen(cp),
 		    rsp_info_len, resid_len, fw_resid_len, sense_len,
 		    par_sense_len, rsp_info_len);
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 3e21e9f..9207aeb 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3210,14 +3210,8 @@ void qla2x00_mark_device_lost(scsi_qla_host_t *vha, fc_port_t *fcport,
 		set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 
 		ql_dbg(ql_dbg_disc, vha, 0x2067,
-		    "Port login retry "
-		    "%02x%02x%02x%02x%02x%02x%02x%02x, "
-		    "id = 0x%04x retry cnt=%d.\n",
-		    fcport->port_name[0], fcport->port_name[1],
-		    fcport->port_name[2], fcport->port_name[3],
-		    fcport->port_name[4], fcport->port_name[5],
-		    fcport->port_name[6], fcport->port_name[7],
-		    fcport->loop_id, fcport->login_retry);
+		    "Port login retry %8phN, id = 0x%04x retry cnt=%d.\n",
+		    fcport->port_name, fcport->loop_id, fcport->login_retry);
 	}
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 83a8f7a..ff12d46 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -430,13 +430,8 @@ static int qlt_reset(struct scsi_qla_host *vha, void *iocb, int mcmd)
 	}
 
 	ql_dbg(ql_dbg_tgt, vha, 0xe047,
-	    "scsi(%ld): resetting (session %p from port "
-	    "%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x, "
-	    "mcmd %x, loop_id %d)\n", vha->host_no, sess,
-	    sess->port_name[0], sess->port_name[1],
-	    sess->port_name[2], sess->port_name[3],
-	    sess->port_name[4], sess->port_name[5],
-	    sess->port_name[6], sess->port_name[7],
+	    "scsi(%ld): resetting (session %p from port %8phC mcmd %x, "
+	    "loop_id %d)\n", vha->host_no, sess, sess->port_name,
 	    mcmd, loop_id);
 
 	lun = a->u.isp24.fcp_cmnd.lun;
@@ -467,15 +462,10 @@ static void qlt_schedule_sess_for_deletion(struct qla_tgt_sess *sess,
 	sess->expires = jiffies + dev_loss_tmo * HZ;
 
 	ql_dbg(ql_dbg_tgt, sess->vha, 0xe048,
-	    "qla_target(%d): session for port %02x:%02x:%02x:"
-	    "%02x:%02x:%02x:%02x:%02x (loop ID %d) scheduled for "
+	    "qla_target(%d): session for port %8phC (loop ID %d) scheduled for "
 	    "deletion in %u secs (expires: %lu) immed: %d\n",
-	    sess->vha->vp_idx,
-	    sess->port_name[0], sess->port_name[1],
-	    sess->port_name[2], sess->port_name[3],
-	    sess->port_name[4], sess->port_name[5],
-	    sess->port_name[6], sess->port_name[7],
-	    sess->loop_id, dev_loss_tmo, sess->expires, immediate);
+	    sess->vha->vp_idx, sess->port_name, sess->loop_id, dev_loss_tmo,
+	    sess->expires, immediate);
 
 	if (immediate)
 		schedule_delayed_work(&tgt->sess_del_work, 0);
@@ -630,13 +620,9 @@ static struct qla_tgt_sess *qlt_create_sess(
 	sess = kzalloc(sizeof(*sess), GFP_KERNEL);
 	if (!sess) {
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf04a,
-		    "qla_target(%u): session allocation failed, "
-		    "all commands from port %02x:%02x:%02x:%02x:"
-		    "%02x:%02x:%02x:%02x will be refused", vha->vp_idx,
-		    fcport->port_name[0], fcport->port_name[1],
-		    fcport->port_name[2], fcport->port_name[3],
-		    fcport->port_name[4], fcport->port_name[5],
-		    fcport->port_name[6], fcport->port_name[7]);
+		    "qla_target(%u): session allocation failed, all commands "
+		    "from port %8phC will be refused", vha->vp_idx,
+		    fcport->port_name);
 
 		return NULL;
 	}
@@ -680,15 +666,11 @@ static struct qla_tgt_sess *qlt_create_sess(
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf04b,
-	    "qla_target(%d): %ssession for wwn %02x:%02x:%02x:%02x:"
-	    "%02x:%02x:%02x:%02x (loop_id %d, s_id %x:%x:%x, confirmed"
-	    " completion %ssupported) added\n",
-	    vha->vp_idx, local ?  "local " : "", fcport->port_name[0],
-	    fcport->port_name[1], fcport->port_name[2], fcport->port_name[3],
-	    fcport->port_name[4], fcport->port_name[5], fcport->port_name[6],
-	    fcport->port_name[7], fcport->loop_id, sess->s_id.b.domain,
-	    sess->s_id.b.area, sess->s_id.b.al_pa, sess->conf_compl_supported ?
-	    "" : "not ");
+	    "qla_target(%d): %ssession for wwn %8phC (loop_id %d, "
+	    "s_id %x:%x:%x, confirmed completion %ssupported) added\n",
+	    vha->vp_idx, local ?  "local " : "", fcport->port_name,
+	    fcport->loop_id, sess->s_id.b.domain, sess->s_id.b.area,
+	    sess->s_id.b.al_pa, sess->conf_compl_supported ?  "" : "not ");
 
 	return sess;
 }
@@ -730,13 +712,9 @@ void qlt_fc_port_added(struct scsi_qla_host *vha, fc_port_t *fcport)
 			qlt_undelete_sess(sess);
 
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf04c,
-			    "qla_target(%u): %ssession for port %02x:"
-			    "%02x:%02x:%02x:%02x:%02x:%02x:%02x (loop ID %d) "
-			    "reappeared\n", vha->vp_idx, sess->local ? "local "
-			    : "", sess->port_name[0], sess->port_name[1],
-			    sess->port_name[2], sess->port_name[3],
-			    sess->port_name[4], sess->port_name[5],
-			    sess->port_name[6], sess->port_name[7],
+			    "qla_target(%u): %ssession for port %8phC "
+			    "(loop ID %d) reappeared\n", vha->vp_idx,
+			    sess->local ? "local " : "", sess->port_name,
 			    sess->loop_id);
 
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf007,
@@ -749,13 +727,8 @@ void qlt_fc_port_added(struct scsi_qla_host *vha, fc_port_t *fcport)
 	if (sess && sess->local) {
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf04d,
 		    "qla_target(%u): local session for "
-		    "port %02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x "
-		    "(loop ID %d) became global\n", vha->vp_idx,
-		    fcport->port_name[0], fcport->port_name[1],
-		    fcport->port_name[2], fcport->port_name[3],
-		    fcport->port_name[4], fcport->port_name[5],
-		    fcport->port_name[6], fcport->port_name[7],
-		    sess->loop_id);
+		    "port %8phC (loop ID %d) became global\n", vha->vp_idx,
+		    fcport->port_name, sess->loop_id);
 		sess->local = 0;
 	}
 	ha->tgt.tgt_ops->put_sess(sess);
@@ -2840,10 +2813,8 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 	int res = 0;
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf026,
-	    "qla_target(%d): Port ID: 0x%02x:%02x:%02x"
-	    " ELS opcode: 0x%02x\n", vha->vp_idx, iocb->u.isp24.port_id[0],
-	    iocb->u.isp24.port_id[1], iocb->u.isp24.port_id[2],
-	    iocb->u.isp24.status_subcode);
+	    "qla_target(%d): Port ID: 0x%3phC ELS opcode: 0x%02x\n",
+	    vha->vp_idx, iocb->u.isp24.port_id, iocb->u.isp24.status_subcode);
 
 	switch (iocb->u.isp24.status_subcode) {
 	case ELS_PLOGI:
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index a318092..a6da313 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1474,15 +1474,11 @@ static void tcm_qla2xxx_update_sess(struct qla_tgt_sess *sess, port_id_t s_id,
 
 
 	if (sess->loop_id != loop_id || sess->s_id.b24 != s_id.b24)
-		pr_info("Updating session %p from port %02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x loop_id %d -> %d s_id %x:%x:%x -> %x:%x:%x\n",
-			sess,
-			sess->port_name[0], sess->port_name[1],
-			sess->port_name[2], sess->port_name[3],
-			sess->port_name[4], sess->port_name[5],
-			sess->port_name[6], sess->port_name[7],
-			sess->loop_id, loop_id,
-			sess->s_id.b.domain, sess->s_id.b.area, sess->s_id.b.al_pa,
-			s_id.b.domain, s_id.b.area, s_id.b.al_pa);
+		pr_info("Updating session %p from port %8phC loop_id %d -> %d s_id %x:%x:%x -> %x:%x:%x\n",
+		    sess, sess->port_name,
+		    sess->loop_id, loop_id, sess->s_id.b.domain,
+		    sess->s_id.b.area, sess->s_id.b.al_pa, s_id.b.domain,
+		    s_id.b.area, s_id.b.al_pa);
 
 	if (sess->loop_id != loop_id) {
 		/*
-- 
1.7.7

