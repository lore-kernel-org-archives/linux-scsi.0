Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BBE3365A1B;
	Tue,  5 May 2026 21:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778016239; cv=none; b=sp05e35zR5PEGjsLlc4Xr9E01v7iy0Ub0tysO8vvJiiXUhbOhDShMJ4NwEt77re3iot9dP/Srjdh1zIGakxd1s+QPg7OUcd9VjaQgj62XEScvKCGsVF07zDH0aqlstdRjkrAbHQl9DgZCaY3RcLedQuMHavhVBU07mSoFnivgHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778016239; c=relaxed/simple;
	bh=QL2yQiS4cI2tISEaNRyqIHZzbrOdOw9sEprE9CvXUGo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jIxr9SU41jx2flLQJ+RZzuwHcf5II+7yg+PdidqPQfk7BlzkOPIxqPWOiF35AgTWpqvt+WnEOX8lvTL2QYEMB2zytw7x9P8OU4pupaqL+zwDYk4/W7M/2yFpbunwGJDHKkIE2IMCvHhaKGOLNSIQkEYzADj5u9iSUcpaSxbSm7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=I4+heM1/; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="I4+heM1/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1778016235;
	bh=QL2yQiS4cI2tISEaNRyqIHZzbrOdOw9sEprE9CvXUGo=;
	h=From:To:Subject:Date:Message-ID:From;
	b=I4+heM1/dte2cMS7FbVRQrOvMv2UX2y3rNz7LZ+XJrg6+w+ZhpP/33B83QjNBJqCL
	 s1i/QyWO59qFCl9MjFbNnDQIp0G+L5QBDuF67AvVa/MaVptTNDQnUZcWMT+gS25QCz
	 q4UAO1+7a12CwwzqXrnHzGhh4cIm+2FFSrN0L7XY=
Received: from lingrow.int.hansenpartnership.com (unknown [153.66.160.227])
	by lamorak.hansenpartnership.com (Postfix) with ESMTP id B8A631C0340;
	Tue, 05 May 2026 17:23:55 -0400 (EDT)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] SCSI fixes for 7.1-rc2+
Date: Tue,  5 May 2026 17:23:49 -0400
Message-ID: <20260505212349.5828-1-James.Bottomley@HansenPartnership.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The following changes since commit 254f49634ee16a731174d2ae34bc50bd5f45e731:

  Linux 7.1-rc1 (2026-04-26 14:19:00 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git tags/scsi-fixes

for you to fetch changes up to 98f69975d4c0434ca2e6e8cfa1d8d51647a20593:

  Merge branch '7.1/scsi-queue' into 7.1/scsi-fixes (2026-04-26 21:15:04 -0400)

----------------------------------------------------------------
All in drivers.  The largest change is the ufs one which has to
introduce a new function to check the power state before doing the
update and the most widely encountered one is the obvious change to sg
to not use GFP_ATOMIC.
----------------------------------------------------------------
Brian Bunker (1):
      scsi: scsi_dh_alua: Increase default ALUA timeout to maximum spec value

Carlos Bilbao (1):
      scsi: target: iscsi: reject invalid size Extended CDB AHS

Christoph Hellwig (1):
      scsi: sg: Don't use GFP_ATOMIC in sg_start_req()

Greg Kroah-Hartman (1):
      scsi: target: configfs: Bound snprintf() return in tg_pt_gp_members_show()

Hugo Villeneuve (1):
      scsi: pmcraid: Fix typo in comments

Martin K. Petersen (1):
      Merge branch '7.1/scsi-queue' into 7.1/scsi-fixes

Ranjan Kumar (1):
      scsi: mpt3sas: Limit NVMe request size to 2 MiB

Tomas Henzl (1):
      scsi: smartpqi: Silence a recursive lock warning

Wang Shuaiwei (1):
      scsi: ufs: core: Fix bRefClkFreq write failure in HS-LSS mode

Yihang Li (1):
      scsi: hisi_sas: Fix sparse warnings in prep_ata_v3_hw()

 drivers/scsi/device_handler/scsi_dh_alua.c |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c     |  2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c       | 14 +++++++++++++-
 drivers/scsi/pmcraid.h                     |  2 +-
 drivers/scsi/sg.c                          |  2 +-
 drivers/scsi/smartpqi/smartpqi_init.c      |  1 +
 drivers/target/iscsi/iscsi_target.c        | 22 ++++++++++++++++++----
 drivers/target/target_core_configfs.c      |  2 +-
 drivers/ufs/core/ufshcd.c                  | 30 ++++++++++++++++++++++++++++--
 include/ufs/unipro.h                       |  5 +++++
 10 files changed, 70 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index efb08b9b145a..80ab0ff921d4 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -37,7 +37,7 @@
 #define TPGS_MODE_EXPLICIT		0x2
 
 #define ALUA_RTPG_SIZE			128
-#define ALUA_FAILOVER_TIMEOUT		60
+#define ALUA_FAILOVER_TIMEOUT		255	/* max 255 (8-bit value) */
 #define ALUA_FAILOVER_RETRIES		5
 #define ALUA_RTPG_DELAY_MSECS		5
 #define ALUA_RTPG_RETRY_DELAY		2
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index fda07b193137..14d563e82d20 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1491,7 +1491,7 @@ static void prep_ata_v3_hw(struct hisi_hba *hisi_hba,
 		phy_id = device->phy->identify.phy_identifier;
 		hdr->dw0 |= cpu_to_le32((1U << phy_id)
 				<< CMD_HDR_PHY_ID_OFF);
-		hdr->dw0 |= CMD_HDR_FORCE_PHY_MSK;
+		hdr->dw0 |= cpu_to_le32(CMD_HDR_FORCE_PHY_MSK);
 		hdr->dw0 |= cpu_to_le32(4U << CMD_HDR_CMD_OFF);
 	}
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 6ff788557294..12caffeed3a0 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2738,8 +2738,20 @@ scsih_sdev_configure(struct scsi_device *sdev, struct queue_limits *lim)
 				pcie_device->enclosure_level,
 				pcie_device->connector_name);
 
