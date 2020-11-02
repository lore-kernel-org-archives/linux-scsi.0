Return-Path: <SRS0=0UYT=EI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45FA4C00A89
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:51:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D39B522258
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:51:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o0+RixOC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbgKBQvv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 11:51:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbgKBQvv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 11:51:51 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E2BC0617A6;
        Mon,  2 Nov 2020 08:51:51 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id t14so11302851pgg.1;
        Mon, 02 Nov 2020 08:51:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cJtPRbZ0BXTdxtMhOPuwVb993Cdrsr394jXmvtsCRXA=;
        b=o0+RixOC4+HHVj6IcZW2lxk7rwbti9/GvAsbGq27zORpiX5cG1FvjlbbRWCKcbJiGF
         Vs7IsnKkJmM+36NfFuYKo0L/FCmh5goFm0hzMpe0Za4SjFFM3gCI/B+6R/JTnHpXZd2b
         stDzegLSVxEFArvrp3VAWZe5KYgISU8AIzLnWGuIBsYBc7jtP3/YdXvAxDgQ/BD0xbNR
         VffUwUPEFHNLZIwOUeY2IULJ/p+Sx3J5mfIGQaU2LFOX+Ka1KZfyzy3cU8QWj65H0feQ
         6b0X51LFE8QhjNwEqiWg0v0/CdO8DpJm429usdwVCb6f16jfJWt8B2cauQEKTumyCj7d
         SAEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cJtPRbZ0BXTdxtMhOPuwVb993Cdrsr394jXmvtsCRXA=;
        b=PyjT0+lGOR10AGZJonwyOrG/XtGhrY+r8eua4Zhr29B/ZwUoD82HJsXXFQecRVwrqj
         Gml0HJ/Po8qRT/cC0FUrZvPe7XiUWDx3D3jnsiVti0xYCFOyghJiZPJc3HYFwlinM1gU
         /fr5chgBXVVsu7YcGGCrlYHop/03TNj8cqvwV44g/HfavCxYCgzywdfo6SVn7NYCkuCX
         TzfKNflVKtYaJeUB2ieSBjvmhgtGFVJ/MBqQRKpexnV02mKsSTHe+YG8CdIx9rrYxP4C
         Vzfo1rBD2Yh4wmXZ0zrEq6s+NPd1tthX+RXwUvbbWGqn7iByuqrbYZagAL4XjM1EPQDi
         LXLA==
X-Gm-Message-State: AOAM53083nEjdZ/lI5Rd8h9bzoXvnbUjXq6C9p7MULXb44bhAdeP8/XB
        drDu8JgSmlynxby5me3L0HY=
X-Google-Smtp-Source: ABdhPJwMkLBsyBK8ShkMbKcFNpZL8/RhL7F9NjCxS+3MHLcgt2hVh7/aAb8+Yaa5TiGJGPB9d9fgfA==
X-Received: by 2002:a63:d66:: with SMTP id 38mr13160055pgn.400.1604335910487;
        Mon, 02 Nov 2020 08:51:50 -0800 (PST)
Received: from varodek.localdomain ([223.179.149.110])
        by smtp.gmail.com with ESMTPSA id t74sm4953233pfc.47.2020.11.02.08.51.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 08:51:50 -0800 (PST)
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
Subject: [PATCH v4 07/29] scsi: aic79xx: use generic power management
Date:   Mon,  2 Nov 2020 22:17:08 +0530
Message-Id: <20201102164730.324035-8-vaibhavgupta40@gmail.com>
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
 drivers/scsi/aic7xxx/aic79xx.h         | 12 +++----
 drivers/scsi/aic7xxx/aic79xx_core.c    |  8 ++---
 drivers/scsi/aic7xxx/aic79xx_osm_pci.c | 43 +++++++-------------------
 drivers/scsi/aic7xxx/aic79xx_pci.c     |  6 ++--
 4 files changed, 20 insertions(+), 49 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx.h b/drivers/scsi/aic7xxx/aic79xx.h
index 9a515551641c..dd5dfd4f30a5 100644
--- a/drivers/scsi/aic7xxx/aic79xx.h
+++ b/drivers/scsi/aic7xxx/aic79xx.h
@@ -1330,10 +1330,8 @@ const struct	ahd_pci_identity *ahd_find_pci_device(ahd_dev_softc_t);
 int			  ahd_pci_config(struct ahd_softc *,
 					 const struct ahd_pci_identity *);
 int	ahd_pci_test_register_access(struct ahd_softc *);
-#ifdef CONFIG_PM
-void	ahd_pci_suspend(struct ahd_softc *);
-void	ahd_pci_resume(struct ahd_softc *);
-#endif
+void __maybe_unused	ahd_pci_suspend(struct ahd_softc *);
+void __maybe_unused	ahd_pci_resume(struct ahd_softc *);
 
 /************************** SCB and SCB queue management **********************/
 void		ahd_qinfifo_requeue_tail(struct ahd_softc *ahd,
@@ -1344,10 +1342,8 @@ struct ahd_softc	*ahd_alloc(void *platform_arg, char *name);
 int			 ahd_softc_init(struct ahd_softc *);
 void			 ahd_controller_info(struct ahd_softc *ahd, char *buf);
 int			 ahd_init(struct ahd_softc *ahd);
-#ifdef CONFIG_PM
-int			 ahd_suspend(struct ahd_softc *ahd);
-void			 ahd_resume(struct ahd_softc *ahd);
-#endif
+int __maybe_unused	 ahd_suspend(struct ahd_softc *ahd);
+void __maybe_unused	 ahd_resume(struct ahd_softc *ahd);
 int			 ahd_default_config(struct ahd_softc *ahd);
 int			 ahd_parse_vpddata(struct ahd_softc *ahd,
 					   struct vpd_config *vpd);
diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 98b02e7d38bb..78560a85b1e3 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -7866,11 +7866,9 @@ ahd_pause_and_flushwork(struct ahd_softc *ahd)
 	ahd->flags &= ~AHD_ALL_INTERRUPTS;
 }
 
