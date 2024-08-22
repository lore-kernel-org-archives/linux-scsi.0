Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03011D12E6
	for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2024 20:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724356916; cv=none; b=NZcbcisz5U7YONWdH82XHWK68rrVQjR5DrSBuTglPW0wAqZ2gC/MpgxNYI6eo/kXYpvIX/CTJ3aa4ReNX4Vrhs7Ps4KVZ9QOKWOKXh0W6pGobdBVnbsmPCpJ6GGfeOnnjyNo8CiPtsgA+NOp449VulHsRvLkWDyEFqfykA14ZDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724356916; c=relaxed/simple;
	bh=ATyMHTFR2N3O/TdXge7TDZCvZasUJcFUiR1WzB28Z9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CNLHGKjbl8I1Hcaz1I3s+cSpsLaee4KaQ43t7KkS9q0I2uG4gzSlPFW5kaEzzsI6C5bbQmp/mMfedUKr9LymbB4smci7Y5eTgO8LcZRuxNjtqfYKc0+mqZ+NAxGpABnJYT1YZ8+7/yY4tQfAOzFI0eFOwSJ5sf92/b6+N1xWA1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=EBynBucB; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="EBynBucB"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WqYxt28KYz6ClY9K;
	Thu, 22 Aug 2024 20:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1724356811; x=1726948812; bh=t6+mT
	XgSJArZjtGyRRwduSZx2pgF7+ybbuplsedCg4c=; b=EBynBucBAValQL0sln56Z
	TZEH4HL7gcvtWZ6SuqmkPpxR6O9zGfmd4AWdDHI+SoBCWq4R1NjAdoWZiKPwY7F5
	RPQlC/jffXfCa4NihONMLwQ5EpHMaIkl6BVznRFV7is4qWZ6JH+WSY8ljT2AhvZ0
	SIFW1aH2m2VBL4w3PlzBM2bvEkzMUjp7df+R0FG6BXvIvkwnIUK9ZEVY09G6vsgp
	aXhORcOk9HEUbbfbsFmdHFzSHUp8ZQE/nCLBJJVQtN76OEJuZqSZMWs9BTnPdpuT
	J2WvQO9VNxFy4dp7npJr/KKGIGVroDjC+//sNBFXLQu/x9PEzN1gbIzMBPyguUeF
	w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id kG8750Hr_rBW; Thu, 22 Aug 2024 20:00:11 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WqYvq1Lwcz6ClY9J;
	Thu, 22 Aug 2024 20:00:07 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
	Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Saurav Kashyap <skashyap@marvell.com>,
	Javed Hasan <jhasan@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	James Smart <james.smart@broadcom.com>,
	Ram Vegesna <ram.vegesna@broadcom.com>,
	Bradley Grove <linuxdrivers@attotech.com>,
	Hannes Reinecke <hare@suse.de>,
	Satish Kharat <satishkh@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	Xiang Chen <chenxiang66@hisilicon.com>,
	Tyrel Datwyler <tyreld@linux.ibm.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	Vishal Bhakta <vishal.bhakta@broadcom.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Mike Christie <michael.christie@oracle.com>,
	Martin Wilck <mwilck@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v3 01/18] scsi: Expand all create*_workqueue() invocations
Date: Thu, 22 Aug 2024 12:59:05 -0700
Message-ID: <20240822195944.654691-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
In-Reply-To: <20240822195944.654691-1-bvanassche@acm.org>
References: <20240822195944.654691-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

The workqueue maintainer wants to remove the create*_workqueue() macros
because these macros always set the WQ_MEM_RECLAIM flag and because these
only support literal workqueue names. Hence this patch that replaces the
create*_workqueue() invocations with the definition of this macro. The
WQ_MEM_RECLAIM flag has been retained because I think that flag is necess=
ary
for workqueues created by storage drivers. This patch has been generated =
by
running spatch and git clang-format. spatch has been invoked as follows:

spatch --in-place --sp-file expand-create-workqueue.spatch $(git grep -lE=
w 'create_(freezable_|singlethread_|)workqueue' */scsi */ufs)

The contents of the expand-create-workqueue.spatch file is as follows:

