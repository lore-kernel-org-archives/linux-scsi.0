Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93E9BC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6380F61107
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233826AbhDTCPR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 22:15:17 -0400
Received: from mail-pg1-f170.google.com ([209.85.215.170]:40902 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233803AbhDTCPJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 22:15:09 -0400
Received: by mail-pg1-f170.google.com with SMTP id b17so25573234pgh.7
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 19:14:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A1HgG7bhuOpMgMFQ3Em5ZD7GI6GUv5eNGkKBkv3gf/w=;
        b=NvZioW1fRI/u0XPD+4pBnylWbnO0jm4pwvfzhb/A1cfT0NisEBA5q6yhQA4rl+6RMs
         m35n4t/EdZOkhQ0rKWa5KcQPbUoDj34j7Bz+6O76STyuTMN+ykvpDisFsCzzJXQQbSkQ
         azWP00qbGnuchZ0fydb2EV7ejq16G7lnG3xdzjOuv04ZXjdud4Y6V0ApSgJxhT0hxJpA
         hT1HRdTfrSUWYrB1PjO2I0TU3hgBAgBpvNnP2NLH6Obyo3Hf2R+fwm8F13WViog+3+dM
         2xy+Dz7zNXDnaKRI7jIHXFFAe6X0cl3NAO+Vs3CIGq1KJd5kmxIH/Z4383uclHVeh551
         5PyQ==
X-Gm-Message-State: AOAM5336exeV4h0g1JPNGJ43+BDY/0A8O3bvgPC1dSQjUqePWBpJblAs
        lRNVJRLsktMEnOkFSMOH/q4=
X-Google-Smtp-Source: ABdhPJxLbeUgKPZAeorpc/4YahLYPvAwiC5M9n1tF5bkAI9uarqtC/OoQ6Pn3+kkfbzFK1vE014Nmw==
X-Received: by 2002:a63:1024:: with SMTP id f36mr14718615pgl.299.1618884878847;
        Mon, 19 Apr 2021 19:14:38 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id mq2sm630984pjb.24.2021.04.19.19.14.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 19:14:38 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 115/117] Change the return types of scsi_mode_sense() and sd_do_mode_sense()
Date:   Mon, 19 Apr 2021 19:14:00 -0700
Message-Id: <20210420021402.27678-25-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that scsi_mode_sense() and sd_do_mode_sense() return a SCSI
status.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: John Garry <john.garry@huawei.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c           |  4 ++--
 drivers/scsi/scsi_transport_sas.c |  4 ++--
 drivers/scsi/sd.c                 | 18 +++++++++---------
 drivers/scsi/sr.c                 |  2 +-
 include/scsi/scsi_device.h        |  8 ++++----
 5 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 44925839ccee..964462895cbb 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2144,7 +2144,7 @@ EXPORT_SYMBOL_GPL(scsi_mode_select);
  *	or 8 depending on whether a six or ten byte command was
  *	issued) if successful.
  */
-int
+union scsi_status
 scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 		  unsigned char *buffer, int len, int timeout, int retries,
 		  struct scsi_mode_data *data, struct scsi_sense_hdr *sshdr)
@@ -2241,7 +2241,7 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 		goto retry;
 	}
 
-	return result.combined;
+	return result;
 }
 EXPORT_SYMBOL(scsi_mode_sense);
 
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 2caa1393cf94..65caf3888f36 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -1235,8 +1235,8 @@ int sas_read_port_mode_page(struct scsi_device *sdev)
 	if (!buffer)
 		return -ENOMEM;
 
-	res.combined = scsi_mode_sense(sdev, 1, 0x19, buffer, BUF_SIZE, 30*HZ,
-				       3, &mode_data, NULL);
+	res = scsi_mode_sense(sdev, 1, 0x19, buffer, BUF_SIZE, 30*HZ, 3,
+			      &mode_data, NULL);
 
 	error = -EINVAL;
 	if (!scsi_status_is_good(res))
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 14cf7841a0bf..2f423a332bc1 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -194,7 +194,7 @@ cache_type_store(struct device *dev, struct device_attribute *attr,
 	}
 
 	if (scsi_mode_sense(sdp, 0x08, 8, buffer, sizeof(buffer), SD_TIMEOUT,
-			    sdkp->max_retries, &data, NULL))
+			    sdkp->max_retries, &data, NULL).combined)
 		return -EINVAL;
 	len = min_t(size_t, sizeof(buffer), data.length - data.header_length -
 		  data.block_descriptor_length);
@@ -2628,7 +2628,7 @@ sd_print_capacity(struct scsi_disk *sdkp,
 }
 
 /* called with buffer of length 512 */
