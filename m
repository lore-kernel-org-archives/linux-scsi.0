Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E9F2517AC;
	Thu, 17 Apr 2025 14:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744900852; cv=none; b=TaoMKbzY6GDm6ucHnCwPImtHDuFUaIoV8k3LzeODlF9ebfiMcUCG6y+p4oGCrXXcoxI3X+NheF8C+gsc6nPMCeS3q7SRFC7GnZPB9Afuh/UdqxhvWVbc5RSLJCx6J6H/JWi30iv3Fo4O6cG23n+jXVZBzN5cd9nJXFDJJaMUzPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744900852; c=relaxed/simple;
	bh=N/TM8x6IIyaHXd79GyBR9ruF/k/+q6ycRtCMr6Par0U=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=T13bdV2o8E6bSOLW0a4TdCy6Dtab6Blk9FX6MxuyaeU6JmfeoQ0gjFe2/By2Zo0II8LZmpAIluVFKzggxaIx2sV/QGOHRYSuvc+ITpFWSZWbCvcpVRDTSwJ8/1gg8cNOW3sxNyDtcIgX9M9vZOkLX1LoUT2ZuYyNpo8Kvi3ImTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=dZUtksQ9; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="dZUtksQ9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1744900847;
	bh=N/TM8x6IIyaHXd79GyBR9ruF/k/+q6ycRtCMr6Par0U=;
	h=Message-ID:Subject:From:To:Date:From;
	b=dZUtksQ9pD+Q2d9NMOfYVPQ5EG0FZqhZ3WeW52JzFG1QX2t2MPoxc2m8pkqHsKcE8
	 eb7fBfAYixDXQhtSZ8v7phk4FVc7uzVbBZOSRERHFy8bMwuKcTIgY1qkYVtQDP84kT
	 tDHDrPVwL/jjrsH07F1TVd4DmhzC2vkSJrBUIrM0=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4302:c21::a774])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id 5C24C1C0013;
	Thu, 17 Apr 2025 10:40:47 -0400 (EDT)
Message-ID: <e4bb2944a14703eb4fe88374b9bd60f4fb6997d4.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 6.15-rc2
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Thu, 17 Apr 2025 10:40:46 -0400
Autocrypt: addr=James.Bottomley@HansenPartnership.com;
 prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.3 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Small drivers fixes, except for ufs which has two large updates, one
for exposing the device level feature, which is a new addition to the
device spec and the other reworking the exynos driver to fix coherence
issues on some android phones.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

Bao D. Nguyen (2):
      scsi: ufs: core: Add device level exception support
      scsi: ufs: core: Rename ufshcd_wb_presrv_usrspc_keep_vcc_on()

Bart Van Assche (1):
      scsi: ufs: core: Fix a race condition related to device commands

Chandrakanth Patil (2):
      scsi: megaraid_sas: Driver version update to 07.734.00.00-rc1
      scsi: megaraid_sas: Block zero-length ATA VPD inquiry

Igor Pylypiv (1):
      scsi: pm80xx: Set phy_attached to zero when device is gone

Li Haoran (1):
      scsi: scsi_transport_srp: Replace min/max nesting with clamp()

Martin Wilck (1):
      scsi: smartpqi: Use is_kdump_kernel() to check for kdump

Miaoqian Lin (1):
      scsi: iscsi: Fix missing scsi_host_put() in error path

Peter Griffin (7):
      scsi: ufs: exynos: gs101: Put UFS device in reset on .suspend()
      scsi: ufs: exynos: Move phy calls to .exit() callback
      scsi: ufs: exynos: Enable PRDT pre-fetching with UFSHCD_CAP_CRYPTO
      scsi: ufs: exynos: Ensure consistent phy reference counts
      scsi: ufs: exynos: Disable iocc if dma-coherent property isn't set
      scsi: ufs: exynos: Move UFS shareability value to drvdata
      scsi: ufs: exynos: Ensure pre_link() executes before exynos_ufs_phy_i=
nit()

Xingui Yang (2):
      scsi: hisi_sas: Fix I/O errors caused by hardware port ID changes
      scsi: hisi_sas: Enable force phy when SATA disk directly connected

And the diffstat:

 Documentation/ABI/testing/sysfs-driver-ufs  | 32 ++++++++++
 drivers/scsi/hisi_sas/hisi_sas_main.c       | 20 +++++++
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c      |  9 ++-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c      | 14 ++++-
 drivers/scsi/megaraid/megaraid_sas.h        |  4 +-
 drivers/scsi/megaraid/megaraid_sas_base.c   |  9 ++-
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  5 +-
 drivers/scsi/pm8001/pm8001_sas.c            |  1 +
 drivers/scsi/scsi_transport_iscsi.c         |  7 ++-
 drivers/scsi/scsi_transport_srp.c           |  2 +-
 drivers/scsi/smartpqi/smartpqi_init.c       | 13 ++--
 drivers/ufs/core/ufs-sysfs.c                | 54 +++++++++++++++++
 drivers/ufs/core/ufshcd-priv.h              |  1 +
 drivers/ufs/core/ufshcd.c                   | 92 +++++++++++++++++++++----=
----
 drivers/ufs/host/ufs-exynos.c               | 85 +++++++++++++++++++------=
-
 drivers/ufs/host/ufs-exynos.h               |  6 +-
 include/ufs/ufs.h                           |  5 +-
 include/ufs/ufshcd.h                        |  7 ++-
 18 files changed, 299 insertions(+), 67 deletions(-)

With full diff below.

James

---

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI=
/testing/sysfs-driver-ufs
index ae0191295d29..e36d2de16cbd 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -1604,3 +1604,35 @@ Description:
 		prevent the UFS from frequently performing clock gating/ungating.
=20
 		The attribute is read/write.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_lvl_exception_count
