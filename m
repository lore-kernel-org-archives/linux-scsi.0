Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BEAAC4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 22:00:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbiI2WAv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Sep 2022 18:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbiI2WAq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2022 18:00:46 -0400
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72821121666
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 15:00:43 -0700 (PDT)
Received: by mail-pj1-f48.google.com with SMTP id i15-20020a17090a4b8f00b0020073b4ac27so2580533pjh.3
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 15:00:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=zEoOI/GhBCdXdf1k4vIpG//5UnLg6Ae74ISODalYCA0=;
        b=o4Nnsu+QyyODUif0UVDsBhQ0e+uWInuxoA2a3i+9H1/ylyLzrAZQDqkHw6ontDgE1B
         SATNtEryeN34k4zF/KZE0XVcIqgnVqq/hkd4oer9TGaEFR6tmK4DrEz81RXJTuGtBQHN
         Txhl4MTUZr4yHWatkun6GefphgXUz4jk3vTBegeGSSXEESNPgsOjl1KaZRMkBBzK8NQ5
         iEmaTlbIz088XPhgkydmoTyLO3843L1YHFWk6UzV3LdBOLmBzZ3viE+aWPyA+mTBmsh5
         ozP/YPsCkkT5m+QG51RV5MMW/uOLq28CDSaqMr9H4zXfeZqtAJBnoNBX9dYfsEugKCFS
         sbXw==
X-Gm-Message-State: ACrzQf1ohZCswZk2L/r6uxdbQgW8nmJOG/QszV5Zxv0vu9PUB72xO4zh
        fGx0MktPQH4n4vZsN+ilzrI=
X-Google-Smtp-Source: AMsMyM79i/JSvxw8TeY1PJL3nru1wSuZqid2VIGoFhFypkBH107Xy4TsdJEnu9XvFYCNM4AaqOWcZA==
X-Received: by 2002:a17:902:d70d:b0:177:fc1d:6af6 with SMTP id w13-20020a170902d70d00b00177fc1d6af6mr5701369ply.148.1664488841224;
        Thu, 29 Sep 2022 15:00:41 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:56f2:482f:20c2:1d35])
        by smtp.gmail.com with ESMTPSA id e3-20020a17090301c300b001782f94f8ebsm407787plh.3.2022.09.29.15.00.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 15:00:40 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Lee Duncan <lduncan@suse.com>, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>,
        John Garry <john.garry@huawei.com>,
        Mike Christie <michael.christie@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Chris Leech <cleech@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Khazhismel Kumykov <khazhy@google.com>
Subject: [PATCH v3 2/8] scsi: core: Change the return type of .eh_timed_out()
Date:   Thu, 29 Sep 2022 15:00:15 -0700
Message-Id: <20220929220021.247097-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
In-Reply-To: <20220929220021.247097-1-bvanassche@acm.org>
References: <20220929220021.247097-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit 6600593cbd93 ("block: rename BLK_EH_NOT_HANDLED to BLK_EH_DONE")
made it impossible for .eh_timed_out() implementations to call
scsi_done() without causing a crash. Restore support for SCSI timeout
handlers to call scsi_done() as follows:
* Change all .eh_timed_out() handlers as follows:
  - Change the return type into enum scsi_timeout_action.
  - Change BLK_EH_RESET_TIMER into SCSI_EH_RESET_TIMER.
  - Change BLK_EH_DONE into SCSI_EH_NOT_HANDLED.
* In scsi_timeout(), convert the SCSI_EH_* values into BLK_EH_* values.

Reviewed-by: Lee Duncan <lduncan@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: John Garry <john.garry@huawei.com>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 Documentation/scsi/scsi_eh.rst            |  7 +++--
 drivers/message/fusion/mptsas.c           |  8 +++---
 drivers/scsi/libiscsi.c                   | 26 +++++++++---------
 drivers/scsi/megaraid/megaraid_sas_base.c |  7 +++--
 drivers/scsi/mvumi.c                      |  4 +--
 drivers/scsi/qla4xxx/ql4_os.c             |  8 +++---
 drivers/scsi/scsi_error.c                 | 33 +++++++++++++----------
 drivers/scsi/scsi_transport_fc.c          |  6 ++---
 drivers/scsi/scsi_transport_srp.c         |  8 +++---
 drivers/scsi/storvsc_drv.c                |  4 +--
 drivers/scsi/virtio_scsi.c                |  4 +--
 include/scsi/libiscsi.h                   |  2 +-
 include/scsi/scsi_host.h                  | 14 +++++++++-
 include/scsi/scsi_transport_fc.h          |  2 +-
 include/scsi/scsi_transport_srp.h         |  2 +-
 15 files changed, 77 insertions(+), 58 deletions(-)