-static inline int
+static inline union scsi_status
 sd_do_mode_sense(struct scsi_disk *sdkp, int dbd, int modepage,
 		 unsigned char *buffer, int len, struct scsi_mode_data *data,
 		 struct scsi_sense_hdr *sshdr)
@@ -2657,14 +2657,14 @@ sd_read_write_protect_flag(struct scsi_disk *sdkp, unsigned char *buffer)
 	}
 
 	if (sdp->use_192_bytes_for_3f) {
-		res.combined = sd_do_mode_sense(sdkp, 0, 0x3F, buffer, 192, &data, NULL);
+		res = sd_do_mode_sense(sdkp, 0, 0x3F, buffer, 192, &data, NULL);
 	} else {
 		/*
 		 * First attempt: ask for all pages (0x3F), but only 4 bytes.
 		 * We have to start carefully: some devices hang if we ask
 		 * for more than is available.
 		 */
-		res.combined = sd_do_mode_sense(sdkp, 0, 0x3F, buffer, 4, &data, NULL);
+		res = sd_do_mode_sense(sdkp, 0, 0x3F, buffer, 4, &data, NULL);
 
 		/*
 		 * Second attempt: ask for page 0 When only page 0 is
@@ -2673,13 +2673,13 @@ sd_read_write_protect_flag(struct scsi_disk *sdkp, unsigned char *buffer)
 		 * CDB.
 		 */
 		if (!scsi_status_is_good(res))
-			res.combined = sd_do_mode_sense(sdkp, 0, 0, buffer, 4, &data, NULL);
+			res = sd_do_mode_sense(sdkp, 0, 0, buffer, 4, &data, NULL);
 
 		/*
 		 * Third attempt: ask 255 bytes, as we did earlier.
 		 */
 		if (!scsi_status_is_good(res))
-			res.combined = sd_do_mode_sense(sdkp, 0, 0x3F, buffer, 255,
+			res = sd_do_mode_sense(sdkp, 0, 0x3F, buffer, 255,
 					       &data, NULL);
 	}
 
@@ -2742,7 +2742,7 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 	}
 
 	/* cautiously ask */
-	res.combined = sd_do_mode_sense(sdkp, dbd, modepage, buffer, first_len,
+	res = sd_do_mode_sense(sdkp, dbd, modepage, buffer, first_len,
 			&data, &sshdr);
 
 	if (!scsi_status_is_good(res))
@@ -2774,7 +2774,7 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 
 	/* Get the data */
 	if (len > first_len)
-		res.combined = sd_do_mode_sense(sdkp, dbd, modepage, buffer, len,
+		res = sd_do_mode_sense(sdkp, dbd, modepage, buffer, len,
 				&data, &sshdr);
 
 	if (scsi_status_is_good(res)) {
@@ -2893,7 +2893,7 @@ static void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
 	if (sdkp->protection_type == 0)
 		return;
 
-	res.combined = scsi_mode_sense(sdp, 1, 0x0a, buffer, 36, SD_TIMEOUT,
+	res = scsi_mode_sense(sdp, 1, 0x0a, buffer, 36, SD_TIMEOUT,
 			      sdkp->max_retries, &data, &sshdr);
 
 	if (!scsi_status_is_good(res) || !data.header_length ||
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index da78b402072f..2496ece3a33d 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -910,7 +910,7 @@ static void get_capabilities(struct scsi_cd *cd)
 	scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr);
 
 	/* ask for mode page 0x2a */
-	rc.combined = scsi_mode_sense(cd->device, 0, 0x2a, buffer, ms_len,
+	rc = scsi_mode_sense(cd->device, 0, 0x2a, buffer, ms_len,
 			     SR_TIMEOUT, 3, &data, NULL);
 
 	if (!scsi_status_is_good(rc) || data.length > ms_len ||
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 3192610af5db..de6f5f98d2eb 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -402,10 +402,10 @@ extern int scsi_track_queue_full(struct scsi_device *, int);
 
 extern int scsi_set_medium_removal(struct scsi_device *, char);
 
-extern int scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
-			   unsigned char *buffer, int len, int timeout,
-			   int retries, struct scsi_mode_data *data,
-			   struct scsi_sense_hdr *);
+extern union scsi_status scsi_mode_sense(struct scsi_device *sdev, int dbd,
+			int modepage, unsigned char *buffer, int len,
+			int timeout, int retries, struct scsi_mode_data *data,
+			struct scsi_sense_hdr *);
 extern int scsi_mode_select(struct scsi_device *sdev, int pf, int sp,
 			    int modepage, unsigned char *buffer, int len,
 			    int timeout, int retries,
