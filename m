Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95D34C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Feb 2022 21:03:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233214AbiBPVDX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Feb 2022 16:03:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233429AbiBPVDR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2022 16:03:17 -0500
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CB6220F85F
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:03:03 -0800 (PST)
Received: by mail-pj1-f42.google.com with SMTP id a11-20020a17090a740b00b001b8b506c42fso7598462pjg.0
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:03:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iiZX6sV4CwW6jvcUw8nIxaJhZYQIR8ZaripFwFVV2nM=;
        b=rv5a1i5TxFbCdxe6B/17I20hu/DkvX4x6DGfbttfqXFyUSyGYmB2Nr/hDL/j06f9kX
         XKqm6TRIKSBCPJ4H+u4m3dtCzj/8hngATKg/PrsUi2KvQD752SETcwwrz6GRHYnegOFi
         2u18iLqWk4w96voQ6uIVZKKaF1m42t5FgQiDm4RMOtxFL3wlMYl3xmFoJnA4+vcyPsbe
         uoLOahUrRmD+8SfL4tJiRcWtnp1mR/LyTkJjWWnrT1A0gtcXsk5Ocar2R9acHI+1lVdI
         OXiywbr9Kxf8Q10Bo2l78rKkq+x1HsTwZ5BiM0MWCj+0t2ZMXfcSmr/9cFjjLPUEwLSj
         gLlg==
X-Gm-Message-State: AOAM530Bs/JZGPAE0JqoMMzkr5y5/riIlzTBIZIHzbGN43LfRSCDg07X
        0x0HBiH3TBrTT4fT6Y9Q2kQ=
X-Google-Smtp-Source: ABdhPJwCTgmFbSM+pq8/hJTMXBidzZ599+lmhk0cJy/BiMqjcUhBC+p/7CP59KIxx+8hfHdMIgaKug==
X-Received: by 2002:a17:90b:4a11:b0:1b9:9685:eea4 with SMTP id kk17-20020a17090b4a1100b001b99685eea4mr3883403pjb.136.1645045382952;
        Wed, 16 Feb 2022 13:03:02 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id c8sm46591222pfv.57.2022.02.16.13.03.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 13:03:02 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Finn Thain <fthain@linux-m68k.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 08/50] scsi: NCR5380: Introduce the NCR5380_cmd_priv() function
Date:   Wed, 16 Feb 2022 13:01:51 -0800
Message-Id: <20220216210233.28774-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220216210233.28774-1-bvanassche@acm.org>
References: <20220216210233.28774-1-bvanassche@acm.org>
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

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Finn Thain <fthain@telegraphics.com.au>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
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