@@
expression name;
@@
-create_workqueue(name)
+alloc_workqueue("%s", WQ_MEM_RECLAIM, 1, name)
@@
expression name;
@@
-create_freezable_workqueue(name)
+alloc_workqueue("%s", WQ_FREEZABLE | WQ_UNBOUND | WQ_MEM_RECLAIM, 1, nam=
e)
@@
expression name;
@@
-create_singlethread_workqueue(name)
+alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM, name)

Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/bfa/bfad_im.c                  |  3 ++-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c           |  4 ++--
 drivers/scsi/device_handler/scsi_dh_rdac.c  |  3 ++-
 drivers/scsi/elx/efct/efct_lio.c            |  3 ++-
 drivers/scsi/esas2r/esas2r_init.c           |  3 ++-
 drivers/scsi/fcoe/fcoe_sysfs.c              |  8 ++++----
 drivers/scsi/fnic/fnic_main.c               |  6 ++++--
 drivers/scsi/hisi_sas/hisi_sas_main.c       |  3 ++-
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c    |  2 +-
 drivers/scsi/libfc/fc_exch.c                |  3 ++-
 drivers/scsi/libfc/fc_rport.c               |  3 ++-
 drivers/scsi/libsas/sas_init.c              |  4 ++--
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  4 ++--
 drivers/scsi/mpi3mr/mpi3mr_fw.c             |  4 ++--
 drivers/scsi/mpt3sas/mpt3sas_base.c         |  4 ++--
 drivers/scsi/myrb.c                         |  3 ++-
 drivers/scsi/myrs.c                         |  3 ++-
 drivers/scsi/qedf/qedf_main.c               | 13 +++++++------
 drivers/scsi/qedi/qedi_main.c               |  6 ++++--
 drivers/scsi/qla2xxx/qla_os.c               |  6 ++++--
 drivers/scsi/qla4xxx/ql4_os.c               |  2 +-
 drivers/scsi/snic/snic_main.c               |  6 ++++--
 drivers/scsi/stex.c                         |  3 ++-
 drivers/scsi/vmw_pvscsi.c                   |  3 ++-
 drivers/ufs/core/ufshcd.c                   |  5 +++--
 25 files changed, 64 insertions(+), 43 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index a9d3d8562d3c..a1d015356063 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -768,7 +768,8 @@ bfad_thread_workq(struct bfad_s *bfad)
 	bfa_trc(bfad, 0);
 	snprintf(im->drv_workq_name, KOBJ_NAME_LEN, "bfad_wq_%d",
 		 bfad->inst_no);
-	im->drv_workq =3D create_singlethread_workqueue(im->drv_workq_name);
+	im->drv_workq =3D alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM,
+						im->drv_workq_name);
 	if (!im->drv_workq)
 		return BFA_STATUS_FAILED;
