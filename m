Return-Path: <SRS0=6jMo=EN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 322E6C5517A
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Nov 2020 10:07:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E116720888
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Nov 2020 10:07:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gZRIvOi0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728178AbgKGKHG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 7 Nov 2020 05:07:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727955AbgKGKHF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Nov 2020 05:07:05 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93F9CC0613CF;
        Sat,  7 Nov 2020 02:07:05 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id f12so675249pjp.4;
        Sat, 07 Nov 2020 02:07:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2nngrMqY6iiNibM4oEPro2US0D5hhIIlMBxKix2qS2w=;
        b=gZRIvOi0dyQvf8miWJW4zOCoxmpyapYFc7h4bxsfvlKWbCYJ1yxH1B/p0BgxETdA7m
         gfhL1Z/DUglTaq8VPPSI3VYXTEGbmu+habRoZDZ6rvfsgI+qMUOuRw6Bnlr2EBOwD8wE
         0F+lqVuNyGu63YR0VP1tf3LYmXcSZENuP68WDCZK4sn4HDAnZbq7X8+17rkprhND92hu
         FnqO5ZdHRk4JDCr8foesU8UUA+j/JHijdo856ZWRgd9kdgKz0LAZnqs2DjXcgy6sn9qo
         zwauR81uAddS8Z/Io5/Ww3KRqXCkXlIWVUtA+3LkVRGOEXGSF9lq/2qAGesNTn2UhoP0
         1EUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2nngrMqY6iiNibM4oEPro2US0D5hhIIlMBxKix2qS2w=;
        b=D+ebLb0XC0YsqRQzcRXFeIu+KJcNa2FGtMOGQQBL6bUwStzYMNN+8bYbTD/GTSqF2A
         VPtVb3hmwz9BxT/O5nLGC/kVTm+oIn/jljnvYH82tVf0cCD5AUMyW4lOnAoagr5TdsIY
         1Ajvs25nduAlE08/jjUcvOZcPswOK5ygkGttSooyCfr0vHX1Bil84VW+nJ/rlycn3phl
         Fc8RtxWp2ARqJELDDPMe/N9H6qLAWD2L9Ah8pmjsRkupOggezm9F7sFm3VglqdgZuT7b
         sJOEUvPRRz+8Pf9RKrp3HPKm0nEnDawzFFqwykTnHdOtg6jZF58MVCSkmVtG0PoKma+M
         JkeA==
X-Gm-Message-State: AOAM530c97f+ivnKYs15QXJV4CtydSejg03Y1VCHG4DkB6oyT0/33NdG
        MXKhtEeicWLe+AS6Wol2pZs=
X-Google-Smtp-Source: ABdhPJz5hXWks237/ce0lNPlv4Qx5Mw1Av0tgs9uuwprW13RplxSVj3H/XziAlJEcPXtUw1biAA8Gg==
X-Received: by 2002:a17:90a:6392:: with SMTP id f18mr3699380pjj.143.1604743625096;
        Sat, 07 Nov 2020 02:07:05 -0800 (PST)
Received: from varodek.localdomain ([223.179.149.110])
        by smtp.gmail.com with ESMTPSA id h16sm5163140pjz.10.2020.11.07.02.07.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 02:07:04 -0800 (PST)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Intel SCU Linux support <intel-linux-scu@intel.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1] scsi: isci: Don't use PCI helper functions
Date:   Sat,  7 Nov 2020 15:34:19 +0530
Message-Id: <20201107100420.149521-1-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PCI helper functions such as pci_enable/disable_device(),
pci_save/restore_state(), pci_set_power_state(), etc. were used by the
legacy framework to perform standard operations related to PCI PM.

This driver is using the generic framework and thus calls for those
functions should be dropped as those tasks are now performed by the PCI
core.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/scsi/isci/init.c | 18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 93bc9019667f..c452849e7bb4 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -715,10 +715,6 @@ static int isci_suspend(struct device *dev)
 		isci_host_deinit(ihost);
 	}
 
-	pci_save_state(pdev);
-	pci_disable_device(pdev);
-	pci_set_power_state(pdev, PCI_D3hot);
-
 	return 0;
 }
 
@@ -726,19 +722,7 @@ static int isci_resume(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct isci_host *ihost;
-	int rc, i;
-
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
-
-	rc = pcim_enable_device(pdev);
-	if (rc) {
-		dev_err(&pdev->dev,
-			"enabling device failure after resume(%d)\n", rc);
-		return rc;
-	}
-
-	pci_set_master(pdev);
+	int i;
 
 	for_each_isci_host(i, ihost, pdev) {
 		sas_prep_resume_ha(&ihost->sas_ha);
-- 
2.28.0

