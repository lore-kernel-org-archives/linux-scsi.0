Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F93231A30;
	Sat, 11 Oct 2025 14:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760194028; cv=none; b=f4ZjK2kpPg0oTf+Ycg8mTjC+54yYEHYSoIJiXlDf7kn/b7y4g23XlZG5xsZDSNcuDDSSzf59z5YyDlq8gvVjamGniInqZ8uvaFUhvqVdQrx2OJw0WBOfigAyqb4edGt21IuCXmENjNdwjOGDwAa5RtJAHrGpYbw60J8+se/csao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760194028; c=relaxed/simple;
	bh=6ROqezrawUAo54k0Q9wo7e3pvws5UWXMBfZUYg8H/WA=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=hqnhQnzOHck59x/NvngJg5ck3brUe1NULyIbCq3Ql8McWbrsf3QOcJdIKPHYeP4dW8oSbTk8lWklMTTkBfwqQwESWsZTeQI2VpomI8f3Zkmt6SHMt3ad5bVYDvAHNpp8K9LQgonvCEKTxTzBAXEKlh4xlBVp10/9Jo9bu8pyRQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=kcIbzNPV; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="kcIbzNPV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1760194023;
	bh=6ROqezrawUAo54k0Q9wo7e3pvws5UWXMBfZUYg8H/WA=;
	h=Message-ID:Subject:From:To:Date:From;
	b=kcIbzNPViGjdfCTsaFhX4i9+jq5BcB7XdYIKxW0I3+r/Up6lpHhgiYyVga//E7u0b
	 MZj0XCZfAQRx+Oojtlj2+lMvt2avgZS8ozQjk2Ckdiw6DoOG1I3x1kTWbRq6DWhObN
	 Geu26kgNgMAM6OlX0us0S3fHR7CY7KKm57EMeqJM=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4302:c21::a774])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id 05F261C0586;
	Sat, 11 Oct 2025 10:47:02 -0400 (EDT)
Message-ID: <6e77e31acee95ebcba03c54dc1b34173cbaf831e.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for the 6.17+ merge window
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Sat, 11 Oct 2025 10:47:02 -0400
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

Fixes only in drivers (ufs, mvsas, qla2xxx, target) that came in just
before or during the merge window.  The most important one is the
qla2xxx which reverts a conversion to fix flexible array member
warnings that went up in this merge window but which turned out on
further testing to be causing data corruption.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Daniel Lee (1):
      scsi: ufs: sysfs: Make HID attributes visible

Duoming Zhou (1):
      scsi: mvsas: Fix use-after-free bugs in mvs_work_queue

Hoyoung Seo (1):
      scsi: ufs: core: Include UTP error in INT_FATAL_ERRORS

John Meneghini (1):
      Revert "scsi: qla2xxx: Fix memcpy() field-spanning write issue"

Marek Szyprowski (1):
      scsi: ufs: core: Fix PM QoS mutex initialization

Peter Wang (1):
      scsi: ufs: core: Fix runtime suspend error deadlock

Wang Haoran (1):
      scsi: target: target_core_configfs: Add length check to avoid buffer =
overflow

And the diffstat:

 drivers/scsi/mvsas/mv_init.c          |  2 +-
 drivers/scsi/qla2xxx/qla_def.h        | 10 ++++------
 drivers/scsi/qla2xxx/qla_isr.c        | 17 +++++++++--------
 drivers/scsi/qla2xxx/qla_nvme.c       |  2 +-
 drivers/scsi/qla2xxx/qla_os.c         |  5 ++---
 drivers/target/target_core_configfs.c |  2 +-
 drivers/ufs/core/ufs-sysfs.c          |  2 +-
 drivers/ufs/core/ufs-sysfs.h          |  1 +
 drivers/ufs/core/ufshcd.c             | 16 +++++++++++++---
 include/ufs/ufshci.h                  |  4 +++-
 10 files changed, 36 insertions(+), 25 deletions(-)

with full diff below.

Regards,

James

---

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 2c72da6b8cf0..7f1ad305eee6 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -124,7 +124,7 @@ static void mvs_free(struct mvs_info *mvi)
 	if (mvi->shost)
 		scsi_host_put(mvi->shost);
 	list_for_each_entry(mwq, &mvi->wq_list, entry)
-		cancel_delayed_work(&mwq->work_q);
+		cancel_delayed_work_sync(&mwq->work_q);
 	kfree(mvi->rsvd_tags);
 	kfree(mvi);
 }
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.=
h
index 604e66bead1e..cb95b7b12051 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -4890,7 +4890,9 @@ struct purex_item {
 			     struct purex_item *pkt);
 	atomic_t in_use;
 	uint16_t size;
