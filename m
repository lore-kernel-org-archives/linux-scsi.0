Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A93AAC11F67
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 18:44:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93C7D61CCC
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 18:44:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232614AbhGGSqn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jul 2021 14:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231755AbhGGSql (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jul 2021 14:46:41 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34FA2C06175F
        for <linux-scsi@vger.kernel.org>; Wed,  7 Jul 2021 11:44:01 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id f20so3058673pfa.1
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jul 2021 11:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eVVRgO9DeBF+eScGT7dgkxmiF2ifh9NrcFNE73jGyQg=;
        b=BwhQe63LJhUI0EhEzB8NQ/qUNNxfvDICXP1LyCe4Va+oUXhWsUunGxuqu1t3dWxsJe
         ur6IYCizSQViw3ikzLYzv/0x/a0eYMoNvjF48N68oj9VN4t2NZaIXlaUZFDEpTRO7Je0
         RlGATrqbzvEHBLDhkWmwsEWc+ZJUUsvMZDFR9Mgkf2Odq4fznvrZOz/KjvXfBh1wXeaE
         2h/HUpHIbfGwA8jE3aklc0w881QI9HffM4gkfXpV//DaHCyNy0Q5aGEqA0/8PYxo8KAY
         suKDi+NdoIXEJdZ1OgiOsmrM/hGeP8JZezhaYfYproJeS4gt+1ksTtwhTBfl3MqvnevB
         jvjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eVVRgO9DeBF+eScGT7dgkxmiF2ifh9NrcFNE73jGyQg=;
        b=uR7EaIxI3aGMilpSmHn+AloO5zFFTPAZke9i0pXHjac5nsbftFLsL5yDTTbpUlzXiz
         qMiAx1JtR2hw0MhtmJ/AAENC855xe+ofhPYqtHw9LbtrRwYFNpCDSleOo+qlOw6r2Xbo
         cSHGss1JSv//bioYdLKY3fttM4wrFcbJtwzk1zUkJ86LHjAWjuOpg8XbQFfQeIbrQGBj
         iX6wQnRpMzLaNfp2InZ1vcnCL3u4BqT7yGpnSQ6zXC0MAJoq0LbqrGA8CExopwwAXSKn
         lRohKLmnIGnTYtdsdeBcYPyg6QEusuqKGMF1V5DwAXEuJfLj0Kjh94YoHE7JWQbUppSj
         dDyA==
X-Gm-Message-State: AOAM533HsguvLBwkZK2VHDEl0K95tI5xIa9Xj2g6st5WuKW2lslRmFNn
        c82Z2ojNyquheP+lZKnLcv7zhM8gBqw=
X-Google-Smtp-Source: ABdhPJy7eEfrIVoVtRFQCp4gFsgIwiZlP2gLkZO+G42aa5YhnCGc05KZ+DquaLz8oKGdKDl5kd8fEg==
X-Received: by 2002:a65:4949:: with SMTP id q9mr26835408pgs.327.1625683440750;
        Wed, 07 Jul 2021 11:44:00 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id z3sm23578631pgl.77.2021.07.07.11.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 11:44:00 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 08/20] lpfc: Fix null ptr dereference with NPIV ports for RDF handling
Date:   Wed,  7 Jul 2021 11:43:39 -0700
Message-Id: <20210707184351.67872-9-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210707184351.67872-1-jsmart2021@gmail.com>
References: <20210707184351.67872-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

RDF ELS handling for NPIV ports may result in an incorrect ndlp
reference count.  In the event of a persistent link down, this may lead
to premature release of an ndlp structure and subsequent null ptr
dereference panic.

Remove extraneous lpfc_nlp_put() call in NPIV port RDF processing.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index b0c443a0cf92..b1ca6f8e5970 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3413,7 +3413,6 @@ lpfc_issue_els_scr(struct lpfc_vport *vport, uint8_t retry)
 		return 1;
 	}
 
-	/* Keep the ndlp just in case RDF is being sent */
 	return 0;
 }
 
@@ -3657,11 +3656,9 @@ lpfc_issue_els_rdf(struct lpfc_vport *vport, uint8_t retry)
 		lpfc_enqueue_node(vport, ndlp);
 	}
 
-	/* RDF ELS is not required on an NPIV VN_Port.  */
-	if (vport->port_type == LPFC_NPIV_PORT) {
-		lpfc_nlp_put(ndlp);
+	/* RDF ELS is not required on an NPIV VN_Port. */
+	if (vport->port_type == LPFC_NPIV_PORT)
 		return -EACCES;
-	}
 
 	elsiocb = lpfc_prep_els_iocb(vport, 1, cmdsize, retry, ndlp,
 				     ndlp->nlp_DID, ELS_CMD_RDF);
-- 
2.26.2

