Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0284C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:11:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 824326109E
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:11:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234207AbhDTAL3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:11:29 -0400
Received: from mail-pj1-f51.google.com ([209.85.216.51]:41494 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233780AbhDTAK7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:10:59 -0400
Received: by mail-pj1-f51.google.com with SMTP id y22-20020a17090a8b16b0290150ae1a6d2bso2542606pjn.0
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:10:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a1mbA4xYoz6KhuSx0c9jJANBu7PZGogQik2iAzb61ZU=;
        b=AB5/Jo43c0rX4XB8njqrn/fWIIusNsaYuDE7f2PXJacV2EtbeGacvmQI3whPLl3C0D
         rE0ulRV7rIZ6by8XOd4PrHEuFA9ToTGvo5lWTygrCiGJYWrlvknX+nbvLPwV2sXSE/bg
         Fhb70ufUsOMmLUZAkRodCYP/5/lgFLTp57m8Ai6/ZyMi+uWQOowth0yFzoXoe4fEqRML
         fV2QqUaMxhlB6Ou/2rxSdrgm4zjgByLouT9uZe1qqdxfAfYzTgYAxB3fT3zQkxPIhCgV
         9fGUB2zAHWs+p5/CvXE+NE1gxN7jFfkCp9X1Fuy2giD/zDkIX0gg8hRfErkBrpNNn89+
         pX6w==
X-Gm-Message-State: AOAM533p9bg3Uz2nf8PIynr8qI7CwiCv8wJDjtJu3li/6TrB2zm/IUPK
        XDZ9gb8BButXWoTLRNjGOLY=
X-Google-Smtp-Source: ABdhPJzdt6Oh5o3THA8TCTbtm+DAFvL4Bm6bCffQe1mVti5kxDn/qsegadm1bRilOAohsj0UNDdcMA==
X-Received: by 2002:a17:90a:1190:: with SMTP id e16mr1821043pja.110.1618877428686;
        Mon, 19 Apr 2021 17:10:28 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.10.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:10:28 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Michael Reed <mdr@sgi.com>
Subject: [PATCH 084/117] qla1280: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:08:12 -0700
Message-Id: <20210420000845.25873-85-bvanassche@acm.org>
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

Cc: Michael Reed <mdr@sgi.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla1280.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 8f35174a1f9a..fbfb67e28038 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -488,7 +488,7 @@ __setup("qla1280=", qla1280_setup);
 #define	CMD_CDBP(Cmnd)		Cmnd->cmnd
 #define	CMD_SNSP(Cmnd)		Cmnd->sense_buffer
 #define	CMD_SNSLEN(Cmnd)	SCSI_SENSE_BUFFERSIZE
-#define	CMD_RESULT(Cmnd)	Cmnd->result
+#define	CMD_RESULT(Cmnd)	Cmnd->status.combined
 #define	CMD_HANDLE(Cmnd)	Cmnd->host_scribble
 #define CMD_REQUEST(Cmnd)	Cmnd->request->cmd
 
