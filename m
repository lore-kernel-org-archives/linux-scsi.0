Return-Path: <SRS0=33X3=DI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1096C47420
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 12:29:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61D5321707
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 12:29:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GR8utQ6K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732242AbgJAM27 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Oct 2020 08:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731952AbgJAM27 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2020 08:28:59 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E7AC0613D0;
        Thu,  1 Oct 2020 05:28:58 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id v14so1787367pjd.4;
        Thu, 01 Oct 2020 05:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mVOjXEKkfZyVO1Nq7xgMnj9Ub/DFSexPEpxry6WmpFc=;
        b=GR8utQ6Kl0t0pzV+SidY8CU1m87lKEvg+HQ6OMuHmDLX0hfhHYLNWdTbltLemaEGO7
         stOH4lQNsrpTMsvnpTIEle0bbqA/hGO0MG6BxSe4GyT19dmG4JT79CPT3Z7A28Qsjfk3
         UVSMrDiPwYi7n48VyY66YDybpu0Zx25AA0bOVDFVPeCv1SfpDng4xYPxtbZVCg1RTEDk
         PTsapRjJ37CQZSEIwpO40Y7l5/pkjN5+ZVChWeAEzeqJs/YjuyKFgIuaBXgGEqh84KFQ
         PJf+eR/qnCJ3kG1Uaxq2R2VvwDMmX1ueWR9ZLG0fkGwaqS8qfle/zt0CX+1fiIrUt8FB
         lwCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mVOjXEKkfZyVO1Nq7xgMnj9Ub/DFSexPEpxry6WmpFc=;
        b=QVqGGW0ZrT4YMTwUgDSccMtXaBk2AfCYzQH7Y5PfYy7xuxa+pE9Cy52FkkeyqZp9Zm
         TFGhXnPo0IpgO6NmyaoyMDNC0HSZ9rMgexhvM+tN42ZkAG95vnzsr6zavij0gBQEY5Pn
         FB8db3PBDy02D2Cu4/ZSgBo9a1tLj0AYZySvCEZ3qHOPwuP9QwplQzYnf/Jt/Pvcg9H1
         4Gn058pva4THZyv4ZjNIYprVzf89GbrP0fUcNEZmBHUGG/uervi+pX2rUXzPBzfJCuWA
         cqNjlzcSXXlOci/rusx9EPa2i+EzTjEFheiqOldwtTGEhkgpfY29lycWVyvfT2Zz4GVt
         5JjQ==
X-Gm-Message-State: AOAM5300mhf0KEUaBu5aJC/EPej8ZJwgJObfyNrfdjh9N+Yy2J+zzwWp
        USnfT8VBr2xrC5fKrJo9FCo=
X-Google-Smtp-Source: ABdhPJwjjEy6svQpFdYpn9f4L4Tzu+FutlqW8hTSvgj9ExQD35LeiMkVBZJFqbliBzWc1yUOi3OjdQ==
X-Received: by 2002:a17:90b:ecc:: with SMTP id gz12mr6649534pjb.219.1601555338113;
        Thu, 01 Oct 2020 05:28:58 -0700 (PDT)
Received: from varodek.localdomain ([171.61.143.130])
        by smtp.gmail.com with ESMTPSA id m13sm5695199pjl.45.2020.10.01.05.28.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 05:28:57 -0700 (PDT)
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
Subject: [PATCH v3 07/28] scsi: aic79xx: use generic power management
Date:   Thu,  1 Oct 2020 17:54:50 +0530
Message-Id: <20201001122511.1075420-8-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201001122511.1075420-1-vaibhavgupta40@gmail.com>
References: <20201001122511.1075420-1-vaibhavgupta40@gmail.com>
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
index e4a09b93d00c..06ee7abd0f8f 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -7880,11 +7880,9 @@ ahd_pause_and_flushwork(struct ahd_softc *ahd)
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
@@ -7895,15 +7893,13 @@ ahd_suspend(struct ahd_softc *ahd)
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