=20
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2=
fc_fcoe.c
index 1078c20c5ef6..f49783b89d04 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -2363,8 +2363,8 @@ static int _bnx2fc_create(struct net_device *netdev=
,
 	interface->vlan_id =3D vlan_id;
 	interface->tm_timeout =3D BNX2FC_TM_TIMEOUT;
=20
-	interface->timer_work_queue =3D
-			create_singlethread_workqueue("bnx2fc_timer_wq");
+	interface->timer_work_queue =3D alloc_ordered_workqueue(
+		"%s", WQ_MEM_RECLAIM, "bnx2fc_timer_wq");
 	if (!interface->timer_work_queue) {
 		printk(KERN_ERR PFX "ulp_init could not create timer_wq\n");
 		rc =3D -EINVAL;
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/de=
vice_handler/scsi_dh_rdac.c
index f8a09e3eba58..6e1b252cea0e 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -822,7 +822,8 @@ static int __init rdac_init(void)
 	/*
 	 * Create workqueue to handle mode selects for rdac
 	 */
-	kmpath_rdacd =3D create_singlethread_workqueue("kmpath_rdacd");
+	kmpath_rdacd =3D
+		alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM, "kmpath_rdacd");
 	if (!kmpath_rdacd) {
 		scsi_unregister_device_handler(&rdac_dh);
 		printk(KERN_ERR "kmpath_rdacd creation failed.\n");
diff --git a/drivers/scsi/elx/efct/efct_lio.c b/drivers/scsi/elx/efct/efc=
t_lio.c
index 6a6ec32c46bd..9ac69356b13e 100644
--- a/drivers/scsi/elx/efct/efct_lio.c
+++ b/drivers/scsi/elx/efct/efct_lio.c
@@ -1114,7 +1114,8 @@ int efct_scsi_tgt_new_device(struct efct *efct)
 	atomic_set(&efct->tgt_efct.watermark_hit, 0);
 	atomic_set(&efct->tgt_efct.initiator_count, 0);
=20
-	lio_wq =3D create_singlethread_workqueue("efct_lio_worker");
+	lio_wq =3D alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM,
+					 "efct_lio_worker");
 	if (!lio_wq) {
 		efc_log_err(efct, "workqueue create failed\n");
 		return -EIO;
diff --git a/drivers/scsi/esas2r/esas2r_init.c b/drivers/scsi/esas2r/esas=
2r_init.c
index c1a5ab662dc8..ff1fa3160c61 100644
--- a/drivers/scsi/esas2r/esas2r_init.c
+++ b/drivers/scsi/esas2r/esas2r_init.c
@@ -313,7 +313,8 @@ int esas2r_init_adapter(struct Scsi_Host *host, struc=
t pci_dev *pcid,
 	esas2r_fw_event_off(a);
 	snprintf(a->fw_event_q_name, ESAS2R_KOBJ_NAME_LEN, "esas2r/%d",
 		 a->index);
-	a->fw_event_q =3D create_singlethread_workqueue(a->fw_event_q_name);
+	a->fw_event_q =3D alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM,
+						a->fw_event_q_name);
=20
 	init_waitqueue_head(&a->buffered_ioctl_waiter);
 	init_waitqueue_head(&a->nvram_waiter);
diff --git a/drivers/scsi/fcoe/fcoe_sysfs.c b/drivers/scsi/fcoe/fcoe_sysf=
s.c
index 7d3b904af9e8..06357bbf6b2c 100644
--- a/drivers/scsi/fcoe/fcoe_sysfs.c
+++ b/drivers/scsi/fcoe/fcoe_sysfs.c
@@ -799,16 +799,16 @@ struct fcoe_ctlr_device *fcoe_ctlr_device_add(struc=
t device *parent,
=20
 	snprintf(ctlr->work_q_name, sizeof(ctlr->work_q_name),
 		 "ctlr_wq_%d", ctlr->id);
-	ctlr->work_q =3D create_singlethread_workqueue(
-		ctlr->work_q_name);
+	ctlr->work_q =3D alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM,
+					       ctlr->work_q_name);
 	if (!ctlr->work_q)
 		goto out_del;
=20
 	snprintf(ctlr->devloss_work_q_name,
 		 sizeof(ctlr->devloss_work_q_name),
 		 "ctlr_dl_wq_%d", ctlr->id);
-	ctlr->devloss_work_q =3D create_singlethread_workqueue(
-		ctlr->devloss_work_q_name);
+	ctlr->devloss_work_q =3D alloc_ordered_workqueue(
+		"%s", WQ_MEM_RECLAIM, ctlr->devloss_work_q_name);
 	if (!ctlr->devloss_work_q)
 		goto out_del_q;
=20
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.=
c
index 29eead383eb9..0044717d4486 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -1161,14 +1161,16 @@ static int __init fnic_init_module(void)
 		goto err_create_fnic_ioreq_slab;
 	}
=20
-	fnic_event_queue =3D create_singlethread_workqueue("fnic_event_wq");
+	fnic_event_queue =3D
+		alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM, "fnic_event_wq");
 	if (!fnic_event_queue) {
 		printk(KERN_ERR PFX "fnic work queue create failed\n");
 		err =3D -ENOMEM;
 		goto err_create_fnic_workq;
 	}
