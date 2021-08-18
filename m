Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MIME_HEADER_CTYPE_ONLY,
	MIME_NO_TEXT,SPF_HELO_NONE,SPF_PASS,T_TVD_MIME_NO_HEADERS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C50BC4338F
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 08:17:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83D1360295
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Aug 2021 08:17:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239643AbhHRISB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Aug 2021 04:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240279AbhHRISA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Aug 2021 04:18:00 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C61C061764
        for <linux-scsi@vger.kernel.org>; Wed, 18 Aug 2021 01:17:25 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id q2so1466016pgt.6
        for <linux-scsi@vger.kernel.org>; Wed, 18 Aug 2021 01:17:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=MZJCmJK0IBB/67cEkzv6t+QUv3jCCpNkFqYRXwQE5Ms=;
        b=cwd9Tj5uI42a2Up467O+UfKoNn4WkLA66ucOgSnjUvbQMLUB+sRQi7k5j+92sJFzCN
         Anoqsi6wESpzEb6jLTtiiv6JOBBVDn8H4xnBBSMcFez2d3uVlQwncmDu4Nhu77eOxH9W
         kwRGz7VNewi4uxfQWExqN9GvjLq3w2iRWliGQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=MZJCmJK0IBB/67cEkzv6t+QUv3jCCpNkFqYRXwQE5Ms=;
        b=LWKHJkAo9dOaecvSp5bCdwEfoDnWoGLQIqQOqj39YSXSbIJ+eZ0FIpIfUt4d0kxgh6
         kzSR2z+UQQxmjUI7RfzC/Yb4cCqUUIwvyfklLxwADwGL/CO9NiQCwvRX3zCX8Wip8s23
         c4nMY+TXObMnKHrFsariSl9/+gNKao00luowQi9tM0a6Nm3fJKtEnu9I1JPhjQa/lT4q
         g8wLY4EExVmqTn043X6BIJpqtyvtU78SwIFyCAgFCb16L4RJHWiFqRWPWJP5aExsmzh1
         XSk6bpIFPWb2411FozKPiUrY/r4nkNbVvTH355AfadZkjdviWk1qJQQZjYvPMrI0JsVK
         rm4w==
X-Gm-Message-State: AOAM533+Ei1aYDmB2NW0DJbWeGEq+uomzrIglnKTVEIfq1SqYqenmMIB
        35DK96SPDsfyFHf2HAXHwxf8/dKpjr6D+pT09ABf3pCFzTvZ/fwuGae8NwraUHxGSc1t6AdLCGL
        jpw4vzBoYPCQwsbr50i6m8M8ST+QYcZr4s43Gsqj5Exk9IUm2xqyV3ehrXpgZoZR7RBhjfwzX5X
        lUWDBSNyIt
X-Google-Smtp-Source: ABdhPJyT+3XOtoDi1qahw/XYv2AqdWfHBjNRia5Skd/ZFFPVvIc/hsW0F0HrYCH9EDBVunHEm8qysg==
X-Received: by 2002:a62:b60d:0:b029:3cb:1cb2:f856 with SMTP id j13-20020a62b60d0000b02903cb1cb2f856mr8184530pff.19.1629274644833;
        Wed, 18 Aug 2021 01:17:24 -0700 (PDT)
Received: from drv-bst-rhel8.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id p17sm4295259pjg.54.2021.08.18.01.17.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 01:17:24 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        mpi3mr-linuxdrv.pdl@broadcom.com,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        sathya.prakash@broadcom.com, thenzl@redhat.com
Subject: [PATCH RESEND] mpi3mr: setup irqs in resume path
Date:   Wed, 18 Aug 2021 13:47:55 +0530
Message-Id: <20210818081755.1274470-1-kashyap.desai@broadcom.com>
X-Mailer: git-send-email 2.18.1
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000078f5c405c9d110f6"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000078f5c405c9d110f6

Issue description - Driver is not setting up irqs in resume path.
Eventually, hibernation path is broken and controller will not be
operational after system is resumed from hibernation.

Fix - Driver should setup irqs in case of probe and hibernation.

Cc: sathya.prakash@broadcom.com
Cc: thenzl@redhat.com
Reported-by: Marco Patalano <mpatalan@redhat.com>
Tested-by: Marco Patalano <mpatalan@redhat.com>
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>

---
 drivers/scsi/mpi3mr/mpi3mr.h    | 21 ++++++++++++++++---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 37 ++++++++++++++++++---------------
 drivers/scsi/mpi3mr/mpi3mr_os.c | 13 ++++++------
 3 files changed, 45 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 6f5dc9e78553..3958841108aa 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -183,6 +183,20 @@ enum mpi3mr_iocstate {
 	MRIOC_STATE_UNRECOVERABLE,
 };
 
