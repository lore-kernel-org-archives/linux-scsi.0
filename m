Return-Path: <SRS0=dYxQ=BJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31D20C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 11:11:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D8E02075F
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 11:11:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vVwDjUUI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgG3LLD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jul 2020 07:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726367AbgG3LLC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jul 2020 07:11:02 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D518BC061794;
        Thu, 30 Jul 2020 04:11:02 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id g19so1200690plq.0;
        Thu, 30 Jul 2020 04:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ae96SR23iZeBLSBCoLIaAGm/kTSoCvrW0+UYQgfK9PA=;
        b=vVwDjUUI8QVtGmGOzrkxP9OugoCgdsctYMdsbBmFGJLK1yMhi9zeY5aH3Vy6IEtcqF
         VaqmPddg6vM9AtB69G34lkcF5WbPBB5WJWPLS6PYB6/rIGXgeSavm2/RA+QxzJ5kH26E
         wcd7Dw8pYssor/HcG6JZYfYdBbyua0Zd4fg8flNkOgTXe22Tqqm0Ubdi7F1+iu2m++1i
         KqBhxTzsLNYuokT0vh/X7SeOMlbLflLZ9vl7kl78wwzImunjjjjb/8lrvBvDfGR52kRH
         jvwBrq1JGyAzmMnYruGdOMR4ge8kfTS3k/ZPPwpsA2MQ+w4XLW5JeTj5ieoSrnb5l4YW
         zcRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ae96SR23iZeBLSBCoLIaAGm/kTSoCvrW0+UYQgfK9PA=;
        b=brz8eqvoxBQCZSyaTpVAT93I4eythYtQxsb3V7Ag4L/W141MCX8fJx/38RDy3aAvab
         B8jj4VHT1MroEojdWs2vxvB3yUG71E9CJnDIuf40nhj2TX54kVNk+JqIdOsTP5611FgJ
         VQD6ZG6d4gi23SvqMNmhYHj4vEMy5I3tMW474EAmeOpgu0i7QiORgjV3y+kcKqFcOvDm
         0ooarLNhXZU240JahOipmcC7pxZwx451nTkireXvvX67+ahHZdbCnF9gZcs+b/Tzr+pd
         BTukHFBWVjPc4NIj3xLVJ8sTTvc95ctlKibBMRMhZ5uj7lqpNjt68Jqoraz5fa5lmE9y
         eOKA==
X-Gm-Message-State: AOAM532dLgNrbMKfejYdmXIuao68pjWJDfGy854TeSeuVtRW3ROESUli
        ar/Gcp5m14RGSPNjHSh/o+w=
X-Google-Smtp-Source: ABdhPJyu9imbhe+saOmZcAMN5MLeoXerEyGeCx7iwEx2yngQKrOHY5GyuhjSg8RAG0NjyyViO3LBQw==
X-Received: by 2002:a63:1406:: with SMTP id u6mr33350183pgl.108.1596107462192;
        Thu, 30 Jul 2020 04:11:02 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.152.86])
        by smtp.gmail.com with ESMTPSA id i67sm5888019pfg.13.2020.07.30.04.10.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2020 04:11:01 -0700 (PDT)
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
Subject: [PATCH v2] scsi: smartpqi: use generic power management
Date:   Thu, 30 Jul 2020 16:39:30 +0530
Message-Id: <20200730110930.664486-1-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200730070233.221488-1-vaibhavgupta40@gmail.com>
References: <20200730070233.221488-1-vaibhavgupta40@gmail.com>
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
 drivers/scsi/smartpqi/smartpqi_init.c | 44 +++++++++++++++++++--------
 1 file changed, 31 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index cd157f11eb22..7061bd26897a 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -8059,11 +8059,11 @@ static void pqi_process_module_params(void)
 	pqi_process_lockup_action_param();
 }
 
-static __maybe_unused int pqi_suspend(struct pci_dev *pci_dev, pm_message_t state)
+static int pqi_suspend_late(struct device *dev, pm_message_t state)
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
 
@@ -8480,16 +8490,24 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 
 MODULE_DEVICE_TABLE(pci, pqi_pci_id_table);
 
+static const struct dev_pm_ops pqi_pm_ops = {
+#ifdef CONFIG_PM_SLEEP
+	.suspend = pqi_suspend,
+	.resume = pqi_resume,
+	.freeze = pqi_freeze,
+	.thaw = pqi_resume,
+	.poweroff = pqi_hibernate,
+	.restore = pqi_resume,
+#endif
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

