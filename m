Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B392AC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F894613AA
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232957AbhDTAJl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:09:41 -0400
Received: from mail-pj1-f51.google.com ([209.85.216.51]:33756 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232903AbhDTAJi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:09:38 -0400
Received: by mail-pj1-f51.google.com with SMTP id kb13-20020a17090ae7cdb02901503d67f0beso397125pjb.0
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:09:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dqYxgSnUpuqY7WGaxyiFYNqWkCJkcjfy38j5CcD3yCY=;
        b=igPtEgprj7cvRVv/MF8lRcK4wTTsr3lFamtd7bmS4xTWHWrryB3uAPTbzBMaYmeQUk
         mPn9CPTrcQYnJAOFND8YMli8Lsk+q+3H5C4HYX3KAwEdWt8eBfSAqfs1i553EE4A2CQP
         rLn6EHnkvf4oZRc6bLEjnG7L2bIWHll4HZIM/qo5JckGN4T+ES/SdMfI/D3bVTi17K89
         gtwm8OPZvAbQmD1WvqpeTzJjeiZ3XNsyvg/ZuNXjCW4fmIMachhmQpm3eOymcoShSLJG
         Jr67QiBwJedc1A7TltmDgkPK96O1PkS7tKqfSGRSqTP+9s/fnhUv49M+ajmywoP9KtgS
         QVUg==
X-Gm-Message-State: AOAM531UYzBWJBakstFYPgrPWS9gE/E0vAn+dyl80FIJhZW8RbxtNiuy
        +PEdZ/ybZnQoTMLSkcC2Jyc=
X-Google-Smtp-Source: ABdhPJzgRu6Dxq6wX80u7hnB2QqJRsKB0IqNqEbD/yuWzCIAk8W0hP1Ab/6hWwnkjtUc8EO4Bm9CDg==
X-Received: by 2002:a17:90a:94c4:: with SMTP id j4mr1743152pjw.14.1618877347428;
        Mon, 19 Apr 2021 17:09:07 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.09.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:09:06 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 013/117] core: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:07:01 -0700
Message-Id: <20210420000845.25873-14-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

An explanation of the purpose of this patch is available in the patch
"scsi: Introduce the scsi_status union".

Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 20 ++++----
 drivers/scsi/hosts.c                       |  2 +-
 drivers/scsi/scsi.c                        |  8 +--
 drivers/scsi/scsi_debugfs.c                |  2 +-
 drivers/scsi/scsi_error.c                  | 44 ++++++++--------
 drivers/scsi/scsi_ioctl.c                  | 12 ++---
 drivers/scsi/scsi_lib.c                    | 59 ++++++++++++----------
 drivers/scsi/scsi_logging.c                |  8 +--
 drivers/scsi/scsi_scan.c                   | 15 +++---
 drivers/scsi/scsi_transport_spi.c          |  8 +--
 include/trace/events/scsi.h                |  2 +-
 11 files changed, 96 insertions(+), 84 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index efa8c0381476..d8269cdec399 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -517,7 +517,8 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 	int len, k, off, bufflen = ALUA_RTPG_SIZE;
 	int group_id_old, state_old, pref_old, valid_states_old;
 	unsigned char *desc, *buff;
-	unsigned err, retval;
+	unsigned err;
+	union scsi_status retval;
 	unsigned int tpg_desc_tbl_off;
 	unsigned char orig_transition_tmo;
 	unsigned long flags;
@@ -543,9 +544,10 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 
  retry:
 	err = 0;
-	retval = submit_rtpg(sdev, buff, bufflen, &sense_hdr, pg->flags);
+	retval.combined = submit_rtpg(sdev, buff, bufflen, &sense_hdr,
+				      pg->flags);
 
