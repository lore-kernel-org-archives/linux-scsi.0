Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B09C9C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:09:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92A4560F48
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:09:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345066AbhIRAKa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:10:30 -0400
Received: from mail-pg1-f172.google.com ([209.85.215.172]:41969 "EHLO
        mail-pg1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345091AbhIRAJc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:09:32 -0400
Received: by mail-pg1-f172.google.com with SMTP id k24so11113801pgh.8
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:08:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZRN510xAfnfRclbm5nziWyGL7z/As9i4hiIKN73Fjx0=;
        b=0qNpRuFDFTkqSzKogR6BuBpon37zX3cUolvGNrVdpVdEFdwkXs03S83RfCp71x9DoW
         GC7oYM7mwz/QmR35JypWC8YKMOh25geE/Hu2WVYysf1cpgkrHd9TLbrljljeWVehhhRb
         DKZushQbt3AWGYRP17GrdPmiNo0NRC41HAkWcJOla7HvSnrVClnmVsoHE2AGoEWgJ7q9
         smKfUmZl+SNZHMx52yXqCj9x7+O7x31XWCF5gY84dYtZS/pcKor5lVKzfz9SelX3bMZ7
         PxrV37uuPH4YTtqu4mA+jqaJeHB7BfbYmLE2CLPPwKEXJbCLfpKtX28/IYhNVoDLTbY/
         QmaA==
X-Gm-Message-State: AOAM530uezH324hPh92qpY1ekk76d9NDDNxSxQW6Ogc467qEjV1CvuWX
        iFBwuMYdhjfmP4DZho+4HCQ=
X-Google-Smtp-Source: ABdhPJzBtqeJ0N/shyM8zPVf567G4Pyqgw4sEZEpTqUSztaZAydpncYi2raxf7ACVgmht96jE/1ciw==
X-Received: by 2002:aa7:9841:0:b0:439:c4cb:fe9a with SMTP id n1-20020aa79841000000b00439c4cbfe9amr13409173pfq.13.1631923689130;
        Fri, 17 Sep 2021 17:08:09 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.08.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:08:08 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 69/84] smartpqi: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:52 -0700
Message-Id: <20210918000607.450448-70-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
In-Reply-To: <20210918000607.450448-1-bvanassche@acm.org>
References: <20210918000607.450448-1-bvanassche@acm.org>
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