=20
-	fnic_fip_queue =3D create_singlethread_workqueue("fnic_fip_q");
+	fnic_fip_queue =3D
+		alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM, "fnic_fip_q");
 	if (!fnic_fip_queue) {
 		printk(KERN_ERR PFX "fnic FIP work queue create failed\n");
 		err =3D -ENOMEM;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sa=
s/hisi_sas_main.c
index ec1a3e7ee94d..6219807ce3b9 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -2302,7 +2302,8 @@ int hisi_sas_alloc(struct hisi_hba *hisi_hba)
=20
 	hisi_hba->last_slot_index =3D 0;
=20
-	hisi_hba->wq =3D create_singlethread_workqueue(dev_name(dev));
+	hisi_hba->wq =3D
+		alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM, dev_name(dev));
 	if (!hisi_hba->wq) {
 		dev_err(dev, "sas_alloc: failed to create workqueue\n");
 		goto err_out;
diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmv=
scsi_tgt/ibmvscsi_tgt.c
index 2fca17cf8b51..639f72f28911 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -3537,7 +3537,7 @@ static int ibmvscsis_probe(struct vio_dev *vdev,
 	init_completion(&vscsi->unconfig);
=20
 	snprintf(wq_name, 24, "ibmvscsis%s", dev_name(&vdev->dev));
-	vscsi->work_q =3D create_workqueue(wq_name);
+	vscsi->work_q =3D alloc_workqueue("%s", WQ_MEM_RECLAIM, 1, wq_name);
 	if (!vscsi->work_q) {
 		rc =3D -ENOMEM;
 		dev_err(&vscsi->dev, "create_workqueue failed\n");
diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 1d91c457527f..f84a7e6ae379 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -2693,7 +2693,8 @@ int fc_setup_exch_mgr(void)
 	fc_cpu_order =3D ilog2(roundup_pow_of_two(nr_cpu_ids));
 	fc_cpu_mask =3D (1 << fc_cpu_order) - 1;
=20
-	fc_exch_workqueue =3D create_singlethread_workqueue("fc_exch_workqueue"=
);
+	fc_exch_workqueue =3D alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM,
+						    "fc_exch_workqueue");
 	if (!fc_exch_workqueue)
 		goto err;
 	return 0;
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.=
c
index 33da3c1085f0..308cb4872f96 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -2263,7 +2263,8 @@ struct fc4_prov fc_rport_t0_prov =3D {
  */
 int fc_setup_rport(void)
 {
-	rport_event_queue =3D create_singlethread_workqueue("fc_rport_eq");
+	rport_event_queue =3D
+		alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM, "fc_rport_eq");
 	if (!rport_event_queue)
 		return -ENOMEM;
 	return 0;
diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_ini=
t.c
index 9c8cc723170d..8566bb1208a0 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -122,12 +122,12 @@ int sas_register_ha(struct sas_ha_struct *sas_ha)
=20
 	error =3D -ENOMEM;
 	snprintf(name, sizeof(name), "%s_event_q", dev_name(sas_ha->dev));
-	sas_ha->event_q =3D create_singlethread_workqueue(name);
+	sas_ha->event_q =3D alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM, name)=
;
 	if (!sas_ha->event_q)
 		goto Undo_ports;
=20
 	snprintf(name, sizeof(name), "%s_disco_q", dev_name(sas_ha->dev));
-	sas_ha->disco_q =3D create_singlethread_workqueue(name);
+	sas_ha->disco_q =3D alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM, name)=
;
 	if (!sas_ha->disco_q)
 		goto Undo_event_q;
=20
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/m=
egaraid/megaraid_sas_fusion.c
index 6c1fb8149553..1eec23da28e2 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1988,8 +1988,8 @@ megasas_fusion_start_watchdog(struct megasas_instan=
ce *instance)
 		 sizeof(instance->fault_handler_work_q_name),
 		 "poll_megasas%d_status", instance->host->host_no);
