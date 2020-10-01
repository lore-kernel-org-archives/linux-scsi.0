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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95F25C4741F
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 12:32:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D26021D24
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 12:32:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sawYFsfH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732258AbgJAMck (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Oct 2020 08:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731936AbgJAMck (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2020 08:32:40 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F06AC0613D0;
        Thu,  1 Oct 2020 05:32:40 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id o20so4322558pfp.11;
        Thu, 01 Oct 2020 05:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ah9td3sQ1fIG5lGgCqIwhgoKZucLujwVmdH4oNX5u+s=;
        b=sawYFsfHVBmfVwr+8fNWhC16ZKZ6OBox2c8ppWrTzorUUdPDBeJBdRRly59vUZbXbK
         kLjuXCWBnMg0M8PnQAmCBDTqNBd1d6GLYOFnXbcrzcc3J2674k0q8PTBEIR5gNHahrqK
         aBIcrsF0Ibdpa9wRCMLQmGcXPs/TO3tgx4nGT5qklHD+Mu0akXCdnJAblTDIUncJThJZ
         6yEK/heNpQA2ViatN8s/jZqNijZB2tov3kIqiCZgjzyRQMa2KHbNdb0/nL3IK9tjVnbJ
         4RRredMZ/kPZMqfxVugAMebdjTJSQuuBkvF1xyID+YfLuackkR3X2utwQ15gnFTW2VlA
         N9og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ah9td3sQ1fIG5lGgCqIwhgoKZucLujwVmdH4oNX5u+s=;
        b=tgFfF7DZccoJQWMY2yJfri5AoIP6niRgmTcycJPE80fiObVKzU8rWB2j+sHE63kaAj
         N5rQ2a2O4zUkncVTlGkuf7/rvz3Cp6KqQcmxEbPbqVyZ3bd6m+n6bbUfiMV1Km3bLGcw
         xS4lFJl7pq7TXGCopdjTRl/yu7v45p9tAOU8UPrccPZzgtthZUnLOaI1DM3vpBAftSm6
         LYcrS3qJFh0FhWYriqjLi1XQqL8Zt2UKEpirJQMnsk5vxmFOHg6ReJh5vmOB/8Qg+MhO
         HgqqdJMKRlSYjRE9UhEmTKruVEKigqbDyKFRM07qsgDfZL4bn+A/jpIRkTX/N8t/089j
         kt4g==
X-Gm-Message-State: AOAM532F9Sv05Y64onxITDM4yedtWGJtXf2bm39gbwXeiz8qMLxJ3oDZ
        PG+xuB7XCsowU7Ay4uroq6I=
X-Google-Smtp-Source: ABdhPJzyjl54g6Q+QzgIlbEPt15+tLx1HeyZRUimL2hMqFHVnu7+yHGefhiyhB9n9iU+7NHCnLsMPA==
X-Received: by 2002:a17:902:b688:b029:d2:43a9:ef1f with SMTP id c8-20020a170902b688b02900d243a9ef1fmr7169860pls.9.1601555559931;
        Thu, 01 Oct 2020 05:32:39 -0700 (PDT)
Received: from varodek.localdomain ([171.61.143.130])
        by smtp.gmail.com with ESMTPSA id m13sm5695199pjl.45.2020.10.01.05.32.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 05:32:39 -0700 (PDT)
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
Subject: [PATCH v3 28/28] scsi: pmcraid: use generic power management
Date:   Thu,  1 Oct 2020 17:55:11 +0530
Message-Id: <20201001122511.1075420-29-vaibhavgupta40@gmail.com>
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
 drivers/scsi/pmcraid.c | 43 ++++++++++--------------------------------
 1 file changed, 10 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 7674b8481f35..bbf7fc8d5a2c 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -5237,53 +5237,37 @@ static void pmcraid_remove(struct pci_dev *pdev)
 	return;
 }
 
-#ifdef CONFIG_PM
 /**
  * pmcraid_suspend - driver suspend entry point for power management
- * @pdev:   PCI device structure
- * @state:  PCI power state to suspend routine
+ * @dev:   Device structure
  *
  * Return Value - 0 always
  */
-static int pmcraid_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused pmcraid_suspend(struct device *dev)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
 	struct pmcraid_instance *pinstance = pci_get_drvdata(pdev);
 
 	pmcraid_shutdown(pdev);
 	pmcraid_disable_interrupts(pinstance, ~0);
 	pmcraid_kill_tasklets(pinstance);
-	pci_set_drvdata(pinstance->pdev, pinstance);
 	pmcraid_unregister_interrupt_handler(pinstance);
-	pci_save_state(pdev);
-	pci_disable_device(pdev);
-	pci_set_power_state(pdev, pci_choose_state(pdev, state));
 
 	return 0;
 }
 
 /**
  * pmcraid_resume - driver resume entry point PCI power management
- * @pdev: PCI device structure
+ * @dev: Device structure
  *
  * Return Value - 0 in case of success. Error code in case of any failure
  */
-static int pmcraid_resume(struct pci_dev *pdev)
+static int __maybe_unused pmcraid_resume(struct device *dev)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
 	struct pmcraid_instance *pinstance = pci_get_drvdata(pdev);
 	struct Scsi_Host *host = pinstance->host;
-	int rc;
-
-	pci_set_power_state(pdev, PCI_D0);
-	pci_restore_state(pdev);
-
-	rc = pci_enable_device(pdev);
-
-	if (rc) {
-		dev_err(&pdev->dev, "resume: Enable device failed\n");
-		return rc;
-	}
-
-	pci_set_master(pdev);
+	int rc = 0;
 
 	if (sizeof(dma_addr_t) == 4 ||
 	    dma_set_mask(&pdev->dev, DMA_BIT_MASK(64)))
@@ -5336,18 +5320,10 @@ static int pmcraid_resume(struct pci_dev *pdev)
 	scsi_host_put(host);
 
 disable_device:
-	pci_disable_device(pdev);
 
 	return rc;
 }
 
-#else
-
-#define pmcraid_suspend NULL
-#define pmcraid_resume  NULL
-
-#endif /* CONFIG_PM */
-
 /**
  * pmcraid_complete_ioa_reset - Called by either timer or tasklet during
  *				completion of the ioa reset
@@ -5835,6 +5811,8 @@ static int pmcraid_probe(struct pci_dev *pdev,
 	return -ENODEV;
 }
 
+static SIMPLE_DEV_PM_OPS(pmcraid_pm_ops, pmcraid_suspend, pmcraid_resume);
+
 /*
  * PCI driver structure of pmcraid driver
  */
@@ -5843,8 +5821,7 @@ static struct pci_driver pmcraid_driver = {
 	.id_table = pmcraid_pci_table,
 	.probe = pmcraid_probe,
 	.remove = pmcraid_remove,
-	.suspend = pmcraid_suspend,
-	.resume = pmcraid_resume,
+	.driver.pm = &pmcraid_pm_ops,
 	.shutdown = pmcraid_shutdown
 };
 
-- 
2.28.0

