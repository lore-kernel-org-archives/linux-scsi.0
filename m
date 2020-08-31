Return-Path: <SRS0=g0vc=CJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2D53C433E7
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Aug 2020 02:54:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A83992076D
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Aug 2020 02:54:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgHaCyU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 30 Aug 2020 22:54:20 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37641 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726946AbgHaCyO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Aug 2020 22:54:14 -0400
Received: by mail-pl1-f194.google.com with SMTP id c15so2351494plq.4
        for <linux-scsi@vger.kernel.org>; Sun, 30 Aug 2020 19:54:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q0GipgpvZhLUV8bGMCiFNZOWoygkRH0DKlv2BF+3dm4=;
        b=BNpGJTns0PE3KupFGXJ7QHYKd879Y3PltiAD1nZwD9PzWLcZwj+k95ifzkNNS5dHdL
         YkDKFTzQpf1jyLGCJ36xL1xxncY9YxLuOalY9LZmDS9OjfrHwjfJbjJn38UNSmGBjQec
         nFsglm4tflk6OterjQhsod2xtmnPyATYdY2aJWQkK/HrMpAagbtho7eVEysLWCSCRXDo
         +Ll/5HN16ig7YRHvqrkSs//F+AhdpWs5x3aGRXDFTO7dzWX/EzdggQ8TMIEZfUCNAtez
         YDH5vdY0+ZVb70iL85aBfItMQX/pRluLmoGox16qOAIs2/d1w23q7pSq3M3CDxvrHsBt
         nmlA==
X-Gm-Message-State: AOAM5331MoYZzK2+OZBg1gERpr1nnIabx/yY8+dXjddkFgUy5MkjlW7M
        XTQHDJATbgr1AsrZBOMkshVMosE5aAaUNA==
X-Google-Smtp-Source: ABdhPJz/WEaB5LifcjLr1y2zeJc2DNqRnRuhTmx9KljYIwcvmksTYTrvwHZMNh4ajv6WGd3SjzhMyA==
X-Received: by 2002:a17:902:5991:: with SMTP id p17mr7106151pli.154.1598842452965;
        Sun, 30 Aug 2020 19:54:12 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id l123sm583569pgl.24.2020.08.30.19.54.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2020 19:54:12 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     linux-scsi@vger.kernel.org,
        Martin Kepplinger <martin.kepplinger@puri.sm>,
        Can Guo <cang@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH RFC 4/6] scsi_transport_spi: Make spi_execute() accept a request queue pointer
Date:   Sun, 30 Aug 2020 19:53:55 -0700
Message-Id: <20200831025357.32700-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200831025357.32700-1-bvanassche@acm.org>
References: <20200831025357.32700-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Passing a request queue pointer to spi_execute() instead of a SCSI device
pointer will allow a later patch to associate two request queues with a
SCSI device. Additionally, instead of assuming that the device state is
SDEV_QUIESCE before domain validation starts, read the device state. This
patch does not change any functionality but makes a later patch easier to
read.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_transport_spi.c | 69 ++++++++++++++++---------------
 1 file changed, 36 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index f3d5b1bbd5aa..959990f66865 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -104,7 +104,7 @@ static int sprint_frac(char *dest, int value, int denom)
 	return result;
 }
 
