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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D44AC433E5
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 13:37:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36F1222B4D
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 13:37:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N3fETepz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728164AbgGTNhp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jul 2020 09:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbgGTNhp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jul 2020 09:37:45 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0200FC061794;
        Mon, 20 Jul 2020 06:37:45 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id m9so9070218pfh.0;
        Mon, 20 Jul 2020 06:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oHOwkj4fnhtZnaXLc1XXpmlO0WhcrZr5c89iPSNlAKc=;
        b=N3fETepzmOozX/AxOkoCUFSDqCpy0ZzL2Rs4rgiRCwW4aDxyzCdhb8wb1BZvzRhQ65
         AlH8lGu3Ff1vJwY4/wqtUmaPXnEjyAEw+C0+ALch561vPqpwi3jIDRbIwct37jI9NIJn
         I8y8Otjt3arzq7cjPvA4ZarBcHL6cK6kE56NjAsKiQTmZ8tTcVY4HK0aGyXih5pfTORS
         mGF1qZnF8aWUNkA+cCvXTcEfcKSmTh6phJa1M6ApdVSV49gerGNLC3hvL6VttAyGktzE
         /50/T+qmqpxZbVuTrKEGa6u2sfhIFY0e3rfLTt4cDrSwsyPdl5VZzCsHT8o68oC1haog
         dAKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oHOwkj4fnhtZnaXLc1XXpmlO0WhcrZr5c89iPSNlAKc=;
        b=ru1aObsy6E4zS87GuGBb6/VXOu8/0myArDTgjyCe+Aj4/U21nyME9D81hurPJzaZxG
         G6TaqpomNxPXBB9PcSiBI5NgtRaTUPuDb+JNiR8cvYpF/rBkgyUijsiOOaIleMqkmoi7
         vj7dKKnKI3f3/2gvlAoTGMlZdQCVaUOXwcTyhQeQnYBGk5q9DFNOFS7rIO1cD6NzKbwv
         +w2aKecnBTYyooHsngAqWTdSyLORcExdUlSngd3CwZ6aFInwj6JsbWNs3qbw8RqprX0G
         AyzOh7ndVpU/2zfH0UPXcszy+DDUO0OCjDu5gffYoFoB87JsIHT2JNU3U3k86Oe9u/Bq
         3CeA==
X-Gm-Message-State: AOAM532SxFQawjAiBFlj7ovzndmCN5Kt75Ngveaz4SPlhU3a10KEQBrb
        2b0lzdDuL+otmGXnws1AA58=
X-Google-Smtp-Source: ABdhPJxJRIM4Ewl/jQRBvdKQ4coKSOKXgbX+ilJAvVkMgETBOGrwClaYe3O8p9u6ps7Ck5oEnYkA4A==
X-Received: by 2002:aa7:8557:: with SMTP id y23mr19420720pfn.148.1595252264494;
        Mon, 20 Jul 2020 06:37:44 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.67])
        by smtp.gmail.com with ESMTPSA id s6sm17042183pfd.20.2020.07.20.06.37.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 06:37:43 -0700 (PDT)
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
Subject: [PATCH v2 07/15] scsi: hisi_sas_v3_hw: use generic power management
Date:   Mon, 20 Jul 2020 19:04:20 +0530
Message-Id: <20200720133427.454400-8-vaibhavgupta40@gmail.com>
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
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 32 +++++++++-----------------
 1 file changed, 11 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 55e2321a65bc..824bfbe1abbb 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -3374,13 +3374,13 @@ enum {
 	hip08,
 };
 
-static int hisi_sas_v3_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused hisi_sas_v3_suspend(struct device *dev_d)
 {
+	struct pci_dev *pdev = to_pci_dev(dev_d);
 	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
 	struct hisi_hba *hisi_hba = sha->lldd_ha;
 	struct device *dev = hisi_hba->dev;
 	struct Scsi_Host *shost = hisi_hba->shost;
-	pci_power_t device_state;
 	int rc;
 
 	if (!pdev->pm_cap) {
@@ -3406,12 +3406,7 @@ static int hisi_sas_v3_suspend(struct pci_dev *pdev, pm_message_t state)
 
 	hisi_sas_init_mem(hisi_hba);
 
-	device_state = pci_choose_state(pdev, state);
-	dev_warn(dev, "entering operating state [D%d]\n",
-			device_state);
-	pci_save_state(pdev);
-	pci_disable_device(pdev);
-	pci_set_power_state(pdev, device_state);
+	dev_warn(dev, "entering suspend state\n");
 
 	hisi_sas_release_tasks(hisi_hba);
 
@@ -3419,8 +3414,9 @@ static int hisi_sas_v3_suspend(struct pci_dev *pdev, pm_message_t state)
 	return 0;
 }
 
-static int hisi_sas_v3_resume(struct pci_dev *pdev)
+static int __maybe_unused hisi_sas_v3_resume(struct device *dev_d)
 {
+	struct pci_dev *pdev = to_pci_dev(dev_d);
 	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
 	struct hisi_hba *hisi_hba = sha->lldd_ha;
 	struct Scsi_Host *shost = hisi_hba->shost;
@@ -3430,16 +3426,8 @@ static int hisi_sas_v3_resume(struct pci_dev *pdev)
 
 	dev_warn(dev, "resuming from operating state [D%d]\n",
 		 device_state);
-	pci_set_power_state(pdev, PCI_D0);
-	pci_enable_wake(pdev, PCI_D0, 0);
-	pci_restore_state(pdev);
-	rc = pci_enable_device(pdev);
-	if (rc) {
-		dev_err(dev, "enable device failed during resume (%d)\n", rc);
-		return rc;
-	}
+	device_wakeup_disable(dev_d);
 
-	pci_set_master(pdev);
 	scsi_unblock_requests(shost);
 	clear_bit(HISI_SAS_REJECT_CMD_BIT, &hisi_hba->flags);
 
@@ -3447,7 +3435,6 @@ static int hisi_sas_v3_resume(struct pci_dev *pdev)
 	rc = hw_init_v3_hw(hisi_hba);
 	if (rc) {
 		scsi_remove_host(shost);
-		pci_disable_device(pdev);
 		return rc;
 	}
 	hisi_hba->hw->phys_init(hisi_hba);
@@ -3468,13 +3455,16 @@ static const struct pci_error_handlers hisi_sas_err_handler = {
 	.reset_done	= hisi_sas_reset_done_v3_hw,
 };
 
+static SIMPLE_DEV_PM_OPS(hisi_sas_v3_pm_ops,
+			 hisi_sas_v3_suspend,
+			 hisi_sas_v3_resume);
+
 static struct pci_driver sas_v3_pci_driver = {
 	.name		= DRV_NAME,
 	.id_table	= sas_v3_pci_table,
 	.probe		= hisi_sas_v3_probe,
 	.remove		= hisi_sas_v3_remove,
-	.suspend	= hisi_sas_v3_suspend,
-	.resume		= hisi_sas_v3_resume,
+	.driver.pm	= &hisi_sas_v3_pm_ops,
 	.err_handler	= &hisi_sas_err_handler,
 };
 
-- 
2.27.0

