Return-Path: <SRS0=dYxQ=BJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7C2CC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 10:18:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A36702083B
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 10:18:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P1090J5l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbgG3KSq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jul 2020 06:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726287AbgG3KSp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jul 2020 06:18:45 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D15FC061794;
        Thu, 30 Jul 2020 03:18:44 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id m16so13644793pls.5;
        Thu, 30 Jul 2020 03:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wfvGgVXPE//hQYiCJ3Y28E2/v0p7YSlsyuVMVmFQhXI=;
        b=P1090J5lZ/jfkYaE5ZKSv1PwN+iPKcSAuV3/SGSLcuTP1BtTfqjBuaHOTWCCt9PyAb
         gqZJGBwC/RUbq8fiAvrXge70fnhp76kNeWXJnus0Zds2LPPusFp/P1Wv14MwcVgQP7OV
         uhRoSZpMQa0gQtWtVCjPWngBfeja1LipkB5cEVyWrmlqlc145r1jP/JeUp6wpoSR1ad9
         V+fzMsM5pZWxFcmAKQ0KSlKgkItZ2evK5XLi51NVZQcu7RdjzxnZY0gH+DhsLu27Gtrz
         KjIJ/6ho83UYIE7Uy0mafzuXLGBwKDv2IHngxTnQWVbflS4NOVxZchYoO55wiYG8iRKX
         J6OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wfvGgVXPE//hQYiCJ3Y28E2/v0p7YSlsyuVMVmFQhXI=;
        b=IafWsnJR3zI/AgGf6/Zhv2mkA/WhKNiTOGZxqvcOc1OxOJKaxJN7WLGBLmnoxv3nON
         LKTSAgWNpS4s+kYqDckm/GH46m66OBCydl3NZu/E1pOi/VCYyiVFZomjozzjjWT2r+uw
         uWW6TOhmEjfwcd/EQGlLnNusfRCGPMsHvpEh/Qe2gkuyUyKjfP+oi7eiR3+X2aibQutK
         HN5QaBSzMyqRLl9SwSXDJYV4uqJYXaTy6WNqDGmM7aahZSswfEs0/P55Zl7F5tcWOfWe
         2IY0HJYKHJVuf9vkx3E8VOAOMRkmtHbwSTbFx9sZPCbiNzAEdHTh57HlYMAnjkro5RVq
         YA5w==
X-Gm-Message-State: AOAM532qJib7tK9LH4CrYY3Cvovz7snu8rP+X8AMxgPPV6XW3cqn27Q3
        uiVcJO/IfFky169hWoIouKU=
X-Google-Smtp-Source: ABdhPJxpg6lp4/yuJVJsGNsNy/UKwch0Tz803qNvlZsB90/Bhx8andlF4XkhRn8gU3mnFkWx0P+i1Q==
X-Received: by 2002:a17:902:8491:: with SMTP id c17mr31587981plo.262.1596104323577;
        Thu, 30 Jul 2020 03:18:43 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.152.86])
        by smtp.gmail.com with ESMTPSA id p5sm5456870pgi.83.2020.07.30.03.18.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2020 03:18:42 -0700 (PDT)
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
Subject: [PATCH v2] scsi: stex: use generic power management
Date:   Thu, 30 Jul 2020 15:46:58 +0530
Message-Id: <20200730101658.576205-1-vaibhavgupta40@gmail.com>
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
 drivers/scsi/stex.c | 37 +++++++++++++++++++++++++++++++------
 1 file changed, 31 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index d4f10c0d813c..5ef6f3cbac11 100644
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
+static int __maybe_unused stex_suspend(struct device *dev)
 {
-	struct st_hba *hba = pci_get_drvdata(pdev);
+	return stex_suspend_late(dev, PMSG_SUSPEND);
+}
+
+static int __maybe_unused stex_hibernate(struct device *dev)
+{
+	return stex_suspend_late(dev, PMSG_HIBERNATE);
+}
+
+static int __maybe_unused stex_freeze(struct device *dev)
+{
+	return stex_suspend_late(dev, PMSG_FREEZE);
+}
+
+static int __maybe_unused stex_resume(struct device *dev)
+{
+	struct st_hba *hba = dev_get_drvdata(dev);
 
 	hba->mu_status = MU_STATE_STARTING;
 	stex_handshake(hba);
@@ -2000,14 +2015,24 @@ static int stex_halt(struct notifier_block *nb, unsigned long event, void *buf)
 }
 MODULE_DEVICE_TABLE(pci, stex_pci_tbl);
 
+static const struct dev_pm_ops stex_pm_ops = {
+#ifdef CONFIG_PM_SLEEP
+	.suspend	= stex_suspend,
+	.resume		= stex_resume,
+	.freeze		= stex_freeze,
+	.thaw		= stex_resume,
+	.poweroff	= stex_hibernate,
+	.restore	= stex_resume,
+#endif
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