-#ifdef CONFIG_PM
-int
+int __maybe_unused
 ahd_suspend(struct ahd_softc *ahd)
 {
-
 	ahd_pause_and_flushwork(ahd);
 
 	if (LIST_FIRST(&ahd->pending_scbs) != NULL) {
@@ -7881,15 +7879,13 @@ ahd_suspend(struct ahd_softc *ahd)
 	return (0);
 }
 
-void
+void __maybe_unused
 ahd_resume(struct ahd_softc *ahd)
 {
-
 	ahd_reset(ahd, /*reinit*/TRUE);
 	ahd_intr_enable(ahd, TRUE); 
 	ahd_restart(ahd);
 }
-#endif
 
 /************************** Busy Target Table *********************************/
 /*
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c b/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
index 8b891a05d9e7..07b670b80f1b 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
@@ -74,11 +74,10 @@ static const struct pci_device_id ahd_linux_pci_id_table[] = {
 
 MODULE_DEVICE_TABLE(pci, ahd_linux_pci_id_table);
 
-#ifdef CONFIG_PM
-static int
-ahd_linux_pci_dev_suspend(struct pci_dev *pdev, pm_message_t mesg)
+static int __maybe_unused
+ahd_linux_pci_dev_suspend(struct device *dev)
 {
-	struct ahd_softc *ahd = pci_get_drvdata(pdev);
+	struct ahd_softc *ahd = dev_get_drvdata(dev);
 	int rc;
 
 	if ((rc = ahd_suspend(ahd)))
@@ -86,39 +85,20 @@ ahd_linux_pci_dev_suspend(struct pci_dev *pdev, pm_message_t mesg)
 
 	ahd_pci_suspend(ahd);
 
-	pci_save_state(pdev);
-	pci_disable_device(pdev);
-
-	if (mesg.event & PM_EVENT_SLEEP)
-		pci_set_power_state(pdev, PCI_D3hot);
-
 	return rc;
 }
 
-static int
-ahd_linux_pci_dev_resume(struct pci_dev *pdev)
+static int __maybe_unused
+ahd_linux_pci_dev_resume(struct device *dev)
 {
-	struct ahd_softc *ahd = pci_get_drvdata(pdev);
-	int rc;
-
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
-
-	if ((rc = pci_enable_device(pdev))) {
-		dev_printk(KERN_ERR, &pdev->dev,
-			   "failed to enable device after resume (%d)\n", rc);
-		return rc;
-	}
-
-	pci_set_master(pdev);
+	struct ahd_softc *ahd = dev_get_drvdata(dev);
 
 	ahd_pci_resume(ahd);
 
 	ahd_resume(ahd);
 
-	return rc;
+	return 0;
 }
-#endif
 
 static void
 ahd_linux_pci_dev_remove(struct pci_dev *pdev)
@@ -224,13 +204,14 @@ ahd_linux_pci_dev_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return (0);
 }
 
+static SIMPLE_DEV_PM_OPS(ahd_linux_pci_dev_pm_ops,
+			 ahd_linux_pci_dev_suspend,
+			 ahd_linux_pci_dev_resume);
+
 static struct pci_driver aic79xx_pci_driver = {
 	.name		= "aic79xx",
 	.probe		= ahd_linux_pci_dev_probe,
-#ifdef CONFIG_PM
-	.suspend	= ahd_linux_pci_dev_suspend,
-	.resume		= ahd_linux_pci_dev_resume,
-#endif
+	.driver.pm	= &ahd_linux_pci_dev_pm_ops,
 	.remove		= ahd_linux_pci_dev_remove,
 	.id_table	= ahd_linux_pci_id_table
 };
diff --git a/drivers/scsi/aic7xxx/aic79xx_pci.c b/drivers/scsi/aic7xxx/aic79xx_pci.c
index 8397ae93f7dd..2f0bdb9225a4 100644
--- a/drivers/scsi/aic7xxx/aic79xx_pci.c
+++ b/drivers/scsi/aic7xxx/aic79xx_pci.c
@@ -377,8 +377,7 @@ ahd_pci_config(struct ahd_softc *ahd, const struct ahd_pci_identity *entry)
 	return ahd_pci_map_int(ahd);
 }
 
-#ifdef CONFIG_PM
-void
+void __maybe_unused
 ahd_pci_suspend(struct ahd_softc *ahd)
 {
 	/*
@@ -394,7 +393,7 @@ ahd_pci_suspend(struct ahd_softc *ahd)
 
 }
 
-void
+void __maybe_unused
 ahd_pci_resume(struct ahd_softc *ahd)
 {
 	ahd_pci_write_config(ahd->dev_softc, DEVCONFIG,
@@ -404,7 +403,6 @@ ahd_pci_resume(struct ahd_softc *ahd)
 	ahd_pci_write_config(ahd->dev_softc, CSIZE_LATTIME,
 			     ahd->suspend_state.pci_state.csize_lattime, /*bytes*/1);
 }
-#endif
 
 /*
  * Perform some simple tests that should catch situations where
-- 
2.28.0

