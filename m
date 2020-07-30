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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5E7FC433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 07:04:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 965622074B
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 07:04:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aOQQzFOu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728865AbgG3HE2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jul 2020 03:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbgG3HE2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jul 2020 03:04:28 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00CBBC061794;
        Thu, 30 Jul 2020 00:04:28 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id e4so165165pjd.0;
        Thu, 30 Jul 2020 00:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mXvBexhmXWwdwGXIqWzN36mFt5YrbAZ23OVzzeYCCbA=;
        b=aOQQzFOuBQkutQhTqQ79Iwu1RXheX6ZuqcsJnCS6vrOmPX6PvVXjrXQjbMDwoq72ne
         4SfmjEmptCIN4Oqw5zySWPOZKQn5URCC7rKBT+ACNAFoJvU/MaM2x9htHBXq+paDpgmh
         i72IfYp2rUw103zaUOo9bQDrtRQP1MN4yb+vs3frRlGbAt7LYnyQ3p0a/bO1UOinYXv2
         9KB0kY5im8yWPevyvfN2Yf6xpJ6RJJgplZOIsSo0wPJBa7Ck0dEmAmMY8JqK88iSiwgQ
         GeLDzGdwok/4shoHl5jjwS/EiE0PjutDl3KX9MsoAHHR7f+qN+3yp8t6Hd92eV0DC3Ws
         pkBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mXvBexhmXWwdwGXIqWzN36mFt5YrbAZ23OVzzeYCCbA=;
        b=nvQsep4ks91ZdlFaTZM+WUf/xD9N6QHloUQErqT68aVRvS0rVTQTWBw5LHWFYO9yag
         DKX897FqdthCk0HDoTpX2Y/M9rCZ5ku/TII6MPN0crKMGiD5Hj+qKNuEoVX8RAfleIgN
         FfCeixebmdLnV1/kPKpcaZ5qqRGkrrsDVYdXdEatSOgu3II5EBdht1klxXc5+BczZEFF
         IRUBV7ak0TqOGWLD4qbM6l+jo8EYjc8tCueISmgFLFksHO6qiyCVBhLRsUkByMJg89zy
         CXVDLrJA3nsKDgejMaOSkSt6iRXjgTXyekrB+c0eRJHIZqFyxWbkbfyM54Q0Aa4crNUG
         U1OA==
X-Gm-Message-State: AOAM531f/kIVVMVeqCY6mjmKo0gIKWct2ijF3jmJdR6AysvQgPpMORBh
        dXImGyqU5jDcgj1wiKDGTrk=
X-Google-Smtp-Source: ABdhPJxPsl1UWzGA/JG6VYkYQ955TOzxmbZLj5555QtTnN9rXz+bnwHX2xxFKfHIZyqcNLl2R39P8Q==
X-Received: by 2002:a17:90a:ef17:: with SMTP id k23mr1635169pjz.45.1596092667438;
        Thu, 30 Jul 2020 00:04:27 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.152.86])
        by smtp.gmail.com with ESMTPSA id s89sm4327476pjj.28.2020.07.30.00.04.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2020 00:04:26 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        Don Brace <don.brace@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH v1] scsi: smartpqi: use generic power management
Date:   Thu, 30 Jul 2020 12:32:33 +0530
Message-Id: <20200730070233.221488-1-vaibhavgupta40@gmail.com>
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
 drivers/scsi/smartpqi/smartpqi_init.c | 42 ++++++++++++++++++---------
 1 file changed, 29 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index cd157f11eb22..dc8567236a23 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -8059,11 +8059,11 @@ static void pqi_process_module_params(void)
 	pqi_process_lockup_action_param();
 }
 
-static __maybe_unused int pqi_suspend(struct pci_dev *pci_dev, pm_message_t state)
+static __maybe_unused int pqi_suspend_late(struct device *dev, pm_message_t state)
 {
 	struct pqi_ctrl_info *ctrl_info;
 
-	ctrl_info = pci_get_drvdata(pci_dev);
+	ctrl_info = dev_get_drvdata(dev);
 
 	pqi_disable_events(ctrl_info);
 	pqi_cancel_update_time_worker(ctrl_info);
@@ -8081,20 +8081,33 @@ static __maybe_unused int pqi_suspend(struct pci_dev *pci_dev, pm_message_t stat
 	if (state.event == PM_EVENT_FREEZE)
 		return 0;
 
-	pci_save_state(pci_dev);
-	pci_set_power_state(pci_dev, pci_choose_state(pci_dev, state));
-
 	ctrl_info->controller_online = false;
 	ctrl_info->pqi_mode_enabled = false;
 
 	return 0;
 }
 
-static __maybe_unused int pqi_resume(struct pci_dev *pci_dev)
+static __maybe_unused int pqi_suspend(struct device *dev)
+{
+	return pqi_suspend_late(dev, PMSG_SUSPEND);
+}
+
+static __maybe_unused int pqi_hibernate(struct device *dev)
+{
+	return pqi_suspend_late(dev, PMSG_HIBERNATE);
+}
+
+static __maybe_unused int pqi_freeze(struct device *dev)
+{
+	return pqi_suspend_late(dev, PMSG_FREEZE);
+}
+
+static __maybe_unused int pqi_resume(struct device *dev)
 {
 	int rc;
 	struct pqi_ctrl_info *ctrl_info;
 
+	struct pci_dev *pci_dev = to_pci_dev(dev);
 	ctrl_info = pci_get_drvdata(pci_dev);
 
 	if (pci_dev->current_state != PCI_D0) {
@@ -8115,9 +8128,6 @@ static __maybe_unused int pqi_resume(struct pci_dev *pci_dev)
 		return 0;
 	}
 
-	pci_set_power_state(pci_dev, PCI_D0);
-	pci_restore_state(pci_dev);
-
 	return pqi_ctrl_init_resume(ctrl_info);
 }
 
@@ -8480,16 +8490,22 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 
 MODULE_DEVICE_TABLE(pci, pqi_pci_id_table);
 
+static const struct dev_pm_ops pqi_pm_ops = {
+	.suspend = pqi_suspend,
+	.resume = pqi_resume,
+	.freeze = pqi_freeze,
+	.thaw = pqi_resume,
+	.poweroff = pqi_hibernate,
+	.restore = pqi_resume,
+};
+
 static struct pci_driver pqi_pci_driver = {
 	.name = DRIVER_NAME_SHORT,
 	.id_table = pqi_pci_id_table,
 	.probe = pqi_pci_probe,
 	.remove = pqi_pci_remove,
 	.shutdown = pqi_shutdown,
-#if defined(CONFIG_PM)
-	.suspend = pqi_suspend,
-	.resume = pqi_resume,
-#endif
+	.driver.pm = &pqi_pm_ops
 };
 
 static int __init pqi_init(void)
-- 
2.27.0

