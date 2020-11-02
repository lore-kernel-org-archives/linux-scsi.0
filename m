Return-Path: <SRS0=0UYT=EI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5935DC55178
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:51:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12AF122268
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:51:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eP3P0NhL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbgKBQvW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 11:51:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727163AbgKBQvW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 11:51:22 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AE6FC0617A6;
        Mon,  2 Nov 2020 08:51:22 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id x13so11592870pfa.9;
        Mon, 02 Nov 2020 08:51:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AdqDqmNu7Nx1PvYYi5OdlW5q1lUoCI4j4VahjSwyvEk=;
        b=eP3P0NhLcYeng6TK2EUujst4SvydxCeEyCUntT9SC6+LJvk6QHykhuueH6/pLI8gt1
         JK7o+Kf5mqLx1NcJLWDCG81IPiUgEJzCPPLtLgwaHSyovtvH7t3P8pTlNcMnjcTjGJv9
         Sl2bEk60Inn362/57NiowC+hgrvZCsYgGpWKA3TpQy5EG1WgSY/wjcIkGWi7KygKi+Go
         MdogMoJxegrgr530XGi0i+9ipmhRgpmpNaQtQ2zTd10tixdh97xB35Wtgssel8g+y1NP
         dxSTp4MoY8BZNBAcF8fwWGesVuDEB5NTgvzoAth0AhvFL1WdJIzmQ4Rpiv0vxnTiyiVo
         G8aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AdqDqmNu7Nx1PvYYi5OdlW5q1lUoCI4j4VahjSwyvEk=;
        b=INqBhtpPa/47P8iwMajcDBvxlsJt4bnBz61LcV/kOIBrKeDbdQEvWHiQlmtEhwdWj+
         ZIcaskQ0/W/E9FrekbpMLwtfm5jrvJ0nsghObhZDRlqJD2lhpXC8cySCuEGmSuZsULvp
         fiSrnKiwb+cM4sf6V+S506ShHY81pWn0CReFvt6+9+94VVywhvIOQw4dn2u//OeJpKcO
         YP97kXvaoqY/6dEg2zn0FrxvHeVmkuWL0gYIXr6JZ9mjLmLMR55ZeKPJnO1Wy4ZcWPm0
         6XKx72EjdL9HW9m6Y9dy3GkYwev9XfII1yZ1Jlti/WscHNYsCZNLKxmY2FG/IFzZRmRE
         947g==
X-Gm-Message-State: AOAM531DJoNZ4vKPzpKdKWkLZCMQJ5HdAaJ/Zz23LMG83iX5ASiGfT8D
        AG8XRlk2bPaEP6OlwAXLd5A=
X-Google-Smtp-Source: ABdhPJw3oohovIVzEW6Lk1KewPzZqifa78hPzZ3VGJMa6114i8blFub1+pk+Izdv8VuHVrnlf8bR7w==
X-Received: by 2002:a63:4556:: with SMTP id u22mr3179533pgk.261.1604335882067;
        Mon, 02 Nov 2020 08:51:22 -0800 (PST)
Received: from varodek.localdomain ([223.179.149.110])
        by smtp.gmail.com with ESMTPSA id t74sm4953233pfc.47.2020.11.02.08.51.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 08:51:21 -0800 (PST)
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
Subject: [PATCH v4 05/29] scsi: aacraid: use generic power management
Date:   Mon,  2 Nov 2020 22:17:06 +0530
Message-Id: <20201102164730.324035-6-vaibhavgupta40@gmail.com>
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
Acked-by: Balsundar P <balsundar.p@microchip.com>
---
 drivers/scsi/aacraid/linit.c | 33 +++++++--------------------------
 1 file changed, 7 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 8c4dcb5ab329..5177d387854a 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1910,11 +1910,9 @@ static int aac_acquire_resources(struct aac_dev *dev)
 
 }
 
-#if (defined(CONFIG_PM))
-static int aac_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused aac_suspend(struct device *dev)
 {
-
-	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct Scsi_Host *shost = dev_get_drvdata(dev);
 	struct aac_dev *aac = (struct aac_dev *)shost->hostdata;
 
 	scsi_host_block(shost);
@@ -1923,28 +1921,14 @@ static int aac_suspend(struct pci_dev *pdev, pm_message_t state)
 
 	aac_release_resources(aac);
 
-	pci_set_drvdata(pdev, shost);
-	pci_save_state(pdev);
-	pci_disable_device(pdev);
-	pci_set_power_state(pdev, pci_choose_state(pdev, state));
-
 	return 0;
 }
 
-static int aac_resume(struct pci_dev *pdev)
+static int __maybe_unused aac_resume(struct device *dev)
 {
-	struct Scsi_Host *shost = pci_get_drvdata(pdev);
+	struct Scsi_Host *shost = dev_get_drvdata(dev);
 	struct aac_dev *aac = (struct aac_dev *)shost->hostdata;
-	int r;
-
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
-	r = pci_enable_device(pdev);
-
-	if (r)
-		goto fail_device;
 
-	pci_set_master(pdev);
 	if (aac_acquire_resources(aac))
 		goto fail_device;
 	/*
@@ -1959,10 +1943,8 @@ static int aac_resume(struct pci_dev *pdev)
 fail_device:
 	printk(KERN_INFO "%s%d: resume failed.\n", aac->name, aac->id);
 	scsi_host_put(shost);
-	pci_disable_device(pdev);
 	return -ENODEV;
 }
-#endif
 
 static void aac_shutdown(struct pci_dev *dev)
 {
@@ -2107,15 +2089,14 @@ static struct pci_error_handlers aac_pci_err_handler = {
 	.resume			= aac_pci_resume,
 };
 
+static SIMPLE_DEV_PM_OPS(aac_pm_ops, aac_suspend, aac_resume);
+
 static struct pci_driver aac_pci_driver = {
 	.name		= AAC_DRIVERNAME,
 	.id_table	= aac_pci_tbl,
 	.probe		= aac_probe_one,
 	.remove		= aac_remove_one,
-#if (defined(CONFIG_PM))
-	.suspend	= aac_suspend,
-	.resume		= aac_resume,
-#endif
+	.driver.pm      = &aac_pm_ops,
 	.shutdown	= aac_shutdown,
 	.err_handler    = &aac_pci_err_handler,
 };
-- 
2.28.0

