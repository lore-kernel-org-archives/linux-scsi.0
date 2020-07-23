Return-Path: <SRS0=JunS=BC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA8D8C43458
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:25:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C364E2080D
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:25:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XMCdyQhV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729103AbgGWMZf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jul 2020 08:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729089AbgGWMZe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jul 2020 08:25:34 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C50FAC0619E2
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:33 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id z15so4956890wrl.8
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hLMOaM8iSqxASAI/AKDkn1rxF+S99dQlJ1Nf6t4G/bk=;
        b=XMCdyQhVFCi6/Umqy2BL5lvg3KZdsLZixNAGmFwN77HHlwBykzCjGpwPy9ESSXjVuT
         iTJxfXek7AOOcDSQn/MxjqdDCN4iacAy6i1ZwD/pWFX+hhVIygaZuE4aWYF7CsbwkvKT
         ifPsFUAb9HUS61VFI4qIeXx4LOCDA5cx9LiGC2TM+CX2yRjuYZTMaxQAInXAE/3XwngA
         H3yzgwUb0Zft8+3t0WskpYaGqxpVCt8eaSYKJrU29sVGAfdkn1huj4aGdp4QWuCuoxa3
         nNz7wBE3E79WtUZ63p1ja7Ip2nOXuEwXc+pNnqL/reGlksaJ4pf1w/zOWIzb7n4QOEi1
         8mmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hLMOaM8iSqxASAI/AKDkn1rxF+S99dQlJ1Nf6t4G/bk=;
        b=pDqyU7Lpp454H917eJJz5dksuF+ZxUvYYwZAvwGl1VVfr520HxtPBQvVor9+xdNddg
         Dkk8tPnZmNzlqSo2/sp920Egts9onnEeVWqX6r/7PlER/VNjlv2Fct3RYqmzn8xsoQC+
         QXEDLH/xhHnZvDMarZWjwOuZoUuGH8s4KTdJOj2k9GAQwbz2UHMubciEjqJ0/5NUTRgy
         sRoUbwmC6fLn1KDzSOkF3NE3lcoCGb06kXgfY8TOW3JiRqJ8XZ6hHMDBgOz7BoHtNEZO
         7mt63BrC4aeBwHDrWAMvSP2gXRWviMajWphpP6e9Y6z+NAS+1iBCcB0Fdmpe1ZsKxOCj
         FhlQ==
X-Gm-Message-State: AOAM532GPvkdVGwpyZcLWw1zR6aFGbRd0kAC9JX44y5VqnMmYeS60Qvf
        3EKnAJhJwTMvk1+Z4R5sey8N1g==
X-Google-Smtp-Source: ABdhPJwrD6HEwKn697niOMA41eFD1GShOngUDeMgSw8bSj35wuHIB+IqpnbyrtRx58qcvunvIeLsOA==
X-Received: by 2002:a5d:6a4a:: with SMTP id t10mr4105420wrw.360.1595507132577;
        Thu, 23 Jul 2020 05:25:32 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.73])
        by smtp.gmail.com with ESMTPSA id j5sm3510651wma.45.2020.07.23.05.25.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 05:25:31 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Subject: [PATCH 35/40] scsi: bfa: bfa_svc: Demote seemingly unintentional kerneldoc header
Date:   Thu, 23 Jul 2020 13:24:41 +0100
Message-Id: <20200723122446.1329773-36-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200723122446.1329773-1-lee.jones@linaro.org>
References: <20200723122446.1329773-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is the only use of kerneldoc in the source file and no
descriptions are provided.

Also demote standard comment.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/bfa/bfa_svc.c:3847: warning: Function parameter or member 'bfa' not described in 'bfa_fcport_get_cfg_topology'

Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
Cc: Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/bfa/bfa_svc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
index 0b7d2e8f4a669..1e266c1ef7938 100644
--- a/drivers/scsi/bfa/bfa_svc.c
+++ b/drivers/scsi/bfa/bfa_svc.c
@@ -2718,7 +2718,7 @@ bfa_fcport_sm_ddport(struct bfa_fcport_s *fcport,
 	case BFA_FCPORT_SM_DPORTDISABLE:
 	case BFA_FCPORT_SM_ENABLE:
 	case BFA_FCPORT_SM_START:
-		/**
+		/*
 		 * Ignore event for a port that is ddport
 		 */
 		break;
@@ -3839,7 +3839,7 @@ bfa_fcport_get_topology(struct bfa_s *bfa)
 	return fcport->topology;
 }
 
-/**
+/*
  * Get config topology.
  */
 enum bfa_port_topology
-- 
2.25.1

