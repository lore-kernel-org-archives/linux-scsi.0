Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E8BAC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 19:52:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238479AbiBRTwt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Feb 2022 14:52:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238495AbiBRTwo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Feb 2022 14:52:44 -0500
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55CC3D7E
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:52:27 -0800 (PST)
Received: by mail-pl1-f172.google.com with SMTP id y18so7952448plb.11
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:52:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YP61j+bdAl74dbQczTSGv63U//0SRph+YlxAjDYjbWs=;
        b=vOmqevbpyOJHKh5mThHie70U8tfFVMM/XzhqLQaSDnpH4BKbok4biXyrxa3pKF5+qE
         oClQ92emdtxUHi/BDmQqDL2wEw4GAbT3nyxUjefLfZOLDheNda2avMhWgdtpRvnOpffo
         GQucajVB9w5yurHd4LX80cdtw25RbzoKqq4WBu6cv85Tv0vugRfW+1hhr+p+TJEVqHwv
         pJlLpmgany7xsHV0ZJV5PTUBYtNvxYhiqGmTF+WXiIBZpwY3g/ZcF8C7m4eYbO3WWc1A
         gHQEpOHunDJRyYPmbOyzw28L3lA9dvLunC9vpglRTSOMxqEGxNMzhs29VDwyKSz6Ta8X
         EgUA==
X-Gm-Message-State: AOAM532OUP4ejAMv+VolQrzJ/83VXeIxcbvRpKggMwgCLsWeiKWzC83t
        vxoGp6L4wa/jzlXr7t1txCQ=
X-Google-Smtp-Source: ABdhPJw1e3Dsu2jJkAO75oOabKLm2sHp6ZbyC4vk//sejcup0hkPEBAke4bM3RKZNusTJi8VjOmTsw==
X-Received: by 2002:a17:902:7002:b0:14d:76b9:2303 with SMTP id y2-20020a170902700200b0014d76b92303mr8981727plk.155.1645213946699;
        Fri, 18 Feb 2022 11:52:26 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id e15sm3930523pfv.104.2022.02.18.11.52.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 11:52:25 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 27/49] scsi: libfc: Stop using the SCSI pointer
Date:   Fri, 18 Feb 2022 11:50:55 -0800
Message-Id: <20220218195117.25689-28-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220218195117.25689-1-bvanassche@acm.org>
References: <20220218195117.25689-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move the fc_fcp_pkt pointer, the residual length and the SCSI status into
the new data structure libfc_cmd_priv. This patch prepares for removal of
the SCSI pointer from struct scsi_cmnd.

The user of the libfc data path functions have been identified as follows:
$ git grep -lw fc_queuecommand | grep -v scsi/libfc/
drivers/scsi/fcoe/fcoe.c

