Return-Path: <SRS0=qpW3=4I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDDF7C761A1
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Feb 2020 04:34:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8515D24670
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Feb 2020 04:34:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728124AbgBTEe4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Feb 2020 23:34:56 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44063 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728119AbgBTEez (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Feb 2020 23:34:55 -0500
Received: by mail-pl1-f194.google.com with SMTP id d9so1022261plo.11
        for <linux-scsi@vger.kernel.org>; Wed, 19 Feb 2020 20:34:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hpZEINrnHwNY4pgFEUDdF9XBqBfqLtNa06a/yBcJRAI=;
        b=Kp4byvHTruWX+aoy2I1SaTGoDH5kzlKe6sG7xseTQvJNUgq7tA6o+3zLezo9OaeWqD
         d4kCTdbGOesUNFuXKQVOYbB0OkWXlFhJeNYOv6n+L4yIXsnsQnGVrKbCIO9j6gEnIPjd
         J5/GL/3F327Z7bogkRev24o9cmrrT0WNxjSzCGsdmZfDl3Ik7BZjtc39rOfNhCGo5IMt
         IWZVLO4r9wbcu55WpQFqKzVCCIqjH8gGsCHgLaanogBsvxNHiH4amI+yF7Hmy5yKrVv8
         gymBHnrvD8Ciix6xCyp5OQxrtt/sd7SvFdZBCemg6g3C/7WGq73eOKObFklheqjkNHIW
         L+nQ==
X-Gm-Message-State: APjAAAW4XMidj2IR32u1kG2Iw4t1SuEwH5SSVCHTrdGpdH5cN1dCEScA
        VZcg3jQ2YfX8q7/CvHoKTrE=
X-Google-Smtp-Source: APXvYqwhAVlsyUXvWZpAaEsYTgXPH1vkXf4YW2Wy3v9z3pCZWfme4tJwxGimu/eesZXgVRRSpdzsBA==
X-Received: by 2002:a17:902:7d86:: with SMTP id a6mr29721417plm.212.1582173293990;
        Wed, 19 Feb 2020 20:34:53 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:29a7:b1bb:5b40:3d61])
        by smtp.gmail.com with ESMTPSA id b5sm1236263pfb.179.2020.02.19.20.34.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 20:34:53 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v3 4/5] qla2xxx: Convert MAKE_HANDLE() from a define into an inline function
Date:   Wed, 19 Feb 2020 20:34:40 -0800
Message-Id: <20200220043441.20504-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200220043441.20504-1-bvanassche@acm.org>
References: <20200220043441.20504-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch allows sparse to verify the endianness of the arguments passed
to make_handle().

