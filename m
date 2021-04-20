Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E520AC43460
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B532761107
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:14:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233841AbhDTCPS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 22:15:18 -0400
Received: from mail-pg1-f176.google.com ([209.85.215.176]:41716 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233834AbhDTCPK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 22:15:10 -0400
Received: by mail-pg1-f176.google.com with SMTP id f29so25550598pgm.8
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 19:14:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FOF9CUR9pBcuVLRccO3Fsu1jx+S1jL640eQGZaFINf0=;
        b=R3NiPrnrrjACZRH0OBMyy7ax/IflIxJVie8jtslwNtKxwgS2FaIeGRb+EtZtHTocb/
         GBU9ZjPTji6XY9WvnC5Qi2mGm7bxzOkgiPRE3sUar19+RCNentZDSlR+MJL+8hI6zExF
         9zJYsfgVTB9wuZQk621+POuE3XI/+u5kSuqpXC6FG7s2P4JEA24ahPJTBw4IRWKK6Dli
         PPSto3He52wfABoV9y6UX4/1GskH07HG+z6rEOpOthQ1+aMx+TClSO+3E6oBIM06BYIt
         ncgJNTKMj6btosWHe7G6QeUlIcJT+0rdx/svaS4YZlG6uLQsjVC3rK8XGEcibs5kG9qI
         bzsg==
X-Gm-Message-State: AOAM531QY+h2pt5nTEJR1NfdwYGd+0hJE12YeH/BWUpR+adGCKK/HzBU
        +iqaexQSw9/oFM8vXUfhJ8M=
X-Google-Smtp-Source: ABdhPJxKxb5c0N8h/lDSs5xi4vypqeB7P67bPqUytQPCaOdfz46m43VwpMtFwoQBHEMEUU8PChA4Ww==
X-Received: by 2002:a05:6a00:b8e:b029:263:6c93:726d with SMTP id g14-20020a056a000b8eb02902636c93726dmr1433284pfj.66.1618884880081;
        Mon, 19 Apr 2021 19:14:40 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id mq2sm630984pjb.24.2021.04.19.19.14.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 19:14:39 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 116/117] Change the return type of scsi_mode_select() into union scsi_status
Date:   Mon, 19 Apr 2021 19:14:01 -0700
Message-Id: <20210420021402.27678-26-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that scsi_mode_select() returns a SCSI status.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: John Garry <john.garry@huawei.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c    | 18 +++++++++++-------
 drivers/scsi/sd.c          |  2 +-
 include/scsi/scsi_device.h |  9 ++++-----
 3 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 964462895cbb..6d7144750e1c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2069,24 +2069,26 @@ void scsi_exit_queue(void)
  *	status on error
  *
  */
-int
+union scsi_status
 scsi_mode_select(struct scsi_device *sdev, int pf, int sp, int modepage,
 		 unsigned char *buffer, int len, int timeout, int retries,
 		 struct scsi_mode_data *data, struct scsi_sense_hdr *sshdr)
 {
 	unsigned char cmd[10];
 	unsigned char *real_buffer;
-	int ret;
+	union scsi_status ret;
 
 	memset(cmd, 0, sizeof(cmd));
 	cmd[1] = (pf ? 0x10 : 0) | (sp ? 0x01 : 0);
 
 	if (sdev->use_10_for_ms) {
+		ret.combined = -EINVAL;
 		if (len > 65535)
-			return -EINVAL;
+			return ret;
+		ret.combined = -ENOMEM;
 		real_buffer = kmalloc(8 + len, GFP_KERNEL);
 		if (!real_buffer)
-			return -ENOMEM;
+			return ret;
 		memcpy(real_buffer + 8, buffer, len);
 		len += 8;
 		real_buffer[0] = 0;
@@ -2102,13 +2104,15 @@ scsi_mode_select(struct scsi_device *sdev, int pf, int sp, int modepage,
 		cmd[7] = len >> 8;
 		cmd[8] = len;
 	} else {
+		ret.combined = -EINVAL;
 		if (len > 255 || data->block_descriptor_length > 255 ||
 		    data->longlba)
-			return -EINVAL;
+			return ret;
 
+		ret.combined = -ENOMEM;
 		real_buffer = kmalloc(4 + len, GFP_KERNEL);
 		if (!real_buffer)
-			return -ENOMEM;
+			return ret;
 		memcpy(real_buffer + 4, buffer, len);
 		len += 4;
 		real_buffer[0] = 0;
@@ -2121,7 +2125,7 @@ scsi_mode_select(struct scsi_device *sdev, int pf, int sp, int modepage,
 	}
 
 	ret = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, real_buffer, len,
-			       sshdr, timeout, retries, NULL).combined;
+			       sshdr, timeout, retries, NULL);
 	kfree(real_buffer);
 	return ret;
 }
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 2f423a332bc1..d07c0484f325 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -212,7 +212,7 @@ cache_type_store(struct device *dev, struct device_attribute *attr,
 	data.device_specific = 0;
 
 	if (scsi_mode_select(sdp, 1, sp, 8, buffer_data, len, SD_TIMEOUT,
-			     sdkp->max_retries, &data, &sshdr)) {
+			     sdkp->max_retries, &data, &sshdr).combined) {
 		if (scsi_sense_valid(&sshdr))
 			sd_print_sense_hdr(sdkp, &sshdr);
 		return -EINVAL;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index de6f5f98d2eb..fd91cf13a257 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -406,11 +406,10 @@ extern union scsi_status scsi_mode_sense(struct scsi_device *sdev, int dbd,
 			int modepage, unsigned char *buffer, int len,
 			int timeout, int retries, struct scsi_mode_data *data,
 			struct scsi_sense_hdr *);
-extern int scsi_mode_select(struct scsi_device *sdev, int pf, int sp,
-			    int modepage, unsigned char *buffer, int len,
-			    int timeout, int retries,
-			    struct scsi_mode_data *data,
-			    struct scsi_sense_hdr *);
+extern union scsi_status scsi_mode_select(struct scsi_device *sdev, int pf,
+			int sp, int modepage, unsigned char *buffer, int len,
+			int timeout, int retries, struct scsi_mode_data *data,
+			struct scsi_sense_hdr *);
 extern union scsi_status scsi_test_unit_ready(struct scsi_device *sdev,
 			int timeout, int retries, struct scsi_sense_hdr *sshdr);
 extern int scsi_get_vpd_page(struct scsi_device *, u8 page, unsigned char *buf,
