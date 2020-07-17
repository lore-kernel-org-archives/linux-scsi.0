Return-Path: <SRS0=tLTu=A4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 307C8C433E6
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 06:37:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0767D20734
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 06:37:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pZEmdvF8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbgGQGhT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jul 2020 02:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbgGQGhS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jul 2020 02:37:18 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F042DC061755;
        Thu, 16 Jul 2020 23:37:17 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id a9so412244pjd.3;
        Thu, 16 Jul 2020 23:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Oj3XjMnrzr/KXlllPC7PsU6D+8eVCB8pjXqRivPGKnY=;
        b=pZEmdvF8fMAyw06fc9xyx9VCFW0YP+T0zKCCYDw6XL6T5IcvXNPrV5PzWc2Gd/7YgZ
         jXiwAWk3Z/0bdBL2Q1EM7i5K4Zl7PU8MYgAeeYNrKofe1NMxZ1314VqJgt6TALPJKsAT
         QFGR+Lqi7bX0M5vneTSxxmRPIKjcMe1NdN9i/kzVAgZzchoSsxsD44z+bihWBIGr5INZ
         xvQQfen/3CirFLKBZudB7MTQjquMAPJI8QTodDLCQmhzpQOvixXl0IjK8z/10ClIpkMp
         +5RpPdkhC9xgXfE5tVOCWAqsXbF24Kx6z/LbCWJWYbRDlq3AHQZ5TlMHHW1FQJYN6sGL
         z10A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Oj3XjMnrzr/KXlllPC7PsU6D+8eVCB8pjXqRivPGKnY=;
        b=ZK8UoSvjD8dGBCFspLE6oCcIqdCnSfEu6STLeCrXRY4NsOTU2HjmWrH/XzRv/jTzhN
         pqQK57SOMHhVSFtwfSjLMVtF/sjoL37mxSCXfOlAUACGL+Fix4XdiqqsWZ5bMY/dWdLZ
         UgBWkEJng/HpOWB3UC1ihftAzcqq4kALd7/2CbEUo5QwzlAD20nhlHH0I0lFXJzArBZX
         THfyLW3ya08h0aRaguZ7hdD6NrCVAjsHbFlGSJi4nGsVH6N5x8oApkIwxfP0AbwTI06y
         8CyxX7PV9DKoIEaIFHgyNEpFZr7wbj0qYxHhK+/sFGyU1c+Q5cyKwwzxfTSHo8c2pbwY
         5mag==
X-Gm-Message-State: AOAM533UiRQOJoyY4f3vkmnOFJqjyOTojzuOHpW70AM96cyKHfSYPJdw
        ALbUIQGNXjEyLnXuKRiPYbs=
X-Google-Smtp-Source: ABdhPJzw0UeA76/vsKD3g4Nf5qJ503fu0aAkL9zuiOLIq+YCd2FsL+cEDPSFq734CCuHPYTafT7lRw==
X-Received: by 2002:a17:90b:188b:: with SMTP id mn11mr8460686pjb.179.1594967837489;
        Thu, 16 Jul 2020 23:37:17 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.67])
        by smtp.gmail.com with ESMTPSA id y22sm1683392pjp.41.2020.07.16.23.37.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 23:37:17 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        Hannes Reinecke <hare@suse.com>,
        Bradley Grove <linuxdrivers@attotech.com>,
        John Garry <john.garry@huawei.com>,
        Don Brace <don.brace@microsemi.com>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-scsi@vger.kernel.org, esc.storagedev@microsemi.com,
        megaraidlinux.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH v1 06/15] scsi: esas2r: use generic power management
Date:   Fri, 17 Jul 2020 12:04:29 +0530
Message-Id: <20200717063438.175022-7-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200717063438.175022-1-vaibhavgupta40@gmail.com>
References: <20200717063438.175022-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

With legacy PM, drivers themselves were responsible for managing the
device's power states and takes care of register states.

After upgrading to the generic structure, PCI core will take care of
required tasks and drivers should do only device-specific operations.

The driver was calling pci_save/restore_state(), pci_choose_state(),
pci_enable/disable_device() and pci_set_power_state() which is no more
needed.

Compile-tested only.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/scsi/esas2r/esas2r.h      |  5 ++--
 drivers/scsi/esas2r/esas2r_init.c | 46 +++++++++----------------------
 drivers/scsi/esas2r/esas2r_main.c |  3 +-
 3 files changed, 17 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r.h b/drivers/scsi/esas2r/esas2r.h
index 7f43b95f4e94..6ad3e0871ef0 100644
--- a/drivers/scsi/esas2r/esas2r.h
+++ b/drivers/scsi/esas2r/esas2r.h
@@ -996,8 +996,9 @@ void esas2r_adapter_tasklet(unsigned long context);
 irqreturn_t esas2r_interrupt(int irq, void *dev_id);
 irqreturn_t esas2r_msi_interrupt(int irq, void *dev_id);
 void esas2r_kickoff_timer(struct esas2r_adapter *a);