Cc: Saurav Kashyap <skashyap@marvell.com>
Cc: Javed Hasan <jhasan@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/fcoe/fcoe.c    |  1 +
 drivers/scsi/libfc/fc_fcp.c | 26 +++++++++++---------------
 include/scsi/libfc.h        |  9 +++++++++
 3 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 6415f88738ad..44ca6110213c 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -277,6 +277,7 @@ static struct scsi_host_template fcoe_shost_template = {
 	.sg_tablesize = SG_ALL,
 	.max_sectors = 0xffff,
 	.track_queue_depth = 1,
+	.cmd_size = sizeof(struct libfc_cmd_priv),
 };
 
 /**
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 871b11edb586..bce90eb56c9c 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -45,14 +45,10 @@ static struct kmem_cache *scsi_pkt_cachep;
 #define FC_SRB_READ		(1 << 1)
 #define FC_SRB_WRITE		(1 << 0)
 
-/*
- * The SCp.ptr should be tested and set under the scsi_pkt_queue lock
- */
-#define CMD_SP(Cmnd)		    ((struct fc_fcp_pkt *)(Cmnd)->SCp.ptr)
-#define CMD_ENTRY_STATUS(Cmnd)	    ((Cmnd)->SCp.have_data_in)
-#define CMD_COMPL_STATUS(Cmnd)	    ((Cmnd)->SCp.this_residual)
-#define CMD_SCSI_STATUS(Cmnd)	    ((Cmnd)->SCp.Status)
-#define CMD_RESID_LEN(Cmnd)	    ((Cmnd)->SCp.buffers_residual)
+static struct libfc_cmd_priv *libfc_priv(struct scsi_cmnd *cmd)
+{
+	return scsi_cmd_priv(cmd);
+}
 
 /**
  * struct fc_fcp_internal - FCP layer internal data
@@ -1137,7 +1133,7 @@ static int fc_fcp_pkt_send(struct fc_lport *lport, struct fc_fcp_pkt *fsp)
 	unsigned long flags;
 	int rc;
 
-	fsp->cmd->SCp.ptr = (char *)fsp;
+	libfc_priv(fsp->cmd)->fsp = fsp;
 	fsp->cdb_cmd.fc_dl = htonl(fsp->data_len);
 	fsp->cdb_cmd.fc_flags = fsp->req_flags & ~FCP_CFL_LEN_MASK;
 
@@ -1150,7 +1146,7 @@ static int fc_fcp_pkt_send(struct fc_lport *lport, struct fc_fcp_pkt *fsp)
 	rc = lport->tt.fcp_cmd_send(lport, fsp, fc_fcp_recv);
 	if (unlikely(rc)) {
 		spin_lock_irqsave(&si->scsi_queue_lock, flags);
-		fsp->cmd->SCp.ptr = NULL;
+		libfc_priv(fsp->cmd)->fsp = NULL;
 		list_del(&fsp->list);
 		spin_unlock_irqrestore(&si->scsi_queue_lock, flags);
 	}
@@ -1983,7 +1979,7 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
 		fc_fcp_can_queue_ramp_up(lport);
 
 	sc_cmd = fsp->cmd;
-	CMD_SCSI_STATUS(sc_cmd) = fsp->cdb_status;
+	libfc_priv(sc_cmd)->status = fsp->cdb_status;
 	switch (fsp->status_code) {
 	case FC_COMPLETE:
 		if (fsp->cdb_status == 0) {
@@ -1992,7 +1988,7 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
 			 */
 			sc_cmd->result = DID_OK << 16;
 			if (fsp->scsi_resid)
-				CMD_RESID_LEN(sc_cmd) = fsp->scsi_resid;
+				libfc_priv(sc_cmd)->resid_len = fsp->scsi_resid;
 		} else {
 			/*
 			 * transport level I/O was ok but scsi
@@ -2025,7 +2021,7 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
 			 */
 			FC_FCP_DBG(fsp, "Returning DID_ERROR to scsi-ml "
 				   "due to FC_DATA_UNDRUN (scsi)\n");
-			CMD_RESID_LEN(sc_cmd) = fsp->scsi_resid;
+			libfc_priv(sc_cmd)->resid_len = fsp->scsi_resid;
 			sc_cmd->result = (DID_ERROR << 16) | fsp->cdb_status;
 		}
 		break;
@@ -2085,7 +2081,7 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
 
 	spin_lock_irqsave(&si->scsi_queue_lock, flags);
 	list_del(&fsp->list);
-	sc_cmd->SCp.ptr = NULL;
+	libfc_priv(sc_cmd)->fsp = NULL;
 	spin_unlock_irqrestore(&si->scsi_queue_lock, flags);
 	scsi_done(sc_cmd);
 
@@ -2121,7 +2117,7 @@ int fc_eh_abort(struct scsi_cmnd *sc_cmd)
 
 	si = fc_get_scsi_internal(lport);
 	spin_lock_irqsave(&si->scsi_queue_lock, flags);
-	fsp = CMD_SP(sc_cmd);
+	fsp = libfc_priv(sc_cmd)->fsp;
 	if (!fsp) {
 		/* command completed while scsi eh was setting up */
 		spin_unlock_irqrestore(&si->scsi_queue_lock, flags);
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index eeb8d689ff6b..6e29e1719db1 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -351,6 +351,15 @@ struct fc_fcp_pkt {
 	struct completion tm_done;
 } ____cacheline_aligned_in_smp;
 
+/*
+ * @fsp should be tested and set under the scsi_pkt_queue lock
+ */
+struct libfc_cmd_priv {
+	struct fc_fcp_pkt *fsp;
+	u32 resid_len;
+	u8 status;
+};
+
 /*
  * Structure and function definitions for managing Fibre Channel Exchanges
  * and Sequences
