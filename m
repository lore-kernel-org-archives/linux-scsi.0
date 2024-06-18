Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3D916DC1D
	for <linux-scsi@vger.kernel.org>; Tue, 18 Jun 2024 13:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718717881; cv=none; b=EwhTNdxGjMc4DuAcZRaFRMpFZD8oUBM1ZGF/mX2+d94Ua3CMGjgRdcpxDvalWLUddUMbpffDtoMIzV56DMh3vnt4GYTc3ZW2qVofeR4yMqJKpqxnzgsXdTSGbnCUk3QZ5KZOkZFReRbq9+vdDfvx5GvLH3+KOL3HxFvYE4O1M5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718717881; c=relaxed/simple;
	bh=TNpL/ocWg5ZKJ7hOTk+32TSWYQKXwvpu7inDVo8qoaU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cv6qpuiWx4KU2yMjyE/iszeKyyL8E7Gv5QyxEjm/mBEabzmkdPAAhzZmKT7PDMMpusanhqPMAszjk+ocdodPJFspjSjE0vO14YRbAX8z4f/DwccGvEMAXEz4Djt8XRLbb9omI2BhEdvhr+W9uZK7VOkxExPwrqU2oQ10xw0HSWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=DJ74jXDN; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="DJ74jXDN"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45IBxJss015585;
	Tue, 18 Jun 2024 06:37:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=5
	yOishH7KKlsE+FnKPpTR8KWl06IQCjp3YSYHyFb6WE=; b=DJ74jXDNGjPhmpDzi
	xihJng0y3+rCDwop4BsIOoPIqm+lH0dbAE+SdkBpTwJoICMNvGFMmqokyjeIoePZ
	jNfs4COqBWyV0w22UMaHHiDPImA3rhQ9jNbmQdDFmiheddTnjkc6T0Z+HTxM2Y3m
	lQAoqWCKMYrNHeE/myCeQQiJs0igafL/YInQeBF38KSpmi1n/W8aCl2js+gUt4sT
	u6CFzGyD7KbOMzKnclJoCxrQuqk454dGMpOQ3U3G0fTvo19NGCOJtdkeFQrfld+U
	vk/RIL4wVxxV71jLeuBn3wDJLXCS+r6gP41gHWgBRaIaCFvnNoE0RF3kNw42/94w
	p68BA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3yu0nwt3mc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Jun 2024 06:37:56 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Tue, 18 Jun 2024 06:37:56 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Tue, 18 Jun 2024 06:37:55 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id A18793F706D;
	Tue, 18 Jun 2024 06:37:53 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH 01/11] qla2xxx: unable to act on RSCN for port online
Date: Tue, 18 Jun 2024 19:07:29 +0530
Message-ID: <20240618133739.35456-2-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20240618133739.35456-1-njavali@marvell.com>
References: <20240618133739.35456-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: EMJLwJFlUciIFM75cNkJde0-s0GWeoZj
X-Proofpoint-ORIG-GUID: EMJLwJFlUciIFM75cNkJde0-s0GWeoZj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-18_02,2024-06-17_01,2024-05-17_01

From: Quinn Tran <qutran@marvell.com>

The device does not come online when the target
port is online. There were multiple RSCNs indicating
multiple devices were affected. Driver is in the
process of finishing a fabric scan. A new RSCN
(device up) arrived at the tail end of the last
fabric scan. Driver mistaken the new RSCN is being
taken care of by the previous fabric scan, where
this notification is cleared and not act on. The laser
needs to be blinked again to get the device to show up.

To prevent driver from accidentally clearing the RSCN
notification, each RSCN is given a generation value.
A fabric scan will scan for that generation(s).
Any new RSCN arrive after the scan start will have a
new generation value. This will trigger another scan to
get latest data. The RSCN notification flag will be
cleared when the scan is associate to that generation.