diff --git a/Documentation/scsi/scsi_eh.rst b/Documentation/scsi/scsi_eh.rst
index bad624fab823..104d09e9af09 100644
--- a/Documentation/scsi/scsi_eh.rst
+++ b/Documentation/scsi/scsi_eh.rst
@@ -92,14 +92,17 @@ The timeout handler is scsi_timeout().  When a timeout occurs, this function
  1. invokes optional hostt->eh_timed_out() callback.  Return value can
     be one of
 
-    - BLK_EH_RESET_TIMER
+    - SCSI_EH_RESET_TIMER
 	This indicates that more time is required to finish the
 	command.  Timer is restarted.
 
-    - BLK_EH_DONE
+    - SCSI_EH_NOT_HANDLED
         eh_timed_out() callback did not handle the command.
 	Step #2 is taken.
 
+    - SCSI_EH_DONE
+        eh_timed_out() completed the command.
+
  2. scsi_abort_command() is invoked to schedule an asynchronous abort which may
     issue a retry scmd->allowed + 1 times.  Asynchronous aborts are not invoked
     for commands for which the SCSI_EH_ABORT_SCHEDULED flag is set (this
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 34901bcd1ce8..88fe4a860ae5 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1952,12 +1952,12 @@ mptsas_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *SCpnt)
  *	@sc: scsi command that the midlayer is about to time out
  *
  **/
-static enum blk_eh_timer_return mptsas_eh_timed_out(struct scsi_cmnd *sc)
+static enum scsi_timeout_action mptsas_eh_timed_out(struct scsi_cmnd *sc)
 {
 	MPT_SCSI_HOST *hd;
 	MPT_ADAPTER   *ioc;
 	VirtDevice    *vdevice;
-	enum blk_eh_timer_return rc = BLK_EH_DONE;
+	enum scsi_timeout_action rc = SCSI_EH_NOT_HANDLED;
 
 	hd = shost_priv(sc->device->host);
 	if (hd == NULL) {
@@ -1980,7 +1980,7 @@ static enum blk_eh_timer_return mptsas_eh_timed_out(struct scsi_cmnd *sc)
 		dtmprintk(ioc, printk(MYIOC_s_WARN_FMT ": %s: ioc is in reset,"
 		    "SML need to reset the timer (sc=%p)\n",
 		    ioc->name, __func__, sc));
-		rc = BLK_EH_RESET_TIMER;
+		rc = SCSI_EH_RESET_TIMER;
 	}
 	vdevice = sc->device->hostdata;
 	if (vdevice && vdevice->vtarget && (vdevice->vtarget->inDMD
@@ -1988,7 +1988,7 @@ static enum blk_eh_timer_return mptsas_eh_timed_out(struct scsi_cmnd *sc)
 		dtmprintk(ioc, printk(MYIOC_s_WARN_FMT ": %s: target removed "
 		    "or in device removal delay (sc=%p)\n",
 		    ioc->name, __func__, sc));
-		rc = BLK_EH_RESET_TIMER;
+		rc = SCSI_EH_RESET_TIMER;
 		goto done;
 	}
 
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index d95f4bcdeb2e..ef2fc860257e 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2071,9 +2071,9 @@ static int iscsi_has_ping_timed_out(struct iscsi_conn *conn)
 		return 0;
 }
 
-enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
+enum scsi_timeout_action iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 {
-	enum blk_eh_timer_return rc = BLK_EH_DONE;
+	enum scsi_timeout_action rc = SCSI_EH_NOT_HANDLED;
 	struct iscsi_task *task = NULL, *running_task;
 	struct iscsi_cls_session *cls_session;
 	struct iscsi_session *session;
@@ -2093,7 +2093,7 @@ enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 		 * Raced with completion. Blk layer has taken ownership
 		 * so let timeout code complete it now.
 		 */
-		rc = BLK_EH_DONE;
+		rc = SCSI_EH_NOT_HANDLED;
 		spin_unlock(&session->back_lock);
 		goto done;
 	}
@@ -2102,7 +2102,7 @@ enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 		 * Racing with the completion path right now, so give it more
 		 * time so that path can complete it like normal.
 		 */
-		rc = BLK_EH_RESET_TIMER;
+		rc = SCSI_EH_RESET_TIMER;
 		task = NULL;
 		spin_unlock(&session->back_lock);
 		goto done;
@@ -2120,21 +2120,21 @@ enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 		if (unlikely(system_state != SYSTEM_RUNNING)) {
 			sc->result = DID_NO_CONNECT << 16;
 			ISCSI_DBG_EH(session, "sc on shutdown, handled\n");
-			rc = BLK_EH_DONE;
+			rc = SCSI_EH_NOT_HANDLED;
 			goto done;
 		}
 		/*
 		 * We are probably in the middle of iscsi recovery so let
 		 * that complete and handle the error.
 		 */
-		rc = BLK_EH_RESET_TIMER;
+		rc = SCSI_EH_RESET_TIMER;
 		goto done;
 	}
 
 	conn = session->leadconn;
 	if (!conn) {
 		/* In the middle of shuting down */
-		rc = BLK_EH_RESET_TIMER;
+		rc = SCSI_EH_RESET_TIMER;
 		goto done;
 	}
 
