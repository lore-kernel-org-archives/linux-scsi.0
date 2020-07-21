Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC06CC433E6
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 14:29:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79B192070A
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 14:29:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ou5FVj28"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728850AbgGUO3z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 10:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728600AbgGUO3y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 10:29:54 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2999CC061794;
        Tue, 21 Jul 2020 07:29:54 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id t6so10342916plo.3;
        Tue, 21 Jul 2020 07:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iYRfseGRxkJSGBtUZrlfdzVPtZz70c1cd/TpTdawABc=;
        b=Ou5FVj28l09vBKNJZNt4QUXmA+4vLyTrzid6vPpuOiFc+adui65+VP3JRRjRVYHDo7
         hSSr8r1sqqve1WHaDIvwW1ydEWCDTZRYF713dbR/n15CRRkyfXP8ycjLgAjPCcFoEHVd
         wOjv8A5OgNTJzbwPXFGrTL2YlkOmi1h98zOY9cb8C/K53thbI4yao5nSkha5d5eyDW9v
         d/kK6tnes3rcNeiEfEUINdNS6t6TAzAFc6qXEVCneCE5zQ/LOf6n6qYgjlFMmx2oPpZN
         ANVdv4mqhhUFWoqf8co6usvf/C3CjTpdOZ1dr4rS7Kwe+Usy/M6JJeszH+o8BDtXXwz4
         10Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iYRfseGRxkJSGBtUZrlfdzVPtZz70c1cd/TpTdawABc=;
        b=ZJS/9rSjjIYPe+d3W5cyH5NONmNA9NYv7q9AjlyNYaYN4rcVv5BJDSoK9hJMdySoCB
         PlRZAyVbvGlM3dlYOFCOZW+aEjKxm3e+vsGz6m3GcexCP8MfeZo7VwVhNON4iXXN2uMI
         +cX2mAi2ecvDw0gmtDyga+GBDUYLoFZPsQX17bslu4gyyi/t6sxOl6zhQMothSZZy804
         Kr3yPkqUNW0bhq7gd5K8NmPzYrrftpHBBW7PXmSRY3XbvuYUlpnZwBD3jY9gLXz6Iia5
         tz3xOYZ3nqrDV2o0Aywar4CRqRDwybV3WY1Pgxn+jKQNwY7tTtjGAbG5Gtootf51ON6C
         UrjA==
X-Gm-Message-State: AOAM532NT0kYt3+8bqzrAulHpLNa8qtRb69OKQXKDEL5fK9MYEYurHJD
        l9gnf0LYWCkWqApUGAz2DoA=
X-Google-Smtp-Source: ABdhPJzqgWbje16rxCbMRkXzILc7Zzq9h1cQGSe9ZmJjCxeYFKDKk/oLlrn9Ss6vfhukJQdSHmBipQ==
X-Received: by 2002:a17:902:8206:: with SMTP id x6mr23010963pln.328.1595341793513;
        Tue, 21 Jul 2020 07:29:53 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.67])
        by smtp.gmail.com with ESMTPSA id y80sm20252309pfb.165.2020.07.21.07.27.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 07:29:52 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH v1] mptfusion: use generic power management
Date:   Tue, 21 Jul 2020 19:54:24 +0530
Message-Id: <20200721142423.304231-1-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
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
helper functions and device power state control functions as through
the generic framework, PCI Core takes care of the necessary operations,
and drivers are required to do only device-specific jobs.

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/message/fusion/mptbase.c  | 36 +++++++++++--------------------
 drivers/message/fusion/mptbase.h  |  7 +++---
 drivers/message/fusion/mptfc.c    |  5 +----
 drivers/message/fusion/mptsas.c   |  5 +----
 drivers/message/fusion/mptscsih.c | 36 +++++++++++++++----------------
 drivers/message/fusion/mptscsih.h |  7 +++---
 drivers/message/fusion/mptspi.c   | 26 +++++++++++++---------
 7 files changed, 53 insertions(+), 69 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 5216487db4fb..13a839c855a1 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -2139,23 +2139,19 @@ mpt_detach(struct pci_dev *pdev)
 /**************************************************************************
  * Power Management
  */
-#ifdef CONFIG_PM
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
  *	mpt_suspend - Fusion MPT base driver suspend routine.
- *	@pdev: Pointer to pci_dev structure
- *	@state: new state to enter
+ *	@dev: Pointer to device structure
  */
