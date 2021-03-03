Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3AC8C433E6
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:32:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0B4764EEC
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:32:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377056AbhCDAcm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:32:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233931AbhCCOw2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 09:52:28 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71AF8C0610D0
        for <linux-scsi@vger.kernel.org>; Wed,  3 Mar 2021 06:47:44 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id u16so5970783wrt.1
        for <linux-scsi@vger.kernel.org>; Wed, 03 Mar 2021 06:47:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2TKUb2pogZTiHfW1B3rSfT1K4dqbyioORwhrvyDot2U=;
        b=V76hOPhXM6n5sbOdIqGsjKx734PDA7I8KWpnyU8FWKAug7Pj0Px0y471jB/N6/CdNa
         IsAvwi/zf+gmdb6jKPF4ji88EBd31IVzUDogPcq+evJBZ9OIlIAF4Mnhpzqvz3GCVWAP
         wVqCvtPftp+r1GyofFJ90omac4zmPp61m/OVXH4CWLimoWmxW4ECudMlmaWA8jfTvOK2
         s2yvI7RiCBoHPytDXFFGxht6R8JjnZrW9bpgYICfk6kAvVJzFvDMrZ/FTdRqCiQXNz+N
         V+80wHC1lvIxVpX3S5GO3Q13exKF8VRgKm7FTQoompxV/XiPpKYIlhHztPHBApE+sisl
         P7kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2TKUb2pogZTiHfW1B3rSfT1K4dqbyioORwhrvyDot2U=;
        b=QElSyPXxmXuCDgVQv6E0E4aoRQTWRRmjD4LRP28hfHKYcd0FaPEvD0Y4KlyIH8gh7o
         dFw3rhFx7sepTh04M1xGzh0HvvfOzqJrVTE4AfY69MVPi//bkNI+wqbB2XCzGYA2IR6B
         QOQUtYxpOXORIKEeiteIqqtp/xl7Ad/Fl48rTC0yuuUQCkp2rVXrld+s/Hxd5vYpqVZq
         a8pxr1ya4rHZSqMsBXhM/ceZcBgKpBhBqqFnS6pc3aBJ1brZobgw+3uBPhDpMiu+EEJS
         yMaEeWjzRqsPFzpbJPmhZChI+X4nRbbY2I2xyAuyTIP9FCvhExfRHwLTKzpUUb3Gfj2d
         Z9Tw==
X-Gm-Message-State: AOAM531p5NmB6M0mxvpWOsZqtoDCoguI5+dlFZxtO1ib3KIfMpOLYLso
        5YYqrTQfmaQAPOuoaav+N7tbyw==
X-Google-Smtp-Source: ABdhPJw225riBzew0Mb2AeNkQjzBr+B1EbV2TITo29vZCKSCpEKWuoeRKUETvWTN3PR3CFsBhnMEAg==
X-Received: by 2002:adf:a2c2:: with SMTP id t2mr27330944wra.47.1614782863232;
        Wed, 03 Mar 2021 06:47:43 -0800 (PST)
Received: from dell.default ([91.110.221.155])
        by smtp.gmail.com with ESMTPSA id a14sm36567233wrg.84.2021.03.03.06.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 06:47:42 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 25/30] scsi: lpfc: lpfc_ct: Fix formatting and misspelling issues
Date:   Wed,  3 Mar 2021 14:46:26 +0000
Message-Id: <20210303144631.3175331-26-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210303144631.3175331-1-lee.jones@linaro.org>
References: <20210303144631.3175331-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/lpfc/lpfc_ct.c:153: warning: Function parameter or member 'ct_req' not described in 'lpfc_ct_reject_event'
 drivers/scsi/lpfc/lpfc_ct.c:153: warning: Function parameter or member 'rx_id' not described in 'lpfc_ct_reject_event'
 drivers/scsi/lpfc/lpfc_ct.c:153: warning: Function parameter or member 'ox_id' not described in 'lpfc_ct_reject_event'
 drivers/scsi/lpfc/lpfc_ct.c:283: warning: Function parameter or member 'ctiocbq' not described in 'lpfc_ct_handle_mibreq'
 drivers/scsi/lpfc/lpfc_ct.c:283: warning: Excess function parameter 'ctiocb' description in 'lpfc_ct_handle_mibreq'

Cc: James Smart <james.smart@broadcom.com>
Cc: Dick Kennedy <dick.kennedy@broadcom.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/lpfc/lpfc_ct.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index dd0b432f7ac5a..37b0c20249988 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -137,11 +137,11 @@ lpfc_ct_unsol_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 }
 
 /**
- * lpfc_ct_reject_event : Issue reject for unhandled CT MIB commands
- * @ndlp : pointer to a node-list data structure.
- * ct_req : pointer to the CT request data structure.
- * rx_id : rx_id of the received UNSOL CT command
- * ox_id : ox_id of the UNSOL CT command
+ * lpfc_ct_reject_event - Issue reject for unhandled CT MIB commands
+ * @ndlp: pointer to a node-list data structure.
+ * @ct_req: pointer to the CT request data structure.
+ * @rx_id: rx_id of the received UNSOL CT command
+ * @ox_id: ox_id of the UNSOL CT command
  *
  * This routine is invoked by the lpfc_ct_handle_mibreq routine for sending
  * a reject response. Reject response is sent for the unhandled commands.
@@ -272,7 +272,7 @@ lpfc_ct_reject_event(struct lpfc_nodelist *ndlp,
 /**
  * lpfc_ct_handle_mibreq - Process an unsolicited CT MIB request data buffer
  * @phba: pointer to lpfc hba data structure.
- * @ctiocb: pointer to lpfc CT command iocb data structure.
+ * @ctiocbq: pointer to lpfc CT command iocb data structure.
  *
  * This routine is used for processing the IOCB associated with a unsolicited
  * CT MIB request. It first determines whether there is an existing ndlp that
-- 
2.27.0

