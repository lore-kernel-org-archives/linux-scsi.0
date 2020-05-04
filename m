Return-Path: <SRS0=Qtkh=6S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A4E1C3A5A9
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 14:21:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BC602078C
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 14:21:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T17JBycX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729096AbgEDOU7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 May 2020 10:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728943AbgEDOU6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 May 2020 10:20:58 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4C6CC061A0E;
        Mon,  4 May 2020 07:20:57 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id y3so2124175wrt.1;
        Mon, 04 May 2020 07:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Dj+u6WWzFcrCt3d3khaJ0TRFYx8lpNXyNtFH5T0gi7U=;
        b=T17JBycXWWOCk2r7V06IagJUcF1SFbBiSz2e5er5NSq7B7hDh+aCjsNUeu3vPJ6t44
         jNb2ZOlSkJmVJvyHAwhc7O2lEbburh1WDUoWFW9um7bHlqSKVYduRNLY5KMgFZ8h9ejl
         L6hRlUuwiTdsIcGIL52NWz8XMh7SZSLVr/ai3BcKNEeeX1LF88jguf1dc60Njz7oyqpr
         kPd+YyyjC2JFuGV+g1WjVTwCtMu6eREraS8s+IApSV376DJ8HkbW8LY49HMnl39As1/s
         ugIPjkBOTWFhYLcejxZD/AmlKdNJcrGBPfOO/RexnEMSr0ZQxkB74iEq03W4Xs9QtmLg
         7vbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Dj+u6WWzFcrCt3d3khaJ0TRFYx8lpNXyNtFH5T0gi7U=;
        b=lKBZCYTTfqZpQsrwU8HXiAMuByyPB7dr7CrM8oIB5IEjPcdBlZsReJZwkJaafOaSqw
         ECduAFa12m5sGLqvuP5fOYqhaACWoJDX/CwpcEhUwfry4M6n815HpS27N3xLv9TxtI1h
         DigzGWFJjqnT4+qoPzkYVTQz1PjNCLjXWPZ0N+NEWAb13fMGhPracLmG2s/WJCBBAV4K
         Ad6IGnMkwFx1L8KooVcPhanGbrA4RBbIltU1BhR6vw49xkS6JgP8HAiTVTR8eidk9EF8
         vZINByXh2Pu6rvi9x7YFN8ZUv685CMhwMh8PBQdx5EykIKxpH1CN2fHBbVGoGfnR9bT9
         ALxQ==
X-Gm-Message-State: AGi0PuYW7SoNY/FaLP2tQlAmPicLYEjwOOX5HibhD33rKXCPv+OlOA7p
        1sE9nK58UtXPct+g5tUi8cM=
X-Google-Smtp-Source: APiQypJDe/hbe5zTdVdgYpFRFRYOChLvpEXHAj6Fz5E0p7KSxFQh7G37PugO0VHHU95t1VnY/FqkxQ==
X-Received: by 2002:a5d:4991:: with SMTP id r17mr11875504wrq.150.1588602054091;
        Mon, 04 May 2020 07:20:54 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bfcc8.dynamic.kabel-deutschland.de. [95.91.252.200])
        by smtp.gmail.com with ESMTPSA id p7sm19196140wrf.31.2020.05.04.07.20.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 07:20:53 -0700 (PDT)
From:   huobean@gmail.com
X-Google-Original-From: beanhuo@micron.com
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, rdunlap@infradead.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org
Subject: [RESENT PATCH RFC v3 5/5] scsi: ufs: UFS Host Performance Booster(HPB) driver
Date:   Mon,  4 May 2020 16:20:32 +0200
Message-Id: <20200504142032.16619-6-beanhuo@micron.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200504142032.16619-1-beanhuo@micron.com>
References: <20200504142032.16619-1-beanhuo@micron.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

This patch is to add support for the UFS Host Performance Booster (HPB v1.0),
which is used to improve UFS read performance, especially for the random read.

NAND flash-based storage devices, including UFS, have mechanisms to translate
logical addresses of requests to the corresponding physical addresses of the
flash storage. Traditionally this L2P mapping data is loaded to the internal
SRAM in the storage controller. When the capacity of storage is larger, a
larger size of SRAM for the L2P map data is required. Since increased SRAM
size affects the manufacturing cost significantly, it is not cost-effective
to allocate all the amount of SRAM needed to keep all the Logical-address to
Physical-address (L2P) map data. Therefore, L2P map data, which is required
to identify the physical address for the requested IOs, can only be partially
stored in SRAM from NAND flash. Due to this partial loading, accessing the
flash address area where the L2P information for that address is not loaded
in the SRAM can result in serious performance degradation.

The HPB is a software solution for the above problem, which uses the host’s
system memory as a cache for the FTL L2P mapping table. It does not need
additional hardware support from the host side. By using HPB, the L2P mapping
table can be read from host memory and stored in host-side memory. while
reading the operation, the corresponding L2P information will be sent to the
UFS device along with the reading request. Since the L2P entry is provided in
the read request, UFS device does not have to load L2P entry from flash memory.
This will significantly improve random read performance.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/Kconfig  |   62 +
 drivers/scsi/ufs/Makefile |    1 +
 drivers/scsi/ufs/ufshcd.c |  234 +++-
 drivers/scsi/ufs/ufshcd.h |   23 +
 drivers/scsi/ufs/ufshpb.c | 2767 +++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshpb.h |  423 ++++++
 6 files changed, 3504 insertions(+), 6 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufshpb.c
 create mode 100644 drivers/scsi/ufs/ufshpb.h

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index e2005aeddc2d..0224f224a641 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -160,3 +160,65 @@ config SCSI_UFS_BSG
 
 	  Select this if you need a bsg device node for your UFS controller.
 	  If unsure, say N.
+
+config SCSI_UFSHPB
+	bool "UFS Host Performance Booster (EXPERIMENTAL)"
+	depends on SCSI_UFSHCD
+	help
+	  NAND flash-based storage devices, including UFS, have mechanisms to
+	  translate logical addresses of the IO requests to the corresponding
+	  physical addresses of the flash storage. Traditionally, this L2P
+	  mapping data is loaded to the internal SRAM in the storage controller.
+	  When the capacity of storage is larger, a larger size of SRAM for the
+	  L2P map data is required. Since increased SRAM size affects the
+	  manufacturing cost significantly, it is not cost-effective to allocate
+	  all the amount of SRAM needed to keep all the Logical-address to
+	  Physical-address (L2P) map data. Therefore, L2P map data, which is
+	  required to identify the physical address for the requested IOs, can
+	  only be partially stored in SRAM from NAND flash. Due to this partial
+	  loading, accessing the flash address area where the L2P information
+	  for that address is not loaded in the SRAM can result in serious
+	  performance degradation.
+
+	  UFS Host Performance Booster (HPB) is a software solution for the
+	  above problem, which uses the host side system memory as a cache for
+	  the FTL L2P mapping table. It does not need additional hardware
+	  support from the host side. By using HPB, the L2P mapping table can be
+	  read from host memory and stored in host-side memory. when performing
+	  the read operation, the corresponding L2P information will be sent to
+	  the UFS device along with the reading request. Since the L2P entry is
+	  provided in the read request, UFS device does not have to load L2P
+	  entry from flash memory to UFS internal SRAM. This will significantly
+	  improve the read performance.
+
+	  When selected, this feature will be built in the UFS driver.
+
+	  If in doubt, say N.
+
+config UFSHPB_MAX_MEM_SIZE
+	int "UFS HPB maximum memory size per controller (in MiB)"
+	depends on SCSI_UFSHPB
+	default 128
+	range 0 65536
+	help
+	  This parameter defines the maximum UFS HPB memory/cache size in the
+	  host system. The recommended HPB cache size by the UFS device can be
+	  calculated from bHPBRegionSize and wDeviceMaxActiveHPBRegions. The
+	  reference formula can be
+
+		(bHPBRegionSize(in KB) / 4KB) * 8 * wDeviceMaxActiveHPBRegions.
+
+	  The HPB cache in the host system is used to contain L2P mapping
+	  entries. If the allocated HPB cache size is lower than what calculated
+	  by the above formula, the use of HPB feature may provide lower
+	  performance advantage. But the system memory resource has the
+	  limitation, we can not let HPB driver allocate its cache at will
+	  according to the UFS device recommendation, so an appropriate size of
+	  the cache for HPB should be specified before you choose to use HPB,
+	  then please enter a non-zero positive integer value.
+
+	  Nevertheless, if you want to leave this to the HPB driver, and let the
+	  HPB driver allocate the HPB cache based on the recommendation of the
+	  UFS device. Just give 0 value to this parameter.
+
+	  Leave the default value if unsure.
diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
index 94c6c5d7334b..24d9b69eab0c 100644
--- a/drivers/scsi/ufs/Makefile
+++ b/drivers/scsi/ufs/Makefile
@@ -7,6 +7,7 @@ obj-$(CONFIG_SCSI_UFS_QCOM) += ufs-qcom.o
 obj-$(CONFIG_SCSI_UFSHCD) += ufshcd-core.o
 ufshcd-core-y				+= ufshcd.o ufs-sysfs.o
 ufshcd-core-$(CONFIG_SCSI_UFS_BSG)	+= ufs_bsg.o
+ufshcd-core-$(CONFIG_SCSI_UFSHPB) += ufshpb.o
 obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
 obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) += ufshcd-pltfrm.o
 obj-$(CONFIG_SCSI_UFS_HISI) += ufs-hisi.o
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 1fe7ffc1a75a..b21d86227c91 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -251,6 +251,7 @@ static int ufshcd_scale_clks(struct ufs_hba *hba, bool scale_up);
 static irqreturn_t ufshcd_intr(int irq, void *__hba);
 static int ufshcd_change_power_mode(struct ufs_hba *hba,
 			     struct ufs_pa_layer_attr *pwr_mode);
+static int ufshcd_clear_cmd(struct ufs_hba *hba, int tag);
 static inline bool ufshcd_valid_tag(struct ufs_hba *hba, int tag)
 {
 	return tag >= 0 && tag < hba->nutrs;
@@ -2391,6 +2392,12 @@ static int ufshcd_comp_scsi_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags,
 						lrbp->cmd->sc_data_direction);
 		ufshcd_prepare_utp_scsi_cmd_upiu(lrbp, upiu_flags);
+
+#if defined(CONFIG_SCSI_UFSHPB)
+		/* If HPB works, prepare for the HPB READ */
+		if (hba->ufshpb_state == HPB_PRESENT)
+			ufshpb_prep_fn(hba, lrbp);
+#endif
 	} else {
 		ret = -EINVAL;
 	}
@@ -2430,6 +2437,181 @@ static void ufshcd_init_lrb(struct ufs_hba *hba, struct ufshcd_lrb *lrb, int i)
 	lrb->ucd_prdt_dma_addr = cmd_desc_element_addr + prdt_offset;
 }
 
+#if defined(CONFIG_SCSI_UFSHPB)
+static void ufshcd_prepare_ureq_upiu(struct ufshcd_lrb *lrbp, struct ufs_req
+				     *ureq, u32 *upiu_flags)
+{
+	struct utp_upiu_req *ucd_req_ptr = lrbp->ucd_req_ptr;
+	unsigned short cdb_len;
+
+	/* command descriptor fields */
+	ucd_req_ptr->header.dword_0 = UPIU_HEADER_DWORD(
+					UPIU_TRANSACTION_COMMAND, *upiu_flags,
+					lrbp->lun, lrbp->task_tag);
+	ucd_req_ptr->header.dword_1 = UPIU_HEADER_DWORD(
+					UPIU_COMMAND_SET_TYPE_SCSI, 0, 0, 0);
+
+	/* Total EHS length and Data segment length will be zero */
+	ucd_req_ptr->header.dword_2 = 0;
+
+	ucd_req_ptr->sc.exp_data_transfer_len = cpu_to_be32(ureq->payload_len);
+
+	cdb_len = min_t(unsigned short, ureq->cmd_len, UFS_CDB_SIZE);
+	memset(ucd_req_ptr->sc.cdb, 0, UFS_CDB_SIZE);
+	memcpy(ucd_req_ptr->sc.cdb, ureq->cmd, cdb_len);
+
+	memset(lrbp->ucd_rsp_ptr, 0, sizeof(struct utp_upiu_rsp));
+}
+
+static void ufshcd_comp_ureq_upiu(struct ufshcd_lrb *lrbp, struct ufs_req *ureq)
+{
+	u32 upiu_flags;
+
+	lrbp->command_type = UTP_CMD_TYPE_UFS_STORAGE;
+	ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags, ureq->cmd_dir);
+	ufshcd_prepare_ureq_upiu(lrbp, ureq, &upiu_flags);
+}
+
+static int ufshcd_ureq_dma_map(struct ufs_hba *hba, struct ufs_req *ureq,
+			       struct ufshcd_lrb *lrbp)
+{
+	int nseg = 0;
+	struct ufshcd_sg_entry *prdt;
+	struct scatterlist *sg;
+	int i;
+	struct device *dev = hba->host->dma_dev;
+
+	nseg = dma_map_sg(dev, ureq->sgt.sgl, ureq->sgt.nents, ureq->cmd_dir);
+	if (nseg < 0)
+		return nseg;
+
+	if (nseg == 0) {
+		lrbp->utr_descriptor_ptr->prd_table_length = 0;
+		return 0;
+	}
+
+	lrbp->utr_descriptor_ptr->prd_table_length = cpu_to_le16((u16)nseg);
+	prdt = (struct ufshcd_sg_entry *)lrbp->ucd_prdt_ptr;
+	for_each_sg(ureq->sgt.sgl, sg, nseg, i) {
+		prdt[i].size  = cpu_to_le32(((u32)sg_dma_len(sg)) - 1);
+		prdt[i].base_addr =
+			cpu_to_le32(lower_32_bits(sg_dma_address(sg)));
+		prdt[i].upper_addr =
+			cpu_to_le32(upper_32_bits(sg_dma_address(sg)));
+		prdt[i].reserved = 0;
+	}
+	wmb();
+	return 0;
+}
+
+static int ufshcd_wait_for_ureq(struct ufs_hba *hba, struct ufshcd_lrb *lrbp,
+				struct ufs_req *ureq, int max_timeout)
+{
+	int err = 0;
+	unsigned long time_left;
+	unsigned long flags;
+
+	time_left = wait_for_completion_timeout(ureq->complete,
+			msecs_to_jiffies(max_timeout));
+
+	/* Make sure descriptors are ready before ringing the doorbell */
+	wmb();
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	ureq->complete = NULL;
+	if (likely(time_left))
+		err = ufshcd_get_tr_ocs(lrbp);
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
+	if (!time_left) {
+		err = -ETIMEDOUT;
+		dev_warn(hba->dev, "%s: ureq timedout, tag %d\n", __func__,
+			 lrbp->task_tag);
+		if (!ufshcd_clear_cmd(hba, lrbp->task_tag))
+			/* successfully cleared the command, retry if needed */
+			err = -EAGAIN;
+		/*
+		 * in case of an error, after clearing the doorbell,
+		 * we also need to clear the outstanding_request
+		 * field in hba
+		 */
+		ufshcd_outstanding_req_clear(hba, lrbp->task_tag);
+	}
+
+	return err;
+}
+
+int ufshcd_exec_internal_req(struct ufs_hba *hba, struct ufs_req *ureq)
+{
+	struct ufshcd_lrb *lrbp;
+	struct request *req = ureq->req;
+	unsigned long flags;
+	int tag;
+	int err = 0;
+
+	struct completion wait;
+
+	tag = req->tag;
+	WARN_ON_ONCE(!ufshcd_valid_tag(hba, tag));
+
+	if (!down_read_trylock(&hba->clk_scaling_lock))
+		return -EBUSY;
+
+	if (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL) {
+		dev_WARN_ONCE(hba->dev, 1, "%s: invalid state %d\n",
+			      __func__, hba->ufshcd_state);
+		err = -EIO;
+		goto unlock;
+	}
+
+	/* if error handling is in progress, don't issue commands */
+	if (ufshcd_eh_in_progress(hba)) {
+		err = -EIO;
+		goto unlock;
+	}
+	hba->req_abort_count = 0;
+
+	err = ufshcd_hold(hba, true);
+	if (err) {
+		err = -EBUSY;
+		goto out;
+	}
+	WARN_ON(hba->clk_gating.state != CLKS_ON);
+
+	init_completion(&wait);
+	lrbp = &hba->lrb[tag];
+	WARN_ON(lrbp->cmd);
+	lrbp->cmd = NULL;
+	lrbp->ureq = ureq;
+	lrbp->sense_bufflen = UFS_SENSE_SIZE;
+	lrbp->sense_buffer = ureq->sense_buffer;
+	lrbp->task_tag = tag;
+	lrbp->lun = ufshcd_scsi_to_upiu_lun(ureq->lun);
+	lrbp->intr_cmd = !ufshcd_is_intr_aggr_allowed(hba) ? true : false;
+	lrbp->req_abort_skip = false;
+
+	ufshcd_comp_ureq_upiu(lrbp, ureq);
+
+	err = ufshcd_ureq_dma_map(hba, ureq, lrbp);
+	if (err) {
+		dev_err(hba->dev,
+			"%s: ufshcd_ureq_dma_map err %d\n", __func__, err);
+		goto out;
+	}
+	ureq->complete = &wait;
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	ufshcd_send_command(hba, tag);
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
+	err = ufshcd_wait_for_ureq(hba, lrbp, ureq, 20000);
+
+out:
+	ufshcd_release(hba);
+unlock:
+	up_read(&hba->clk_scaling_lock);
+	return err;
+}
+#endif
+
 /**
  * ufshcd_queuecommand - main entry point for SCSI requests
  * @host: SCSI host pointer
@@ -4622,7 +4804,10 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
 
 	if (ufshcd_is_rpm_autosuspend_allowed(hba))
 		sdev->rpm_autosuspend = 1;
-
+#if defined(CONFIG_SCSI_UFSHPB)
+	if (sdev->lun < hba->dev_info.max_lu_supported)
+		hba->sdev_ufs_lu[sdev->lun] = sdev;
+#endif
 	return 0;
 }
 
@@ -4738,6 +4923,16 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 				 */
 				pm_runtime_get_noresume(hba->dev);
 			}