-int
-mpt_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused
+mpt_suspend(struct device *dev)
 {
-	u32 device_state;
+	struct pci_dev *pdev = to_pci_dev(dev);
 	MPT_ADAPTER *ioc = pci_get_drvdata(pdev);
 
-	device_state = pci_choose_state(pdev, state);
 	printk(MYIOC_s_INFO_FMT "pci-suspend: pdev=0x%p, slot=%s, Entering "
-	    "operating state [D%d]\n", ioc->name, pdev, pci_name(pdev),
-	    device_state);
+	    "suspend state\n", ioc->name, pdev, pci_name(pdev));
 
 	/* put ioc into READY_STATE */
 	if (SendIocReset(ioc, MPI_FUNCTION_IOC_MESSAGE_UNIT_RESET, CAN_SLEEP)) {
@@ -2174,21 +2170,18 @@ mpt_suspend(struct pci_dev *pdev, pm_message_t state)
 	if (ioc->msi_enable)
 		pci_disable_msi(ioc->pcidev);
 	ioc->pci_irq = -1;
-	pci_save_state(pdev);
-	pci_disable_device(pdev);
-	pci_release_selected_regions(pdev, ioc->bars);
-	pci_set_power_state(pdev, device_state);
 	return 0;
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
  *	mpt_resume - Fusion MPT base driver resume routine.
- *	@pdev: Pointer to pci_dev structure
+ *	@dev: Pointer to device structure
  */
-int
-mpt_resume(struct pci_dev *pdev)
+static int __maybe_unused
+mpt_resume(struct device *dev)
 {
+	struct pci_dev *pdev = to_pci_dev(dev);
 	MPT_ADAPTER *ioc = pci_get_drvdata(pdev);
 	u32 device_state = pdev->current_state;
 	int recovery_state;
@@ -2198,9 +2191,6 @@ mpt_resume(struct pci_dev *pdev)
 	    "operating state [D%d]\n", ioc->name, pdev, pci_name(pdev),
 	    device_state);
 
-	pci_set_power_state(pdev, PCI_D0);
-	pci_enable_wake(pdev, PCI_D0, 0);
-	pci_restore_state(pdev);
 	ioc->pcidev = pdev;
 	err = mpt_mapresources(ioc);
 	if (err)
@@ -2256,7 +2246,9 @@ mpt_resume(struct pci_dev *pdev)
 	return 0;
 
 }
-#endif
+
+SIMPLE_DEV_PM_OPS(mpt_pm_ops, mpt_suspend, mpt_resume);
+EXPORT_SYMBOL(mpt_pm_ops);
 
 static int
 mpt_signal_reset(u8 index, MPT_ADAPTER *ioc, int reset_phase)
@@ -8440,10 +8432,6 @@ mpt_iocstatus_info(MPT_ADAPTER *ioc, u32 ioc_status, MPT_FRAME_HDR *mf)
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 EXPORT_SYMBOL(mpt_attach);
 EXPORT_SYMBOL(mpt_detach);
-#ifdef CONFIG_PM
-EXPORT_SYMBOL(mpt_resume);
-EXPORT_SYMBOL(mpt_suspend);
-#endif
 EXPORT_SYMBOL(ioc_list);
 EXPORT_SYMBOL(mpt_register);
 EXPORT_SYMBOL(mpt_deregister);
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index 813d46311f6a..b4ae350acd6c 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -909,10 +909,9 @@ typedef struct _x_config_parms {
  */
 extern int	 mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id);
 extern void	 mpt_detach(struct pci_dev *pdev);
-#ifdef CONFIG_PM
-extern int	 mpt_suspend(struct pci_dev *pdev, pm_message_t state);
-extern int	 mpt_resume(struct pci_dev *pdev);
-#endif
+
+extern const struct dev_pm_ops mpt_pm_ops;
+
 extern u8	 mpt_register(MPT_CALLBACK cbfunc, MPT_DRIVER_CLASS dclass,
 		char *func_name);
 extern void	 mpt_deregister(u8 cb_idx);
diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index 4314a3352b96..5aae60bdd6c4 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -1357,10 +1357,7 @@ static struct pci_driver mptfc_driver = {
 	.probe		= mptfc_probe,
 	.remove		= mptfc_remove,
 	.shutdown	= mptscsih_shutdown,
-#ifdef CONFIG_PM
-	.suspend	= mptscsih_suspend,
-	.resume		= mptscsih_resume,
-#endif
+	.driver.pm	= &mptscsih_pm_ops,
 };
 
 static int
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 6a79cd0ebe2b..158b59336b8f 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -5376,10 +5376,7 @@ static struct pci_driver mptsas_driver = {
 	.probe		= mptsas_probe,
 	.remove		= mptsas_remove,
 	.shutdown	= mptsas_shutdown,
-#ifdef CONFIG_PM
-	.suspend	= mptscsih_suspend,
-	.resume		= mptscsih_resume,
-#endif
+	.driver.pm	= &mptscsih_pm_ops,
 };
 
 static int __init
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 1491561d2e5c..2861e51841da 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -113,10 +113,12 @@ mptscsih_taskmgmt_reply(MPT_ADAPTER *ioc, u8 type,
 				SCSITaskMgmtReply_t *pScsiTmReply);
 void 		mptscsih_remove(struct pci_dev *);
 void 		mptscsih_shutdown(struct pci_dev *);
-#ifdef CONFIG_PM
-int 		mptscsih_suspend(struct pci_dev *pdev, pm_message_t state);
-int 		mptscsih_resume(struct pci_dev *pdev);
-#endif
+
+static int __maybe_unused
+mptscsih_suspend(struct device *dev);
+
+static int __maybe_unused
+mptscsih_resume(struct device *dev);
 
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -1215,22 +1217,21 @@ mptscsih_shutdown(struct pci_dev *pdev)
 {
 }
 
