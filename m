Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B825C43217
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87E1560E9B
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:30:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242193AbhJGUb4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:31:56 -0400
Received: from mail-pf1-f177.google.com ([209.85.210.177]:45006 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241376AbhJGUby (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:31:54 -0400
Received: by mail-pf1-f177.google.com with SMTP id 145so6280599pfz.11
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:30:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oZWoRgmfz3fLDUnKSNlrRhoBitSJ4DQx02h5l5+QPeo=;
        b=DhCQR3EKADV26BbebqVqUHpJsw/U3WsfoBiBs5W6UzuXGdx6UqSUH3pblVUhooAnWI
         kc5b96g49ls2LGRSmFgZmgPR5SXrGAMExH1zkC02KyKiUqYWf2iprFnzAyuhVDqKkiy9
         rXN6JjmQ39JS4ZWRdoKtb6HLuKEekQ3R+KToIKkXlF/Y4m/hZC+Q9rrnJwk/aYVyZfNN
         apeT6EBmytSyH0NCfBIdBsKVoBCzRBVRNTUg7/sveHV9iDLFPVLez7e1xiOIA2qtyw2x
         Vi6GEpCCGtwUPrdOIA/EGjx5FsBuafWaGpZRhmOl2+gr2oWkW+NpnfUy8tvGKCh7JfwB
         4yRQ==
X-Gm-Message-State: AOAM530CTAz0+WWFT0vIJcLF4mBPTjZBkCR2aVHSfyZgk4KQd+rcs7Nm
        z1Ejgzq78AGbAdwe2FzACxM=
X-Google-Smtp-Source: ABdhPJwGuwkg7ehNGVBIX/E7L/nQ3uJxx7EqQ6id+AMooztxiPeS7VLJhT1Vx4rZyvHhPMjXGEwm+Q==
X-Received: by 2002:a63:2d46:: with SMTP id t67mr1346957pgt.15.1633638599895;
        Thu, 07 Oct 2021 13:29:59 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:29:59 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 18/88] advansys: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:13 -0700
Message-Id: <20211007202923.2174984-19-bvanassche@acm.org>
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
 drivers/scsi/advansys.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 2df2a843a5ff..f2f14fbd5069 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -3592,7 +3592,7 @@ static void asc_scsi_done(struct scsi_cmnd *scp)
 {
 	scsi_dma_unmap(scp);
 	ASC_STATS(scp->device->host, done);
-	scp->scsi_done(scp);
+	scsi_done(scp);
 }
 
 static void AscSetBank(PortAddr iop_base, uchar bank)
@@ -8460,7 +8460,6 @@ advansys_queuecommand_lck(struct scsi_cmnd *scp, void (*done)(struct scsi_cmnd *
 	int asc_res, result = 0;
 
 	ASC_STATS(shost, queuecommand);
-	scp->scsi_done = done;
 
 	asc_res = asc_execute_scsi_cmnd(scp);
 