Cc: Quinn Tran <qutran@marvell.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_def.h    |  5 ++++-
 drivers/scsi/qla2xxx/qla_iocb.c   | 22 +++++++++++-----------
 drivers/scsi/qla2xxx/qla_mbx.c    | 10 +++++-----
 drivers/scsi/qla2xxx/qla_mr.c     |  8 ++++----
 drivers/scsi/qla2xxx/qla_nvme.c   |  2 +-
 drivers/scsi/qla2xxx/qla_target.c |  6 +++---
 6 files changed, 28 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index b04d334933ef..cec0b5082927 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -119,7 +119,10 @@ typedef struct {
 #define LSD(x)	((uint32_t)((uint64_t)(x)))
 #define MSD(x)	((uint32_t)((((uint64_t)(x)) >> 16) >> 16))
 
-#define MAKE_HANDLE(x, y) ((uint32_t)((((uint32_t)(x)) << 16) | (uint32_t)(y)))
+static inline uint32_t make_handle(uint16_t x, uint16_t y)
+{
+	return ((uint32_t)x << 16) | y;
+}
 
 /*
  * I/O register
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 47bf60a9490a..1816660768da 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -530,7 +530,7 @@ __qla2x00_marker(struct scsi_qla_host *vha, struct qla_qpair *qpair,
 			int_to_scsilun(lun, (struct scsi_lun *)&mrk24->lun);
 			host_to_fcp_swap(mrk24->lun, sizeof(mrk24->lun));
 			mrk24->vp_index = vha->vp_idx;
-			mrk24->handle = MAKE_HANDLE(req->id, mrk24->handle);
+			mrk24->handle = make_handle(req->id, mrk24->handle);
 		} else {
 			SET_TARGET_ID(ha, mrk->target, loop_id);
 			mrk->lun = cpu_to_le16((uint16_t)lun);
@@ -1655,7 +1655,7 @@ qla24xx_start_scsi(srb_t *sp)
 	req->cnt -= req_cnt;
 
 	cmd_pkt = (struct cmd_type_7 *)req->ring_ptr;
-	cmd_pkt->handle = MAKE_HANDLE(req->id, handle);
+	cmd_pkt->handle = make_handle(req->id, handle);
 
 	/* Zero out remaining portion of packet. */
 	/*    tagged queuing modifier -- default is TSK_SIMPLE (0). */
@@ -1843,7 +1843,7 @@ qla24xx_dif_start_scsi(srb_t *sp)
 
 	/* Fill-in common area */
 	cmd_pkt = (struct cmd_type_crc_2 *)req->ring_ptr;
-	cmd_pkt->handle = MAKE_HANDLE(req->id, handle);
+	cmd_pkt->handle = make_handle(req->id, handle);
 
 	clr_ptr = (uint32_t *)cmd_pkt + 2;
 	memset(clr_ptr, 0, REQUEST_ENTRY_SIZE - 8);
@@ -1975,7 +1975,7 @@ qla2xxx_start_scsi_mq(srb_t *sp)
 	req->cnt -= req_cnt;
 
 	cmd_pkt = (struct cmd_type_7 *)req->ring_ptr;
-	cmd_pkt->handle = MAKE_HANDLE(req->id, handle);
+	cmd_pkt->handle = make_handle(req->id, handle);
 
 	/* Zero out remaining portion of packet. */
 	/*    tagged queuing modifier -- default is TSK_SIMPLE (0). */
@@ -2178,7 +2178,7 @@ qla2xxx_dif_start_scsi_mq(srb_t *sp)
 
 	/* Fill-in common area */
 	cmd_pkt = (struct cmd_type_crc_2 *)req->ring_ptr;
-	cmd_pkt->handle = MAKE_HANDLE(req->id, handle);
+	cmd_pkt->handle = make_handle(req->id, handle);
 
 	clr_ptr = (uint32_t *)cmd_pkt + 2;
 	memset(clr_ptr, 0, REQUEST_ENTRY_SIZE - 8);
@@ -2489,7 +2489,7 @@ qla24xx_tm_iocb(srb_t *sp, struct tsk_mgmt_entry *tsk)
 
 	tsk->entry_type = TSK_MGMT_IOCB_TYPE;
 	tsk->entry_count = 1;
-	tsk->handle = MAKE_HANDLE(req->id, tsk->handle);
+	tsk->handle = make_handle(req->id, tsk->handle);
 	tsk->nport_handle = cpu_to_le16(fcport->loop_id);
 	tsk->timeout = cpu_to_le16(ha->r_a_tov / 10 * 2);
 	tsk->control_flags = cpu_to_le32(flags);
@@ -3358,7 +3358,7 @@ qla82xx_start_scsi(srb_t *sp)
 		}
 
 		cmd_pkt = (struct cmd_type_6 *)req->ring_ptr;
-		cmd_pkt->handle = MAKE_HANDLE(req->id, handle);
+		cmd_pkt->handle = make_handle(req->id, handle);
 
 		/* Zero out remaining portion of packet. */
 		/*    tagged queuing modifier -- default is TSK_SIMPLE (0). */
@@ -3429,7 +3429,7 @@ qla82xx_start_scsi(srb_t *sp)
 			goto queuing_error;
 
 		cmd_pkt = (struct cmd_type_7 *)req->ring_ptr;
-		cmd_pkt->handle = MAKE_HANDLE(req->id, handle);
+		cmd_pkt->handle = make_handle(req->id, handle);
 
 		/* Zero out remaining portion of packet. */
 		/* tagged queuing modifier -- default is TSK_SIMPLE (0).*/
@@ -3534,7 +3534,7 @@ qla24xx_abort_iocb(srb_t *sp, struct abort_entry_24xx *abt_iocb)
 	memset(abt_iocb, 0, sizeof(struct abort_entry_24xx));
 	abt_iocb->entry_type = ABORT_IOCB_TYPE;
 	abt_iocb->entry_count = 1;
