Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12721C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:06:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEFA660FC2
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:06:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347087AbhI2WI1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:08:27 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:36853 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347079AbhI2WIU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:08:20 -0400
Received: by mail-pf1-f176.google.com with SMTP id m26so3171094pff.3
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:06:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/kY+Mm7p+mWHCVj3DZsZtqFD6IntTSnDQTB/xGVwz90=;
        b=69s2VKyNCxhoqy/ZI26r2uVGJMF1CM51lSdcTZ8vuQMsN0JbdhbnfndnXpzavX5qgL
         elqFkSGUFNJ+iVLTLngXu+u+22X5vrNRR8rxubuVB+Fy954uhsPnKanoraoDTfQtmsHn
         LBKvXXWkLkHOBQMCQyBLHlYH4uLqEWgxYexsgTbzxzqtfWO8YaTdVzNfndn1yHB8UYqu
         1LpCEXXE7pXmf+1nMtr5FpprGxH1jAK/oLHsupcRUY5m0voo7JQQ0U8TvFv4Lo0v5lR1
         gyf9TFVsEoOerbyTMNWBw1igFkfpIdQ3CrGuIBoqV/7syh3xIC0LPUTn8Dl2z3S2bdDJ
         oWfA==
X-Gm-Message-State: AOAM5332BLd9m10tTZiDudq/8+dyv3sCZNygFJ4TXnmp5ZwQwVYVRgio
        f0hzVwsqrItRNDINmVZUtUo=
X-Google-Smtp-Source: ABdhPJxkUagDwcgKgRV42UpoQJEymP1uau/qVN6SmCM47LV8cRuKIDNnxMOSzZqgeC0bs5l1TxLjQQ==
X-Received: by 2002:a63:cf44:: with SMTP id b4mr1913165pgj.215.1632953199114;
        Wed, 29 Sep 2021 15:06:39 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.06.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:06:38 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 16/84] aacraid: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:04:52 -0700
Message-Id: <20210929220600.3509089-17-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929220600.3509089-1-bvanassche@acm.org>
References: <20210929220600.3509089-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The aacraid driver invokes scmd->scsi_done(scmd) for two types of SCSI
commands:
* SCSI commands initialized by the SCSI mid-layer.
* SCSI commands initialized by aac_probe_container().

The processing sequence for SCSI commands allocated by
aac_probe_container() is as follows:

aac_probe_container()
-> _aac_probe_container(scmd, aac_probe_container_callback1)
  -> scmd->SCp.ptr = aac_probe_container_callback1
  -> aac_fib_send(..., _aac_probe_container1, scmd)
    -> fibptr->callback = _aac_probe_container1
    -> fibptr->callback_data = scmd

fibptr->callback(scmd)
-> _aac_probe_container1(scmd, fibptr)
   [ ... ]
   -> _aac_probe_container2(scmd, fibptr)
     -> Call scmd->SCp.ptr == aac_probe_container_callback1
       -> scmd->device = NULL;

The processing sequence for SCSI commands allocated by the SCSI mid-layer
if _aac_probe_container() is called is as follows:

aac_queuecommand()
-> aac_scsi_cmd()
  -> _aac_probe_container(scmd, aac_probe_container_callback2)
    -> scmd->SCp.ptr = aac_probe_container_callback2
    -> aac_fib_send(..., _aac_probe_container1, scmd)

fibptr->callback(scmd)
-> _aac_probe_container1(scmd, fibptr)
   [ ... ]
   -> _aac_probe_container2(scmd, fibptr)
     -> Call scmd->SCp.ptr == aac_probe_container_callback2

Preserve the existing call sequences by calling scsi_done() for commands
submitted by the mid-layer or aac_probe_container_scsi_done() for commands
submitted by aac_probe_container().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/aacraid/aachba.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 40b86acac17b..59f6b7b2a70a 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -223,6 +223,7 @@ static long aac_build_sghba(struct scsi_cmnd *scsicmd,
 				int sg_max, u64 sg_address);
 static int aac_convert_sgraw2(struct aac_raw_io2 *rio2,
 				int pages, int nseg, int nseg_new);
+static void aac_probe_container_scsi_done(struct scsi_cmnd *scsi_cmnd);
 static int aac_send_srb_fib(struct scsi_cmnd* scsicmd);
 static int aac_send_hba_fib(struct scsi_cmnd *scsicmd);
 #ifdef AAC_DETAILED_STATUS_INFO
@@ -332,7 +333,7 @@ static inline int aac_valid_context(struct scsi_cmnd *scsicmd,
 		struct fib *fibptr) {
 	struct scsi_device *device;
 
-	if (unlikely(!scsicmd || !scsicmd->scsi_done)) {
+	if (unlikely(!scsicmd)) {
 		dprintk((KERN_WARNING "aac_valid_context: scsi command corrupt\n"));
 		aac_fib_complete(fibptr);
 		return 0;
@@ -519,7 +520,13 @@ int aac_get_containers(struct aac_dev *dev)
 
 static void aac_scsi_done(struct scsi_cmnd *scmd)
 {
-	scmd->scsi_done(scmd);
+	if (scmd->device->request_queue) {
+		/* SCSI command has been submitted by the SCSI mid-layer. */
+		scsi_done(scmd);
+	} else {
+		/* SCSI command has been submitted by aac_probe_container(). */
+		aac_probe_container_scsi_done(scmd);
+	}
 }
 
 static void get_container_name_callback(void *context, struct fib * fibptr)
@@ -809,8 +816,8 @@ static void aac_probe_container_scsi_done(struct scsi_cmnd *scsi_cmnd)
 
 int aac_probe_container(struct aac_dev *dev, int cid)
 {
-	struct scsi_cmnd *scsicmd = kmalloc(sizeof(*scsicmd), GFP_KERNEL);
-	struct scsi_device *scsidev = kmalloc(sizeof(*scsidev), GFP_KERNEL);
+	struct scsi_cmnd *scsicmd = kzalloc(sizeof(*scsicmd), GFP_KERNEL);
+	struct scsi_device *scsidev = kzalloc(sizeof(*scsidev), GFP_KERNEL);
 	int status;
 
 	if (!scsicmd || !scsidev) {
@@ -818,7 +825,6 @@ int aac_probe_container(struct aac_dev *dev, int cid)
 		kfree(scsidev);
 		return -ENOMEM;
 	}
-	scsicmd->scsi_done = aac_probe_container_scsi_done;
 
 	scsicmd->device = scsidev;
 	scsidev->sdev_state = 0;
