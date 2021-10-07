Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 771F5C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:31:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 612C260F4A
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:31:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233992AbhJGUda (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:33:30 -0400
Received: from mail-pf1-f180.google.com ([209.85.210.180]:39926 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242700AbhJGUdT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:33:19 -0400
Received: by mail-pf1-f180.google.com with SMTP id g2so6311455pfc.6
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:31:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DyB+fddyW5gcgcAEXD5s3JCSHTBobhm9JdLXpErbHD4=;
        b=L5xVIqo5RQIHAyyXGoJZEsG66RfJlEo7Juu+UdEJuMB5N93d4bAi1Vp0apzmhza8Rd
         QlfXsL0xtNXH7+/iEk6GD34rY2oGftxsCPrARYlKMF5i1jPnro4ZxiX8BIB7/QBunSbg
         dfrxgt135XU67DzZxDpLDW61vEFo67BG0xCyWH2UxB6oZN7d4rCmNktrAicJjafv6SSf
         hqDBSUQsE2StX8HJafL3ySAaq25OuK0S7SPsy0Rg3LwhnCwRrFmJ2fYCNSXP5h3JOh4o
         5kmmNbHkFSvvrtkBU4/ztRdCvdCFaeM7pBwzoazsz2mMM6CrhyeY1kFbA4XLppmdzEZP
         C0eQ==
X-Gm-Message-State: AOAM532rehwr4WWdK5pQsIlcwxvUh8UFCdPsRTbEIOBHaXs4WjbvCD6E
        BtEDJWj8gOfzefQErU8tdkM=
X-Google-Smtp-Source: ABdhPJw4ddohH2Pnc/FcLOF3OLbfIn5loWLrhim40UC2Lm+SD6q75IxpM4Cwwxa65RjvM/okUMuV2Q==
X-Received: by 2002:a65:5382:: with SMTP id x2mr1380003pgq.176.1633638684846;
        Thu, 07 Oct 2021 13:31:24 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.31.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:31:24 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 66/88] qla4xxx: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:29:01 -0700
Message-Id: <20211007202923.2174984-67-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007202923.2174984-1-bvanassche@acm.org>
References: <20211007202923.2174984-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla4xxx/ql4_os.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index f1ea65c6e5f5..76d0b59a9982 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -4080,7 +4080,7 @@ void qla4xxx_srb_compl(struct kref *ref)
 
 	mempool_free(srb, ha->srb_mempool);
 
-	cmd->scsi_done(cmd);
+	scsi_done(cmd);
 }
 
 /**
@@ -4154,7 +4154,7 @@ static int qla4xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	return SCSI_MLQUEUE_HOST_BUSY;
 
 qc_fail_command:
-	cmd->scsi_done(cmd);
+	scsi_done(cmd);
 
 	return 0;
 }