+What:		/sys/bus/platform/devices/*.ufs/device_lvl_exception_count
+Date:		March 2025
+Contact:	Bao D. Nguyen <quic_nguyenb@quicinc.com>
+Description:
+		This attribute is applicable to ufs devices compliant to the
+		JEDEC specifications version 4.1 or later. The
+		device_lvl_exception_count is a counter indicating the number of
+		times the device level exceptions have occurred since the last
+		time this variable is reset.  Writing a 0 value to this
+		attribute will reset the device_lvl_exception_count.  If the
+		device_lvl_exception_count reads a positive value, the user
+		application should read the device_lvl_exception_id attribute to
+		know more information about the exception.
+
+		The attribute is read/write.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/device_lvl_exception_id
+What:		/sys/bus/platform/devices/*.ufs/device_lvl_exception_id
+Date:		March 2025
+Contact:	Bao D. Nguyen <quic_nguyenb@quicinc.com>
+Description:
+		Reading the device_lvl_exception_id returns the
+		qDeviceLevelExceptionID attribute of the ufs device JEDEC
+		specification version 4.1. The definition of the
+		qDeviceLevelExceptionID is the ufs device vendor specific
+		implementation.  Refer to the device manufacturer datasheet for
+		more information on the meaning of the qDeviceLevelExceptionID
+		attribute value.
+
+		The attribute is read only.
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/=
hisi_sas_main.c
index 5cb1d3db4907..944cf2fb0561 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -935,8 +935,28 @@ static void hisi_sas_phyup_work_common(struct work_str=
uct *work,
 		container_of(work, typeof(*phy), works[event]);
 	struct hisi_hba *hisi_hba =3D phy->hisi_hba;
 	struct asd_sas_phy *sas_phy =3D &phy->sas_phy;
+	struct asd_sas_port *sas_port =3D sas_phy->port;
+	struct hisi_sas_port *port =3D phy->port;
+	struct device *dev =3D hisi_hba->dev;
+	struct domain_device *port_dev;
 	int phy_no =3D sas_phy->id;
=20
+	if (!test_bit(HISI_SAS_RESETTING_BIT, &hisi_hba->flags) &&
+	    sas_port && port && (port->id !=3D phy->port_id)) {
+		dev_info(dev, "phy%d's hw port id changed from %d to %llu\n",
+				phy_no, port->id, phy->port_id);
+		port_dev =3D sas_port->port_dev;
+		if (port_dev && !dev_is_expander(port_dev->dev_type)) {
+			/*
+			 * Set the device state to gone to block
+			 * sending IO to the device.
+			 */
+			set_bit(SAS_DEV_GONE, &port_dev->state);
+			hisi_sas_notify_phy_event(phy, HISI_PHYE_LINK_RESET);
+			return;
+		}
+	}
+
 	phy->wait_phyup_cnt =3D 0;
 	if (phy->identify.target_port_protocols =3D=3D SAS_PROTOCOL_SSP)
 		hisi_hba->hw->sl_notify_ssp(hisi_hba, phy_no);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas=