Fixes: bb2ca6b3f09a ("scsi: qla2xxx: Relogin during fabric disturbance")
Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_def.h    |  3 +++
 drivers/scsi/qla2xxx/qla_gs.c     | 33 ++++++++++++++++++++++++++++---
 drivers/scsi/qla2xxx/qla_init.c   | 24 +++++++++++++++++-----
 drivers/scsi/qla2xxx/qla_inline.h | 18 +++++++++++++++++
 4 files changed, 70 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 2f49baf131e2..ba134f6237b8 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3312,6 +3312,8 @@ struct fab_scan_rp {
 struct fab_scan {
 	struct fab_scan_rp *l;
 	u32 size;
+	u32 rscn_gen_start;
+	u32 rscn_gen_end;
 	u16 scan_retry;
 #define MAX_SCAN_RETRIES 5
 	enum scan_flags_t scan_flags;
@@ -5030,6 +5032,7 @@ typedef struct scsi_qla_host {
 
 	/* Counter to detect races between ELS and RSCN events */
 	atomic_t		generation_tick;
+	atomic_t		rscn_gen;
 	/* Time when global fcport update has been scheduled */
 	int			total_fcport_update_gen;
 	/* List of pending LOGOs, protected by tgt_mutex */
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 1cf9d200d563..e801cd9e2345 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3168,6 +3168,29 @@ static int qla2x00_is_a_vp(scsi_qla_host_t *vha, u64 wwn)
 	return rc;
 }
 
+static bool qla_ok_to_clear_rscn(scsi_qla_host_t *vha, fc_port_t *fcport)
+{
+	u32 rscn_gen;
+
+	rscn_gen = atomic_read(&vha->rscn_gen);
+	ql_dbg(ql_dbg_disc + ql_dbg_verbose, vha, 0x2017,
+	    "%s %d %8phC rscn_gen %x start %x end %x current %x\n",
+	    __func__, __LINE__, fcport->port_name, fcport->rscn_gen,
+	    vha->scan.rscn_gen_start, vha->scan.rscn_gen_end, rscn_gen);
+
+	if (val_is_in_range(fcport->rscn_gen, vha->scan.rscn_gen_start,
+	    vha->scan.rscn_gen_end))
+		/* rscn came in before fabric scan */
+		return true;
+
+	if (val_is_in_range(fcport->rscn_gen, vha->scan.rscn_gen_end, rscn_gen))
+		/* rscn came in after fabric scan */
+		return false;
+
+	/* rare: fcport's scan_needed + rscn_gen must be stale */
+	return true;
+}
+
 void qla24xx_async_gnnft_done(scsi_qla_host_t *vha, srb_t *sp)
 {
 	fc_port_t *fcport;
@@ -3281,10 +3304,10 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t *vha, srb_t *sp)
 				   (fcport->scan_needed &&
 				    fcport->port_type != FCT_INITIATOR &&
 				    fcport->port_type != FCT_NVME_INITIATOR)) {
+				fcport->scan_needed = 0;
 				qlt_schedule_sess_for_deletion(fcport);
 			}
 			fcport->d_id.b24 = rp->id.b24;
-			fcport->scan_needed = 0;
 			break;
 		}
 
@@ -3325,7 +3348,9 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t *vha, srb_t *sp)
 				do_delete = true;
 			}
 
-			fcport->scan_needed = 0;
+			if (qla_ok_to_clear_rscn(vha, fcport))
+				fcport->scan_needed = 0;
+
 			if (((qla_dual_mode_enabled(vha) ||
 			      qla_ini_mode_enabled(vha)) &&
 			    atomic_read(&fcport->state) == FCS_ONLINE) ||
@@ -3355,7 +3380,9 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t *vha, srb_t *sp)
 					    fcport->port_name, fcport->loop_id,
 					    fcport->login_retry);
 				}
-				fcport->scan_needed = 0;
+
+				if (qla_ok_to_clear_rscn(vha, fcport))
+					fcport->scan_needed = 0;
 				qla24xx_fcport_handle_login(vha, fcport);
 			}
 		}
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 8377624d76c9..d88f05ea55cb 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1842,10 +1842,18 @@ int qla24xx_post_newsess_work(struct scsi_qla_host *vha, port_id_t *id,
 	return qla2x00_post_work(vha, e);
 }
 
