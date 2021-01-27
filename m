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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3FBFC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 22:16:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0C7964D9F
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 22:16:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236641AbhA0WQv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 17:16:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236407AbhA0WQq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jan 2021 17:16:46 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2798CC061756
        for <linux-scsi@vger.kernel.org>; Wed, 27 Jan 2021 14:16:06 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id d13so1920532plg.0
        for <linux-scsi@vger.kernel.org>; Wed, 27 Jan 2021 14:16:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iB7S4L+EMf7bNOInfB++cIXeBTA1Qnnl98MP16gpo6M=;
        b=mBXMkSV6j9nAreJH7Lh8ScwCKWJy4POkIa88QAO2++0rOe4TPzKzubSlyxIlWJtYuz
         hYJ+B3C6c7eHnyljgwO9ao0uEnGD3D9jxQHJ1z/EKQbVp9jamJE7iEv1Df2l6ho8BguV
         X7+KRU1Q2+KNgouxYRTuUMivpHbr61fd9oVSK0S1SVAb6VCcGNRWR+kCxUW0NgYhn/9j
         yMjYBiSCKUW9fnJWlv8J/buhEMn1fFOad2swo7dk9b97vjQ851oLTQxDM84sIfSvdcaZ
         zKsqwSedsp6kV/AWJayv3Dyk07ae1IonSBfR4rFwMgepbSZ/nJavF+ma+u/8dEEqeycl
         gJGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iB7S4L+EMf7bNOInfB++cIXeBTA1Qnnl98MP16gpo6M=;
        b=XIAKczcVMtdZMmpNK3oxr8YfSLigifS27L1X0ntC6guJ3NbXo6a7/dPVOEfHDyk8U4
         /CR/3hD0kiP76h0wgLqy/IInzC9ufX4Xm3lss2bkG6Tw7FHfghOfHmXGIbEvowM/Vz2+
         /QkLbiTisZoLPc0FA+dk1w/Za2/QZjEY1G6TPewCNaKwl7bVvR6RKjxCEUchs70fX3yP
         tO0Vy54W4k3sdOPJTd4yIXiACybXrq42+NAdTT+Y7aaFbQN2u3M0WxUTvZO8Aa0SfglD
         uC6BJoqlJOvuX3P+hFNIl9HqjJNtaqj53Sq2l/fNDpLW9tDMK+eQPnYwCRC5033k64vS
         f3jg==
X-Gm-Message-State: AOAM533hk52phnpjNcRoZ+64gtbp/15cU041JTaETvmOgUslDrGzse6p
        gE1igAgEiCIc5TqIQGiudOJKo0lI62hOAQ==
X-Google-Smtp-Source: ABdhPJzt2R/CIBAhN0vMOkqCEY8oD686SZTZPjLH63Uuunp9x44N2W0Vu56PJsACuygaOv7J4ymW/w==
X-Received: by 2002:a17:90b:1004:: with SMTP id gm4mr7886187pjb.97.1611785765658;
        Wed, 27 Jan 2021 14:16:05 -0800 (PST)
Received: from localhost.localdomain ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id i36sm3657102pgi.81.2021.01.27.14.16.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 14:16:05 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH] lpfc: Fix EEH encountering oops with nvme traffic
Date:   Wed, 27 Jan 2021 14:16:01 -0800
Message-Id: <20210127221601.84878-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In testing, in a configuration with Redfish and native nvme multipath
when an EEH is injected, a kernel oops is being encountered:
(unreliable)
lpfc_nvme_ls_req+0x328/0x720 [lpfc]
__nvme_fc_send_ls_req.constprop.13+0x1d8/0x3d0 [nvme_fc]
nvme_fc_create_association+0x224/0xd10 [nvme_fc]
nvme_fc_reset_ctrl_work+0x110/0x154 [nvme_fc]
process_one_work+0x304/0x5d

the nvme transport is issuing a Disconnect LS request, which the driver
receives and tries to post but the work queue used by the driver is
already being torn down by the eeh.

Fix by validating the validity of the work queue before proceeding with
the LS transmit.

Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 5e990f4c1ca6..4d819e52496a 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -559,6 +559,9 @@ __lpfc_nvme_ls_req(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		return -ENODEV;
 	}
 
+	if (!vport->phba->sli4_hba.nvmels_wq)
+		return -ENOMEM;
+
 	/*
 	 * there are two dma buf in the request, actually there is one and
 	 * the second one is just the start address + cmd size.
-- 
2.26.2

