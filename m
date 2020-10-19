Return-Path: <SRS0=6nW3=D2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEB56C43457
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 12:18:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BC1622283
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 12:18:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbgJSMSD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Oct 2020 08:18:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:49276 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726599AbgJSMSA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 19 Oct 2020 08:18:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id ED631AFC4;
        Mon, 19 Oct 2020 12:17:57 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/4] bfa: Remove legacy printk() usage
Date:   Mon, 19 Oct 2020 14:17:53 +0200
Message-Id: <20201019121756.74644-2-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20201019121756.74644-1-hare@suse.de>
References: <20201019121756.74644-1-hare@suse.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replace the remaining callsites to use dev_printk() and friends.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/bfa/bfad.c         | 55 +++++++++++++++++------------------------
 drivers/scsi/bfa/bfad_bsg.c     | 12 +++------
 drivers/scsi/bfa/bfad_debugfs.c | 32 +++++++++---------------
 drivers/scsi/bfa/bfad_drv.h     |  3 +++
 drivers/scsi/bfa/bfad_im.c      | 14 +++++------
 5 files changed, 48 insertions(+), 68 deletions(-)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index 440ef32be048..f350f3154e52 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -170,8 +170,7 @@ bfad_sm_uninit(struct bfad_s *bfad, enum bfad_sm_event event)
 		bfad->bfad_tsk = kthread_create(bfad_worker, (void *) bfad,
 						"%s", "bfad_worker");
 		if (IS_ERR(bfad->bfad_tsk)) {
-			printk(KERN_INFO "bfad[%d]: Kernel thread "
-				"creation failed!\n", bfad->inst_no);
+			BFA_MSG(KERN_INFO, bfad, "Kernel thread creation failed!\n");
 			bfa_sm_send_event(bfad, BFAD_E_KTHREAD_CREATE_FAILED);
 		}
 		bfa_sm_send_event(bfad, BFAD_E_INIT);
@@ -205,8 +204,7 @@ bfad_sm_created(struct bfad_s *bfad, enum bfad_sm_event event)
 
 		/* Enable Interrupt and wait bfa_init completion */
 		if (bfad_setup_intr(bfad)) {
-			printk(KERN_WARNING "bfad%d: bfad_setup_intr failed\n",
-					bfad->inst_no);
+			BFA_MSG(KERN_WARNING, bfad, "bfad_setup_intr failed\n");
 			bfa_sm_send_event(bfad, BFAD_E_INIT_FAILED);
 			break;
 		}
@@ -218,8 +216,7 @@ bfad_sm_created(struct bfad_s *bfad, enum bfad_sm_event event)
 		/* Set up interrupt handler for each vectors */
 		if ((bfad->bfad_flags & BFAD_MSIX_ON) &&
 			bfad_install_msix_handler(bfad)) {
-			printk(KERN_WARNING "%s: install_msix failed, bfad%d\n",
-				__func__, bfad->inst_no);
+			BFA_MSG(KERN_WARNING, bfad, "install_msix failed\n");
 		}
 
 		bfad_init_timer(bfad);
