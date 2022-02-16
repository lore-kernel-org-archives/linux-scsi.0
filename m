Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3F42C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Feb 2022 21:04:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbiBPVEO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Feb 2022 16:04:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233619AbiBPVEI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2022 16:04:08 -0500
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 085492B0B06
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:03:45 -0800 (PST)
Received: by mail-pl1-f181.google.com with SMTP id w1so2961607plb.6
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:03:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Kna+1/whBHm/Uup0ECCatq0EmWr/zlx7nzTrjC/MKew=;
        b=bHKvVGUMsjsvFJTxhmpjLeN6Moa4/DwW4KFkliCbqXaifM6dwfTyCUZpAZZeGGLBbr
         GmVEvD/UpHRCNGLOeD5oQXLgBot1BI+eOW4yJ5T2+Us4Mt27a7YUaFeqjX/dUbiqbt2c
         y5LkKJ7PM5BfwwW8d+SIPKJ8cAAj51N9Jw7+SsbAtk5mnwCadml+lrKiVo/u4bMK9rK/
         eHHQq2y0K47UvSHabiu0GIv7KjR3qoyXlrBVXqj+geYK4ZaaSsBE/WZq+Whw70aKnN1z
         3F59ZlgeAIvovMvWoDacRRXU2lFqzbZAmTeFhpr4fWj3ZiJ3C415aQutpCrJM6qAQgXZ
         8Y7A==
X-Gm-Message-State: AOAM533UQ0LoVlZ8FGBbs4hzAg3YV6JyUcwHUWaIk2gAzbkJccJWXBlP
        9b7ienVb8z5UCopFLyGXHQc=
X-Google-Smtp-Source: ABdhPJyWMRGA6pAsNyqVYET0DwzTHxHWOf3QWI4pvNVMwtQ/qLRZgfVV4Eea0KZkkgpVOCmzGtpaJg==
X-Received: by 2002:a17:902:654b:b0:14d:964d:7578 with SMTP id d11-20020a170902654b00b0014d964d7578mr4322326pln.166.1645045424373;
        Wed, 16 Feb 2022 13:03:44 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id c8sm46591222pfv.57.2022.02.16.13.03.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 13:03:43 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 29/50] scsi: bnx2fc: Stop using the SCSI pointer
Date:   Wed, 16 Feb 2022 13:02:12 -0800
Message-Id: <20220216210233.28774-30-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220216210233.28774-1-bvanassche@acm.org>
References: <20220216210233.28774-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set .cmd_size in the SCSI host template instead of using the SCSI pointer
from struct scsi_cmnd. Remove the CMD_SCSI_STATUS() assignment because the
assigned value is not used.

This patch prepares for removal of the SCSI pointer from struct scsi_cmnd.

Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/bnx2fc/bnx2fc.h      |  9 +++++++--
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |  1 +
 drivers/scsi/bnx2fc/bnx2fc_io.c   | 23 +++++++++++------------
 3 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index b4cea8b06ea1..046247420cfa 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -137,8 +137,6 @@
 #define BNX2FC_FW_TIMEOUT		(3 * HZ)
 #define PORT_MAX			2
 
-#define CMD_SCSI_STATUS(Cmnd)		((Cmnd)->SCp.Status)
-
 /* FC FCP Status */
 #define	FC_GOOD				0
 
@@ -493,7 +491,14 @@ struct bnx2fc_unsol_els {
 	struct work_struct unsol_els_work;
 };
 
+struct bnx2fc_priv {
+	struct bnx2fc_cmd *io_req;
+};
 
+static inline struct bnx2fc_priv *bnx2fc_priv(struct scsi_cmnd *cmd)
+{
+	return scsi_cmd_priv(cmd);
+}
 
 struct bnx2fc_cmd *bnx2fc_cmd_alloc(struct bnx2fc_rport *tgt);
 struct bnx2fc_cmd *bnx2fc_elstm_alloc(struct bnx2fc_rport *tgt, int type);
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 68c4e3c3e7bb..f9a37ef57f1c 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -2979,6 +2979,7 @@ static struct scsi_host_template bnx2fc_shost_template = {
 	.track_queue_depth	= 1,
 	.slave_configure	= bnx2fc_slave_configure,
 	.shost_groups		= bnx2fc_host_groups,
+	.cmd_size		= sizeof(struct bnx2fc_priv),
 };
 
 static struct libfc_function_template bnx2fc_libfc_fcn_templ = {
diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index b9114113ee73..962454f2e2b1 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -204,7 +204,7 @@ static void bnx2fc_scsi_done(struct bnx2fc_cmd *io_req, int err_code)
 		sc_cmd, host_byte(sc_cmd->result), sc_cmd->retries,
 		sc_cmd->allowed);
 	scsi_set_resid(sc_cmd, scsi_bufflen(sc_cmd));