+/* Init type definitions */
+enum mpi3mr_init_type {
+	MPI3MR_IT_INIT = 0,
+	MPI3MR_IT_RESET,
+	MPI3MR_IT_RESUME,
+};
+
+/* Cleanup reason definitions */
+enum mpi3mr_cleanup_reason {
+	MPI3MR_COMPLETE_CLEANUP = 0,
+	MPI3MR_REINIT_FAILURE,
+	MPI3MR_SUSPEND,
+};
+
 /* Reset reason code definitions*/
 enum mpi3mr_reset_reason {
 	MPI3MR_RESET_FROM_BRINGUP = 1,
@@ -855,8 +869,8 @@ struct delayed_dev_rmhs_node {
 
 int mpi3mr_setup_resources(struct mpi3mr_ioc *mrioc);
 void mpi3mr_cleanup_resources(struct mpi3mr_ioc *mrioc);
-int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc, u8 re_init);
-void mpi3mr_cleanup_ioc(struct mpi3mr_ioc *mrioc, u8 re_init);
+int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc, u8 init_type);
+void mpi3mr_cleanup_ioc(struct mpi3mr_ioc *mrioc, u8 reason);
 int mpi3mr_issue_port_enable(struct mpi3mr_ioc *mrioc, u8 async);
 int mpi3mr_admin_request_post(struct mpi3mr_ioc *mrioc, void *admin_req,
 u16 admin_req_sz, u8 ignore_reset);
@@ -872,6 +886,7 @@ void *mpi3mr_get_reply_virt_addr(struct mpi3mr_ioc *mrioc,
 void mpi3mr_repost_sense_buf(struct mpi3mr_ioc *mrioc,
 				     u64 sense_buf_dma);
 
+void mpi3mr_memset_buffers(struct mpi3mr_ioc *mrioc);
 void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
 			     struct mpi3_event_notification_reply *event_reply);
 void mpi3mr_process_op_reply_desc(struct mpi3mr_ioc *mrioc,
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 9eceafca59bc..551edeac1040 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -3206,7 +3206,7 @@ int mpi3mr_setup_resources(struct mpi3mr_ioc *mrioc)
 /**
  * mpi3mr_init_ioc - Initialize the controller
  * @mrioc: Adapter instance reference
- * @re_init: Flag to indicate is this fresh init or re-init
+ * @init_type: Flag to indicate is the init_type
  *
  * This the controller initialization routine, executed either
  * after soft reset or from pci probe callback.
@@ -3219,7 +3219,7 @@ int mpi3mr_setup_resources(struct mpi3mr_ioc *mrioc)
  *
  * Return: 0 on success and non-zero on failure.
  */
-int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc, u8 re_init)
+int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc, u8 init_type)
 {
 	int retval = 0;
 	enum mpi3mr_iocstate ioc_state;
@@ -3230,7 +3230,7 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc, u8 re_init)
 
 	mrioc->irqpoll_sleep = MPI3MR_IRQ_POLL_SLEEP;
 	mrioc->change_count = 0;
