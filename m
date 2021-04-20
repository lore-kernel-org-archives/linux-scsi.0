Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 933C7C43460
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EBCA611EE
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233570AbhDTCPH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 22:15:07 -0400
Received: from mail-pl1-f180.google.com ([209.85.214.180]:46720 "EHLO
        mail-pl1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233722AbhDTCPG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 22:15:06 -0400
Received: by mail-pl1-f180.google.com with SMTP id s20so2978900plr.13
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 19:14:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8jFOUXF/WmLiXa4msFwKc9rQWebPS/DanuH7DLniOtM=;
        b=q4yETfMmQhxtaXmkvzDr/u2P9x+PExbKXGOTvrjddY2O7UcHoSAN3QE5e821R6BFiW
         +oUchRCYo33i7zX7n4gUDsZu+lS2+h4uhNY13K2386Fgc8rL2or+1g99lMnoxaUDPNql
         KX8mrWVFI+GO34MUQbaMyqV0xHMQMt409qi9803gOl4kmD3VSEJalEcedWKTLRR4kWCf
         qmI5fYa411+fmUhFQfLFvh7LsQPZIpnNE64UKy8NU+CGG8PVy9Ng+K6j/3gxwwtk2HBW
         0WMBjDO8hGWncboW2EhEpwu8qaSBHq75rZkTn0DvvSibxlKeXJlsGvaOqh2Oi6YFsf9r
         dwZg==
X-Gm-Message-State: AOAM531hSLJ8NhpdjFBAkujJa+4c0Y8PQ43ET1u8aSOlpY5GNaHZ6gK2
        lMLW4RkzmlMkyOu5MbO8Ono=
X-Google-Smtp-Source: ABdhPJwGUTDKdoPHpfXH3PYi9IftQKlDRbLYiW2cK+kwHYeHewoxOYcbSOzldXPkQ5ci921OauCXig==
X-Received: by 2002:a17:902:d3ca:b029:eb:4ae2:6d6 with SMTP id w10-20020a170902d3cab02900eb4ae206d6mr26633864plb.69.1618884875115;
        Mon, 19 Apr 2021 19:14:35 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id mq2sm630984pjb.24.2021.04.19.19.14.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 19:14:34 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 112/117] Change the return type of scsi_execute() into union scsi_status
Date:   Mon, 19 Apr 2021 19:13:57 -0700
Message-Id: <20210420021402.27678-22-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that scsi_execute() returns a four-byte SCSI status code.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: John Garry <john.garry@huawei.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ata/libata-scsi.c                   |  4 ++--
 drivers/scsi/cxlflash/superpipe.c           |  2 +-
 drivers/scsi/cxlflash/vlun.c                |  8 ++++----
 drivers/scsi/device_handler/scsi_dh_alua.c  | 14 +++++++-------
 drivers/scsi/device_handler/scsi_dh_emc.c   |  7 ++++---
 drivers/scsi/device_handler/scsi_dh_hp_sw.c | 12 +++++++-----
 drivers/scsi/device_handler/scsi_dh_rdac.c  |  2 +-
 drivers/scsi/scsi_lib.c                     |  7 ++++---
 drivers/scsi/scsi_transport_spi.c           |  3 +--
 drivers/scsi/sd.c                           |  8 ++++----
 drivers/scsi/sr_ioctl.c                     |  2 +-
 drivers/scsi/ufs/ufshcd.c                   |  4 ++--
 include/scsi/scsi_device.h                  |  5 +++--
 13 files changed, 41 insertions(+), 37 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 5ba4b3152c99..edc183ba5853 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -407,7 +407,7 @@ int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
 
 	/* Good values for timeout and retries?  Values below
 	   from scsi_ioctl_send_command() for default case... */
