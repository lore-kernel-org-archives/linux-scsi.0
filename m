Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2175C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 17:07:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E48860C3E
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 17:07:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347088AbhDMRHv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 13:07:51 -0400
Received: from mail-pf1-f177.google.com ([209.85.210.177]:36750 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347087AbhDMRHr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 13:07:47 -0400
Received: by mail-pf1-f177.google.com with SMTP id b26so6693197pfr.3
        for <linux-scsi@vger.kernel.org>; Tue, 13 Apr 2021 10:07:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m5BVu2YG+HeQVn5GzMzPj14fIsTQzg7CffJ+vsLVUms=;
        b=T4sDWAhC8O96F3Z8Tok33tJ0ZoazOzca6MQI8yPcxnLVO9WI0pygmC6CCTWHadhxyR
         fD/Gl4rXc+8TKR0l1k+zBNFB4MlGoTrwUrzvdDVSods2eu3D3kRR/LOv8+uOOrWwvoS4
         ylgFg7t3RZxf4UTWpCD3n2OZzAweoRb10Fc2Frx/NYyjGyWiziKx+EmnWA+JLzLeMObN
         7J0mMaNSIyzoiAJelYZ9mWNymt1Sj5KJK4aOSt7AvzO0QKRXbwxYbqFyWEkzTzb/67P8
         6SP5zNA4U+K+f/IJvHgwXM6y/fDOFaGZQmjq4CK5eXDx3Bn2DtCP3IyKDGeeCHtfPd9I
         obnQ==
X-Gm-Message-State: AOAM5315dRWzF2aEzcp2P8guDYHC7zUnS9uN6xrgAH3z939yEY3fGVvX
        CWUU3hVheAqAYePGwsrbbCA=
X-Google-Smtp-Source: ABdhPJx8DxseS/NbxgDWkLjyt9RJM2XFDub2SvPMtib8y+vUcc/P/0kqsA8s6LuqoClvWkcp37Nywg==
X-Received: by 2002:a63:3e06:: with SMTP id l6mr32974911pga.140.1618333646956;
        Tue, 13 Apr 2021 10:07:26 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:345f:c70d:97e0:e2ef])
        by smtp.gmail.com with ESMTPSA id z10sm6736078pfe.218.2021.04.13.10.07.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 10:07:26 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Hannes Reinecke <hare@suse.de>, Daniel Wagner <dwagner@suse.de>
Subject: [PATCH 05/20] Introduce enum scsi_disposition
Date:   Tue, 13 Apr 2021 10:06:59 -0700
Message-Id: <20210413170714.2119-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210413170714.2119-1-bvanassche@acm.org>
References: <20210413170714.2119-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Improve readability of the code in the SCSI core by introducing an
enumeration type for the values used internally that decide how to
continue processing a SCSI command. The eh_*_handler return values have
not been changed because that would involve modifying all SCSI drivers.

The output of the following command has been inspected to verify that
no out-of-range values are assigned to a variable of type enum
scsi_disposition:

KCFLAGS=-Wassign-enum make CC=clang W=1 drivers/scsi/