+static void qla_rscn_gen_tick(scsi_qla_host_t *vha, u32 *ret_rscn_gen)
+{
+	*ret_rscn_gen = atomic_inc_return(&vha->rscn_gen);
+	/* memory barrier */
+	wmb();
+}
+
 void qla2x00_handle_rscn(scsi_qla_host_t *vha, struct event_arg *ea)
 {
 	fc_port_t *fcport;
 	unsigned long flags;
+	u32 rscn_gen;
 
 	switch (ea->id.b.rsvd_1) {
 	case RSCN_PORT_ADDR:
@@ -1875,15 +1883,16 @@ void qla2x00_handle_rscn(scsi_qla_host_t *vha, struct event_arg *ea)
 					 * Otherwise we're already in the middle of a relogin
 					 */
 					fcport->scan_needed = 1;
-					fcport->rscn_gen++;
+					qla_rscn_gen_tick(vha, &fcport->rscn_gen);
 				}
 			} else {
 				fcport->scan_needed = 1;
-				fcport->rscn_gen++;
+				qla_rscn_gen_tick(vha, &fcport->rscn_gen);
 			}
 		}
 		break;
 	case RSCN_AREA_ADDR:
+		qla_rscn_gen_tick(vha, &rscn_gen);
 		list_for_each_entry(fcport, &vha->vp_fcports, list) {
 			if (fcport->flags & FCF_FCP2_DEVICE &&
 			    atomic_read(&fcport->state) == FCS_ONLINE)
@@ -1891,11 +1900,12 @@ void qla2x00_handle_rscn(scsi_qla_host_t *vha, struct event_arg *ea)
 
 			if ((ea->id.b24 & 0xffff00) == (fcport->d_id.b24 & 0xffff00)) {
 				fcport->scan_needed = 1;
-				fcport->rscn_gen++;
+				fcport->rscn_gen = rscn_gen;
 			}
 		}
 		break;
 	case RSCN_DOM_ADDR:
+		qla_rscn_gen_tick(vha, &rscn_gen);
 		list_for_each_entry(fcport, &vha->vp_fcports, list) {
 			if (fcport->flags & FCF_FCP2_DEVICE &&
 			    atomic_read(&fcport->state) == FCS_ONLINE)
@@ -1903,19 +1913,20 @@ void qla2x00_handle_rscn(scsi_qla_host_t *vha, struct event_arg *ea)
 
 			if ((ea->id.b24 & 0xff0000) == (fcport->d_id.b24 & 0xff0000)) {
 				fcport->scan_needed = 1;
-				fcport->rscn_gen++;
+				fcport->rscn_gen = rscn_gen;
 			}
 		}
 		break;
 	case RSCN_FAB_ADDR:
 	default:
+		qla_rscn_gen_tick(vha, &rscn_gen);
 		list_for_each_entry(fcport, &vha->vp_fcports, list) {
 			if (fcport->flags & FCF_FCP2_DEVICE &&
 			    atomic_read(&fcport->state) == FCS_ONLINE)
 				continue;
 
 			fcport->scan_needed = 1;
-			fcport->rscn_gen++;
+			fcport->rscn_gen = rscn_gen;
 		}
 		break;
 	}
@@ -1924,6 +1935,7 @@ void qla2x00_handle_rscn(scsi_qla_host_t *vha, struct event_arg *ea)
 	if (vha->scan.scan_flags == 0) {
 		ql_dbg(ql_dbg_disc, vha, 0xffff, "%s: schedule\n", __func__);
 		vha->scan.scan_flags |= SF_QUEUED;
+		vha->scan.rscn_gen_start = atomic_read(&vha->rscn_gen);
 		schedule_delayed_work(&vha->scan.scan_work, 5);
 	}
 	spin_unlock_irqrestore(&vha->work_lock, flags);
@@ -6393,6 +6405,8 @@ qla2x00_configure_fabric(scsi_qla_host_t *vha)
 		qlt_do_generation_tick(vha, &discovery_gen);
 
 		if (USE_ASYNC_SCAN(ha)) {
+			/* start of scan begins here */
+			vha->scan.rscn_gen_end = atomic_read(&vha->rscn_gen);
 			rval = qla24xx_async_gpnft(vha, FC4_TYPE_FCP_SCSI,
 			    NULL);
 			if (rval)
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index a4a56ab0ba74..30e332806f86 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -631,3 +631,21 @@ static inline int qla_mapq_alloc_qp_cpu_map(struct qla_hw_data *ha)
 	}
 	return 0;
 }
+
+static inline bool val_is_in_range(u32 val, u32 start, u32 end)
+{
+	if (start < end) {
+		if (val >= start && val <= end)
+			return true;
+		else
+			return false;
+	}
+
+	/* @end has wrapped */
+	if (val >= start  && val <= 0xffffffffu)
+		return true;
+	if (val <= end)
+		return true;
+	else
+		return false;
+}
-- 
2.23.1

