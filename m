Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA2A4C433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:04:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB58520772
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:04:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WTS0XP84"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729098AbgGHME0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 08:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729043AbgGHMCj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 08:02:39 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 786B6C08E763
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2020 05:02:39 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id 17so2743113wmo.1
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2020 05:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8R5JqiLjYcza4fbV6goyYqcdxR7v8Q2JkVSQFyfGqhI=;
        b=WTS0XP84AmmKQrGU8ziMJ3EGhNUnOurEbGXIkTmbQAGMR/dlruCblCEvvVvGWA3O0k
         MimUKfmmpbWohYE7vF5UIRsPJBDLsf4+VRtZNZOBzkN0vafEWFgpVT0bzbGM2ARDQP9j
         k2gYk3QaC3Vwm4/QfiIwQMXscCbndCduFjGyN2Xfv/a8nLlvohHaafqRerLHrCPZqKwY
         TaLJVAjOlqGYB6OE9H9T9FebrRMhImG9jr4fRCwSF510Yl7lr8+2AElxYOOBELn5CuTQ
         PCnhte0ZuTJh4en1CTY0nf6YBtHNI4mvLnzvWtbQiF6czj5H3Ov8gsqKLxnwI3J+iYKy
         LMDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8R5JqiLjYcza4fbV6goyYqcdxR7v8Q2JkVSQFyfGqhI=;
        b=BCEqacpLNav0G34euivF9O/JYrCN5+s13oE9KDGucdaicvNeIz1DB6dmtUFnZHBLSW
         i3AsJsMObefQ2cy5PcZSepOulY4NlOLPQ0b7qymXh4iT1pV31+MjQDwcrgaPr1yK/nDJ
         kyxvwmgHLU2jjG/0olQHIrxUzhFwBO06vwYbUII/CzjggXoot8LvIQmmmFfzaG9AgGRJ
         fJm7ChxkdDlMcKNNEEt6GKCzNuzE4X4mUd7m41E0hi4YurLP+WxSVcbOcZomojd2dCIz
         ce26yKkm+tdCZ1t5CF9TvI5HARoPBs4H3sDmnvqSLARLjUc21SwNfW4nBbWJcnklXvpv
         vTHw==
X-Gm-Message-State: AOAM530+RUsi85QXlE6PL1fxu1S2k//DKlY/dgy7R4ld8haOtC6Gg832
        7laV8Qq0qdA3UF+RnqnOHIli6UtVnAY=
X-Google-Smtp-Source: ABdhPJzNHZRM3aKgz5exfCRDRHqYWEiH/AAdFnW93fxIFV5+7uoZn9heFMe5b+YngdabAe4i2GsUbQ==
X-Received: by 2002:a1c:28a:: with SMTP id 132mr8926950wmc.109.1594209758143;
        Wed, 08 Jul 2020 05:02:38 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id m62sm3964997wmm.42.2020.07.08.05.02.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 05:02:37 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        QLogic-Storage-Upstream@cavium.com
Subject: [PATCH 09/30] scsi: qedf: qedf_main: Remove set but not checked variable 'tmp'
Date:   Wed,  8 Jul 2020 13:02:00 +0100
Message-Id: <20200708120221.3386672-10-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200708120221.3386672-1-lee.jones@linaro.org>
References: <20200708120221.3386672-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks like the return value of readw() has never been checked.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/qedf/qedf_main.c: In function ‘__qedf_probe’:
 drivers/scsi/qedf/qedf_main.c:3203:6: warning: variable ‘tmp’ set but not used [-Wunused-but-set-variable]

Cc: QLogic-Storage-Upstream@cavium.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/qedf/qedf_main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index a77a74fad6a7e..47fc14f5ed9d7 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3199,7 +3199,6 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	void *task_start, *task_end;
 	struct qed_slowpath_params slowpath_params;
 	struct qed_probe_params qed_params;
-	u16 tmp;
 
 	/*
 	 * When doing error recovery we didn't reap the lport so don't try
@@ -3393,9 +3392,9 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	    "Writing %d to primary and secondary BDQ doorbell registers.\n",
 	    qedf->bdq_prod_idx);
 	writew(qedf->bdq_prod_idx, qedf->bdq_primary_prod);
-	tmp = readw(qedf->bdq_primary_prod);
+	readw(qedf->bdq_primary_prod);
 	writew(qedf->bdq_prod_idx, qedf->bdq_secondary_prod);
-	tmp = readw(qedf->bdq_secondary_prod);
+	readw(qedf->bdq_secondary_prod);
 
 	qed_ops->common->set_power_state(qedf->cdev, PCI_D0);
 
-- 
2.25.1