Cc: Christoph Hellwig <hch@lst.de>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ata/libata-eh.c                    |  2 +-
 drivers/scsi/device_handler/scsi_dh_alua.c |  4 +-
 drivers/scsi/device_handler/scsi_dh_emc.c  |  4 +-
 drivers/scsi/device_handler/scsi_dh_rdac.c |  4 +-
 drivers/scsi/scsi_error.c                  | 64 ++++++++++++----------
 drivers/scsi/scsi_lib.c                    |  2 +-
 drivers/scsi/scsi_priv.h                   |  2 +-
 include/scsi/scsi.h                        | 21 +++----
 include/scsi/scsi_dh.h                     |  3 +-
 include/scsi/scsi_eh.h                     |  2 +-
 10 files changed, 57 insertions(+), 51 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index b6f92050e60c..5352be2b447d 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1599,7 +1599,7 @@ static unsigned int ata_eh_analyze_tf(struct ata_queued_cmd *qc,
 	}
 
 	if (qc->flags & ATA_QCFLAG_SENSE_VALID) {
-		int ret = scsi_check_sense(qc->scsicmd);
+		enum scsi_disposition ret = scsi_check_sense(qc->scsicmd);
 		/*
 		 * SUCCESS here means that the sense code could be
 		 * evaluated and should be passed to the upper layers
diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index e6fde27d4565..efa8c0381476 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -405,8 +405,8 @@ static char print_alua_state(unsigned char state)
 	}
 }
 
-static int alua_check_sense(struct scsi_device *sdev,
-			    struct scsi_sense_hdr *sense_hdr)
+static enum scsi_disposition alua_check_sense(struct scsi_device *sdev,
+					      struct scsi_sense_hdr *sense_hdr)
 {
 	struct alua_dh_data *h = sdev->handler_data;
 	struct alua_port_group *pg;
diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index caa685cfe3d4..bd28ec6cfb72 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -280,8 +280,8 @@ static int send_trespass_cmd(struct scsi_device *sdev,
 	return res;
 }
 
-static int clariion_check_sense(struct scsi_device *sdev,
-				struct scsi_sense_hdr *sense_hdr)
+static enum scsi_disposition clariion_check_sense(struct scsi_device *sdev,
+					struct scsi_sense_hdr *sense_hdr)
 {
 	switch (sense_hdr->sense_key) {
 	case NOT_READY:
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index 5efc959493ec..25f6e1ac9e7b 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -656,8 +656,8 @@ static blk_status_t rdac_prep_fn(struct scsi_device *sdev, struct request *req)
 	return BLK_STS_OK;
 }
 
-static int rdac_check_sense(struct scsi_device *sdev,
-				struct scsi_sense_hdr *sense_hdr)
+static enum scsi_disposition rdac_check_sense(struct scsi_device *sdev,
+					      struct scsi_sense_hdr *sense_hdr)
 {
 	struct rdac_dh_data *h = sdev->handler_data;
 
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 28b287e9f50a..9afd65eb2c8b 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -60,8 +60,8 @@ static void scsi_eh_done(struct scsi_cmnd *scmd);
 #define HOST_RESET_SETTLE_TIME  (10)
 
 static int scsi_eh_try_stu(struct scsi_cmnd *scmd);
-static int scsi_try_to_abort_cmd(struct scsi_host_template *,
-				 struct scsi_cmnd *);
+static enum scsi_disposition scsi_try_to_abort_cmd(struct scsi_host_template *,
+						   struct scsi_cmnd *);
 
 void scsi_eh_wakeup(struct Scsi_Host *shost)
 {
@@ -151,7 +151,7 @@ scmd_eh_abort_handler(struct work_struct *work)
 	struct scsi_cmnd *scmd =
 		container_of(work, struct scsi_cmnd, abort_work.work);
 	struct scsi_device *sdev = scmd->device;
-	int rtn;
+	enum scsi_disposition rtn;
 
 	if (scsi_host_eh_past_deadline(sdev->host)) {
 		SCSI_LOG_ERROR_RECOVERY(3,
@@ -498,7 +498,7 @@ static void scsi_report_sense(struct scsi_device *sdev,
  *	When a deferred error is detected the current command has
  *	not been executed and needs retrying.
  */
-int scsi_check_sense(struct scsi_cmnd *scmd)
+enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
 {
 	struct scsi_device *sdev = scmd->device;
 	struct scsi_sense_hdr sshdr;
@@ -512,7 +512,7 @@ int scsi_check_sense(struct scsi_cmnd *scmd)
 		return NEEDS_RETRY;
 
 	if (sdev->handler && sdev->handler->check_sense) {
-		int rc;
+		enum scsi_disposition rc;
 
 		rc = sdev->handler->check_sense(sdev, &sshdr);
 		if (rc != SCSI_RETURN_NOT_HANDLED)
@@ -726,7 +726,7 @@ static void scsi_handle_queue_full(struct scsi_device *sdev)
  *    don't allow for the possibility of retries here, and we are a lot
  *    more restrictive about what we consider acceptable.
  */
-static int scsi_eh_completed_normally(struct scsi_cmnd *scmd)
+static enum scsi_disposition scsi_eh_completed_normally(struct scsi_cmnd *scmd)
 {
 	/*
 	 * first check the host byte, to see if there is anything in there
@@ -807,10 +807,10 @@ static void scsi_eh_done(struct scsi_cmnd *scmd)
  * scsi_try_host_reset - ask host adapter to reset itself
  * @scmd:	SCSI cmd to send host reset.
  */
-static int scsi_try_host_reset(struct scsi_cmnd *scmd)
+static enum scsi_disposition scsi_try_host_reset(struct scsi_cmnd *scmd)
 {
 	unsigned long flags;
-	int rtn;
+	enum scsi_disposition rtn;
 	struct Scsi_Host *host = scmd->device->host;
 	struct scsi_host_template *hostt = host->hostt;
 
@@ -837,10 +837,10 @@ static int scsi_try_host_reset(struct scsi_cmnd *scmd)
  * scsi_try_bus_reset - ask host to perform a bus reset
  * @scmd:	SCSI cmd to send bus reset.
  */
-static int scsi_try_bus_reset(struct scsi_cmnd *scmd)
+static enum scsi_disposition scsi_try_bus_reset(struct scsi_cmnd *scmd)
 {
 	unsigned long flags;
-	int rtn;
+	enum scsi_disposition rtn;
 	struct Scsi_Host *host = scmd->device->host;
 	struct scsi_host_template *hostt = host->hostt;
 
@@ -879,10 +879,10 @@ static void __scsi_report_device_reset(struct scsi_device *sdev, void *data)
  *    timer on it, and set the host back to a consistent state prior to
  *    returning.
  */
-static int scsi_try_target_reset(struct scsi_cmnd *scmd)
+static enum scsi_disposition scsi_try_target_reset(struct scsi_cmnd *scmd)
 {
 	unsigned long flags;
-	int rtn;
+	enum scsi_disposition rtn;
 	struct Scsi_Host *host = scmd->device->host;
 	struct scsi_host_template *hostt = host->hostt;
 
@@ -910,9 +910,9 @@ static int scsi_try_target_reset(struct scsi_cmnd *scmd)
  *    timer on it, and set the host back to a consistent state prior to
  *    returning.
  */
-static int scsi_try_bus_device_reset(struct scsi_cmnd *scmd)
+static enum scsi_disposition scsi_try_bus_device_reset(struct scsi_cmnd *scmd)
 {
-	int rtn;
+	enum scsi_disposition rtn;
 	struct scsi_host_template *hostt = scmd->device->host->hostt;
 
 	if (!hostt->eh_device_reset_handler)
@@ -941,8 +941,8 @@ static int scsi_try_bus_device_reset(struct scsi_cmnd *scmd)
  *    if the device is temporarily unavailable (eg due to a
  *    link down on FibreChannel)
  */
-static int scsi_try_to_abort_cmd(struct scsi_host_template *hostt,
-				 struct scsi_cmnd *scmd)
+static enum scsi_disposition
+scsi_try_to_abort_cmd(struct scsi_host_template *hostt, struct scsi_cmnd *scmd)
 {
 	if (!hostt->eh_abort_handler)
 		return FAILED;
@@ -1075,8 +1075,8 @@ EXPORT_SYMBOL(scsi_eh_restore_cmnd);
  * Return value:
  *    SUCCESS or FAILED or NEEDS_RETRY
  */
-static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
-			     int cmnd_size, int timeout, unsigned sense_bytes)
+static enum scsi_disposition scsi_send_eh_cmnd(struct scsi_cmnd *scmd,
+	unsigned char *cmnd, int cmnd_size, int timeout, unsigned sense_bytes)
 {
 	struct scsi_device *sdev = scmd->device;
 	struct Scsi_Host *shost = sdev->host;
@@ -1183,12 +1183,13 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
  *    that we obtain it on our own. This function will *not* return until
  *    the command either times out, or it completes.
  */
-static int scsi_request_sense(struct scsi_cmnd *scmd)
+static enum scsi_disposition scsi_request_sense(struct scsi_cmnd *scmd)
 {
 	return scsi_send_eh_cmnd(scmd, NULL, 0, scmd->device->eh_timeout, ~0);
 }
 
-static int scsi_eh_action(struct scsi_cmnd *scmd, int rtn)
+static enum scsi_disposition
+scsi_eh_action(struct scsi_cmnd *scmd, enum scsi_disposition rtn)
 {
 	if (!blk_rq_is_passthrough(scmd->request)) {
 		struct scsi_driver *sdrv = scsi_cmd_to_driver(scmd);
@@ -1241,7 +1242,7 @@ int scsi_eh_get_sense(struct list_head *work_q,
 {
 	struct scsi_cmnd *scmd, *next;
 	struct Scsi_Host *shost;
-	int rtn;
+	enum scsi_disposition rtn;
 
 	/*
 	 * If SCSI_EH_ABORT_SCHEDULED has been set, it is timeout IO,
@@ -1319,7 +1320,8 @@ EXPORT_SYMBOL_GPL(scsi_eh_get_sense);
 static int scsi_eh_tur(struct scsi_cmnd *scmd)
 {
 	static unsigned char tur_command[6] = {TEST_UNIT_READY, 0, 0, 0, 0, 0};
-	int retry_cnt = 1, rtn;
+	int retry_cnt = 1;
+	enum scsi_disposition rtn;
 
 retry_tur:
 	rtn = scsi_send_eh_cmnd(scmd, tur_command, 6,
@@ -1407,7 +1409,8 @@ static int scsi_eh_try_stu(struct scsi_cmnd *scmd)
 	static unsigned char stu_command[6] = {START_STOP, 0, 0, 0, 1, 0};
 
 	if (scmd->device->allow_restart) {
-		int i, rtn = NEEDS_RETRY;
+		int i;
+		enum scsi_disposition rtn = NEEDS_RETRY;
 
 		for (i = 0; rtn == NEEDS_RETRY && i < 2; i++)
 			rtn = scsi_send_eh_cmnd(scmd, stu_command, 6, scmd->device->request_queue->rq_timeout, 0);
@@ -1501,7 +1504,7 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
 {
 	struct scsi_cmnd *scmd, *bdr_scmd, *next;
 	struct scsi_device *sdev;
-	int rtn;
+	enum scsi_disposition rtn;
 
 	shost_for_each_device(sdev, shost) {
 		if (scsi_host_eh_past_deadline(shost)) {
@@ -1568,7 +1571,7 @@ static int scsi_eh_target_reset(struct Scsi_Host *shost,
 
 	while (!list_empty(&tmp_list)) {
 		struct scsi_cmnd *next, *scmd;
-		int rtn;
+		enum scsi_disposition rtn;
 		unsigned int id;
 
 		if (scsi_host_eh_past_deadline(shost)) {
@@ -1626,7 +1629,7 @@ static int scsi_eh_bus_reset(struct Scsi_Host *shost,
 	struct scsi_cmnd *scmd, *chan_scmd, *next;
 	LIST_HEAD(check_list);
 	unsigned int channel;
-	int rtn;
+	enum scsi_disposition rtn;
 
 	/*
 	 * we really want to loop over the various channels, and do this on
@@ -1697,7 +1700,7 @@ static int scsi_eh_host_reset(struct Scsi_Host *shost,
 {
 	struct scsi_cmnd *scmd, *next;
 	LIST_HEAD(check_list);
-	int rtn;
+	enum scsi_disposition rtn;
 
 	if (!list_empty(work_q)) {
 		scmd = list_entry(work_q->next,
@@ -1803,9 +1806,9 @@ int scsi_noretry_cmd(struct scsi_cmnd *scmd)
  *    doesn't require the error handler read (i.e. we don't need to
  *    abort/reset), this function should return SUCCESS.
  */
-int scsi_decide_disposition(struct scsi_cmnd *scmd)
+enum scsi_disposition scsi_decide_disposition(struct scsi_cmnd *scmd)
 {
-	int rtn;
+	enum scsi_disposition rtn;
 
 	/*
 	 * if the device is offline, then we clearly just pass the result back
@@ -2368,7 +2371,8 @@ scsi_ioctl_reset(struct scsi_device *dev, int __user *arg)
 	struct Scsi_Host *shost = dev->host;
 	struct request *rq;
 	unsigned long flags;
-	int error = 0, rtn, val;
+	int error = 0, val;
+	enum scsi_disposition rtn;
 
 	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
 		return -EACCES;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c4d6157e8051..a979a9457dff 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1441,7 +1441,7 @@ static bool scsi_mq_lld_busy(struct request_queue *q)
 static void scsi_complete(struct request *rq)
 {
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
-	int disposition;
+	enum scsi_disposition disposition;
 
 	INIT_LIST_HEAD(&cmd->eh_entry);
 
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index ed240f006c04..75d6f23e4fff 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -74,7 +74,7 @@ extern void scsi_exit_devinfo(void);
 extern void scmd_eh_abort_handler(struct work_struct *work);
 extern enum blk_eh_timer_return scsi_times_out(struct request *req);
 extern int scsi_error_handler(void *host);
-extern int scsi_decide_disposition(struct scsi_cmnd *cmd);
+extern enum scsi_disposition scsi_decide_disposition(struct scsi_cmnd *cmd);
 extern void scsi_eh_wakeup(struct Scsi_Host *shost);
 extern void scsi_eh_scmd_add(struct scsi_cmnd *);
 void scsi_eh_ready_devs(struct Scsi_Host *shost,
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index e75cca25338a..246ced401683 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -180,16 +180,17 @@ static inline int scsi_is_wlun(u64 lun)
 /*
  * Internal return values.
  */
-
-#define NEEDS_RETRY     0x2001
-#define SUCCESS         0x2002
-#define FAILED          0x2003
-#define QUEUED          0x2004
-#define SOFT_ERROR      0x2005
-#define ADD_TO_MLQUEUE  0x2006
-#define TIMEOUT_ERROR   0x2007
-#define SCSI_RETURN_NOT_HANDLED   0x2008
-#define FAST_IO_FAIL	0x2009
+enum scsi_disposition {
+	NEEDS_RETRY		= 0x2001,
+	SUCCESS			= 0x2002,
+	FAILED			= 0x2003,
+	QUEUED			= 0x2004,
+	SOFT_ERROR		= 0x2005,
+	ADD_TO_MLQUEUE		= 0x2006,
+	TIMEOUT_ERROR		= 0x2007,
+	SCSI_RETURN_NOT_HANDLED	= 0x2008,
+	FAST_IO_FAIL		= 0x2009,
+};
 
 /*
  * Midlevel queue return values.
diff --git a/include/scsi/scsi_dh.h b/include/scsi/scsi_dh.h
index a9f782fe732a..4df943c1b90b 100644
--- a/include/scsi/scsi_dh.h
+++ b/include/scsi/scsi_dh.h
@@ -52,7 +52,8 @@ struct scsi_device_handler {
 	/* Filled by the hardware handler */
 	struct module *module;
 	const char *name;
-	int (*check_sense)(struct scsi_device *, struct scsi_sense_hdr *);
+	enum scsi_disposition (*check_sense)(struct scsi_device *,
+					     struct scsi_sense_hdr *);
 	int (*attach)(struct scsi_device *);
 	void (*detach)(struct scsi_device *);
 	int (*activate)(struct scsi_device *, activate_complete, void *);
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index 6bd5ed695a5e..468094254b3c 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -17,7 +17,7 @@ extern void scsi_report_device_reset(struct Scsi_Host *, int, int);
 extern int scsi_block_when_processing_errors(struct scsi_device *);
 extern bool scsi_command_normalize_sense(const struct scsi_cmnd *cmd,
 					 struct scsi_sense_hdr *sshdr);
-extern int scsi_check_sense(struct scsi_cmnd *);
+extern enum scsi_disposition scsi_check_sense(struct scsi_cmnd *);
 
 static inline bool scsi_sense_is_deferred(const struct scsi_sense_hdr *sshdr)
 {