-	if (!re_init) {
+	if (init_type == MPI3MR_IT_INIT) {
 		mrioc->cpu_count = num_online_cpus();
 		retval = mpi3mr_setup_resources(mrioc);
 		if (retval) {
@@ -3315,7 +3315,7 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc, u8 re_init)
 		goto out_failed;
 	}
 
-	if (!re_init) {
+	if (init_type != MPI3MR_IT_RESET) {
 		retval = mpi3mr_setup_isr(mrioc, 1);
 		if (retval) {
 			ioc_err(mrioc, "Failed to setup ISR error %d\n",
@@ -3333,7 +3333,7 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc, u8 re_init)
 	}
 
 	mpi3mr_process_factsdata(mrioc, &facts_data);
-	if (!re_init) {
+	if (init_type == MPI3MR_IT_INIT) {
 		retval = mpi3mr_check_reset_dma_mask(mrioc);
 		if (retval) {
 			ioc_err(mrioc, "Resetting dma mask failed %d\n",
@@ -3352,7 +3352,7 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc, u8 re_init)
 		goto out_failed;
 	}
 
-	if (!re_init) {
+	if (init_type == MPI3MR_IT_INIT) {
 		retval = mpi3mr_alloc_chain_bufs(mrioc);
 		if (retval) {
 			ioc_err(mrioc, "Failed to allocated chain buffers %d\n",
@@ -3375,7 +3375,7 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc, u8 re_init)
 	writel(mrioc->sbq_host_index,
 	    &mrioc->sysif_regs->sense_buffer_free_host_index);
 
-	if (!re_init)  {
+	if (init_type != MPI3MR_IT_RESET) {
 		retval = mpi3mr_setup_isr(mrioc, 0);
 		if (retval) {
 			ioc_err(mrioc, "Failed to re-setup ISR, error %d\n",
@@ -3391,7 +3391,7 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc, u8 re_init)
 		goto out_failed;
 	}
 
-	if (re_init &&
+	if ((init_type != MPI3MR_IT_INIT) &&
 	    (mrioc->shost->nr_hw_queues > mrioc->num_op_reply_q)) {
 		retval = -1;
 		ioc_err(mrioc,
@@ -3423,7 +3423,7 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc, u8 re_init)
 		goto out_failed;
 	}
 
-	if (re_init) {
+	if (init_type != MPI3MR_IT_INIT) {
 		ioc_info(mrioc, "Issuing Port Enable\n");
 		retval = mpi3mr_issue_port_enable(mrioc, 0);
 		if (retval) {
@@ -3435,7 +3435,10 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc, u8 re_init)
 	return retval;
 
 out_failed:
-	mpi3mr_cleanup_ioc(mrioc, re_init);
+	if (init_type == MPI3MR_IT_INIT)
+		mpi3mr_cleanup_ioc(mrioc, MPI3MR_COMPLETE_CLEANUP);
+	else
+		mpi3mr_cleanup_ioc(mrioc, MPI3MR_REINIT_FAILURE);
 out_nocleanup:
 	return retval;
 }
@@ -3496,7 +3499,7 @@ static void mpi3mr_memset_op_req_q_buffers(struct mpi3mr_ioc *mrioc, u16 qidx)
  *
  * Return: Nothing.
  */
-static void mpi3mr_memset_buffers(struct mpi3mr_ioc *mrioc)
+void mpi3mr_memset_buffers(struct mpi3mr_ioc *mrioc)
 {
 	u16 i;
 
@@ -3711,7 +3714,7 @@ static void mpi3mr_issue_ioc_shutdown(struct mpi3mr_ioc *mrioc)
 /**
  * mpi3mr_cleanup_ioc - Cleanup controller
  * @mrioc: Adapter instance reference
- * @re_init: Cleanup due to a reinit or not
+ * @reason: Cleanup reason
  *
  * controller cleanup handler, Message unit reset or soft reset
  * and shutdown notification is issued to the controller and the
@@ -3719,11 +3722,11 @@ static void mpi3mr_issue_ioc_shutdown(struct mpi3mr_ioc *mrioc)
  *
  * Return: Nothing.
  */
-void mpi3mr_cleanup_ioc(struct mpi3mr_ioc *mrioc, u8 re_init)
+void mpi3mr_cleanup_ioc(struct mpi3mr_ioc *mrioc, u8 reason)
 {
 	enum mpi3mr_iocstate ioc_state;
 
-	if (!re_init)
+	if (reason == MPI3MR_COMPLETE_CLEANUP)
 		mpi3mr_stop_watchdog(mrioc);
 
 	mpi3mr_ioc_disable_intr(mrioc);
@@ -3738,11 +3741,11 @@ void mpi3mr_cleanup_ioc(struct mpi3mr_ioc *mrioc, u8 re_init)
 			    MPI3_SYSIF_HOST_DIAG_RESET_ACTION_SOFT_RESET,
 			    MPI3MR_RESET_FROM_MUR_FAILURE);
 
-		if (!re_init)
+		if (reason != MPI3MR_REINIT_FAILURE)
 			mpi3mr_issue_ioc_shutdown(mrioc);
 	}
 
-	if (!re_init) {
+	if (reason == MPI3MR_COMPLETE_CLEANUP) {
 		mpi3mr_free_mem(mrioc);
 		mpi3mr_cleanup_resources(mrioc);
 	}
@@ -3924,7 +3927,7 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 	mpi3mr_flush_host_io(mrioc);
 	mpi3mr_invalidate_devhandles(mrioc);
 	mpi3mr_memset_buffers(mrioc);
-	retval = mpi3mr_init_ioc(mrioc, 1);
+	retval = mpi3mr_init_ioc(mrioc, MPI3MR_IT_RESET);
 	if (retval) {
 		pr_err(IOCNAME "reinit after soft reset failed: reason %d\n",
 		    mrioc->name, reset_reason);
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 24ac7ddec749..b092fc52d884 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -3795,7 +3795,7 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	mrioc->is_driver_loading = 1;
-	if (mpi3mr_init_ioc(mrioc, 0)) {
+	if (mpi3mr_init_ioc(mrioc, MPI3MR_IT_INIT)) {
 		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
 		    __FILE__, __LINE__, __func__);
 		retval = -ENODEV;
@@ -3818,7 +3818,7 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return retval;
 
 addhost_failed:
-	mpi3mr_cleanup_ioc(mrioc, 0);
+	mpi3mr_cleanup_ioc(mrioc, MPI3MR_COMPLETE_CLEANUP);
 out_iocinit_failed:
 	destroy_workqueue(mrioc->fwevt_worker_thread);
 out_fwevtthread_failed:
@@ -3870,7 +3870,7 @@ static void mpi3mr_remove(struct pci_dev *pdev)
 		mpi3mr_tgtdev_del_from_list(mrioc, tgtdev);
 		mpi3mr_tgtdev_put(tgtdev);
 	}
-	mpi3mr_cleanup_ioc(mrioc, 0);
+	mpi3mr_cleanup_ioc(mrioc, MPI3MR_COMPLETE_CLEANUP);
 
 	spin_lock(&mrioc_list_lock);
 	list_del(&mrioc->list);
@@ -3910,7 +3910,7 @@ static void mpi3mr_shutdown(struct pci_dev *pdev)
 	spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);
 	if (wq)
 		destroy_workqueue(wq);
-	mpi3mr_cleanup_ioc(mrioc, 0);
+	mpi3mr_cleanup_ioc(mrioc, MPI3MR_COMPLETE_CLEANUP);
 }
 
 #ifdef CONFIG_PM
@@ -3940,7 +3940,7 @@ static int mpi3mr_suspend(struct pci_dev *pdev, pm_message_t state)
 	mpi3mr_cleanup_fwevt_list(mrioc);
 	scsi_block_requests(shost);
 	mpi3mr_stop_watchdog(mrioc);
-	mpi3mr_cleanup_ioc(mrioc, 1);
+	mpi3mr_cleanup_ioc(mrioc, MPI3MR_SUSPEND);
 
 	device_state = pci_choose_state(pdev, state);
 	ioc_info(mrioc, "pdev=0x%p, slot=%s, entering operating state [D%d]\n",
@@ -3988,7 +3988,8 @@ static int mpi3mr_resume(struct pci_dev *pdev)
 	}
 
 	mrioc->stop_drv_processing = 0;
-	mpi3mr_init_ioc(mrioc, 1);
+	mpi3mr_memset_buffers(mrioc);
+	mpi3mr_init_ioc(mrioc, MPI3MR_IT_RESUME);
 	scsi_unblock_requests(shost);
 	mpi3mr_start_watchdog(mrioc);
 
-- 
2.18.1


--00000000000078f5c405c9d110f6
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
P3lSxcw4Cg90iKHqfpwLnGNc9AGXHMxUCukpnAHRlivljilKHMx1ymb180BLmtF+ZLm6KrFLQWzB
4KeiUOMtKM13wJrQubqTeZgB1XA+89jeLYlxagVsMyksdwIDAQABo4IB2zCCAdcwDgYDVR0PAQH/
BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3VyZS5nbG9i
YWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEGCCsGAQUF
BzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAy
MDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xv
YmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6hjhodHRw
Oi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNybDAlBgNV
HREEHjAcgRprYXNoeWFwLmRlc2FpQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAf
BgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUkTOZp9jXE3yPj4ieKeDT
OiNyCtswDQYJKoZIhvcNAQELBQADggEBABG1KCh7cLjStywh4S37nKE1eE8KPyAxDzQCkhxYLBVj
gnnhaLmEOayEucPAsM1hCRAm/vR3RQ27lMXBGveCHaq9RZkzTjGSbzr8adOGK3CluPrasNf5StX3
GSk4HwCapA39BDUrhnc/qG5vHwLrgA1jwAvSy8e/vn4F4h+KPrPoFNd1OnCafedbuiEXTqTkn5Rk
vZ2AOTcSbxvmyKBMb/iu1vn7AAoui0d8GYCPoz8shf2iWMSUXVYJAMrtRHVJr47J5jlopF5F2ghC
MzNfx6QsmJhYiRByd8L9sUOjp/DMgkC6H93PyYpYMiBGapgNf6UMsLg/1kx5DATNwhPAJbkxggJt
MIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYD
VQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxwO04DXOeYbZtr
4mAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIK+zxqMUz/V7Fjr3lChUtdPKt7eG
Yfe9hNnxyeE34bM4MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MDgxODA4MTcyNVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQCxtO967Fi/pphcgtt6D1SzpWBi+9no6kd7Qtelg/bEzehk
aPolDZ6tskz+Plbr/81/UA9qObjizArKK1sUD4iqK8yeB/J+DbkRfwQKul+f5+KA1PrrCW833HA+
1fChLUCVVdCFhGgGlY+8ZivTfrxBAbUSiwk/2UdrYp6A6DS7nJ5Q8QTZfvAiG35tmaESNL8hLVlm
O0CUGOKpyPCkBMg2Fy4LfEf/kLQL/TIU3KtKd4oigA3uIx3/s5jq6ZNHaznm30jgpOYd399isal8
szKXoI+u8feMYJx2yctpoDnyDU/KsrGb1SA+mCuzbRCY0ZuvK/Wg/eTwupBh69xKL2/r
--00000000000078f5c405c9d110f6--