+
+#if defined(CONFIG_SCSI_UFSHPB)
+			/*
+			 * HPB recommendations are provided in RESPONSE UPIU
+			 * packets of successfully completed commands, which
+			 * are commands terminated with GOOD status.
+			 */
+			if (scsi_status == SAM_STAT_GOOD)
+				ufshpb_rsp_handler(hba, lrbp);
+#endif
 			break;
 		case UPIU_TRANSACTION_REJECT_UPIU:
 			/* TODO: handle Reject UPIU Response */
@@ -4843,6 +5038,8 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 				ufshcd_add_command_trace(hba, index,
 						"dev_complete");
 				complete(hba->dev_cmd.complete);
+			} else if (lrbp->ureq) {
+				complete(lrbp->ureq->complete);
 			}
 		}
 		if (ufshcd_is_clkscaling_supported(hba))
@@ -6081,6 +6278,11 @@ static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
 		}
 	}
 	spin_lock_irqsave(host->host_lock, flags);
+
+#if defined(CONFIG_SCSI_UFSHPB)
+	if (hba->ufshpb_state == HPB_PRESENT)
+		hba->ufshpb_state = HPB_NEED_RESET;
+#endif
 	ufshcd_transfer_req_compl(hba);
 	spin_unlock_irqrestore(host->host_lock, flags);
 
@@ -6088,6 +6290,11 @@ static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
 	hba->req_abort_count = 0;
 	ufshcd_update_reg_hist(&hba->ufs_stats.dev_reset, (u32)err);
 	if (!err) {
+#if defined(CONFIG_SCSI_UFSHPB)
+		if (hba->ufshpb_state == HPB_NEED_RESET)
+			schedule_delayed_work(&hba->ufshpb_init_work,
+					      msecs_to_jiffies(10));
+#endif
 		err = SUCCESS;
 	} else {
 		dev_err(hba->dev, "%s: failed with err %d\n", __func__, err);
@@ -6627,16 +6834,16 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 
 	dev_info->ufs_features = desc_buf[DEVICE_DESC_PARAM_UFS_FEAT];
 
-	if (desc_buf[DEVICE_DESC_PARAM_UFS_FEAT] & 0x80) {
-		hba->dev_info.hpb_control_mode =
+	if (dev_info->ufs_features & 0x80) {
+		dev_info->hpb_control_mode =
 			desc_buf[DEVICE_DESC_PARAM_HPB_CTRL_MODE];
-		hba->dev_info.hpb_ver =
+		dev_info->hpb_ver =
 			(u16) (desc_buf[DEVICE_DESC_PARAM_HPB_VER] << 8) |
 			desc_buf[DEVICE_DESC_PARAM_HPB_VER + 1];
 		dev_info(hba->dev, "HPB Version: 0x%2x\n",
-			 hba->dev_info.hpb_ver);
+			 dev_info->hpb_ver);
 		dev_info(hba->dev, "HPB control mode: %d\n",
-			 hba->dev_info.hpb_control_mode);
+			 dev_info->hpb_control_mode);
 	}
 	/*
 	 * getting vendor (manufacturerID) and Bank Index in big endian
@@ -7188,6 +7395,14 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 
 	/* Probe and add UFS logical units  */
 	ret = ufshcd_add_lus(hba);
+
+#if defined(CONFIG_SCSI_UFSHPB)
+	/* Initialize HPB  */
+	if (hba->ufshpb_state == HPB_NEED_INIT)
+		schedule_delayed_work(&hba->ufshpb_init_work,
+				      msecs_to_jiffies(10));
+#endif
+
 out:
 	/*
 	 * If we failed to initialize the device or the device is not
@@ -8316,6 +8531,9 @@ EXPORT_SYMBOL(ufshcd_shutdown);
  */
 void ufshcd_remove(struct ufs_hba *hba)
 {
+#if defined(CONFIG_SCSI_UFSHPB)
+	ufshpb_release(hba, HPB_NEED_INIT);
+#endif
 	ufs_bsg_remove(hba);
 	ufs_sysfs_remove_nodes(hba->dev);
 	blk_cleanup_queue(hba->tmf_queue);
@@ -8531,6 +8749,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 		err = PTR_ERR(hba->cmd_queue);
 		goto out_remove_scsi_host;
 	}
+	blk_queue_max_hw_sectors(hba->cmd_queue, host->max_sectors);
 
 	hba->tmf_tag_set = (struct blk_mq_tag_set) {
 		.nr_hw_queues	= 1,
@@ -8588,6 +8807,9 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	 */
 	ufshcd_set_ufs_dev_active(hba);
 
+#if defined(CONFIG_SCSI_UFSHPB)
+	ufshpb_init(hba);
+#endif
 	async_schedule(ufshcd_async_scan, hba);
 	ufs_sysfs_add_nodes(hba->dev);
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 7ce9cc2f10fe..03890309a963 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -70,6 +70,7 @@
 
 #include "ufs.h"
 #include "ufshci.h"
+#include "ufshpb.h"
 
 #define UFSHCD "ufshcd"
 #define UFSHCD_DRIVER_VERSION "0.2"
@@ -162,6 +163,17 @@ struct ufs_pm_lvl_states {
 	enum uic_link_state link_state;
 };
 
+struct ufs_req {
+	struct request *req;
+	u8 cmd[16];
+	u8 cmd_len;
+	u8 *sense_buffer;
+	u8 lun;
+	unsigned int payload_len;
+	struct sg_table sgt;
+	enum dma_data_direction cmd_dir;
+	struct completion *complete;
+};
 /**
  * struct ufshcd_lrb - local reference block
  * @utr_descriptor_ptr: UTRD address of the command
@@ -206,6 +218,7 @@ struct ufshcd_lrb {
 	bool intr_cmd;
 	ktime_t issue_time_stamp;
 	ktime_t compl_time_stamp;
+	struct ufs_req *ureq;
 
 	bool req_abort_skip;
 };
@@ -727,6 +740,15 @@ struct ufs_hba {
 
 	struct device		bsg_dev;
 	struct request_queue	*bsg_queue;
+
+#if defined(CONFIG_SCSI_UFSHPB)
+	enum UFSHPB_STATE ufshpb_state;
+	struct ufshpb_geo hpb_geo;
+	struct ufshpb_lu *ufshpb_lup[32];
+	struct delayed_work ufshpb_init_work;
+	struct work_struct ufshpb_eh_work;
+	struct scsi_device *sdev_ufs_lu[32];
+#endif
 };
 
 /* Returns true if clocks can be gated. Otherwise false */
@@ -962,6 +984,7 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 			     u8 *desc_buff, int *buff_len,
 			     enum query_opcode desc_op);
 
