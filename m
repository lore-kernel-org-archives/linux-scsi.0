Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3D4CEB64DD
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Jul 2023 17:53:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232677AbjGLRxv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Jul 2023 13:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232671AbjGLRxk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2023 13:53:40 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BC921FED
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 10:53:39 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1b3ecb17721so11166485ad.0
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 10:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689184419; x=1691776419;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9YyVfSu6+Kp5KIFRXj1gcMRMVFnmqTkhSHu02gqVfvo=;
        b=sdLcRtk5hJyH8YmFM5H+jd/378gh7DwhL4uFPGW3eDyJyZirq13Sq9Mdb2NapqN8Kn
         RQVvEBqhhtSh+/vp+j5QQjT+cw0xjgSfnsWIwQHuuhUCYVtkDJN2T1KgAqdY6XUxpJe/
         6MRViqFEViy0/cQFOMLpqP4KZ6lY9wVIBzoW4pKU4dsZMu1t+0p7EanCL2XIPg8nnzXm
         1UVdEfnkTh7mCrTjbhv2gItfrI5eyEY18DAuDcbL222UDYqGuTD51gMTOlsGvV8vuJ4P
         lRRobB25mVImwDYYPRq/OSZIbm9wiKols2txFikEmQmkPJuFaZf1giW2JDb7ov3ZB/34
         +3dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689184419; x=1691776419;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9YyVfSu6+Kp5KIFRXj1gcMRMVFnmqTkhSHu02gqVfvo=;
        b=ayFEsG3Bfabp/g9zAmzqqMmktyWD8qUi+we+j7izcqkwKjmfeehEIfWzx1j+KFDVcS
         PxYb52ViPA5zfstzLJY3rVQpQvaecaDXZRsCC4n4tk8SNF0VnhSQSKNz2MSL5ucJY1Ax
         g+A3u1IsD3spsApYM/X1Vl7WGUGHlKQFQduIOrX9bdut2q5V5Kwg5/EXTbfYclvo2JK7
         EHTkP71ArPnZz9XtPpb2DCyeesX1aQoGtitmQRGKFTBCy0FWza7Li1hbSkLn03caPsRk
         PrKbn5o+9F+rbIezG4+sbskOIf8dJ4PW0yhFbshEMeKZl9SBhnSiBo04TyfOE3Ofiv0Y
         rS6Q==
X-Gm-Message-State: ABy/qLYrxaqPnznS6CZIY2fj0wMsCWAbx1YjOuieGtbuovGPXs2cX5og
        fBDfZPK3F8SPPE8GIXgrg0pC7m2NwnQ=
X-Google-Smtp-Source: APBJJlFgZxXS2c2udczIAlTThQAWeQDnupgNOGzLMPx9iblt08vw6kW2x19RGCAdQz46c+EioUy5vw==
X-Received: by 2002:a17:902:eccc:b0:1b8:5827:8763 with SMTP id a12-20020a170902eccc00b001b858278763mr55792plh.4.1689184418834;
        Wed, 12 Jul 2023 10:53:38 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d11-20020a170902b70b00b001b898595be7sm4218459pls.291.2023.07.12.10.53.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jul 2023 10:53:38 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 04/12] lpfc: Qualify ndlp discovery state when processing RSCN
Date:   Wed, 12 Jul 2023 11:05:14 -0700
Message-Id: <20230712180522.112722-5-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230712180522.112722-1-justintee8345@gmail.com>
References: <20230712180522.112722-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditionalize when to put an ndlp into recovery mode when processing
RSCNs.  As long as an ndlp state is beyond a PLOGI issue and has been
mapped to a transport layer before, the ndlp qualifies to be put into
recovery mode.  Otherwise, treat the ndlp rport normally through the
discovery engine.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 499849b58ee4..b4303254744a 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -5757,8 +5757,11 @@ lpfc_setup_disc_node(struct lpfc_vport *vport, uint32_t did)
 			     (NLP_FCP_TARGET | NLP_NVME_TARGET)))
 				return NULL;
 
-			lpfc_disc_state_machine(vport, ndlp, NULL,
-						NLP_EVT_DEVICE_RECOVERY);
+			if (ndlp->nlp_state > NLP_STE_UNUSED_NODE &&
+			    ndlp->nlp_state < NLP_STE_NPR_NODE) {
+				lpfc_disc_state_machine(vport, ndlp, NULL,
+							NLP_EVT_DEVICE_RECOVERY);
+			}
 
 			spin_lock_irq(&ndlp->lock);
 			ndlp->nlp_flag |= NLP_NPR_2B_DISC;
-- 
2.38.0