-	sc_cmd->SCp.ptr = NULL;
+	bnx2fc_priv(sc_cmd)->io_req = NULL;
 	scsi_done(sc_cmd);
 }
 
@@ -765,7 +765,7 @@ static int bnx2fc_initiate_tmf(struct scsi_cmnd *sc_cmd, u8 tm_flags)
 	task = &(task_page[index]);
 	bnx2fc_init_mp_task(io_req, task);
 
-	sc_cmd->SCp.ptr = (char *)io_req;
+	bnx2fc_priv(sc_cmd)->io_req = io_req;
 
 	/* Obtain free SQ entry */
 	spin_lock_bh(&tgt->tgt_lock);
@@ -1147,7 +1147,7 @@ int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
 	BNX2FC_TGT_DBG(tgt, "Entered bnx2fc_eh_abort\n");
 
 	spin_lock_bh(&tgt->tgt_lock);
-	io_req = (struct bnx2fc_cmd *)sc_cmd->SCp.ptr;
+	io_req = bnx2fc_priv(sc_cmd)->io_req;
 	if (!io_req) {
 		/* Command might have just completed */
 		printk(KERN_ERR PFX "eh_abort: io_req is NULL\n");
@@ -1572,8 +1572,8 @@ void bnx2fc_process_tm_compl(struct bnx2fc_cmd *io_req,
 		printk(KERN_ERR PFX "tmf's fc_hdr r_ctl = 0x%x\n",
 			fc_hdr->fh_r_ctl);
 	}
-	if (!sc_cmd->SCp.ptr) {
-		printk(KERN_ERR PFX "tm_compl: SCp.ptr is NULL\n");
+	if (!bnx2fc_priv(sc_cmd)->io_req) {
+		printk(KERN_ERR PFX "tm_compl: io_req is NULL\n");
 		return;
 	}
 	switch (io_req->fcp_status) {
@@ -1609,7 +1609,7 @@ void bnx2fc_process_tm_compl(struct bnx2fc_cmd *io_req,
 		return;
 	}
 
-	sc_cmd->SCp.ptr = NULL;
+	bnx2fc_priv(sc_cmd)->io_req = NULL;
 	scsi_done(sc_cmd);
 
 	kref_put(&io_req->refcount, bnx2fc_cmd_release);
@@ -1773,8 +1773,7 @@ static void bnx2fc_parse_fcp_rsp(struct bnx2fc_cmd *io_req,
 		io_req->fcp_resid = fcp_rsp->fcp_resid;
 
 	io_req->scsi_comp_flags = rsp_flags;
-	CMD_SCSI_STATUS(sc_cmd) = io_req->cdb_status =
-				fcp_rsp->scsi_status_code;
+	io_req->cdb_status = fcp_rsp->scsi_status_code;
 
 	/* Fetch fcp_rsp_info and fcp_sns_info if available */
 	if (num_rq) {
@@ -1946,8 +1945,8 @@ void bnx2fc_process_scsi_cmd_compl(struct bnx2fc_cmd *io_req,
 	/* parse fcp_rsp and obtain sense data from RQ if available */
 	bnx2fc_parse_fcp_rsp(io_req, fcp_rsp, num_rq, rq_data);
 
-	if (!sc_cmd->SCp.ptr) {
-		printk(KERN_ERR PFX "SCp.ptr is NULL\n");
+	if (!bnx2fc_priv(sc_cmd)->io_req) {
+		printk(KERN_ERR PFX "io_req is NULL\n");
 		return;
 	}
 
@@ -2018,7 +2017,7 @@ void bnx2fc_process_scsi_cmd_compl(struct bnx2fc_cmd *io_req,
 			io_req->fcp_status);
 		break;
 	}
-	sc_cmd->SCp.ptr = NULL;
+	bnx2fc_priv(sc_cmd)->io_req = NULL;
 	scsi_done(sc_cmd);
 	kref_put(&io_req->refcount, bnx2fc_cmd_release);
 }
@@ -2044,7 +2043,7 @@ int bnx2fc_post_io_req(struct bnx2fc_rport *tgt,
 	io_req->port = port;
 	io_req->tgt = tgt;
 	io_req->data_xfer_len = scsi_bufflen(sc_cmd);
-	sc_cmd->SCp.ptr = (char *)io_req;
+	bnx2fc_priv(sc_cmd)->io_req = io_req;
 
 	stats = per_cpu_ptr(lport->stats, get_cpu());
 	if (sc_cmd->sc_data_direction == DMA_FROM_DEVICE) {
