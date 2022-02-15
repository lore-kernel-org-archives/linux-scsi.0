Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7716C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Feb 2022 03:00:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbiBODBA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Feb 2022 22:01:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbiBODBA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Feb 2022 22:01:00 -0500
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2822412223C
        for <linux-scsi@vger.kernel.org>; Mon, 14 Feb 2022 19:00:50 -0800 (PST)
Received: by mail-pj1-f44.google.com with SMTP id v5-20020a17090a4ec500b001b8b702df57so1278092pjl.2
        for <linux-scsi@vger.kernel.org>; Mon, 14 Feb 2022 19:00:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ByfXnAwflntJmmGZmu+gEHUOlpdlzpOXi1npyaWFRAw=;
        b=0TA8rNbe3uCAribdvQ2xx9TcGTJl3NHWxfBje9pPwLezMU5M0tV8ZeLSBSu20RFqoi
         +e2qtQy+usNnr35uUFi7q+VGPBVMIvfx9i21Sag1K+22dNQd6iXlPvPIxvvAcccn1940
         +CqMDVgv3ZFVqgrMjC+Lap9S2P88YsxXKjkoKQwis5ggZf2xiC+zIEQzoW13he6SV3d4
         4yHWU0fnTAnqHRETtJb5XOzArujZ1hu9LZpJpXUjY6mZT+79oLdSqpN0OdXcqYCIVQo6
         Fx1KZtxR0TbT/vXWuHY3/MnUMru0UiJ/amVgmrDy6yzkgTAaq2q5/KXTULYAxkYi7tt9
         Qbug==
X-Gm-Message-State: AOAM532Wq1T89/7ctQnd+9vx62EVrcN10KU6Vv3wOisu/lnvH2t+NjRX
        B0afR1vKj0akOupnF080QE4=
X-Google-Smtp-Source: ABdhPJyJFKC1d0AYkiuazgIZ0huv04x9S7difoX5hSasGyVanjYCn8EBawSk4h3ifrcugUYlS2d+DQ==
X-Received: by 2002:a17:902:d2c2:: with SMTP id n2mr2004786plc.5.1644894049381;
        Mon, 14 Feb 2022 19:00:49 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id 6sm801438pgx.36.2022.02.14.19.00.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Feb 2022 19:00:48 -0800 (PST)
Message-ID: <09dae05e-3e53-cd31-1538-9a715ca16774@acm.org>
Date:   Mon, 14 Feb 2022 19:00:47 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v3 28/48] scsi: libfc: Stop using the SCSI pointer
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>
References: <20220211223247.14369-1-bvanassche@acm.org>
 <20220211223247.14369-29-bvanassche@acm.org>
 <2b079541-4333-535f-3f20-abb3feca85da@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <2b079541-4333-535f-3f20-abb3feca85da@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/14/22 03:55, Hannes Reinecke wrote:
> I had a closer look at the usage of SCp.ptr in the various FCoE drivers, and it turns out that all have their own private use of SCp.ptr.
> The only 'generic' use of SCp.ptr (where it points to 'struct libfc_cmd_priv') is in fcoe/fcoe.c.
> For the others (bnx2fc, qedf, and fnic) they point to their own, private, data structure, and there's no overlap with libfc itself.
> So no need to have a combined structure, and each driver should use
> their own data structure only.
> (IE bnx2fc_priv should just have the 'bnx2fc_cmd' pointer).

How about splitting this patch into the three patches below?

Thanks,

Bart.

----------------------------------------------------------------------
 From b8e0bea7fc2d4802b274121fefdd9570ae61e744 Mon Sep 17 00:00:00 2001
From: Bart Van Assche <bvanassche@acm.org>
Date: Fri, 14 Jan 2022 14:37:10 -0800
Subject: [PATCH 1/3] scsi: libfc: Stop using the SCSI pointer

Move the fc_fcp_pkt pointer, the residual length and the SCSI status into
the new data structure libfc_cmd_priv. This patch prepares for removal of
the SCSI pointer from struct scsi_cmnd.