@@ -2151,7 +2151,7 @@ enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 			     "Last data xfer at %lu. Last timeout was at "
 			     "%lu\n.", task->last_xfer, task->last_timeout);
 		task->have_checked_conn = false;
-		rc = BLK_EH_RESET_TIMER;
+		rc = SCSI_EH_RESET_TIMER;
 		goto done;
 	}
 
@@ -2162,7 +2162,7 @@ enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 	 * and can let the iscsi eh handle it
 	 */
 	if (iscsi_has_ping_timed_out(conn)) {
-		rc = BLK_EH_RESET_TIMER;
+		rc = SCSI_EH_RESET_TIMER;
 		goto done;
 	}
 
@@ -2200,7 +2200,7 @@ enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 				     task->last_xfer, running_task->last_xfer,
 				     task->last_timeout);
 			spin_unlock(&session->back_lock);
-			rc = BLK_EH_RESET_TIMER;
+			rc = SCSI_EH_RESET_TIMER;
 			goto done;
 		}
 	}
@@ -2216,14 +2216,14 @@ enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 	 */
 	if (READ_ONCE(conn->ping_task)) {
 		task->have_checked_conn = true;
-		rc = BLK_EH_RESET_TIMER;
+		rc = SCSI_EH_RESET_TIMER;
 		goto done;
 	}
 
 	/* Make sure there is a transport check done */
 	iscsi_send_nopout(conn, NULL);
 	task->have_checked_conn = true;
-	rc = BLK_EH_RESET_TIMER;
+	rc = SCSI_EH_RESET_TIMER;
 
 done:
 	spin_unlock_bh(&session->frwd_lock);
@@ -2232,7 +2232,7 @@ enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
 		task->last_timeout = jiffies;
 		iscsi_put_task(task);
 	}
-	ISCSI_DBG_EH(session, "return %s\n", rc == BLK_EH_RESET_TIMER ?
+	ISCSI_DBG_EH(session, "return %s\n", rc == SCSI_EH_RESET_TIMER ?
 		     "timer reset" : "shutdown or nh");
 	return rc;
 }
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index ae6b9a570fa9..643b1a9a3480 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -2927,15 +2927,14 @@ static int megasas_generic_reset(struct scsi_cmnd *scmd)
  * Sets the FW busy flag and reduces the host->can_queue if the
  * cmd has not been completed within the timeout period.
  */
-static enum
-blk_eh_timer_return megasas_reset_timer(struct scsi_cmnd *scmd)
+static enum scsi_timeout_action megasas_reset_timer(struct scsi_cmnd *scmd)
 {
 	struct megasas_instance *instance;
 	unsigned long flags;
 
 	if (time_after(jiffies, scmd->jiffies_at_alloc +
 				(scmd_timeout * 2) * HZ)) {
-		return BLK_EH_DONE;
+		return SCSI_EH_NOT_HANDLED;
 	}
 
 	instance = (struct megasas_instance *)scmd->device->host->hostdata;
@@ -2949,7 +2948,7 @@ blk_eh_timer_return megasas_reset_timer(struct scsi_cmnd *scmd)
 
 		spin_unlock_irqrestore(instance->host->host_lock, flags);
 	}