-	cmd_result.combined = scsi_execute(scsidev, scsi_cmd, data_dir, argbuf, argsize,
+	cmd_result = scsi_execute(scsidev, scsi_cmd, data_dir, argbuf, argsize,
 				  sensebuf, &sshdr, (10*HZ), 5, 0, 0, NULL);
 
 	if (driver_byte(cmd_result) == DRIVER_SENSE) {/* sense data available */
@@ -488,7 +488,7 @@ int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg)
 
 	/* Good values for timeout and retries?  Values below
 	   from scsi_ioctl_send_command() for default case... */
-	cmd_result.combined = scsi_execute(scsidev, scsi_cmd, DMA_NONE, NULL, 0,
+	cmd_result = scsi_execute(scsidev, scsi_cmd, DMA_NONE, NULL, 0,
 				sensebuf, &sshdr, (10*HZ), 5, 0, 0, NULL);
 
 	if (driver_byte(cmd_result) == DRIVER_SENSE) {/* sense data available */
diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index 4a19a154e237..9214d6088ac4 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -357,7 +357,7 @@ static int read_cap16(struct scsi_device *sdev, struct llun_info *lli)
 
 	/* Drop the ioctl read semahpore across lengthy call */
 	up_read(&cfg->ioctl_rwsem);
-	result.combined = scsi_execute(sdev, scsi_cmd, DMA_FROM_DEVICE, cmd_buf,
+	result = scsi_execute(sdev, scsi_cmd, DMA_FROM_DEVICE, cmd_buf,
 			      CMD_BUFSIZE, NULL, &sshdr, to, CMD_RETRIES,
 			      0, 0, NULL);
 	down_read(&cfg->ioctl_rwsem);
diff --git a/drivers/scsi/cxlflash/vlun.c b/drivers/scsi/cxlflash/vlun.c
index 01917b28cdb6..283160903c6e 100644
--- a/drivers/scsi/cxlflash/vlun.c
+++ b/drivers/scsi/cxlflash/vlun.c
@@ -423,7 +423,7 @@ static int write_same16(struct scsi_device *sdev,
 	u8 *cmd_buf = NULL;
 	u8 *scsi_cmd = NULL;
 	int rc = 0;
-	int result = 0;
+	union scsi_status result = { };
 	u64 offset = lba;
 	int left = nblks;
 	struct cxlflash_cfg *cfg = shost_priv(sdev->host);
@@ -457,15 +457,15 @@ static int write_same16(struct scsi_device *sdev,
 		rc = check_state(cfg);
 		if (rc) {
 			dev_err(dev, "%s: Failed state result=%08x\n",
-				__func__, result);
+				__func__, result.combined);
 			rc = -ENODEV;
 			goto out;
 		}
 
-		if (result) {
+		if (result.combined) {
 			dev_err_ratelimited(dev, "%s: command failed for "
 					    "offset=%lld result=%08x\n",
-					    __func__, offset, result);
+					    __func__, offset, result.combined);
 			rc = -EIO;
 			goto out;
 		}
diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index d8269cdec399..0de3096f9df7 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -122,8 +122,9 @@ static void release_port_group(struct kref *kref)
  * submit_rtpg - Issue a REPORT TARGET GROUP STATES command
  * @sdev: sdev the command should be sent to
  */
-static int submit_rtpg(struct scsi_device *sdev, unsigned char *buff,
-		       int bufflen, struct scsi_sense_hdr *sshdr, int flags)
+static union scsi_status submit_rtpg(struct scsi_device *sdev,
+				      unsigned char *buff, int bufflen,
+				      struct scsi_sense_hdr *sshdr, int flags)
 {
 	u8 cdb[MAX_COMMAND_SIZE];
 	int req_flags = REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
@@ -150,8 +151,8 @@ static int submit_rtpg(struct scsi_device *sdev, unsigned char *buff,
  * to 'active/optimized' and let the array firmware figure out
  * the states of the remaining groups.
  */
-static int submit_stpg(struct scsi_device *sdev, int group_id,
-		       struct scsi_sense_hdr *sshdr)
+static union scsi_status submit_stpg(struct scsi_device *sdev, int group_id,
+				      struct scsi_sense_hdr *sshdr)
 {
 	u8 cdb[MAX_COMMAND_SIZE];
 	unsigned char stpg_data[8];
@@ -544,8 +545,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 
  retry:
 	err = 0;
-	retval.combined = submit_rtpg(sdev, buff, bufflen, &sense_hdr,
-				      pg->flags);
+	retval = submit_rtpg(sdev, buff, bufflen, &sense_hdr, pg->flags);
 
 	if (retval.combined) {
 		/*
@@ -790,7 +790,7 @@ static unsigned alua_stpg(struct scsi_device *sdev, struct alua_port_group *pg)
 			    ALUA_DH_NAME, pg->state);
 		return SCSI_DH_NOSYS;
 	}
-	retval.combined = submit_stpg(sdev, pg->group_id, &sense_hdr);
+	retval = submit_stpg(sdev, pg->group_id, &sense_hdr);
 
 	if (retval.combined) {
 		if (!scsi_sense_valid(&sense_hdr)) {
diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index bd28ec6cfb72..062dee18b781 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -237,7 +237,8 @@ static int send_trespass_cmd(struct scsi_device *sdev,
 {
 	unsigned char *page22;
 	unsigned char cdb[MAX_COMMAND_SIZE];
-	int err, res = SCSI_DH_OK, len;
+	int res = SCSI_DH_OK, len;
+	union scsi_status err;
 	struct scsi_sense_hdr sshdr;
 	u64 req_flags = REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
 		REQ_FAILFAST_DRIVER;
@@ -266,13 +267,13 @@ static int send_trespass_cmd(struct scsi_device *sdev,
 	err = scsi_execute(sdev, cdb, DMA_TO_DEVICE, csdev->buffer, len, NULL,
 			&sshdr, CLARIION_TIMEOUT * HZ, CLARIION_RETRIES,
 			req_flags, 0, NULL);
-	if (err) {
+	if (err.combined) {
 		if (scsi_sense_valid(&sshdr))
 			res = trespass_endio(sdev, &sshdr);
 		else {
 			sdev_printk(KERN_INFO, sdev,
 				    "%s: failed to send MODE SELECT: %x\n",
-				    CLARIION_NAME, err);
+				    CLARIION_NAME, err.combined);
 			res = SCSI_DH_IO;
 		}
 	}
diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 4a3f7831a2d6..136b07739deb 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -82,20 +82,21 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 {
 	unsigned char cmd[6] = { TEST_UNIT_READY };
 	struct scsi_sense_hdr sshdr;
-	int ret = SCSI_DH_OK, res;
+	int ret = SCSI_DH_OK;
+	union scsi_status res;
 	u64 req_flags = REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
 		REQ_FAILFAST_DRIVER;
 
 retry:
 	res = scsi_execute(sdev, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
 			HP_SW_TIMEOUT, HP_SW_RETRIES, req_flags, 0, NULL);
-	if (res) {
+	if (res.combined) {
 		if (scsi_sense_valid(&sshdr))
 			ret = tur_done(sdev, h, &sshdr);
 		else {
 			sdev_printk(KERN_WARNING, sdev,
 				    "%s: sending tur failed with %x\n",
-				    HP_SW_NAME, res);
+				    HP_SW_NAME, res.combined);
 			ret = SCSI_DH_IO;
 		}
 	} else {
@@ -119,7 +120,8 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 	unsigned char cmd[6] = { START_STOP, 0, 0, 0, 1, 0 };
 	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdev = h->sdev;
-	int res, rc = SCSI_DH_OK;
+	int rc = SCSI_DH_OK;
+	union scsi_status res;
 	int retry_cnt = HP_SW_RETRIES;
 	u64 req_flags = REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
 		REQ_FAILFAST_DRIVER;
@@ -127,7 +129,7 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 retry:
 	res = scsi_execute(sdev, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
 			HP_SW_TIMEOUT, HP_SW_RETRIES, req_flags, 0, NULL);
-	if (res) {
+	if (res.combined) {
 		if (!scsi_sense_valid(&sshdr)) {
 			sdev_printk(KERN_WARNING, sdev,
 				    "%s: sending start_stop_unit failed, "
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index 25f6e1ac9e7b..6078cb45f783 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -557,7 +557,7 @@ static void send_mode_select(struct work_struct *work)
 
 	if (scsi_execute(sdev, cdb, DMA_TO_DEVICE, &h->ctlr->mode_select,
 			data_size, NULL, &sshdr, RDAC_TIMEOUT * HZ,
-			RDAC_RETRIES, req_flags, 0, NULL)) {
+			RDAC_RETRIES, req_flags, 0, NULL).combined) {
 		err = mode_select_handle_sense(sdev, &sshdr);
 		if (err == SCSI_DH_RETRY && retry_cnt--)
 			goto retry;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 882e04c8be69..485cb002cbc9 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -237,7 +237,8 @@ void scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
  * Returns the scsi_cmnd result field if a command was executed, or a negative
  * Linux error code if we didn't get that far.
  */
-int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
+union scsi_status
+__scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 		 int data_direction, void *buffer, unsigned bufflen,
 		 unsigned char *sense, struct scsi_sense_hdr *sshdr,
 		 int timeout, int retries, u64 flags, req_flags_t rq_flags,
@@ -245,7 +246,7 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 {
 	struct request *req;
 	struct scsi_request *rq;
-	int ret = DRIVER_ERROR << 24;
+	union scsi_status ret = { .b.driver = DRIVER_ERROR };
 
 	req = blk_get_request(sdev->request_queue,
 			data_direction == DMA_TO_DEVICE ?
@@ -286,7 +287,7 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 		memcpy(sense, rq->sense, SCSI_SENSE_BUFFERSIZE);
 	if (sshdr)
 		scsi_normalize_sense(rq->sense, rq->sense_len, sshdr);
-	ret = rq->status.combined;
+	ret = rq->status;
  out:
 	blk_put_request(req);
 
diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 8788066275df..f9da5da6a7d3 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -122,8 +122,7 @@ static int spi_execute(struct scsi_device *sdev, const void *cmd,
 		 * The purpose of the RQF_PM flag below is to bypass the
 		 * SDEV_QUIESCE state.
 		 */
-		result.combined =
-			scsi_execute(sdev, cmd, dir, buffer, bufflen, sense,
+		result = scsi_execute(sdev, cmd, dir, buffer, bufflen, sense,
 				      sshdr, DV_TIMEOUT, /* retries */ 1,
 				      REQ_FAILFAST_DEV |
 				      REQ_FAILFAST_TRANSPORT |
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 756fe99794a7..263a0e253f60 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -700,7 +700,7 @@ static int sd_sec_submit(void *data, u16 spsp, u8 secp, void *buffer,
 	struct scsi_disk *sdkp = data;
 	struct scsi_device *sdev = sdkp->device;
 	u8 cdb[12] = { 0, };
-	int ret;
+	union scsi_status ret;
 
 	cdb[0] = send ? SECURITY_PROTOCOL_OUT : SECURITY_PROTOCOL_IN;
 	cdb[1] = secp;
@@ -710,7 +710,7 @@ static int sd_sec_submit(void *data, u16 spsp, u8 secp, void *buffer,
 	ret = scsi_execute(sdev, cdb, send ? DMA_TO_DEVICE : DMA_FROM_DEVICE,
 		buffer, len, NULL, NULL, SD_TIMEOUT, sdkp->max_retries, 0,
 		RQF_PM, NULL);
-	return ret <= 0 ? ret : -EIO;
+	return ret.combined <= 0 ? ret.combined : -EIO;
 }
 #endif /* CONFIG_BLK_SED_OPAL */
 
@@ -1712,7 +1712,7 @@ static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
 		 * Leave the rest of the command zero to indicate
 		 * flush everything.
 		 */
-		res.combined = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, sshdr,
+		res = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, sshdr,
 				timeout, sdkp->max_retries, 0, RQF_PM, NULL);
 		if (res.combined == 0)
 			break;
@@ -3593,7 +3593,7 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 	if (!scsi_device_online(sdp))
 		return -ENODEV;
 
-	res.combined = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
+	res = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
 			SD_TIMEOUT, sdkp->max_retries, 0, RQF_PM, NULL);
 	if (res.combined) {
 		sd_print_result(sdkp, "Start/Stop Unit failed", res);
diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index 11170d742e40..b13612f50d6d 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -201,7 +201,7 @@ int sr_do_ioctl(Scsi_CD *cd, struct packet_command *cgc)
 		goto out;
 	}
 
-	result.combined = scsi_execute(SDev, cgc->cmd, cgc->data_direction,
+	result = scsi_execute(SDev, cgc->cmd, cgc->data_direction,
 			      cgc->buffer, cgc->buflen, NULL, sshdr,
 			      cgc->timeout, IOCTL_RETRIES, 0, 0, NULL);
 
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index cec555d3fcd7..20a200a2acef 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8412,7 +8412,7 @@ ufshcd_send_request_sense(struct ufs_hba *hba, struct scsi_device *sdp)
 
 	ret = scsi_execute(sdp, cmd, DMA_FROM_DEVICE, buffer,
 			UFS_SENSE_SIZE, NULL, NULL,
-			msecs_to_jiffies(1000), 3, 0, RQF_PM, NULL);
+			msecs_to_jiffies(1000), 3, 0, RQF_PM, NULL).combined;
 	if (ret)
 		pr_err("%s: failed with err %d\n", __func__, ret);
 
@@ -8472,7 +8472,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	 * callbacks hence set the RQF_PM flag so that it doesn't resume the
 	 * already suspended childs.
 	 */
-	start_stop_res.combined =
+	start_stop_res =
 		scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
 			START_STOP_TIMEOUT, 0, 0, RQF_PM, NULL);
 	ret = start_stop_res.combined;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index ac6ab16abee7..c91c284c88ef 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -439,7 +439,8 @@ extern const char *scsi_device_state_name(enum scsi_device_state);
 extern int scsi_is_sdev_device(const struct device *);
 extern int scsi_is_target_device(const struct device *);
 extern void scsi_sanitize_inquiry_string(unsigned char *s, int len);
-extern int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
+extern union scsi_status
+__scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 			int data_direction, void *buffer, unsigned bufflen,
 			unsigned char *sense, struct scsi_sense_hdr *sshdr,
 			int timeout, int retries, u64 flags,
@@ -460,7 +461,7 @@ static inline int scsi_execute_req(struct scsi_device *sdev,
 	int retries, int *resid)
 {
 	return scsi_execute(sdev, cmd, data_direction, buffer,
-		bufflen, NULL, sshdr, timeout, retries,  0, 0, resid);
+		bufflen, NULL, sshdr, timeout, retries,  0, 0, resid).combined;
 }
 extern void sdev_disable_disk_events(struct scsi_device *sdev);
 extern void sdev_enable_disk_events(struct scsi_device *sdev);
