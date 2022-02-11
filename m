Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 077D9C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 22:33:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354101AbiBKWd0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 17:33:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354097AbiBKWdY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 17:33:24 -0500
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AECDD4E
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:33:22 -0800 (PST)
Received: by mail-pj1-f47.google.com with SMTP id a11-20020a17090a740b00b001b8b506c42fso13313258pjg.0
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:33:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KBeb2F7tSmHB1G7Ikr0wqZkswodiLKmsS3V2bljOEik=;
        b=Ik7fEXmHgnV3ubxTbi91CEZ8iIEktz4HXdhsvZfrDdCNvCQFOJrGpIvD8NXcskJFHA
         a4Pu+bHFlwCPjHKAN0CvKeyvIbioITmWAoz3etM007b/RgNTjPpiG81FT/8Vja//Vs5i
         jnv0zpady8LnQ1fEHwnzgukDjeT0m0xU5fXiv5hNSZiXzYkZkAENUksKq8AClKoPsNjU
         9RBxyrBSF3DJfmR1nZOvekX0EZSV2lFuwBkb7hbkcAI4N5DXXUEvVTQ9GvtqjmE5mMkj
         ngY5PuKrAFby3hltTGFJVUPtgdJvCWhmZXAxgG3WtN0qH20nDzkbiEPubx1jmmg95F6f
         qrSA==
X-Gm-Message-State: AOAM530Jor+TAeFZ51cAEMt/4Ycn8G5b7Ih6bYej8TefUWzImcp86iKr
        83IlPWvnq0vi9HqmMA6MxM4=
X-Google-Smtp-Source: ABdhPJy6pDwt1hF4/qnFTlLqGwROTxMCD8gvP5hmhSyG/3AVOh9uuK1VKFHmaltj/n5NEc55MCtNSA==
X-Received: by 2002:a17:90a:e7d1:: with SMTP id kb17mr2598175pjb.1.1644618801343;
        Fri, 11 Feb 2022 14:33:21 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id n13sm6296733pjq.13.2022.02.11.14.33.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 14:33:20 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        Hannes Reinecke <hare@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Finn Thain <fthain@linux-m68k.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 08/48] scsi: NCR5380: Introduce the NCR5380_cmd_priv() function
Date:   Fri, 11 Feb 2022 14:32:07 -0800
Message-Id: <20220211223247.14369-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220211223247.14369-1-bvanassche@acm.org>
References: <20220211223247.14369-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Introduce the NCR5380_cmd_priv() function. This function will allow to
access the SCSI pointer in the next patch with a single statement instead of
two, e.g. as follows:

	struct scsi_pointer *scsi_pointer =
		&NCR5380_cmd_priv(cmd)->scsi_pointer;

Cc: Finn Thain <fthain@telegraphics.com.au>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/NCR5380.c | 8 ++++----
 drivers/scsi/NCR5380.h | 5 +++++
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 55af3e245a92..6fa5e363945a 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -564,7 +564,7 @@ static int NCR5380_queue_command(struct Scsi_Host *instance,
                                  struct scsi_cmnd *cmd)
 {
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
-	struct NCR5380_cmd *ncmd = scsi_cmd_priv(cmd);
+	struct NCR5380_cmd *ncmd = NCR5380_cmd_priv(cmd);
 	unsigned long flags;
 
 #if (NDEBUG & NDEBUG_NO_WRITE)
@@ -672,7 +672,7 @@ static struct scsi_cmnd *dequeue_next_cmd(struct Scsi_Host *instance)
 static void requeue_cmd(struct Scsi_Host *instance, struct scsi_cmnd *cmd)
 {
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
-	struct NCR5380_cmd *ncmd = scsi_cmd_priv(cmd);
+	struct NCR5380_cmd *ncmd = NCR5380_cmd_priv(cmd);
 
 	if (hostdata->sensing == cmd) {
 		scsi_eh_restore_cmnd(cmd, &hostdata->ses);
@@ -1690,7 +1690,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 #endif
 
 	while ((cmd = hostdata->connected)) {
-		struct NCR5380_cmd *ncmd = scsi_cmd_priv(cmd);
+		struct NCR5380_cmd *ncmd = NCR5380_cmd_priv(cmd);
 
 		tmp = NCR5380_read(STATUS_REG);
 		/* We only have a valid SCSI phase when REQ is asserted */
@@ -2206,7 +2206,7 @@ static bool list_del_cmd(struct list_head *haystack,
                          struct scsi_cmnd *needle)
 {
 	if (list_find_cmd(haystack, needle)) {
-		struct NCR5380_cmd *ncmd = scsi_cmd_priv(needle);
+		struct NCR5380_cmd *ncmd = NCR5380_cmd_priv(needle);
 
 		list_del(&ncmd->list);
 		return true;
diff --git a/drivers/scsi/NCR5380.h b/drivers/scsi/NCR5380.h
index 845bd2423e66..88a1bb41b72e 100644
--- a/drivers/scsi/NCR5380.h
+++ b/drivers/scsi/NCR5380.h
@@ -230,6 +230,11 @@ struct NCR5380_cmd {
 	struct list_head list;
 };
 
+static inline struct NCR5380_cmd *NCR5380_cmd_priv(struct scsi_cmnd *cmd)
+{
+	return scsi_cmd_priv(cmd);
+}
+
 #define NCR5380_PIO_CHUNK_SIZE		256
 
 /* Time limit (ms) to poll registers when IRQs are disabled, e.g. during PDMA */
