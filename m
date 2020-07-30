Return-Path: <SRS0=dYxQ=BJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C561C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 05:19:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 755922083B
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 05:19:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CNYeSPa5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728640AbgG3FTk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jul 2020 01:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727838AbgG3FTj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jul 2020 01:19:39 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC975C061794;
        Wed, 29 Jul 2020 22:19:39 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id u10so3655203plr.7;
        Wed, 29 Jul 2020 22:19:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EnGXeNbQwuYNZ4/SgA8a2g0/K9Xn2zkd8XxAO1wpPBE=;
        b=CNYeSPa5UHoQU/zAXoMxTvIy8LM9ZnpBrUa+u5uUMyQdzorRKQusWkM0WWRphxi5ru
         p/FmoF5qPGgJNNY0+EDETyed1MxEEDnBRCn9/qFltha0m+8igcWmCh9nFCRh3mRLf5qE
         oXYFuLxMrynBJjPTQ7xkCv/VoWYHHQ2CxG1MYDb+mDbsqpKjABOqr2615HF+D0k0Y0bq
         hwvXDejkhM7UM6Kq06SzRnTtf4aB1nJ4vOVO7tFo3BKYD0PajnvSPrWUBK29IIfPQCAQ
         blSwhF47KNibbIJ0e+vT7gwNsoX4dZds4/os/tKEW05Jbq9BhC9BWwcZUM8GY/o0iiOY
         5Fpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EnGXeNbQwuYNZ4/SgA8a2g0/K9Xn2zkd8XxAO1wpPBE=;
        b=ZpvvJcx1L6B6EVe5tw0dnjBR5DrHJlZZrXLfE7E/t8FhC1ixH4/O4ECQ70BxzuF8z1
         oUCQ6lEitwFG9xR9wFBlenq8V0iVcHCLw5k3sO6uLdj0q16um5Isx6VPHqmh8R2PyTPL
         Jos1Gc//WtjkpbOJaBleR4ROf+YVF2O+OUIulCnNEy4wNn4YNldfaM4c1HyzSm++oc9j
         NeV7/WyJPHlNWdm8cMYQcjyMH2GD1pSsCxj1S7aMc2oqSpG+3N+6dBaYJC7TCM8zNnSV
         w38UOojlPlzFl95beAFYXZJOkmd8R7gGasap+CQ2zsUUrk8e6xS/wC206+xe6PXcDik6
         m2kQ==
X-Gm-Message-State: AOAM5323x6vWTIReWcWarTVeRKGubv1IC3brQBmDrVegkYNqtwI3vmtm
        mYkLh0/8Xr69ATGg6k7hPeY=
X-Google-Smtp-Source: ABdhPJwjUlYjYmMWc8AL8fvrnaAOvzZZqXAtYVN5Q/5zg1fY1zOc8Bo7eLrzwvyLF10mdRA/NCC5WA==
X-Received: by 2002:a17:902:103:: with SMTP id 3mr31556502plb.195.1596086379202;
        Wed, 29 Jul 2020 22:19:39 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.152.86])
        by smtp.gmail.com with ESMTPSA id 9sm4224025pfx.131.2020.07.29.22.19.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2020 22:19:38 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH v1] scsi: stex: use generic power management
Date:   Thu, 30 Jul 2020 10:47:33 +0530
Message-Id: <20200730051733.113652-1-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Drivers using legacy power management .suspen()/.resume() callbacks
have to manage PCI states and device's PM states themselves. They also
need to take care of standard configuration registers.

Switch to generic power management framework using a single
"struct dev_pm_ops" variable to take the unnecessary load from the driver.
This also avoids the need for the driver to directly call most of the PCI
helper functions and device power state control functions, as through
the generic framework PCI Core takes care of the necessary operations,
and drivers are required to do only device-specific jobs.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/scsi/stex.c | 35 +++++++++++++++++++++++++++++------
 1 file changed, 29 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index d4f10c0d813c..9500666b521a 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -1972,9 +1972,9 @@ static int stex_choice_sleep_mic(struct st_hba *hba, pm_message_t state)
 	}
 }
 
-static int stex_suspend(struct pci_dev *pdev, pm_message_t state)
+static int stex_suspend_late(struct device *dev, pm_message_t state)
 {
-	struct st_hba *hba = pci_get_drvdata(pdev);
+	struct st_hba *hba = dev_get_drvdata(dev);
 
 	if ((hba->cardtype == st_yel || hba->cardtype == st_P3)
 		&& hba->supports_pm == 1)
@@ -1984,9 +1984,24 @@ static int stex_suspend(struct pci_dev *pdev, pm_message_t state)
 	return 0;
 }
 
-static int stex_resume(struct pci_dev *pdev)
+static int stex_suspend(struct device *dev)
 {
-	struct st_hba *hba = pci_get_drvdata(pdev);
+	return stex_suspend_late(dev, PMSG_SUSPEND);
+}
+
+static int stex_hibernate(struct device *dev)
+{
+	return stex_suspend_late(dev, PMSG_HIBERNATE);
+}
+
+static int stex_freeze(struct device *dev)
+{
+	return stex_suspend_late(dev, PMSG_FREEZE);
+}
+
+static int stex_resume(struct device *dev)
+{
+	struct st_hba *hba = dev_get_drvdata(dev);
 
 	hba->mu_status = MU_STATE_STARTING;
 	stex_handshake(hba);
@@ -2000,14 +2015,22 @@ static int stex_halt(struct notifier_block *nb, unsigned long event, void *buf)
 }
 MODULE_DEVICE_TABLE(pci, stex_pci_tbl);
 
+static const struct dev_pm_ops stex_pm_ops = {
+	.suspend	= stex_suspend,
+	.resume		= stex_resume,
+	.freeze		= stex_freeze,
+	.thaw		= stex_resume,
+	.poweroff	= stex_hibernate,
+	.restore	= stex_resume,
+};
+
 static struct pci_driver stex_pci_driver = {
 	.name		= DRV_NAME,
 	.id_table	= stex_pci_tbl,
 	.probe		= stex_probe,
 	.remove		= stex_remove,
 	.shutdown	= stex_shutdown,
-	.suspend	= stex_suspend,
-	.resume		= stex_resume,
+	.driver.pm	= &stex_pm_ops,
 };
 
 static int __init stex_init(void)
-- 
2.27.0