The user of the libfc data path functions have been identified as follows:
$ git grep -lw fc_queuecommand | grep -v scsi/libfc/
drivers/scsi/fcoe/fcoe.c

Cc: Hannes Reinecke <hare@suse.de>
Cc: Saurav Kashyap <skashyap@marvell.com>
Cc: Javed Hasan <jhasan@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
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
----------------------------------------------------------------------
 From bd1e682f07fc47350989b557229d0075d9927aa6 Mon Sep 17 00:00:00 2001
From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 14 Feb 2022 09:55:18 -0800
Subject: [PATCH 2/3] scsi: bnx2fc: Stop using the SCSI pointer

Set .cmd_size in the SCSI host template instead of using the SCSI pointer
from struct scsi_cmnd. This patch prepares for removal of the SCSI pointer
from struct scsi_cmnd.

Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
  drivers/scsi/bnx2fc/bnx2fc.h      | 10 ++++++++--
  drivers/scsi/bnx2fc/bnx2fc_fcoe.c |  1 +
  drivers/scsi/bnx2fc/bnx2fc_io.c   | 24 ++++++++++++------------
  3 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index b4cea8b06ea1..e89562382acf 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -137,8 +137,6 @@
  #define BNX2FC_FW_TIMEOUT		(3 * HZ)
  #define PORT_MAX			2

-#define CMD_SCSI_STATUS(Cmnd)		((Cmnd)->SCp.Status)
-
  /* FC FCP Status */
  #define	FC_GOOD				0

@@ -493,7 +491,15 @@ struct bnx2fc_unsol_els {
  	struct work_struct unsol_els_work;
  };

+struct bnx2fc_priv {
+	struct bnx2fc_cmd *io_req;
+	u8		   status;
+};