+		/*
+		 * The HBA firmware passes the NVMe drive's MDTS
+		 * (Maximum Data Transfer Size) up to the driver. However,
+		 * the driver hardcodes a 4K buffer size for the PRP list,
+		 * accommodating at most 512 entries. This strictly limits
+		 * the maximum supported NVMe I/O transfer to 2 MiB.
+		 *
+		 * Cap max_hw_sectors to the smaller of the drive's reported
+		 * MDTS or the 2 MiB driver limit to prevent kernel oopses.
+		 */
+		lim->max_hw_sectors = SZ_2M >> SECTOR_SHIFT;
 		if (pcie_device->nvme_mdts)
-			lim->max_hw_sectors = pcie_device->nvme_mdts / 512;
+			lim->max_hw_sectors = min(lim->max_hw_sectors,
+					pcie_device->nvme_mdts >> SECTOR_SHIFT);
 
 		pcie_device_put(pcie_device);
 		spin_unlock_irqrestore(&ioc->pcie_device_lock, flags);
diff --git a/drivers/scsi/pmcraid.h b/drivers/scsi/pmcraid.h
index 9f59930e8b4f..cd059b7599b4 100644
--- a/drivers/scsi/pmcraid.h
+++ b/drivers/scsi/pmcraid.h
@@ -657,7 +657,7 @@ struct pmcraid_hostrcb {
  */
 struct pmcraid_instance {
 	/* Array of allowed-to-be-exposed resources, initialized from
-	 * Configutation Table, later updated with CCNs
+	 * Configuration Table, later updated with CCNs
 	 */
 	struct pmcraid_resource_entry *res_entries;
 
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 2b4b2a1a8e44..74cd4e8a61c2 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1801,7 +1801,7 @@ sg_start_req(Sg_request *srp, unsigned char *cmd)
 	}
 
 	res = blk_rq_map_user_io(rq, md, hp->dxferp, hp->dxfer_len,
-			GFP_ATOMIC, iov_count, iov_count, 1, rw);
+			GFP_KERNEL, iov_count, iov_count, 1, rw);
 	if (!res) {
 		srp->bio = rq->bio;
 
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index b4ed991976d0..2026ac645d6a 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -9427,6 +9427,7 @@ static void pqi_shutdown(struct pci_dev *pci_dev)
 
 	pqi_crash_if_pending_command(ctrl_info);
 	pqi_reset(ctrl_info);
+	pqi_ctrl_unblock_device_reset(ctrl_info);
 }
 
 static void pqi_process_lockup_action_param(void)
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index e80449f6ce15..cb832fd523af 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -995,6 +995,7 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 	int data_direction, payload_length;
 	struct iscsi_ecdb_ahdr *ecdb_ahdr;
 	struct iscsi_scsi_req *hdr;
+	u16 ahslength, cdb_length;
 	int iscsi_task_attr;
 	unsigned char *cdb;
 	int sam_task_attr;
@@ -1108,14 +1109,27 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
 				ISCSI_REASON_CMD_NOT_SUPPORTED, buf);
 		}
 