+int ufshcd_exec_internal_req(struct ufs_hba *hba, struct ufs_req *ureq);
 /* Wrapper functions for safely calling variant operations */
 static inline const char *ufshcd_get_var_name(struct ufs_hba *hba)
 {
diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
new file mode 100644
index 000000000000..79e6b2fa26f1
--- /dev/null
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -0,0 +1,2767 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Universal Flash Storage Host Performance Booster
+ *
+ * Copyright (C) 2017-2018 Samsung Electronics Co., Ltd.
+ *
+ * Authors:
+ *	Yongmyung Lee <ymhungry.lee@samsung.com>
+ *	Jinyoung Choi <j-young.choi@samsung.com>
+ */
+#include <asm/unaligned.h>
+#include <linux/blkdev.h>
+#include <linux/blktrace_api.h>
+#include <linux/sysfs.h>
+#include <scsi/scsi.h>
+
+#include "ufs.h"
+#include "ufshcd.h"
+#include "ufshpb.h"
+#include "ufs_quirks.h"
+
+#define hpb_trace(hpb, args...)						\
+	do { if ((hpb)->hba->sdev_ufs_lu[(hpb)->lun] &&			\
+		(hpb)->hba->sdev_ufs_lu[(hpb)->lun]->request_queue)	\
+		blk_add_trace_msg(					\
+		(hpb)->hba->sdev_ufs_lu[(hpb)->lun]->request_queue,	\
+				##args);				\
+	} while (0)
+
+/*
+ * define global constants
+ */
+static int sects_per_blk_shift;
+static int bits_per_dword_shift;
+static int bits_per_dword_mask;
+static int bits_per_byte_shift;
+
+static int ufshpb_create_sysfs(struct ufs_hba *hba, struct ufshpb_lu *hpb);
+static inline int ufshpb_region_mctx_discard(struct ufshpb_lu *hpb,
+					     struct ufshpb_region *cb);
+static void ufshpb_destroy_subregion_tbl(struct ufshpb_lu *hpb,
+					 struct ufshpb_region *cb);
+static int ufshpb_subregion_mctx_reserve(struct ufshpb_lu *hpb,
+					 struct ufshpb_subregion *cp);
+static inline void ufshpb_cleanup_lru_info(struct ufshpb_lu *hpb,
+					   struct ufshpb_region *cb);
+static void ufshpb_subregion_dirty(struct ufshpb_lu *hpb,
+				   struct ufshpb_subregion *cp);
+static int ufshpb_subregion_l2p_load(struct ufshpb_lu *hpb,
+				     struct ufshpb_subregion *cp, __u64 start_t,
+				     __u64 workq_enter_t);
+
+static void ufshpb_init_constant(struct ufs_hba *hba,
+				 struct ufshpb_geo_desc *geo_desc)
+{
+	struct ufshpb_geo *geo = &hba->hpb_geo;
+	u64 region_entry_sz;
+	int entries_per_region;
+
+	sects_per_blk_shift = ffs(UFS_LOGICAL_BLOCK_SIZE) - ffs(SECTOR_SIZE);
+	bits_per_dword_shift = ffs(BITS_PER_DWORD) - 1;
+	bits_per_dword_mask = BITS_PER_DWORD - 1;
+	bits_per_byte_shift = ffs(BITS_PER_BYTE) - 1;
+
+	geo->region_size_bytes = (u64)
+			SECTOR_SIZE * (0x01 << geo_desc->hpb_region_size);
+	region_entry_sz = geo->region_size_bytes /
+					UFS_LOGICAL_BLOCK_SIZE * HPB_ENTRY_SIZE;
+
+	geo->subregion_size_bytes = (u64)
+			SECTOR_SIZE * (0x01 << geo_desc->hpb_subregion_size);
+	geo->subregion_entry_sz = geo->subregion_size_bytes /
+		UFS_LOGICAL_BLOCK_SIZE * HPB_ENTRY_SIZE;
+
+	geo->dev_max_active_regions = geo_desc->hpb_dev_max_active_regions;
+	geo->max_hpb_lu_cnt = geo_desc->hpb_number_lu;
+	/*
+	 * Relationship across LU, region, subregion, L2P entry:
+	 * lu -> region -> sub region -> entry
+	 */
+	entries_per_region = region_entry_sz / HPB_ENTRY_SIZE;
+	geo->entries_per_subregion = geo->subregion_entry_sz / HPB_ENTRY_SIZE;
+	geo->subregions_per_region = region_entry_sz / geo->subregion_entry_sz;
+
+	/* mempool info */
+	geo->mpage_bytes = PAGE_SIZE;
+	geo->mpages_per_subregion = geo->subregion_entry_sz / geo->mpage_bytes;
+	/* Bitmask Info. */
+	geo->dwords_per_subregion = geo->entries_per_subregion /
+								BITS_PER_DWORD;
+	geo->entries_per_region_shift = ffs(entries_per_region) - 1;
+	geo->entries_per_region_mask = entries_per_region - 1;
+	geo->entries_per_subregion_shift = ffs(geo->entries_per_subregion) - 1;
+	geo->entries_per_subregion_mask = geo->entries_per_subregion - 1;
+
+	hpb_info("Maximum device active regions %d, maximum HPB LUs %d\n",
+		 geo->dev_max_active_regions, geo->max_hpb_lu_cnt);
+	hpb_info("Region size 0x%llx, Region L2P entry size 0x%llx\n",
+		 geo->region_size_bytes, region_entry_sz);
+	hpb_info("Subregion size 0x%llx, subregion L2P entry size 0x%x\n",
+		 geo->subregion_size_bytes, geo->subregion_entry_sz);
+	hpb_info("Subregions per region %d\n", geo->subregions_per_region);
+	hpb_info("Cnt of mpage per subregion %d\n", geo->mpages_per_subregion);
+}
+
+static void ufshpb_init_lu_constant(struct ufshpb_lu *lu_hpb,
+				    struct ufshpb_lu_desc *lu_desc)
+{
+	u64 subregion_size, region_entry_size, subregion_entry_size;
+	u64 last_subregion_size, last_region_size;
+	struct ufs_hba *hba = lu_hpb->hba;
+	struct ufshpb_geo *geo = &hba->hpb_geo;
+	int lu_num_blocks;
+
+	lu_num_blocks = lu_desc->lu_logblk_cnt;
+
+	lu_hpb->lu_max_active_regions = lu_desc->lu_max_active_hpb_regions;
+	lu_hpb->lu_pinned_regions = lu_desc->lu_num_hpb_pinned_regions;
+
+	/*
+	 * HPB Sub-Regions are equally sized except for the last one which is
+	 * smaller if the last HPB Region is not an integer multiple of
+	 * bHPBSubRegionSize
+	 */
+	lu_hpb->subregions_in_last_region = geo->subregions_per_region;
+	lu_hpb->last_subregion_entry_size = geo->subregion_entry_sz;
+	last_region_size = (u64)lu_num_blocks * UFS_LOGICAL_BLOCK_SIZE %
+						geo->region_size_bytes;
+	if (last_region_size) {
+		subregion_size = geo->subregion_size_bytes;
+		last_subregion_size = (u64)last_region_size % subregion_size;
+		if (last_subregion_size) {
+			lu_hpb->subregions_in_last_region = last_region_size /
+				subregion_size + 1;
+			lu_hpb->last_subregion_entry_size =
+				last_subregion_size / UFS_LOGICAL_BLOCK_SIZE *
+				HPB_ENTRY_SIZE;
+		} else {
+			lu_hpb->subregions_in_last_region = last_region_size /
+								subregion_size;
+		}
+	}
+
+	/*
+	 * 1. regions_per_lu = (lu_num_blocks * 4096) / region_size
+	 *		= (lu_num_blocks * HPB_ENTRY_SIZE) / region_entry_size
+	 *		= lu_num_blocks / (region_entry_size / HPB_ENTRY_SIZE)
+	 *
+	 * 2. regions_per_lu = lu_num_blocks / subregion_entry_size (is trik...)
+	 *    if HPB_ENTRY_SIZE != subregions_per_region, it is error.
+	 */
+	subregion_entry_size = geo->subregion_entry_sz;
+	region_entry_size = geo->subregions_per_region * subregion_entry_size;
+	lu_hpb->lu_region_cnt = ((unsigned long long)lu_num_blocks
+			       + (region_entry_size / HPB_ENTRY_SIZE) - 1) /
+				(region_entry_size / HPB_ENTRY_SIZE);
+	lu_hpb->lu_subregion_cnt = ((unsigned long long)lu_num_blocks
+			+ (subregion_entry_size / HPB_ENTRY_SIZE) - 1) /
+			(subregion_entry_size / HPB_ENTRY_SIZE);
+
+	hpb_info("LU%d Maximum active regions %d, pinned regions %d\n",
+		 lu_hpb->lun, lu_hpb->lu_max_active_regions,
+		 lu_hpb->lu_pinned_regions);
+	hpb_info("LU%d Total logical Block Count %d, region count %d\n",
+		 lu_hpb->lun, lu_num_blocks, lu_hpb->lu_region_cnt);
+	hpb_info("LU%d Subregions count per lun %d\n", lu_hpb->lun,
+		 lu_hpb->lu_subregion_cnt);
+	hpb_info("LU%d Last region size 0x%llx, last subregion L2P entry %d\n",
+		 lu_hpb->lun, last_region_size,
+		 lu_hpb->last_subregion_entry_size);
+}
+
+static inline int ufshpb_blocksize_is_supported(struct ufshpb_lu *hpb,
+						int sectors)
+{
+	int ret = true;
+
+	if (sectors > SECTORS_PER_BLOCK)
+		ret = false;
+		/* HPB 1.0 only supports 4KB TRANSFER LENGTH */
+
+	return ret;
+}
+
+static struct
+ufshpb_region *ufshpb_victim_region_select(struct active_region_info *lru_info)
+{
+	struct ufshpb_region *cb;
+	struct ufshpb_region *victim_cb = NULL;
+	u32 hit_count = 0xffffffff;
+
+	switch (lru_info->selection_type) {
+	case LRU:
+		/*
+		 * Choose first region from the active region list
+		 */
+		victim_cb = list_first_entry(&lru_info->lru,
+					     struct ufshpb_region, list_region);
+		break;
+	case LFU:
+		/*
+		 * Choose active region with the lowest hit_count
+		 */
+		list_for_each_entry(cb, &lru_info->lru, list_region) {
+			if (hit_count > cb->hit_count) {
+				hit_count = cb->hit_count;
+				victim_cb = cb;
+			}
+		}
+		break;
+	default:
+		break;
+	}
+
+	return victim_cb;
+}
+
+static inline void ufshpb_get_bit_offset(struct ufshpb_lu *hpb,
+					 int subregion_offset,
+					 int *dword, int *offset)
+{
+	*dword = subregion_offset >> bits_per_dword_shift;
+	*offset = subregion_offset & bits_per_dword_mask;
+}
+
+static inline struct
+hpb_sense_data *ufshpb_get_sense_data(struct ufshcd_lrb *lrbp)
+{
+	return (struct hpb_sense_data *)&lrbp->ucd_rsp_ptr->sr.sense_data_len;
+}
+
+static inline void ufshpb_prepare_read_buf_cmd(unsigned char *cmd, int region,
+					       int subregion, int alloc_len)
+{
+	cmd[0] = UFSHPB_READ_BUFFER;
+	cmd[1] = 0x01;
+	put_unaligned_be16(region, &cmd[2]);
+	put_unaligned_be16(subregion, &cmd[4]);
+	put_unaligned_be24(alloc_len, &cmd[6]);
+	cmd[9] = 0x00;
+}
+
+static void ufshpb_prepare_hpb_read(struct ufshpb_lu *hpb,
+				    struct ufshcd_lrb *lrbp,
+				    unsigned long long entry, int blk_cnt)
+{
+	unsigned char cmd[16] = { };
+	/*
+	 * cmd[14] = Transfer length
+	 */
+	cmd[0] = UFSHPB_READ;
+	cmd[2] = lrbp->cmd->cmnd[2];
+	cmd[3] = lrbp->cmd->cmnd[3];
+	cmd[4] = lrbp->cmd->cmnd[4];
+	cmd[5] = lrbp->cmd->cmnd[5];
+	put_unaligned_be64(entry, &cmd[6]);
+	cmd[14] = blk_cnt;
+	cmd[15] = 0x00;
+	memcpy(lrbp->cmd->cmnd, cmd, 16);
+	memcpy(lrbp->ucd_req_ptr->sc.cdb, cmd, 16);
+}
+
+/* Get L2P entry(8 bytes) from HPB host side memory */
+static inline unsigned long long ufshpb_get_ppn(struct ufshpb_map_ctx *mctx,
+						int pos)
+{
+	unsigned long long *ppn_table;
+	struct page *page;
+	int index, offset;
+
+	index = pos / HPB_ENTREIS_PER_OS_PAGE;
+	offset = pos % HPB_ENTREIS_PER_OS_PAGE;
+
+	page = mctx->m_page[index];
+	WARN_ON(!page);
+
+	ppn_table = page_address(page);
+	WARN_ON(!ppn_table);
+
+	return ppn_table[offset];
+}
+
+/*
+ * Note: hpb->hpb_lock (irq) should be held before calling this function
+ */
+static inline void ufshpb_l2p_entry_dirty_bit_set(struct ufshpb_lu *hpb,
+						  struct ufshpb_region *cb,
+						  struct ufshpb_subregion *cp,
+						  int dword, int offset,
+						  unsigned int count)
+{
+	struct ufshpb_geo *geo;
+	const unsigned long mask = ((1UL << count) - 1) & 0xffffffff;
+
+	if (cb->region_state == REGION_INACTIVE ||
+	    cp->subregion_state == SUBREGION_DIRTY)
+		return;
+
+	geo = &hpb->hba->hpb_geo;
+
+	WARN_ON(!cp->mctx);
+	cp->mctx->ppn_dirty[dword] |= (mask << offset);
+	cp->mctx->ppn_dirty_counter += count;
+
+	if (cp->mctx->ppn_dirty_counter >= geo->entries_per_subregion)
+		ufshpb_subregion_dirty(hpb, cp);
+}
+
+/*
+ * Check if this entry/ppn is dirty or not in the L2P entry cache,
+ * Note: hpb->hpb_lock (irq) should be held before calling this function
+ */
+static bool ufshpb_l2p_entry_dirty_check(struct ufshpb_lu *hpb,
+					 struct ufshpb_subregion *cp,
+					 int subregion_offset)
+{
+	bool is_dirty;
+	unsigned int bit_dword, bit_offset;
+
+	if (!cp->mctx->ppn_dirty || cp->subregion_state == SUBREGION_DIRTY)
+		return false;
+
+	ufshpb_get_bit_offset(hpb, subregion_offset, &bit_dword, &bit_offset);
+
+	is_dirty = cp->mctx->ppn_dirty[bit_dword] & (1 << bit_offset) ?
+								true : false;
+
+	return is_dirty;
+}
+
+static struct ufshpb_rsp_info *ufshpb_rsp_info_get(struct ufshpb_lu *hpb)
+{
+	unsigned long flags;
+	struct ufshpb_rsp_info *rsp_info;
+
+	spin_lock_irqsave(&hpb->rsp_list_lock, flags);
+	rsp_info = list_first_entry_or_null(&hpb->lh_rsp_info_free,
+					    struct ufshpb_rsp_info,
+					    list_rsp_info);
+	if (!rsp_info) {
+		hpb_dbg(FAILURE_INFO, hpb, "No free rsp_info\n");
+		goto out;
+	}
+	list_del(&rsp_info->list_rsp_info);
+	memset(rsp_info, 0x00, sizeof(struct ufshpb_rsp_info));
+
+	INIT_LIST_HEAD(&rsp_info->list_rsp_info);
+out:
+
+	spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
+	return rsp_info;
+}
+
+static void ufshpb_rsp_info_put(struct ufshpb_lu *hpb,
+				struct ufshpb_rsp_info *rsp_info)
+{
+	unsigned long flags;
+
+	WARN_ON(!rsp_info);
+
+	spin_lock_irqsave(&hpb->rsp_list_lock, flags);
+	list_add_tail(&rsp_info->list_rsp_info, &hpb->lh_rsp_info_free);
+	spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
+}
+
+static void ufshpb_rsp_info_fill(struct ufshpb_lu *hpb,
+				 struct ufshpb_rsp_info *rsp_info,
+				 struct hpb_sense_data *sense_data)
+{
+	int num, idx;
+
+	rsp_info->type = HPB_REQ_REGION_UPDATE;
+	rsp_info->rsp_start = ktime_to_ns(ktime_get());
+
+	for (num = 0; num < sense_data->active_region_cnt; num++) {
+		idx = num * PER_ACTIVE_INFO_BYTES;
+		rsp_info->active_list.region[num] =
+			get_unaligned_be16(sense_data->active_field + idx + 0);
+		rsp_info->active_list.subregion[num] =
+			get_unaligned_be16(sense_data->active_field + idx + 2);
+
+		hpb_dbg(REGION_INFO, hpb, "RSP UPIU: ACT[%d]: RG %d, SRG %d",
+			num + 1, rsp_info->active_list.region[num],
+			rsp_info->active_list.subregion[num]);
+	}
+	rsp_info->active_cnt = num;
+
+	for (num = 0; num < sense_data->inactive_region_cnt; num++) {
+		idx = num * PER_INACTIVE_INFO_BYTES;
+		rsp_info->inactive_list.region[num] =
+			get_unaligned_be16(sense_data->inactive_field + idx);
+		hpb_dbg(REGION_INFO, hpb, "RSP UPIU: INACT[%d]: Region%d",
+			num + 1, rsp_info->inactive_list.region[num]);
+	}
+	rsp_info->inactive_cnt = num;
+}
+
+static inline bool ufshpb_is_read_lrbp(struct ufshcd_lrb *lrbp)
+{
+	if (lrbp->cmd->cmnd[0] == READ_10 || lrbp->cmd->cmnd[0] == READ_16)
+		return true;
+
+	return false;
+}
+
+static inline void ufshpb_get_pos_from_lpn(struct ufshpb_lu *hpb,
+					   unsigned int lpn, int *region,
+					   int *subregion, int *offset)
+{
+	int region_offset;
+	struct ufshpb_geo *geo;
+
+	geo = &hpb->hba->hpb_geo;
+
+	*region = lpn >> geo->entries_per_region_shift;
+	region_offset = lpn & geo->entries_per_region_mask;
+	*subregion = region_offset >> geo->entries_per_subregion_shift;
+	*offset = region_offset & geo->entries_per_subregion_mask;
+}
+
+static int ufshpb_subregion_dirty_bitmap_clean(struct ufshpb_lu *hpb,
+					       struct ufshpb_subregion *cp)
+{
+	struct ufshpb_region *cb;
+	struct ufshpb_geo *geo;
+
+	geo = &hpb->hba->hpb_geo;
+
+	cb = hpb->region_tbl + cp->region;
+
+	/* if mctx is null, active block had been evicted out */
+	if (cb->region_state == REGION_INACTIVE || !cp->mctx) {
+		hpb_dbg(FAILURE_INFO, hpb, "RG_SRG (%d-%d) has been evicted\n",
+			cp->region, cp->subregion);
+		return -EINVAL;
+	}
+
+	memset(cp->mctx->ppn_dirty, 0x00,
+	       geo->entries_per_subregion >> bits_per_byte_shift);
+
+	return 0;
+}
+
+/*
+ * Change subregion_state to SUBREGION_CLEAN
+ */
+static void ufshpb_subregion_clean(struct ufshpb_lu *hpb,
+				   struct ufshpb_subregion *cp)
+{
+	struct ufshpb_region *cb;
+
+	cb = hpb->region_tbl + cp->region;
+
+	/*
+	 * If mctx is null or the state of region is not active,
+	 * that means relavent region had been evicted out.
+	 */
+	if (cb->region_state == REGION_INACTIVE || !cp->mctx) {
+		hpb_dbg(FAILURE_INFO, hpb, "RG_SRG (%d-%d) has been evicted\n",
+			cp->region, cp->subregion);
+		return;
+	}
+
+	cp->subregion_state = SUBREGION_CLEAN;
+}
+
+/*
+ * Change subregion_state to SUBREGION_DIRTY, and remain its mctx
+ */
+static void ufshpb_subregion_dirty(struct ufshpb_lu *hpb,
+				   struct ufshpb_subregion *cp)
+{
+	struct ufshpb_region *cb;
+
+	cb = hpb->region_tbl + cp->region;
+
+	/* if mctx is null, active region had been evicted out */
+	if (cb->region_state == REGION_INACTIVE || !cp->mctx ||
+	    cp->subregion_state == SUBREGION_DIRTY) {
+		return;
+	}
+	cp->subregion_state = SUBREGION_DIRTY;
+	cb->subregion_dirty_count++;
+}
+
+static int ufshpb_subregion_is_clean(struct ufshpb_lu *hpb,
+				     struct ufshpb_subregion *cp)
+{
+	struct ufshpb_region *cb;
+	int is_clean;
+
+	cb = hpb->region_tbl + cp->region;
+	is_clean = true;
+
+	if (cb->region_state == REGION_INACTIVE) {
+		is_clean = false;
+		atomic64_inc(&hpb->status.region_miss);
+	} else if (cp->subregion_state != SUBREGION_CLEAN) {
+		is_clean = false;
+		atomic64_inc(&hpb->status.subregion_miss);
+	}
+
+	return is_clean;
+}
+
+/*
+ * Select one victim region from active regions, and discard its mctx.
+ */
+static int ufshpb_evict_one_region(struct ufshpb_lu *hpb, int *victim_region)
+{
+	struct ufshpb_region *victim_cb;
+	struct active_region_info *lru_info;
+	int ret;
+
+	lru_info = &hpb->lru_info;
+
+	victim_cb = ufshpb_victim_region_select(lru_info);
+	if (!victim_cb) {
+		hpb_warn("UFSHPB victim_cb is NULL\n");
+		ret = -EIO;
+		goto out;
+	}
+	hpb_trace(hpb, "%s: VT RG %d", DRIVER_NAME, victim_cb->region);
+	hpb_dbg(REGION_INFO, hpb, "LU%d HPB will discard active region %d\n",
+		hpb->lun,  victim_cb->region);
+
+	ret = ufshpb_region_mctx_discard(hpb, victim_cb);
+	if (ret)
+		goto out;
+
+	if (victim_cb->region_state != REGION_INACTIVE) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	*victim_region = victim_cb->region;
+	return 0;
+out:
+	return ret;
+}
+
+static inline struct ufshpb_map_ctx *ufshpb_mctx_get(struct ufshpb_lu *hpb,
+						     int *err)
+{
+	struct ufshpb_map_ctx *mctx;
+
+	mctx = list_first_entry_or_null(&hpb->lh_map_ctx, struct ufshpb_map_ctx,
+					list_table);
+	if (mctx) {
+		list_del_init(&mctx->list_table);
+		hpb->free_mctx_count--;
+		*err = 0;
+		return mctx;
+	}
+	*err = -ENOMEM;
+
+	return NULL;
+}
+
+static inline void ufshpb_mctx_put(struct ufshpb_lu *hpb,
+				   struct ufshpb_map_ctx *mctx)
+{
+	list_add(&mctx->list_table, &hpb->lh_map_ctx);
+	hpb->free_mctx_count++;
+}
+
+/*
+ * Discard the active subregion mctx, and clear its read_counter
+ */
+static inline void ufshpb_subregion_mctx_purge(struct ufshpb_lu *hpb,
+					       struct ufshpb_subregion *cp,
+					       int state)
+{
+	if (state == SUBREGION_UNUSED) {
+		ufshpb_mctx_put(hpb, cp->mctx);
+		cp->mctx = NULL;
+	}
+
+	cp->subregion_state = state;
+	atomic_set(&cp->read_counter, 0);
+}
+
+struct ufshpb_map_ctx *ufshpb_subregion_mctx_alloc(struct ufshpb_lu *hpb)
+{
+	int i, j;
+	int entries;
+	struct ufshpb_map_ctx *mctx;
+	struct ufshpb_geo *geo;
+
+	geo = &hpb->hba->hpb_geo;
+	entries = geo->entries_per_subregion;
+
+	mctx = kzalloc(sizeof(*mctx), GFP_KERNEL);
+	if (!mctx)
+		return NULL;
+
+	mctx->m_page = kcalloc(geo->mpages_per_subregion, sizeof(struct page *),
+			       GFP_KERNEL);
+	if (!mctx->m_page)
+		goto release_mem;
+
+	mctx->ppn_dirty = kvzalloc(entries >> bits_per_byte_shift, GFP_KERNEL);
+	if (!mctx->ppn_dirty)
+		goto release_mem;
+
+	for (i = 0; i < geo->mpages_per_subregion; i++) {
+		mctx->m_page[i] = alloc_page(GFP_KERNEL | __GFP_ZERO);
+		if (!mctx->m_page[i]) {
+			for (j = 0; j < i; j++)
+				kfree(mctx->m_page[j]);
+			goto release_mem;
+		}
+	}
+	return mctx;
+
+release_mem:
+	kfree(mctx->m_page);
+	kvfree(mctx->ppn_dirty);
+	kfree(mctx);
+	return NULL;
+}
+
+/*
+ * Add new region to active region info lru_info
+ */
+static inline void ufshpb_add_lru_info(struct active_region_info *lru_info,
+				       struct ufshpb_region *cb)
+{
+	cb->region_state = REGION_ACTIVE;
+	cb->hit_count = 1;
+	list_add_tail(&cb->list_region, &lru_info->lru);
+	atomic64_inc(&lru_info->active_cnt);
+}
+
+static inline void ufshpb_hit_lru_info(struct active_region_info *lru_info,
+				       struct ufshpb_region *cb)
+{
+	if (list_empty(&cb->list_region)) {
+		hpb_err("RG %d hasn't been added in lru_info\n", cb->region);
+		return;
+	}
+
+	list_move_tail(&cb->list_region, &lru_info->lru);
+	if (cb->hit_count != 0xffffffff)
+		cb->hit_count++;
+}
+
+/*
+ * Remove active region from active region info lru_info
+ */
+static inline void ufshpb_cleanup_lru_info(struct ufshpb_lu *hpb,
+					   struct ufshpb_region *cb)
+{
+	struct active_region_info *lru_info;
+
+	lru_info = &hpb->lru_info;
+
+	list_del_init(&cb->list_region);
+	cb->region_state = REGION_INACTIVE;
+	cb->hit_count = 0;
+	atomic64_dec(&lru_info->active_cnt);
+}
+
+static void  ufshpb_l2p_load_error_handler(struct ufshpb_lu *hpb,
+					   struct ufshpb_map_req *map_req,
+					   int *retried)
+{
+	struct ufshpb_region *cb;
+	struct scsi_sense_hdr sshdr;
+
+	cb = hpb->region_tbl + map_req->region;
+
+	scsi_normalize_sense(map_req->ureq->sense_buffer, SCSI_SENSE_BUFFERSIZE,
+			     &sshdr);
+
+	hpb_err("LU%d HPB READ BUFFER RG_SRG (%d-%d) failed\n", map_req->lun,
+		map_req->region, map_req->subregion);
+	hpb_err("RSP_code 0x%x sense_key 0x%x ASC 0x%x ASCQ 0x%x\n",
+		sshdr.response_code, sshdr.sense_key, sshdr.asc, sshdr.ascq);
+	hpb_err("byte4 %x byte5 %x byte6 %x additional_len %x\n", sshdr.byte4,
+		sshdr.byte5, sshdr.byte6, sshdr.additional_length);
+
+	atomic64_inc(&hpb->status.rb_fail);
+
+	switch (sshdr.sense_key) {
+	case ILLEGAL_REQUEST:
+		spin_lock(&hpb->hpb_lock);
+		if (cb->region_state == REGION_PINNED &&
+		    map_req->retry_cnt < HPB_MAP_REQ_RETRIES) {
+			/*
+			 * If the HPB buffer Read request for the Pinned region
+			 * meets the UFS device GC, the device will return
+			 * ILLEGAL_REQUEST. For this case, we should retry this
+			 * request later.
+			 */
+			hpb_dbg(REGION_INFO, hpb,
+				"Retry pinned RG_SRG (%d-%d) L2P load",
+				map_req->region, map_req->subregion);
+
+			INIT_LIST_HEAD(&map_req->list_map_req);
+			list_add_tail(&map_req->list_map_req,
+				      &hpb->lh_map_req_retry);
+			spin_unlock(&hpb->hpb_lock);
+
+			schedule_delayed_work(&hpb->retry_work,
+					      msecs_to_jiffies(5000));
+			*retried = 1;
+			return;
+		}
+		hpb_dbg(REGION_INFO, hpb, "Mark RG_SRG (%d-%d) dirty",
+			map_req->region, map_req->subregion);
+		ufshpb_subregion_dirty(hpb, cb->subregion_tbl +
+				       map_req->subregion);
+		spin_unlock(&hpb->hpb_lock);
+		break;
+	default:
+		break;
+	}
+	*retried = 0;
+}
+
+/*
+ * This function is only to change subregion_state to  SUBREGION_CLEAN
+ */
+static void ufshpb_l2p_load_req_compl(struct ufshpb_lu *hpb,
+				      struct ufshpb_map_req *map_req)
+{
+	map_req->req_end_t = ktime_to_ns(ktime_get());
+
+	hpb_trace(hpb, "%s: C RB %d - %d", DRIVER_NAME, map_req->region,
+		  map_req->subregion);
+	hpb_dbg(SCHEDULE_INFO, hpb,
+		"LU%d HPB READ BUFFER COMPL RG_SRG (%d-%d), took %lldns\n",
+		hpb->lun, map_req->region, map_req->subregion,
+		map_req->req_end_t - map_req->req_start_t);
+	hpb_dbg(SCHEDULE_INFO, hpb,
+		"stage1 %lldns, stage2 %lldns, stage3 %lldns",
+		map_req->workq_enter_t - map_req->req_start_t,
+		map_req->req_issue_t - map_req->workq_enter_t,
+		map_req->req_end_t - map_req->req_issue_t);
+
+	spin_lock(&hpb->hpb_lock);
+	ufshpb_subregion_clean(hpb,
+			       hpb->region_tbl[map_req->region].subregion_tbl +
+			       map_req->subregion);
+	spin_unlock(&hpb->hpb_lock);
+}
+
+static int ufshpb_add_bio_page(struct ufshpb_lu *hpb, struct request_queue *q,
+			       struct bio *bio, struct bio_vec *bvec,
+			       struct ufshpb_map_ctx *mctx)
+{
+	struct ufshpb_geo *geo;
+	struct page *page = NULL;
+	int i, ret = 0;
+
+	WARN_ON(!mctx);
+	WARN_ON(!bvec);
+
+	geo = &hpb->hba->hpb_geo;
+	bio_init(bio, bvec, geo->mpages_per_subregion);
+
+	for (i = 0; i < geo->mpages_per_subregion; i++) {
+		page = mctx->m_page[i];
+		if (!page)
+			return -ENOMEM;
+
+		ret = bio_add_pc_page(q, bio, page, geo->mpage_bytes, 0);
+
+		if (ret != geo->mpage_bytes) {
+			hpb_err("bio_add_pc_page() error with ret %d\n", ret);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+static int ufshpb_req_buffer_map(struct ufs_req *ureq)
+{
+	struct request *req = (struct request *)ureq->req;
+	size_t sz = (sizeof(struct scatterlist) * req->nr_phys_segments);
+
+	WARN_ON(!req->nr_phys_segments);
+
+	ureq->sgt.sgl = kzalloc(sz, GFP_KERNEL);
+	if (!ureq->sgt.sgl)
+		return -ENOMEM;
+	sg_init_table(ureq->sgt.sgl, req->nr_phys_segments);
+	ureq->sgt.nents = blk_rq_map_sg(req->q, req, ureq->sgt.sgl);
+	ureq->payload_len = blk_rq_bytes(req);
+	return BLK_STS_OK;
+}
+
+static void ufshpb_map_req_init(struct ufshpb_lu *hpb,
+				struct ufshpb_map_req *map_req,
+				struct ufshpb_subregion *cp,
+				__u64 start_t, __u64 workq_enter_t)
+{
+	map_req->hpb = hpb;
+	map_req->retry_cnt = 0;
+	map_req->region = cp->region;
+	map_req->subregion = cp->subregion;
+	map_req->mctx = cp->mctx;
+	map_req->lun = hpb->lun;
+	memset(&map_req->bio, 0x00, sizeof(struct bio));
+
+	/* Follow parameters used by debug/profile */
+	map_req->req_start_t = start_t;
+	map_req->workq_enter_t = workq_enter_t;
+	map_req->req_issue_t = 0;
+}
+
+static int ufshpb_l2p_load(struct ufshpb_lu *hpb,
+			   struct ufshpb_map_req *map_req)
+{
+	struct ufs_req *ureq;
+	struct ufs_hba *hba = hpb->hba;
+	struct request_queue *q = hpb->hba->cmd_queue;
+	int retried = 0;
+	struct bio *bio;
+	int alloc_len;
+	int ret;
+
+	map_req->ureq = kmalloc(sizeof(struct ufs_req), GFP_KERNEL);
+	if (!map_req->ureq)
+		return -ENOMEM;
+	ureq = map_req->ureq;
+	ureq->req = NULL;
+
+	map_req->ureq->sense_buffer = kmalloc(UFS_SENSE_SIZE, GFP_KERNEL);
+	if (!map_req->ureq->sense_buffer) {
+		kfree(map_req->ureq);
+		return -ENOMEM;
+	}
+
+	bio = &map_req->bio;
+	ret = ufshpb_add_bio_page(hpb, q, bio, map_req->bvec, map_req->mctx);
+	if (ret) {
+		hpb_err("ufshpb_add_bio_page() failed with ret %d\n", ret);
+		goto free_mem;
+	}
+
+	alloc_len = hpb->hba->hpb_geo.subregion_entry_sz;
+	/*
+	 * HPB Sub-Regions are equally sized except for the last one which is
+	 * smaller if the last hpb Region is not an integer multiple of
+	 * bHPBSubRegionSize.
+	 */
+	if (map_req->region == (hpb->lu_region_cnt - 1) &&
+	    map_req->subregion == (hpb->subregions_in_last_region - 1))
+		alloc_len = hpb->last_subregion_entry_size;
+
+	ufshpb_prepare_read_buf_cmd(ureq->cmd, map_req->region,
+				    map_req->subregion, alloc_len);
+	if (!ureq->req) {
+		ureq->req = blk_get_request(q, REQ_OP_SCSI_IN, 0);
+		if (IS_ERR(ureq->req)) {
+			ret =  PTR_ERR(ureq->req);
+			goto free_mem;
+		}
+	}
+
+	blk_rq_append_bio(ureq->req, &bio);
+
+	ureq->cmd_len = 10;
+	ureq->lun = map_req->lun;
+	ureq->cmd_dir = DMA_FROM_DEVICE;
+
+	ufshpb_req_buffer_map(ureq);
+
+	map_req->req_issue_t = ktime_to_ns(ktime_get());
+	atomic64_inc(&hpb->status.map_req_cnt);
+
+	hpb_dbg(SCHEDULE_INFO, hpb, "ISSUE READ_BUFFER : (%d-%d) retry = %d\n",
+		map_req->region, map_req->subregion, map_req->retry_cnt);
+	hpb_trace(hpb, "%s: I RB %d - %d", DRIVER_NAME, map_req->region,
+		  map_req->subregion);
+	ret = ufshcd_exec_internal_req(hpb->hba, ureq);
+
+	if (hba->ufshpb_state != HPB_PRESENT)
+		goto free_mem_req;
+
+	if (ret) {
+		hpb_err("ureq Request result %d\n", ret);
+		ufshpb_l2p_load_error_handler(hpb, map_req, &retried);
+		if (retried)
+			return 0;
+		goto free_mem_req;
+	}
+	ufshpb_l2p_load_req_compl(hpb, map_req);
+
+free_mem_req:
+	blk_put_request(map_req->ureq->req);
+	map_req->ureq->req = NULL;
+free_mem:
+	kfree(ureq->sense_buffer);
+	kfree(ureq->sgt.sgl);
+	kfree(map_req->ureq);
+	INIT_LIST_HEAD(&map_req->list_map_req);
+	spin_lock(&hpb->hpb_lock);
+	list_add_tail(&map_req->list_map_req, &hpb->lh_map_req_free);
+	spin_unlock(&hpb->hpb_lock);
+	return ret;
+}
+
+static int ufshpb_subregion_l2p_load(struct ufshpb_lu *hpb,
+				     struct ufshpb_subregion *cp,
+				     __u64 start_t, __u64 workq_enter_t)
+{
+	struct ufshpb_map_req *map_req;
+
+	spin_lock(&hpb->hpb_lock);
+	map_req = list_first_entry_or_null(&hpb->lh_map_req_free,
+					   struct ufshpb_map_req, list_map_req);
+	if (!map_req) {
+		hpb_dbg(FAILURE_INFO, hpb, "There is no free map_req\n");
+		spin_unlock(&hpb->hpb_lock);
+		return -ENOMEM;
+	}
+	list_del(&map_req->list_map_req);
+	spin_unlock(&hpb->hpb_lock);
+
+	ufshpb_map_req_init(hpb, map_req, cp, start_t, workq_enter_t);
+	return ufshpb_l2p_load(hpb, map_req);
+}
+
+/*
+ * Discard the active region mctx, return 0 on success.
+ * Note: hpb->hpb_lock (irq) should be held before calling this function
+ */
+static inline int ufshpb_region_mctx_discard(struct ufshpb_lu *hpb,
+					     struct ufshpb_region *cb)
+{
+	struct ufshpb_subregion *cp;
+	int subregion;
+
+	if (cb->region_state == REGION_PINNED) {
+		/*
+		 * The pinned active regions should not drop-out. But if so, it
+		 * would treat error as critical, and it will run ufshpb_eh_work
+		 */
+		hpb_warn("Trying to evict HPB pinned region\n");
+		return -ENOMEDIUM;
+	}
+
+	if (list_empty(&cb->list_region))
+		/* The region being evicted has been evicted */
+		return 0;
+
+	hpb_dbg(REGION_INFO, hpb,
+		"\x1b[41m\x1b[33m EVICT region: %d \x1b[0m", cb->region);
+	hpb_trace(hpb, "%s: EVIC RG: %d", DRIVER_NAME, cb->region);
+
+	ufshpb_cleanup_lru_info(hpb, cb);
+
+	atomic64_inc(&hpb->status.region_evict);
+	for (subregion = 0; subregion < cb->subregion_count; subregion++) {
+		cp = cb->subregion_tbl + subregion;
+		ufshpb_subregion_mctx_purge(hpb, cp, SUBREGION_UNUSED);
+	}
+	return 0;
+}
+
+static int ufshpb_subregion_mctx_reserve(struct ufshpb_lu *hpb,
+					 struct ufshpb_subregion *cp)
+{
+	struct active_region_info *lru_info;
+	struct ufshpb_region *cb;
+	int victim_reg;
+	int ret;
+
+	lru_info = &hpb->lru_info;
+	cb = hpb->region_tbl + cp->region;
+
+	if (cp->mctx) {
+		ufshpb_hit_lru_info(lru_info, cb);
+		return 0;
+	}
+
+	if (cb->region_state == REGION_INACTIVE &&
+	    atomic64_read(&lru_info->active_cnt) >=
+	    lru_info->max_active_nor_regions) {
+		/*
+		 * if the number of active HPB Region is equal to the maximum
+		 * active regions supported by device, the host is expected to
+		 * issue a HPB WRITE BUFFER command to inactivate a region
+		 * before activating a new region
+		 */
+		ret = ufshpb_evict_one_region(hpb, &victim_reg);
+		if (ret)
+			return ret;
+	}
+
+	cp->mctx = ufshpb_mctx_get(hpb, &ret);
+	if (ret || !cp->mctx) {
+		hpb_dbg(FAILURE_INFO, hpb,
+			"Failed to get mctx for SRG %d, free mctxs %d",
+			cp->subregion, hpb->free_mctx_count);
+		return -ENOMEM;
+	}
+
+	if (list_empty(&cb->list_region)) {
+		ufshpb_add_lru_info(lru_info, cb);
+		atomic64_inc(&hpb->status.region_add);
+		hpb_dbg(REGION_INFO, hpb,
+			"\x1b[44m\x1b[32m Activate region: %d \x1b[0m",
+			cb->region);
+		hpb_trace(hpb, "%s: ACT RG: %d", DRIVER_NAME, cb->region);
+	} else {
+		ufshpb_hit_lru_info(lru_info, cb);
+	}
+
+	return 0;
+}
+
+/*
+ * Only in the device HPB control mode, the device shall send recommendations
+ * for inactivating active HPB Regions, which means that the related HPB entries
+ * in host side HPB memory are no longer valid. This funciton is just to discard
+ * all HPB entries of the regions indicated in HPB RSP from host side HPB memory
+ */
+static int ufshpb_inactive_rsp_handler(struct ufshpb_lu *hpb,
+				       struct ufshpb_rsp_info *rsp_info)
+{
+	struct ufshpb_region *cb;
+	int region;
+	int ret, i;
+
+	if (!rsp_info->inactive_cnt)
+		return 0;
+
+	spin_lock(&hpb->hpb_lock);
+	for (i = 0; i < rsp_info->inactive_cnt; i++) {
+		region = rsp_info->inactive_list.region[i];
+		cb = hpb->region_tbl + region;
+		ret = ufshpb_region_mctx_discard(hpb, cb);
+		if (ret)
+			break;
+	}
+	spin_unlock(&hpb->hpb_lock);
+	return ret;
+}
+
+static int ufshpb_active_rsp_handler(struct ufshpb_lu *hpb,
+				     struct ufshpb_rsp_info *rsp_info)
+{
+	struct ufshpb_region *cb;
+	struct ufshpb_subregion *cp;
+	int region, subregion;
+	int iter;
+	int ret;
+
+	for (iter = 0; iter < rsp_info->active_cnt; iter++) {
+		region = rsp_info->active_list.region[iter];
+		subregion = rsp_info->active_list.subregion[iter];
+		cb = hpb->region_tbl + region;
+
+		if (region >= hpb->lu_region_cnt ||
+		    subregion >= cb->subregion_count) {
+			hpb_err("RG_SRG (%d-%d) is wrong\n", region, subregion);
+			return -EINVAL;
+		}
+
+		cp = cb->subregion_tbl + subregion;
+
+		spin_lock(&hpb->hpb_lock);
+		if (cp->subregion_state == SUBREGION_ISSUED) {
+			hpb_dbg(SCHEDULE_INFO, hpb,
+				"RG_SRG (%d-%d) HPB BUFFER READ issued\n",
+				region, subregion);
+			spin_unlock(&hpb->hpb_lock);
+			continue;
+		}
+
+		switch (hpb->hba->dev_info.hpb_control_mode) {
+		case HPB_DEV_CTRL_MODE:
+			ret = ufshpb_subregion_mctx_reserve(hpb, cp);
+			if (ret)
+				goto out;
+			break;
+		default:
+			hpb_err("Unknown HPB control mode\n");
+			ret = -EINVAL;
+			goto out;
+		}
+
+		cp->subregion_state = SUBREGION_ISSUED;
+
+		ret = ufshpb_subregion_dirty_bitmap_clean(hpb, cp);
+		spin_unlock(&hpb->hpb_lock);
+
+		if (ret)
+			continue;
+
+		if (hpb->force_map_req_disable) {
+			hpb_notice("map disable - return\n");
+			return 0;
+		}
+
+		ret = ufshpb_subregion_l2p_load(hpb, cp, rsp_info->rsp_start,
+						rsp_info->rsp_tasklet_enter);
+		if (ret) {
+			hpb_err("ufshpb_subregion_l2p_load failed ret %d\n",
+				ret);
+			return ret;
+		}
+	}
+	return 0;
+out:
+	spin_unlock(&hpb->hpb_lock);
+	return ret;
+}
+
+static void ufshpb_recommended_l2p_update(struct ufshpb_lu *hpb,
+					  struct ufshpb_rsp_info *rsp_info)
+{
+	int ret;
+
+	ret = ufshpb_inactive_rsp_handler(hpb, rsp_info);
+	if (ret) {
+		hpb_err("ufshpb_inactive_rsp_handler failed ret %d\n", ret);
+		goto wakeup_ee_worker;
+	}
+
+	ret = ufshpb_active_rsp_handler(hpb, rsp_info);
+	if (ret) {
+		hpb_err("ufshpb_active_rsp_handler failed\n");
+		goto wakeup_ee_worker;
+	}
+
+	return;
+wakeup_ee_worker:
+	hpb->hba->ufshpb_state = HPB_FAILED;
+	schedule_work(&hpb->hba->ufshpb_eh_work);
+}
+
+/*
+ * Note: hpb->hpb_lock (irq) should be held before calling this function
+ */
+static inline int ufshpb_subregion_sync_add(struct ufshpb_lu *hpb,
+					    struct ufshpb_subregion *cp)
+{
+	if (!cp->mctx)
+		return false;
+
+	hpb_dbg(REGION_INFO, hpb, "Add active RG %d, SRG %d state %d to sync\n",
+		cp->region, cp->subregion, cp->subregion_state);
+	list_add_tail(&cp->list_subregion, &hpb->lh_subregion_req);
+	cp->subregion_state = SUBREGION_ISSUED;
+
+	return true;
+}
+
+static int ufshpb_execute_req(struct ufshpb_lu *hpb, unsigned char *cmd,
+			      struct ufshpb_subregion *cp)
+{
+	struct ufs_hba *hba;
+	struct ufshpb_geo *geo;
+	struct request_queue *q;
+	struct request *req;
+	struct scsi_request *scsi_rq;
+	struct scsi_sense_hdr sshdr;
+	struct scsi_device *sdp;
+	struct bio bio;
+	struct bio *bio_p = &bio;
+	struct bio_vec *bvec;
+	unsigned long flags;
+	int ret = 0;
+
+	hba = hpb->hba;
+	geo = &hba->hpb_geo;
+
+	bvec = kvmalloc_array(geo->mpages_per_subregion, sizeof(struct bio_vec),
+			      GFP_KERNEL);
+	if (!bvec)
+		return -ENOMEM;
+
+	sdp = hba->sdev_ufs_lu[hpb->lun];
+	if (!sdp) {
+		hpb_warn("%s UFSHPB cannot find scsi_device\n", __func__);
+		ret = -ENODEV;
+		goto mem_free_out;
+	}
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	ret = scsi_device_get(sdp);
+	if (!ret && !scsi_device_online(sdp)) {
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		ret = -ENODEV;
+		scsi_device_put(sdp);
+		goto mem_free_out;
+	}
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
+	q = sdp->request_queue;
+
+	ret = ufshpb_add_bio_page(hpb, q, &bio, bvec, cp->mctx);
+	if (ret) {
+		scsi_device_put(sdp);
+		goto mem_free_out;
+	}
+
+	req = blk_get_request(q, REQ_OP_SCSI_IN, 0);
+	if (IS_ERR(req))
+		return PTR_ERR(req);
+
+	blk_rq_append_bio(req, &bio_p);
+
+	scsi_rq = scsi_req(req);
+	scsi_req_init(scsi_rq);
+
+	scsi_rq->cmd_len = COMMAND_SIZE(cmd[0]);
+	memcpy(scsi_rq->cmd, cmd, scsi_rq->cmd_len);
+
+	scsi_rq->retries = 3;
+	req->timeout = msecs_to_jiffies(10000);
+
+	blk_execute_rq(q, NULL, req, 1);
+	if (scsi_rq->result) {
+		ret = scsi_rq->result;
+		scsi_normalize_sense(scsi_rq->sense, SCSI_SENSE_BUFFERSIZE,
+				     &sshdr);
+		hpb_err("code 0x%x sense_key 0x%x asc 0x%x ascq 0x%x\n",
+			sshdr.response_code, sshdr.sense_key, sshdr.asc,
+			sshdr.ascq);
+		hpb_err("byte4 0x%x byte5 0x%x byte6 0x%x att_len 0x%x\n",
+			sshdr.byte4, sshdr.byte5, sshdr.byte6,
+			sshdr.additional_length);
+		spin_lock_bh(&hpb->hpb_lock);
+		ufshpb_subregion_dirty(hpb, cp);
+		spin_unlock_bh(&hpb->hpb_lock);
+	} else {
+		ret = 0;
+		spin_lock_bh(&hpb->hpb_lock);
+		ufshpb_subregion_dirty_bitmap_clean(hpb, cp);
+		spin_unlock_bh(&hpb->hpb_lock);
+	}
+	scsi_device_put(sdp);
+	blk_put_request(req);
+mem_free_out:
+	kvfree(bvec);
+	return ret;
+}
+
+static int ufshpb_issue_map_req_from_list(struct ufshpb_lu *hpb)
+{
+	struct ufshpb_subregion *cp, *next_cp;
+	struct ufshpb_geo *geo = &hpb->hba->hpb_geo;
+	int alloc_len;
+	int ret;
+
+	LIST_HEAD(req_list);
+
+	spin_lock_bh(&hpb->hpb_lock);
+	list_splice_init(&hpb->lh_subregion_req, &req_list);
+	spin_unlock_bh(&hpb->hpb_lock);
+
+	list_for_each_entry_safe(cp, next_cp, &req_list, list_subregion) {
+		unsigned char cmd[10] = { };
+
+		alloc_len = geo->subregion_entry_sz;
+		/*
+		 * HPB subregions are equally sized except for the last one
+		 * which is smaller if the last hpb region is not an integer
+		 * multiple of bHPBSubRegionSize.
+		 */
+		if (cp->region == (hpb->lu_region_cnt - 1) &&
+		    cp->subregion == (hpb->subregions_in_last_region - 1))
+			alloc_len = hpb->last_subregion_entry_size;
+
+		ufshpb_prepare_read_buf_cmd(cmd, cp->region, cp->subregion,
+					    alloc_len);
+
+		hpb_dbg(SCHEDULE_INFO, hpb,
+			"RG_SRG (%d-%d) HPB READ BUFFER issued\n", cp->region,
+			cp->subregion);
+
+		hpb_trace(hpb, "%s: I RB %d - %d", DRIVER_NAME, cp->region,
+			  cp->subregion);
+
+		ret = ufshpb_execute_req(hpb, cmd, cp);
+		if (ret < 0) {
+			hpb_err("RG_SRG (%d-%d) HPB READ BUFFER failed %d\n",
+				cp->region, cp->subregion, ret);
+			list_del_init(&cp->list_subregion);
+			continue;
+		}
+
+		hpb_trace(hpb, "%s: C RB %d - %d", DRIVER_NAME, cp->region,
+			  cp->subregion);
+
+		hpb_dbg(REGION_INFO, hpb,
+			"RG_SRG (%d-%d) HPB READ BUFFER COML\n", cp->region,
+			cp->subregion);
+
+		spin_lock_bh(&hpb->hpb_lock);
+		ufshpb_subregion_clean(hpb, cp);
+		list_del_init(&cp->list_subregion);
+		spin_unlock_bh(&hpb->hpb_lock);
+	}
+
+	return 0;
+}
+
+static void ufshpb_sync_workq_fn(struct work_struct *work)
+{
+	struct ufshpb_lu *hpb;
+	int ret;
+
+	hpb = container_of(work, struct ufshpb_lu, ufshpb_sync_work);
+
+	if (!list_empty(&hpb->lh_subregion_req)) {
+		ret = ufshpb_issue_map_req_from_list(hpb);
+		if (ret)
+			hpb_err("Issue map_req failed with ret %d\n", ret);
+	}
+}
+
+static void ufshpb_retry_workq_fn(struct work_struct *work)
+{
+	struct ufshpb_lu *hpb;
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct ufshpb_map_req *map_req;
+	struct request_queue *q;
+	int ret = 0;
+
+	LIST_HEAD(retry_list);
+
+	hpb = container_of(dwork, struct ufshpb_lu, retry_work);
+	hpb_dbg(SCHEDULE_INFO, hpb, "Retry workq start\n");
+
+	spin_lock_bh(&hpb->hpb_lock);
+	list_splice_init(&hpb->lh_map_req_retry, &retry_list);
+	spin_unlock_bh(&hpb->hpb_lock);
+
+	while (1) {
+		map_req = list_first_entry_or_null(&retry_list,
+						   struct ufshpb_map_req,
+						   list_map_req);
+		if (!map_req) {
+			hpb_dbg(SCHEDULE_INFO, hpb, "There is no map_req\n");
+			break;
+		}
+		list_del(&map_req->list_map_req);
+
+		map_req->retry_cnt++;
+
+		q = hpb->hba->sdev_ufs_lu[hpb->lun]->request_queue;
+		ret = ufshpb_l2p_load(hpb, map_req);
+		if (ret) {
+			hpb_err("ufshpb_l2p_load_req error %d\n", ret);
+			goto wakeup_ee_worker;
+		}
+	}
+	hpb_dbg(SCHEDULE_INFO, hpb, "Retry workq end\n");
+	return;
+
+wakeup_ee_worker:
+	hpb->hba->ufshpb_state = HPB_FAILED;
+	schedule_work(&hpb->hba->ufshpb_eh_work);
+}
+
+static void ufshpb_rsp_workq_fn(struct work_struct *work)
+{
+	struct ufshpb_lu *hpb;
+	struct ufshpb_rsp_info *rsp_info;
+	unsigned long flags;
+
+	hpb = container_of(work, struct ufshpb_lu, ufshpb_rsp_work);
+
+	while (1) {
+		spin_lock_irqsave(&hpb->rsp_list_lock, flags);
+		rsp_info = list_first_entry_or_null(&hpb->lh_rsp_info,
+						    struct ufshpb_rsp_info,
+						    list_rsp_info);
+		if (!rsp_info) {
+			spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
+			break;
+		}
+
+		list_del_init(&rsp_info->list_rsp_info);
+		spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
+
+		rsp_info->rsp_tasklet_enter = ktime_to_ns(ktime_get());
+		switch (rsp_info->type) {
+		case HPB_REQ_REGION_UPDATE:
+			ufshpb_recommended_l2p_update(hpb, rsp_info);
+			break;
+		default:
+			hpb_warn("Unknown rsp_info type\n");
+			break;
+		}
+		ufshpb_rsp_info_put(hpb, rsp_info);
+	}
+}
+
+static int ufshpb_init_pinned_region(struct ufshpb_lu *hpb,
+				     struct ufshpb_region *cb)
+{
+	struct ufshpb_subregion *cp;
+	int subregion, j;
+	int err = 0;
+
+	for (subregion = 0; subregion < cb->subregion_count; subregion++) {
+		cp = cb->subregion_tbl + subregion;
+
+		cp->mctx = ufshpb_mctx_get(hpb, &err);
+		if (err) {
+			hpb_err("Failed to get mctx for pinned SRG %d\n",
+				subregion);
+			goto release;
+		}
+		spin_lock_bh(&hpb->hpb_lock);
+		ufshpb_subregion_sync_add(hpb, cp);
+		spin_unlock_bh(&hpb->hpb_lock);
+	}
+
+	cb->region_state = REGION_PINNED;
+	return 0;
+
+release:
+	for (j = 0; j < subregion; j++) {
+		cp = cb->subregion_tbl + j;
+		ufshpb_mctx_put(hpb, cp->mctx);
+	}
+
+	return err;
+}
+
+static inline bool ufshpb_is_pinned_region(struct ufshpb_lu_desc *lu_desc,
+					   int region)
+{
+	if (lu_desc->lu_hpb_pinned_end_offset != -1 &&
+	    region >= lu_desc->hpb_pinned_region_startidx &&
+	    region <= lu_desc->lu_hpb_pinned_end_offset)
+		return true;
+
+	return false;
+}
+
+static inline void ufshpb_init_jobs(struct ufshpb_lu *hpb)
+{
+	INIT_WORK(&hpb->ufshpb_sync_work, ufshpb_sync_workq_fn);
+	INIT_DELAYED_WORK(&hpb->retry_work, ufshpb_retry_workq_fn);
+	INIT_WORK(&hpb->ufshpb_rsp_work, ufshpb_rsp_workq_fn);
+}
+
+static inline void ufshpb_cancel_jobs(struct ufshpb_lu *hpb)
+{
+	cancel_work_sync(&hpb->ufshpb_sync_work);
+	cancel_delayed_work_sync(&hpb->retry_work);
+	cancel_work_sync(&hpb->ufshpb_rsp_work);
+}
+
+static void ufshpb_subregion_tbl_init(struct ufshpb_lu *hpb,
+				      struct ufshpb_region *cb)
+{
+	int subregion;
+
+	for (subregion = 0; subregion < cb->subregion_count; subregion++) {
+		struct ufshpb_subregion *cp = cb->subregion_tbl + subregion;
+
+		cp->region = cb->region;
+		cp->subregion = subregion;
+		cp->subregion_state = SUBREGION_UNUSED;
+	}
+}
+
+static int ufshpb_subregion_tbl_alloc(struct ufshpb_lu *hpb,
+				      struct ufshpb_region *cb,
+				      int subregion_count)
+{
+	cb->subregion_tbl =
+		kcalloc(subregion_count, sizeof(struct ufshpb_subregion),
+			GFP_KERNEL);
+	if (!cb->subregion_tbl)
+		return -ENOMEM;
+
+	cb->subregion_count = subregion_count;
+
+	return 0;
+}
+
+static void ufshpb_mctx_mempool_remove(struct ufshpb_lu *hpb)
+{
+	struct ufshpb_map_ctx *mctx, *next;
+	struct ufshpb_geo *geo;
+	int i;
+
+	geo = &hpb->hba->hpb_geo;
+	list_for_each_entry_safe(mctx, next, &hpb->lh_map_ctx, list_table) {
+		for (i = 0; i < geo->mpages_per_subregion; i++)
+			__free_page(mctx->m_page[i]);
+
+		kvfree(mctx->ppn_dirty);
+		kfree(mctx->m_page);
+		kfree(mctx);
+		hpb->lu_max_mctx_cnt--;
+	}
+
+	if (hpb->lu_max_mctx_cnt != 0)
+		hpb_warn("LU%d still remains mctx %d\n", hpb->lun,
+			 hpb->lu_max_mctx_cnt);
+	else
+		hpb_info("LU%d mctx has been released\n", hpb->lun);
+}
+
+static int ufshpb_mctx_mempool_init(struct ufshpb_lu *hpb, int num_regions,
+				    int subregions_per_region)
+{
+	int i;
+	struct ufshpb_geo *geo;
+	struct ufshpb_map_ctx *mctx = NULL;
+
+	INIT_LIST_HEAD(&hpb->lh_map_ctx);
+
+	for (i = 0; i < num_regions * subregions_per_region; i++) {
+		mctx = ufshpb_subregion_mctx_alloc(hpb);
+		if (!mctx)
+			return -ENOMEM;
+		INIT_LIST_HEAD(&mctx->list_table);
+		list_add(&mctx->list_table, &hpb->lh_map_ctx);
+		hpb->free_mctx_count++;
+	}
+
+	geo = &hpb->hba->hpb_geo;
+
+	hpb->lu_max_mctx_cnt = hpb->free_mctx_count;
+	hpb_info("LU%d mctx cnt %d, %d MiB\n", hpb->lun, hpb->free_mctx_count,
+		 (hpb->lu_max_mctx_cnt * geo->mpages_per_subregion *
+		 geo->mpage_bytes) / SZ_1M);
+	return 0;
+}
+
+static inline void ufshpb_map_req_remove(struct ufshpb_lu *hpb)
+{
+	int i;
+	struct ufshpb_map_req *map_req;
+
+	if (!hpb->map_req)
+		return;
+
+	for (i = 0; i < hpb->map_req_cnt; i++) {
+		map_req = hpb->map_req + i;
+		if (!map_req)
+			break;
+		kfree(map_req->bvec);
+	}
+	kfree(hpb->map_req);
+}
+
+static inline void ufshpb_req_mempool_remove(struct ufshpb_lu *hpb)
+{
+	kfree(hpb->rsp_info);
+	kfree(hpb->req_info);
+	ufshpb_map_req_remove(hpb);
+}
+
+static int ufshpb_req_mempool_init(struct ufshpb_lu *hpb, int pinned_regions,
+				   int queue_depth)
+{
+	struct ufs_hba *hba;
+	struct ufshpb_geo *geo;
+	struct ufshpb_rsp_info *rsp_info = NULL;
+	struct ufshpb_req_info *req_info = NULL;
+	struct ufshpb_map_req *map_req = NULL;
+	int i, map_req_cnt = 0;
+
+	hba = hpb->hba;
+	geo = &hba->hpb_geo;
+
+	if (!queue_depth) {
+		queue_depth = hba->nutrs;
+		hpb_info("LU%d own queue depth is 0, use shared Q-depth %d\n",
+			 hpb->lun, queue_depth);
+	}
+
+	INIT_LIST_HEAD(&hpb->lh_rsp_info);
+	INIT_LIST_HEAD(&hpb->lh_req_info);
+	INIT_LIST_HEAD(&hpb->lh_rsp_info_free);
+	INIT_LIST_HEAD(&hpb->lh_map_req_free);
+	INIT_LIST_HEAD(&hpb->lh_map_req_retry);
+	INIT_LIST_HEAD(&hpb->lh_req_info_free);
+
+	hpb->rsp_info = kcalloc(queue_depth, sizeof(struct ufshpb_rsp_info),
+				GFP_KERNEL);
+	if (!hpb->rsp_info)
+		goto out;
+
+	hpb->req_info = kcalloc(queue_depth, sizeof(struct ufshpb_req_info),
+				GFP_KERNEL);
+	if (!hpb->req_info)
+		goto out_free_rsp;
+
+	map_req_cnt = pinned_regions * geo->subregions_per_region + queue_depth;
+
+	hpb->map_req = kcalloc(map_req_cnt, sizeof(struct ufshpb_map_req),
+			       GFP_KERNEL);
+	if (!hpb->map_req)
+		goto out_free_req;
+	hpb->map_req_cnt = map_req_cnt;
+
+	for (i = 0; i < queue_depth; i++) {
+		rsp_info = hpb->rsp_info + i;
+		req_info = hpb->req_info + i;
+		INIT_LIST_HEAD(&rsp_info->list_rsp_info);
+		INIT_LIST_HEAD(&req_info->list_req_info);
+		list_add_tail(&rsp_info->list_rsp_info, &hpb->lh_rsp_info_free);
+		list_add_tail(&req_info->list_req_info, &hpb->lh_req_info_free);
+	}
+
+	for (i = 0; i < map_req_cnt; i++) {
+		map_req = hpb->map_req + i;
+		map_req->bvec = kcalloc(geo->mpages_per_subregion,
+					sizeof(struct bio_vec), GFP_KERNEL);
+		if (!map_req->bvec) {
+			int j;
+
+			for (j = 0; j < i; j++) {
+				map_req = hpb->map_req + j;
+				kfree(map_req->bvec);
+			}
+			goto out_free_req;
+		}
+		INIT_LIST_HEAD(&map_req->list_map_req);
+		list_add_tail(&map_req->list_map_req, &hpb->lh_map_req_free);
+	}
+
+	return 0;
+out_free_req:
+	kfree(hpb->req_info);
+out_free_rsp:
+	kfree(hpb->rsp_info);
+out:
+	return -ENOMEM;
+}
+
+static int ufshpb_region_subregion_table_alloc(struct ufshpb_lu *hpb,
+					       struct ufshpb_lu_desc *lu_desc)
+{
+	struct ufshpb_region *cb;
+	struct ufshpb_geo *geo;
+	int subregions, subregion_count;
+	int region;
+	bool do_sync_work;
+	int ret = 0;
+	int j;
+
+	WARN_ON(!hpb->lu_region_cnt);
+	WARN_ON(!hpb->lu_subregion_cnt);
+
+	geo = &hpb->hba->hpb_geo;
+	hpb->region_tbl = kcalloc(hpb->lu_region_cnt,
+				  sizeof(struct ufshpb_region), GFP_KERNEL);
+	if (!hpb->region_tbl)
+		return -ENOMEM;
+
+	subregion_count = 0;
+	subregions = hpb->lu_subregion_cnt;
+	for (region = 0; region < hpb->lu_region_cnt; region++) {
+		cb = hpb->region_tbl + region;
+
+		/* Initialize logic subregion information */
+		INIT_LIST_HEAD(&cb->list_region);
+		cb->hit_count = 0;
+		cb->region = region;
+
+		subregion_count = min(subregions, geo->subregions_per_region);
+
+		ret = ufshpb_subregion_tbl_alloc(hpb, cb, subregion_count);
+		if (ret) {
+			hpb_err("Error while allocating subregion_tbl\n");
+			goto release_subregion_tbl;
+		}
+		ufshpb_subregion_tbl_init(hpb, cb);
+
+		if (ufshpb_is_pinned_region(lu_desc, region)) {
+			hpb_info("Region %d PINNED (%d ~ %d)\n", region,
+				 lu_desc->hpb_pinned_region_startidx,
+				 lu_desc->lu_hpb_pinned_end_offset);
+			ret = ufshpb_init_pinned_region(hpb, cb);
+			if (ret)
+				goto release_subregion_tbl;
+
+			do_sync_work = true;
+		} else {
+			cb->region_state = REGION_INACTIVE;
+		}
+
+		subregions -= subregion_count;
+	}
+
+	if (subregions != 0) {
+		hpb_err("Error, remaining %d subregions aren't initializd\n",
+			subregions);
+		goto release_subregion_tbl;
+	}
+
+	hpb_info("LU%d region_tbl size: %lu bytes\n", hpb->lun,
+		 (unsigned long)(sizeof(struct ufshpb_region) *
+				 hpb->lu_region_cnt));
+	hpb_info("LU%d subregion_tbl size: %lu bytes\n", hpb->lun,
+		 (unsigned long)(sizeof(struct ufshpb_subregion) *
+				 hpb->lu_subregion_cnt));
+
+	if (do_sync_work)
+		schedule_work(&hpb->ufshpb_sync_work);
+
+	return 0;
+
+release_subregion_tbl:
+	for (j = 0; j < region; j++) {
+		cb = hpb->region_tbl + j;
+		ufshpb_destroy_subregion_tbl(hpb, cb);
+	}
+	kfree(hpb->region_tbl);
+	return -ENOMEM;
+}
+
+static int ufshpb_lu_init(struct ufs_hba *hba, struct ufshpb_lu *hpb,
+			  struct ufshpb_lu_desc *lu_desc, int lun)
+{
+	int ret = 0;
+	struct ufshpb_geo *geo = &hba->hpb_geo;
+
+	hpb->hba = hba;
+	hpb->lun = lun;
+	hpb->debug = 0;
+	hpb->lu_hpb_enable = true;
+
+	ufshpb_init_lu_constant(hpb, lu_desc);
+
+	if (hpb->lu_max_active_regions <= hpb->lu_pinned_regions) {
+		hpb_err("LU%d configuration is invalid\n", lun);
+		return -EINVAL;
+	}
+
+	spin_lock_init(&hpb->hpb_lock);
+	spin_lock_init(&hpb->rsp_list_lock);
+	spin_lock_init(&hpb->req_list_lock);
+
+	/* Initialize loacl active region info lru */
+	INIT_LIST_HEAD(&hpb->lru_info.lru);
+	hpb->lru_info.selection_type = LRU;
+	/* Set maximum active normal regions supported */
+	hpb->lru_info.max_active_nor_regions = hpb->lu_max_active_regions -
+						hpb->lu_pinned_regions;
+	INIT_LIST_HEAD(&hpb->lh_subregion_req);
+
+	/* Allocate HPB memory for L2P entries */
+	ret = ufshpb_mctx_mempool_init(hpb, hpb->lu_max_active_regions,
+				       geo->subregions_per_region);
+	if (ret) {
+		hpb_err("HPB mapping ctx mempool init failed!\n");
+		goto release_mempool;
+	}
+
+	ret = ufshpb_req_mempool_init(hpb, lu_desc->lu_num_hpb_pinned_regions,
+				      lu_desc->lu_queue_depth);
+	if (ret) {
+		hpb_err("req/rsp info mempool init failed!\n");
+		goto release_mempool;
+	}
+
+	ufshpb_init_jobs(hpb);
+
+	hpb->read_threshold = HPB_DEF_READ_THREASHOLD;
+
+	ret = ufshpb_region_subregion_table_alloc(hpb, lu_desc);
+	if (ret) {
+		hpb_err("region/subregion table alloc failed!\n");
+		goto release_mempool;
+	}
+
+	/*
+	 * Even if creating sysfs failed, ufshpb could run normally. so we don't
+	 * deal with error handling
+	 */
+	ufshpb_create_sysfs(hba, hpb);
+	return 0;
+
+release_mempool:
+	ufshpb_req_mempool_remove(hpb);
+	ufshpb_mctx_mempool_remove(hpb);
+	hpb->lu_hpb_enable = false;
+	return ret;
+}
+
+static int ufshpb_get_hpb_lu_desc(struct ufs_hba *hba,
+				  struct ufshpb_lu_desc *lu_desc, int lun)
+{
+	int ret;
+	u8 buf[QUERY_DESC_MAX_SIZE] = { };
+
+	ret = ufshcd_read_unit_desc_param(hba, lun, 0, buf,
+					  QUERY_DESC_MAX_SIZE);
+	if (ret) {
+		hpb_err("Read unit desc failed with ret %d\n", ret);
+		return ret;
+	}
+
+	if (buf[UNIT_DESC_PARAM_LU_ENABLE] == 0x02) {
+		lu_desc->lu_hpb_enable = true;
+		hpb_info("LU%d HPB is enabled\n", lun);
+	} else {
+		lu_desc->lu_hpb_enable = false;
+		return 0;
+	}
+
+	lu_desc->lu_queue_depth = buf[UNIT_DESC_PARAM_LU_Q_DEPTH];
+
+	lu_desc->lu_logblk_size = buf[UNIT_DESC_PARAM_LOGICAL_BLK_SIZE];
+	lu_desc->lu_logblk_cnt =
+		get_unaligned_be64(&buf[UNIT_DESC_PARAM_LOGICAL_BLK_COUNT]);
+
+	lu_desc->lu_max_active_hpb_regions =
+		get_unaligned_be16(&buf[UNIT_DESC_PARAM_HPB_MAX_ACTIVE_REGIONS]);
+	lu_desc->hpb_pinned_region_startidx =
+		get_unaligned_be16(&buf[UNIT_DESC_PARAM_HPB_PIN_REGION_START_OFFSET]);
+	lu_desc->lu_num_hpb_pinned_regions =
+		get_unaligned_be16(&buf[UNIT_DESC_PARAM_HPB_NUM_PIN_REGIONS]);
+
+	hpb_info("LU%d bLogicalBlockSize %d\n", lun, lu_desc->lu_logblk_size);
+	hpb_info("LU%d wLUMaxActiveHPBRegions %d\n", lun,
+		 lu_desc->lu_max_active_hpb_regions);
+	hpb_info("LU%d wHPBPinnedRegionStartIdx %d\n", lun,
+		 lu_desc->hpb_pinned_region_startidx);
+	hpb_info("LU%d wNumHPBPinnedRegions %d\n", lun,
+		 lu_desc->lu_num_hpb_pinned_regions);
+
+	if (lu_desc->lu_num_hpb_pinned_regions > 0) {
+		lu_desc->lu_hpb_pinned_end_offset =
+			lu_desc->hpb_pinned_region_startidx +
+			lu_desc->lu_num_hpb_pinned_regions - 1;
+		hpb_info("LU%d PINNED regions:  %d -  %d\n", lun,
+			 lu_desc->hpb_pinned_region_startidx,
+			 lu_desc->lu_hpb_pinned_end_offset);
+	} else {
+		lu_desc->lu_hpb_pinned_end_offset = -1;
+	}
+
+	return 0;
+}
+
+static int ufshpb_read_geo_desc_support(struct ufs_hba *hba,
+					struct ufshpb_geo_desc *desc)
+{
+	int err;
+	u8 *geo_buf;
+	size_t buff_len;
+
+	buff_len = hba->desc_size.geom_desc;
+	geo_buf = kmalloc(buff_len, GFP_KERNEL);
+	if (!geo_buf) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	err = ufshcd_read_desc_param(hba, QUERY_DESC_IDN_GEOMETRY, 0, 0,
+				     geo_buf, buff_len);
+	if (err) {
+		hpb_err("%s: Failed reading Device Geometry Desc. err = %d\n",
+			__func__, err);
+		goto out;
+	}
+
+	desc->hpb_region_size = geo_buf[GEOMETRY_DESC_PARAM_HPB_REGION_SIZE];
+	desc->hpb_number_lu = geo_buf[GEOMETRY_DESC_PARAM_HPB_NUMBER_LU];
+	desc->hpb_subregion_size =
+		geo_buf[GEOMETRY_DESC_PARAM_HPB_SUBREGION_SIZE];
+	desc->hpb_dev_max_active_regions =
+		get_unaligned_be16(&geo_buf[GEOMETRY_DESC_PARAM_HPB_MAX_ACTIVE_REGIONS]);
+
+	if (desc->hpb_number_lu == 0) {
+		hpb_warn("There is no LU which supports HPB\n");
+		err = -ENODEV;
+	}
+out:
+	kfree(geo_buf);
+
+	return err;
+}
+
+static void ufshpb_error_handler(struct work_struct *work)
+{
+	struct ufs_hba *hba;
+
+	hba = container_of(work, struct ufs_hba, ufshpb_eh_work);
+	/*
+	 * So far, we don't have a optimal restoring solution，
+	 * in case of fatal error happenning, current soltion is that
+	 * simply kills HPB, in order to not impact normal read.
+	 */
+
+	ufshpb_release(hba, HPB_FAILED);
+	hpb_warn("UFSHPB driver has failed, UFSHCD will run without HPB\n");
+}
+
+static void ufshpb_max_mem_setup(struct ufs_hba *hba)
+{
+	struct ufshpb_geo *geo = &hba->hpb_geo;
+	int preferred_mem_mib = HPB_MAX_MEM_SIZE_MB;
+	u64 region_l2p_mem;
+	int max_regions, min_regions;
+
+	if (!preferred_mem_mib)
+		/* If there is no HPB maximum memory limitation, HPB driver will
+		 * allocate HPB memory for each HPB LU according to each HPB LU
+		 * wLUMaxActiveHPBRegions. The total HPB memory allocatd willn't
+		 * be higher than what calculated by this formula:
+		 *  (bHPBRegionSize(in KB)/4KB)*8*wDeviceMaxActiveHPBRegions
+		 */
+		return;
+
+	/* Calculate how many regions can be activated based on the
+	 * preferred_mem_mib
+	 */
+	region_l2p_mem = (u64)geo->mpages_per_subregion * geo->mpage_bytes *
+		geo->subregions_per_region;
+	max_regions = (u64)(preferred_mem_mib * SZ_1M) / region_l2p_mem;
+
+	min_regions = min(max_regions, geo->dev_max_active_regions);
+	geo->dev_max_active_regions = min_regions;
+
+	hpb_info("Maximum HPB memory %d MiB, Maximum dev active regions %d\n",
+		 preferred_mem_mib, geo->dev_max_active_regions);
+}
+
+static int ufshpb_exec_init(struct ufs_hba *hba)
+{
+	struct ufshpb_geo_desc geo_desc;
+	int lun, i, ret = 1, hpb_dev = 0;
+	int region_balance;
+
+	if (!(hba->dev_info.ufs_features & UFS_FEATURE_SUPPORT_HPB_BIT))
+		goto out;
+
+	ret = ufshpb_read_geo_desc_support(hba, &geo_desc);
+	if (ret)
+		goto out;
+
+	ufshpb_init_constant(hba, &geo_desc);
+
+	ufshpb_max_mem_setup(hba);
+	region_balance = hba->hpb_geo.dev_max_active_regions;
+
+	for (lun = 0; lun < hba->dev_info.max_lu_supported; lun++) {
+		struct ufshpb_lu_desc lu_desc;
+
+		if (!region_balance)
+			break;
+
+		hba->ufshpb_lup[lun] = NULL;
+
+		ret = ufshpb_get_hpb_lu_desc(hba, &lu_desc, lun);
+		if (ret)
+			break;
+
+		if (!lu_desc.lu_hpb_enable)
+			continue;
+
+		hba->ufshpb_lup[lun] =
+			kzalloc(sizeof(struct ufshpb_lu), GFP_KERNEL);
+		if (!hba->ufshpb_lup[lun])
+			break;
+
+		if (region_balance < lu_desc.lu_max_active_hpb_regions)
+			lu_desc.lu_max_active_hpb_regions = region_balance;
+
+		ret = ufshpb_lu_init(hba, hba->ufshpb_lup[lun], &lu_desc, lun);
+		if (ret) {
+			kfree(hba->ufshpb_lup[lun]);
+			break;
+		}
+		hpb_dev++;
+		region_balance -= lu_desc.lu_max_active_hpb_regions;
+
+		hpb_info("LU%d HPB is working now\n", lun);
+	}
+
+	if (hpb_dev == 0) {
+		hpb_info("No UFS HPB is present\n");
+		ret = -ENODEV;
+		goto out_free_mem;
+	}
+
+	INIT_WORK(&hba->ufshpb_eh_work, ufshpb_error_handler);
+	hba->ufshpb_state = HPB_PRESENT;
+
+	return 0;
+
+out_free_mem:
+	for (i = 0; i < lun; i++)
+		kfree(hba->ufshpb_lup[i]);
+out:
+	hba->ufshpb_state = HPB_NOT_SUPPORTED;
+	return ret;
+}
+
+static void ufshpb_purge_active_region(struct ufshpb_lu *hpb)
+{
+	int region, subregion, state;
+	struct ufshpb_region *cb;
+	struct ufshpb_subregion *cp;
+
+	spin_lock_bh(&hpb->hpb_lock);
+	for (region = 0; region < hpb->lu_region_cnt; region++) {
+		cb = hpb->region_tbl + region;
+
+		if (cb->region_state == REGION_INACTIVE) {
+			hpb_dbg(REGION_INFO, hpb, "region %d is inactive\n",
+				region);
+			continue;
+		}
+		if (cb->region_state == REGION_PINNED) {
+			state = SUBREGION_DIRTY;
+		} else if (cb->region_state == REGION_ACTIVE) {
+			state = SUBREGION_UNUSED;
+			ufshpb_cleanup_lru_info(hpb, cb);
+		} else {
+			hpb_notice("Unsupported region state %d\n",
+				   cb->region_state);
+			continue;
+		}
+
+		for (subregion = 0; subregion < cb->subregion_count;
+		     subregion++) {
+			cp = cb->subregion_tbl + subregion;
+			ufshpb_subregion_mctx_purge(hpb, cp, state);
+		}
+	}
+	spin_unlock_bh(&hpb->hpb_lock);
+}
+
+static void ufshpb_retrieve_rsp_info(struct ufshpb_lu *hpb)
+{
+	struct ufshpb_rsp_info *rsp_info;
+	unsigned long flags;
+
+	while (1) {
+		spin_lock_irqsave(&hpb->rsp_list_lock, flags);
+		rsp_info = list_first_entry_or_null(&hpb->lh_rsp_info,
+						    struct ufshpb_rsp_info,
+						    list_rsp_info);
+		if (!rsp_info) {
+			spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
+			break;
+		}
+
+		list_move_tail(&rsp_info->list_rsp_info,
+			       &hpb->lh_rsp_info_free);
+
+		spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
+	}
+}
+
+static void ufshpb_retrieve_req_info(struct ufshpb_lu *hpb)
+{
+	struct ufshpb_req_info *req_info;
+	unsigned long flags;
+
+	while (1) {
+		spin_lock_irqsave(&hpb->req_list_lock, flags);
+		req_info = list_first_entry_or_null(&hpb->lh_req_info,
+						    struct ufshpb_req_info,
+						    list_req_info);
+		if (!req_info) {
+			spin_unlock_irqrestore(&hpb->req_list_lock, flags);
+			break;
+		}
+
+		list_move_tail(&req_info->list_req_info,
+			       &hpb->lh_req_info_free);
+
+		spin_unlock_irqrestore(&hpb->req_list_lock, flags);
+	}
+}
+
+static void ufshpb_reset(struct ufs_hba *hba)
+{
+	struct ufshpb_lu *hpb;
+	int lu;
+
+	for (lu = 0; lu < hba->dev_info.max_lu_supported; lu++) {
+		hpb = hba->ufshpb_lup[lu];
+
+		if (hpb && hpb->lu_hpb_enable) {
+			hpb_notice("LU%d HPB RESET\n", lu);
+
+			ufshpb_cancel_jobs(hpb);
+			ufshpb_retrieve_rsp_info(hpb);
+			ufshpb_retrieve_req_info(hpb);
+			ufshpb_purge_active_region(hpb);
+			/* FIXME add hpb reset */
+			ufshpb_init_jobs(hpb);
+		}
+	}
+
+	hba->ufshpb_state = HPB_PRESENT;
+}
+
+static void ufshpb_destroy_subregion_tbl(struct ufshpb_lu *hpb,
+					 struct ufshpb_region *cb)
+{
+	int subregion;
+
+	if (!cb->subregion_tbl)
+		return;
+
+	for (subregion = 0; subregion < cb->subregion_count; subregion++) {
+		struct ufshpb_subregion *cp;
+
+		cp = cb->subregion_tbl + subregion;
+
+		hpb_info("Subregion %d-> %p state %d mctx-> %p released\n",
+			 subregion, cp, cp->subregion_state, cp->mctx);
+
+		cp->subregion_state = SUBREGION_UNUSED;
+		if (cp->mctx)
+			ufshpb_mctx_put(hpb, cp->mctx);
+	}
+
+	kfree(cb->subregion_tbl);
+}
+
+static void ufshpb_destroy_region_tbl(struct ufshpb_lu *hpb)
+{
+	int region;
+
+	for (region = 0; region < hpb->lu_region_cnt; region++) {
+		struct ufshpb_region *cb;
+
+		cb = hpb->region_tbl + region;
+		hpb_info("LU%d free sub/region %d tbl, state %d\n", hpb->lun,
+			 region, cb->region_state);
+
+		if (cb->region_state == REGION_PINNED ||
+		    cb->region_state == REGION_ACTIVE) {
+			cb->region_state = REGION_INACTIVE;
+
+			ufshpb_destroy_subregion_tbl(hpb, cb);
+		}
+	}
+
+	kfree(hpb->region_tbl);
+}
+
+static int ufshpb_sense_data_checkup(struct ufs_hba *hba,
+				     struct hpb_sense_data *sense_data)
+{
+	if (get_unaligned_be16(&sense_data->len[0]) != HPB_SENSE_DATA_LEN ||
+	    sense_data->desc_type != HPB_DESCRIPTOR_TYPE ||
+	    sense_data->additional_len != HPB_ADDITIONAL_LEN ||
+	    sense_data->hpb_op == HPB_RSP_NONE ||
+	    sense_data->active_region_cnt > MAX_ACTIVE_NUM ||
+	    sense_data->inactive_region_cnt > MAX_INACTIVE_NUM) {
+		hpb_err("HPB Sense Data Error\n");
+		hpb_err("Sense Data Length (12h): 0x%x\n",
+			get_unaligned_be16(&sense_data->len[0]));
+		hpb_err("Descriptor Type: 0x%x\n", sense_data->desc_type);
+		hpb_err("Additional Len: 0x%x\n", sense_data->additional_len);
+		hpb_err("HPB Operation: 0x%x\n", sense_data->hpb_op);
+		hpb_err("Active HPB Count: 0x%x\n",
+			sense_data->active_region_cnt);
+		hpb_err("Inactive HPB Count: 0x%x\n",
+			sense_data->inactive_region_cnt);
+		return false;
+	}
+	return true;
+}
+
+static void ufshpb_init_workq_fn(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct ufs_hba *hba;
+	int err;
+#if defined(CONFIG_SCSI_SCAN_ASYNC)
+	unsigned long flags;
+#endif
+
+	hba = container_of(dwork, struct ufs_hba, ufshpb_init_work);
+
+#if defined(CONFIG_SCSI_SCAN_ASYNC)
+	mutex_lock(&hba->host->scan_mutex);
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	if (hba->host->async_scan == 1) {
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+		mutex_unlock(&hba->host->scan_mutex);
+		hpb_info("Not set scsi-device-info, so re-sched.\n");
+		schedule_delayed_work(&hba->ufshpb_init_work,
+				      msecs_to_jiffies(100));
+		return;
+	}
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	mutex_unlock(&hba->host->scan_mutex);
+#endif
+
+	switch (hba->ufshpb_state) {
+	case HPB_NEED_INIT:
+		err = ufshpb_exec_init(hba);
+		if (err)
+			hpb_warn("%s failed, err %d, UFS runs without HPB\n",
+				 __func__, err);
+		break;
+	case HPB_NEED_RESET:
+		ufshpb_reset(hba);
+		break;
+	default:
+		hpb_warn("Unkonwn HPB state\n");
+		break;
+	}
+}
+
+void ufshpb_init(struct ufs_hba *hba)
+{
+	hba->ufshpb_state = HPB_NEED_INIT;
+	INIT_DELAYED_WORK(&hba->ufshpb_init_work, ufshpb_init_workq_fn);
+}
+
+void ufshpb_release(struct ufs_hba *hba, enum UFSHPB_STATE state)
+{
+	int lun;
+	struct ufshpb_lu *hpb;
+
+	hba->ufshpb_state = HPB_FAILED;
+
+	for (lun = 0; lun < hba->dev_info.max_lu_supported; lun++) {
+		hpb = hba->ufshpb_lup[lun];
+
+		if (!hpb)
+			continue;
+
+		if (!hpb->lu_hpb_enable)
+			continue;
+
+		hpb_notice("LU%d HPB will be released\n", lun);
+
+		hba->ufshpb_lup[lun] = NULL;
+
+		hpb->lu_hpb_enable = false;
+
+		ufshpb_cancel_jobs(hpb);
+
+		ufshpb_destroy_region_tbl(hpb);
+
+		ufshpb_req_mempool_remove(hpb);
+
+		ufshpb_mctx_mempool_remove(hpb);
+
+		kobject_uevent(&hpb->kobj, KOBJ_REMOVE);
+		kobject_del(&hpb->kobj);
+
+		kfree(hpb);
+	}
+
+	hba->ufshpb_state = state;
+}
+
+void ufshpb_rsp_handler(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
+{
+	struct ufshpb_lu *hpb;
+	struct hpb_sense_data *sense_data;
+	struct ufshpb_rsp_info *rsp_info;
+	int data_seg_len;
+
+	if (hba->ufshpb_state != HPB_PRESENT)
+		return;
+
+	if (!lrbp || !lrbp->ucd_rsp_ptr)
+		return;
+
+	/* Well Known LU doesn't support HPB */
+	if (lrbp->lun >= hba->dev_info.max_lu_supported)
+		return;
+
+	data_seg_len = be32_to_cpu(lrbp->ucd_rsp_ptr->header.dword_2)
+		       & MASK_RSP_UPIU_DATA_SEG_LEN;
+	/* FIXME Add Device informaiton checkup bit 1: HPB_UPDATE_ALERT = 1 */
+	if (!data_seg_len) {
+		bool do_tasklet = false;
+
+		hpb = hba->ufshpb_lup[lrbp->lun];
+		if (!hpb)
+			return;
+		/*
+		 * No recommmended region in response, but we still have
+		 * recommmended region to enactive in list lh_rsp_info.
+		 */
+		spin_lock(&hpb->rsp_list_lock);
+		do_tasklet = !list_empty(&hpb->lh_rsp_info);
+		spin_unlock(&hpb->rsp_list_lock);
+
+		if (do_tasklet)
+			schedule_work(&hpb->ufshpb_rsp_work);
+		return;
+	}
+
+	sense_data = ufshpb_get_sense_data(lrbp);
+
+	WARN_ON(!sense_data);
+
+	if (!ufshpb_sense_data_checkup(hba, sense_data))
+		return;
+
+	hpb = hba->ufshpb_lup[lrbp->lun];
+	if (!hpb) {
+		hpb_warn("%s LU%d didn't allocated HPB\n", __func__, lrbp->lun);
+		return;
+	}
+
+	hpb_dbg(REGION_INFO, hpb,
+		"RSP UPIU for LU%d: HPB OP %d, Data Len 0x%x\n",
+		sense_data->lun,  sense_data->hpb_op, data_seg_len);
+
+	atomic64_inc(&hpb->status.rb_noti_cnt);
+
+	if (!hpb->lu_hpb_enable) {
+		hpb_warn("LU%d HPB has been disabled.\n", lrbp->lun);
+		return;
+	}
+
+	rsp_info = ufshpb_rsp_info_get(hpb);
+	if (!rsp_info) {
+		hpb_warn("%s:%d There is no free rsp_info\n", __func__,
+			 __LINE__);
+		return;
+	}
+
+	switch (sense_data->hpb_op) {
+	case HPB_REQ_REGION_UPDATE:
+		WARN_ON(data_seg_len != HPB_DATA_SEG_LEN);
+		ufshpb_rsp_info_fill(hpb, rsp_info, sense_data);
+
+		hpb_trace(hpb, "%s: #ACT %d, #INACT %d", DRIVER_NAME,
+			  rsp_info->active_cnt, rsp_info->inactive_cnt);
+
+		spin_lock(&hpb->rsp_list_lock);
+		list_add_tail(&rsp_info->list_rsp_info, &hpb->lh_rsp_info);
+		spin_unlock(&hpb->rsp_list_lock);
+
+		schedule_work(&hpb->ufshpb_rsp_work);
+		break;
+
+	default:
+		hpb_warn("HPB Operation %d is not supported\n",
+			 sense_data->hpb_op);
+		break;
+	}
+}
+
+void ufshpb_prep_fn(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
+{
+	struct request *rq;
+	struct ufshpb_lu *hpb;
+	struct ufshpb_region *cb;
+	struct ufshpb_subregion *cp;
+	unsigned long long ppn = 0;
+	unsigned long long rq_pos;
+	unsigned int rq_sectors;
+	unsigned int lpn;
+	int region, subregion, subregion_offset;
+	int blk_cnt = 1;
+
+	/* WKLU doesn't support HPB */
+	if (!lrbp || lrbp->lun >= hba->dev_info.max_lu_supported)
+		return;
+
+	hpb = hba->ufshpb_lup[lrbp->lun];
+	if (!hpb)
+		return;
+
+	/* If HPB has been disabled or not enabled yet */
+	if (!hpb->lu_hpb_enable || hpb->force_disable)
+		return;
+	/*
+	 * Convert sector address(in 512B unit) to block address (in 4KB unit),
+	 * since minimum Logical block size supported by HPB is 4KB.
+	 */
+	rq = lrbp->cmd->request;
+	rq_pos = blk_rq_pos(rq);
+	rq_sectors = blk_rq_sectors(rq);
+	lpn = rq_pos / SECTORS_PER_BLOCK;
+
+	/* Get region, subregion and offset according to page address */
+	ufshpb_get_pos_from_lpn(hpb, lpn, &region, &subregion,
+				&subregion_offset);
+	cb = hpb->region_tbl + region;
+
+	/* Check if it is the read cmd */
+	if (!ufshpb_is_read_lrbp(lrbp))
+		return;
+
+	cp = cb->subregion_tbl + subregion;
+
+	spin_lock_bh(&hpb->hpb_lock);
+
+	if (!ufshpb_subregion_is_clean(hpb, cp)) {
+		spin_unlock_bh(&hpb->hpb_lock);
+		return;
+	}
+
+	if (ufshpb_blocksize_is_supported(hpb, rq_sectors) != true) {
+		spin_unlock_bh(&hpb->hpb_lock);
+		return;
+	}
+
+	if (ufshpb_l2p_entry_dirty_check(hpb, cp, subregion_offset)) {
+		atomic64_inc(&hpb->status.entry_dirty_miss);
+		hpb_dbg(REGION_INFO, hpb, "0x%llx + %u HPB PPN Dirty %d - %d\n",
+			rq_pos, rq_sectors, region, subregion);
+		spin_unlock_bh(&hpb->hpb_lock);
+		return;
+	}
+
+	ppn = ufshpb_get_ppn(cp->mctx, subregion_offset);
+
+	if (cb->subregion_count == 1)
+		ufshpb_hit_lru_info(&hpb->lru_info, cb);
+
+	spin_unlock_bh(&hpb->hpb_lock);
+
+	if (rq_sectors != SECTORS_PER_BLOCK) {
+		int remainder;
+
+		remainder = rq_sectors % SECTORS_PER_BLOCK;
+		blk_cnt = rq_sectors / SECTORS_PER_BLOCK;
+		if (remainder)
+			blk_cnt += 1;
+		hpb_dbg(NORMAL_INFO, hpb,
+			"Read %d blks (%d sects) from 0x%llx, %d: %d\n",
+			blk_cnt, rq_sectors, rq_pos, region, subregion);
+	}
+
+	ufshpb_prepare_hpb_read(hpb, lrbp, ppn, blk_cnt);
+	hpb_trace(hpb, "%s: %llu + %u HPB READ %d - %d", DRIVER_NAME, rq_pos,
+		  rq_sectors, region, subregion);
+	hpb_dbg(NORMAL_INFO, hpb,
+		"PPN: 0x%llx, LA: 0x%llx + %u HPB READ from RG %d - SRG %d",
+		ppn, rq_pos, rq_sectors, region, subregion);
+	atomic64_inc(&hpb->status.hit);
+}
+
+static void ufshpb_sysfs_stat_init(struct ufshpb_lu *hpb)
+{
+	atomic64_set(&hpb->status.hit, 0);
+	atomic64_set(&hpb->status.miss, 0);
+	atomic64_set(&hpb->status.region_miss, 0);
+	atomic64_set(&hpb->status.subregion_miss, 0);
+	atomic64_set(&hpb->status.entry_dirty_miss, 0);
+	atomic64_set(&hpb->status.rb_noti_cnt, 0);
+	atomic64_set(&hpb->status.map_req_cnt, 0);
+	atomic64_set(&hpb->status.region_evict, 0);
+	atomic64_set(&hpb->status.region_add, 0);
+	atomic64_set(&hpb->status.rb_fail, 0);
+}
+
+static ssize_t ufshpb_sysfs_kill_hpb_store(struct ufshpb_lu *hpb,
+					   const char *buf, size_t count)
+{
+	unsigned long value;
+
+	if (kstrtoul(buf, 0, &value)) {
+		hpb_err("kstrtoul error\n");
+		return -EINVAL;
+	}
+
+	if (value == 0) {
+		hpb_info("LU%d HPB will be killed manually\n", hpb->lun);
+		goto kill_hpb;
+	} else {
+		hpb_info("Unrecognize value inputted %lu\n", value);
+	}
+
+	return count;
+kill_hpb:
+	hpb->hba->ufshpb_state = HPB_FAILED;
+	schedule_work(&hpb->hba->ufshpb_eh_work);
+	return count;
+}
+
+static ssize_t ufshpb_sysfs_rsp_req_show(struct ufshpb_lu *hpb, char *buf)
+{
+	long long rb_noti_cnt, map_req_cnt;
+
+	rb_noti_cnt = atomic64_read(&hpb->status.rb_noti_cnt);
+	map_req_cnt = atomic64_read(&hpb->status.map_req_cnt);
+
+	return snprintf(buf, PAGE_SIZE,
+			"Recommend RSP count %lld HPB Buffer Read count %lld\n",
+			rb_noti_cnt, map_req_cnt);
+}
+
+static ssize_t ufshpb_sysfs_count_reset_store(struct ufshpb_lu *hpb,
+					      const char *buf, size_t count)
+{
+	unsigned long debug;
+
+	if (kstrtoul(buf, 0, &debug))
+		return -EINVAL;
+
+	ufshpb_sysfs_stat_init(hpb);
+
+	return count;
+}
+
+static ssize_t ufshpb_sysfs_add_evict_show(struct ufshpb_lu *hpb, char *buf)
+{
+	long long add, evict;
+
+	add = atomic64_read(&hpb->status.region_add);
+	evict = atomic64_read(&hpb->status.region_evict);
+
+	return snprintf(buf, PAGE_SIZE, "Add %lld, Evict %lld\n", add, evict);
+}
+
+static ssize_t ufshpb_sysfs_hit_show(struct ufshpb_lu *hpb, char *buf)
+{
+	long long hit;
+
+	hit = atomic64_read(&hpb->status.hit);
+
+	return snprintf(buf, PAGE_SIZE, "LU%d HPB Total hit: %lld\n",
+			hpb->lun, hit);
+}
+
+static ssize_t ufshpb_sysfs_miss_show(struct ufshpb_lu *hpb, char *buf)
+{
+	long long region_miss, subregion_miss, entry_dirty_miss, rb_fail;
+	int ret = 0, count = 0;
+
+	region_miss = atomic64_read(&hpb->status.region_miss);
+	subregion_miss = atomic64_read(&hpb->status.subregion_miss);
+	entry_dirty_miss = atomic64_read(&hpb->status.entry_dirty_miss);
+	rb_fail = atomic64_read(&hpb->status.rb_fail);
+
+	ret = sprintf(buf + count, "Total entries missed: %lld\n",
+		      region_miss + subregion_miss + entry_dirty_miss);
+	count += ret;
+
+	ret = sprintf(buf + count, "Region: %lld\n", region_miss);
+	count += ret;
+
+	ret = sprintf(buf + count, "subregion: %lld, entry dirty: %lld\n",
+		      subregion_miss, entry_dirty_miss);
+	count += ret;
+
+	ret = sprintf(buf + count, "HPB Read Buffer CMD failure: %lld\n",
+		      rb_fail);
+
+	return (count + ret);
+}
+
+static ssize_t ufshpb_sysfs_active_region_show(struct ufshpb_lu *hpb, char *buf)
+{
+	int ret = 0, count = 0, region, total = 0;
+
+	ret = sprintf(buf, " ACTIVE Region List:\n");
+	count = ret;
+
+	for (region = 0; region < hpb->lu_region_cnt; region++) {
+		if (hpb->region_tbl[region].region_state == REGION_ACTIVE ||
+		    hpb->region_tbl[region].region_state == REGION_PINNED) {
+			ret = sprintf(buf + count, "%d,", region);
+			total++;
+			count += ret;
+		}
+	}
+
+	ret = sprintf(buf + count, "Total: %d\n", total);
+	count += ret;
+
+	return count;
+}
+
+static ssize_t ufshpb_sysfs_act_subregion_show(struct ufshpb_lu *hpb, char *buf)
+{
+	int ret = 0, count = 0, region, sub;
+	struct ufshpb_region *cb;
+	int state;
+
+	ret = sprintf(buf, "Clean Subregion List:\n");
+	count = ret;
+
+	for (region = 0; region < hpb->lu_region_cnt; region++) {
+		cb = hpb->region_tbl + region;
+		for (sub = 0; sub < cb->subregion_count; sub++) {
+			state = cb->subregion_tbl[sub].subregion_state;
+			if (state == SUBREGION_CLEAN) {
+				ret = sprintf(buf + count, "%d:%d ", region,
+					      sub);
+				count += ret;
+			}
+		}
+	}
+
+	ret = sprintf(buf + count, "\n");
+	count += ret;
+
+	return count;
+}
+
+static ssize_t ufshpb_sysfs_debug_store(struct ufshpb_lu *hpb,
+					const char *buf, size_t count)
+{
+	unsigned long debug;
+
+	if (kstrtoul(buf, 0, &debug))
+		return -EINVAL;
+
+	if (debug > 0)
+		hpb->debug = debug;
+	else
+		hpb->debug = 0;
+
+	return count;
+}
+
+static ssize_t ufshpb_sysfs_debug_show(struct ufshpb_lu *hpb, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n",	hpb->debug);
+}
+
+static ssize_t ufshpb_sysfs_map_disable_show(struct ufshpb_lu *hpb, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, ">> Force_map_req_disable: %d\n",
+			hpb->force_map_req_disable);
+}
+
+static ssize_t ufshpb_sysfs_map_disable_store(struct ufshpb_lu *hpb,
+					      const char *buf, size_t count)
+{
+	unsigned long value;
+
+	if (kstrtoul(buf, 0, &value))
+		return -EINVAL;
+
+	if (value > 1)
+		value = 1;
+
+	if (value == 1)
+		hpb->force_map_req_disable = true;
+	else if (value == 0)
+		hpb->force_map_req_disable = false;
+	else
+		hpb_err("Error value: %lu\n", value);
+
+	return count;
+}
+
+static ssize_t ufshpb_sysfs_disable_show(struct ufshpb_lu *hpb, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "LU%d  HPB force_disable: %d\n",
+			hpb->lun, hpb->force_disable);
+}
+
+static ssize_t ufshpb_sysfs_disable_store(struct ufshpb_lu *hpb,
+					  const char *buf, size_t count)
+{
+	unsigned long value;
+
+	if (kstrtoul(buf, 0, &value))
+		return -EINVAL;
+
+	if (value > 1)
+		value = 1;
+
+	if (value == 1)
+		hpb->force_disable = true;
+	else if (value == 0)
+		hpb->force_disable = false;
+	else
+		hpb_err("Error value: %lu\n", value);
+
+	return count;
+}
+
+static struct ufshpb_sysfs_entry ufshpb_sysfs_entries[] = {
+	__ATTR(bypass_hpb, 0644, ufshpb_sysfs_disable_show,
+	       ufshpb_sysfs_disable_store),
+	__ATTR(map_req_disable, 0644, ufshpb_sysfs_map_disable_show,
+	       ufshpb_sysfs_map_disable_store),
+	__ATTR(active_subregion, 0444, ufshpb_sysfs_act_subregion_show, NULL),
+	__ATTR(active_region, 0444, ufshpb_sysfs_active_region_show, NULL),
+	__ATTR(debug, 0644, ufshpb_sysfs_debug_show, ufshpb_sysfs_debug_store),
+	__ATTR(hit_count, 0444, ufshpb_sysfs_hit_show, NULL),
+	__ATTR(miss_count, 0444, ufshpb_sysfs_miss_show, NULL),
+	__ATTR(region_add_evict_count, 0444, ufshpb_sysfs_add_evict_show, NULL),
+	__ATTR(rsp_req_count, 0444, ufshpb_sysfs_rsp_req_show, NULL),
+	__ATTR(kill_hpb, 0200, NULL, ufshpb_sysfs_kill_hpb_store),
+	__ATTR(reset_counter, 0200, NULL, ufshpb_sysfs_count_reset_store),
+	__ATTR_NULL
+};
+
+static ssize_t ufshpb_attr_show(struct kobject *kobj, struct attribute *attr,
+				char *page)
+{
+	struct ufshpb_sysfs_entry *entry;
+	struct ufshpb_lu *hpb;
+	ssize_t error;
+
+	entry = container_of(attr, struct ufshpb_sysfs_entry, attr);
+	hpb = container_of(kobj, struct ufshpb_lu, kobj);
+
+	if (!entry->show)
+		return -EIO;
+
+	mutex_lock(&hpb->sysfs_lock);
+	error = entry->show(hpb, page);
+	mutex_unlock(&hpb->sysfs_lock);
+	return error;
+}
+
+static ssize_t ufshpb_attr_store(struct kobject *kobj, struct attribute *attr,
+				 const char *page, size_t length)
+{
+	struct ufshpb_sysfs_entry *entry;
+	struct ufshpb_lu *hpb;
+	ssize_t error;
+
+	entry = container_of(attr, struct ufshpb_sysfs_entry, attr);
+	hpb = container_of(kobj, struct ufshpb_lu, kobj);
+
+	if (!entry->store)
+		return -EIO;
+
+	mutex_lock(&hpb->sysfs_lock);
+	error = entry->store(hpb, page, length);
+	mutex_unlock(&hpb->sysfs_lock);
+	return error;
+}
+
+static const struct sysfs_ops ufshpb_sysfs_ops = {
+	.show = ufshpb_attr_show,
+	.store = ufshpb_attr_store,
+};
+
+static struct kobj_type ufshpb_ktype = {
+	.sysfs_ops = &ufshpb_sysfs_ops,
+	.release = NULL,
+};
+
+static int ufshpb_create_sysfs(struct ufs_hba *hba, struct ufshpb_lu *hpb)
+{
+	struct device *dev = hba->dev;
+	struct ufshpb_sysfs_entry *entry;
+	int err;
+
+	hpb->sysfs_entries = ufshpb_sysfs_entries;
+
+	ufshpb_sysfs_stat_init(hpb);
+
+	kobject_init(&hpb->kobj, &ufshpb_ktype);
+	mutex_init(&hpb->sysfs_lock);
+
+	err = kobject_add(&hpb->kobj, kobject_get(&dev->kobj), "ufshpb_lu%d",
+			  hpb->lun);
+	if (!err) {
+		for (entry = hpb->sysfs_entries; entry->attr.name; entry++) {
+			if (sysfs_create_file(&hpb->kobj, &entry->attr))
+				break;
+		}
+		kobject_uevent(&hpb->kobj, KOBJ_ADD);
+	}
+
+	return err;
+}
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
new file mode 100644
index 000000000000..bb1826089d7f
--- /dev/null
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -0,0 +1,423 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Universal Flash Storage Host Performance Booster
+ *
+ * Copyright (C) 2017-2018 Samsung Electronics Co., Ltd.
+ *
+ * Authors:
+ *	Yongmyung Lee <ymhungry.lee@samsung.com>
+ *	Jinyoung Choi <j-young.choi@samsung.com>
+ */
+
+#ifndef _UFSHPB_H_
+#define _UFSHPB_H_
+
+#include <linux/spinlock.h>
+#include <linux/workqueue.h>
+#include <linux/blkdev.h>
+
+#include "ufshcd.h"
+
+#define UFSHPB_VER			0x0100
+#define DRIVER_NAME			"UFSHPB"
+#define hpb_warn(fmt, ...)					\
+	pr_warn("%s:" fmt, DRIVER_NAME, ##__VA_ARGS__)
+#define hpb_notice(fmt, ...)					\
+	pr_notice("%s:" fmt, DRIVER_NAME, ##__VA_ARGS__)
+#define hpb_info(fmt, ...)					\
+	pr_info("%s:" fmt, DRIVER_NAME, ##__VA_ARGS__)
+#define hpb_err(fmt, ...)					\
+	pr_err("%s: %s:" fmt, __func__, DRIVER_NAME,		\
+					##__VA_ARGS__)
+#define hpb_dbg(level, hpb, fmt, ...)					\
+do {									\
+	if (!(hpb))							\
+		break;							\
+	if ((hpb)->debug >= HPB_DBG_MAX || (hpb)->debug == (level))	\
+		pr_notice("%s: %s():" fmt,				\
+			DRIVER_NAME, __func__, ##__VA_ARGS__);		\
+} while (0)
+
+/*
+ * The maximum HPB cache size in system memory per controller (in MiB)
+ */
+#define HPB_MAX_MEM_SIZE_MB		CONFIG_UFSHPB_MAX_MEM_SIZE
+
+/* HPB control mode */
+#define HPB_HOST_CTRL_MODE		0x00
+#define HPB_DEV_CTRL_MODE		0x01
+
+#define HPB_MAP_REQ_RETRIES		5
+/*
+ * The default read count threashold before activating a subregion. Used in HPB
+ * host control mode.
+ */
+#define HPB_DEF_READ_THREASHOLD		10
+
+/* Constant value*/
+#define UFS_LOGICAL_BLOCK_SIZE		4096
+#define SECTORS_PER_BLOCK		(UFS_LOGICAL_BLOCK_SIZE / SECTOR_SIZE)
+#define BITS_PER_DWORD			32
+#define MAX_ACTIVE_NUM			2
+#define MAX_INACTIVE_NUM		2
+
+#define HPB_ENTRY_SIZE			0x08
+#define HPB_ENTREIS_PER_OS_PAGE		(PAGE_SIZE / HPB_ENTRY_SIZE)
+
+/* Description */
+#define UFS_FEATURE_SUPPORT_HPB_BIT	0x80
+
+#define PER_ACTIVE_INFO_BYTES		4
+#define PER_INACTIVE_INFO_BYTES		2
+
+/* UFS HPB OPCODE */
+#define UFSHPB_READ			0xF8
+#define UFSHPB_READ_BUFFER		0xF9
+#define UFSHPB_WRITE_BUFFER		0xFA
+
+#define HPB_DATA_SEG_LEN		0x14
+#define HPB_SENSE_DATA_LEN		0x12
+#define HPB_DESCRIPTOR_TYPE		0x80
+#define HPB_ADDITIONAL_LEN		0x10
+
+/* UFS HPB states */
+enum UFSHPB_STATE {
+	HPB_PRESENT = 1,
+	HPB_NOT_SUPPORTED,
+	HPB_FAILED,
+	HPB_NEED_INIT,
+	HPB_NEED_RESET,
+};
+
+/* UFS HPB region states */
+enum HPBREGION_STATE {
+	REGION_INACTIVE,
+	REGION_ACTIVE,
+	REGION_PINNED,
+};
+
+/* UFS HPB subregion states */
+enum HPBSUBREGION_STATE {
+	SUBREGION_UNUSED = 1,
+	SUBREGION_DIRTY,
+	SUBREGION_REGISTERED,
+	SUBREGION_ISSUED,
+	SUBREGION_CLEAN,
+};
+
+enum HPB_REQUEST_TYPE {
+	HPB_REGION_DEACTIVATE = 1,
+	HPB_SUBREGION_ACTIVATE,
+};
+
+/* Response UPIU types */
+enum HPB_SEMSE_DATA_OPERATION {
+	HPB_RSP_NONE,
+	HPB_REQ_REGION_UPDATE,
+	HPB_RESET_REGION_INFO,
+};
+
+enum HPB_DEBUG_LEVEL {
+	FAILURE_INFO = 1,
+	REGION_INFO,
+	SCHEDULE_INFO,
+	NORMAL_INFO,
+	HPB_DBG_MAX,
+};
+
+struct ufshpb_geo_desc {
+	/*** Geometry Descriptor ***/
+	/* 48h bHPBRegionSize (UNIT: 512B) */
+	u8 hpb_region_size;
+	/* 49h bHPBNumberLU */
+	u8 hpb_number_lu;
+	/* 4Ah bHPBSubRegionSize */
+	u8 hpb_subregion_size;
+	/* 4B:4Ch wDeviceMaxActiveHPBRegions */
+	u16 hpb_dev_max_active_regions;
+};
+
+struct ufshpb_lu_desc {
+	/*** Unit Descriptor ****/
+	/* 03h bLUEnable */
+	int lu_enable;
+	/* 06h lu queue depth info*/
+	int lu_queue_depth;
+	/* 0Ah bLogicalBlockSize. default 0x0C = 4KB */
+	int lu_logblk_size;
+	/* 0Bh qLogicalBlockCount, total number of addressable logical blocks */
+	u64 lu_logblk_cnt;
+
+	/* 23h:24h wLUMaxActiveHPBRegions */
+	u16 lu_max_active_hpb_regions;
+	/* 25h:26h wHPBPinnedRegionStartIdx */
+	u16 hpb_pinned_region_startidx;
+	/* 27h:28h wNumHPBPinnedRegions */
+	u16 lu_num_hpb_pinned_regions;
+
+	/* if 03h value is 02h, hpb_enable is set. */
+	bool lu_hpb_enable;
+
+	int lu_hpb_pinned_end_offset;
+};
+
+struct ufshpb_rsp_active_list {
+	/* Active HPB Region 0/1 */
+	u16 region[MAX_ACTIVE_NUM];
+	/* HPB Sub-Region of Active HPB Region 0/1 */
+	u16 subregion[MAX_ACTIVE_NUM];
+};
+
+struct ufshpb_rsp_inactive_list {
+	/* Inactive HPB Region 0/1 */
+	u16 region[MAX_INACTIVE_NUM];
+};
+
+/*
+ * UPIU response info for HPB recommendations for activating new SubRegions
+ * and/or inactivating region
+ */
+struct ufshpb_rsp_info {
+	int type;
+	int active_cnt;
+	int inactive_cnt;
+	struct ufshpb_rsp_active_list active_list;
+	struct ufshpb_rsp_inactive_list inactive_list;
+
+	__u64 rsp_start;
+	__u64 rsp_tasklet_enter;
+
+	struct list_head list_rsp_info;
+};
+
+/*
+ * HPB request info for activating new subregion or deactivating a region
+ */
+struct ufshpb_req_info {
+	enum HPB_REQUEST_TYPE type;
+	int region;
+	int subregion;
+
+	__u64 req_start_t;
+	__u64 workq_enter_t;
+
+	struct list_head list_req_info;
+};
+
+/*
+ * HPB Sense Data frame in RESPONSE UPIU
+ */
+struct hpb_sense_data {
+	u8 len[2];
+	u8 desc_type;
+	u8 additional_len;
+	u8 hpb_op;
+	u8 lun;
+	u8 active_region_cnt;
+	u8 inactive_region_cnt;
+	u8 active_field[8];
+	u8 inactive_field[4];
+};
+
+struct ufshpb_map_ctx {
+	struct page **m_page;
+	unsigned int *ppn_dirty;
+	unsigned int ppn_dirty_counter;
+
+	struct list_head list_table;
+};
+
+struct ufshpb_subregion {
+	struct ufshpb_map_ctx *mctx;
+	enum HPBSUBREGION_STATE subregion_state;
+	int region;
+	int subregion;
+	/* Counter of read hit on this subregion */
+	atomic_t read_counter;
+
+	struct list_head list_subregion;
+};
+
+struct ufshpb_region {
+	struct ufshpb_subregion *subregion_tbl;
+	enum HPBREGION_STATE region_state;
+	/* Region number */
+	int region;
+	/* How many subregions in this region */
+	int subregion_count;
+	/* How many dirty subregions in this region */
+	int subregion_dirty_count;
+
+	/* Hit count by the read on this region */
+	unsigned int hit_count;
+	/* List head for active reion list*/
+	struct list_head list_region;
+};
+
+/*
+ * HPB deactivating/inactivating request structure
+ */
+struct ufshpb_map_req {
+	struct ufshpb_map_ctx *mctx;
+	struct ufshpb_lu *hpb;
+	struct request *req;
+	struct ufs_req *ureq;
+	struct bio_vec *bvec;
+	struct bio bio;
+	int region;
+	int subregion;
+	int lun;
+	int retry_cnt;
+
+	struct list_head list_map_req;
+
+	/* Follow parameters used by debug/profile */
+	__u64 req_start_t;
+	__u64 workq_enter_t;
+	__u64 req_issue_t;
+	__u64 req_end_t;
+};
+
+enum victim_selection_type {
+	/* Select the first active region in list to evict */
+	LRU = 1,
+	/* Choose the active region with lowest hit count to evict */
+	LFU = 2,
+};
+
+/*
+ * local active region info list
+ */
+struct active_region_info {
+	enum victim_selection_type selection_type;
+	/* Active region list */
+	struct list_head lru;
+	/* Maximum active normal regions, doesn't include pinned regions */
+	int max_active_nor_regions;
+	/* Current Active region count */
+	atomic64_t active_cnt;
+};
+
+/* UFS device HPB constants associated with its geometry */
+struct ufshpb_geo {
+	u64 region_size_bytes;
+	u64 subregion_size_bytes;
+	/* total entry size in byte per subregion */
+	int subregion_entry_sz;
+	/* total active regions supported by the device */
+	int dev_max_active_regions;
+	/* maximum count of hpb lun supported by the device */
+	int max_hpb_lu_cnt;
+	int entries_per_subregion;
+	int entries_per_subregion_shift;
+	int entries_per_subregion_mask;
+	int entries_per_region_shift;
+	int entries_per_region_mask;
+	int subregions_per_region;
+	int dwords_per_subregion;
+	/* page size in byte */
+	int mpage_bytes;
+	/* how many pages needed for the L2P entries of one subregion */
+	int mpages_per_subregion;
+};
+
+struct ufshpb_running_status {
+	atomic64_t hit;
+	atomic64_t miss;
+	atomic64_t region_miss;
+	atomic64_t subregion_miss;
+	atomic64_t entry_dirty_miss;
+	atomic64_t rb_noti_cnt;
+	atomic64_t map_req_cnt;
+	atomic64_t region_add;
+	atomic64_t region_evict;
+	atomic64_t rb_fail;
+};
+
+struct ufshpb_lu {
+	/* The LU number associated with this HPB */
+	int lun;
+	struct ufs_hba *hba;
+	bool lu_hpb_enable;
+	spinlock_t hpb_lock;
+
+	/* HPB region info memory */
+	struct ufshpb_region *region_tbl;
+
+	/* HPB response info, the count = queue_depth */
+	struct ufshpb_rsp_info *rsp_info;
+	struct list_head lh_rsp_info_free;
+	struct list_head lh_rsp_info;
+	spinlock_t rsp_list_lock;
+
+	/* HPB request info, the count = queue_depth */
+	struct ufshpb_req_info *req_info;
+	struct list_head lh_req_info_free;
+	struct list_head lh_req_info;
+	spinlock_t req_list_lock;
+
+	/* HPB L2P mapping request memory */
+	struct ufshpb_map_req *map_req;
+	struct list_head lh_map_req_free;
+	int map_req_cnt;
+
+	/* The map_req list for map_req needed to retry */
+	struct list_head lh_map_req_retry;
+
+	/* Free mapping context structure (struct ufshpb_map_ctx) list */
+	struct list_head lh_map_ctx;
+	int free_mctx_count;
+	int lu_max_mctx_cnt;
+
+	struct list_head lh_subregion_req;
+	/*
+	 * The read_threshold is used to specify the maximum number of the read
+	 * operation hit on inactive subregion before considering this subregion
+	 * should be activated. It is used in the HPB host control mode.
+	 */
+	int read_threshold;
+	/* Active regions info list */
+	struct active_region_info lru_info;
+
+	struct work_struct ufshpb_sync_work;
+	struct work_struct ufshpb_req_work;
+	struct delayed_work retry_work;
+	struct work_struct ufshpb_rsp_work;
+
+	/* Entries size in byte of the last subregion of the LU */
+	int last_subregion_entry_size;
+	int subregions_in_last_region;
+	/* Total subregion count in the LU */
+	int lu_subregion_cnt;
+	/* Total region count in the LU */
+	int lu_region_cnt;
+	/* Max active region count supported by UFS. it includes Pinned region*/
+	int lu_max_active_regions;
+	int lu_pinned_regions;
+
+	/* UFS HPB sysfs */
+	struct kobject kobj;
+	struct mutex sysfs_lock;
+	struct ufshpb_sysfs_entry *sysfs_entries;
+
+	/* for debug */
+	bool force_disable;
+	bool force_map_req_disable;
+	int debug;
+	struct ufshpb_running_status status;
+};
+
+struct ufshpb_sysfs_entry {
+	struct attribute    attr;
+	ssize_t (*show)(struct ufshpb_lu *hpb, char *buf);
+	ssize_t (*store)(struct ufshpb_lu *hpb, const char *buf, size_t count);
+};
+
+struct ufshcd_lrb;
+
+void ufshpb_prep_fn(struct ufs_hba *hba, struct ufshcd_lrb *lrbp);
+void ufshpb_rsp_handler(struct ufs_hba *hba, struct ufshcd_lrb *lrbp);
+void ufshpb_release(struct ufs_hba *hba, enum UFSHPB_STATE state);
+void ufshpb_init(struct ufs_hba *hba);
+
+#endif /* End of Header */
-- 
2.17.1

