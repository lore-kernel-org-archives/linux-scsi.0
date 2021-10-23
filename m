Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79A5EC433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Oct 2021 16:10:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48EB26105A
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Oct 2021 16:10:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbhJWQND (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 23 Oct 2021 12:13:03 -0400
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:50672 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230037AbhJWQNC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 23 Oct 2021 12:13:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1635005443;
        bh=uWU6OxYQsM5INugsJf6auKYNXnrogubCfUFv12YZ1B8=;
        h=Message-ID:Subject:From:To:Date:From;
        b=NeIBSvB0RiTgRiKo1Djb0JiJYSM4HVcU/uVRUrK1n1FvpjTSeJdmhYQ5Ylp1hWEAV
         wrzi6LxlregPBzL8ETrN7dBf7VvzmiukCvAfDzlLG5lyvD74K9M3MxF32CbGw5mBKM
         kT+6t8yrEhkrF7c4NM5/ZidhpjNWwoeuLV+YmSnA=
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id D008F12805A8;
        Sat, 23 Oct 2021 12:10:43 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 0MT4efYzSJ59; Sat, 23 Oct 2021 12:10:43 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1635005443;
        bh=uWU6OxYQsM5INugsJf6auKYNXnrogubCfUFv12YZ1B8=;
        h=Message-ID:Subject:From:To:Date:From;
        b=NeIBSvB0RiTgRiKo1Djb0JiJYSM4HVcU/uVRUrK1n1FvpjTSeJdmhYQ5Ylp1hWEAV
         wrzi6LxlregPBzL8ETrN7dBf7VvzmiukCvAfDzlLG5lyvD74K9M3MxF32CbGw5mBKM
         kT+6t8yrEhkrF7c4NM5/ZidhpjNWwoeuLV+YmSnA=
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:c551::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 447C11280383;
        Sat, 23 Oct 2021 12:10:43 -0400 (EDT)
Message-ID: <14c6e40fec98dbd042c37ea6f65cbd0617b79d78.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.15-rc6
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Sat, 23 Oct 2021 12:10:42 -0400
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Ten fixes, seven of which are in drivers.  The core fixes are one to
fix a potential crash on resume, one to sort out our reference count
releases to avoid releasing in-use modules and one to adjust the cmd
per lun calculation to avoid an overflow in hyper-v.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Adrian Hunter (1):
      scsi: ufs: ufs-pci: Force a full restore after suspend-to-disk

Andrea Parri (Microsoft) (1):
      scsi: storvsc: Fix validation for unsolicited incoming packets

Dexuan Cui (1):
      scsi: core: Fix shost->cmd_per_lun calculation in scsi_add_host_with_dma()

Dmitry Bogdanov (1):
      scsi: qla2xxx: Fix unmap of already freed sgl

Joy Gu (1):
      scsi: qla2xxx: Fix a memory leak in an error path of qla2x00_process_els()

Mike Christie (1):
      scsi: iscsi: Fix set_param() handling

Miles Chen (1):
      scsi: sd: Fix crashes in sd_resume_runtime()

Ming Lei (1):
      scsi: core: Put LLD module refcnt after SCSI device is released

Sreekanth Reddy (1):
      scsi: mpi3mr: Fix duplicate device entries when scanning through sysfs

Zheyu Ma (1):
      scsi: qla2xxx: Return -ENOMEM if kzalloc() fails

And the diffstat:

 drivers/scsi/hosts.c                |  3 ++-
 drivers/scsi/mpi3mr/mpi3mr_os.c     |  2 +-
 drivers/scsi/qla2xxx/qla_bsg.c      |  2 +-
 drivers/scsi/qla2xxx/qla_os.c       |  2 +-
 drivers/scsi/qla2xxx/qla_target.c   | 14 +++++---------
 drivers/scsi/scsi.c                 |  4 +++-
 drivers/scsi/scsi_sysfs.c           |  9 +++++++++
 drivers/scsi/scsi_transport_iscsi.c |  2 --
 drivers/scsi/sd.c                   |  7 ++++++-
 drivers/scsi/storvsc_drv.c          | 32 +++++++++++++++++++++++---------
 drivers/scsi/ufs/ufshcd-pci.c       | 33 ++++++++++++++++++---------------
 11 files changed, 69 insertions(+), 41 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 3f6f14f0cafb..24b72ee4246f 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -220,7 +220,8 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 		goto fail;
 	}
 
