Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8612C47082
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CC2C61166
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:09:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232246AbhEXDKw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 23:10:52 -0400
Received: from mail-pl1-f174.google.com ([209.85.214.174]:38544 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232238AbhEXDKt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 23:10:49 -0400
Received: by mail-pl1-f174.google.com with SMTP id 69so13910532plc.5
        for <linux-scsi@vger.kernel.org>; Sun, 23 May 2021 20:09:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bzKvqzuA/WFu9Oar88tH0h8JNjeKZGFwFrdGi+tFRcQ=;
        b=Ra9jPBq+bSfncZx9SUYttxJ0ujhvZwXF6kfQp+1mZJWtBlNnzNtgYpyouXyExi11oY
         c1NUdPVeCCYDDPjaT0T15B0CchnwWNeqAj+LEaBsDkzeq3aJAM5FF1aeCulusYHPEqJ+
         L1U/dYfEiqO0BKAFzW+wByfLzFVlDVvI7FlLAsBJFYQdvMVW4nyKBCie2fa/sIw14diR
         syephU4LYct1fhXMQwstCHqsDjyYJp1fZ2cRvJuBJp6A8jDJwryB3vqlX4FpFyOonbVk
         eFiHm787muvmPPpTPuEWnZNcMybLr0mLzkkiFFpYsdMfJPAOl5RFgX41to+A5jI284Ku
         hL5g==
X-Gm-Message-State: AOAM532P+YMAT5uoqMvshZADsf/WljOk6r+zVuxxW6for/SBhTwENrO2
        OIhJme2L8OxabK84sKXPNIE=
X-Google-Smtp-Source: ABdhPJxTHJs5+YXvKD1nYrFhC157OfU6zv362qEQnt4moEwLm8pWTq4ddEbk0PdQGGt+IyStC3xh3g==
X-Received: by 2002:a17:90a:8902:: with SMTP id u2mr22516976pjn.143.1621825760801;
        Sun, 23 May 2021 20:09:20 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v9sm11131863pjd.26.2021.05.23.20.09.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 20:09:20 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 11/51] 53c700: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Sun, 23 May 2021 20:08:16 -0700
Message-Id: <20210524030856.2824-12-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524030856.2824-1-bvanassche@acm.org>
References: <20210524030856.2824-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/53c700.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index 77ccb96e5ed4..4bff29169f19 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -1823,7 +1823,7 @@ NCR_700_queuecommand_lck(struct scsi_cmnd *SCp, void (*done)(struct scsi_cmnd *)
 
 	if ((hostdata->tag_negotiated & (1<<scmd_id(SCp))) &&
 	    SCp->device->simple_tags) {
-		slot->tag = SCp->request->tag;
+		slot->tag = scsi_cmd_to_rq(SCp)->tag;
 		CDEBUG(KERN_DEBUG, SCp, "sending out tag %d, slot %p\n",
 		       slot->tag, slot);
 	} else {
