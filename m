Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E1EEC433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:29:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7ACDD61175
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:29:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242002AbhJGUbw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:31:52 -0400
Received: from mail-pg1-f169.google.com ([209.85.215.169]:35495 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241222AbhJGUbv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:31:51 -0400
Received: by mail-pg1-f169.google.com with SMTP id e7so929320pgk.2
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:29:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/kY+Mm7p+mWHCVj3DZsZtqFD6IntTSnDQTB/xGVwz90=;
        b=oG29SSnUY7yEHV6kTUT+rTg2epjTonsQ/Q3+yiz4CzVwDLAxIt3iph09RMq89hJUvj
         31J4ioJQyYANnJCL9NRg+5+az1t9yvi6J+y4ncwlAFFENPlMwGl2yU42vcGRffE1Lq5M
         DbJVHMdT0ZnaBkpZkiVH6UfrtBBHd8h0L3X8kLq87QZYDhOsd+LEjNw0dqhLhT22ScVO
         z+8HTGynj9Y8Q/VHgiaAYLWT0ShoVPSi3AN2Uux5pKsx7tCW8ipOEfe5QjTAEUs6Hkpl
         7/GD5Mpct5jRwuS57J2q2pXBGfzn213w3NxtdkDuThNtvp0kPWUsWWeCyKV2LotLz3y3
         TRow==
X-Gm-Message-State: AOAM532A9CG575ujTa5//IY0Ciqtg1vvHhwIfLqkFG+FaYOrmKMPU4sV
        LP/tA8qsAIb2j7FFoHn2zN/+cR75O6M=
X-Google-Smtp-Source: ABdhPJxOM0GQKqHK03xCRIKRZVvzoKyNyb67TVukQfDwKK0/910GKKuOaHhLDI1dHoTSF84bBchtdA==
X-Received: by 2002:a62:dd0a:0:b0:44b:bd85:9387 with SMTP id w10-20020a62dd0a000000b0044bbd859387mr6412072pff.49.1633638597129;
        Thu, 07 Oct 2021 13:29:57 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.29.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:29:56 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 16/88] aacraid: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:11 -0700
Message-Id: <20211007202923.2174984-17-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007202923.2174984-1-bvanassche@acm.org>
References: <20211007202923.2174984-1-bvanassche@acm.org>
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