-		cdb = kmalloc(be16_to_cpu(ecdb_ahdr->ahslength) + 15,
-			      GFP_KERNEL);
+		ahslength = be16_to_cpu(ecdb_ahdr->ahslength);
+		if (!ahslength) {
+			pr_err("Extended CDB AHS with zero length, protocol error.\n");
+			return iscsit_add_reject_cmd(cmd,
+				ISCSI_REASON_PROTOCOL_ERROR, buf);
+		}
+		if (ahslength > (hdr->hlength * 4) - 3) {
+			pr_err("Extended CDB AHS length %u exceeds available PDU buffer.\n",
+			       ahslength);
+			return iscsit_add_reject_cmd(cmd,
+				ISCSI_REASON_PROTOCOL_ERROR, buf);
+		}
+
+		cdb_length = ahslength - 1 + ISCSI_CDB_SIZE;
+
+		cdb = kmalloc(cdb_length, GFP_KERNEL);
 		if (cdb == NULL)
 			return iscsit_add_reject_cmd(cmd,
 				ISCSI_REASON_BOOKMARK_NO_RESOURCES, buf);
 		memcpy(cdb, hdr->cdb, ISCSI_CDB_SIZE);
-		memcpy(cdb + ISCSI_CDB_SIZE, ecdb_ahdr->ecdb,
-		       be16_to_cpu(ecdb_ahdr->ahslength) - 1);
+		memcpy(cdb + ISCSI_CDB_SIZE, ecdb_ahdr->ecdb, cdb_length - ISCSI_CDB_SIZE);
 	}
 
 	data_direction = (hdr->flags & ISCSI_FLAG_CMD_WRITE) ? DMA_TO_DEVICE :
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index d93773b3227c..2b19a956007b 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -3249,7 +3249,7 @@ static ssize_t target_tg_pt_gp_members_show(struct config_item *item,
 			config_item_name(&lun->lun_group.cg_item));
 		cur_len++; /* Extra byte for NULL terminator */
 
-		if ((cur_len + len) > PAGE_SIZE) {
+		if (cur_len > TG_PT_GROUP_NAME_BUF || (cur_len + len) > PAGE_SIZE) {
 			pr_warn("Ran out of lu_gp_show_attr"
 				"_members buffer\n");
 			break;
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 4805e40ed4d7..c3f08957d179 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9259,6 +9259,30 @@ static void ufshcd_config_mcq(struct ufs_hba *hba)
 		 hba->nutrs);
 }
 
+/**
+ * ufshcd_get_op_mode - get UFS operating mode.
+ * @hba: per-adapter instance
+ *
+ * Use the PA_PWRMODE value to represent the operating mode of UFS.
+ *
+ */
+static enum ufs_op_mode ufshcd_get_op_mode(struct ufs_hba *hba)
+{
+	u32 mode;
+	u8 rx_mode;
+	u8 tx_mode;
+
+	ufshcd_dme_get(hba, UIC_ARG_MIB(PA_PWRMODE), &mode);
+	rx_mode = (mode >> PWRMODE_RX_OFFSET) & PWRMODE_MASK;
+	tx_mode = mode & PWRMODE_MASK;
+
+	if ((rx_mode == SLOW_MODE || rx_mode == SLOWAUTO_MODE) &&
+	    (tx_mode == SLOW_MODE || tx_mode == SLOWAUTO_MODE))
+		return LS_MODE;
+
+	return HS_MODE;
+}
+
 static int ufshcd_post_device_init(struct ufs_hba *hba)
 {
 	int ret;
@@ -9281,11 +9305,13 @@ static int ufshcd_post_device_init(struct ufs_hba *hba)
 		return 0;
 
 	/*
-	 * Set the right value to bRefClkFreq before attempting to
+	 * Set the right value to bRefClkFreq in LS_MODE before attempting to
 	 * switch to HS gears.
 	 */
-	if (hba->dev_ref_clk_freq != REF_CLK_FREQ_INVAL)
+	if (ufshcd_get_op_mode(hba) == LS_MODE &&
+	    hba->dev_ref_clk_freq != REF_CLK_FREQ_INVAL)
 		ufshcd_set_dev_ref_clk(hba);
+
 	/* Gear up to HS gear. */
 	ret = ufshcd_config_pwr_mode(hba, &hba->max_pwr_info.info,
 				     UFSHCD_PMC_POLICY_DONT_FORCE);
diff --git a/include/ufs/unipro.h b/include/ufs/unipro.h
index f849a2a101ae..9c168703b104 100644
--- a/include/ufs/unipro.h
+++ b/include/ufs/unipro.h
@@ -333,6 +333,11 @@ enum ufs_eom_eye_mask {
 #define DME_LocalTC0ReplayTimeOutVal		0xD042
 #define DME_LocalAFC0ReqTimeOutVal		0xD043
 
+enum ufs_op_mode {
+	LS_MODE = 1,
+	HS_MODE = 2,
+};
+
 /* PA power modes */
 enum ufs_pa_pwr_mode {
 	FAST_MODE	= 1,
