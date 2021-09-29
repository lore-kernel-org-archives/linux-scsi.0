Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91E4AC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:08:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CBAF60FC2
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:08:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347217AbhI2WJx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:09:53 -0400
Received: from mail-pg1-f171.google.com ([209.85.215.171]:44651 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347189AbhI2WJr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:09:47 -0400
Received: by mail-pg1-f171.google.com with SMTP id s11so4132166pgr.11
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:08:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZRN510xAfnfRclbm5nziWyGL7z/As9i4hiIKN73Fjx0=;
        b=EFoXBgCztl7oyLtCipah9H7zfmvYxIPiJ/oqS0EbE1kQADnc7T7VPF2mDTyY2hI1vT
         vlWOHr7+EwDx4e72xafeZE6jUetCzMiqQ6WmexEdgteRI26OVzP8p8SMgJ7YUxQMG4pu
         3+mR/EQKJSG3YoCd1bXjCrriY9xneBMlaxR0Gwq5UDV9U/SRNEJ40/+XNWoPnwoiNuSU
         r//O403lFV6oTv0sVZWhDyV+RnAe2GjrC8OhNZ0HY69TOK/vz8NKxlIjBO6bogzm+Kq6
         HP+YWj6K9dkbgEjGbCPdmdIQbntFJsUZtdPVufnrbTmUEK3QBLOkNiUKZFl7krjHo3uB
         qd+g==
X-Gm-Message-State: AOAM533lmqYvwLWqKJ3ItT+A2fRoj5o/IQDP1kQLpCO70EJQeLHr6LxF
        9B1bgqvc3QomlOndAQSU1Vo=
X-Google-Smtp-Source: ABdhPJzODyZYBOaGTF2zgxzci3eS8juoQXLPxZLeCcXI/jI9LJduRzrK7ECQlnTCguJg9cWZaroPkw==
X-Received: by 2002:a63:5608:: with SMTP id k8mr1886929pgb.287.1632953285786;
        Wed, 29 Sep 2021 15:08:05 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.08.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:08:05 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 69/84] smartpqi: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:05:45 -0700
Message-Id: <20210929220600.3509089-70-bvanassche@acm.org>
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
 drivers/scsi/smartpqi/smartpqi_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index ecb2af3f43ca..3b5601c0c537 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -194,7 +194,7 @@ static char *pqi_raid_level_to_string(u8 raid_level)
 static inline void pqi_scsi_done(struct scsi_cmnd *scmd)
 {
 	pqi_prep_for_scsi_done(scmd);
-	scmd->scsi_done(scmd);
+	scsi_done(scmd);
 }
 
 static inline void pqi_disable_write_same(struct scsi_device *sdev)
