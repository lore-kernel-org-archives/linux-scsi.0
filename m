Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E40A8C43461
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBA8C6109E
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233175AbhDTAJu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:09:50 -0400
Received: from mail-pl1-f178.google.com ([209.85.214.178]:47073 "EHLO
        mail-pl1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232951AbhDTAJl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:09:41 -0400
Received: by mail-pl1-f178.google.com with SMTP id s20so2838184plr.13
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:09:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QuYinr+a0R07jgiJt9P0PtvtChRLZsRq1Pa20bE+hhM=;
        b=sDCsCR8MLcv3nfMTvOBDYZaUSWTvi03B7eNOYjHaSY81Vc2eJUFCoqFWY5mBcaMMq7
         ggQVajalAabBNNIojuJxLdfFEaIK/qapI43tdcaFWYxbJVd3xOkvh6/supxHxgmDDGnC
         tY5NqcBmwluAXs0nGEJW9ws9wIQ5VSqIuaDtgVX3FiWAfr20THZPfin3Yptd9AyoOTc2
         4h3Adccn3dEWGIscgFbvViPzQ3b9D5ZCOTUHGYwfpuNw028LuccXd2uTudxw5Kha5H0x
         wZE+yqD0cQ8wWaBCbZVtejMJNxgU/qxCr0xXxunpdHAQs9cgAQxXK3+oiq8ol4QbLKmt
         lN5g==
X-Gm-Message-State: AOAM533XdaJ673oazraUH/+XQOugGe2FTEEbWKkuDUbQaypqHsKtw4wa
        3mk9VUM/6YhWq+lKymvwmDs=
X-Google-Smtp-Source: ABdhPJz1JpJZ8VllAzcUpei4bqeYidgyEJK2wTnK6YD6OTJGdDJUdqcjYylv6N6NYXHT5mjHiMDj+A==
X-Received: by 2002:a17:902:7795:b029:ec:b1ca:de75 with SMTP id o21-20020a1709027795b02900ecb1cade75mr3466647pll.70.1618877350895;
        Mon, 19 Apr 2021 17:09:10 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.09.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:09:10 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 016/117] sr: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:07:04 -0700
Message-Id: <20210420000845.25873-17-bvanassche@acm.org>
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

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sr.c       | 16 +++++++++-------
 drivers/scsi/sr_ioctl.c |  5 +++--
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index e4633b84c556..a78e499d4836 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -237,7 +237,7 @@ static unsigned int sr_check_events(struct cdrom_device_info *cdi,
 	bool last_present;
 	struct scsi_sense_hdr sshdr;
 	unsigned int events;
-	int ret;
+	union scsi_status ret;
 
 	/* no changer support */
 	if (CDSL_CURRENT != slot)
@@ -273,7 +273,8 @@ static unsigned int sr_check_events(struct cdrom_device_info *cdi,
 do_tur:
 	/* let's see whether the media is there with TUR */
 	last_present = cd->media_present;
-	ret = scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr);
+	ret.combined = scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES,
+					    &sshdr);
 
 	/*
 	 * Media is considered to be present if TUR succeeds or fails with
@@ -321,15 +322,15 @@ static unsigned int sr_check_events(struct cdrom_device_info *cdi,
  */
 static int sr_done(struct scsi_cmnd *SCpnt)
 {
-	int result = SCpnt->result;
+	const union scsi_status result = SCpnt->status;
 	int this_count = scsi_bufflen(SCpnt);
-	int good_bytes = (result == 0 ? this_count : 0);
+	int good_bytes = result.combined == 0 ? this_count : 0;
 	int block_sectors = 0;
 	long error_sector;
 	struct scsi_cd *cd = scsi_cd(SCpnt->request->rq_disk);
 
 #ifdef DEBUG
-	scmd_printk(KERN_INFO, SCpnt, "done: %x\n", result);
+	scmd_printk(KERN_INFO, SCpnt, "done: %x\n", result.combined);
 #endif
 
 	/*
@@ -882,7 +883,8 @@ static void get_capabilities(struct scsi_cd *cd)
 	struct scsi_mode_data data;
 	struct scsi_sense_hdr sshdr;
 	unsigned int ms_len = 128;
-	int rc, n;
+	union scsi_status rc;
+	int n;
 
 	static const char *loadmech[] =
 	{
@@ -908,7 +910,7 @@ static void get_capabilities(struct scsi_cd *cd)
 	scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr);
 
 	/* ask for mode page 0x2a */
-	rc = scsi_mode_sense(cd->device, 0, 0x2a, buffer, ms_len,
+	rc.combined = scsi_mode_sense(cd->device, 0, 0x2a, buffer, ms_len,
 			     SR_TIMEOUT, 3, &data, NULL);
 
 	if (!scsi_status_is_good(rc) || data.length > ms_len ||
diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index 5703f8400b73..11170d742e40 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -187,7 +187,8 @@ int sr_do_ioctl(Scsi_CD *cd, struct packet_command *cgc)
 {
 	struct scsi_device *SDev;
 	struct scsi_sense_hdr local_sshdr, *sshdr = &local_sshdr;
-	int result, err = 0, retries = 0;
+	union scsi_status result;
+	int err = 0, retries = 0;
 
 	SDev = cd->device;
 
@@ -200,7 +201,7 @@ int sr_do_ioctl(Scsi_CD *cd, struct packet_command *cgc)
 		goto out;
 	}
 
-	result = scsi_execute(SDev, cgc->cmd, cgc->data_direction,
+	result.combined = scsi_execute(SDev, cgc->cmd, cgc->data_direction,
 			      cgc->buffer, cgc->buflen, NULL, sshdr,
 			      cgc->timeout, IOCTL_RETRIES, 0, 0, NULL);
 