=20
-	instance->fw_fault_work_q =3D
-		create_singlethread_workqueue(instance->fault_handler_work_q_name);
+	instance->fw_fault_work_q =3D alloc_ordered_workqueue(
+		"%s", WQ_MEM_RECLAIM, instance->fault_handler_work_q_name);
 	if (!instance->fw_fault_work_q) {
 		dev_err(&instance->pdev->dev, "Failed from %s %d\n",
 			__func__, __LINE__);
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr=
_fw.c
index 6eb5bcd8e757..2e1a92d306b2 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -2760,8 +2760,8 @@ void mpi3mr_start_watchdog(struct mpi3mr_ioc *mrioc=
)
 	snprintf(mrioc->watchdog_work_q_name,
 	    sizeof(mrioc->watchdog_work_q_name), "watchdog_%s%d", mrioc->name,
 	    mrioc->id);
-	mrioc->watchdog_work_q =3D
-	    create_singlethread_workqueue(mrioc->watchdog_work_q_name);
+	mrioc->watchdog_work_q =3D alloc_ordered_workqueue(
+		"%s", WQ_MEM_RECLAIM, mrioc->watchdog_work_q_name);
 	if (!mrioc->watchdog_work_q) {
 		ioc_err(mrioc, "%s: failed (line=3D%d)\n", __func__, __LINE__);
 		return;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/m=
pt3sas_base.c
index b2bcf4a27ddc..2d3eeda5a6a0 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -846,8 +846,8 @@ mpt3sas_base_start_watchdog(struct MPT3SAS_ADAPTER *i=
oc)
 	snprintf(ioc->fault_reset_work_q_name,
 	    sizeof(ioc->fault_reset_work_q_name), "poll_%s%d_status",
 	    ioc->driver_name, ioc->id);
-	ioc->fault_reset_work_q =3D
-		create_singlethread_workqueue(ioc->fault_reset_work_q_name);
+	ioc->fault_reset_work_q =3D alloc_ordered_workqueue(
+		"%s", WQ_MEM_RECLAIM, ioc->fault_reset_work_q_name);
 	if (!ioc->fault_reset_work_q) {
 		ioc_err(ioc, "%s: failed (line=3D%d)\n", __func__, __LINE__);
 		return;
diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index f684eb5e0489..140dc0e9cead 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -114,7 +114,8 @@ static bool myrb_create_mempools(struct pci_dev *pdev=
, struct myrb_hba *cb)
=20
 	snprintf(cb->work_q_name, sizeof(cb->work_q_name),
 		 "myrb_wq_%d", cb->host->host_no);
-	cb->work_q =3D create_singlethread_workqueue(cb->work_q_name);
+	cb->work_q =3D
+		alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM, cb->work_q_name);
 	if (!cb->work_q) {
 		dma_pool_destroy(cb->dcdb_pool);
 		cb->dcdb_pool =3D NULL;
diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index e824be9d9bbb..8a8f26633cda 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -2208,7 +2208,8 @@ static bool myrs_create_mempools(struct pci_dev *pd=
ev, struct myrs_hba *cs)
=20
 	snprintf(cs->work_q_name, sizeof(cs->work_q_name),
 		 "myrs_wq_%d", shost->host_no);
-	cs->work_q =3D create_singlethread_workqueue(cs->work_q_name);
+	cs->work_q =3D
+		alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM, cs->work_q_name);
 	if (!cs->work_q) {
 		dma_pool_destroy(cs->dcdb_pool);
 		cs->dcdb_pool =3D NULL;
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.=
c
index 4813087e58a1..119afcaf6e13 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3374,7 +3374,8 @@ static int __qedf_probe(struct pci_dev *pdev, int m=
ode)
=20
 	sprintf(host_buf, "qedf_%u_link",
 	    qedf->lport->host->host_no);
-	qedf->link_update_wq =3D create_workqueue(host_buf);
+	qedf->link_update_wq =3D
+		alloc_workqueue("%s", WQ_MEM_RECLAIM, 1, host_buf);
 	INIT_DELAYED_WORK(&qedf->link_update, qedf_handle_link_update);
 	INIT_DELAYED_WORK(&qedf->link_recovery, qedf_link_recovery);
 	INIT_DELAYED_WORK(&qedf->grcdump_work, qedf_wq_grcdump);
@@ -3585,8 +3586,7 @@ static int __qedf_probe(struct pci_dev *pdev, int m=
ode)
=20
 	/* Start LL2 processing thread */
 	snprintf(host_buf, 20, "qedf_%d_ll2", host->host_no);
-	qedf->ll2_recv_wq =3D
-		create_workqueue(host_buf);
+	qedf->ll2_recv_wq =3D alloc_workqueue("%s", WQ_MEM_RECLAIM, 1, host_buf=
);
 	if (!qedf->ll2_recv_wq) {
 		QEDF_ERR(&(qedf->dbg_ctx), "Failed to LL2 workqueue.\n");
 		rc =3D -ENOMEM;
@@ -3629,7 +3629,7 @@ static int __qedf_probe(struct pci_dev *pdev, int m=
ode)
=20
 	sprintf(host_buf, "qedf_%u_timer", qedf->lport->host->host_no);
 	qedf->timer_work_queue =3D
-		create_workqueue(host_buf);
+		alloc_workqueue("%s", WQ_MEM_RECLAIM, 1, host_buf);
 	if (!qedf->timer_work_queue) {
 		QEDF_ERR(&(qedf->dbg_ctx), "Failed to start timer "
 			  "workqueue.\n");
@@ -3641,7 +3641,8 @@ static int __qedf_probe(struct pci_dev *pdev, int m=
ode)
 	if (mode !=3D QEDF_MODE_RECOVERY) {
 		sprintf(host_buf, "qedf_%u_dpc",
 		    qedf->lport->host->host_no);
-		qedf->dpc_wq =3D create_workqueue(host_buf);
+		qedf->dpc_wq =3D
+			alloc_workqueue("%s", WQ_MEM_RECLAIM, 1, host_buf);
 	}
 	INIT_DELAYED_WORK(&qedf->recovery_work, qedf_recovery_handler);
=20
@@ -4182,7 +4183,7 @@ static int __init qedf_init(void)
 		goto err3;
 	}
=20
-	qedf_io_wq =3D create_workqueue("qedf_io_wq");
+	qedf_io_wq =3D alloc_workqueue("%s", WQ_MEM_RECLAIM, 1, "qedf_io_wq");
 	if (!qedf_io_wq) {
 		QEDF_ERR(NULL, "Could not create qedf_io_wq.\n");
 		goto err4;
diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.=
c
index cd0180b1f5b9..319c1da549f7 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -2767,7 +2767,8 @@ static int __qedi_probe(struct pci_dev *pdev, int m=
ode)
 		}
=20
 		sprintf(host_buf, "host_%d", qedi->shost->host_no);
-		qedi->tmf_thread =3D create_singlethread_workqueue(host_buf);
+		qedi->tmf_thread =3D
+			alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM, host_buf);
 		if (!qedi->tmf_thread) {
 			QEDI_ERR(&qedi->dbg_ctx,
 				 "Unable to start tmf thread!\n");
@@ -2776,7 +2777,8 @@ static int __qedi_probe(struct pci_dev *pdev, int m=
ode)
 		}
=20
 		sprintf(host_buf, "qedi_ofld%d", qedi->shost->host_no);
-		qedi->offload_thread =3D create_workqueue(host_buf);
+		qedi->offload_thread =3D
+			alloc_workqueue("%s", WQ_MEM_RECLAIM, 1, host_buf);
 		if (!qedi->offload_thread) {
 			QEDI_ERR(&qedi->dbg_ctx,
 				 "Unable to start offload thread!\n");
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
index bc3b2aea3f8b..7f980e6141c2 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3501,11 +3501,13 @@ qla2x00_probe_one(struct pci_dev *pdev, const str=
uct pci_device_id *id)
=20
 	if (IS_QLA8031(ha) || IS_MCTP_CAPABLE(ha)) {
 		sprintf(wq_name, "qla2xxx_%lu_dpc_lp_wq", base_vha->host_no);
-		ha->dpc_lp_wq =3D create_singlethread_workqueue(wq_name);
+		ha->dpc_lp_wq =3D
+			alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM, wq_name);
 		INIT_WORK(&ha->idc_aen, qla83xx_service_idc_aen);
=20
 		sprintf(wq_name, "qla2xxx_%lu_dpc_hp_wq", base_vha->host_no);
-		ha->dpc_hp_wq =3D create_singlethread_workqueue(wq_name);
+		ha->dpc_hp_wq =3D
+			alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM, wq_name);
 		INIT_WORK(&ha->nic_core_reset, qla83xx_nic_core_reset_work);
 		INIT_WORK(&ha->idc_state_handler,
 		    qla83xx_idc_state_handler_work);
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.=
c
index 17cccd14765f..d91f54a6e752 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -8806,7 +8806,7 @@ static int qla4xxx_probe_adapter(struct pci_dev *pd=
ev,
 	DEBUG2(printk("scsi: %s: Starting kernel thread for "
 		      "qla4xxx_dpc\n", __func__));
 	sprintf(buf, "qla4xxx_%lu_dpc", ha->host_no);
-	ha->dpc_thread =3D create_singlethread_workqueue(buf);
+	ha->dpc_thread =3D alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM, buf);
 	if (!ha->dpc_thread) {
 		ql4_printk(KERN_WARNING, ha, "Unable to start DPC thread!\n");
 		ret =3D -ENODEV;
diff --git a/drivers/scsi/snic/snic_main.c b/drivers/scsi/snic/snic_main.=
c
index abc78320c66d..79ffcf796b05 100644
--- a/drivers/scsi/snic/snic_main.c
+++ b/drivers/scsi/snic/snic_main.c
@@ -302,7 +302,8 @@ snic_add_host(struct Scsi_Host *shost, struct pci_dev=
 *pdev)
 	SNIC_BUG_ON(shost->work_q !=3D NULL);
 	snprintf(shost->work_q_name, sizeof(shost->work_q_name), "scsi_wq_%d",
 		 shost->host_no);
-	shost->work_q =3D create_singlethread_workqueue(shost->work_q_name);
+	shost->work_q =3D alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM,
+						shost->work_q_name);
 	if (!shost->work_q) {
 		SNIC_HOST_ERR(shost, "Failed to Create ScsiHost wq.\n");
=20
@@ -884,7 +885,8 @@ snic_global_data_init(void)
 	snic_glob->req_cache[SNIC_REQ_TM_CACHE] =3D cachep;
=20
 	/* snic_event queue */
-	snic_glob->event_q =3D create_singlethread_workqueue("snic_event_wq");
+	snic_glob->event_q =3D
+		alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM, "snic_event_wq");
 	if (!snic_glob->event_q) {
 		SNIC_ERR("snic event queue create failed\n");
 		ret =3D -ENOMEM;
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 8ffb75be99bc..fbee7db4a835 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -1797,7 +1797,8 @@ static int stex_probe(struct pci_dev *pdev, const s=
truct pci_device_id *id)
=20
 	snprintf(hba->work_q_name, sizeof(hba->work_q_name),
 		 "stex_wq_%d", host->host_no);
-	hba->work_q =3D create_singlethread_workqueue(hba->work_q_name);
+	hba->work_q =3D
+		alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM, hba->work_q_name);
 	if (!hba->work_q) {
 		printk(KERN_ERR DRV_NAME "(%s): create workqueue failed\n",
 			pci_name(pdev));
diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index c4fea077265e..32242d86cf5b 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -1137,7 +1137,8 @@ static int pvscsi_setup_msg_workqueue(struct pvscsi=
_adapter *adapter)
 	snprintf(name, sizeof(name),
 		 "vmw_pvscsi_wq_%u", adapter->host->host_no);
=20
-	adapter->workqueue =3D create_singlethread_workqueue(name);
+	adapter->workqueue =3D
+		alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM, name);
 	if (!adapter->workqueue) {
 		printk(KERN_ERR "vmw_pvscsi: failed to create work queue\n");
 		return 0;
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 0dd26059f5d7..bc00603a6837 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1819,7 +1819,8 @@ static void ufshcd_init_clk_scaling(struct ufs_hba =
*hba)
=20
 	snprintf(wq_name, sizeof(wq_name), "ufs_clkscaling_%d",
 		 hba->host->host_no);
-	hba->clk_scaling.workq =3D create_singlethread_workqueue(wq_name);
+	hba->clk_scaling.workq =3D
+		alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM, wq_name);
=20
 	hba->clk_scaling.is_initialized =3D true;
 }
@@ -10463,7 +10464,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem=
 *mmio_base, unsigned int irq)
 	/* Initialize work queues */
 	snprintf(eh_wq_name, sizeof(eh_wq_name), "ufs_eh_wq_%d",
 		 hba->host->host_no);
-	hba->eh_wq =3D create_singlethread_workqueue(eh_wq_name);
+	hba->eh_wq =3D alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM, eh_wq_name=
);
 	if (!hba->eh_wq) {
 		dev_err(hba->dev, "%s: failed to create eh workqueue\n",
 			__func__);