-	shost->cmd_per_lun = min_t(short, shost->cmd_per_lun,
+	/* Use min_t(int, ...) in case shost->can_queue exceeds SHRT_MAX */
+	shost->cmd_per_lun = min_t(int, shost->cmd_per_lun,
 				   shost->can_queue);
 
 	error = scsi_init_sense_cache(shost);
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 2197988333fe..3cae8803383b 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -3736,7 +3736,7 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	shost->max_lun = -1;
 	shost->unique_id = mrioc->id;
 
-	shost->max_channel = 1;
+	shost->max_channel = 0;
 	shost->max_id = 0xFFFFFFFF;
 
 	if (prot_mask >= 0)
diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 4b5d28d89d69..655cf5de604b 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -431,7 +431,7 @@ qla2x00_process_els(struct bsg_job *bsg_job)
 	goto done_free_fcport;
 
 done_free_fcport:
-	if (bsg_request->msgcode == FC_BSG_RPT_ELS)
+	if (bsg_request->msgcode != FC_BSG_RPT_ELS)
 		qla2x00_free_fcport(fcport);
 done:
 	return rval;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index d2e40aaba734..836fedcea241 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4157,7 +4157,7 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 					ql_dbg_pci(ql_dbg_init, ha->pdev,
 					    0xe0ee, "%s: failed alloc dsd\n",
 					    __func__);
-					return 1;
+					return -ENOMEM;
 				}
 				ha->dif_bundle_kallocs++;
 
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index b3478ed9b12e..7d8242c120fc 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3319,8 +3319,7 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 			"RESET-RSP online/active/old-count/new-count = %d/%d/%d/%d.\n",
 			vha->flags.online, qla2x00_reset_active(vha),
 			cmd->reset_count, qpair->chip_reset);
-		spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
-		return 0;
+		goto out_unmap_unlock;
 	}
 
 	/* Does F/W have an IOCBs for this request */
@@ -3445,10 +3444,6 @@ int qlt_rdy_to_xfer(struct qla_tgt_cmd *cmd)
 	prm.sg = NULL;
 	prm.req_cnt = 1;
 