-	uint8_t iocb[] __counted_by(size);
+	struct {
+		uint8_t iocb[64];
+	} iocb;
 };
=20
 #include "qla_edif.h"
@@ -5099,6 +5101,7 @@ typedef struct scsi_qla_host {
 		struct list_head head;
 		spinlock_t lock;
 	} purex_list;
+	struct purex_item default_item;
=20
 	struct name_list_extended gnl;
 	/* Count of active session/fcport */
@@ -5127,11 +5130,6 @@ typedef struct scsi_qla_host {
 #define DPORT_DIAG_IN_PROGRESS                 BIT_0
 #define DPORT_DIAG_CHIP_RESET_IN_PROGRESS      BIT_1
 	uint16_t dport_status;
-
-	/* Must be last --ends in a flexible-array member. */
-	TRAILING_OVERLAP(struct purex_item, default_item, iocb,
-		uint8_t __default_item_iocb[QLA_DEFAULT_PAYLOAD_SIZE];
-	);
 } scsi_qla_host_t;
=20
 struct qla27xx_image_status {
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.=
c
index 4559b490614d..c4c6b5c6658c 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1077,17 +1077,17 @@ static struct purex_item *
 qla24xx_alloc_purex_item(scsi_qla_host_t *vha, uint16_t size)
 {
 	struct purex_item *item =3D NULL;
+	uint8_t item_hdr_size =3D sizeof(*item);
=20
 	if (size > QLA_DEFAULT_PAYLOAD_SIZE) {
-		item =3D kzalloc(struct_size(item, iocb, size), GFP_ATOMIC);
+		item =3D kzalloc(item_hdr_size +
+		    (size - QLA_DEFAULT_PAYLOAD_SIZE), GFP_ATOMIC);
 	} else {
 		if (atomic_inc_return(&vha->default_item.in_use) =3D=3D 1) {
 			item =3D &vha->default_item;
 			goto initialize_purex_header;
 		} else {
-			item =3D kzalloc(
-				struct_size(item, iocb, QLA_DEFAULT_PAYLOAD_SIZE),
-				GFP_ATOMIC);
+			item =3D kzalloc(item_hdr_size, GFP_ATOMIC);
 		}
 	}
 	if (!item) {
@@ -1127,16 +1127,17 @@ qla24xx_queue_purex_item(scsi_qla_host_t *vha, stru=
ct purex_item *pkt,
  * @vha: SCSI driver HA context
  * @pkt: ELS packet
  */
-static struct purex_item *
-qla24xx_copy_std_pkt(struct scsi_qla_host *vha, void *pkt)
+static struct purex_item
+*qla24xx_copy_std_pkt(struct scsi_qla_host *vha, void *pkt)
 {
 	struct purex_item *item;
=20
-	item =3D qla24xx_alloc_purex_item(vha, QLA_DEFAULT_PAYLOAD_SIZE);
+	item =3D qla24xx_alloc_purex_item(vha,
+					QLA_DEFAULT_PAYLOAD_SIZE);
 	if (!item)
 		return item;
=20
-	memcpy(&item->iocb, pkt, QLA_DEFAULT_PAYLOAD_SIZE);
+	memcpy(&item->iocb, pkt, sizeof(item->iocb));
 	return item;
 }
=20
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvm=
e.c
index 065f9bcca26f..316594aa40cc 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -1308,7 +1308,7 @@ void qla2xxx_process_purls_iocb(void **pkt, struct rs=
p_que **rsp)
=20
 	ql_dbg(ql_dbg_unsol, vha, 0x2121,
 	       "PURLS OP[%01x] size %d xchg addr 0x%x portid %06x\n",
-	       item->iocb[3], item->size, uctx->exchange_address,
+	       item->iocb.iocb[3], item->size, uctx->exchange_address,
 	       fcport->d_id.b24);
 	/* +48    0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
 	 * ----- -----------------------------------------------
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 98a5c105fdfd..9a2f328200ab 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -6459,10 +6459,9 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host =
*vha,
 void
 qla24xx_free_purex_item(struct purex_item *item)
 {
-	if (item =3D=3D &item->vha->default_item) {
+	if (item =3D=3D &item->vha->default_item)
 		memset(&item->vha->default_item, 0, sizeof(struct purex_item));
-		memset(&item->vha->__default_item_iocb, 0, QLA_DEFAULT_PAYLOAD_SIZE);
-	} else
+	else
 		kfree(item);
 }
=20
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_=
core_configfs.c
index 0904ecae253a..b19acd662726 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2774,7 +2774,7 @@ static ssize_t target_lu_gp_members_show(struct confi=
g_item *item, char *page)
 			config_item_name(&dev->dev_group.cg_item));
 		cur_len++; /* Extra byte for NULL terminator */
=20
-		if ((cur_len + len) > PAGE_SIZE) {
+		if ((cur_len + len) > PAGE_SIZE || cur_len > LU_GROUP_NAME_BUF) {
 			pr_warn("Ran out of lu_gp_show_attr"
 				"_members buffer\n");
 			break;
diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index 0086816b27cd..c040afc6668e 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -1949,7 +1949,7 @@ static umode_t ufs_sysfs_hid_is_visible(struct kobjec=
t *kobj,
 	return	hba->dev_info.hid_sup ? attr->mode : 0;
 }
=20
-static const struct attribute_group ufs_sysfs_hid_group =3D {
+const struct attribute_group ufs_sysfs_hid_group =3D {
 	.name =3D "hid",
 	.attrs =3D ufs_sysfs_hid,
 	.is_visible =3D ufs_sysfs_hid_is_visible,
diff --git a/drivers/ufs/core/ufs-sysfs.h b/drivers/ufs/core/ufs-sysfs.h
index 8d94af3b8077..6efb82a082fd 100644
--- a/drivers/ufs/core/ufs-sysfs.h
+++ b/drivers/ufs/core/ufs-sysfs.h
@@ -14,5 +14,6 @@ void ufs_sysfs_remove_nodes(struct device *dev);
=20
 extern const struct attribute_group ufs_sysfs_unit_descriptor_group;
 extern const struct attribute_group ufs_sysfs_lun_attributes_group;
+extern const struct attribute_group ufs_sysfs_hid_group;
=20
 #endif
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index b2e103aa4e62..127b691402f9 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6673,6 +6673,14 @@ static void ufshcd_err_handler(struct work_struct *w=
ork)
 	}
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
=20
+	ufshcd_rpm_get_noresume(hba);
+	if (hba->pm_op_in_progress) {
+		ufshcd_link_recovery(hba);
+		ufshcd_rpm_put(hba);
+		return;
+	}
+	ufshcd_rpm_put(hba);
+
 	ufshcd_err_handling_prepare(hba);
=20
 	spin_lock_irqsave(hba->host->host_lock, flags);
@@ -8472,6 +8480,8 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
 				DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP) &
 				UFS_DEV_HID_SUPPORT;
=20
+	sysfs_update_group(&hba->dev->kobj, &ufs_sysfs_hid_group);
+
 	model_index =3D desc_buf[DEVICE_DESC_PARAM_PRDCT_NAME];
=20
 	err =3D ufshcd_read_string_desc(hba, model_index,
@@ -10661,6 +10671,9 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *=
mmio_base, unsigned int irq)
 	 */
 	spin_lock_init(&hba->clk_gating.lock);
=20
+	/* Initialize mutex for PM QoS request synchronization */
+	mutex_init(&hba->pm_qos_mutex);
+
 	/*
 	 * Set the default power management level for runtime and system PM.
 	 * Host controller drivers can override them in their
@@ -10749,9 +10762,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *=
mmio_base, unsigned int irq)
=20
 	mutex_init(&hba->wb_mutex);
=20
-	/* Initialize mutex for PM QoS request synchronization */
-	mutex_init(&hba->pm_qos_mutex);
-
 	init_rwsem(&hba->clk_scaling_lock);
=20
 	ufshcd_init_clk_gating(hba);
diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
index 612500a7088f..e64b70132101 100644
--- a/include/ufs/ufshci.h
+++ b/include/ufs/ufshci.h
@@ -180,6 +180,7 @@ static inline u32 ufshci_version(u32 major, u32 minor)
 #define UTP_TASK_REQ_COMPL			0x200
 #define UIC_COMMAND_COMPL			0x400
 #define DEVICE_FATAL_ERROR			0x800
+#define UTP_ERROR				0x1000
 #define CONTROLLER_FATAL_ERROR			0x10000
 #define SYSTEM_BUS_FATAL_ERROR			0x20000
 #define CRYPTO_ENGINE_FATAL_ERROR		0x40000
@@ -199,7 +200,8 @@ static inline u32 ufshci_version(u32 major, u32 minor)
 				CONTROLLER_FATAL_ERROR |\
 				SYSTEM_BUS_FATAL_ERROR |\
 				CRYPTO_ENGINE_FATAL_ERROR |\
-				UIC_LINK_LOST)
+				UIC_LINK_LOST |\
+				UTP_ERROR)
=20
 /* HCS - Host Controller Status 30h */
 #define DEVICE_PRESENT				0x1

