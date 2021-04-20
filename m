Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1576C43460
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C7B76109E
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233195AbhDTAJv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:09:51 -0400
Received: from mail-pj1-f54.google.com ([209.85.216.54]:46809 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232905AbhDTAJn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:09:43 -0400
Received: by mail-pj1-f54.google.com with SMTP id u14-20020a17090a1f0eb029014e38011b09so14624504pja.5
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:09:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WMFt/Bzpg9Y/PdeyDOLVAMAou8mYJ4Jwx4g5pKqWxBE=;
        b=IicTnXjBI+KepoIvIH+qi7TqqshgNviEDXRf82s1wJ5LaS+6+bFv4f16HykvzbLRFz
         R8uvmF8gSHMI92BRatkLN5NXza1Ko/T392hNQrjVn1JHgEM2FixJG/asy9kX/rgn883z
         eoMC4/AME5EOTdRi1zGPgGDkktd8IJLu77vXmsRdQ9zj6TzKY95xkIhgwNKbBnDf7AIf
         dJTgSgFPXyDgRvF33Tw677e8HtmmS3hAkIQm0j9FTLVTTEmkOQlQGC2914MtTm/4ESr1
         exDRxB8vwagwHTfiHezvfI9ZuEXKiQis3NKNSfuIehD8dgL6EJusuwn+dvtiHjd9HVyO
         /PDQ==
X-Gm-Message-State: AOAM533b0hrDpmz3jNV4qT9JVpL75GRTjkUQLMLzFu9DNDptLTn3TJuT
        XhgX9L6ZNIDU3NzmJXipqR4=
X-Google-Smtp-Source: ABdhPJz9Y25l3WmVhpNgqjdVv83zg74sxJHZpTYuQXqTOB085i9OKzy0gTbjCje7rMpIjw8ilcnyjA==
X-Received: by 2002:a17:902:59d4:b029:ea:bbc5:c775 with SMTP id d20-20020a17090259d4b02900eabbc5c775mr25978431plj.11.1618877353107;
        Mon, 19 Apr 2021 17:09:13 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.09.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:09:12 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Doug Gilbert <dgilbert@interlog.com>
Subject: [PATCH 018/117] sg: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:07:06 -0700
Message-Id: <20210420000845.25873-19-bvanassche@acm.org>
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

Cc: Doug Gilbert <dgilbert@interlog.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sg.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 737cea9d908e..82e79042de7b 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1344,7 +1344,8 @@ sg_rq_end_io(struct request *rq, blk_status_t status)
 	unsigned long iflags;
 	unsigned int ms;
 	char *sense;
-	int result, resid, done = 1;
+	union scsi_status result;
+	int resid, done = 1;
 
 	if (WARN_ON(srp->done != 0))
 		return;
@@ -1358,20 +1359,20 @@ sg_rq_end_io(struct request *rq, blk_status_t status)
 		pr_info("%s: device detaching\n", __func__);
 
 	sense = req->sense;
-	result = req->result;
+	result = req->status;
 	resid = req->resid_len;
 
 	SCSI_LOG_TIMEOUT(4, sg_printk(KERN_INFO, sdp,
 				      "sg_cmd_done: pack_id=%d, res=0x%x\n",
-				      srp->header.pack_id, result));
+				      srp->header.pack_id, result.combined));
 	srp->header.resid = resid;
 	ms = jiffies_to_msecs(jiffies);
 	srp->header.duration = (ms > srp->header.duration) ?
 				(ms - srp->header.duration) : 0;
-	if (0 != result) {
+	if (0 != result.combined) {
 		struct scsi_sense_hdr sshdr;
 
-		srp->header.status = 0xff & result;
+		srp->header.status = 0xff & result.combined;
 		srp->header.masked_status = status_byte(result);
 		srp->header.msg_status = msg_byte(result);
 		srp->header.host_status = host_byte(result);