@@ -229,9 +226,7 @@ bfad_sm_created(struct bfad_s *bfad, enum bfad_sm_event event)
 		if ((bfad->bfad_flags & BFAD_HAL_INIT_DONE)) {
 			bfa_sm_send_event(bfad, BFAD_E_INIT_SUCCESS);
 		} else {
-			printk(KERN_WARNING
-				"bfa %s: bfa init failed\n",
-				bfad->pci_name);
+			BFA_MSG(KERN_WARNING, bfad, "bfa init failed\n");
 			spin_lock_irqsave(&bfad->bfad_lock, flags);
 			bfa_fcs_init(&bfad->bfa_fcs);
 			spin_unlock_irqrestore(&bfad->bfad_lock, flags);
@@ -722,7 +717,7 @@ bfad_pci_init(struct pci_dev *pdev, struct bfad_s *bfad)
 	int rc = -ENODEV;
 
 	if (pci_enable_device(pdev)) {
-		printk(KERN_ERR "pci_enable_device fail %p\n", pdev);
+		dev_err(&pdev->dev, "pci_enable_device fail %p\n", pdev);
 		goto out;
 	}
 
@@ -737,7 +732,7 @@ bfad_pci_init(struct pci_dev *pdev, struct bfad_s *bfad)
 
 	if (rc) {
 		rc = -ENODEV;
-		printk(KERN_ERR "dma_set_mask_and_coherent fail %p\n", pdev);
+		dev_err(&pdev->dev, "dma_set_mask_and_coherent fail\n");
 		goto out_release_region;
 	}
 
@@ -748,7 +743,7 @@ bfad_pci_init(struct pci_dev *pdev, struct bfad_s *bfad)
 	bfad->pci_bar2_kva = pci_iomap(pdev, 2, pci_resource_len(pdev, 2));
 
 	if (bfad->pci_bar0_kva == NULL) {
-		printk(KERN_ERR "Fail to map bar0\n");
+		BFA_MSG(KERN_ERR, bfad, "Fail to map bar0\n");
 		rc = -ENODEV;
 		goto out_release_region;
 	}
@@ -774,13 +769,13 @@ bfad_pci_init(struct pci_dev *pdev, struct bfad_s *bfad)
 		    pcie_max_read_reqsz <= 4096 &&
 		    is_power_of_2(pcie_max_read_reqsz)) {
 			int max_rq = pcie_get_readrq(pdev);
-			printk(KERN_WARNING "BFA[%s]: "
+			dev_warn(&pdev->dev, "BFA[%s]: "
 				"pcie_max_read_request_size is %d, "
 				"reset to %d\n", bfad->pci_name, max_rq,
 				pcie_max_read_reqsz);
 			pcie_set_readrq(pdev, pcie_max_read_reqsz);
 		} else {
-			printk(KERN_WARNING "BFA[%s]: invalid "
+			dev_warn(&pdev->dev, "BFA[%s]: invalid "
 			       "pcie_max_read_request_size %d ignored\n",
 			       bfad->pci_name, pcie_max_read_reqsz);
 		}
@@ -822,10 +817,8 @@ bfad_drv_init(struct bfad_s *bfad)
 
 	rc = bfad_hal_mem_alloc(bfad);
 	if (rc != BFA_STATUS_OK) {
-		printk(KERN_WARNING "bfad%d bfad_hal_mem_alloc failure\n",
-		       bfad->inst_no);
-		printk(KERN_WARNING
-			"Not enough memory to attach all QLogic BR-series HBA ports. System may need more memory.\n");
+		BFA_MSG(KERN_WARNING, bfad, "bfad_hal_mem_alloc failure\n");
+		BFA_MSG(KERN_WARNING, bfad, "Not enough memory to attach all QLogic BR-series HBA ports. System may need more memory.\n");
 		return BFA_STATUS_FAILED;
 	}
 
@@ -1011,7 +1004,7 @@ bfad_start_ops(struct bfad_s *bfad) {
 	/* BFAD level FC4 IM specific resource allocation */
 	retval = bfad_im_probe(bfad);
 	if (retval != BFA_STATUS_OK) {
-		printk(KERN_WARNING "bfad_im_probe failed\n");
+		BFA_MSG(KERN_WARNING, bfad, "bfad_im_probe failed\n");
 		if (bfa_sm_cmp_state(bfad, bfad_sm_initializing))
 			bfa_sm_set_state(bfad, bfad_sm_failed);
 		return BFA_STATUS_FAILED;
@@ -1038,8 +1031,8 @@ bfad_start_ops(struct bfad_s *bfad) {
 		fc_vport = fc_vport_create(bfad->pport.im_port->shost, 0, &vid);
 		if (!fc_vport) {
 			wwn2str(pwwn_buf, vid.port_name);
-			printk(KERN_WARNING "bfad%d: failed to create pbc vport"
-				" %s\n", bfad->inst_no, pwwn_buf);
+			BFA_MSG(KERN_WARNING, bfad, "failed to create pbc vport %s\n",
+				 pwwn_buf);
 		}
 		list_del(&vport->list_entry);
 		kfree(vport);
@@ -1220,19 +1213,17 @@ bfad_setup_intr(struct bfad_s *bfad)
 					      msix_entries, bfad->nvec);
 		/* In CT1 & CT2, try to allocate just one vector */
 		if (error == -ENOSPC && bfa_asic_id_ctc(pdev->device)) {
-			printk(KERN_WARNING "bfa %s: trying one msix "
-			       "vector failed to allocate %d[%d]\n",
-			       bfad->pci_name, bfad->nvec, error);
+			BFA_MSG(KERN_WARNING, bfad, "trying one msix vector "
+				 "failed to allocate %d[%d]\n",
+				 bfad->nvec, error);
 			bfad->nvec = 1;
 			error = pci_enable_msix_exact(bfad->pcidev,
 						      msix_entries, 1);
 		}
 
 		if (error) {
-			printk(KERN_WARNING "bfad%d: "
-			       "pci_enable_msix_exact failed (%d), "
-			       "use line based.\n",
-				bfad->inst_no, error);
+			BFA_MSG(KERN_WARNING, bfad, "pci_enable_msix_exact "
+				"failed (%d), use line based.\n", error);
 			goto line_based;
 		}
 
@@ -1306,7 +1297,7 @@ bfad_pci_probe(struct pci_dev *pdev, const struct pci_device_id *pid)
 
 	bfad->trcmod = kzalloc(sizeof(struct bfa_trc_mod_s), GFP_KERNEL);
 	if (!bfad->trcmod) {
-		printk(KERN_WARNING "Error alloc trace buffer!\n");
+		dev_warn(&pdev->dev, "Error alloc trace buffer!\n");
 		error = -ENOMEM;
 		goto out_alloc_trace_failure;
 	}
@@ -1328,7 +1319,7 @@ bfad_pci_probe(struct pci_dev *pdev, const struct pci_device_id *pid)
 
 	retval = bfad_pci_init(pdev, bfad);
 	if (retval) {
-		printk(KERN_WARNING "bfad_pci_init failure!\n");
+		dev_warn(&pdev->dev, "bfad_pci_init failure!\n");
 		error = retval;
 		goto out_pci_init_failure;
 	}
@@ -1749,14 +1740,14 @@ bfad_read_firmware(struct pci_dev *pdev, u32 **bfi_image,
 	const struct firmware *fw;
 
 	if (request_firmware(&fw, fw_name, &pdev->dev)) {
-		printk(KERN_ALERT "Can't locate firmware %s\n", fw_name);
+		dev_alert(&pdev->dev, "Can't locate firmware %s\n", fw_name);
 		*bfi_image = NULL;
 		goto out;
 	}
 
 	*bfi_image = vmalloc(fw->size);
 	if (NULL == *bfi_image) {
-		printk(KERN_ALERT "Fail to allocate buffer for fw image "
+		dev_alert(&pdev->dev, "Fail to allocate buffer for fw image "
 			"size=%x!\n", (u32) fw->size);
 		goto out;
 	}
diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index fc515424ca88..9302f0b83ca2 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -3441,16 +3441,14 @@ bfad_im_bsg_els_ct_request(struct bsg_job *job)
 	/* allocate memory for req / rsp buffers */
 	req_kbuf = kzalloc(job->request_payload.payload_len, GFP_KERNEL);
 	if (!req_kbuf) {
-		printk(KERN_INFO "bfa %s: fcpt request buffer alloc failed\n",
-				bfad->pci_name);
+		BFA_MSG(KERN_INFO, bfad, "fcpt request buffer alloc failed\n");
 		rc = -ENOMEM;
 		goto out_free_mem;
 	}
 
 	rsp_kbuf = kzalloc(job->reply_payload.payload_len, GFP_KERNEL);
 	if (!rsp_kbuf) {
-		printk(KERN_INFO "bfa %s: fcpt response buffer alloc failed\n",
-				bfad->pci_name);
+		BFA_MSG(KERN_INFO, bfad, "fcpt response buffer alloc failed\n");
 		rc = -ENOMEM;
 		goto out_free_mem;
 	}
@@ -3464,8 +3462,7 @@ bfad_im_bsg_els_ct_request(struct bsg_job *job)
 					job->request_payload.payload_len,
 					&drv_fcxp->num_req_sgles);
 	if (!drv_fcxp->reqbuf_info) {
-		printk(KERN_INFO "bfa %s: fcpt request fcxp_map_sg failed\n",
-				bfad->pci_name);
+		BFA_MSG(KERN_INFO, bfad, "fcpt request fcxp_map_sg failed\n");
 		rc = -ENOMEM;
 		goto out_free_mem;
 	}
@@ -3480,8 +3477,7 @@ bfad_im_bsg_els_ct_request(struct bsg_job *job)
 					job->reply_payload.payload_len,
 					&drv_fcxp->num_rsp_sgles);
 	if (!drv_fcxp->rspbuf_info) {
-		printk(KERN_INFO "bfa %s: fcpt response fcxp_map_sg failed\n",
-				bfad->pci_name);
+		BFA_MSG(KERN_INFO, bfad, "fcpt response fcxp_map_sg failed\n");
 		rc = -ENOMEM;
 		goto out_free_mem;
 	}
diff --git a/drivers/scsi/bfa/bfad_debugfs.c b/drivers/scsi/bfa/bfad_debugfs.c
index fd1b378a263a..2eaa8e6473c1 100644
--- a/drivers/scsi/bfa/bfad_debugfs.c
+++ b/drivers/scsi/bfa/bfad_debugfs.c
@@ -76,8 +76,7 @@ bfad_debugfs_open_fwtrc(struct inode *inode, struct file *file)
 	fw_debug->debug_buffer = vzalloc(fw_debug->buffer_len);
 	if (!fw_debug->debug_buffer) {
 		kfree(fw_debug);
-		printk(KERN_INFO "bfad[%d]: Failed to allocate fwtrc buffer\n",
-				bfad->inst_no);
+		BFA_MSG(KERN_INFO, bfad, "Failed to allocate fwtrc buffer\n");
 		return -ENOMEM;
 	}
 
@@ -90,8 +89,7 @@ bfad_debugfs_open_fwtrc(struct inode *inode, struct file *file)
 		vfree(fw_debug->debug_buffer);
 		fw_debug->debug_buffer = NULL;
 		kfree(fw_debug);
-		printk(KERN_INFO "bfad[%d]: Failed to collect fwtrc\n",
-				bfad->inst_no);
+		BFA_MSG(KERN_INFO, bfad, "Failed to collect fwtrc\n");
 		return -ENOMEM;
 	}
 
@@ -118,8 +116,7 @@ bfad_debugfs_open_fwsave(struct inode *inode, struct file *file)
 	fw_debug->debug_buffer = vzalloc(fw_debug->buffer_len);
 	if (!fw_debug->debug_buffer) {
 		kfree(fw_debug);
-		printk(KERN_INFO "bfad[%d]: Failed to allocate fwsave buffer\n",
-				bfad->inst_no);
+		BFA_MSG(KERN_INFO, bfad, "Failed to allocate fwsave buffer\n");
 		return -ENOMEM;
 	}
 
@@ -132,8 +129,7 @@ bfad_debugfs_open_fwsave(struct inode *inode, struct file *file)
 		vfree(fw_debug->debug_buffer);
 		fw_debug->debug_buffer = NULL;
 		kfree(fw_debug);
-		printk(KERN_INFO "bfad[%d]: Failed to collect fwsave\n",
-				bfad->inst_no);
+		BFA_MSG(KERN_INFO, bfad, "Failed to collect fwsave\n");
 		return -ENOMEM;
 	}
 
@@ -256,9 +252,8 @@ bfad_debugfs_write_regrd(struct file *file, const char __user *buf,
 
 	rc = sscanf(kern_buf, "%x:%x", &addr, &len);
 	if (rc < 2 || len > (UINT_MAX >> 2)) {
-		printk(KERN_INFO
-			"bfad[%d]: %s failed to read user buf\n",
-			bfad->inst_no, __func__);
+		BFA_MSG(KERN_INFO, bfad, "%s failed to read user buf\n",
+			 __func__);
 		kfree(kern_buf);
 		return -EINVAL;
 	}
@@ -270,8 +265,7 @@ bfad_debugfs_write_regrd(struct file *file, const char __user *buf,
 
 	bfad->regdata = kzalloc(len << 2, GFP_KERNEL);
 	if (!bfad->regdata) {
-		printk(KERN_INFO "bfad[%d]: Failed to allocate regrd buffer\n",
-				bfad->inst_no);
+		BFA_MSG(KERN_INFO, bfad, "Failed to allocate regrd buffer\n");
 		return -ENOMEM;
 	}
 
@@ -282,8 +276,7 @@ bfad_debugfs_write_regrd(struct file *file, const char __user *buf,
 	/* offset and len sanity check */
 	rc = bfad_reg_offset_check(bfa, addr, len);
 	if (rc) {
-		printk(KERN_INFO "bfad[%d]: Failed reg offset check\n",
-				bfad->inst_no);
+		BFA_MSG(KERN_INFO, bfad, "Failed reg offset check\n");
 		kfree(bfad->regdata);
 		bfad->regdata = NULL;
 		bfad->reglen = 0;
@@ -323,9 +316,8 @@ bfad_debugfs_write_regwr(struct file *file, const char __user *buf,
 
 	rc = sscanf(kern_buf, "%x:%x", &addr, &val);
 	if (rc < 2) {
-		printk(KERN_INFO
-			"bfad[%d]: %s failed to read user buf\n",
-			bfad->inst_no, __func__);
+		BFA_MSG(KERN_INFO, bfad, "%s failed to read user buf\n",
+			__func__);
 		kfree(kern_buf);
 		return -EINVAL;
 	}
@@ -336,9 +328,7 @@ bfad_debugfs_write_regwr(struct file *file, const char __user *buf,
 	/* offset and len sanity check */
 	rc = bfad_reg_offset_check(bfa, addr, 1);
 	if (rc) {
-		printk(KERN_INFO
-			"bfad[%d]: Failed reg offset check\n",
-			bfad->inst_no);
+		BFA_MSG(KERN_INFO, bfad, "Failed reg offset check\n");
 		return -EINVAL;
 	}
 
diff --git a/drivers/scsi/bfa/bfad_drv.h b/drivers/scsi/bfa/bfad_drv.h
index eaee7c8bc2d2..619a7e47553b 100644
--- a/drivers/scsi/bfa/bfad_drv.h
+++ b/drivers/scsi/bfa/bfad_drv.h
@@ -286,6 +286,9 @@ do {									\
 		dev_printk(level, &((bfad)->pcidev)->dev, fmt, ##arg);	\
 } while (0)
 
+#define BFA_MSG(level, bfad, fmt, arg...)			\
+	dev_warn(&((bfad)->pcidev)->dev, "bfad%d: " fmt, (bfad)->inst_no, ##arg);
+
 bfa_status_t	bfad_vport_create(struct bfad_s *bfad, u16 vf_id,
 				  struct bfa_lport_cfg_s *port_cfg,
 				  struct device *dev);
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 22f06be2606f..1e5fe003ea11 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -542,7 +542,7 @@ bfad_im_scsi_host_alloc(struct bfad_s *bfad, struct bfad_im_port_s *im_port,
 	error = idr_alloc(&bfad_im_port_index, im_port, 0, 0, GFP_KERNEL);
 	if (error < 0) {
 		mutex_unlock(&bfad_mutex);
-		printk(KERN_WARNING "idr_alloc failure\n");
+		BFA_MSG(KERN_WARNING, bfad, "idr_alloc failure\n");
 		goto out;
 	}
 	im_port->idr_id = error;
@@ -570,7 +570,7 @@ bfad_im_scsi_host_alloc(struct bfad_s *bfad, struct bfad_im_port_s *im_port,
 
 	error = scsi_add_host_with_dma(im_port->shost, dev, &bfad->pcidev->dev);
 	if (error) {
-		printk(KERN_WARNING "scsi_add_host failure %d\n", error);
+		BFA_MSG(KERN_WARNING, bfad, "scsi_add_host failure %d\n", error);
 		goto out_fc_rel;
 	}
 
@@ -1136,7 +1136,7 @@ bfad_im_itnim_work_handler(struct work_struct *work)
 				itnim->scsi_tgt_id,
 				fcid_str, wwpn_str);
 		} else {
-			printk(KERN_WARNING
+			BFA_MSG(KERN_WARNING, bfad,
 				"%s: itnim %llx is already in online state\n",
 				__func__,
 				bfa_fcs_itnim_get_pwwn(&itnim->fcs_itnim));
@@ -1237,9 +1237,9 @@ bfad_im_queuecommand_lck(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd
 
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
 	if (!(bfad->bfad_flags & BFAD_HAL_START_DONE)) {
-		printk(KERN_WARNING
-			"bfad%d, queuecommand %p %x failed, BFA stopped\n",
-		       bfad->inst_no, cmnd, cmnd->cmnd[0]);
+		BFA_MSG(KERN_WARNING, bfad,
+			"queuecommand %p %x failed, BFA stopped\n",
+			cmnd, cmnd->cmnd[0]);
 		cmnd->result = DID_NO_CONNECT << 16;
 		goto out_fail_cmd;
 	}
@@ -1254,7 +1254,7 @@ bfad_im_queuecommand_lck(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd
 	hal_io = bfa_ioim_alloc(&bfad->bfa, (struct bfad_ioim_s *) cmnd,
 				    itnim->bfa_itnim, sg_cnt);
 	if (!hal_io) {
-		printk(KERN_WARNING "hal_io failure\n");
+		BFA_MSG(KERN_WARNING, bfad, "hal_io failure\n");
 		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 		scsi_dma_unmap(cmnd);
 		return SCSI_MLQUEUE_HOST_BUSY;
-- 
2.16.4