-	/* Calculate number of entries and segments required */
-	if (qlt_pci_map_calc_cnt(&prm) != 0)
-		return -EAGAIN;
-
 	if (!qpair->fw_started || (cmd->reset_count != qpair->chip_reset) ||
 	    (cmd->sess && cmd->sess->deleted)) {
 		/*
@@ -3466,6 +3461,10 @@ int qlt_rdy_to_xfer(struct qla_tgt_cmd *cmd)
 		return 0;
 	}
 
+	/* Calculate number of entries and segments required */
+	if (qlt_pci_map_calc_cnt(&prm) != 0)
+		return -EAGAIN;
+
 	spin_lock_irqsave(qpair->qp_lock_ptr, flags);
 	/* Does F/W have an IOCBs for this request */
 	res = qlt_check_reserve_free_req(qpair, prm.req_cnt);
@@ -3870,9 +3869,6 @@ void qlt_free_cmd(struct qla_tgt_cmd *cmd)
 
 	BUG_ON(cmd->cmd_in_wq);
 
-	if (cmd->sg_mapped)
-		qlt_unmap_sg(cmd->vha, cmd);
-
 	if (!cmd->q_full)
 		qlt_decr_num_pend_cmds(cmd->vha);
 
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index b241f9e3885c..291ecc33b1fe 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -553,8 +553,10 @@ EXPORT_SYMBOL(scsi_device_get);
  */
 void scsi_device_put(struct scsi_device *sdev)
 {
-	module_put(sdev->host->hostt->module);
+	struct module *mod = sdev->host->hostt->module;
+
 	put_device(&sdev->sdev_gendev);
+	module_put(mod);
 }
 EXPORT_SYMBOL(scsi_device_put);
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 86793259e541..a35841b34bfd 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -449,9 +449,12 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	struct scsi_vpd *vpd_pg80 = NULL, *vpd_pg83 = NULL;
 	struct scsi_vpd *vpd_pg0 = NULL, *vpd_pg89 = NULL;
 	unsigned long flags;
+	struct module *mod;
 
 	sdev = container_of(work, struct scsi_device, ew.work);
 
+	mod = sdev->host->hostt->module;
+
 	scsi_dh_release_device(sdev);
 
 	parent = sdev->sdev_gendev.parent;
@@ -502,11 +505,17 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 
 	if (parent)
 		put_device(parent);
+	module_put(mod);
 }
 
 static void scsi_device_dev_release(struct device *dev)
 {
 	struct scsi_device *sdp = to_scsi_device(dev);
+
+	/* Set module pointer as NULL in case of module unloading */
+	if (!try_module_get(sdp->host->hostt->module))
+		sdp->host->hostt->module = NULL;
+
 	execute_in_process_context(scsi_device_dev_release_usercontext,
 				   &sdp->ew);
 }
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 922e4c7bd88e..78343d3f9385 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2930,8 +2930,6 @@ iscsi_set_param(struct iscsi_transport *transport, struct iscsi_uevent *ev)
 			session->recovery_tmo = value;
 		break;
 	default:
-		err = transport->set_param(conn, ev->u.set_param.param,
-					   data, ev->u.set_param.len);
 		if ((conn->state == ISCSI_CONN_BOUND) ||
 			(conn->state == ISCSI_CONN_UP)) {
 			err = transport->set_param(conn, ev->u.set_param.param,
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 523bf2fdc253..fce63335084e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3683,7 +3683,12 @@ static int sd_resume(struct device *dev)
 static int sd_resume_runtime(struct device *dev)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
-	struct scsi_device *sdp = sdkp->device;
+	struct scsi_device *sdp;
+
+	if (!sdkp)	/* E.g.: runtime resume at the start of sd_probe() */
+		return 0;
+
+	sdp = sdkp->device;
 
 	if (sdp->ignore_media_change) {
 		/* clear the device's sense data */
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index ebbbc1299c62..9eb1b88a29dd 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1285,11 +1285,15 @@ static void storvsc_on_channel_callback(void *context)
 	foreach_vmbus_pkt(desc, channel) {
 		struct vstor_packet *packet = hv_pkt_data(desc);
 		struct storvsc_cmd_request *request = NULL;
+		u32 pktlen = hv_pkt_datalen(desc);
 		u64 rqst_id = desc->trans_id;
+		u32 minlen = rqst_id ? sizeof(struct vstor_packet) -
+			stor_device->vmscsi_size_delta : sizeof(enum vstor_packet_operation);
 
-		if (hv_pkt_datalen(desc) < sizeof(struct vstor_packet) -
-				stor_device->vmscsi_size_delta) {
-			dev_err(&device->device, "Invalid packet len\n");
+		if (pktlen < minlen) {
+			dev_err(&device->device,
+				"Invalid pkt: id=%llu, len=%u, minlen=%u\n",
+				rqst_id, pktlen, minlen);
 			continue;
 		}
 
@@ -1302,13 +1306,23 @@ static void storvsc_on_channel_callback(void *context)
 			if (rqst_id == 0) {
 				/*
 				 * storvsc_on_receive() looks at the vstor_packet in the message
-				 * from the ring buffer.  If the operation in the vstor_packet is
-				 * COMPLETE_IO, then we call storvsc_on_io_completion(), and
-				 * dereference the guest memory address.  Make sure we don't call
-				 * storvsc_on_io_completion() with a guest memory address that is
-				 * zero if Hyper-V were to construct and send such a bogus packet.
+				 * from the ring buffer.
+				 *
+				 * - If the operation in the vstor_packet is COMPLETE_IO, then
+				 *   we call storvsc_on_io_completion(), and dereference the
+				 *   guest memory address.  Make sure we don't call
+				 *   storvsc_on_io_completion() with a guest memory address
+				 *   that is zero if Hyper-V were to construct and send such
+				 *   a bogus packet.
+				 *
+				 * - If the operation in the vstor_packet is FCHBA_DATA, then
+				 *   we call cache_wwn(), and access the data payload area of
+				 *   the packet (wwn_packet); however, there is no guarantee
+				 *   that the packet is big enough to contain such area.
+				 *   Future-proof the code by rejecting such a bogus packet.
 				 */
-				if (packet->operation == VSTOR_OPERATION_COMPLETE_IO) {
+				if (packet->operation == VSTOR_OPERATION_COMPLETE_IO ||
+				    packet->operation == VSTOR_OPERATION_FCHBA_DATA) {
 					dev_err(&device->device, "Invalid packet with ID of 0\n");
 					continue;
 				}
diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index 149c1aa09103..51424557810d 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -370,20 +370,6 @@ static void ufs_intel_common_exit(struct ufs_hba *hba)
 
 static int ufs_intel_resume(struct ufs_hba *hba, enum ufs_pm_op op)
 {
-	/*
-	 * To support S4 (suspend-to-disk) with spm_lvl other than 5, the base
-	 * address registers must be restored because the restore kernel can
-	 * have used different addresses.
-	 */
-	ufshcd_writel(hba, lower_32_bits(hba->utrdl_dma_addr),
-		      REG_UTP_TRANSFER_REQ_LIST_BASE_L);
-	ufshcd_writel(hba, upper_32_bits(hba->utrdl_dma_addr),
-		      REG_UTP_TRANSFER_REQ_LIST_BASE_H);
-	ufshcd_writel(hba, lower_32_bits(hba->utmrdl_dma_addr),
-		      REG_UTP_TASK_REQ_LIST_BASE_L);
-	ufshcd_writel(hba, upper_32_bits(hba->utmrdl_dma_addr),
-		      REG_UTP_TASK_REQ_LIST_BASE_H);
-
 	if (ufshcd_is_link_hibern8(hba)) {
 		int ret = ufshcd_uic_hibern8_exit(hba);
 
@@ -463,6 +449,18 @@ static struct ufs_hba_variant_ops ufs_intel_lkf_hba_vops = {
 	.device_reset		= ufs_intel_device_reset,
 };
 
+#ifdef CONFIG_PM_SLEEP
+static int ufshcd_pci_restore(struct device *dev)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+
+	/* Force a full reset and restore */
+	ufshcd_set_link_off(hba);
+
+	return ufshcd_system_resume(dev);
+}
+#endif
+
 /**
  * ufshcd_pci_shutdown - main function to put the controller in reset state
  * @pdev: pointer to PCI device handle
@@ -546,9 +544,14 @@ ufshcd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 }
 
 static const struct dev_pm_ops ufshcd_pci_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(ufshcd_system_suspend, ufshcd_system_resume)
 	SET_RUNTIME_PM_OPS(ufshcd_runtime_suspend, ufshcd_runtime_resume, NULL)
 #ifdef CONFIG_PM_SLEEP
+	.suspend	= ufshcd_system_suspend,
+	.resume		= ufshcd_system_resume,
+	.freeze		= ufshcd_system_suspend,
+	.thaw		= ufshcd_system_resume,
+	.poweroff	= ufshcd_system_suspend,
+	.restore	= ufshcd_pci_restore,
 	.prepare	= ufshcd_suspend_prepare,
 	.complete	= ufshcd_resume_complete,
 #endif

