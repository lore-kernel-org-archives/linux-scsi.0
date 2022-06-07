Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A21C3C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jun 2022 04:47:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236623AbiFGErM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jun 2022 00:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236605AbiFGEqq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jun 2022 00:46:46 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F1ECD0295
        for <linux-scsi@vger.kernel.org>; Mon,  6 Jun 2022 21:46:45 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 256JXd0Y025485
        for <linux-scsi@vger.kernel.org>; Mon, 6 Jun 2022 21:46:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=DsFUvN7+FxncF4TZGyf9fY3LWM8+aiE5HEVE3Vglgqw=;
 b=RyhGBUA9TtmFT7nyvG/iA9kbi12YGfDBAIehjbT9beKrmvxCTm7ijfjC4IqDCEYQT4Mr
 6QcKnuD9pPmBSmiKhxpqvOi5EDd7w1FZfjCcNGVy3RRiHbuBW0uXYZiE+29mK3PM1jU+
 r0EqgN21K6EIgeYOcIDkdi+GjS6W6uT7EmzSCF9sByVpjaGdJ4PJrxD+yHIWyRAxdfg4
 0fVnvo1ASz9nSfKyEsJkj0gbS5vTAR++fdmE6+/oALOZxIpyjCoLyURGdg7FXg+zNKAT
 JSx5OEIgWAxzG/MLc7hKBoccdmBWWD5c+P8NuCkgI7jE2/q3A4vghrSVH4X+iqt4xt06 Uw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3gg6wq8q8g-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 06 Jun 2022 21:46:44 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 6 Jun
 2022 21:46:41 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 6 Jun 2022 21:46:41 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 9829A3F706B;
        Mon,  6 Jun 2022 21:46:41 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 08/11] qla2xxx: edif: remove old doorbell interface
Date:   Mon, 6 Jun 2022 21:46:24 -0700
Message-ID: <20220607044627.19563-9-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220607044627.19563-1-njavali@marvell.com>
References: <20220607044627.19563-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: flionusy9MhU533KamPw-gZ1qwlqoSAg
X-Proofpoint-GUID: flionusy9MhU533KamPw-gZ1qwlqoSAg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-07_01,2022-06-03_01,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Recently driver has implemented a new doorbell mechanism via bsg.
The new doorbell tells driver the exact buffer size application has
where driver can fill it up with events. The old doorbell guestimated
application buffer size is 256. This patch remove duplicate
functionality. In addition, application has moved on to the new
doorbell interface.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |  2 -
 drivers/scsi/qla2xxx/qla_edif.c | 78 ---------------------------------
 drivers/scsi/qla2xxx/qla_gbl.h  |  1 -
 3 files changed, 81 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 3b3e4234f37a..8b87fefda423 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2476,7 +2476,6 @@ static DEVICE_ATTR(port_speed, 0644, qla2x00_port_speed_show,
     qla2x00_port_speed_store);
 static DEVICE_ATTR(port_no, 0444, qla2x00_port_no_show, NULL);
 static DEVICE_ATTR(fw_attr, 0444, qla2x00_fw_attr_show, NULL);
