Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D8B6C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:06:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28395613CE
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:06:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347102AbhI2WIb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:08:31 -0400
Received: from mail-pg1-f181.google.com ([209.85.215.181]:40861 "EHLO
        mail-pg1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347094AbhI2WIX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:08:23 -0400
Received: by mail-pg1-f181.google.com with SMTP id h3so4141525pgb.7
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:06:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OB0MRcxmTIO5O4V7zuWDOK2QrnsN1Cd4v/Zvgh2Im/Q=;
        b=Vh8sYjOQOkaLKmPpWsYAhfKinZ7/hliX2CTBAj9LX5H9HD8onamFqZN8XVsCkP/a7l
         OO2e0D7uyvQcgYzu8+Qs4uPJpOHYq8SamPChj2P7NBG3IhtzQs+AK55ntZ00h/8ipVYg
         yPkm2RZS7j/bUqoPuiT75B176UmzWW/fYDbv1cn8Z1h1k6CnzsART5nt3LInuIbjV7O8
         J6uPi/13HQlGY02UYy9Jo9zaHCDwjh7XzRmWUNBut596CTzaibXYmUyZf8wF+EDFCQ05
         UdvTfN5grWBBRHiyfuvxbxkZy7Jj5PlKNHMX7oqGLUEXpiYd9DU9CtRt4XPeK64YMBrm
         vTqA==
X-Gm-Message-State: AOAM5313GxpjU8Oyiw3QxdxWHOY65AmUYgDb5as+M9XrfehMdebYPFDa
        MXzc11nBRwqzfYAeqWLUuUQ=
X-Google-Smtp-Source: ABdhPJzMgWMsjIIwNF+2iYbOh5GSCFX+7oD6gtW9tXDDL1yvFgC7/Q0gcAUE1WQIUVtlT40QvWM29Q==
X-Received: by 2002:a63:490d:: with SMTP id w13mr1907241pga.481.1632953201780;
        Wed, 29 Sep 2021 15:06:41 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.06.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:06:41 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 18/84] advansys: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:04:54 -0700
Message-Id: <20210929220600.3509089-19-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929220600.3509089-1-bvanassche@acm.org>
References: <20210929220600.3509089-1-bvanassche@acm.org>
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
index e341b3372482..9ff8b1009450 100644
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
 