-	return BLK_EH_RESET_TIMER;
+	return SCSI_EH_RESET_TIMER;
 }
 
 /**
diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 05d3ce9b72db..b3dcb8918618 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -2109,7 +2109,7 @@ static int mvumi_queue_command(struct Scsi_Host *shost,
 	return 0;
 }
 
-static enum blk_eh_timer_return mvumi_timed_out(struct scsi_cmnd *scmd)
+static enum scsi_timeout_action mvumi_timed_out(struct scsi_cmnd *scmd)
 {
 	struct mvumi_cmd *cmd = mvumi_priv(scmd)->cmd_priv;
 	struct Scsi_Host *host = scmd->device->host;
@@ -2137,7 +2137,7 @@ static enum blk_eh_timer_return mvumi_timed_out(struct scsi_cmnd *scmd)
 	mvumi_return_cmd(mhba, cmd);
 	spin_unlock_irqrestore(mhba->shost->host_lock, flags);
 
-	return BLK_EH_DONE;
+	return SCSI_EH_NOT_HANDLED;
 }
 
 static int
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 9e849f6b0d0f..005502125b27 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -116,7 +116,7 @@ static int qla4xxx_iface_set_param(struct Scsi_Host *shost, void *data,
 static int qla4xxx_get_iface_param(struct iscsi_iface *iface,
 				   enum iscsi_param_type param_type,
 				   int param, char *buf);
-static enum blk_eh_timer_return qla4xxx_eh_cmd_timed_out(struct scsi_cmnd *sc);
+static enum scsi_timeout_action qla4xxx_eh_cmd_timed_out(struct scsi_cmnd *sc);
 static struct iscsi_endpoint *qla4xxx_ep_connect(struct Scsi_Host *shost,
 						 struct sockaddr *dst_addr,
 						 int non_blocking);
@@ -1871,17 +1871,17 @@ static void qla4xxx_conn_get_stats(struct iscsi_cls_conn *cls_conn,
 	return;
 }
 
-static enum blk_eh_timer_return qla4xxx_eh_cmd_timed_out(struct scsi_cmnd *sc)
+static enum scsi_timeout_action qla4xxx_eh_cmd_timed_out(struct scsi_cmnd *sc)
 {
 	struct iscsi_cls_session *session;
 	unsigned long flags;
-	enum blk_eh_timer_return ret = BLK_EH_DONE;
+	enum scsi_timeout_action ret = SCSI_EH_NOT_HANDLED;
 
 	session = starget_to_session(scsi_target(sc->device));
 
 	spin_lock_irqsave(&session->lock, flags);
 	if (session->state == ISCSI_SESSION_FAILED)
-		ret = BLK_EH_RESET_TIMER;
+		ret = SCSI_EH_RESET_TIMER;
 	spin_unlock_irqrestore(&session->lock, flags);
 
 	return ret;
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index d1b07ff64a96..d3eee1435e47 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -328,7 +328,6 @@ void scsi_eh_scmd_add(struct scsi_cmnd *scmd)
 enum blk_eh_timer_return scsi_timeout(struct request *req)
 {
 	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
-	enum blk_eh_timer_return rtn = BLK_EH_DONE;
 	struct Scsi_Host *host = scmd->device->host;
 
 	trace_scsi_dispatch_cmd_timeout(scmd);
@@ -338,23 +337,29 @@ enum blk_eh_timer_return scsi_timeout(struct request *req)
 	if (host->eh_deadline != -1 && !host->last_reset)
 		host->last_reset = jiffies;
 
-	if (host->hostt->eh_timed_out)
-		rtn = host->hostt->eh_timed_out(scmd);
-
-	if (rtn == BLK_EH_DONE) {
-		/*
-		 * If scsi_done() has already set SCMD_STATE_COMPLETE, do not
-		 * modify *scmd.
-		 */
-		if (test_and_set_bit(SCMD_STATE_COMPLETE, &scmd->state))
+	if (host->hostt->eh_timed_out) {
+		switch (host->hostt->eh_timed_out(scmd)) {
+		case SCSI_EH_DONE:
 			return BLK_EH_DONE;
-		if (scsi_abort_command(scmd) != SUCCESS) {
-			set_host_byte(scmd, DID_TIME_OUT);
-			scsi_eh_scmd_add(scmd);
+		case SCSI_EH_RESET_TIMER:
+			return BLK_EH_RESET_TIMER;
+		case SCSI_EH_NOT_HANDLED:
+			break;
 		}
 	}
 
-	return rtn;
+	/*
+	 * If scsi_done() has already set SCMD_STATE_COMPLETE, do not modify
+	 * *scmd.
+	 */
+	if (test_and_set_bit(SCMD_STATE_COMPLETE, &scmd->state))
+		return BLK_EH_DONE;
+	if (scsi_abort_command(scmd) != SUCCESS) {
+		set_host_byte(scmd, DID_TIME_OUT);
+		scsi_eh_scmd_add(scmd);
+	}
+
+	return BLK_EH_DONE;
 }
 
 /**
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 8934160c4a33..7294bb98df92 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -2530,15 +2530,15 @@ static int fc_vport_match(struct attribute_container *cont,
  * Notes:
  *	This routine assumes no locks are held on entry.
  */
