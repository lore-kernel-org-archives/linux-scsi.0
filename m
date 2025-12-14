Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0FD2E0938;
	Sun, 14 Dec 2025 01:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765675774; cv=none; b=RDaDJ/Q/JhsmKYJNC/ADm2RUYy/i5ZhRAxn4yv9uSrzgoerBY8rw9mg5hfSv0LITrBi9E9X+FmTEjugcLB/l0gzzt2G1Zqvihl15TLdaH0T9YcUbbwlFbe9ZcJunUbpxmt+En3xAQ+1/or6pQ8WjSblQo1OpBYW/wTWiNY0ye2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765675774; c=relaxed/simple;
	bh=/wYc4x6uiRERDmtIo7Y2nZXGTsALa0Q5rHQSLjrYsYo=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=aae6qujHJuGaYSHvpx4lW50bC8WQJBWI6w8e8JOiQu1iR+iO7ZqRUD8I4bcVvhs7ukdz2aPs0+ISzOwBB+GxBTVNJmEje06xL+iTMPQxQezCMhzJbCq2wYumqHLoQ0dM+X6XkSvkAWVdAPvXKtAWFGwjDFgGK2LLB1MzNd53HQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=hNGAODyD; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="hNGAODyD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1765675769;
	bh=/wYc4x6uiRERDmtIo7Y2nZXGTsALa0Q5rHQSLjrYsYo=;
	h=Message-ID:Subject:From:To:Date:From;
	b=hNGAODyD35KzkLcFvbjo1CdGYIiMz9x+nMeygi+Qole4IfGVclQ5LEqZDUBDXDKKi
	 bm3L2kd7ULzzSNMdBOeGTqdqI+cDVgdrOFpnAKnNvxbKZypeO0YyE5GBzBGH9FI79+
	 Sj94DPQIccto41LtXeXdJrylCfdk66U7gTw7z4gQ=
