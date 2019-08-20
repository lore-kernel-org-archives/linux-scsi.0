Return-Path: <SRS0=HqgQ=WQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85C5FC3A5A0
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Aug 2019 02:18:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 623D420644
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Aug 2019 02:18:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729053AbfHTCSs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Aug 2019 22:18:48 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:34955 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728800AbfHTCSs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Aug 2019 22:18:48 -0400
Received: by mail-pl1-f196.google.com with SMTP id gn20so1906999plb.2
        for <linux-scsi@vger.kernel.org>; Mon, 19 Aug 2019 19:18:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fiW+42C0L5z/HYcB4IZ5z5dHWTQOaBVp9u7EwRxkaJk=;
        b=Oky/P98Hh+xyYHCrrRbG2oZEqXX3r9xmto7Paz4r9VQThh1+ufS8bk9fnpuhaokh6R
         SVi16CiZX41orjtNweBTg6eRLGrzjd+go4uWbrviCYI7z+UerEHeIlJG857rANRXhaC+
         LmEQ9eIX9K/5GYJSIBXEAQYxcM/CtZh6Gubjd/9xlQ6jAMBsQdRGwYN0l2uTimmG62MK
         E2tJfyERmBuM+dmsS+2XfFO8DOgntDO24SVRvaWV0F9MlCKhrT5TM/qQdQegDctFPIDL
         tbIqI3UuDkc9FQ263uKT/G7jyDhhdQpuSM6jeDztu9w2+2ZM2S3jFCEj6IhPxpR79bU2
         yYfw==
X-Gm-Message-State: APjAAAUp61K27fDC0yJBRFykZf2yy/4Hy45JjQ7xC2kOhF+8Y93nFmuX
        16fe0RW9G6hNN85aWGOszSk=
X-Google-Smtp-Source: APXvYqxnsjGpftBjjHc4GuWiUinHbwbedhUEU4yZLK0T62/f7HvVrCv5M4ZEjdg15npxiTqkSt3llw==
X-Received: by 2002:a17:902:ab8e:: with SMTP id f14mr26146669plr.6.1566267527062;
        Mon, 19 Aug 2019 19:18:47 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:9688:7239:73c8:e524:4c7f])
        by smtp.gmail.com with ESMTPSA id c22sm9035986pfi.82.2019.08.19.19.18.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 19:18:46 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Subject: [PATCH] qla2xxx: Fix a recently introduced kernel warning
Date:   Mon, 19 Aug 2019 19:18:36 -0700
Message-Id: <20190820021836.16401-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

According to the firmware documentation a status type 0 IOCB can be
followed by one or more status continuation type 0 IOCBs. Hence do not
complain if the completion function is not called from inside the status
type 0 IOCB handler.

WARNING: CPU: 10 PID: 425 at drivers/scsi/qla2xxx/qla_isr.c:2784
qla2x00_status_entry.isra.7+0x484/0x17b0 [qla2xxx]
CPU: 10 PID: 425 Comm: kworker/10:1 Tainted: G            E     5.3.0-rc4-next-20190813-autotest-autotest #1
Workqueue: qla2xxx_wq qla25xx_free_rsp_que [qla2xxx]
Call Trace:
 qla2x00_status_entry.isra.7+0x1484/0x17b0 [qla2xxx] (unreliable)
 qla24xx_process_response_queue+0x7d8/0xbd0 [qla2xxx]
 qla25xx_free_rsp_que+0x1a0/0x220 [qla2xxx]
 process_one_work+0x25c/0x520
 worker_thread+0x8c/0x5e0
 kthread+0x154/0x1a0
 ret_from_kernel_thread+0x5c/0x7c

Cc: Himanshu Madhani <hmadhani@marvell.com>
Cc: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Reported-and-tested-by: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_isr.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index cd39ac18c5fd..d81b5ecce24b 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2780,8 +2780,6 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 
 	if (rsp->status_srb == NULL)
 		sp->done(sp, res);
-	else
-		WARN_ON_ONCE(true);
 }
 
 /**
-- 
2.22.0

