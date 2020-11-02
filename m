Return-Path: <SRS0=0UYT=EI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3B0DC00A89
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:52:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F1A022268
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:52:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qeGq4sy0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbgKBQwg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 11:52:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726913AbgKBQwg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 11:52:36 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5F74C0617A6;
        Mon,  2 Nov 2020 08:52:35 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id i26so11278254pgl.5;
        Mon, 02 Nov 2020 08:52:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WUBvgbl6iGKCFFzOFeem+Ak5qZZi8vOAFv31Ry1s8Ag=;
        b=qeGq4sy0Twb2LAXIoCUbswcwn5ARIZjtbvsgY+oMv6tpsKJBflcN0heggKOvGtAqlF
         5lWH8QI0yCIRswe3y9aFtE4ifNs/DVlApOrcyVqC+BWmQvc3TF2UsKcW2AvIOOf2Q5Xp
         eYffTtiEej9hzNYv+Ao6e5/9+dOMgx3vPfbwOh+YLptr1r/Zc88Yhm68bvLv4bNzolZ7
         2pISvCLddMw9n0rFCiEzmY5pEMguW+KZ2mqsL0Poev7+GgE8Av4S/6rbZKZGxl4O5S0S
         CUlraZ6y34Q6SjK0QqTBWFJ18eEmU2626VUSvimPY1VA8lXybPhbRpHTHa7JCe8zQNHm
         3Avw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WUBvgbl6iGKCFFzOFeem+Ak5qZZi8vOAFv31Ry1s8Ag=;
        b=ianSS/mVTn5iZYF4mzv7P5UeURgWAyYQ22eQviFob9nxWSKvPUVVuZU3TNHe/Ymdm1
         wL4rhgXIt9a6sJ3ir12I5sSG1Ovcdod4WgY8r0OSWbg9bMJNlzvuQCTvJzwgn1zdSLxa
         vbyBLLQ9ibyY3FF1p9wNMcvUWS1hCelLvxoHVABCfb1eFUTTaZku5N9Q2ythhoCfanuk
         Ct3hweVFQI8Cds4QOd4UUefKk0u35KpjZm9p3SwJIiEy3USzdpRt8yYqbDByqnxtWn6I
         KofVad6UZwyBoVRTATYswCe56daRFUivcnblyNwD0Njp2yVrY+EV+4lTyTJYN3Idv0g1
         1lNA==
X-Gm-Message-State: AOAM532yVmbLXmj/CWoGAXzprvzCrtFahXBTxgWOXPl4/mVKRWxXGV7t
        IbCLeK1SA+OPSpdKc2Abay0=
X-Google-Smtp-Source: ABdhPJxVRX3en5oytRjcT9dRbMawLDnUSZPxIfG/YiS9M7Ityd8FlnM25FraJFjXR8i/6UM+kEw3Sw==
X-Received: by 2002:a05:6a00:2cf:b029:160:c0c:a95c with SMTP id b15-20020a056a0002cfb02901600c0ca95cmr21990295pft.76.1604335955469;
        Mon, 02 Nov 2020 08:52:35 -0800 (PST)
Received: from varodek.localdomain ([223.179.149.110])
        by smtp.gmail.com with ESMTPSA id t74sm4953233pfc.47.2020.11.02.08.52.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 08:52:34 -0800 (PST)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        Hannes Reinecke <hare@suse.com>,
        Bradley Grove <linuxdrivers@attotech.com>,
        John Garry <john.garry@huawei.com>,
        Don Brace <don.brace@microsemi.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
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
        Balsundar P <balsundar.p@microchip.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-scsi@vger.kernel.org, esc.storagedev@microsemi.com,
        megaraidlinux.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH v4 11/29] scsi: esas2r: use generic power management
Date:   Mon,  2 Nov 2020 22:17:12 +0530
Message-Id: <20201102164730.324035-12-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201102164730.324035-1-vaibhavgupta40@gmail.com>
References: <20201102164730.324035-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Drivers should do only device-specific jobs. But in general, drivers using
legacy PCI PM framework for .suspend()/.resume() have to manage many PCI
PM-related tasks themselves which can be done by PCI Core itself. This
brings extra load on the driver and it directly calls PCI helper functions
to handle them.

Switch to the new generic framework by updating function signatures and
define a "struct dev_pm_ops" variable to bind PM callbacks. Also, remove
unnecessary calls to the PCI Helper functions along with the legacy
.suspend & .resume bindings.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/scsi/esas2r/esas2r.h      |  5 ++--
 drivers/scsi/esas2r/esas2r_init.c | 44 +++++++++----------------------
 drivers/scsi/esas2r/esas2r_main.c |  3 +--
 3 files changed, 16 insertions(+), 36 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r.h b/drivers/scsi/esas2r/esas2r.h
index e30d2f1f5368..ed63f7a9ea54 100644
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
index 905a6c874789..eb7763af7089 100644
--- a/drivers/scsi/esas2r/esas2r_init.c
+++ b/drivers/scsi/esas2r/esas2r_init.c
@@ -640,49 +640,27 @@ void esas2r_kill_adapter(int i)
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
-	int rez;
-
-	esas2r_log_dev(ESAS2R_LOG_INFO, &(pdev->dev), "resuming adapter()");
-	esas2r_log_dev(ESAS2R_LOG_INFO, &(pdev->dev),
-		       "pci_set_power_state(PCI_D0) "
-		       "called");
-	pci_set_power_state(pdev, PCI_D0);
-	esas2r_log_dev(ESAS2R_LOG_INFO, &(pdev->dev),
-		       "pci_restore_state() called");
-	pci_restore_state(pdev);
-	esas2r_log_dev(ESAS2R_LOG_INFO, &(pdev->dev),
-		       "pci_enable_device() called");
-	rez = pci_enable_device(pdev);
-	pci_set_master(pdev);
+	int rez = 0;
+
+	esas2r_log_dev(ESAS2R_LOG_INFO, dev, "resuming adapter()");
 
 	if (!a) {
 		rez = -ENODEV;
@@ -726,11 +704,13 @@ int esas2r_resume(struct pci_dev *pdev)
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
2.28.0

