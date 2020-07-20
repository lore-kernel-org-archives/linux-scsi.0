Return-Path: <SRS0=rv89=A7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A08BDC433E7
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 13:37:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BD4222C9C
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 13:37:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nVu+bkUf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbgGTNhh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jul 2020 09:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbgGTNhg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jul 2020 09:37:36 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D35AC0619D2;
        Mon, 20 Jul 2020 06:37:36 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id a24so9065647pfc.10;
        Mon, 20 Jul 2020 06:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g/tyeJF8PDKMzFJdLXmzBSv8b1mcXisQeNVbn9w363w=;
        b=nVu+bkUfU8uZ6Y9bM5MnpehhbVKa0HZT0XFlnc43jPvwL7tBnEQAmHSLtZ+gBgJqxb
         NeL+J5yg3sIbdGuNJhrwUDWdAvieqT4tO666p6jzELlF7zks0HQfA6p9QlWRUl/ZPHVs
         kzSWlrnoxI667undAsKwN0eac0ZlwirAKNoc6iVFfp7Zhr/NMFTDl11OuVRsOwT7RBw6
         7Kuh6/4F7n0HBDlQjYN+qPvsdXO4WzvKPDr/3JDnkdR2UQQCivhOv8S6tEU31aVWCRoH
         0SvT94CNwtUs0DOF1Gb4vMJu2STGzjzYVKmzZMISwRki8yPbhsO4lGd5lK35G0828yzi
         2Zdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g/tyeJF8PDKMzFJdLXmzBSv8b1mcXisQeNVbn9w363w=;
        b=XY9aaIO+hy4snf7NWWEOma46lMVoEPmYs/WvqFLac2zGKe7kIwD1boAt8jA35gdE5L
         uwxjvZBTxohZW5wvO0ow+lINnCYkKIXq6uZQtqowG9pRL+Vg1m89Mu/SEoR7IUQoKYkH
         KClqWAU9fcKNIfpWHDM7W9CiJjRjBqbfIubCF5WGfN095EuWh2weqR6HOojzsnfCFq82
         n1epGtxo38KDZIzliHLAoxLkY/+v6B8iqQxad9yW4n5DCJ5/SceNy92c4AMLq/m2gLpc
         /2g1Na29Nwacuqi6/7tm8XvYi+gjASjyRQi0mZPw0ssgTKH7n1Oa/rkiqsBn9jG/ovlq
         CHiA==
X-Gm-Message-State: AOAM530prnlfW7dWbiIgPOK9mb3tXCTd8YyUdVOgbLgNw3rSMasuB70c
        /765eNiiCEsG3/jQByY6ZEw=
X-Google-Smtp-Source: ABdhPJzNEPHUJoYdIwhey6eTtJDVg+pcapt7e6hUXlaJoM6SYFLd09rx5dD/UfelQj+iqrB5Ywzp6g==
X-Received: by 2002:a63:531e:: with SMTP id h30mr18016413pgb.165.1595252255802;
        Mon, 20 Jul 2020 06:37:35 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.67])
        by smtp.gmail.com with ESMTPSA id s6sm17042183pfd.20.2020.07.20.06.37.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 06:37:35 -0700 (PDT)
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
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-scsi@vger.kernel.org, esc.storagedev@microsemi.com,
        megaraidlinux.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH v2 06/15] scsi: esas2r: use generic power management
Date:   Mon, 20 Jul 2020 19:04:19 +0530
Message-Id: <20200720133427.454400-7-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720133427.454400-1-vaibhavgupta40@gmail.com>
References: <20200720133427.454400-1-vaibhavgupta40@gmail.com>
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
 drivers/scsi/esas2r/esas2r_init.c | 48 +++++++++----------------------
 drivers/scsi/esas2r/esas2r_main.c |  3 +-
 3 files changed, 18 insertions(+), 38 deletions(-)

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
index eb7d139ffc00..6c5854969791 100644
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
-	int rez;
+	int rez = 0;
 
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

