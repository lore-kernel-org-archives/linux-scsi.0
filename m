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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 735D6C433E5
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 06:38:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AE4020704
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 06:38:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="geP9tlik"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728033AbgGQGiB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jul 2020 02:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbgGQGiA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jul 2020 02:38:00 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8CADC061755;
        Thu, 16 Jul 2020 23:38:00 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id z5so6216792pgb.6;
        Thu, 16 Jul 2020 23:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wtgOcxozUo1A/1oRnre/tApDmIyqZGC9apBsteJq/qw=;
        b=geP9tlikeeOgb99m2DhIOa+lVY4n89I7VpemFrryKIceCZvdTXbVKN3gKRTNQBCUI9
         V+lhzf1Wm8hv8FqDG+WyjFS/kZmLQTsljSOIzOX8VhTP2cJcfZQDiX6K8I0dShaioez6
         lEVAk2bBnW1ejSmieSgtb808UIHyPuFSiuLM019Wi7ZAYJAtyDrjbS05pXBD3Sn6NiXI
         /f4BBsjfK8Fr+pVnGZeL/m0YoeRRBJBSymhtHAcCBSAophrjSW7mClNgSEQAHBkAQHBz
         amXV0T3Zi2rWFZ61b2jp3DsnXZWwFMopXrvIHlSVFQ5bRJ7Z8ajLkgIqWbdPcoOpaTsH
         w8lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wtgOcxozUo1A/1oRnre/tApDmIyqZGC9apBsteJq/qw=;
        b=LDMqZfY9HRSIRrKcPcoQ654gURKejWjA1rs8OZ2DWYlAOGjIW8RAMbybMCtdVDpdau
         Z784eMaeZyDKUshfANm8gKwh3if15Wk6Q0cFWbw6mXylmg4ugRDWUCG37ob8r4cW02fu
         rcVDHFYMkcPnAi5WqBs/T9YvcmKefjI15BAxvDuqJEd7qUoSp6oIxINOwrZU5W+IQTUs
         l/v9LjYgBi8HyUdZ4S2YkyyzSFe7jvTPxQxj/u8tZI2RG9ya9H/FJEDMNsDmBj3f6zmZ
         bUwAfvV+lk1PjvCLSwDVJpLHA64obmQ426/Q5QRkCnfgmhNTD3jJVCJ9iyDJvEnDHL97
         0baA==
X-Gm-Message-State: AOAM530BhtUiovJn595/YCI6y8T5oLv7XXYLlXu9Uw9QdyDof0o1VzB2
        /4cqidA1DoLK+M7U+RKnlYo=
X-Google-Smtp-Source: ABdhPJwSELLmtmQGLqjUTkpErqmiYkPKogaj4aTRq3vd5MMKo50b/0qylVSUT7c5iKhsYEKVV7EWPw==
X-Received: by 2002:aa7:8391:: with SMTP id u17mr7167776pfm.156.1594967880278;
        Thu, 16 Jul 2020 23:38:00 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.67])
        by smtp.gmail.com with ESMTPSA id y22sm1683392pjp.41.2020.07.16.23.37.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 23:37:59 -0700 (PDT)
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
Subject: [PATCH v1 10/15] scsi: pm_8001: use generic power management
Date:   Fri, 17 Jul 2020 12:04:33 +0530
Message-Id: <20200717063438.175022-11-vaibhavgupta40@gmail.com>
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
 drivers/scsi/pm8001/pm8001_init.c | 43 ++++++++++++-------------------
 1 file changed, 16 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 9e99262a2b9d..6831760fca59 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1178,23 +1178,22 @@ static void pm8001_pci_remove(struct pci_dev *pdev)
 
 /**
  * pm8001_pci_suspend - power management suspend main entry point
- * @pdev: PCI device struct
- * @state: PM state change to (usually PCI_D3)
+ * @dev: Device struct
  *
  * Returns 0 success, anything else error.
  */
-static int pm8001_pci_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused pm8001_pci_suspend(struct device *dev)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
 	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
 	struct pm8001_hba_info *pm8001_ha;
 	int  i, j;
-	u32 device_state;
 	pm8001_ha = sha->lldd_ha;
 	sas_suspend_ha(sha);
 	flush_workqueue(pm8001_wq);
 	scsi_block_requests(pm8001_ha->shost);
 	if (!pdev->pm_cap) {
-		dev_err(&pdev->dev, " PCI PM not supported\n");
+		dev_err(dev, " PCI PM not supported\n");
 		return -ENODEV;
 	}
 	PM8001_CHIP_DISP->interrupt_disable(pm8001_ha, 0xFF);
@@ -1217,24 +1216,21 @@ static int pm8001_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 		for (j = 0; j < PM8001_MAX_MSIX_VEC; j++)
 			tasklet_kill(&pm8001_ha->tasklet[j]);
 #endif
-	device_state = pci_choose_state(pdev, state);
 	pm8001_printk("pdev=0x%p, slot=%s, entering "
-		      "operating state [D%d]\n", pdev,
-		      pm8001_ha->name, device_state);
-	pci_save_state(pdev);
-	pci_disable_device(pdev);
-	pci_set_power_state(pdev, device_state);
+		      "suspended state\n", pdev,
+		      pm8001_ha->name);
 	return 0;
 }
 
 /**
  * pm8001_pci_resume - power management resume main entry point
- * @pdev: PCI device struct
+ * @dev: Device struct
  *
  * Returns 0 success, anything else error.
  */
-static int pm8001_pci_resume(struct pci_dev *pdev)
+static int __maybe_unused pm8001_pci_resume(struct device *dev)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
 	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
 	struct pm8001_hba_info *pm8001_ha;
 	int rc;
@@ -1247,17 +1243,8 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
 	pm8001_printk("pdev=0x%p, slot=%s, resuming from previous "
 		"operating state [D%d]\n", pdev, pm8001_ha->name, device_state);
 
-	pci_set_power_state(pdev, PCI_D0);
-	pci_enable_wake(pdev, PCI_D0, 0);
-	pci_restore_state(pdev);
-	rc = pci_enable_device(pdev);
-	if (rc) {
-		pm8001_printk("slot=%s Enable device failed during resume\n",
-			      pm8001_ha->name);
-		goto err_out_enable;
-	}
+	device_wakeup_disable(dev);
 
-	pci_set_master(pdev);
 	rc = pci_go_44(pdev);
 	if (rc)
 		goto err_out_disable;
@@ -1318,8 +1305,7 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
 
 err_out_disable:
 	scsi_remove_host(pm8001_ha->shost);
-	pci_disable_device(pdev);
-err_out_enable:
+
 	return rc;
 }
 
@@ -1402,13 +1388,16 @@ static struct pci_device_id pm8001_pci_table[] = {
 	{} /* terminate list */
 };
 
+static SIMPLE_DEV_PM_OPS(pm8001_pci_pm_ops,
+			 pm8001_pci_suspend,
+			 pm8001_pci_resume);
+
 static struct pci_driver pm8001_pci_driver = {
 	.name		= DRV_NAME,
 	.id_table	= pm8001_pci_table,
 	.probe		= pm8001_pci_probe,
 	.remove		= pm8001_pci_remove,
-	.suspend	= pm8001_pci_suspend,
-	.resume		= pm8001_pci_resume,
+	.driver.pm	= &pm8001_pci_pm_ops,
 };
 
 /**
-- 
2.27.0

