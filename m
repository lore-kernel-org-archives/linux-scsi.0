Received: from rcdn-iport-8.cisco.com (rcdn-iport-8.cisco.com [173.37.86.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC751D0BA2;
	Wed,  2 Oct 2024 18:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727893493; cv=none; b=ZdqIvsjVlEKav2yjuKvLTy7QbQPGIFfLxTwhWl6W1Pi40oXunqMNLtXZjihd/055VsA6lzrLjPLCrRf/b0HSwXjAddjnkjgyahV1MvJy8Be8/PwhznqGTv/2BPswduRvm7VvdTJeMHvkLHP4Ip8aTIFNQzVnnNqflsOOVn0Gx6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727893493; c=relaxed/simple;
	bh=fYJXGx3mM8+4tiR4dZYLps0OH4TvRmwj2vdtUKGUFMY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MryZnvsBTO/GvOueXF7aPLO1As1ySuN+qST8nrRigpUYl6Db3bXIEyy/hiVjzq9k1lqoS7SmHNY46wMKIEzKDldDf7MJiRebp8YZBxhsExd2tLyYxFaX97LExGdNlRWo6lgIZ6xEj/evow5AHLSlFU3a2Hcvt/bwvoDp3xOpsaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=LwmUfVaj; arc=none smtp.client-ip=173.37.86.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="LwmUfVaj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=16814; q=dns/txt;
  s=iport; t=1727893491; x=1729103091;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xfBW3Iv1RXlf16bnEoktOQaChWcArNbC4OX2eZ0YBgo=;
  b=LwmUfVajVA0D1UYUvopTaqYpd9Iw7U3pvDHVil8Z2DRKlOG3jTRYNj0j
   62qVya/cu69MTaYE4VVRCr/R5li+lTfo28TJiOmlhdCiuUOSJo6W3/IN0
   7mtkB9D9H4Ku7bVcxMz08ao4gWJuI/7T2HrCxnaUf8RNsJ1esNA96FFyh
   c=;
X-CSE-ConnectionGUID: SPH9mVV2RyCuDgglzI+tXg==
X-CSE-MsgGUID: qkgQd4uyTKuRzO7LKEiA6Q==
X-IronPort-AV: E=Sophos;i="6.11,172,1725321600"; 
   d="scan'208";a="260381971"
Received: from rcdn-core-8.cisco.com ([173.37.93.144])
  by rcdn-iport-8.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2024 18:24:44 +0000
Received: from localhost.cisco.com ([10.193.101.253])
	(authenticated bits=0)
	by rcdn-core-8.cisco.com (8.15.2/8.15.2) with ESMTPSA id 492IOHQk009807
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 2 Oct 2024 18:24:43 GMT
From: Karan Tilak Kumar <kartilak@cisco.com>
To: sebaddel@cisco.com
Cc: arulponn@cisco.com, djhawar@cisco.com, gcboffa@cisco.com, mkai2@cisco.com,
        satishkh@cisco.com, aeasi@cisco.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Karan Tilak Kumar <kartilak@cisco.com>
Subject: [PATCH v4 01/14] scsi: fnic: Replace shost_printk with dev_info/dev_err
Date: Wed,  2 Oct 2024 11:23:57 -0700
Message-Id: <20241002182410.68093-2-kartilak@cisco.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20241002182410.68093-1-kartilak@cisco.com>
References: <20241002182410.68093-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.193.101.253, [10.193.101.253]
X-Outbound-Node: rcdn-core-8.cisco.com

Sending host information to shost_printk
prior to host initialization in fnic is unnecessary.
Replace shost_printk and a printk prior to this
initialization with dev_info and dev_err accordingly.

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
Changes between v1 and v2:
    Incorporate review comments from Hannes:
	Replace pr_info with dev_info.
	Replace pr_err with dev_err.
	Modify patch heading and description appropriately.
---
 drivers/scsi/fnic/fnic_main.c | 84 ++++++++++++-----------------------
 drivers/scsi/fnic/fnic_res.c  | 69 ++++++++++------------------
 2 files changed, 51 insertions(+), 102 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 0044717d4486..1633f7e6af1e 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -344,25 +344,19 @@ void fnic_log_q_error(struct fnic *fnic)
 	for (i = 0; i < fnic->raw_wq_count; i++) {
 		error_status = ioread32(&fnic->wq[i].ctrl->error_status);
 		if (error_status)
-			shost_printk(KERN_ERR, fnic->lport->host,
-				     "WQ[%d] error_status"
-				     " %d\n", i, error_status);
+			dev_err(&fnic->pdev->dev, "WQ[%d] error_status %d\n", i, error_status);
 	}
 
 	for (i = 0; i < fnic->rq_count; i++) {
 		error_status = ioread32(&fnic->rq[i].ctrl->error_status);
 		if (error_status)
-			shost_printk(KERN_ERR, fnic->lport->host,
-				     "RQ[%d] error_status"
-				     " %d\n", i, error_status);
+			dev_err(&fnic->pdev->dev, "RQ[%d] error_status %d\n", i, error_status);
 	}
 
 	for (i = 0; i < fnic->wq_copy_count; i++) {
 		error_status = ioread32(&fnic->hw_copy_wq[i].ctrl->error_status);
 		if (error_status)
-			shost_printk(KERN_ERR, fnic->lport->host,
-				     "CWQ[%d] error_status"
-				     " %d\n", i, error_status);
+			dev_err(&fnic->pdev->dev, "CWQ[%d] error_status %d\n", i, error_status);
 	}
 }
 
@@ -396,8 +390,7 @@ static int fnic_notify_set(struct fnic *fnic)
 		err = vnic_dev_notify_set(fnic->vdev, fnic->wq_copy_count + fnic->copy_wq_base);
 		break;
 	default:
-		shost_printk(KERN_ERR, fnic->lport->host,
-			     "Interrupt mode should be set up"
+		dev_err(&fnic->pdev->dev, "Interrupt mode should be set up"
 			     " before devcmd notify set %d\n",
 			     vnic_dev_get_intr_mode(fnic->vdev));
 		err = -1;
@@ -567,12 +560,10 @@ static int fnic_scsi_drv_init(struct fnic *fnic)
 
 	host->nr_hw_queues = fnic->wq_copy_count;
 
-	shost_printk(KERN_INFO, host,
-			"fnic: can_queue: %d max_lun: %llu",
+	dev_info(&fnic->pdev->dev, "fnic: can_queue: %d max_lun: %llu",
 			host->can_queue, host->max_lun);
 
-	shost_printk(KERN_INFO, host,
-			"fnic: max_id: %d max_cmd_len: %d nr_hw_queues: %d",
+	dev_info(&fnic->pdev->dev, "fnic: max_id: %d max_cmd_len: %d nr_hw_queues: %d",
 			host->max_id, host->max_cmd_len, host->nr_hw_queues);
 
 	return 0;
@@ -622,7 +613,7 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 */
 	lp = libfc_host_alloc(&fnic_host_template, sizeof(struct fnic));
 	if (!lp) {
-		printk(KERN_ERR PFX "Unable to alloc libfc local port\n");
+		dev_err(&pdev->dev, "Unable to alloc libfc local port\n");
 		err = -ENOMEM;
 		goto err_out;
 	}
@@ -632,7 +623,7 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	fnic_id = ida_alloc(&fnic_ida, GFP_KERNEL);
 	if (fnic_id < 0) {
-		pr_err("Unable to alloc fnic ID\n");
+		dev_err(&pdev->dev, "Unable to alloc fnic ID\n");
 		err = fnic_id;
 		goto err_out_ida_alloc;
 	}
@@ -650,15 +641,13 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	err = pci_enable_device(pdev);
 	if (err) {
-		shost_printk(KERN_ERR, fnic->lport->host,
-			     "Cannot enable PCI device, aborting.\n");
+		dev_err(&fnic->pdev->dev, "Cannot enable PCI device, aborting.\n");
 		goto err_out_free_hba;
 	}
 
 	err = pci_request_regions(pdev, DRV_NAME);
 	if (err) {
-		shost_printk(KERN_ERR, fnic->lport->host,
-			     "Cannot enable PCI resources, aborting\n");
+		dev_err(&fnic->pdev->dev, "Cannot enable PCI resources, aborting\n");
 		goto err_out_disable_device;
 	}
 
@@ -672,8 +661,7 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (err) {
 		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
 		if (err) {
-			shost_printk(KERN_ERR, fnic->lport->host,
-				     "No usable DMA configuration "
+			dev_err(&fnic->pdev->dev, "No usable DMA configuration "
 				     "aborting\n");
 			goto err_out_release_regions;
 		}
@@ -681,8 +669,7 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* Map vNIC resources from BAR0 */
 	if (!(pci_resource_flags(pdev, 0) & IORESOURCE_MEM)) {
-		shost_printk(KERN_ERR, fnic->lport->host,
-			     "BAR0 not memory-map'able, aborting.\n");
+		dev_err(&fnic->pdev->dev, "BAR0 not memory-map'able, aborting.\n");
 		err = -ENODEV;
 		goto err_out_release_regions;
 	}
@@ -692,8 +679,7 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	fnic->bar0.len = pci_resource_len(pdev, 0);
 
 	if (!fnic->bar0.vaddr) {
-		shost_printk(KERN_ERR, fnic->lport->host,
-			     "Cannot memory-map BAR0 res hdr, "
+		dev_err(&fnic->pdev->dev, "Cannot memory-map BAR0 res hdr, "
 			     "aborting.\n");
 		err = -ENODEV;
 		goto err_out_release_regions;
@@ -701,8 +687,7 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	fnic->vdev = vnic_dev_register(NULL, fnic, pdev, &fnic->bar0);
 	if (!fnic->vdev) {
-		shost_printk(KERN_ERR, fnic->lport->host,
-			     "vNIC registration failed, "
+		dev_err(&fnic->pdev->dev, "vNIC registration failed, "
 			     "aborting.\n");
 		err = -ENODEV;
 		goto err_out_iounmap;
@@ -710,8 +695,7 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	err = vnic_dev_cmd_init(fnic->vdev);
 	if (err) {
-		shost_printk(KERN_ERR, fnic->lport->host,
-				"vnic_dev_cmd_init() returns %d, aborting\n",
+		dev_err(&fnic->pdev->dev, "vnic_dev_cmd_init() returns %d, aborting\n",
 				err);
 		goto err_out_vnic_unregister;
 	}
@@ -719,22 +703,19 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	err = fnic_dev_wait(fnic->vdev, vnic_dev_open,
 			    vnic_dev_open_done, CMD_OPENF_RQ_ENABLE_THEN_POST);
 	if (err) {
-		shost_printk(KERN_ERR, fnic->lport->host,
-			     "vNIC dev open failed, aborting.\n");
+		dev_err(&fnic->pdev->dev, "vNIC dev open failed, aborting.\n");
 		goto err_out_dev_cmd_deinit;
 	}
 
 	err = vnic_dev_init(fnic->vdev, 0);
 	if (err) {
-		shost_printk(KERN_ERR, fnic->lport->host,
-			     "vNIC dev init failed, aborting.\n");
+		dev_err(&fnic->pdev->dev, "vNIC dev init failed, aborting.\n");
 		goto err_out_dev_close;
 	}
 
 	err = vnic_dev_mac_addr(fnic->vdev, fnic->ctlr.ctl_src_addr);
 	if (err) {
-		shost_printk(KERN_ERR, fnic->lport->host,
-			     "vNIC get MAC addr failed \n");
+		dev_err(&fnic->pdev->dev, "vNIC get MAC addr failed\n");
 		goto err_out_dev_close;
 	}
 	/* set data_src for point-to-point mode and to keep it non-zero */
@@ -743,8 +724,7 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* Get vNIC configuration */
 	err = fnic_get_vnic_config(fnic);
 	if (err) {
-		shost_printk(KERN_ERR, fnic->lport->host,
-			     "Get vNIC configuration failed, "
+		dev_err(&fnic->pdev->dev, "Get vNIC configuration failed, "
 			     "aborting.\n");
 		goto err_out_dev_close;
 	}
@@ -756,16 +736,14 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	err = fnic_set_intr_mode(fnic);
 	if (err) {
-		shost_printk(KERN_ERR, fnic->lport->host,
-			     "Failed to set intr mode, "
+		dev_err(&fnic->pdev->dev, "Failed to set intr mode, "
 			     "aborting.\n");
 		goto err_out_dev_close;
 	}
 
 	err = fnic_alloc_vnic_resources(fnic);
 	if (err) {
-		shost_printk(KERN_ERR, fnic->lport->host,
-			     "Failed to alloc vNIC resources, "
+		dev_err(&fnic->pdev->dev, "Failed to alloc vNIC resources, "
 			     "aborting.\n");
 		goto err_out_clear_intr;
 	}
@@ -778,7 +756,7 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 					kzalloc((fnic->sw_copy_wq[hwq].ioreq_table_size + 1) *
 					sizeof(struct fnic_io_req *), GFP_KERNEL);
 	}
-	shost_printk(KERN_INFO, fnic->lport->host, "fnic copy wqs: %d, Q0 ioreq table size: %d\n",
+	dev_info(&fnic->pdev->dev, "fnic copy wqs: %d, Q0 ioreq table size: %d\n",
 			fnic->wq_copy_count, fnic->sw_copy_wq[0].ioreq_table_size);
 
 	/* initialize all fnic locks */
@@ -818,8 +796,7 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	fnic->ctlr.update_mac = fnic_update_mac;
 	fnic->ctlr.get_src_addr = fnic_get_mac;
 	if (fnic->config.flags & VFCF_FIP_CAPABLE) {
-		shost_printk(KERN_INFO, fnic->lport->host,
-			     "firmware supports FIP\n");
+		dev_info(&fnic->pdev->dev, "firmware supports FIP\n");
 		/* enable directed and multicast */
 		vnic_dev_packet_filter(fnic->vdev, 1, 1, 0, 0, 0);
 		vnic_dev_add_addr(fnic->vdev, FIP_ALL_ENODE_MACS);
@@ -835,8 +812,7 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		INIT_LIST_HEAD(&fnic->evlist);
 		INIT_LIST_HEAD(&fnic->vlans);
 	} else {
-		shost_printk(KERN_INFO, fnic->lport->host,
-			     "firmware uses non-FIP mode\n");
+		dev_info(&fnic->pdev->dev, "firmware uses non-FIP mode\n");
 		fcoe_ctlr_init(&fnic->ctlr, FIP_MODE_NON_FIP);
 		fnic->ctlr.state = FIP_ST_NON_FIP;
 	}
@@ -851,8 +827,7 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* Setup notification buffer area */
 	err = fnic_notify_set(fnic);
 	if (err) {
-		shost_printk(KERN_ERR, fnic->lport->host,
-			     "Failed to alloc notify buffer, aborting.\n");
+		dev_err(&fnic->pdev->dev, "Failed to alloc notify buffer, aborting.\n");
 		goto err_out_free_max_pool;
 	}
 
@@ -864,8 +839,7 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	for (i = 0; i < fnic->rq_count; i++) {
 		err = vnic_rq_fill(&fnic->rq[i], fnic_alloc_rq_frame);
 		if (err) {
-			shost_printk(KERN_ERR, fnic->lport->host,
-				     "fnic_alloc_rq_frame can't alloc "
+			dev_err(&fnic->pdev->dev, "fnic_alloc_rq_frame can't alloc "
 				     "frame\n");
 			goto err_out_rq_buf;
 		}
@@ -883,8 +857,7 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	err = fnic_request_intr(fnic);
 	if (err) {
-		shost_printk(KERN_ERR, fnic->lport->host,
-			     "Unable to request irq.\n");
+		dev_err(&fnic->pdev->dev, "Unable to request irq.\n");
 		goto err_out_request_intr;
 	}
 
@@ -894,8 +867,7 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 */
 	err = scsi_add_host(lp->host, &pdev->dev);
 	if (err) {
-		shost_printk(KERN_ERR, fnic->lport->host,
-			     "fnic: scsi_add_host failed...exiting\n");
+		dev_err(&fnic->pdev->dev, "fnic: scsi_add_host failed...exiting\n");
 		goto err_out_scsi_add_host;
 	}
 
diff --git a/drivers/scsi/fnic/fnic_res.c b/drivers/scsi/fnic/fnic_res.c
index 33dd27f6f24e..dd24e25574db 100644
--- a/drivers/scsi/fnic/fnic_res.c
+++ b/drivers/scsi/fnic/fnic_res.c
@@ -30,9 +30,7 @@ int fnic_get_vnic_config(struct fnic *fnic)
 				    offsetof(struct vnic_fc_config, m), \
 				    sizeof(c->m), &c->m); \
 		if (err) { \
-			shost_printk(KERN_ERR, fnic->lport->host, \
-				     "Error getting %s, %d\n", #m, \
-				     err); \
+			dev_err(&fnic->pdev->dev, "Error getting %s, %d\n", #m, err); \
 			return err; \
 		} \
 	} while (0);
@@ -139,40 +137,29 @@ int fnic_get_vnic_config(struct fnic *fnic)
 
 	c->wq_copy_count = min_t(u16, FNIC_WQ_COPY_MAX, c->wq_copy_count);
 
-	shost_printk(KERN_INFO, fnic->lport->host,
-		     "vNIC MAC addr %pM "
+	dev_info(&fnic->pdev->dev, "vNIC MAC addr %pM "
 		     "wq/wq_copy/rq %d/%d/%d\n",
 		     fnic->ctlr.ctl_src_addr,
 		     c->wq_enet_desc_count, c->wq_copy_desc_count,
 		     c->rq_desc_count);
-	shost_printk(KERN_INFO, fnic->lport->host,
-		     "vNIC node wwn %llx port wwn %llx\n",
+	dev_info(&fnic->pdev->dev, "vNIC node wwn %llx port wwn %llx\n",
 		     c->node_wwn, c->port_wwn);
-	shost_printk(KERN_INFO, fnic->lport->host,
-		     "vNIC ed_tov %d ra_tov %d\n",
+	dev_info(&fnic->pdev->dev, "vNIC ed_tov %d ra_tov %d\n",
 		     c->ed_tov, c->ra_tov);
-	shost_printk(KERN_INFO, fnic->lport->host,
-		     "vNIC mtu %d intr timer %d\n",
+	dev_info(&fnic->pdev->dev, "vNIC mtu %d intr timer %d\n",
 		     c->maxdatafieldsize, c->intr_timer);
-	shost_printk(KERN_INFO, fnic->lport->host,
-		     "vNIC flags 0x%x luns per tgt %d\n",
+	dev_info(&fnic->pdev->dev, "vNIC flags 0x%x luns per tgt %d\n",
 		     c->flags, c->luns_per_tgt);
-	shost_printk(KERN_INFO, fnic->lport->host,
-		     "vNIC flogi_retries %d flogi timeout %d\n",
+	dev_info(&fnic->pdev->dev, "vNIC flogi_retries %d flogi timeout %d\n",
 		     c->flogi_retries, c->flogi_timeout);
-	shost_printk(KERN_INFO, fnic->lport->host,
-		     "vNIC plogi retries %d plogi timeout %d\n",
+	dev_info(&fnic->pdev->dev, "vNIC plogi retries %d plogi timeout %d\n",
 		     c->plogi_retries, c->plogi_timeout);
-	shost_printk(KERN_INFO, fnic->lport->host,
-		     "vNIC io throttle count %d link dn timeout %d\n",
+	dev_info(&fnic->pdev->dev, "vNIC io throttle count %d link dn timeout %d\n",
 		     c->io_throttle_count, c->link_down_timeout);
-	shost_printk(KERN_INFO, fnic->lport->host,
-		     "vNIC port dn io retries %d port dn timeout %d\n",
+	dev_info(&fnic->pdev->dev, "vNIC port dn io retries %d port dn timeout %d\n",
 		     c->port_down_io_retries, c->port_down_timeout);
-	shost_printk(KERN_INFO, fnic->lport->host,
-			"vNIC wq_copy_count: %d\n", c->wq_copy_count);
-	shost_printk(KERN_INFO, fnic->lport->host,
-			"vNIC intr mode: %d\n", c->intr_mode);
+	dev_info(&fnic->pdev->dev, "vNIC wq_copy_count: %d\n", c->wq_copy_count);
+	dev_info(&fnic->pdev->dev, "vNIC intr mode: %d\n", c->intr_mode);
 
 	return 0;
 }
@@ -206,18 +193,12 @@ void fnic_get_res_counts(struct fnic *fnic)
 	fnic->intr_count = vnic_dev_get_res_count(fnic->vdev,
 		RES_TYPE_INTR_CTRL);
 
-	shost_printk(KERN_INFO, fnic->lport->host,
-		"vNIC fw resources wq_count: %d\n", fnic->wq_count);
-	shost_printk(KERN_INFO, fnic->lport->host,
-		"vNIC fw resources raw_wq_count: %d\n", fnic->raw_wq_count);
-	shost_printk(KERN_INFO, fnic->lport->host,
-		"vNIC fw resources wq_copy_count: %d\n", fnic->wq_copy_count);
-	shost_printk(KERN_INFO, fnic->lport->host,
-		"vNIC fw resources rq_count: %d\n", fnic->rq_count);
-	shost_printk(KERN_INFO, fnic->lport->host,
-		"vNIC fw resources cq_count: %d\n", fnic->cq_count);
-	shost_printk(KERN_INFO, fnic->lport->host,
-		"vNIC fw resources intr_count: %d\n", fnic->intr_count);
+	dev_info(&fnic->pdev->dev, "vNIC fw resources wq_count: %d\n", fnic->wq_count);
+	dev_info(&fnic->pdev->dev, "vNIC fw resources raw_wq_count: %d\n", fnic->raw_wq_count);
+	dev_info(&fnic->pdev->dev, "vNIC fw resources wq_copy_count: %d\n", fnic->wq_copy_count);
+	dev_info(&fnic->pdev->dev, "vNIC fw resources rq_count: %d\n", fnic->rq_count);
+	dev_info(&fnic->pdev->dev, "vNIC fw resources cq_count: %d\n", fnic->cq_count);
+	dev_info(&fnic->pdev->dev, "vNIC fw resources intr_count: %d\n", fnic->intr_count);
 }
 
 void fnic_free_vnic_resources(struct fnic *fnic)
@@ -253,19 +234,17 @@ int fnic_alloc_vnic_resources(struct fnic *fnic)
 
 	intr_mode = vnic_dev_get_intr_mode(fnic->vdev);
 
-	shost_printk(KERN_INFO, fnic->lport->host, "vNIC interrupt mode: %s\n",
+	dev_info(&fnic->pdev->dev, "vNIC interrupt mode: %s\n",
 		     intr_mode == VNIC_DEV_INTR_MODE_INTX ? "legacy PCI INTx" :
 		     intr_mode == VNIC_DEV_INTR_MODE_MSI ? "MSI" :
 		     intr_mode == VNIC_DEV_INTR_MODE_MSIX ?
 		     "MSI-X" : "unknown");
 
-	shost_printk(KERN_INFO, fnic->lport->host,
-			"vNIC resources avail: wq %d cp_wq %d raw_wq %d rq %d",
+	dev_info(&fnic->pdev->dev, "res avail: wq %d cp_wq %d raw_wq %d rq %d",
 			fnic->wq_count, fnic->wq_copy_count,
 			fnic->raw_wq_count, fnic->rq_count);
 
-	shost_printk(KERN_INFO, fnic->lport->host,
-			"vNIC resources avail: cq %d intr %d cpy-wq desc count %d\n",
+	dev_info(&fnic->pdev->dev, "res avail: cq %d intr %d cpy-wq desc count %d\n",
 			fnic->cq_count, fnic->intr_count,
 			fnic->config.wq_copy_desc_count);
 
@@ -340,8 +319,7 @@ int fnic_alloc_vnic_resources(struct fnic *fnic)
 				RES_TYPE_INTR_PBA_LEGACY, 0);
 
 	if (!fnic->legacy_pba && intr_mode == VNIC_DEV_INTR_MODE_INTX) {
-		shost_printk(KERN_ERR, fnic->lport->host,
-			     "Failed to hook legacy pba resource\n");
+		dev_err(&fnic->pdev->dev, "Failed to hook legacy pba resource\n");
 		err = -ENODEV;
 		goto err_out_cleanup;
 	}
@@ -444,8 +422,7 @@ int fnic_alloc_vnic_resources(struct fnic *fnic)
 	/* init the stats memory by making the first call here */
 	err = vnic_dev_stats_dump(fnic->vdev, &fnic->stats);
 	if (err) {
-		shost_printk(KERN_ERR, fnic->lport->host,
-			     "vnic_dev_stats_dump failed - x%x\n", err);
+		dev_err(&fnic->pdev->dev, "vnic_dev_stats_dump failed - x%x\n", err);
 		goto err_out_cleanup;
 	}
 
-- 
2.31.1

