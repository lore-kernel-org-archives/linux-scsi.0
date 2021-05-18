Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D48E8C43461
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE4F0611AC
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:45:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351249AbhERRqn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:46:43 -0400
Received: from mail-pj1-f51.google.com ([209.85.216.51]:37691 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351255AbhERRqk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:46:40 -0400
Received: by mail-pj1-f51.google.com with SMTP id gb21-20020a17090b0615b029015d1a863a91so1981999pjb.2
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:45:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E1UO5vrCstw9gxZuwcmCZCPBjeDEolIQTXzW+jrfs58=;
        b=uhztsZMENKYTxAjr4KobRon7P5v7tb5BzBxMm1gIHFmTYKz6vSfrdRN5o2dsQQqmbA
         5fE2expPU8AFTWzA5YUlWPfVWNR7kLDYKw6MrekIrp2CPjfmCypF2XtAqvDes5JBGAbq
         PUmIu4j8vpFcaRSOTqs+FYjJy6g3/Tx616T2O8nf9nZUwJoLIElzc/0ifeuR9e1ghNcG
         41eXG9M/h1wn7oKUac7fQa4nHv/xqL8Yyh1IxoCry8Vo1mT01u9GhKLXCE5hvfcVScJE
         IAn+X2iZVFIbLu4mLsNyza5dNWXdOwrQCX2jWAaSDKW/5d2GTZw/OPPdUbKbI9bruip9
         Zuvg==
X-Gm-Message-State: AOAM530VG8S0J9MKnbMqLeFA9p77moIi0WEMD2EkcRiGXdN6okHBgv8h
        tJyoJbk1mP296ijRnvpQLCo=
X-Google-Smtp-Source: ABdhPJyclKbNxXbMaONsMeKEul0FrKe5Qk/y59b91oaliRAEYr//UbhMolZIWesNSk+CV1sbg8+77g==
X-Received: by 2002:a17:902:8e88:b029:ee:b947:d7df with SMTP id bg8-20020a1709028e88b02900eeb947d7dfmr5869294plb.48.1621359922393;
        Tue, 18 May 2021 10:45:22 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id z27sm12656920pfr.46.2021.05.18.10.45.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:45:22 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 22/50] ibmvfc: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Tue, 18 May 2021 10:44:22 -0700
Message-Id: <20210518174450.20664-23-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210518174450.20664-1-bvanassche@acm.org>
References: <20210518174450.20664-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index a251dbf630cc..9067ce1611d3 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1910,7 +1910,7 @@ static int ibmvfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 	struct ibmvfc_cmd *vfc_cmd;
 	struct ibmvfc_fcp_cmd_iu *iu;
 	struct ibmvfc_event *evt;
-	u32 tag_and_hwq = blk_mq_unique_tag(cmnd->request);
+	u32 tag_and_hwq = blk_mq_unique_tag(scsi_cmd_to_rq(cmnd));
 	u16 hwq = blk_mq_unique_tag_to_hwq(tag_and_hwq);
 	u16 scsi_channel;
 	int rc;