/hisi_sas_v2_hw.c
index a1fc400ab4c3..1e9830940f84 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2501,6 +2501,7 @@ static void prep_ata_v2_hw(struct hisi_hba *hisi_hba,
 	struct hisi_sas_port *port =3D to_hisi_sas_port(sas_port);
 	struct sas_ata_task *ata_task =3D &task->ata_task;
 	struct sas_tmf_task *tmf =3D slot->tmf;
+	int phy_id;
 	u8 *buf_cmd;
 	int has_data =3D 0, hdr_tag =3D 0;
 	u32 dw0, dw1 =3D 0, dw2 =3D 0;
@@ -2508,10 +2509,14 @@ static void prep_ata_v2_hw(struct hisi_hba *hisi_hb=
a,
 	/* create header */
 	/* dw0 */
 	dw0 =3D port->id << CMD_HDR_PORT_OFF;
-	if (parent_dev && dev_is_expander(parent_dev->dev_type))
+	if (parent_dev && dev_is_expander(parent_dev->dev_type)) {
 		dw0 |=3D 3 << CMD_HDR_CMD_OFF;
-	else
+	} else {
+		phy_id =3D device->phy->identify.phy_identifier;
+		dw0 |=3D (1U << phy_id) << CMD_HDR_PHY_ID_OFF;
+		dw0 |=3D CMD_HDR_FORCE_PHY_MSK;
 		dw0 |=3D 4 << CMD_HDR_CMD_OFF;
+	}
=20
 	if (tmf && ata_task->force_phy) {
 		dw0 |=3D CMD_HDR_FORCE_PHY_MSK;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas=
/hisi_sas_v3_hw.c
index 2684d6482067..08dac9ae2f10 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -359,6 +359,10 @@
 #define CMD_HDR_RESP_REPORT_MSK		(0x1 << CMD_HDR_RESP_REPORT_OFF)
 #define CMD_HDR_TLR_CTRL_OFF		6
 #define CMD_HDR_TLR_CTRL_MSK		(0x3 << CMD_HDR_TLR_CTRL_OFF)
+#define CMD_HDR_PHY_ID_OFF		8
+#define CMD_HDR_PHY_ID_MSK		(0x1ff << CMD_HDR_PHY_ID_OFF)
+#define CMD_HDR_FORCE_PHY_OFF		17
+#define CMD_HDR_FORCE_PHY_MSK		(0x1U << CMD_HDR_FORCE_PHY_OFF)
 #define CMD_HDR_PORT_OFF		18
 #define CMD_HDR_PORT_MSK		(0xf << CMD_HDR_PORT_OFF)
 #define CMD_HDR_PRIORITY_OFF		27
@@ -1429,15 +1433,21 @@ static void prep_ata_v3_hw(struct hisi_hba *hisi_hb=
a,
 	struct hisi_sas_cmd_hdr *hdr =3D slot->cmd_hdr;
 	struct asd_sas_port *sas_port =3D device->port;
 	struct hisi_sas_port *port =3D to_hisi_sas_port(sas_port);
+	int phy_id;
 	u8 *buf_cmd;
 	int has_data =3D 0, hdr_tag =3D 0;
 	u32 dw1 =3D 0, dw2 =3D 0;
=20
 	hdr->dw0 =3D cpu_to_le32(port->id << CMD_HDR_PORT_OFF);
-	if (parent_dev && dev_is_expander(parent_dev->dev_type))
+	if (parent_dev && dev_is_expander(parent_dev->dev_type)) {
 		hdr->dw0 |=3D cpu_to_le32(3 << CMD_HDR_CMD_OFF);
-	else
+	} else {
+		phy_id =3D device->phy->identify.phy_identifier;
+		hdr->dw0 |=3D cpu_to_le32((1U << phy_id)
+				<< CMD_HDR_PHY_ID_OFF);
+		hdr->dw0 |=3D CMD_HDR_FORCE_PHY_MSK;
 		hdr->dw0 |=3D cpu_to_le32(4U << CMD_HDR_CMD_OFF);
+	}
=20
 	switch (task->data_dir) {
 	case DMA_TO_DEVICE:
diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/m=
egaraid_sas.h
index 088cc40ae866..8ee2bfe47571 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -23,8 +23,8 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION				"07.727.03.00-rc1"
-#define MEGASAS_RELDATE				"Oct 03, 2023"
+#define MEGASAS_VERSION				"07.734.00.00-rc1"
+#define MEGASAS_RELDATE				"Apr 03, 2025"
=20
 #define MEGASAS_MSIX_NAME_LEN			32
=20
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megar=
aid/megaraid_sas_base.c
index c20447b39cb9..5e33d411fa3d 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -2103,6 +2103,9 @@ static int megasas_sdev_configure(struct scsi_device =
*sdev,
 	/* This sdev property may change post OCR */
 	megasas_set_dynamic_target_properties(sdev, lim, is_target_prop);
=20
+	if (!MEGASAS_IS_LOGICAL(sdev))
+		sdev->no_vpd_size =3D 1;
+
 	mutex_unlock(&instance->reset_mutex);
=20
 	return 0;
@@ -3662,8 +3665,10 @@ megasas_complete_cmd(struct megasas_instance *instan=
ce, struct megasas_cmd *cmd,
=20
 		case MFI_STAT_SCSI_IO_FAILED:
 		case MFI_STAT_LD_INIT_IN_PROGRESS:
-			cmd->scmd->result =3D
-			    (DID_ERROR << 16) | hdr->scsi_status;
+			if (hdr->scsi_status =3D=3D 0xf0)
+				cmd->scmd->result =3D (DID_ERROR << 16) | SAM_STAT_CHECK_CONDITION;
+			else
+				cmd->scmd->result =3D (DID_ERROR << 16) | hdr->scsi_status;
 			break;
=20
 		case MFI_STAT_SCSI_DONE_WITH_ERROR:
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/meg=
araid/megaraid_sas_fusion.c
index 721860cb1ef6..a6794f49e9fa 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -2043,7 +2043,10 @@ map_cmd_status(struct fusion_context *fusion,
=20
 	case MFI_STAT_SCSI_IO_FAILED:
 	case MFI_STAT_LD_INIT_IN_PROGRESS:
-		scmd->result =3D (DID_ERROR << 16) | ext_status;
+		if (ext_status =3D=3D 0xf0)
+			scmd->result =3D (DID_ERROR << 16) | SAM_STAT_CHECK_CONDITION;
+		else
+			scmd->result =3D (DID_ERROR << 16) | ext_status;
 		break;
=20
 	case MFI_STAT_SCSI_DONE_WITH_ERROR:
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_=
sas.c
index 183ce00aa671..f7067878b34f 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -766,6 +766,7 @@ static void pm8001_dev_gone_notify(struct domain_device=
 *dev)
 			spin_lock_irqsave(&pm8001_ha->lock, flags);
 		}
 		PM8001_CHIP_DISP->dereg_dev_req(pm8001_ha, device_id);
+		pm8001_ha->phy[pm8001_dev->attached_phy].phy_attached =3D 0;
 		pm8001_free_dev(pm8001_dev);
 	} else {
 		pm8001_dbg(pm8001_ha, DISC, "Found dev has gone.\n");
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transp=
ort_iscsi.c
index 9c347c64c315..0b8c91bf793f 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -3182,11 +3182,14 @@ iscsi_set_host_param(struct iscsi_transport *transp=
ort,
 	}
=20
 	/* see similar check in iscsi_if_set_param() */
-	if (strlen(data) > ev->u.set_host_param.len)
-		return -EINVAL;
+	if (strlen(data) > ev->u.set_host_param.len) {
+		err =3D -EINVAL;
+		goto out;
+	}
=20
 	err =3D transport->set_host_param(shost, ev->u.set_host_param.param,
 					data, ev->u.set_host_param.len);
+out:
 	scsi_host_put(shost);
 	return err;
 }
diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transpor=
t_srp.c
index 64f6b22e8cc0..aeb58a9e6b7f 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -388,7 +388,7 @@ static void srp_reconnect_work(struct work_struct *work=
)
 			     "reconnect attempt %d failed (%d)\n",
 			     ++rport->failed_reconnects, res);
 		delay =3D rport->reconnect_delay *
-			min(100, max(1, rport->failed_reconnects - 10));
+			clamp(rport->failed_reconnects - 10, 1, 100);
 		if (delay > 0)
 			queue_delayed_work(system_long_wq,
 					   &rport->reconnect_work, delay * HZ);
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/=
smartpqi_init.c
index 88135fdb8bd1..8a26eca4fdc9 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -19,6 +19,7 @@
 #include <linux/bcd.h>
 #include <linux/reboot.h>
 #include <linux/cciss_ioctl.h>
+#include <linux/crash_dump.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
@@ -5246,7 +5247,7 @@ static void pqi_calculate_io_resources(struct pqi_ctr=
l_info *ctrl_info)
 	ctrl_info->error_buffer_length =3D
 		ctrl_info->max_io_slots * PQI_ERROR_BUFFER_ELEMENT_LENGTH;
=20
-	if (reset_devices)
+	if (is_kdump_kernel())
 		max_transfer_size =3D min(ctrl_info->max_transfer_size,
 			PQI_MAX_TRANSFER_SIZE_KDUMP);
 	else
@@ -5275,7 +5276,7 @@ static void pqi_calculate_queue_resources(struct pqi_=
ctrl_info *ctrl_info)
 	u16 num_elements_per_iq;
 	u16 num_elements_per_oq;
=20
-	if (reset_devices) {
+	if (is_kdump_kernel()) {
 		num_queue_groups =3D 1;
 	} else {
 		int num_cpus;
@@ -8288,12 +8289,12 @@ static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl=
_info)
 	u32 product_id;
=20
 	if (reset_devices) {
-		if (pqi_is_fw_triage_supported(ctrl_info)) {
+		if (is_kdump_kernel() && pqi_is_fw_triage_supported(ctrl_info)) {
 			rc =3D sis_wait_for_fw_triage_completion(ctrl_info);
 			if (rc)
 				return rc;
 		}
-		if (sis_is_ctrl_logging_supported(ctrl_info)) {
+		if (is_kdump_kernel() && sis_is_ctrl_logging_supported(ctrl_info)) {
 			sis_notify_kdump(ctrl_info);
 			rc =3D sis_wait_for_ctrl_logging_completion(ctrl_info);
 			if (rc)
@@ -8344,7 +8345,7 @@ static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_i=
nfo)
 	ctrl_info->product_id =3D (u8)product_id;
 	ctrl_info->product_revision =3D (u8)(product_id >> 8);
=20
-	if (reset_devices) {
+	if (is_kdump_kernel()) {
 		if (ctrl_info->max_outstanding_requests >
 			PQI_MAX_OUTSTANDING_REQUESTS_KDUMP)
 				ctrl_info->max_outstanding_requests =3D
@@ -8480,7 +8481,7 @@ static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_i=
nfo)
 	if (rc)
 		return rc;
=20
-	if (ctrl_info->ctrl_logging_supported && !reset_devices) {
+	if (ctrl_info->ctrl_logging_supported && !is_kdump_kernel()) {
 		pqi_host_setup_buffer(ctrl_info, &ctrl_info->ctrl_log_memory, PQI_CTRL_L=
OG_TOTAL_SIZE, PQI_CTRL_LOG_MIN_SIZE);
 		pqi_host_memory_update(ctrl_info, &ctrl_info->ctrl_log_memory, PQI_VENDO=
R_GENERAL_CTRL_LOG_MEMORY_UPDATE);
 	}
diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index 90b5ab60f5ae..634cf163f4cb 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -466,6 +466,56 @@ static ssize_t critical_health_show(struct device *dev=
,
 	return sysfs_emit(buf, "%d\n", hba->critical_health_count);
 }
=20
+static ssize_t device_lvl_exception_count_show(struct device *dev,
+					       struct device_attribute *attr,
+					       char *buf)
+{
+	struct ufs_hba *hba =3D dev_get_drvdata(dev);
+
+	if (hba->dev_info.wspecversion < 0x410)
+		return -EOPNOTSUPP;
+
+	return sysfs_emit(buf, "%u\n", atomic_read(&hba->dev_lvl_exception_count)=
);
+}
+
+static ssize_t device_lvl_exception_count_store(struct device *dev,
+						struct device_attribute *attr,
+						const char *buf, size_t count)
+{
+	struct ufs_hba *hba =3D dev_get_drvdata(dev);
+	unsigned int value;
+
+	if (kstrtouint(buf, 0, &value))
+		return -EINVAL;
+
+	/* the only supported usecase is to reset the dev_lvl_exception_count */
+	if (value)
+		return -EINVAL;
+
+	atomic_set(&hba->dev_lvl_exception_count, 0);
+
+	return count;
+}
+
+static ssize_t device_lvl_exception_id_show(struct device *dev,
+					    struct device_attribute *attr,
+					    char *buf)
+{
+	struct ufs_hba *hba =3D dev_get_drvdata(dev);
+	u64 exception_id;
+	int err;
+
+	ufshcd_rpm_get_sync(hba);
+	err =3D ufshcd_read_device_lvl_exception_id(hba, &exception_id);
+	ufshcd_rpm_put_sync(hba);
+
+	if (err)
+		return err;
+
+	hba->dev_lvl_exception_id =3D exception_id;
+	return sysfs_emit(buf, "%llu\n", exception_id);
+}
+
 static DEVICE_ATTR_RW(rpm_lvl);
 static DEVICE_ATTR_RO(rpm_target_dev_state);
 static DEVICE_ATTR_RO(rpm_target_link_state);
@@ -479,6 +529,8 @@ static DEVICE_ATTR_RW(wb_flush_threshold);
 static DEVICE_ATTR_RW(rtc_update_ms);
 static DEVICE_ATTR_RW(pm_qos_enable);
 static DEVICE_ATTR_RO(critical_health);
+static DEVICE_ATTR_RW(device_lvl_exception_count);
+static DEVICE_ATTR_RO(device_lvl_exception_id);
=20
 static struct attribute *ufs_sysfs_ufshcd_attrs[] =3D {
 	&dev_attr_rpm_lvl.attr,
@@ -494,6 +546,8 @@ static struct attribute *ufs_sysfs_ufshcd_attrs[] =3D {
 	&dev_attr_rtc_update_ms.attr,
 	&dev_attr_pm_qos_enable.attr,
 	&dev_attr_critical_health.attr,
+	&dev_attr_device_lvl_exception_count.attr,
+	&dev_attr_device_lvl_exception_id.attr,
 	NULL
 };
=20
diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.=
h
index 10b4a19a70f1..d0a2c963a27d 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -94,6 +94,7 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 			     enum query_opcode desc_op);
=20
 int ufshcd_wb_toggle(struct ufs_hba *hba, bool enable);
+int ufshcd_read_device_lvl_exception_id(struct ufs_hba *hba, u64 *exceptio=
n_id);
=20
 /* Wrapper functions for safely calling variant operations */
 static inline const char *ufshcd_get_var_name(struct ufs_hba *hba)
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 0534390c2a35..44156041d88f 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3176,16 +3176,10 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *=
hba,
 	int err;
=20
 retry:
-	time_left =3D wait_for_completion_timeout(hba->dev_cmd.complete,
+	time_left =3D wait_for_completion_timeout(&hba->dev_cmd.complete,
 						time_left);
=20
 	if (likely(time_left)) {
-		/*
-		 * The completion handler called complete() and the caller of
-		 * this function still owns the @lrbp tag so the code below does
-		 * not trigger any race conditions.
-		 */
-		hba->dev_cmd.complete =3D NULL;
 		err =3D ufshcd_get_tr_ocs(lrbp, NULL);
 		if (!err)
 			err =3D ufshcd_dev_cmd_completion(hba, lrbp);
@@ -3199,7 +3193,6 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hb=
a,
 			/* successfully cleared the command, retry if needed */
 			if (ufshcd_clear_cmd(hba, lrbp->task_tag) =3D=3D 0)
 				err =3D -EAGAIN;
-			hba->dev_cmd.complete =3D NULL;
 			return err;
 		}
=20
@@ -3215,11 +3208,9 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *h=
ba,
 			spin_lock_irqsave(&hba->outstanding_lock, flags);
 			pending =3D test_bit(lrbp->task_tag,
 					   &hba->outstanding_reqs);
-			if (pending) {
-				hba->dev_cmd.complete =3D NULL;
+			if (pending)
 				__clear_bit(lrbp->task_tag,
 					    &hba->outstanding_reqs);
-			}
 			spin_unlock_irqrestore(&hba->outstanding_lock, flags);
=20
 			if (!pending) {
@@ -3237,8 +3228,6 @@ static int ufshcd_wait_for_dev_cmd(struct ufs_hba *hb=
a,
 			spin_lock_irqsave(&hba->outstanding_lock, flags);
 			pending =3D test_bit(lrbp->task_tag,
 					   &hba->outstanding_reqs);
-			if (pending)
-				hba->dev_cmd.complete =3D NULL;
 			spin_unlock_irqrestore(&hba->outstanding_lock, flags);
=20
 			if (!pending) {
@@ -3272,13 +3261,9 @@ static void ufshcd_dev_man_unlock(struct ufs_hba *hb=
a)
 static int ufshcd_issue_dev_cmd(struct ufs_hba *hba, struct ufshcd_lrb *lr=
bp,
 			  const u32 tag, int timeout)
 {
-	DECLARE_COMPLETION_ONSTACK(wait);
 	int err;
=20
-	hba->dev_cmd.complete =3D &wait;
-
 	ufshcd_add_query_upiu_trace(hba, UFS_QUERY_SEND, lrbp->ucd_req_ptr);
-
 	ufshcd_send_command(hba, tag, hba->dev_cmd_queue);
 	err =3D ufshcd_wait_for_dev_cmd(hba, lrbp, timeout);
=20
@@ -5585,12 +5570,12 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int =
task_tag,
 		ufshcd_release_scsi_cmd(hba, lrbp);
 		/* Do not touch lrbp after scsi done */
 		scsi_done(cmd);
-	} else if (hba->dev_cmd.complete) {
+	} else {
 		if (cqe) {
 			ocs =3D le32_to_cpu(cqe->status) & MASK_OCS;
 			lrbp->utr_descriptor_ptr->header.ocs =3D ocs;
 		}
-		complete(hba->dev_cmd.complete);
+		complete(&hba->dev_cmd.complete);
 	}
 }
=20
@@ -6013,6 +5998,42 @@ static void ufshcd_bkops_exception_event_handler(str=
uct ufs_hba *hba)
 				__func__, err);
 }
=20
+int ufshcd_read_device_lvl_exception_id(struct ufs_hba *hba, u64 *exceptio=
n_id)
+{
+	struct utp_upiu_query_v4_0 *upiu_resp;
+	struct ufs_query_req *request =3D NULL;
+	struct ufs_query_res *response =3D NULL;
+	int err;
+
+	if (hba->dev_info.wspecversion < 0x410)
+		return -EOPNOTSUPP;
+
+	ufshcd_hold(hba);
+	mutex_lock(&hba->dev_cmd.lock);
+
+	ufshcd_init_query(hba, &request, &response,
+			  UPIU_QUERY_OPCODE_READ_ATTR,
+			  QUERY_ATTR_IDN_DEV_LVL_EXCEPTION_ID, 0, 0);
+
+	request->query_func =3D UPIU_QUERY_FUNC_STANDARD_READ_REQUEST;
+
+	err =3D ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_QUERY, QUERY_REQ_TIMEOUT);
+
+	if (err) {
+		dev_err(hba->dev, "%s: failed to read device level exception %d\n",
+			__func__, err);
+		goto out;
+	}
+
+	upiu_resp =3D (struct utp_upiu_query_v4_0 *)response;
+	*exception_id =3D get_unaligned_be64(&upiu_resp->osf3);
+out:
+	mutex_unlock(&hba->dev_cmd.lock);
+	ufshcd_release(hba);
+
+	return err;
+}
+
 static int __ufshcd_wb_toggle(struct ufs_hba *hba, bool set, enum flag_idn=
 idn)
 {
 	u8 index;
@@ -6083,7 +6104,7 @@ int ufshcd_wb_toggle_buf_flush(struct ufs_hba *hba, b=
ool enable)
 	return ret;
 }
=20
-static bool ufshcd_wb_presrv_usrspc_keep_vcc_on(struct ufs_hba *hba,
+static bool ufshcd_wb_curr_buff_threshold_check(struct ufs_hba *hba,
 						u32 avail_buf)
 {
 	u32 cur_buf;
@@ -6165,15 +6186,13 @@ static bool ufshcd_wb_need_flush(struct ufs_hba *hb=
a)
 	}
=20
 	/*
-	 * The ufs device needs the vcc to be ON to flush.
 	 * With user-space reduction enabled, it's enough to enable flush
 	 * by checking only the available buffer. The threshold
 	 * defined here is > 90% full.
 	 * With user-space preserved enabled, the current-buffer
 	 * should be checked too because the wb buffer size can reduce
 	 * when disk tends to be full. This info is provided by current
-	 * buffer (dCurrentWriteBoosterBufferSize). There's no point in
-	 * keeping vcc on when current buffer is empty.
+	 * buffer (dCurrentWriteBoosterBufferSize).
 	 */
 	index =3D ufshcd_wb_get_query_index(hba);
 	ret =3D ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
@@ -6188,7 +6207,7 @@ static bool ufshcd_wb_need_flush(struct ufs_hba *hba)
 	if (!hba->dev_info.b_presrv_uspc_en)
 		return avail_buf <=3D UFS_WB_BUF_REMAIN_PERCENT(10);
=20
-	return ufshcd_wb_presrv_usrspc_keep_vcc_on(hba, avail_buf);
+	return ufshcd_wb_curr_buff_threshold_check(hba, avail_buf);
 }
=20
 static void ufshcd_rpm_dev_flush_recheck_work(struct work_struct *work)
@@ -6240,6 +6259,11 @@ static void ufshcd_exception_event_handler(struct wo=
rk_struct *work)
 		sysfs_notify(&hba->dev->kobj, NULL, "critical_health");
 	}
=20
+	if (status & hba->ee_drv_mask & MASK_EE_DEV_LVL_EXCEPTION) {
+		atomic_inc(&hba->dev_lvl_exception_count);
+		sysfs_notify(&hba->dev->kobj, NULL, "device_lvl_exception_count");
+	}
+
 	ufs_debugfs_exception_event(hba, status);
 }
=20
@@ -8139,6 +8163,22 @@ static void ufshcd_temp_notif_probe(struct ufs_hba *=
hba, const u8 *desc_buf)
 	}
 }
=20
+static void ufshcd_device_lvl_exception_probe(struct ufs_hba *hba, u8 *des=
c_buf)
+{
+	u32 ext_ufs_feature;
+
+	if (hba->dev_info.wspecversion < 0x410)
+		return;
+
+	ext_ufs_feature =3D get_unaligned_be32(desc_buf +
+				DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP);
+	if (!(ext_ufs_feature & UFS_DEV_LVL_EXCEPTION_SUP))
+		return;
+
+	atomic_set(&hba->dev_lvl_exception_count, 0);
+	ufshcd_enable_ee(hba, MASK_EE_DEV_LVL_EXCEPTION);
+}
+
 static void ufshcd_set_rtt(struct ufs_hba *hba)
 {
 	struct ufs_dev_info *dev_info =3D &hba->dev_info;
@@ -8339,6 +8379,8 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
=20
 	ufs_init_rtc(hba, desc_buf);
=20
+	ufshcd_device_lvl_exception_probe(hba, desc_buf);
+
 	/*
 	 * ufshcd_read_string_desc returns size of the string
 	 * reset the error value
@@ -10490,6 +10532,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *=
mmio_base, unsigned int irq)
 						UFS_SLEEP_PWR_MODE,
 						UIC_LINK_HIBERN8_STATE);
=20
+	init_completion(&hba->dev_cmd.complete);
+
 	err =3D ufshcd_hba_init(hba);
 	if (err)
 		goto out_error;
diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index d7539cda97da..3e545af536e5 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -34,7 +34,7 @@
  * Exynos's Vendor specific registers for UFSHCI
  */
 #define HCI_TXPRDT_ENTRY_SIZE	0x00
-#define PRDT_PREFECT_EN		BIT(31)
+#define PRDT_PREFETCH_EN	BIT(31)
 #define HCI_RXPRDT_ENTRY_SIZE	0x04
 #define HCI_1US_TO_CNT_VAL	0x0C
 #define CNT_VAL_1US_MASK	0x3FF
@@ -92,11 +92,16 @@
 				 UIC_TRANSPORT_NO_CONNECTION_RX |\
 				 UIC_TRANSPORT_BAD_TC)
=20
-/* FSYS UFS Shareability */
-#define UFS_WR_SHARABLE		BIT(2)
-#define UFS_RD_SHARABLE		BIT(1)
-#define UFS_SHARABLE		(UFS_WR_SHARABLE | UFS_RD_SHARABLE)
-#define UFS_SHAREABILITY_OFFSET	0x710
+/* UFS Shareability */
+#define UFS_EXYNOSAUTO_WR_SHARABLE	BIT(2)
+#define UFS_EXYNOSAUTO_RD_SHARABLE	BIT(1)
+#define UFS_EXYNOSAUTO_SHARABLE		(UFS_EXYNOSAUTO_WR_SHARABLE | \
+					 UFS_EXYNOSAUTO_RD_SHARABLE)
+#define UFS_GS101_WR_SHARABLE		BIT(1)
+#define UFS_GS101_RD_SHARABLE		BIT(0)
+#define UFS_GS101_SHARABLE		(UFS_GS101_WR_SHARABLE | \
+					 UFS_GS101_RD_SHARABLE)
+#define UFS_SHAREABILITY_OFFSET		0x710
=20
 /* Multi-host registers */
 #define MHCTRL			0xC4
@@ -209,8 +214,8 @@ static int exynos_ufs_shareability(struct exynos_ufs *u=
fs)
 	/* IO Coherency setting */
 	if (ufs->sysreg) {
 		return regmap_update_bits(ufs->sysreg,
-					  ufs->shareability_reg_offset,
-					  UFS_SHARABLE, UFS_SHARABLE);
+					  ufs->iocc_offset,
+					  ufs->iocc_mask, ufs->iocc_val);
 	}
=20
 	return 0;
@@ -957,6 +962,12 @@ static int exynos_ufs_phy_init(struct exynos_ufs *ufs)
 	}
=20
 	phy_set_bus_width(generic_phy, ufs->avail_ln_rx);
+
+	if (generic_phy->power_count) {
+		phy_power_off(generic_phy);
+		phy_exit(generic_phy);
+	}
+
 	ret =3D phy_init(generic_phy);
 	if (ret) {
 		dev_err(hba->dev, "%s: phy init failed, ret =3D %d\n",
@@ -1049,9 +1060,14 @@ static int exynos_ufs_pre_link(struct ufs_hba *hba)
 	exynos_ufs_config_intr(ufs, DFES_DEF_L4_ERRS, UNIPRO_L4);
 	exynos_ufs_set_unipro_pclk_div(ufs);
=20
+	exynos_ufs_setup_clocks(hba, true, PRE_CHANGE);
+
 	/* unipro */
 	exynos_ufs_config_unipro(ufs);
=20
+	if (ufs->drv_data->pre_link)
+		ufs->drv_data->pre_link(ufs);
+
 	/* m-phy */
 	exynos_ufs_phy_init(ufs);
 	if (!(ufs->opts & EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR)) {
@@ -1059,11 +1075,6 @@ static int exynos_ufs_pre_link(struct ufs_hba *hba)
 		exynos_ufs_config_phy_cap_attr(ufs);
 	}
=20
-	exynos_ufs_setup_clocks(hba, true, PRE_CHANGE);
-
-	if (ufs->drv_data->pre_link)
-		ufs->drv_data->pre_link(ufs);
-
 	return 0;
 }
=20
@@ -1087,12 +1098,17 @@ static int exynos_ufs_post_link(struct ufs_hba *hba=
)
 	struct exynos_ufs *ufs =3D ufshcd_get_variant(hba);
 	struct phy *generic_phy =3D ufs->phy;
 	struct exynos_ufs_uic_attr *attr =3D ufs->drv_data->uic_attr;
+	u32 val =3D ilog2(DATA_UNIT_SIZE);
=20
 	exynos_ufs_establish_connt(ufs);
 	exynos_ufs_fit_aggr_timeout(ufs);
=20
 	hci_writel(ufs, 0xa, HCI_DATA_REORDER);
-	hci_writel(ufs, ilog2(DATA_UNIT_SIZE), HCI_TXPRDT_ENTRY_SIZE);
+
+	if (hba->caps & UFSHCD_CAP_CRYPTO)
+		val |=3D PRDT_PREFETCH_EN;
+	hci_writel(ufs, val, HCI_TXPRDT_ENTRY_SIZE);
+
 	hci_writel(ufs, ilog2(DATA_UNIT_SIZE), HCI_RXPRDT_ENTRY_SIZE);
 	hci_writel(ufs, (1 << hba->nutrs) - 1, HCI_UTRL_NEXUS_TYPE);
 	hci_writel(ufs, (1 << hba->nutmrs) - 1, HCI_UTMRL_NEXUS_TYPE);
@@ -1168,12 +1184,22 @@ static int exynos_ufs_parse_dt(struct device *dev, =
struct exynos_ufs *ufs)
 		ufs->sysreg =3D NULL;
 	else {
 		if (of_property_read_u32_index(np, "samsung,sysreg", 1,
-					       &ufs->shareability_reg_offset)) {
+					       &ufs->iocc_offset)) {
 			dev_warn(dev, "can't get an offset from sysreg. Set to default value\n"=
);
-			ufs->shareability_reg_offset =3D UFS_SHAREABILITY_OFFSET;
+			ufs->iocc_offset =3D UFS_SHAREABILITY_OFFSET;
 		}
 	}
=20
+	ufs->iocc_mask =3D ufs->drv_data->iocc_mask;
+	/*
+	 * no 'dma-coherent' property means the descriptors are
+	 * non-cacheable so iocc shareability should be disabled.
+	 */
+	if (of_dma_is_coherent(dev->of_node))
+		ufs->iocc_val =3D ufs->iocc_mask;
+	else
+		ufs->iocc_val =3D 0;
+
 	ufs->pclk_avail_min =3D PCLK_AVAIL_MIN;
 	ufs->pclk_avail_max =3D PCLK_AVAIL_MAX;
=20
@@ -1497,6 +1523,14 @@ static int exynos_ufs_init(struct ufs_hba *hba)
 	return ret;
 }
=20
+static void exynos_ufs_exit(struct ufs_hba *hba)
+{
+	struct exynos_ufs *ufs =3D ufshcd_get_variant(hba);
+
+	phy_power_off(ufs->phy);
+	phy_exit(ufs->phy);
+}
+
 static int exynos_ufs_host_reset(struct ufs_hba *hba)
 {
 	struct exynos_ufs *ufs =3D ufshcd_get_variant(hba);
@@ -1667,6 +1701,12 @@ static void exynos_ufs_hibern8_notify(struct ufs_hba=
 *hba,
 	}
 }
=20
+static int gs101_ufs_suspend(struct exynos_ufs *ufs)
+{
+	hci_writel(ufs, 0 << 0, HCI_GPIO_OUT);
+	return 0;
+}
+
 static int exynos_ufs_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
 	enum ufs_notify_change_status status)
 {
@@ -1675,6 +1715,9 @@ static int exynos_ufs_suspend(struct ufs_hba *hba, en=
um ufs_pm_op pm_op,
 	if (status =3D=3D PRE_CHANGE)
 		return 0;
=20
+	if (ufs->drv_data->suspend)
+		ufs->drv_data->suspend(ufs);
+
 	if (!ufshcd_is_link_active(hba))
 		phy_power_off(ufs->phy);
=20
@@ -1952,6 +1995,7 @@ static int gs101_ufs_pre_pwr_change(struct exynos_ufs=
 *ufs,
 static const struct ufs_hba_variant_ops ufs_hba_exynos_ops =3D {
 	.name				=3D "exynos_ufs",
 	.init				=3D exynos_ufs_init,
+	.exit				=3D exynos_ufs_exit,
 	.hce_enable_notify		=3D exynos_ufs_hce_enable_notify,
 	.link_startup_notify		=3D exynos_ufs_link_startup_notify,
 	.pwr_change_notify		=3D exynos_ufs_pwr_change_notify,
@@ -1990,13 +2034,7 @@ static int exynos_ufs_probe(struct platform_device *=
pdev)
=20
 static void exynos_ufs_remove(struct platform_device *pdev)
 {
-	struct ufs_hba *hba =3D  platform_get_drvdata(pdev);
-	struct exynos_ufs *ufs =3D ufshcd_get_variant(hba);
-
 	ufshcd_pltfrm_remove(pdev);
-
-	phy_power_off(ufs->phy);
-	phy_exit(ufs->phy);
 }
=20
 static struct exynos_ufs_uic_attr exynos7_uic_attr =3D {
@@ -2035,6 +2073,7 @@ static const struct exynos_ufs_drv_data exynosauto_uf=
s_drvs =3D {
 	.opts			=3D EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL |
 				  EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR |
 				  EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX,
+	.iocc_mask		=3D UFS_EXYNOSAUTO_SHARABLE,
 	.drv_init		=3D exynosauto_ufs_drv_init,
 	.post_hce_enable	=3D exynosauto_ufs_post_hce_enable,
 	.pre_link		=3D exynosauto_ufs_pre_link,
@@ -2136,10 +2175,12 @@ static const struct exynos_ufs_drv_data gs101_ufs_d=
rvs =3D {
 	.opts			=3D EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR |
 				  EXYNOS_UFS_OPT_UFSPR_SECURE |
 				  EXYNOS_UFS_OPT_TIMER_TICK_SELECT,
+	.iocc_mask		=3D UFS_GS101_SHARABLE,
 	.drv_init		=3D gs101_ufs_drv_init,
 	.pre_link		=3D gs101_ufs_pre_link,
 	.post_link		=3D gs101_ufs_post_link,
 	.pre_pwr_change		=3D gs101_ufs_pre_pwr_change,
+	.suspend		=3D gs101_ufs_suspend,
 };
=20
 static const struct of_device_id exynos_ufs_of_match[] =3D {
diff --git a/drivers/ufs/host/ufs-exynos.h b/drivers/ufs/host/ufs-exynos.h
index aac517276189..abe7e472759e 100644
--- a/drivers/ufs/host/ufs-exynos.h
+++ b/drivers/ufs/host/ufs-exynos.h
@@ -181,6 +181,7 @@ struct exynos_ufs_drv_data {
 	struct exynos_ufs_uic_attr *uic_attr;
 	unsigned int quirks;
 	unsigned int opts;
+	u32 iocc_mask;
 	/* SoC's specific operations */
 	int (*drv_init)(struct exynos_ufs *ufs);
 	int (*pre_link)(struct exynos_ufs *ufs);
@@ -191,6 +192,7 @@ struct exynos_ufs_drv_data {
 			       const struct ufs_pa_layer_attr *pwr);
 	int (*pre_hce_enable)(struct exynos_ufs *ufs);
 	int (*post_hce_enable)(struct exynos_ufs *ufs);
+	int (*suspend)(struct exynos_ufs *ufs);
 };
=20
 struct ufs_phy_time_cfg {
@@ -230,7 +232,9 @@ struct exynos_ufs {
 	ktime_t entry_hibern8_t;
 	const struct exynos_ufs_drv_data *drv_data;
 	struct regmap *sysreg;
-	u32 shareability_reg_offset;
+	u32 iocc_offset;
+	u32 iocc_mask;
+	u32 iocc_val;
=20
 	u32 opts;
 #define EXYNOS_UFS_OPT_HAS_APB_CLK_CTRL		BIT(0)
diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
index 8a24ed59ec46..1c47136d8715 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -180,7 +180,8 @@ enum attr_idn {
 	QUERY_ATTR_IDN_AVAIL_WB_BUFF_SIZE       =3D 0x1D,
 	QUERY_ATTR_IDN_WB_BUFF_LIFE_TIME_EST    =3D 0x1E,
 	QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE        =3D 0x1F,
-	QUERY_ATTR_IDN_TIMESTAMP		=3D 0x30
+	QUERY_ATTR_IDN_TIMESTAMP		=3D 0x30,
+	QUERY_ATTR_IDN_DEV_LVL_EXCEPTION_ID     =3D 0x34,
 };
=20
 /* Descriptor idn for Query requests */
@@ -390,6 +391,7 @@ enum {
 	UFS_DEV_EXT_TEMP_NOTIF		=3D BIT(6),
 	UFS_DEV_HPB_SUPPORT		=3D BIT(7),
 	UFS_DEV_WRITE_BOOSTER_SUP	=3D BIT(8),
+	UFS_DEV_LVL_EXCEPTION_SUP       =3D BIT(12),
 };
 #define UFS_DEV_HPB_SUPPORT_VERSION		0x310
=20
@@ -419,6 +421,7 @@ enum {
 	MASK_EE_TOO_LOW_TEMP		=3D BIT(4),
 	MASK_EE_WRITEBOOSTER_EVENT	=3D BIT(5),
 	MASK_EE_PERFORMANCE_THROTTLING	=3D BIT(6),
+	MASK_EE_DEV_LVL_EXCEPTION       =3D BIT(7),
 	MASK_EE_HEALTH_CRITICAL		=3D BIT(9),
 };
 #define MASK_EE_URGENT_TEMP (MASK_EE_TOO_HIGH_TEMP | MASK_EE_TOO_LOW_TEMP)
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index e3909cc691b2..e928ed0265ff 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -246,7 +246,7 @@ struct ufs_query {
 struct ufs_dev_cmd {
 	enum dev_cmd_type type;
 	struct mutex lock;
-	struct completion *complete;
+	struct completion complete;
 	struct ufs_query query;
 };
=20
@@ -968,6 +968,9 @@ enum ufshcd_mcq_opr {
  * @pm_qos_req: PM QoS request handle
  * @pm_qos_enabled: flag to check if pm qos is enabled
  * @critical_health_count: count of critical health exceptions
+ * @dev_lvl_exception_count: count of device level exceptions since last r=
eset
+ * @dev_lvl_exception_id: vendor specific information about the
+ * device level exception event.
  */
 struct ufs_hba {
 	void __iomem *mmio_base;
@@ -1138,6 +1141,8 @@ struct ufs_hba {
 	bool pm_qos_enabled;
=20
 	int critical_health_count;
+	atomic_t dev_lvl_exception_count;
+	u64 dev_lvl_exception_id;
 };
=20
 /**