-	if (retval) {
+	if (retval.combined) {
 		/*
 		 * Some (broken) implementations have a habit of returning
 		 * an error during things like firmware update etc.
@@ -558,14 +560,14 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 		if ((pg->valid_states & ~TPGS_SUPPORT_OPTIMIZED) == 0) {
 			sdev_printk(KERN_INFO, sdev,
 				    "%s: ignoring rtpg result %d\n",
-				    ALUA_DH_NAME, retval);
+				    ALUA_DH_NAME, retval.combined);
 			kfree(buff);
 			return SCSI_DH_OK;
 		}
 		if (!scsi_sense_valid(&sense_hdr)) {
 			sdev_printk(KERN_INFO, sdev,
 				    "%s: rtpg failed, result %d\n",
-				    ALUA_DH_NAME, retval);
+				    ALUA_DH_NAME, retval.combined);
 			kfree(buff);
 			if (driver_byte(retval) == DRIVER_ERROR)
 				return SCSI_DH_DEV_TEMP_BUSY;
@@ -759,7 +761,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
  */
 static unsigned alua_stpg(struct scsi_device *sdev, struct alua_port_group *pg)
 {
-	int retval;
+	union scsi_status retval;
 	struct scsi_sense_hdr sense_hdr;
 
 	if (!(pg->tpgs & TPGS_MODE_EXPLICIT)) {
@@ -788,13 +790,13 @@ static unsigned alua_stpg(struct scsi_device *sdev, struct alua_port_group *pg)
 			    ALUA_DH_NAME, pg->state);
 		return SCSI_DH_NOSYS;
 	}
-	retval = submit_stpg(sdev, pg->group_id, &sense_hdr);
+	retval.combined = submit_stpg(sdev, pg->group_id, &sense_hdr);
 
-	if (retval) {
+	if (retval.combined) {
 		if (!scsi_sense_valid(&sense_hdr)) {
 			sdev_printk(KERN_INFO, sdev,
 				    "%s: stpg failed, result %d",
-				    ALUA_DH_NAME, retval);
+				    ALUA_DH_NAME, retval.combined);
 			if (driver_byte(retval) == DRIVER_ERROR)
 				return SCSI_DH_DEV_TEMP_BUSY;
 		} else {
diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index b551e0ee2271..4c1e80a4a7c3 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -660,7 +660,7 @@ static bool complete_all_cmds_iter(struct request *rq, void *data, bool rsvd)
 	enum host_status status = *(enum host_status *)data;
 
 	scsi_dma_unmap(scmd);
-	scmd->result = 0;
+	scmd->status.combined = 0;
 	set_host_byte(scmd, status);
 	scmd->scsi_done(scmd);
 	return true;
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 4f71f2005be4..c6f3bbec8982 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -140,11 +140,11 @@ void scsi_log_completion(struct scsi_cmnd *cmd, int disposition)
 	if (unlikely(scsi_logging_level)) {
 		level = SCSI_LOG_LEVEL(SCSI_LOG_MLCOMPLETE_SHIFT,
 				       SCSI_LOG_MLCOMPLETE_BITS);
-		if (((level > 0) && (cmd->result || disposition != SUCCESS)) ||
+		if (((level > 0) && (cmd->status.combined || disposition != SUCCESS)) ||
 		    (level > 1)) {
 			scsi_print_result(cmd, "Done", disposition);
 			scsi_print_command(cmd);
-			if (status_byte(cmd->result) == CHECK_CONDITION)
+			if (status_byte(cmd->status) == CHECK_CONDITION)
 				scsi_print_sense(cmd);
 			if (level > 3)
 				scmd_printk(KERN_INFO, cmd,
@@ -190,11 +190,11 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
 	 * must have taken place.  Make a note of this.
 	 */
 	if (SCSI_SENSE_VALID(cmd))
-		cmd->result |= (DRIVER_SENSE << 24);
+		cmd->status.combined |= (DRIVER_SENSE << 24);
 
 	SCSI_LOG_MLCOMPLETE(4, sdev_printk(KERN_INFO, sdev,
 				"Notifying upper driver of completion "
-				"(result %x)\n", cmd->result));
+				"(result %x)\n", cmd->status.combined));
 
 	good_bytes = scsi_bufflen(cmd);
 	if (!blk_rq_is_passthrough(cmd->request)) {
diff --git a/drivers/scsi/scsi_debugfs.c b/drivers/scsi/scsi_debugfs.c
index c19ea7ab54cb..09679072b070 100644
--- a/drivers/scsi/scsi_debugfs.c
+++ b/drivers/scsi/scsi_debugfs.c
@@ -42,7 +42,7 @@ void scsi_show_rq(struct seq_file *m, struct request *rq)
 	if (cdb)
 		__scsi_format_command(buf, sizeof(buf), cdb, cmd->cmd_len);
 	seq_printf(m, ", .cmd=%s, .retries=%d, .result = %#x, .flags=", buf,
-		   cmd->retries, cmd->result);
+		   cmd->retries, cmd->status.combined);
 	scsi_flags_show(m, cmd->flags, scsi_cmd_flags,
 			ARRAY_SIZE(scsi_cmd_flags));
 	seq_printf(m, ", .timeout=%d.%03d, allocated %d.%03d s ago",
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 54213c37806b..e54fbdc9206c 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -732,7 +732,7 @@ static enum scsi_disposition scsi_eh_completed_normally(struct scsi_cmnd *scmd)
 	 * first check the host byte, to see if there is anything in there
 	 * that would indicate what we need to do.
 	 */
-	if (host_byte(scmd->result) == DID_RESET) {
+	if (host_byte(scmd->status) == DID_RESET) {
 		/*
 		 * rats.  we are already in the error handler, so we now
 		 * get to try and figure out what to do next.  if the sense
@@ -741,20 +741,20 @@ static enum scsi_disposition scsi_eh_completed_normally(struct scsi_cmnd *scmd)
 		 */
 		return scsi_check_sense(scmd);
 	}
-	if (host_byte(scmd->result) != DID_OK)
+	if (host_byte(scmd->status) != DID_OK)
 		return FAILED;
 
 	/*
 	 * next, check the message byte.
 	 */
-	if (msg_byte(scmd->result) != COMMAND_COMPLETE)
+	if (msg_byte(scmd->status) != COMMAND_COMPLETE)
 		return FAILED;
 
 	/*
 	 * now, check the status byte to see if this indicates
 	 * anything special.
 	 */
-	switch (status_byte(scmd->result)) {
+	switch (status_byte(scmd->status)) {
 	case GOOD:
 		scsi_handle_queue_ramp_up(scmd->device);
 		fallthrough;
@@ -796,7 +796,7 @@ static void scsi_eh_done(struct scsi_cmnd *scmd)
 	struct completion *eh_action;
 
 	SCSI_LOG_ERROR_RECOVERY(3, scmd_printk(KERN_INFO, scmd,
-			"%s result: %x\n", __func__, scmd->result));
+			"%s result: %x\n", __func__, scmd->status.combined));
 
 	eh_action = scmd->device->host->eh_action;
 	if (eh_action)
@@ -989,7 +989,7 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
 	ses->cmnd = scmd->cmnd;
 	ses->data_direction = scmd->sc_data_direction;
 	ses->sdb = scmd->sdb;
-	ses->result = scmd->result;
+	ses->status = scmd->status;
 	ses->resid_len = scmd->req.resid_len;
 	ses->underflow = scmd->underflow;
 	ses->prot_op = scmd->prot_op;
@@ -1000,7 +1000,7 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
 	scmd->cmnd = ses->eh_cmnd;
 	memset(scmd->cmnd, 0, BLK_MAX_CDB);
 	memset(&scmd->sdb, 0, sizeof(scmd->sdb));
-	scmd->result = 0;
+	scmd->status.combined = 0;
 	scmd->req.resid_len = 0;
 
 	if (sense_bytes) {
@@ -1053,7 +1053,7 @@ void scsi_eh_restore_cmnd(struct scsi_cmnd* scmd, struct scsi_eh_save *ses)
 	scmd->cmnd = ses->cmnd;
 	scmd->sc_data_direction = ses->data_direction;
 	scmd->sdb = ses->sdb;
-	scmd->result = ses->result;
+	scmd->status = ses->status;
 	scmd->req.resid_len = ses->resid_len;
 	scmd->underflow = ses->underflow;
 	scmd->prot_op = ses->prot_op;
@@ -1261,7 +1261,7 @@ int scsi_eh_get_sense(struct list_head *work_q,
 					     current->comm));
 			break;
 		}
-		if (status_byte(scmd->result) != CHECK_CONDITION)
+		if (status_byte(scmd->status) != CHECK_CONDITION)
 			/*
 			 * don't request sense if there's no check condition
 			 * status because the error we're processing isn't one
@@ -1278,7 +1278,7 @@ int scsi_eh_get_sense(struct list_head *work_q,
 			continue;
 
 		SCSI_LOG_ERROR_RECOVERY(3, scmd_printk(KERN_INFO, scmd,
-			"sense requested, result %x\n", scmd->result));
+			"sense requested, result %x\n", scmd->status.combined));
 		SCSI_LOG_ERROR_RECOVERY(3, scsi_print_sense(scmd));
 
 		rtn = scsi_decide_disposition(scmd);
@@ -1759,7 +1759,7 @@ static void scsi_eh_offline_sdevs(struct list_head *work_q,
  */
 int scsi_noretry_cmd(struct scsi_cmnd *scmd)
 {
-	switch (host_byte(scmd->result)) {
+	switch (host_byte(scmd->status)) {
 	case DID_OK:
 		break;
 	case DID_TIME_OUT:
@@ -1769,8 +1769,8 @@ int scsi_noretry_cmd(struct scsi_cmnd *scmd)
 	case DID_PARITY:
 		return (scmd->request->cmd_flags & REQ_FAILFAST_DEV);
 	case DID_ERROR:
-		if (msg_byte(scmd->result) == COMMAND_COMPLETE &&
-		    status_byte(scmd->result) == RESERVATION_CONFLICT)
+		if (msg_byte(scmd->status) == COMMAND_COMPLETE &&
+		    status_byte(scmd->status) == RESERVATION_CONFLICT)
 			return 0;
 		fallthrough;
 	case DID_SOFT_ERROR:
@@ -1779,7 +1779,7 @@ int scsi_noretry_cmd(struct scsi_cmnd *scmd)
 		break;
 	}
 
-	if (status_byte(scmd->result) != CHECK_CONDITION)
+	if (status_byte(scmd->status) != CHECK_CONDITION)
 		return 0;
 
 check_type:
@@ -1826,14 +1826,14 @@ enum scsi_disposition scsi_decide_disposition(struct scsi_cmnd *scmd)
 	 * first check the host byte, to see if there is anything in there
 	 * that would indicate what we need to do.
 	 */
-	switch (host_byte(scmd->result)) {
+	switch (host_byte(scmd->status)) {
 	case DID_PASSTHROUGH:
 		/*
 		 * no matter what, pass this through to the upper layer.
 		 * nuke this special code so that it looks like we are saying
 		 * did_ok.
 		 */
-		scmd->result &= 0xff00ffff;
+		set_host_byte(scmd, DID_OK);
 		return SUCCESS;
 	case DID_OK:
 		/*
@@ -1888,8 +1888,8 @@ enum scsi_disposition scsi_decide_disposition(struct scsi_cmnd *scmd)
 		 */
 		return SUCCESS;
 	case DID_ERROR:
-		if (msg_byte(scmd->result) == COMMAND_COMPLETE &&
-		    status_byte(scmd->result) == RESERVATION_CONFLICT)
+		if (msg_byte(scmd->status) == COMMAND_COMPLETE &&
+		    status_byte(scmd->status) == RESERVATION_CONFLICT)
 			/*
 			 * execute reservation conflict processing code
 			 * lower down
@@ -1920,13 +1920,13 @@ enum scsi_disposition scsi_decide_disposition(struct scsi_cmnd *scmd)
 	/*
 	 * next, check the message byte.
 	 */
-	if (msg_byte(scmd->result) != COMMAND_COMPLETE)
+	if (msg_byte(scmd->status) != COMMAND_COMPLETE)
 		return FAILED;
 
 	/*
 	 * check the status byte to see if this indicates anything special.
 	 */
-	switch (status_byte(scmd->result)) {
+	switch (status_byte(scmd->status)) {
 	case QUEUE_FULL:
 		scsi_handle_queue_full(scmd->device);
 		/*
@@ -2144,8 +2144,8 @@ void scsi_eh_flush_done_q(struct list_head *done_q)
 			 * scsi_eh_get_sense), scmd->result is already
 			 * set, do not set DRIVER_TIMEOUT.
 			 */
-			if (!scmd->result)
-				scmd->result |= (DRIVER_TIMEOUT << 24);
+			if (!scmd->status.combined)
+				scmd->status.combined |= (DRIVER_TIMEOUT << 24);
 			SCSI_LOG_ERROR_RECOVERY(3,
 				scmd_printk(KERN_INFO, scmd,
 					     "%s: flush finish cmd\n",
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index 14872c9dc78c..fee0e72917b3 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -89,17 +89,17 @@ static int ioctl_probe(struct Scsi_Host *host, void __user *buffer)
 static int ioctl_internal_command(struct scsi_device *sdev, char *cmd,
 				  int timeout, int retries)
 {
-	int result;
+	union scsi_status result;
 	struct scsi_sense_hdr sshdr;
 
 	SCSI_LOG_IOCTL(1, sdev_printk(KERN_INFO, sdev,
 				      "Trying ioctl with scsi command %d\n", *cmd));
 
-	result = scsi_execute_req(sdev, cmd, DMA_NONE, NULL, 0,
+	result.combined = scsi_execute_req(sdev, cmd, DMA_NONE, NULL, 0,
 				  &sshdr, timeout, retries, NULL);
 
 	SCSI_LOG_IOCTL(2, sdev_printk(KERN_INFO, sdev,
-				      "Ioctl returned  0x%x\n", result));
+				"Ioctl returned  0x%x\n", result.combined));
 
 	if (driver_byte(result) == DRIVER_SENSE &&
 	    scsi_sense_valid(&sshdr)) {
@@ -121,14 +121,14 @@ static int ioctl_internal_command(struct scsi_device *sdev, char *cmd,
 		case UNIT_ATTENTION:
 			if (sdev->removable) {
 				sdev->changed = 1;
-				result = 0;	/* This is no longer considered an error */
+				result.combined = 0;	/* This is no longer considered an error */
 				break;
 			}
 			fallthrough;	/* for non-removable media */
 		default:
 			sdev_printk(KERN_INFO, sdev,
 				    "ioctl_internal_command return code = %x\n",
-				    result);
+				    result.combined);
 			scsi_print_sense_hdr(sdev, NULL, &sshdr);
 			break;
 		}
@@ -136,7 +136,7 @@ static int ioctl_internal_command(struct scsi_device *sdev, char *cmd,
 
 	SCSI_LOG_IOCTL(2, sdev_printk(KERN_INFO, sdev,
 				      "IOCTL Releasing command\n"));
-	return result;
+	return result.combined;
 }
 
 int scsi_set_medium_removal(struct scsi_device *sdev, char state)
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index a979a9457dff..882e04c8be69 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -196,7 +196,7 @@ static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, bool unbusy)
 	 * lock such that the kblockd_schedule_work() call happens
 	 * before blk_cleanup_queue() finishes.
 	 */
-	cmd->result = 0;
+	cmd->status.combined = 0;
 
 	blk_mq_requeue_request(cmd->request, true);
 }
@@ -286,7 +286,7 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 		memcpy(sense, rq->sense, SCSI_SENSE_BUFFERSIZE);
 	if (sshdr)
 		scsi_normalize_sense(rq->sense, rq->sense_len, sshdr);
-	ret = rq->result;
+	ret = rq->status.combined;
  out:
 	blk_put_request(req);
 
@@ -616,9 +616,10 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
  * @result:	scsi error code
  *
  * Translate a SCSI result code into a blk_status_t value. May reset the host
- * byte of @cmd->result.
+ * byte of @cmd->status.
  */
-static blk_status_t scsi_result_to_blk_status(struct scsi_cmnd *cmd, int result)
+static blk_status_t scsi_result_to_blk_status(struct scsi_cmnd *cmd,
+					      union scsi_status result)
 {
 	switch (host_byte(result)) {
 	case DID_OK:
@@ -627,7 +628,8 @@ static blk_status_t scsi_result_to_blk_status(struct scsi_cmnd *cmd, int result)
 		 * to handle the case when a SCSI LLD sets result to
 		 * DRIVER_SENSE << 24 without setting SAM_STAT_CHECK_CONDITION.
 		 */
-		if (scsi_status_is_good(result) && (result & ~0xff) == 0)
+		if (scsi_status_is_good(result) &&
+		    (result.combined & ~0xff) == 0)
 			return BLK_STS_OK;
 		return BLK_STS_IOERR;
 	case DID_TRANSPORT_FAILFAST:
@@ -676,7 +678,8 @@ static bool scsi_cmd_runtime_exceeced(struct scsi_cmnd *cmd)
 }
 
 /* Helper for scsi_io_completion() when special action required. */
-static void scsi_io_completion_action(struct scsi_cmnd *cmd, int result)
+static void scsi_io_completion_action(struct scsi_cmnd *cmd,
+				      union scsi_status result)
 {
 	struct request_queue *q = cmd->device->request_queue;
 	struct request *req = cmd->request;
@@ -844,12 +847,12 @@ static void scsi_io_completion_action(struct scsi_cmnd *cmd, int result)
 }
 
 /*
- * Helper for scsi_io_completion() when cmd->result is non-zero. Returns a
+ * Helper for scsi_io_completion() when cmd->status is non-zero. Returns a
  * new result that may suppress further error checking. Also modifies
  * *blk_statp in some cases.
  */
-static int scsi_io_completion_nz_result(struct scsi_cmnd *cmd, int result,
-					blk_status_t *blk_statp)
+static union scsi_status scsi_io_completion_nz_result(struct scsi_cmnd *cmd,
+			union scsi_status result, blk_status_t *blk_statp)
 {
 	bool sense_valid;
 	bool sense_current = true;	/* false implies "deferred sense" */
@@ -882,7 +885,7 @@ static int scsi_io_completion_nz_result(struct scsi_cmnd *cmd, int result,
 	/*
 	 * Recovered errors need reporting, but they're always treated as
 	 * success, so fiddle the result code here.  For passthrough requests
-	 * we already took a copy of the original into sreq->result which
+	 * we already took a copy of the original into sreq->status which
 	 * is what gets returned to the user
 	 */
 	if (sense_valid && (sshdr.sense_key == RECOVERED_ERROR)) {
@@ -898,7 +901,7 @@ static int scsi_io_completion_nz_result(struct scsi_cmnd *cmd, int result,
 			do_print = false;
 		if (do_print)
 			scsi_print_sense(cmd);
-		result = 0;
+		result.combined = 0;
 		/* for passthrough, *blk_statp may be set */
 		*blk_statp = BLK_STS_OK;
 	}
@@ -910,7 +913,7 @@ static int scsi_io_completion_nz_result(struct scsi_cmnd *cmd, int result,
 	 * intermediate statuses (both obsolete in SAM-4) as good.
 	 */
 	if (status_byte(result) && scsi_status_is_good(result)) {
-		result = 0;
+		result.combined = 0;
 		*blk_statp = BLK_STS_OK;
 	}
 	return result;
@@ -940,19 +943,20 @@ static int scsi_io_completion_nz_result(struct scsi_cmnd *cmd, int result,
  */
 void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 {
-	int result = cmd->result;
+	union scsi_status result = cmd->status;
 	struct request_queue *q = cmd->device->request_queue;
 	struct request *req = cmd->request;
 	blk_status_t blk_stat = BLK_STS_OK;
 
-	if (unlikely(result))	/* a nz result may or may not be an error */
+	/* a non-zero result may or may not be an error */
+	if (unlikely(result.combined))
 		result = scsi_io_completion_nz_result(cmd, result, &blk_stat);
 
 	if (unlikely(blk_rq_is_passthrough(req))) {
 		/*
 		 * scsi_result_to_blk_status may have reset the host_byte
 		 */
-		scsi_req(req)->result = cmd->result;
+		scsi_req(req)->status = cmd->status;
 	}
 
 	/*
@@ -984,7 +988,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	 * If there had been no error, but we have leftover bytes in the
 	 * requeues just queue the command up again.
 	 */
-	if (likely(result == 0))
+	if (likely(result.combined == 0))
 		scsi_io_completion_reprep(cmd, q);
 	else
 		scsi_io_completion_action(cmd, result);
@@ -1446,7 +1450,7 @@ static void scsi_complete(struct request *rq)
 	INIT_LIST_HEAD(&cmd->eh_entry);
 
 	atomic_inc(&cmd->device->iodone_cnt);
-	if (cmd->result)
+	if (cmd->status.combined)
 		atomic_inc(&cmd->device->ioerr_cnt);
 
 	disposition = scsi_decide_disposition(cmd);
@@ -1490,7 +1494,7 @@ static int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 		/* in SDEV_DEL we error all commands. DID_NO_CONNECT
 		 * returns an immediate error upwards, and signals
 		 * that the device is no longer present */
-		cmd->result = DID_NO_CONNECT << 16;
+		cmd->status.combined = DID_NO_CONNECT << 16;
 		goto done;
 	}
 
@@ -1524,12 +1528,12 @@ static int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 			       "queuecommand : command too long. "
 			       "cdb_size=%d host->max_cmd_len=%d\n",
 			       cmd->cmd_len, cmd->device->host->max_cmd_len));
-		cmd->result = (DID_ABORT << 16);
+		cmd->status.combined = (DID_ABORT << 16);
 		goto done;
 	}
 
 	if (unlikely(host->shost_state == SHOST_DEL)) {
-		cmd->result = (DID_NO_CONNECT << 16);
+		cmd->status.combined = (DID_NO_CONNECT << 16);
 		goto done;
 
 	}
@@ -1742,15 +1746,15 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 			ret = BLK_STS_DEV_RESOURCE;
 		break;
 	case BLK_STS_AGAIN:
-		scsi_req(req)->result = DID_BUS_BUSY << 16;
+		scsi_req(req)->status.combined = DID_BUS_BUSY << 16;
 		if (req->rq_flags & RQF_DONTPREP)
 			scsi_mq_uninit_cmd(cmd);
 		break;
 	default:
 		if (unlikely(!scsi_device_online(sdev)))
-			scsi_req(req)->result = DID_NO_CONNECT << 16;
+			scsi_req(req)->status.combined = DID_NO_CONNECT << 16;
 		else
-			scsi_req(req)->result = DID_ERROR << 16;
+			scsi_req(req)->status.combined = DID_ERROR << 16;
 		/*
 		 * Make sure to release all allocated resources when
 		 * we hit an error, as we will never see this command
@@ -2147,7 +2151,8 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 	unsigned char cmd[12];
 	int use_10_for_ms;
 	int header_length;
-	int result, retry_count = retries;
+	union scsi_status result;
+	int retry_count = retries;
 	struct scsi_sense_hdr my_sshdr;
 
 	memset(data, 0, sizeof(*data));
@@ -2182,8 +2187,8 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 
 	memset(buffer, 0, len);
 
-	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer, len,
-				  sshdr, timeout, retries, NULL);
+	result.combined = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer,
+					   len, sshdr, timeout, retries, NULL);
 
 	/* This code looks awful: what it's doing is making sure an
 	 * ILLEGAL REQUEST sense return identifies the actual command
@@ -2235,7 +2240,7 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 		goto retry;
 	}
 
-	return result;
+	return result.combined;
 }
 EXPORT_SYMBOL(scsi_mode_sense);
 
diff --git a/drivers/scsi/scsi_logging.c b/drivers/scsi/scsi_logging.c
index 8ea44c6595ef..5c994ba1fad8 100644
--- a/drivers/scsi/scsi_logging.c
+++ b/drivers/scsi/scsi_logging.c
@@ -384,8 +384,8 @@ void scsi_print_result(const struct scsi_cmnd *cmd, const char *msg,
 	char *logbuf;
 	size_t off, logbuf_len;
 	const char *mlret_string = scsi_mlreturn_string(disposition);
-	const char *hb_string = scsi_hostbyte_string(cmd->result);
-	const char *db_string = scsi_driverbyte_string(cmd->result);
+	const char *hb_string = scsi_hostbyte_string(cmd->status.combined);
+	const char *db_string = scsi_driverbyte_string(cmd->status.combined);
 	unsigned long cmd_age = (jiffies - cmd->jiffies_at_alloc) / HZ;
 
 	logbuf = scsi_log_reserve_buffer(&logbuf_len);
@@ -422,7 +422,7 @@ void scsi_print_result(const struct scsi_cmnd *cmd, const char *msg,
 				 "hostbyte=%s ", hb_string);
 	else
 		off += scnprintf(logbuf + off, logbuf_len - off,
-				 "hostbyte=0x%02x ", host_byte(cmd->result));
+				 "hostbyte=0x%02x ", host_byte(cmd->status));
 	if (WARN_ON(off >= logbuf_len))
 		goto out_printk;
 
@@ -432,7 +432,7 @@ void scsi_print_result(const struct scsi_cmnd *cmd, const char *msg,
 	else
 		off += scnprintf(logbuf + off, logbuf_len - off,
 				 "driverbyte=0x%02x ",
-				 driver_byte(cmd->result));
+				 driver_byte(cmd->status));
 
 	off += scnprintf(logbuf + off, logbuf_len - off,
 			 "cmd_age=%lus", cmd_age);
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 9f1b7f3c650a..43346f7dedd1 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -580,7 +580,8 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
 	int first_inquiry_len, try_inquiry_len, next_inquiry_len;
 	int response_len = 0;
-	int pass, count, result;
+	int pass, count;
+	union scsi_status result;
 	struct scsi_sense_hdr sshdr;
 
 	*bflags = 0;
@@ -607,16 +608,18 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 
 		memset(inq_result, 0, try_inquiry_len);
 
-		result = scsi_execute_req(sdev,  scsi_cmd, DMA_FROM_DEVICE,
+		result.combined =
+			scsi_execute_req(sdev,  scsi_cmd, DMA_FROM_DEVICE,
 					  inq_result, try_inquiry_len, &sshdr,
 					  HZ / 2 + HZ * scsi_inq_timeout, 3,
 					  &resid);
 
 		SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
 				"scsi scan: INQUIRY %s with code 0x%x\n",
-				result ? "failed" : "successful", result));
+				result.combined ? "failed" : "successful",
+				result.combined));
 
-		if (result) {
+		if (result.combined) {
 			/*
 			 * not-ready to ready transition [asc/ascq=0x28/0x0]
 			 * or power-on, reset [asc/ascq=0x29/0x0], continue.
@@ -643,7 +646,7 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 		break;
 	}
 
-	if (result == 0) {
+	if (result.combined == 0) {
 		scsi_sanitize_inquiry_string(&inq_result[8], 8);
 		scsi_sanitize_inquiry_string(&inq_result[16], 16);
 		scsi_sanitize_inquiry_string(&inq_result[32], 4);
@@ -695,7 +698,7 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 
 	/* If the last transfer attempt got an error, assume the
 	 * peripheral doesn't exist or is dead. */
-	if (result)
+	if (result.combined)
 		return -EIO;
 
 	/* Don't report any more data than the device says is valid */
diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index c37dd15d16d2..8788066275df 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -109,7 +109,8 @@ static int spi_execute(struct scsi_device *sdev, const void *cmd,
 		       void *buffer, unsigned bufflen,
 		       struct scsi_sense_hdr *sshdr)
 {
-	int i, result;
+	int i;
+	union scsi_status result;
 	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
 	struct scsi_sense_hdr sshdr_tmp;
 
@@ -121,7 +122,8 @@ static int spi_execute(struct scsi_device *sdev, const void *cmd,
 		 * The purpose of the RQF_PM flag below is to bypass the
 		 * SDEV_QUIESCE state.
 		 */
-		result = scsi_execute(sdev, cmd, dir, buffer, bufflen, sense,
+		result.combined =
+			scsi_execute(sdev, cmd, dir, buffer, bufflen, sense,
 				      sshdr, DV_TIMEOUT, /* retries */ 1,
 				      REQ_FAILFAST_DEV |
 				      REQ_FAILFAST_TRANSPORT |
@@ -131,7 +133,7 @@ static int spi_execute(struct scsi_device *sdev, const void *cmd,
 		    sshdr->sense_key != UNIT_ATTENTION)
 			break;
 	}
-	return result;
+	return result.combined;
 }
 
 static struct {
diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
index f624969a4f14..13da567f5b72 100644
--- a/include/trace/events/scsi.h
+++ b/include/trace/events/scsi.h
@@ -309,7 +309,7 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
 		__entry->channel	= cmd->device->channel;
 		__entry->id		= cmd->device->id;
 		__entry->lun		= cmd->device->lun;
-		__entry->result		= cmd->result;
+		__entry->result		= cmd->status.combined;
 		__entry->opcode		= cmd->cmnd[0];
 		__entry->cmd_len	= cmd->cmd_len;
 		__entry->data_sglen	= scsi_sg_count(cmd);