-	abt_iocb->handle = cpu_to_le32(MAKE_HANDLE(req->id, sp->handle));
+	abt_iocb->handle = cpu_to_le32(make_handle(req->id, sp->handle));
 	if (sp->fcport) {
 		abt_iocb->nport_handle = cpu_to_le16(sp->fcport->loop_id);
 		abt_iocb->port_id[0] = sp->fcport->d_id.b.al_pa;
@@ -3542,7 +3542,7 @@ qla24xx_abort_iocb(srb_t *sp, struct abort_entry_24xx *abt_iocb)
 		abt_iocb->port_id[2] = sp->fcport->d_id.b.domain;
 	}
 	abt_iocb->handle_to_abort =
-	    cpu_to_le32(MAKE_HANDLE(aio->u.abt.req_que_no,
+	    cpu_to_le32(make_handle(aio->u.abt.req_que_no,
 				    aio->u.abt.cmd_hndl));
 	abt_iocb->vp_index = vha->vp_idx;
 	abt_iocb->req_que_no = cpu_to_le16(aio->u.abt.req_que_no);
@@ -3905,7 +3905,7 @@ qla2x00_start_bidir(srb_t *sp, struct scsi_qla_host *vha, uint32_t tot_dsds)
 	}
 
 	cmd_pkt = (struct cmd_bidir *)req->ring_ptr;
-	cmd_pkt->handle = MAKE_HANDLE(req->id, handle);
+	cmd_pkt->handle = make_handle(req->id, handle);
 
 	/* Zero out remaining portion of packet. */
 	/* tagged queuing modifier -- default is TSK_SIMPLE (0).*/
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index ff945d35ba8e..1563396ad658 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2383,7 +2383,7 @@ qla24xx_login_fabric(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 
 	lg->entry_type = LOGINOUT_PORT_IOCB_TYPE;
 	lg->entry_count = 1;
-	lg->handle = MAKE_HANDLE(req->id, lg->handle);
+	lg->handle = make_handle(req->id, lg->handle);
 	lg->nport_handle = cpu_to_le16(loop_id);
 	lg->control_flags = cpu_to_le16(LCF_COMMAND_PLOGI);
 	if (opt & BIT_0)
@@ -2653,7 +2653,7 @@ qla24xx_fabric_logout(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 	req = vha->req;
 	lg->entry_type = LOGINOUT_PORT_IOCB_TYPE;
 	lg->entry_count = 1;
-	lg->handle = MAKE_HANDLE(req->id, lg->handle);
+	lg->handle = make_handle(req->id, lg->handle);
 	lg->nport_handle = cpu_to_le16(loop_id);
 	lg->control_flags =
 	    cpu_to_le16(LCF_COMMAND_LOGO|LCF_IMPL_LOGO|
@@ -3144,9 +3144,9 @@ qla24xx_abort_command(srb_t *sp)
 
 	abt->entry_type = ABORT_IOCB_TYPE;
 	abt->entry_count = 1;
-	abt->handle = MAKE_HANDLE(req->id, abt->handle);
+	abt->handle = make_handle(req->id, abt->handle);
 	abt->nport_handle = cpu_to_le16(fcport->loop_id);
-	abt->handle_to_abort = MAKE_HANDLE(req->id, handle);
+	abt->handle_to_abort = make_handle(req->id, handle);
 	abt->port_id[0] = fcport->d_id.b.al_pa;
 	abt->port_id[1] = fcport->d_id.b.area;
 	abt->port_id[2] = fcport->d_id.b.domain;
@@ -3223,7 +3223,7 @@ __qla24xx_issue_tmf(char *name, uint32_t type, struct fc_port *fcport,
 
 	tsk->p.tsk.entry_type = TSK_MGMT_IOCB_TYPE;
 	tsk->p.tsk.entry_count = 1;
-	tsk->p.tsk.handle = MAKE_HANDLE(req->id, tsk->p.tsk.handle);
+	tsk->p.tsk.handle = make_handle(req->id, tsk->p.tsk.handle);
 	tsk->p.tsk.nport_handle = cpu_to_le16(fcport->loop_id);
 	tsk->p.tsk.timeout = cpu_to_le16(ha->r_a_tov / 10 * 2);
 	tsk->p.tsk.control_flags = cpu_to_le32(type);
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 6d120457478e..df99911b8bb9 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -3135,7 +3135,7 @@ qlafx00_start_scsi(srb_t *sp)
 
 	memset(&lcmd_pkt, 0, REQUEST_ENTRY_SIZE);
 
-	lcmd_pkt.handle = MAKE_HANDLE(req->id, sp->handle);
+	lcmd_pkt.handle = make_handle(req->id, sp->handle);
 	lcmd_pkt.reserved_0 = 0;
 	lcmd_pkt.port_path_ctrl = 0;
 	lcmd_pkt.reserved_1 = 0;
@@ -3205,7 +3205,7 @@ qlafx00_tm_iocb(srb_t *sp, struct tsk_mgmt_entry_fx00 *ptm_iocb)
 	memset(&tm_iocb, 0, sizeof(struct tsk_mgmt_entry_fx00));
 	tm_iocb.entry_type = TSK_MGMT_IOCB_TYPE_FX00;
 	tm_iocb.entry_count = 1;
-	tm_iocb.handle = cpu_to_le32(MAKE_HANDLE(req->id, sp->handle));
+	tm_iocb.handle = cpu_to_le32(make_handle(req->id, sp->handle));
 	tm_iocb.reserved_0 = 0;
 	tm_iocb.tgt_id = cpu_to_le16(sp->fcport->tgt_id);
 	tm_iocb.control_flags = cpu_to_le32(fxio->u.tmf.flags);
@@ -3231,9 +3231,9 @@ qlafx00_abort_iocb(srb_t *sp, struct abort_iocb_entry_fx00 *pabt_iocb)
 	memset(&abt_iocb, 0, sizeof(struct abort_iocb_entry_fx00));
 	abt_iocb.entry_type = ABORT_IOCB_TYPE_FX00;
 	abt_iocb.entry_count = 1;
-	abt_iocb.handle = cpu_to_le32(MAKE_HANDLE(req->id, sp->handle));
+	abt_iocb.handle = cpu_to_le32(make_handle(req->id, sp->handle));
 	abt_iocb.abort_handle =
-	    cpu_to_le32(MAKE_HANDLE(req->id, fxio->u.abt.cmd_hndl));
+	    cpu_to_le32(make_handle(req->id, fxio->u.abt.cmd_hndl));
 	abt_iocb.tgt_id_sts = cpu_to_le16(sp->fcport->tgt_id);
 	abt_iocb.req_que_no = cpu_to_le16(req->id);
 
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index bfcd02fdf2b8..84e2a980dea0 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -413,7 +413,7 @@ static inline int qla2x00_start_nvme_mq(srb_t *sp)
 	req->cnt -= req_cnt;
 
 	cmd_pkt = (struct cmd_nvme *)req->ring_ptr;
-	cmd_pkt->handle = MAKE_HANDLE(req->id, handle);
+	cmd_pkt->handle = make_handle(req->id, handle);
 
 	/* Zero out remaining portion of packet. */
 	clr_ptr = (uint32_t *)cmd_pkt + 2;
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 243f87df3d2b..d0dbddcef70f 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1758,7 +1758,7 @@ static int qlt_build_abts_resp_iocb(struct qla_tgt_mgmt_cmd *mcmd)
 		qpair->req->outstanding_cmds[h] = (srb_t *)mcmd;
 	}
 
-	resp->handle = MAKE_HANDLE(qpair->req->id, h);
+	resp->handle = make_handle(qpair->req->id, h);
 	resp->entry_type = ABTS_RESP_24XX;
 	resp->entry_count = 1;
 	resp->nport_handle = abts->nport_handle;
@@ -2580,7 +2580,7 @@ static int qlt_24xx_build_ctio_pkt(struct qla_qpair *qpair,
 	} else
 		qpair->req->outstanding_cmds[h] = (srb_t *)prm->cmd;
 
-	pkt->handle = MAKE_HANDLE(qpair->req->id, h);
+	pkt->handle = make_handle(qpair->req->id, h);
 	pkt->handle |= CTIO_COMPLETION_HANDLE_MARK;
 	pkt->nport_handle = cpu_to_le16(prm->cmd->loop_id);
 	pkt->timeout = cpu_to_le16(QLA_TGT_TIMEOUT);
@@ -3093,7 +3093,7 @@ qlt_build_ctio_crc2_pkt(struct qla_qpair *qpair, struct qla_tgt_prm *prm)
 	} else
 		qpair->req->outstanding_cmds[h] = (srb_t *)prm->cmd;
 
-	pkt->handle  = MAKE_HANDLE(qpair->req->id, h);
+	pkt->handle  = make_handle(qpair->req->id, h);
 	pkt->handle |= CTIO_COMPLETION_HANDLE_MARK;
 	pkt->nport_handle = cpu_to_le16(prm->cmd->loop_id);
 	pkt->timeout = cpu_to_le16(QLA_TGT_TIMEOUT);