Received: from [172.20.4.117] (122x212x32x58.ap122.ftth.ucom.ne.jp [122.212.32.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id D9BDB1C01E4;
	Sat, 13 Dec 2025 20:29:28 -0500 (EST)
Message-ID: <e482ef9ce85d30aa038a80cf95bcbcf9f7b288c5.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for the 6.18+ merge window
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Sun, 14 Dec 2025 10:29:26 +0900
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

The only core fix is in doc; all the others are in drivers, with the
biggest impacts in libsas being the rollback on error handling and in
ufs coming from a couple of error handling fixes, one causing a crash
if it's activated before scanning and the other fixing W-LUN
resumption.=20

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Andrey Vatoropin (1):
      scsi: target: Reset t_task_cdb pointer in error case

Bart Van Assche (2):
      scsi: ufs: core: Fix a deadlock in the frequency scaling code
      scsi: ufs: core: Fix an error handler crash

Bean Huo (1):
      scsi: ufs: core: Fix RPMB link error by reversing Kconfig dependencie=
s

Benjamin Marzinski (1):
      scsi: device_handler: Return error pointer in scsi_dh_attached_handle=
r_name()

Brian Kao (1):
      scsi: ufs: core: Fix EH failure after W-LUN resume error

Chaohai Chen (1):
      scsi: libsas: Add rollback handling when an error occurs

Duoming Zhou (1):
      scsi: imm: Fix use-after-free bug caused by unfinished delayed work

Heiko Carstens (1):
      scsi: target: sbp: Remove KMSG_COMPONENT macro

Krzysztof Kozlowski (1):
      scsi: ufs: qcom: Fix confusing cleanup.h syntax

Miao Li (1):
      scsi: core: Correct documentation for scsi_device_quiesce()

Shi Hao (1):
      scsi: qla4xxx: Use time conversion macros

Suganath Prabu S (1):
      scsi: mpi3mr: Prevent duplicate SAS/SATA device entries in channel 1

Wen Xiong (2):
      scsi: qla2xxx: Enable/disable IRQD_NO_BALANCING during reset
      scsi: ipr: Enable/disable IRQD_NO_BALANCING during reset

Xingui Yang (1):
      scsi: Revert "scsi: libsas: Fix exp-attached device scan after probe =
failure scanned in again after probe failed"


And the diffstat:

 drivers/md/dm-mpath.c                  | 13 +++++++
 drivers/misc/Kconfig                   |  1 -
 drivers/scsi/imm.c                     |  1 +
 drivers/scsi/ipr.c                     | 28 +++++++++++++-
 drivers/scsi/libsas/sas_init.c         |  1 +
 drivers/scsi/libsas/sas_internal.h     | 15 +-------
 drivers/scsi/libsas/sas_phy.c          | 33 +++++++++++++++--
 drivers/scsi/mpi3mr/mpi3mr.h           |  4 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c        |  4 +-
 drivers/scsi/qla2xxx/qla_os.c          | 30 +++++++++++++++
 drivers/scsi/qla4xxx/ql4_nx.c          |  2 +-
 drivers/scsi/scsi_dh.c                 |  8 ++--
 drivers/scsi/scsi_lib.c                |  2 +-
 drivers/target/sbp/sbp_target.c        |  3 +-
 drivers/target/target_core_transport.c |  1 +
 drivers/ufs/Kconfig                    |  1 +
 drivers/ufs/core/ufshcd.c              | 68 ++++++++++++++++++++++--------=
----
 drivers/ufs/host/ufs-qcom.c            |  6 +--
 18 files changed, 165 insertions(+), 56 deletions(-)

With full diff below.

Regards,

James

---

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index aaf4a0a4b0eb..1f3989ad2f7d 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -962,6 +962,19 @@ static struct pgpath *parse_path(struct dm_arg_set *as=
, struct path_selector *ps
=20
 	q =3D bdev_get_queue(p->path.dev->bdev);
 	attached_handler_name =3D scsi_dh_attached_handler_name(q, GFP_KERNEL);
+	if (IS_ERR(attached_handler_name)) {
+		if (PTR_ERR(attached_handler_name) =3D=3D -ENODEV) {
+			if (m->hw_handler_name) {
+				DMERR("hardware handlers are only allowed for SCSI devices");
+				kfree(m->hw_handler_name);
+				m->hw_handler_name =3D NULL;
+			}
+			attached_handler_name =3D NULL;
+		} else {
+			r =3D PTR_ERR(attached_handler_name);
+			goto bad;
+		}
+	}
 	if (attached_handler_name || m->hw_handler_name) {
 		INIT_DELAYED_WORK(&p->activate_path, activate_path_work);
 		r =3D setup_scsi_dh(p->path.dev->bdev, m, &attached_handler_name, &ti->e=
rror);
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 9d1de68dee27..d7d41b054b98 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -106,7 +106,6 @@ config PHANTOM
=20
 config RPMB
 	tristate "RPMB partition interface"
-	depends on MMC || SCSI_UFSHCD
 	help
 	  Unified RPMB unit interface for RPMB capable devices such as eMMC and
 	  UFS. Provides interface for in-kernel security controllers to access
diff --git a/drivers/scsi/imm.c b/drivers/scsi/imm.c
index 5c602c057798..45b0e33293a5 100644
--- a/drivers/scsi/imm.c
+++ b/drivers/scsi/imm.c
@@ -1260,6 +1260,7 @@ static void imm_detach(struct parport *pb)
 	imm_struct *dev;
 	list_for_each_entry(dev, &imm_hosts, list) {
 		if (dev->dev->port =3D=3D pb) {
+			disable_delayed_work_sync(&dev->imm_tq);
 			list_del_init(&dev->list);
 			scsi_remove_host(dev->host);
 			scsi_host_put(dev->host);
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 44214884deaf..d62bb7d0e416 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -61,8 +61,8 @@
 #include <linux/hdreg.h>
 #include <linux/reboot.h>
 #include <linux/stringify.h>
+#include <linux/irq.h>
 #include <asm/io.h>
-#include <asm/irq.h>
 #include <asm/processor.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
@@ -7843,6 +7843,30 @@ static int ipr_dump_mailbox_wait(struct ipr_cmnd *ip=
r_cmd)
 	return IPR_RC_JOB_RETURN;
 }
=20
+/**
+ * ipr_set_affinity_nobalance
+ * @ioa_cfg:	ipr_ioa_cfg struct for an ipr device
+ * @flag:	bool
+ *	true: ensable "IRQ_NO_BALANCING" bit for msix interrupt
+ *	false: disable "IRQ_NO_BALANCING" bit for msix interrupt
+ * Description: This function will be called to disable/enable
+ *	"IRQ_NO_BALANCING" to avoid irqbalance daemon
+ *	kicking in during adapter reset.
+ **/
+static void ipr_set_affinity_nobalance(struct ipr_ioa_cfg *ioa_cfg, bool f=
lag)
+{
+	int irq, i;
+
+	for (i =3D 0; i < ioa_cfg->nvectors; i++) {
+		irq =3D pci_irq_vector(ioa_cfg->pdev, i);
+
+		if (flag)
+			irq_set_status_flags(irq, IRQ_NO_BALANCING);
+		else
+			irq_clear_status_flags(irq, IRQ_NO_BALANCING);
+	}
+}
+
 /**
  * ipr_reset_restore_cfg_space - Restore PCI config space.
  * @ipr_cmd:	ipr command struct
@@ -7867,6 +7891,7 @@ static int ipr_reset_restore_cfg_space(struct ipr_cmn=
d *ipr_cmd)
 		return IPR_RC_JOB_CONTINUE;
 	}
=20
+	ipr_set_affinity_nobalance(ioa_cfg, false);
 	ipr_fail_all_ops(ioa_cfg);
=20
 	if (ioa_cfg->sis64) {
@@ -7946,6 +7971,7 @@ static int ipr_reset_start_bist(struct ipr_cmnd *ipr_=
cmd)
 		rc =3D pci_write_config_byte(ioa_cfg->pdev, PCI_BIST, PCI_BIST_START);
=20
 	if (rc =3D=3D PCIBIOS_SUCCESSFUL) {
+		ipr_set_affinity_nobalance(ioa_cfg, true);
 		ipr_cmd->job_step =3D ipr_reset_bist_done;
 		ipr_reset_start_timer(ipr_cmd, IPR_WAIT_FOR_BIST_TIMEOUT);
 		rc =3D IPR_RC_JOB_RETURN;
diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.=
c
index 8566bb1208a0..6b15ad1bcada 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -141,6 +141,7 @@ int sas_register_ha(struct sas_ha_struct *sas_ha)
 Undo_ports:
 	sas_unregister_ports(sas_ha);
 Undo_phys:
+	sas_unregister_phys(sas_ha);
=20
 	return error;
 }
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_i=
nternal.h
index 6706f2be8d27..d104c87f04f5 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -54,6 +54,7 @@ void sas_unregister_dev(struct asd_sas_port *port, struct=
 domain_device *dev);
 void sas_scsi_recover_host(struct Scsi_Host *shost);
=20
 int  sas_register_phys(struct sas_ha_struct *sas_ha);
+void sas_unregister_phys(struct sas_ha_struct *sas_ha);
=20
 struct asd_sas_event *sas_alloc_event(struct asd_sas_phy *phy, gfp_t gfp_f=
lags);
 void sas_free_event(struct asd_sas_event *event);
@@ -145,20 +146,6 @@ static inline void sas_fail_probe(struct domain_device=
 *dev, const char *func, i
 		func, dev->parent ? "exp-attached" :
 		"direct-attached",
 		SAS_ADDR(dev->sas_addr), err);
-
-	/*
-	 * If the device probe failed, the expander phy attached address
-	 * needs to be reset so that the phy will not be treated as flutter
-	 * in the next revalidation
-	 */
-	if (dev->parent && !dev_is_expander(dev->dev_type)) {
-		struct sas_phy *phy =3D dev->phy;
-		struct domain_device *parent =3D dev->parent;
-		struct ex_phy *ex_phy =3D &parent->ex_dev.ex_phy[phy->number];
-
-		memset(ex_phy->attached_sas_addr, 0, SAS_ADDR_SIZE);
-	}
-
 	sas_unregister_dev(dev->port, dev);
 }
=20
diff --git a/drivers/scsi/libsas/sas_phy.c b/drivers/scsi/libsas/sas_phy.c
index 635835c28ecd..58f08dc2c187 100644
--- a/drivers/scsi/libsas/sas_phy.c
+++ b/drivers/scsi/libsas/sas_phy.c
@@ -116,6 +116,7 @@ static void sas_phye_shutdown(struct work_struct *work)
 int sas_register_phys(struct sas_ha_struct *sas_ha)
 {
 	int i;
+	int err;
=20
 	/* Now register the phys. */
 	for (i =3D 0; i < sas_ha->num_phys; i++) {
@@ -132,8 +133,10 @@ int sas_register_phys(struct sas_ha_struct *sas_ha)
 		phy->frame_rcvd_size =3D 0;
=20
 		phy->phy =3D sas_phy_alloc(&sas_ha->shost->shost_gendev, i);
-		if (!phy->phy)
-			return -ENOMEM;
+		if (!phy->phy) {
+			err =3D -ENOMEM;
+			goto rollback;
+		}
=20
 		phy->phy->identify.initiator_port_protocols =3D
 			phy->iproto;
@@ -146,10 +149,34 @@ int sas_register_phys(struct sas_ha_struct *sas_ha)
 		phy->phy->maximum_linkrate =3D SAS_LINK_RATE_UNKNOWN;
 		phy->phy->negotiated_linkrate =3D SAS_LINK_RATE_UNKNOWN;
=20
-		sas_phy_add(phy->phy);
+		err =3D sas_phy_add(phy->phy);
+		if (err) {
+			sas_phy_free(phy->phy);
+			goto rollback;
+		}
 	}
=20
 	return 0;
+rollback:
+	for (i-- ; i >=3D 0 ; i--) {
+		struct asd_sas_phy *phy =3D sas_ha->sas_phy[i];
+
+		sas_phy_delete(phy->phy);
+		sas_phy_free(phy->phy);
+	}
+	return err;
+}
+
+void sas_unregister_phys(struct sas_ha_struct *sas_ha)
+{
+	int i;
+
+	for (i =3D 0 ; i < sas_ha->num_phys ; i++) {
+		struct asd_sas_phy *phy =3D sas_ha->sas_phy[i];
+
+		sas_phy_delete(phy->phy);
+		sas_phy_free(phy->phy);
+	}
 }
=20
 const work_func_t sas_phy_event_fns[PHY_NUM_EVENTS] =3D {
diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 6742684e2990..31d68c151b20 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -56,8 +56,8 @@ extern struct list_head mrioc_list;
 extern int prot_mask;
 extern atomic64_t event_counter;
=20
-#define MPI3MR_DRIVER_VERSION	"8.15.0.5.50"
-#define MPI3MR_DRIVER_RELDATE	"12-August-2025"
+#define MPI3MR_DRIVER_VERSION	"8.15.0.5.51"
+#define MPI3MR_DRIVER_RELDATE	"18-November-2025"
=20
 #define MPI3MR_DRIVER_NAME	"mpi3mr"
 #define MPI3MR_DRIVER_LICENSE	"GPL"
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_o=
s.c
index b88633e1efe2..d4ca878d0886 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -1184,6 +1184,8 @@ static void mpi3mr_update_tgtdev(struct mpi3mr_ioc *m=
rioc,
 	if (is_added =3D=3D true)
 		tgtdev->io_throttle_enabled =3D
 		    (flags & MPI3_DEVICE0_FLAGS_IO_THROTTLING_REQUIRED) ? 1 : 0;
+	if (!mrioc->sas_transport_enabled)
+		tgtdev->non_stl =3D 1;
=20
 	switch (flags & MPI3_DEVICE0_FLAGS_MAX_WRITE_SAME_MASK) {
 	case MPI3_DEVICE0_FLAGS_MAX_WRITE_SAME_256_LB:
@@ -4844,7 +4846,7 @@ static int mpi3mr_target_alloc(struct scsi_target *st=
arget)
 	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
 	if (starget->channel =3D=3D mrioc->scsi_device_channel) {
 		tgt_dev =3D __mpi3mr_get_tgtdev_by_perst_id(mrioc, starget->id);
-		if (tgt_dev && !tgt_dev->is_hidden) {
+		if (tgt_dev && !tgt_dev->is_hidden && tgt_dev->non_stl) {
 			scsi_tgt_priv_data->starget =3D starget;
 			scsi_tgt_priv_data->dev_handle =3D tgt_dev->dev_handle;
 			scsi_tgt_priv_data->perst_id =3D tgt_dev->perst_id;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 89ef7a2dc46c..3f937cb9fb08 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -17,6 +17,7 @@
 #include <linux/crash_dump.h>
 #include <linux/trace_events.h>
 #include <linux/trace.h>
+#include <linux/irq.h>
=20
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsicam.h>
@@ -7776,6 +7777,31 @@ static void qla_pci_error_cleanup(scsi_qla_host_t *v=
ha)
 }
=20
=20
+/**
+ * qla2xxx_set_affinity_nobalance
+ * @pdev: pci_dev struct for a qla2xxx device
+ * @flag: bool
+ * true: enable "IRQ_NO_BALANCING" bit for msix interrupt
+ * false: disable "IRQ_NO_BALANCING" bit for msix interrupt
+ * Description: This function will be called to disable/enable
+ * "IRQ_NO_BALANCING" to avoid irqbalance daemon
+ * kicking in during adapter reset.
+ **/
+
+static void qla2xxx_set_affinity_nobalance(struct pci_dev *pdev, bool flag=
)
+{
+	int irq, i;
+
+	for (i =3D 0; i < QLA_BASE_VECTORS; i++) {
+		irq =3D pci_irq_vector(pdev, i);
+
+		if (flag)
+			irq_set_status_flags(irq, IRQ_NO_BALANCING);
+		else
+			irq_clear_status_flags(irq, IRQ_NO_BALANCING);
+	}
+}
+
 static pci_ers_result_t
 qla2xxx_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t state=
)
 {
@@ -7794,6 +7820,8 @@ qla2xxx_pci_error_detected(struct pci_dev *pdev, pci_=
channel_state_t state)
 		goto out;
 	}
=20
+	qla2xxx_set_affinity_nobalance(pdev, false);
+
 	switch (state) {
 	case pci_channel_io_normal:
 		qla_pci_set_eeh_busy(vha);
@@ -7935,6 +7963,8 @@ qla2xxx_pci_slot_reset(struct pci_dev *pdev)
 	ql_dbg(ql_dbg_aer, base_vha, 0x900e,
 	    "Slot Reset returning %x.\n", ret);
=20
+	qla2xxx_set_affinity_nobalance(pdev, true);
+
 	return ret;
 }
=20
diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index da2fc66ffedd..b0a62aaa1cca 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -1552,7 +1552,7 @@ static int qla4_82xx_cmdpeg_ready(struct scsi_qla_hos=
t *ha, int pegtune_val)
 			    (val =3D=3D PHAN_INITIALIZE_ACK))
 				return 0;
 			set_current_state(TASK_UNINTERRUPTIBLE);
-			schedule_timeout(500);
+			schedule_timeout(msecs_to_jiffies(500));
=20
 		} while (--retries);
=20
diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
index 7b56e00c7df6..b9d805317814 100644
--- a/drivers/scsi/scsi_dh.c
+++ b/drivers/scsi/scsi_dh.c
@@ -353,7 +353,8 @@ EXPORT_SYMBOL_GPL(scsi_dh_attach);
  *      that may have a device handler attached
  * @gfp - the GFP mask used in the kmalloc() call when allocating memory
  *
- * Returns name of attached handler, NULL if no handler is attached.
+ * Returns name of attached handler, NULL if no handler is attached, or
+ * and error pointer if an error occurred.
  * Caller must take care to free the returned string.
  */
 const char *scsi_dh_attached_handler_name(struct request_queue *q, gfp_t g=
fp)
@@ -363,10 +364,11 @@ const char *scsi_dh_attached_handler_name(struct requ=
est_queue *q, gfp_t gfp)
=20
 	sdev =3D scsi_device_from_queue(q);
 	if (!sdev)
-		return NULL;
+		return ERR_PTR(-ENODEV);
=20
 	if (sdev->handler)
-		handler_name =3D kstrdup(sdev->handler->name, gfp);
+		handler_name =3D kstrdup(sdev->handler->name, gfp) ? :
+			       ERR_PTR(-ENOMEM);
 	put_device(&sdev->sdev_gendev);
 	return handler_name;
 }
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 51ad2ad07e43..93031326ac3e 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2801,7 +2801,7 @@ EXPORT_SYMBOL_GPL(sdev_evt_send_simple);
  *
  *	Must be called with user context, may sleep.
  *
- *	Returns zero if unsuccessful or an error if not.
+ *	Returns zero if successful or an error if not.
  */
 int
 scsi_device_quiesce(struct scsi_device *sdev)
diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_targe=
t.c
index b8457477cee9..9f167ff8da7b 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -5,8 +5,7 @@
  * Copyright (C) 2011  Chris Boot <bootc@bootc.net>
  */
=20
-#define KMSG_COMPONENT "sbp_target"
-#define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
+#define pr_fmt(fmt) "sbp_target: " fmt
=20
 #include <linux/kernel.h>
 #include <linux/module.h>
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target=
_core_transport.c
index e8b7955d40f2..50d21888a0c9 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1524,6 +1524,7 @@ target_cmd_init_cdb(struct se_cmd *cmd, unsigned char=
 *cdb, gfp_t gfp)
 	if (scsi_command_size(cdb) > sizeof(cmd->__t_task_cdb)) {
 		cmd->t_task_cdb =3D kzalloc(scsi_command_size(cdb), gfp);
 		if (!cmd->t_task_cdb) {
+			cmd->t_task_cdb =3D &cmd->__t_task_cdb[0];
 			pr_err("Unable to allocate cmd->t_task_cdb"
 				" %u > sizeof(cmd->__t_task_cdb): %lu ops\n",
 				scsi_command_size(cdb),
diff --git a/drivers/ufs/Kconfig b/drivers/ufs/Kconfig
index 90226f72c158..f662e7ce71f1 100644
--- a/drivers/ufs/Kconfig
+++ b/drivers/ufs/Kconfig
@@ -6,6 +6,7 @@
 menuconfig SCSI_UFSHCD
 	tristate "Universal Flash Storage Controller"
 	depends on SCSI && SCSI_DMA
+	depends on RPMB || !RPMB
 	select PM_DEVFREQ
 	select DEVFREQ_GOV_SIMPLE_ONDEMAND
 	select NLS
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 040a0ceb170a..80c0b49f30b0 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1455,15 +1455,14 @@ static int ufshcd_clock_scaling_prepare(struct ufs_=
hba *hba, u64 timeout_us)
 static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, int err)
 {
 	up_write(&hba->clk_scaling_lock);
+	mutex_unlock(&hba->wb_mutex);
+	blk_mq_unquiesce_tagset(&hba->host->tag_set);
+	mutex_unlock(&hba->host->scan_mutex);
=20
 	/* Enable Write Booster if current gear requires it else disable it */
 	if (ufshcd_enable_wb_if_scaling_up(hba) && !err)
 		ufshcd_wb_toggle(hba, hba->pwr_info.gear_rx >=3D hba->clk_scaling.wb_gea=
r);
=20
-	mutex_unlock(&hba->wb_mutex);
-
-	blk_mq_unquiesce_tagset(&hba->host->tag_set);
-	mutex_unlock(&hba->host->scan_mutex);
 	ufshcd_release(hba);
 }
=20
@@ -6504,6 +6503,11 @@ static void ufshcd_clk_scaling_suspend(struct ufs_hb=
a *hba, bool suspend)
=20
 static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
 {
+	/*
+	 * A WLUN resume failure could potentially lead to the HBA being
+	 * runtime suspended, so take an extra reference on hba->dev.
+	 */
+	pm_runtime_get_sync(hba->dev);
 	ufshcd_rpm_get_sync(hba);
 	if (pm_runtime_status_suspended(&hba->ufs_device_wlun->sdev_gendev) ||
 	    hba->is_sys_suspended) {
@@ -6543,6 +6547,7 @@ static void ufshcd_err_handling_unprepare(struct ufs_=
hba *hba)
 	if (ufshcd_is_clkscaling_supported(hba))
 		ufshcd_clk_scaling_suspend(hba, false);
 	ufshcd_rpm_put(hba);
+	pm_runtime_put(hba->dev);
 }
=20
 static inline bool ufshcd_err_handling_should_stop(struct ufs_hba *hba)
@@ -6557,28 +6562,42 @@ static inline bool ufshcd_err_handling_should_stop(=
struct ufs_hba *hba)
 #ifdef CONFIG_PM
 static void ufshcd_recover_pm_error(struct ufs_hba *hba)
 {
+	struct scsi_target *starget =3D hba->ufs_device_wlun->sdev_target;
 	struct Scsi_Host *shost =3D hba->host;
 	struct scsi_device *sdev;
 	struct request_queue *q;
-	int ret;
+	bool resume_sdev_queues =3D false;
=20
 	hba->is_sys_suspended =3D false;
+
 	/*
-	 * Set RPM status of wlun device to RPM_ACTIVE,
-	 * this also clears its runtime error.
+	 * Ensure the parent's error status is cleared before proceeding
+	 * to the child, as the parent must be active to activate the child.
 	 */
-	ret =3D pm_runtime_set_active(&hba->ufs_device_wlun->sdev_gendev);
+	if (hba->dev->power.runtime_error) {
+		/* hba->dev has no functional parent thus simplily set RPM_ACTIVE */
+		pm_runtime_set_active(hba->dev);
+		resume_sdev_queues =3D true;
+	}
+
+	if (hba->ufs_device_wlun->sdev_gendev.power.runtime_error) {
+		/*
+		 * starget, parent of wlun, might be suspended if wlun resume failed.
+		 * Make sure parent is resumed before set child (wlun) active.
+		 */
+		pm_runtime_get_sync(&starget->dev);
+		pm_runtime_set_active(&hba->ufs_device_wlun->sdev_gendev);
+		pm_runtime_put_sync(&starget->dev);
+		resume_sdev_queues =3D true;
+	}
=20
-	/* hba device might have a runtime error otherwise */
-	if (ret)
-		ret =3D pm_runtime_set_active(hba->dev);
 	/*
 	 * If wlun device had runtime error, we also need to resume those
 	 * consumer scsi devices in case any of them has failed to be
 	 * resumed due to supplier runtime resume failure. This is to unblock
 	 * blk_queue_enter in case there are bios waiting inside it.
 	 */
-	if (!ret) {
+	if (resume_sdev_queues) {
 		shost_for_each_device(sdev, shost) {
 			q =3D sdev->request_queue;
 			if (q->dev && (q->rpm_status =3D=3D RPM_SUSPENDED ||
@@ -6679,19 +6698,22 @@ static void ufshcd_err_handler(struct work_struct *=
work)
 		 hba->saved_uic_err, hba->force_reset,
 		 ufshcd_is_link_broken(hba) ? "; link is broken" : "");
=20
-	/*
-	 * Use ufshcd_rpm_get_noresume() here to safely perform link recovery
-	 * even if an error occurs during runtime suspend or runtime resume.
-	 * This avoids potential deadlocks that could happen if we tried to
-	 * resume the device while a PM operation is already in progress.
-	 */
-	ufshcd_rpm_get_noresume(hba);
-	if (hba->pm_op_in_progress) {
-		ufshcd_link_recovery(hba);
+	if (hba->ufs_device_wlun) {
+		/*
+		 * Use ufshcd_rpm_get_noresume() here to safely perform link
+		 * recovery even if an error occurs during runtime suspend or
+		 * runtime resume. This avoids potential deadlocks that could
+		 * happen if we tried to resume the device while a PM operation
+		 * is already in progress.
+		 */
+		ufshcd_rpm_get_noresume(hba);
+		if (hba->pm_op_in_progress) {
+			ufshcd_link_recovery(hba);
+			ufshcd_rpm_put(hba);
+			return;
+		}
 		ufshcd_rpm_put(hba);
-		return;
 	}
-	ufshcd_rpm_put(hba);
=20
 	down(&hba->host_sem);
 	spin_lock_irqsave(hba->host->host_lock, flags);
diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 8d119b3223cb..8ebee0cc5313 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -1769,10 +1769,9 @@ static void ufs_qcom_dump_testbus(struct ufs_hba *hb=
a)
 {
 	struct ufs_qcom_host *host =3D ufshcd_get_variant(hba);
 	int i, j, nminor =3D 0, testbus_len =3D 0;
-	u32 *testbus __free(kfree) =3D NULL;
 	char *prefix;
=20
-	testbus =3D kmalloc_array(256, sizeof(u32), GFP_KERNEL);
+	u32 *testbus __free(kfree) =3D kmalloc_array(256, sizeof(u32), GFP_KERNEL=
);
 	if (!testbus)
 		return;
=20
@@ -1794,13 +1793,12 @@ static void ufs_qcom_dump_testbus(struct ufs_hba *h=
ba)
 static int ufs_qcom_dump_regs(struct ufs_hba *hba, size_t offset, size_t l=
en,
 			      const char *prefix, void __iomem *base)
 {
-	u32 *regs __free(kfree) =3D NULL;
 	size_t pos;
=20
 	if (offset % 4 !=3D 0 || len % 4 !=3D 0)
 		return -EINVAL;
=20
-	regs =3D kzalloc(len, GFP_ATOMIC);
+	u32 *regs __free(kfree) =3D kzalloc(len, GFP_ATOMIC);
 	if (!regs)
 		return -ENOMEM;
=20