-static DEVICE_ATTR_RO(edif_doorbell);
 
 static struct attribute *qla2x00_host_attrs[] = {
 	&dev_attr_driver_version.attr,
@@ -2521,7 +2520,6 @@ static struct attribute *qla2x00_host_attrs[] = {
 	&dev_attr_port_no.attr,
 	&dev_attr_fw_attr.attr,
 	&dev_attr_dport_diagnostics.attr,
-	&dev_attr_edif_doorbell.attr,
 	&dev_attr_mpi_pause.attr,
 	&dev_attr_qlini_mode.attr,
 	&dev_attr_ql2xiniexchg.attr,
diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index 142feda0381f..7f2106f2d94d 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -2265,84 +2265,6 @@ qla_edif_timer(scsi_qla_host_t *vha)
 		qla_edif_dbell_bsg_done(vha);
 }
 
-/*
- * app uses separate thread to read this. It'll wait until the doorbell
- * is rung by the driver or the max wait time has expired
- */
-ssize_t
-edif_doorbell_show(struct device *dev, struct device_attribute *attr,
-		char *buf)
-{
-	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
-	struct edb_node	*dbnode = NULL;
-	struct edif_app_dbell *ap = (struct edif_app_dbell *)buf;
-	uint32_t dat_siz, buf_size, sz;
-
-	/* TODO: app currently hardcoded to 256. Will transition to bsg */
-	sz = 256;
-
-	/* stop new threads from waiting if we're not init'd */
-	if (DBELL_INACTIVE(vha)) {
-		ql_dbg(ql_dbg_edif + ql_dbg_verbose, vha, 0x09122,
-		    "%s error - edif db not enabled\n", __func__);
-		return 0;
-	}
-
-	if (!vha->hw->flags.edif_enabled) {
-		/* edif not enabled */
-		ql_dbg(ql_dbg_edif + ql_dbg_verbose, vha, 0x09122,
-		    "%s error - edif not enabled\n", __func__);
-		return -1;
-	}
-
-	buf_size = 0;
-	while ((sz - buf_size) >= sizeof(struct edb_node)) {
-		/* remove the next item from the doorbell list */
-		dat_siz = 0;
-		dbnode = qla_edb_getnext(vha);
-		if (dbnode) {
-			ap->event_code = dbnode->ntype;
-			switch (dbnode->ntype) {
-			case VND_CMD_AUTH_STATE_SESSION_SHUTDOWN:
-			case VND_CMD_AUTH_STATE_NEEDED:
-				ap->port_id = dbnode->u.plogi_did;
-				dat_siz += sizeof(ap->port_id);
-				break;
-			case VND_CMD_AUTH_STATE_ELS_RCVD:
-				ap->port_id = dbnode->u.els_sid;
-				dat_siz += sizeof(ap->port_id);
-				break;
-			case VND_CMD_AUTH_STATE_SAUPDATE_COMPL:
-				ap->port_id = dbnode->u.sa_aen.port_id;
-				memcpy(ap->event_data, &dbnode->u,
-						sizeof(struct edif_sa_update_aen));
-				dat_siz += sizeof(struct edif_sa_update_aen);
-				break;
-			default:
-				/* unknown node type, rtn unknown ntype */
-				ap->event_code = VND_CMD_AUTH_STATE_UNDEF;
-				memcpy(ap->event_data, &dbnode->ntype, 4);
-				dat_siz += 4;
-				break;
-			}
-
-			ql_dbg(ql_dbg_edif, vha, 0x09102,
-				"%s Doorbell consumed : type=%d %p\n",
-				__func__, dbnode->ntype, dbnode);
-			/* we're done with the db node, so free it up */
-			kfree(dbnode);
-		} else {
-			break;
-		}
-
-		ap->event_data_size = dat_siz;
-		/* 8bytes = ap->event_code + ap->event_data_size */
-		buf_size += dat_siz + 8;
-		ap = (struct edif_app_dbell *)(buf + buf_size);
-	}
-	return buf_size;
-}
-
 static void qla_noop_sp_done(srb_t *sp, int res)
 {
 	sp->fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 84b44454c231..08103efa170f 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -990,7 +990,6 @@ fc_port_t *qla2x00_find_fcport_by_pid(scsi_qla_host_t *vha, port_id_t *id);
 void qla_edb_eventcreate(scsi_qla_host_t *vha, uint32_t dbtype, uint32_t data, uint32_t data2,
 		fc_port_t *fcport);
 void qla_edb_stop(scsi_qla_host_t *vha);
-ssize_t edif_doorbell_show(struct device *dev, struct device_attribute *attr, char *buf);
 int32_t qla_edif_app_mgmt(struct bsg_job *bsg_job);
 void qla_enode_init(scsi_qla_host_t *vha);
 void qla_enode_stop(scsi_qla_host_t *vha);
-- 
2.19.0.rc0

