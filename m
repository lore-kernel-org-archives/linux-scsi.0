Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C895DC433E9
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 17:25:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9063865227
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 17:25:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234811AbhCARYa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 12:24:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236538AbhCARU3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 12:20:29 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3AF2C0617AA
        for <linux-scsi@vger.kernel.org>; Mon,  1 Mar 2021 09:18:31 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id b15so11724007pjb.0
        for <linux-scsi@vger.kernel.org>; Mon, 01 Mar 2021 09:18:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GZL1LkwD18z6aGBFteC5gfoTijG8gZJiJAt/JaELU8k=;
        b=JKtqing1w4RaTeW7Sq5Ocbb7ciwcddc1p+0pPno/Fa87AyU3PTJSNmlSC1fG9puNn3
         14NDSOVZA8K88FJ2wOgD5sCg+wy1GbOMtrOB3ZYj3S3QPqzndIv8KXQEc/x6fyYwm4E5
         LzfX9q7oLK5bLaUTQOc2nrY7belg086+Kr4BAL+U476oOlOodfv9R5ign4CHd/Ie5tS3
         UKxRQg+M9S4rmSvsavEwE88BuyDtilQIP9tJe+vxloIEymlj1hLGdeB07rfw/nqSmVk6
         jNWu07LvL1J630JKibqMkf3evLcAA57wne5qrYwgW6j9G808pNRL8y2z9yhur62U1JaF
         vH7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GZL1LkwD18z6aGBFteC5gfoTijG8gZJiJAt/JaELU8k=;
        b=NuahrAJIhp9RG2Yl5rpvKhD0Ze8qC6uZHDnzz8Q87MKLRo9aheWR8TZ1gVNs24TTmv
         4WBoRsnSJnLqmGGEdDmdN3zBlU79QhpsP/tkYwMzxy1wctdn4UVOmaRBK1wbnhMOlMvz
         fodcUaBPxHoQdzI5vyNzFKDzav2f4J9U3XHrUZBm/wriVoCUudcTueObpLR4rV1XZF49
         XgTwmLjjM1a+/alfA+Vkq+K0EawG3WN7btsx1DLD45NwsIjyBjJ9rDMsj8moV0b8Szsj
         IggFNtLNqfPIRzG5V3BO7MusP9uCgK196D2U9OwsB5BI67QURqWS/Cov1dl/A8tFn1Uh
         Nx5A==
X-Gm-Message-State: AOAM530hTTFvqUQdv2Mq8h80cH6AL3N8Iw2aFSOB2NqB06yqPfZvepue
        B4eTULW0mS05SFWo39f5gc22UT2BHCA=
X-Google-Smtp-Source: ABdhPJyoXr8F2aIRIN1jYbNw+4oroON13t9R7uNy/JnvpA8p2EolbyMK4CPlF/2Yam3p+CSVPkbldw==
X-Received: by 2002:a17:90b:804:: with SMTP id bk4mr7275522pjb.25.1614619111259;
        Mon, 01 Mar 2021 09:18:31 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t19sm10133602pgj.8.2021.03.01.09.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 09:18:30 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH v2 07/22] lpfc: Fix pt2pt connection does not recover after LOGO
Date:   Mon,  1 Mar 2021 09:18:06 -0800
Message-Id: <20210301171821.3427-8-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210301171821.3427-1-jsmart2021@gmail.com>
References: <20210301171821.3427-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On a pt2pt setup, between 2 initiators, if one side issues a a LOGO, there
is no relogin attempt. The FC specs are grey in this area on which port
(higher wwn or not) is to re-login.

As there is no spec guidance, unconditionally re-PLOGI after the logout to
ensure a login is re-established.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 135d8e8a42ba..4918423960d6 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -913,9 +913,14 @@ lpfc_rcv_logo(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		}
 	} else if ((!(ndlp->nlp_type & NLP_FABRIC) &&
 		((ndlp->nlp_type & NLP_FCP_TARGET) ||
-		!(ndlp->nlp_type & NLP_FCP_INITIATOR))) ||
+		(ndlp->nlp_type & NLP_NVME_TARGET) ||
+		(vport->fc_flag & FC_PT2PT))) ||
 		(ndlp->nlp_state == NLP_STE_ADISC_ISSUE)) {
-		/* Only try to re-login if this is NOT a Fabric Node */
+		/* Only try to re-login if this is NOT a Fabric Node
+		 * AND the remote NPORT is a FCP/NVME Target or we
+		 * are in pt2pt mode. NLP_STE_ADISC_ISSUE is a special
+		 * case for LOGO as a response to ADISC behavior.
+		 */
 		mod_timer(&ndlp->nlp_delayfunc,
 			  jiffies + msecs_to_jiffies(1000 * 1));
 		spin_lock_irq(&ndlp->lock);
-- 
2.26.2