+static inline struct bnx2fc_priv *bnx2fc_priv(struct scsi_cmnd *cmd)
+{
+	return scsi_cmd_priv(cmd);
+}

  struct bnx2fc_cmd *bnx2fc_cmd_alloc(struct bnx2fc_rport *tgt);
  struct bnx2fc_cmd *bnx2fc_elstm_alloc(struct bnx2fc_rport *tgt, int type);
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index a826456c6075..2d5c71967ee3 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -2975,6 +2975,7 @@ static struct scsi_host_template bnx2fc_shost_template = {
  	.track_queue_depth	= 1,
  	.slave_configure	= bnx2fc_slave_configure,
  	.shost_groups		= bnx2fc_host_groups,
+	.cmd_size		= sizeof(struct bnx2fc_priv),
  };

  static struct libfc_function_template bnx2fc_libfc_fcn_templ = {
diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index b9114113ee73..b560bfcf9ee2 100644
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
@@ -1773,8 +1773,8 @@ static void bnx2fc_parse_fcp_rsp(struct bnx2fc_cmd *io_req,
  		io_req->fcp_resid = fcp_rsp->fcp_resid;

  	io_req->scsi_comp_flags = rsp_flags;
-	CMD_SCSI_STATUS(sc_cmd) = io_req->cdb_status =
-				fcp_rsp->scsi_status_code;
+	bnx2fc_priv(sc_cmd)->status = io_req->cdb_status =
+		fcp_rsp->scsi_status_code;

  	/* Fetch fcp_rsp_info and fcp_sns_info if available */
  	if (num_rq) {
@@ -1946,8 +1946,8 @@ void bnx2fc_process_scsi_cmd_compl(struct bnx2fc_cmd *io_req,
  	/* parse fcp_rsp and obtain sense data from RQ if available */
  	bnx2fc_parse_fcp_rsp(io_req, fcp_rsp, num_rq, rq_data);

-	if (!sc_cmd->SCp.ptr) {
-		printk(KERN_ERR PFX "SCp.ptr is NULL\n");
+	if (!bnx2fc_priv(sc_cmd)->io_req) {
+		printk(KERN_ERR PFX "io_req is NULL\n");
  		return;
  	}

@@ -2018,7 +2018,7 @@ void bnx2fc_process_scsi_cmd_compl(struct bnx2fc_cmd *io_req,
  			io_req->fcp_status);
  		break;
  	}
-	sc_cmd->SCp.ptr = NULL;
+	bnx2fc_priv(sc_cmd)->io_req = NULL;
  	scsi_done(sc_cmd);
  	kref_put(&io_req->refcount, bnx2fc_cmd_release);
  }
@@ -2044,7 +2044,7 @@ int bnx2fc_post_io_req(struct bnx2fc_rport *tgt,
  	io_req->port = port;
  	io_req->tgt = tgt;
  	io_req->data_xfer_len = scsi_bufflen(sc_cmd);
-	sc_cmd->SCp.ptr = (char *)io_req;
+	bnx2fc_priv(sc_cmd)->io_req = io_req;

  	stats = per_cpu_ptr(lport->stats, get_cpu());
  	if (sc_cmd->sc_data_direction == DMA_FROM_DEVICE) {
----------------------------------------------------------------------
 From 25f7a76c224ef90eaba57da9c1153329b4b19899 Mon Sep 17 00:00:00 2001
From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 14 Feb 2022 09:55:29 -0800
Subject: [PATCH 3/3] scsi: qedf: Stop using the SCSI pointer

Set .cmd_size in the SCSI host template instead of using the SCSI pointer
from struct scsi_cmnd. This patch prepares for removal of the SCSI pointer
from struct scsi_cmnd.

Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
  drivers/scsi/qedf/qedf.h      | 11 ++++++++++-
  drivers/scsi/qedf/qedf_io.c   | 24 ++++++++++++------------
  drivers/scsi/qedf/qedf_main.c |  3 ++-
  3 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/qedf/qedf.h b/drivers/scsi/qedf/qedf.h
index ca987451b17e..f51259d903d4 100644
--- a/drivers/scsi/qedf/qedf.h
+++ b/drivers/scsi/qedf/qedf.h
@@ -91,7 +91,6 @@ enum qedf_ioreq_event {
  #define FC_GOOD		0
  #define FCOE_FCP_RSP_FLAGS_FCP_RESID_OVER	(0x1<<2)
  #define FCOE_FCP_RSP_FLAGS_FCP_RESID_UNDER	(0x1<<3)
-#define CMD_SCSI_STATUS(Cmnd)			((Cmnd)->SCp.Status)
  #define FCOE_FCP_RSP_FLAGS_FCP_RSP_LEN_VALID	(0x1<<0)
  #define FCOE_FCP_RSP_FLAGS_FCP_SNS_LEN_VALID	(0x1<<1)
  struct qedf_ioreq {
@@ -189,6 +188,16 @@ struct qedf_ioreq {
  	unsigned int alloc;
  };

+struct qedf_cmd_priv {
+	struct qedf_ioreq *io_req;
+	u8		   status;
+};
+
+static inline struct qedf_cmd_priv *qedf_priv(struct scsi_cmnd *cmd)
+{
+	return scsi_cmd_priv(cmd);
+}
+
  extern struct workqueue_struct *qedf_io_wq;

  struct qedf_rport {
diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index fab43dabe5b3..ea7edb4b9c3f 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -857,7 +857,7 @@ int qedf_post_io_req(struct qedf_rport *fcport, struct qedf_ioreq *io_req)

  	/* Initialize rest of io_req fileds */
  	io_req->data_xfer_len = scsi_bufflen(sc_cmd);
-	sc_cmd->SCp.ptr = (char *)io_req;
+	qedf_priv(sc_cmd)->io_req = io_req;
  	io_req->sge_type = QEDF_IOREQ_FAST_SGE; /* Assume fast SGL by default */

  	/* Record which cpu this request is associated with */
@@ -1065,7 +1065,7 @@ static void qedf_parse_fcp_rsp(struct qedf_ioreq *io_req,
  		io_req->fcp_resid = fcp_rsp->fcp_resid;

  	io_req->scsi_comp_flags = rsp_flags;
-	CMD_SCSI_STATUS(sc_cmd) = io_req->cdb_status =
+	qedf_priv(sc_cmd)->status = io_req->cdb_status =
  	    fcp_rsp->scsi_status_code;

  	if (rsp_flags &
@@ -1150,9 +1150,9 @@ void qedf_scsi_completion(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
  		return;
  	}

-	if (!sc_cmd->SCp.ptr) {
-		QEDF_WARN(&(qedf->dbg_ctx), "SCp.ptr is NULL, returned in "
-		    "another context.\n");
+	if (!qedf_priv(sc_cmd)->io_req) {
+		QEDF_WARN(&(qedf->dbg_ctx),
+			  "io_req is NULL, returned in another context.\n");
  		return;
  	}

@@ -1312,7 +1312,7 @@ void qedf_scsi_completion(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
  	clear_bit(QEDF_CMD_OUTSTANDING, &io_req->flags);

  	io_req->sc_cmd = NULL;
-	sc_cmd->SCp.ptr =  NULL;
+	qedf_priv(sc_cmd)->io_req =  NULL;
  	scsi_done(sc_cmd);
  	kref_put(&io_req->refcount, qedf_release_cmd);
  }
@@ -1354,9 +1354,9 @@ void qedf_scsi_done(struct qedf_ctx *qedf, struct qedf_ioreq *io_req,
  		goto bad_scsi_ptr;
  	}

-	if (!sc_cmd->SCp.ptr) {
-		QEDF_WARN(&(qedf->dbg_ctx), "SCp.ptr is NULL, returned in "
-		    "another context.\n");
+	if (!qedf_priv(sc_cmd)->io_req) {
+		QEDF_WARN(&(qedf->dbg_ctx),
+			  "io_req is NULL, returned in another context.\n");
  		return;
  	}

@@ -1409,7 +1409,7 @@ void qedf_scsi_done(struct qedf_ctx *qedf, struct qedf_ioreq *io_req,
  		qedf_trace_io(io_req->fcport, io_req, QEDF_IO_TRACE_RSP);

  	io_req->sc_cmd = NULL;
-	sc_cmd->SCp.ptr = NULL;
+	qedf_priv(sc_cmd)->io_req = NULL;
  	scsi_done(sc_cmd);
  	kref_put(&io_req->refcount, qedf_release_cmd);
  	return;
@@ -2433,8 +2433,8 @@ int qedf_initiate_tmf(struct scsi_cmnd *sc_cmd, u8 tm_flags)
  		 (tm_flags == FCP_TMF_TGT_RESET) ? "TARGET RESET" :
  		 "LUN RESET");

-	if (sc_cmd->SCp.ptr) {
-		io_req = (struct qedf_ioreq *)sc_cmd->SCp.ptr;
+	if (qedf_priv(sc_cmd)->io_req) {
+		io_req = qedf_priv(sc_cmd)->io_req;
  		ref_cnt = kref_read(&io_req->refcount);
  		QEDF_ERR(NULL,
  			 "orig io_req = %p xid = 0x%x ref_cnt = %d.\n",
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 6ad28bc8e948..18dc68d577b6 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -740,7 +740,7 @@ static int qedf_eh_abort(struct scsi_cmnd *sc_cmd)
  	}


-	io_req = (struct qedf_ioreq *)sc_cmd->SCp.ptr;
+	io_req = qedf_priv(sc_cmd)->io_req;
  	if (!io_req) {
  		QEDF_ERR(&qedf->dbg_ctx,
  			 "sc_cmd not queued with lld, sc_cmd=%p op=0x%02x, port_id=%06x\n",
@@ -996,6 +996,7 @@ static struct scsi_host_template qedf_host_template = {
  	.sg_tablesize = QEDF_MAX_BDS_PER_CMD,
  	.can_queue = FCOE_PARAMS_NUM_TASKS,
  	.change_queue_depth = scsi_change_queue_depth,
+	.cmd_size = sizeof(struct qedf_cmd_priv),
  };

  static int qedf_get_paged_crc_eof(struct sk_buff *skb, int tlen)