-enum blk_eh_timer_return
+enum scsi_timeout_action
 fc_eh_timed_out(struct scsi_cmnd *scmd)
 {
 	struct fc_rport *rport = starget_to_rport(scsi_target(scmd->device));
 
 	if (rport->port_state == FC_PORTSTATE_BLOCKED)
-		return BLK_EH_RESET_TIMER;
+		return SCSI_EH_RESET_TIMER;
 
-	return BLK_EH_DONE;
+	return SCSI_EH_NOT_HANDLED;
 }
 EXPORT_SYMBOL(fc_eh_timed_out);
 
diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index 98a34ed10f1a..87d0fb8dc503 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -594,13 +594,13 @@ EXPORT_SYMBOL(srp_reconnect_rport);
  * @scmd: SCSI command.
  *
  * If a timeout occurs while an rport is in the blocked state, ask the SCSI
- * EH to continue waiting (BLK_EH_RESET_TIMER). Otherwise let the SCSI core
- * handle the timeout (BLK_EH_DONE).
+ * EH to continue waiting (SCSI_EH_RESET_TIMER). Otherwise let the SCSI core
+ * handle the timeout (SCSI_EH_NOT_HANDLED).
  *
  * Note: This function is called from soft-IRQ context and with the request
  * queue lock held.
  */
-enum blk_eh_timer_return srp_timed_out(struct scsi_cmnd *scmd)
+enum scsi_timeout_action srp_timed_out(struct scsi_cmnd *scmd)
 {
 	struct scsi_device *sdev = scmd->device;
 	struct Scsi_Host *shost = sdev->host;
@@ -611,7 +611,7 @@ enum blk_eh_timer_return srp_timed_out(struct scsi_cmnd *scmd)
 	return rport && rport->fast_io_fail_tmo < 0 &&
 		rport->dev_loss_tmo < 0 &&
 		i->f->reset_timer_if_blocked && scsi_device_blocked(sdev) ?
-		BLK_EH_RESET_TIMER : BLK_EH_DONE;
+		SCSI_EH_RESET_TIMER : SCSI_EH_NOT_HANDLED;
 }
 EXPORT_SYMBOL(srp_timed_out);
 
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 25c44c87c972..169bbe510fca 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1643,13 +1643,13 @@ static int storvsc_host_reset_handler(struct scsi_cmnd *scmnd)
  * be unbounded on Azure.  Reset the timer unconditionally to give the host a
  * chance to perform EH.
  */
-static enum blk_eh_timer_return storvsc_eh_timed_out(struct scsi_cmnd *scmnd)
+static enum scsi_timeout_action storvsc_eh_timed_out(struct scsi_cmnd *scmnd)
 {
 #if IS_ENABLED(CONFIG_SCSI_FC_ATTRS)
 	if (scmnd->device->host->transportt == fc_transport_template)
 		return fc_eh_timed_out(scmnd);
 #endif
-	return BLK_EH_RESET_TIMER;
+	return SCSI_EH_RESET_TIMER;
 }
 
 static bool storvsc_scsi_cmd_ok(struct scsi_cmnd *scmnd)
diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 00cf6743db8c..0eda846b7365 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -731,9 +731,9 @@ static void virtscsi_commit_rqs(struct Scsi_Host *shost, u16 hwq)
  * latencies might be higher than on bare metal.  Reset the timer
  * unconditionally to give the host a chance to perform EH.
  */
-static enum blk_eh_timer_return virtscsi_eh_timed_out(struct scsi_cmnd *scmnd)
+static enum scsi_timeout_action virtscsi_eh_timed_out(struct scsi_cmnd *scmnd)
 {
-	return BLK_EH_RESET_TIMER;
+	return SCSI_EH_RESET_TIMER;
 }
 
 static struct scsi_host_template virtscsi_host_template = {
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 654cc3918c94..695eebc6f2c8 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -393,7 +393,7 @@ extern int iscsi_eh_recover_target(struct scsi_cmnd *sc);
 extern int iscsi_eh_session_reset(struct scsi_cmnd *sc);
 extern int iscsi_eh_device_reset(struct scsi_cmnd *sc);
 extern int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc);
-extern enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc);
+extern enum scsi_timeout_action iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc);
 
 /*
  * iSCSI host helpers.
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index aa7b7496c93a..85b2c4986dea 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -27,6 +27,18 @@ struct scsi_transport_template;
 #define MODE_INITIATOR 0x01
 #define MODE_TARGET 0x02
 
+/**
+ * enum scsi_timeout_action - How to handle a command that timed out.
+ * @SCSI_EH_DONE: The command has already been completed.
+ * @SCSI_EH_RESET_TIMER: Reset the timer and continue waiting for completion.
+ * @SCSI_EH_NOT_HANDLED: The command has not yet finished. Abort the command.
+ */
+enum scsi_timeout_action {
+	SCSI_EH_DONE,
+	SCSI_EH_RESET_TIMER,
+	SCSI_EH_NOT_HANDLED,
+};
+
 struct scsi_host_template {
 	/*
 	 * Put fields referenced in IO submission path together in
@@ -331,7 +343,7 @@ struct scsi_host_template {
 	 *
 	 * Status: OPTIONAL
 	 */
-	enum blk_eh_timer_return (*eh_timed_out)(struct scsi_cmnd *);
+	enum scsi_timeout_action (*eh_timed_out)(struct scsi_cmnd *);
 	/*
 	 * Optional routine that allows the transport to decide if a cmd
 	 * is retryable. Return true if the transport is in a state the
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index e80a7c542c88..3dcda19d3520 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -862,7 +862,7 @@ struct fc_vport *fc_vport_create(struct Scsi_Host *shost, int channel,
 int fc_vport_terminate(struct fc_vport *vport);
 int fc_block_rport(struct fc_rport *rport);
 int fc_block_scsi_eh(struct scsi_cmnd *cmnd);
-enum blk_eh_timer_return fc_eh_timed_out(struct scsi_cmnd *scmd);
+enum scsi_timeout_action fc_eh_timed_out(struct scsi_cmnd *scmd);
 bool fc_eh_should_retry_cmd(struct scsi_cmnd *scmd);
 
 static inline struct Scsi_Host *fc_bsg_to_shost(struct bsg_job *job)
diff --git a/include/scsi/scsi_transport_srp.h b/include/scsi/scsi_transport_srp.h
index d22df12584f9..dfc78aa112ad 100644
--- a/include/scsi/scsi_transport_srp.h
+++ b/include/scsi/scsi_transport_srp.h
@@ -118,7 +118,7 @@ extern int srp_reconnect_rport(struct srp_rport *rport);
 extern void srp_start_tl_fail_timers(struct srp_rport *rport);
 extern void srp_remove_host(struct Scsi_Host *);
 extern void srp_stop_rport_timers(struct srp_rport *rport);
-enum blk_eh_timer_return srp_timed_out(struct scsi_cmnd *scmd);
+enum scsi_timeout_action srp_timed_out(struct scsi_cmnd *scmd);
 
 /**
  * srp_chkready() - evaluate the transport layer state before I/O