-static int spi_execute(struct scsi_device *sdev, const void *cmd,
+static int spi_execute(struct request_queue *q, const void *cmd,
 		       enum dma_data_direction dir,
 		       void *buffer, unsigned bufflen,
 		       struct scsi_sense_hdr *sshdr)
@@ -117,7 +117,7 @@ static int spi_execute(struct scsi_device *sdev, const void *cmd,
 		sshdr = &sshdr_tmp;
 
 	for(i = 0; i < DV_RETRIES; i++) {
-		result = scsi_execute(sdev, cmd, dir, buffer, bufflen, sense,
+		result = __scsi_execute(q, cmd, dir, buffer, bufflen, sense,
 				      sshdr, DV_TIMEOUT, /* retries */ 1,
 				      REQ_FAILFAST_DEV |
 				      REQ_FAILFAST_TRANSPORT |
@@ -620,13 +620,14 @@ enum spi_compare_returns {
 /* This is for read/write Domain Validation:  If the device supports
  * an echo buffer, we do read/write tests to it */
 static enum spi_compare_returns
-spi_dv_device_echo_buffer(struct scsi_device *sdev, u8 *buffer,
-			  u8 *ptr, const int retries)
+spi_dv_device_echo_buffer(struct scsi_device *sdev, struct request_queue *q,
+			  u8 *buffer, u8 *ptr, const int retries)
 {
 	int len = ptr - buffer;
 	int j, k, r, result;
 	unsigned int pattern = 0x0000ffff;
 	struct scsi_sense_hdr sshdr;
+	enum scsi_device_state sdev_state = sdev->sdev_state;
 
 	const char spi_write_buffer[] = {
 		WRITE_BUFFER, 0x0a, 0, 0, 0, 0, 0, len >> 8, len & 0xff, 0
@@ -671,11 +672,10 @@ spi_dv_device_echo_buffer(struct scsi_device *sdev, u8 *buffer,
 	}
 
 	for (r = 0; r < retries; r++) {
-		result = spi_execute(sdev, spi_write_buffer, DMA_TO_DEVICE,
+		result = spi_execute(q, spi_write_buffer, DMA_TO_DEVICE,
 				     buffer, len, &sshdr);
 		if(result || !scsi_device_online(sdev)) {
-
-			scsi_device_set_state(sdev, SDEV_QUIESCE);
+			scsi_device_set_state(sdev, sdev_state);
 			if (scsi_sense_valid(&sshdr)
 			    && sshdr.sense_key == ILLEGAL_REQUEST
 			    /* INVALID FIELD IN CDB */
@@ -693,9 +693,9 @@ spi_dv_device_echo_buffer(struct scsi_device *sdev, u8 *buffer,
 		}
 
 		memset(ptr, 0, len);
-		spi_execute(sdev, spi_read_buffer, DMA_FROM_DEVICE,
-			    ptr, len, NULL);
-		scsi_device_set_state(sdev, SDEV_QUIESCE);
+		spi_execute(q, spi_read_buffer, DMA_FROM_DEVICE, ptr, len,
+			    NULL);
+		scsi_device_set_state(sdev, sdev_state);
 
 		if (memcmp(buffer, ptr, len) != 0)
 			return SPI_COMPARE_FAILURE;
@@ -706,11 +706,12 @@ spi_dv_device_echo_buffer(struct scsi_device *sdev, u8 *buffer,
 /* This is for the simplest form of Domain Validation: a read test
  * on the inquiry data from the device */
 static enum spi_compare_returns
-spi_dv_device_compare_inquiry(struct scsi_device *sdev, u8 *buffer,
-			      u8 *ptr, const int retries)
+spi_dv_device_compare_inquiry(struct scsi_device *sdev, struct request_queue *q,
+			      u8 *buffer, u8 *ptr, const int retries)
 {
 	int r, result;
 	const int len = sdev->inquiry_len;
+	enum scsi_device_state sdev_state = sdev->sdev_state;
 	const char spi_inquiry[] = {
 		INQUIRY, 0, 0, 0, len, 0
 	};
@@ -718,11 +719,11 @@ spi_dv_device_compare_inquiry(struct scsi_device *sdev, u8 *buffer,
 	for (r = 0; r < retries; r++) {
 		memset(ptr, 0, len);
 
-		result = spi_execute(sdev, spi_inquiry, DMA_FROM_DEVICE,
-				     ptr, len, NULL);
+		result = spi_execute(q, spi_inquiry, DMA_FROM_DEVICE, ptr, len,
+				     NULL);
 		
 		if(result || !scsi_device_online(sdev)) {
-			scsi_device_set_state(sdev, SDEV_QUIESCE);
+			scsi_device_set_state(sdev, sdev_state);
 			return SPI_COMPARE_FAILURE;
 		}
 
@@ -742,9 +743,10 @@ spi_dv_device_compare_inquiry(struct scsi_device *sdev, u8 *buffer,
 }
 
 static enum spi_compare_returns
-spi_dv_retrain(struct scsi_device *sdev, u8 *buffer, u8 *ptr,
-	       enum spi_compare_returns 
-	       (*compare_fn)(struct scsi_device *, u8 *, u8 *, int))
+spi_dv_retrain(struct scsi_device *sdev, struct request_queue *q, u8 *buffer,
+	       u8 *ptr, enum spi_compare_returns
+	       (*compare_fn)(struct scsi_device *, struct request_queue *,
+			     u8 *, u8 *, int))
 {
 	struct spi_internal *i = to_spi_internal(sdev->host->transportt);
 	struct scsi_target *starget = sdev->sdev_target;
@@ -754,7 +756,7 @@ spi_dv_retrain(struct scsi_device *sdev, u8 *buffer, u8 *ptr,
 
 	for (;;) {
 		int newperiod;
-		retval = compare_fn(sdev, buffer, ptr, DV_LOOPS);
+		retval = compare_fn(sdev, q, buffer, ptr, DV_LOOPS);
 
 		if (retval == SPI_COMPARE_SUCCESS
 		    || retval == SPI_COMPARE_SKIP_TEST)
@@ -800,7 +802,8 @@ spi_dv_retrain(struct scsi_device *sdev, u8 *buffer, u8 *ptr,
 }
 
 static int
-spi_dv_device_get_echo_buffer(struct scsi_device *sdev, u8 *buffer)
+spi_dv_device_get_echo_buffer(struct scsi_device *sdev,
+			      struct request_queue *q, u8 *buffer)
 {
 	int l, result;
 
@@ -824,8 +827,8 @@ spi_dv_device_get_echo_buffer(struct scsi_device *sdev, u8 *buffer)
 	 * (reservation conflict, device not ready, etc) just
 	 * skip the write tests */
 	for (l = 0; ; l++) {
-		result = spi_execute(sdev, spi_test_unit_ready, DMA_NONE, 
-				     NULL, 0, NULL);
+		result = spi_execute(q, spi_test_unit_ready, DMA_NONE, NULL, 0,
+				     NULL);
 
 		if(result) {
 			if(l >= 3)
@@ -836,8 +839,8 @@ spi_dv_device_get_echo_buffer(struct scsi_device *sdev, u8 *buffer)
 		}
 	}
 
-	result = spi_execute(sdev, spi_read_buffer_descriptor, 
-			     DMA_FROM_DEVICE, buffer, 4, NULL);
+	result = spi_execute(q, spi_read_buffer_descriptor, DMA_FROM_DEVICE,
+			     buffer, 4, NULL);
 
 	if (result)
 		/* Device has no echo buffer */
@@ -847,7 +850,8 @@ spi_dv_device_get_echo_buffer(struct scsi_device *sdev, u8 *buffer)
 }
 
 static void
-spi_dv_device_internal(struct scsi_device *sdev, u8 *buffer)
+spi_dv_device_internal(struct scsi_device *sdev, struct request_queue *q,
+		       u8 *buffer)
 {
 	struct spi_internal *i = to_spi_internal(sdev->host->transportt);
 	struct scsi_target *starget = sdev->sdev_target;
@@ -859,7 +863,7 @@ spi_dv_device_internal(struct scsi_device *sdev, u8 *buffer)
 	DV_SET(offset, 0);
 	DV_SET(width, 0);
 
-	if (spi_dv_device_compare_inquiry(sdev, buffer, buffer, DV_LOOPS)
+	if (spi_dv_device_compare_inquiry(sdev, q, buffer, buffer, DV_LOOPS)
 	    != SPI_COMPARE_SUCCESS) {
 		starget_printk(KERN_ERR, starget, "Domain Validation Initial Inquiry Failed\n");
 		/* FIXME: should probably offline the device here? */
@@ -875,9 +879,8 @@ spi_dv_device_internal(struct scsi_device *sdev, u8 *buffer)
 	if (i->f->set_width && max_width) {
 		i->f->set_width(starget, 1);
 
-		if (spi_dv_device_compare_inquiry(sdev, buffer,
-						   buffer + len,
-						   DV_LOOPS)
+		if (spi_dv_device_compare_inquiry(sdev, q, buffer, buffer + len,
+						  DV_LOOPS)
 		    != SPI_COMPARE_SUCCESS) {
 			starget_printk(KERN_ERR, starget, "Wide Transfers Fail\n");
 			i->f->set_width(starget, 0);
@@ -946,7 +949,7 @@ spi_dv_device_internal(struct scsi_device *sdev, u8 *buffer)
 	DV_SET(width, max_width);
 
 	/* Do the read only INQUIRY tests */
-	spi_dv_retrain(sdev, buffer, buffer + sdev->inquiry_len,
+	spi_dv_retrain(sdev, q, buffer, buffer + sdev->inquiry_len,
 		       spi_dv_device_compare_inquiry);
 	/* See if we actually managed to negotiate and sustain DT */
 	if (i->f->get_dt)
@@ -958,7 +961,7 @@ spi_dv_device_internal(struct scsi_device *sdev, u8 *buffer)
 	 * negotiated DT */
 
 	if (len == -1 && spi_dt(starget))
-		len = spi_dv_device_get_echo_buffer(sdev, buffer);
+		len = spi_dv_device_get_echo_buffer(sdev, q, buffer);
 
 	if (len <= 0) {
 		starget_printk(KERN_INFO, starget, "Domain Validation skipping write tests\n");
@@ -970,7 +973,7 @@ spi_dv_device_internal(struct scsi_device *sdev, u8 *buffer)
 		len = SPI_MAX_ECHO_BUFFER_SIZE;
 	}
 
-	if (spi_dv_retrain(sdev, buffer, buffer + len,
+	if (spi_dv_retrain(sdev, q, buffer, buffer + len,
 			   spi_dv_device_echo_buffer)
 	    == SPI_COMPARE_SKIP_TEST) {
 		/* OK, the stupid drive can't do a write echo buffer
@@ -1030,7 +1033,7 @@ spi_dv_device(struct scsi_device *sdev)
 
 	starget_printk(KERN_INFO, starget, "Beginning Domain Validation\n");
 
-	spi_dv_device_internal(sdev, buffer);
+	spi_dv_device_internal(sdev, sdev->request_queue, buffer);
 
 	starget_printk(KERN_INFO, starget, "Ending Domain Validation\n");
 