-int esas2r_suspend(struct pci_dev *pcid, pm_message_t state);
-int esas2r_resume(struct pci_dev *pcid);
+
+extern const struct dev_pm_ops esas2r_pm_ops;
+
 void esas2r_fw_event_off(struct esas2r_adapter *a);
 void esas2r_fw_event_on(struct esas2r_adapter *a);
 bool esas2r_nvram_write(struct esas2r_adapter *a, struct esas2r_request *rq,
diff --git a/drivers/scsi/esas2r/esas2r_init.c b/drivers/scsi/esas2r/esas2r_init.c
index eb7d139ffc00..d682cc585632 100644
--- a/drivers/scsi/esas2r/esas2r_init.c
+++ b/drivers/scsi/esas2r/esas2r_init.c
@@ -640,53 +640,31 @@ void esas2r_kill_adapter(int i)
 	}
 }
 
-int esas2r_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused esas2r_suspend(struct device *dev)
 {
-	struct Scsi_Host *host = pci_get_drvdata(pdev);
-	u32 device_state;
+	struct Scsi_Host *host = dev_get_drvdata(dev);
 	struct esas2r_adapter *a = (struct esas2r_adapter *)host->hostdata;
 
-	esas2r_log_dev(ESAS2R_LOG_INFO, &(pdev->dev), "suspending adapter()");
+	esas2r_log_dev(ESAS2R_LOG_INFO, dev, "suspending adapter()");
 	if (!a)
 		return -ENODEV;
 
 	esas2r_adapter_power_down(a, 1);
-	device_state = pci_choose_state(pdev, state);
-	esas2r_log_dev(ESAS2R_LOG_INFO, &(pdev->dev),
-		       "pci_save_state() called");
-	pci_save_state(pdev);
-	esas2r_log_dev(ESAS2R_LOG_INFO, &(pdev->dev),
-		       "pci_disable_device() called");
-	pci_disable_device(pdev);
-	esas2r_log_dev(ESAS2R_LOG_INFO, &(pdev->dev),
-		       "pci_set_power_state() called");
-	pci_set_power_state(pdev, device_state);
-	esas2r_log_dev(ESAS2R_LOG_INFO, &(pdev->dev), "esas2r_suspend(): 0");
+	esas2r_log_dev(ESAS2R_LOG_INFO, dev, "esas2r_suspend(): 0");
 	return 0;
 }
 
-int esas2r_resume(struct pci_dev *pdev)
+static int __maybe_unused esas2r_resume(struct device *dev)
 {
-	struct Scsi_Host *host = pci_get_drvdata(pdev);
+	struct Scsi_Host *host = dev_get_drvdata(dev);
 	struct esas2r_adapter *a = (struct esas2r_adapter *)host->hostdata;
 	int rez;
 
-	esas2r_log_dev(ESAS2R_LOG_INFO, &(pdev->dev), "resuming adapter()");
-	esas2r_log_dev(ESAS2R_LOG_INFO, &(pdev->dev),
-		       "pci_set_power_state(PCI_D0) "
+	esas2r_log_dev(ESAS2R_LOG_INFO, dev, "resuming adapter()");
+	esas2r_log_dev(ESAS2R_LOG_INFO, dev,
+		       "device_wakeup_disable() "
 		       "called");
-	pci_set_power_state(pdev, PCI_D0);
-	esas2r_log_dev(ESAS2R_LOG_INFO, &(pdev->dev),
-		       "pci_enable_wake(PCI_D0, 0) "
-		       "called");
-	pci_enable_wake(pdev, PCI_D0, 0);
-	esas2r_log_dev(ESAS2R_LOG_INFO, &(pdev->dev),
-		       "pci_restore_state() called");
-	pci_restore_state(pdev);
-	esas2r_log_dev(ESAS2R_LOG_INFO, &(pdev->dev),
-		       "pci_enable_device() called");
-	rez = pci_enable_device(pdev);
-	pci_set_master(pdev);
+	device_wakeup_disable(dev);
 
 	if (!a) {
 		rez = -ENODEV;
@@ -730,11 +708,13 @@ int esas2r_resume(struct pci_dev *pdev)
 	}
 
 error_exit:
-	esas2r_log_dev(ESAS2R_LOG_CRIT, &(pdev->dev), "esas2r_resume(): %d",
+	esas2r_log_dev(ESAS2R_LOG_CRIT, dev, "esas2r_resume(): %d",
 		       rez);
 	return rez;
 }
 
+SIMPLE_DEV_PM_OPS(esas2r_pm_ops, esas2r_suspend, esas2r_resume);
+
 bool esas2r_set_degraded_mode(struct esas2r_adapter *a, char *error_str)
 {
 	set_bit(AF_DEGRADED_MODE, &a->flags);
diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index 7b49e2e9fcde..aab3ea580e6b 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -346,8 +346,7 @@ static struct pci_driver
 	.id_table	= esas2r_pci_table,
 	.probe		= esas2r_probe,
 	.remove		= esas2r_remove,
-	.suspend	= esas2r_suspend,
-	.resume		= esas2r_resume,
+	.driver.pm	= &esas2r_pm_ops,
 };
 
 static int esas2r_probe(struct pci_dev *pcid,
-- 
2.27.0