-#ifdef CONFIG_PM
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*
  *	mptscsih_suspend - Fusion MPT scsi driver suspend routine.
  *
  *
  */
-int
-mptscsih_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused
+mptscsih_suspend(struct device *dev)
 {
-	MPT_ADAPTER 		*ioc = pci_get_drvdata(pdev);
+	MPT_ADAPTER 		*ioc = dev_get_drvdata(dev);
 
 	scsi_block_requests(ioc->sh);
 	flush_scheduled_work();
-	mptscsih_shutdown(pdev);
-	return mpt_suspend(pdev,state);
+	mptscsih_shutdown(to_pci_dev(dev));
+	return mpt_pm_ops.suspend(dev);
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -1239,18 +1240,19 @@ mptscsih_suspend(struct pci_dev *pdev, pm_message_t state)
  *
  *
  */
-int
-mptscsih_resume(struct pci_dev *pdev)
+static int __maybe_unused
+mptscsih_resume(struct device *dev)
 {
-	MPT_ADAPTER 		*ioc = pci_get_drvdata(pdev);
+	MPT_ADAPTER 		*ioc = dev_get_drvdata(dev);
 	int rc;
 
-	rc = mpt_resume(pdev);
+	rc = mpt_pm_ops.resume(dev);
 	scsi_unblock_requests(ioc->sh);
 	return rc;
 }
 
-#endif
+SIMPLE_DEV_PM_OPS(mptscsih_pm_ops, mptscsih_suspend, mptscsih_resume);
+EXPORT_SYMBOL(mptscsih_pm_ops);
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
@@ -3236,10 +3238,6 @@ EXPORT_SYMBOL(mptscsih_host_attrs);
 
 EXPORT_SYMBOL(mptscsih_remove);
 EXPORT_SYMBOL(mptscsih_shutdown);
-#ifdef CONFIG_PM
-EXPORT_SYMBOL(mptscsih_suspend);
-EXPORT_SYMBOL(mptscsih_resume);
-#endif
 EXPORT_SYMBOL(mptscsih_show_info);
 EXPORT_SYMBOL(mptscsih_info);
 EXPORT_SYMBOL(mptscsih_qcmd);
diff --git a/drivers/message/fusion/mptscsih.h b/drivers/message/fusion/mptscsih.h
index 2baeefd9be7a..57ebb22977ee 100644
--- a/drivers/message/fusion/mptscsih.h
+++ b/drivers/message/fusion/mptscsih.h
@@ -107,10 +107,9 @@ typedef struct _internal_cmd {
 
 extern void mptscsih_remove(struct pci_dev *);
 extern void mptscsih_shutdown(struct pci_dev *);
-#ifdef CONFIG_PM
-extern int mptscsih_suspend(struct pci_dev *pdev, pm_message_t state);
-extern int mptscsih_resume(struct pci_dev *pdev);
-#endif
+
+extern const struct dev_pm_ops mptscsih_pm_ops;
+
 extern int mptscsih_show_info(struct seq_file *, struct Scsi_Host *);
 extern const char * mptscsih_info(struct Scsi_Host *SChost);
 extern int mptscsih_qcmd(struct scsi_cmnd *SCpnt);
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index eabc4de5816c..19994d5d034c 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -1321,23 +1321,30 @@ mptspi_ioc_reset(MPT_ADAPTER *ioc, int reset_phase)
 	return rc;
 }
 
-#ifdef CONFIG_PM
+/*
+ * spi module suspend handler
+ */
+static int __maybe_unused
+mptspi_suspend(struct device *dev)
+{
+	return mptscsih_pm_ops.suspend(dev);
+}
+
 /*
  * spi module resume handler
  */
-static int
-mptspi_resume(struct pci_dev *pdev)
+static int __maybe_unused
+mptspi_resume(struct device *dev)
 {
-	MPT_ADAPTER 	*ioc = pci_get_drvdata(pdev);
+	MPT_ADAPTER 	*ioc = dev_get_drvdata(dev);
 	struct _MPT_SCSI_HOST *hd = shost_priv(ioc->sh);
 	int rc;
 
-	rc = mptscsih_resume(pdev);
+	rc = mptscsih_pm_ops.resume(dev);
 	mptspi_dv_renegotiate(hd);
 
 	return rc;
 }
-#endif
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -1550,16 +1557,15 @@ static void mptspi_remove(struct pci_dev *pdev)
 	mptscsih_remove(pdev);
 }
 
+static SIMPLE_DEV_PM_OPS(mptspi_pm_ops, mptspi_suspend, mptspi_resume);
+
 static struct pci_driver mptspi_driver = {
 	.name		= "mptspi",
 	.id_table	= mptspi_pci_table,
 	.probe		= mptspi_probe,
 	.remove		= mptspi_remove,
 	.shutdown	= mptscsih_shutdown,
-#ifdef CONFIG_PM
-	.suspend	= mptscsih_suspend,
-	.resume		= mptspi_resume,
-#endif
+	.driver.pm	= &mptspi_pm_ops,
 };
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-- 
2.27.0

