From: <kgudipat@brocade.com>
Subject: [PATCH 08/15] bfa: Add support to configure and query flash boot partition
Date: Wed, 20 Jul 2011 17:02:32 -0700
Message-ID: <1311206552-6756-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:59849 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751660Ab1GUACu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jul 2011 20:02:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: huangj@brocade.com, adapter_linux_open_src_team@brocade.com, kgudipat@brocade.com

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:
	- Added support to configure and query the flash boot partitions.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfa_defs.h |   23 ++++++++
 drivers/scsi/bfa/bfad_bsg.c |  124 +++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/bfa/bfad_bsg.h |   26 +++++++++
 3 files changed, 173 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_defs.h b/drivers/scsi/bfa/bfa_defs.h
index 2dc4b6f..75b9d91 100644
--- a/drivers/scsi/bfa/bfa_defs.h
+++ b/drivers/scsi/bfa/bfa_defs.h
@@ -656,6 +656,20 @@ struct bfa_boot_bootlun_s {
 /*
  * BOOT boot configuraton
  */
+struct bfa_boot_cfg_s {
+	u8		version;
+	u8		rsvd1;
+	u16		chksum;
+	u8		enable;		/* enable/disable SAN boot */
+	u8		speed;          /* boot speed settings */
+	u8		topology;       /* boot topology setting */
+	u8		bootopt;        /* bfa_boot_bootopt_t */
+	u32		nbluns;         /* number of boot luns */
+	u32		rsvd2;
+	struct bfa_boot_bootlun_s blun[BFA_BOOT_BOOTLUN_MAX];
+	struct bfa_boot_bootlun_s blun_disc[BFA_BOOT_BOOTLUN_MAX];
+};
+
 struct bfa_boot_pbc_s {
 	u8              enable;         /*  enable/disable SAN boot */
 	u8              speed;          /*  boot speed settings */
@@ -665,6 +679,15 @@ struct bfa_boot_pbc_s {
 	struct bfa_boot_bootlun_s pblun[BFA_PREBOOT_BOOTLUN_MAX];
 };
 
+struct bfa_ethboot_cfg_s {
+	u8		version;
+	u8		rsvd1;
+	u16		chksum;
+	u8		enable;	/* enable/disable Eth/PXE boot */
+	u8		rsvd2;
+	u16		vlan;
+};
+
 /*
  * ASIC block configuration related structures
  */
diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index 0d920ed..f782ee4 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -2072,6 +2072,115 @@ out:
 	return 0;
 }
 
+int
+bfad_iocmd_boot_cfg(struct bfad_s *bfad, void *cmd)
+{
+	struct bfa_bsg_boot_s *iocmd = (struct bfa_bsg_boot_s *)cmd;
+	struct bfad_hal_comp fcomp;
+	unsigned long	flags;
+
+	init_completion(&fcomp.comp);
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	iocmd->status = bfa_flash_update_part(BFA_FLASH(&bfad->bfa),
+			BFA_FLASH_PART_BOOT, PCI_FUNC(bfad->pcidev->devfn),
+			&iocmd->cfg, sizeof(struct bfa_boot_cfg_s), 0,
+			bfad_hcb_comp, &fcomp);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+	if (iocmd->status != BFA_STATUS_OK)
+		goto out;
+	wait_for_completion(&fcomp.comp);
+	iocmd->status = fcomp.status;
+out:
+	return 0;
+}
+
+int
+bfad_iocmd_boot_query(struct bfad_s *bfad, void *cmd)
+{
+	struct bfa_bsg_boot_s *iocmd = (struct bfa_bsg_boot_s *)cmd;
+	struct bfad_hal_comp fcomp;
+	unsigned long	flags;
+
+	init_completion(&fcomp.comp);
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	iocmd->status = bfa_flash_read_part(BFA_FLASH(&bfad->bfa),
+			BFA_FLASH_PART_BOOT, PCI_FUNC(bfad->pcidev->devfn),
+			&iocmd->cfg, sizeof(struct bfa_boot_cfg_s), 0,
+			bfad_hcb_comp, &fcomp);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+	if (iocmd->status != BFA_STATUS_OK)
+		goto out;
+	wait_for_completion(&fcomp.comp);
+	iocmd->status = fcomp.status;
+out:
+	return 0;
+}
+
+int
+bfad_iocmd_preboot_query(struct bfad_s *bfad, void *cmd)
+{
+	struct bfa_bsg_preboot_s *iocmd = (struct bfa_bsg_preboot_s *)cmd;
+	struct bfi_iocfc_cfgrsp_s *cfgrsp = bfad->bfa.iocfc.cfgrsp;
+	struct bfa_boot_pbc_s *pbcfg = &iocmd->cfg;
+	unsigned long	flags;
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	pbcfg->enable = cfgrsp->pbc_cfg.boot_enabled;
+	pbcfg->nbluns = cfgrsp->pbc_cfg.nbluns;
+	pbcfg->speed = cfgrsp->pbc_cfg.port_speed;
+	memcpy(pbcfg->pblun, cfgrsp->pbc_cfg.blun, sizeof(pbcfg->pblun));
+	iocmd->status = BFA_STATUS_OK;
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+	return 0;
+}
+
+int
+bfad_iocmd_ethboot_cfg(struct bfad_s *bfad, void *cmd)
+{
+	struct bfa_bsg_ethboot_s *iocmd = (struct bfa_bsg_ethboot_s *)cmd;
+	struct bfad_hal_comp fcomp;
+	unsigned long	flags;
+
+	init_completion(&fcomp.comp);
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	iocmd->status = bfa_flash_update_part(BFA_FLASH(&bfad->bfa),
+				BFA_FLASH_PART_PXECFG,
+				bfad->bfa.ioc.port_id, &iocmd->cfg,
+				sizeof(struct bfa_ethboot_cfg_s), 0,
+				bfad_hcb_comp, &fcomp);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+	if (iocmd->status != BFA_STATUS_OK)
+		goto out;
+	wait_for_completion(&fcomp.comp);
+	iocmd->status = fcomp.status;
+out:
+	return 0;
+}
+
+int
+bfad_iocmd_ethboot_query(struct bfad_s *bfad, void *cmd)
+{
+	struct bfa_bsg_ethboot_s *iocmd = (struct bfa_bsg_ethboot_s *)cmd;
+	struct bfad_hal_comp fcomp;
+	unsigned long	flags;
+
+	init_completion(&fcomp.comp);
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	iocmd->status = bfa_flash_read_part(BFA_FLASH(&bfad->bfa),
+				BFA_FLASH_PART_PXECFG,
+				bfad->bfa.ioc.port_id, &iocmd->cfg,
+				sizeof(struct bfa_ethboot_cfg_s), 0,
+				bfad_hcb_comp, &fcomp);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+	if (iocmd->status != BFA_STATUS_OK)
+		goto out;
+	wait_for_completion(&fcomp.comp);
+	iocmd->status = fcomp.status;
+out:
+	return 0;
+}
+
 static int
 bfad_iocmd_handler(struct bfad_s *bfad, unsigned int cmd, void *iocmd,
 		unsigned int payload_len)
@@ -2346,6 +2455,21 @@ bfad_iocmd_handler(struct bfad_s *bfad, unsigned int cmd, void *iocmd,
 	case IOCMD_FCPORT_RESET_STATS:
 		rc = bfad_iocmd_fcport_reset_stats(bfad, iocmd);
 		break;
+	case IOCMD_BOOT_CFG:
+		rc = bfad_iocmd_boot_cfg(bfad, iocmd);
+		break;
+	case IOCMD_BOOT_QUERY:
+		rc = bfad_iocmd_boot_query(bfad, iocmd);
+		break;
+	case IOCMD_PREBOOT_QUERY:
+		rc = bfad_iocmd_preboot_query(bfad, iocmd);
+		break;
+	case IOCMD_ETHBOOT_CFG:
+		rc = bfad_iocmd_ethboot_cfg(bfad, iocmd);
+		break;
+	case IOCMD_ETHBOOT_QUERY:
+		rc = bfad_iocmd_ethboot_query(bfad, iocmd);
+		break;
 	default:
 		rc = -EINVAL;
 		break;
diff --git a/drivers/scsi/bfa/bfad_bsg.h b/drivers/scsi/bfa/bfad_bsg.h
index f64f3ee..95694ce 100644
--- a/drivers/scsi/bfa/bfad_bsg.h
+++ b/drivers/scsi/bfa/bfad_bsg.h
@@ -121,6 +121,11 @@ enum {
 	IOCMD_ITNIM_GET_IOPROFILE,
 	IOCMD_FCPORT_GET_STATS,
 	IOCMD_FCPORT_RESET_STATS,
+	IOCMD_BOOT_CFG,
+	IOCMD_BOOT_QUERY,
+	IOCMD_PREBOOT_QUERY,
+	IOCMD_ETHBOOT_CFG,
+	IOCMD_ETHBOOT_QUERY,
 };
 
 struct bfa_bsg_gen_s {
@@ -630,6 +635,27 @@ struct bfa_bsg_vhba_attr_s {
 	struct bfa_vhba_attr_s	attr;
 };
 
+struct bfa_bsg_boot_s {
+	bfa_status_t	status;
+	u16		bfad_num;
+	u16		rsvd;
+	struct bfa_boot_cfg_s	cfg;
+};
+
+struct bfa_bsg_preboot_s {
+	bfa_status_t	status;
+	u16		bfad_num;
+	u16		rsvd;
+	struct bfa_boot_pbc_s	cfg;
+};
+
+struct bfa_bsg_ethboot_s {
+	bfa_status_t	status;
+	u16		bfad_num;
+	u16		rsvd;
+	struct  bfa_ethboot_cfg_s  cfg;
+};
+
 struct bfa_bsg_fcpt_s {
 	bfa_status_t    status;
 	u16		vf_id;
-- 
1.7.3.rc1

