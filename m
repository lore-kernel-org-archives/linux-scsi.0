Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA22EC6FD1F
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 20:00:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbjCVUAT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 16:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231286AbjCVT7b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 15:59:31 -0400
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54DD99EF6
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:58:09 -0700 (PDT)
Received: by mail-pj1-f52.google.com with SMTP id fy10-20020a17090b020a00b0023b4bcf0727so20265509pjb.0
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:58:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515087;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4kkeJzpxmqlphiL9GOyWXaal4wNiBQHmsKtZJrkE1yg=;
        b=raxL1a1ljfi5IBmPSGZzYWNoh9ueIT6pHbQzApKg8BpuiinT8/1IaQ1KY0qOOrBIw9
         tS7oX4Q812HkSFTi/L0G63z/slAphOz4RH6bq7W8gyZ8k/nndXVtOG+npEGMCM1dNiVl
         TtfVh0lvQZ7ejlrMWy8ga8U4tR8KUY9dPBf2UUo4xZABCbGGb3Dih/75p7PgF0OfQ7Q4
         9XZkQPvrST5ndJboaNp0VCKqnniAwfCG3KkYYzwjeBFYDARSMsND4pLPR9QrCp5GGwAA
         wUGffHf2qEEJmKn0tOtyFzpWLP6DuUk6qs3N1a4qMN629jb2GTjzkHcD7pbmyXiLUdxZ
         YuUw==
X-Gm-Message-State: AO0yUKUeTojrE6jWUrd9DOzR+bwwDy3VycLaFqPmuq2dW+2D8wUxgnrS
        fVQJTvRRLFcIL+NPuqdZJ345jUzgVgcFPw==
X-Google-Smtp-Source: AK7set/hgM5GYowzKHTIp7qpqESRcIhffELFf4g5E32fOfW3vUltpJTN5kbokOgY73AyO6+gG7axIQ==
X-Received: by 2002:a17:90b:38c2:b0:23f:618a:6bed with SMTP id nn2-20020a17090b38c200b0023f618a6bedmr5335461pjb.47.1679515087623;
        Wed, 22 Mar 2023 12:58:07 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.58.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:58:07 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 53/80] scsi: mpi3mr: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:54:48 -0700
Message-Id: <20230322195515.1267197-54-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230322195515.1267197-1-bvanassche@acm.org>
References: <20230322195515.1267197-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 39ebaa8a0fc8..5db412ad9fd8 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -4795,7 +4795,7 @@ static int mpi3mr_qcmd(struct Scsi_Host *shost,
 	return retval;
 }
 
-static struct scsi_host_template mpi3mr_driver_template = {
+static const struct scsi_host_template mpi3mr_driver_template = {
 	.module				= THIS_MODULE,
 	.name				= "MPI3 Storage Controller",
 	.proc_name			= MPI3MR_DRIVER_NAME,
