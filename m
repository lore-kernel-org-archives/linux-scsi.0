Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9927134EF03;
	Sun, 11 Oct 2026 06:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791699542; cv=none; b=X8x1jTV9le3Yerj8KAs/DcQpROqWilz0OacT/5xpRIs8Me1eHLO4czVdUDZx8DkpCsn5wRXnquoRaTmMZQ/cveyww4EjDhlw0MIkgMtbgJnC35llYFD9RvPfF9pzqWPPjNOhgwy+xq66cCeJXJAOhA6FAv4Q6mrculdQ8tONBGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791699542; c=relaxed/simple;
	bh=oc/nkU99PENVAzivhRrSn8X5cHMa/jNer75YkJzxSkY=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=o8OkOm5darpLdjvKEKGhP1C7DXtIG9j+EofRPsGEjCAsg2fa6gMBqEn2ruqmX+bbgzWiD7C+/ggl/YJw6ek5GqBprnTeaab91wdV7t3IUZXgdcVVnbazjSLgBc29DKril9ED6QLmttIOMCDvy9N467Ow49ukSRYfMVyEbi4DcgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=Nokzbk+L; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="Nokzbk+L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1791699539;
	bh=oc/nkU99PENVAzivhRrSn8X5cHMa/jNer75YkJzxSkY=;
	h=Message-ID:Subject:From:To:Date:From;
	b=Nokzbk+Lq2rESo9L9rSJkwIGvPq9RZf07AHgF1dAzx4vqdupGdeggdVUS1IPOprk2
	 o534XaR0SbkVt37y9dTumDWX7Gz+4nlpKN3hQA1SHyB2W3Q/2muTGt7ZuOy1A2W+5u
	 u6yyOshbZYAvhziJ6dN7yJeH3LI/SGbdsTFOMCX8=
Received: from [10.23.23.39] (unknown [80.188.228.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id B31851C00E7;
	Sun, 11 Oct 2026 02:18:58 -0400 (EDT)
Message-ID: <eab58e05da0087c70f5473874a549572a9ab0230.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 7.3-rc6+
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Sun, 11 Oct 2026 08:18:55 +0200
Autocrypt: addr=James.Bottomley@HansenPartnership.com;
 keydata=mQENBE58FlABCADPM714lRLxGmba4JFjkocqpj1/6/Cx+IXezcS22azZetzCXDpm2MfNE
 lecY3qkFjfnoffQiw5rrOO0/oRSATOh8+2fmJ6el7naRbDuh+i8lVESfdlkoqX57H5R8h/UTIp6gn
 1mpNlxjQv6QSZbl551zQ1nmkSVRbA5TbEp4br5GZeJ58esmYDCBwxuFTsSsdzbOBNthLcudWpJZHU
 RfMc0ew24By1nldL9F37AktNcCipKpC2U0NtGlJjYPNSVXrCd1izxKmO7te7BLP+7B4DNj1VRnaf8
 X9+VIApCi/l4Kdx+ZR3aLTqSuNsIMmXUJ3T8JRl+ag7kby/KBp+0OpotABEBAAG0N0phbWVzIEJvd
 HRvbWxleSA8SmFtZXMuQm90dG9tbGV5QEhhbnNlblBhcnRuZXJzaGlwLmNvbT6JAVgEEwEIAEICGw
 MGCwkIBwMCBhUIAgkKCwQWAgMBAh4BAheAAhkBFiEE1WBuc8i0YnG+rZrfgUrkfCFIVNYFAml2ZBI
 FCS3GUMIACgkQgUrkfCFIVNZKjQf/deRzlXZClKxTC/Ee2yEPqqS7mm/INUA49KdQQ5oIhSxkUBy0
 9J4qjMIo5F8ZFkFTqikBqeL35LKu7O7rn8WETfX8Bxvos3HUsl3jHo34DES4MUFIpoQPgtiLRGwLb
 K0cVCAArR2u2qj4ABmTRrs1I1kvdjEw6gatOuXtEe/j5O2fvfzTq9GBr0Q3n2IAsFXi4hLlx6VPE8
 tyWUZ8BWJKtih3JAeUiXFvASL3McV0rV9RnU0VbjEQEhSE7PMYhWpnDC9AyBb0lXJllQRvC3NSkUB
 8KVQgNNxRPss0WE/nBoZ4dFA42jTyzTz8lNylxZoAWV7WJb3QxVg4oCodRVrxxrQhSmFtZXMgQm90
 dG9tbGV5IDxqZWpiQGtlcm5lbC5vcmc+iQFVBBMBCAA/AhsDBgsJCAcDAgYVCAIJCgsEFgIDAQIeA
 QIXgBYhBNVgbnPItGJxvq2a34FK5HwhSFTWBQJgS5mYBQkbNYS9AAoJEIFK5HwhSFTWBpwIAL5Bk3
 5FB34U6iHmDzzgdCbxLTs43T/YQyJpcGIvopBvnI/fDY8oSG6Df64/O6B+1R+A8TDp6ZG5ysUWnCC
 6GuIaEHemBYkitMPglR6+sGCMQY7O0mlsPvdssvKK1KI9Bno4VU6ogaF2qVzefSqg1Djmf/DcsxWP
 rI/jdJ8FB5AYR2rjIdDFc+zRdAJuavo1/anyY2wgpFh/3R8IOYAEfWV9nGgYkf9+tA4EIn1sxE0I3
 L5oW2N3mbyRrkzuBwO8ztMCwqEPk7moWzhokcZqMXiAIahaZdkashJC+s2X2RZSGCy+g+pvY5NN4B
 BVG5XwLgVBqbHMTcxE0fbmPqz+q6O0LEphbWVzIEJvdHRvbWxleSA8amVqYkBoYW5zZW5wYXJ0bmV
 yc2hpcC5jb20+iQFXBBMBCABBFiEE1WBuc8i0YnG+rZrfgUrkfCFIVNYFAmODZ5ACGwMFCRs1hL0F
 CwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4AACgkQgUrkfCFIVNZu0Af/TzvL2/NdgAcw9uN3x60H8
 jc4QUq14VpxcFEFEMpcj1morkX/G93V+56HBBaXZj+yK8PhxIA/SIz+sU7C/0YvKuvzakP8ZX/7WJ
 e32SOUtjfr/VTaqjIBzNj6OxLvZpmNbBw7s6DwhhNpHOWqJ/1ml+PtDRDV71IB58yVqQjp1xlNKVl
 ZppcJ5908EJzsFnRIVjiQiDSKoppqB2BCibBbrWcln7CiWMyOC/cco6SIn6twH+f7+aivJ3xGcOE2
 a9gBKF5rNi9TBoX9oyPmshv/TDmnohsVrH7AYXlGYfZTk15SWEiROh1QX8/uD9wl/gcIv5EDUpT/F
 L2jzOsA5663bw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

The following changes since commit 42d1221d321e55afc7bba9109a77aaf5a817c8a3=
:

  scsi: megaraid_sas: Protect megasas_get_ctrl_info() in megasas_resume() (=
2026-09-16 21:33:30 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git/ tags/scsi-=
fixes

for you to fetch changes up to 469fa055664bfd8717b087a80d59c03055789c17:

  scsi: ufs: core: Decouple CQ sweep from request iterator in MCQ (2026-10-=
05 22:05:13 -0400)

----------------------------------------------------------------
Driver (and tape media changer) only fixes. Three of the fixes are about
the same size, (ch, ufs decouble CQ and ufs avoid unsafe MMIO) but the
unsafe MMIO is the least obvious logic change.

----------------------------------------------------------------
Ahmed Abdelhaleem Ahmed (1):
      scsi: ch: Do not keep references to data transfer element devices

Naomi Chu (1):
      scsi: ufs: core: Hold a clock reference across the probe

Pengpeng Hou (1):
      scsi: ufs: mediatek: Handle mPHY power-on failures

Runyu Xiao (1):
      scsi: qedi: Initialize callback state before registration

Stanley Jhu (2):
      scsi: ufs: core: Avoid unsafe MMIO reads in ufshcd_mcq_compl_all_cqes=
_lock()
      scsi: ufs: core: Decouple CQ sweep from request iterator in MCQ

 drivers/scsi/ch.c               | 29 +++++++---------------
 drivers/scsi/qedi/qedi_main.c   |  3 +--
 drivers/ufs/core/ufs-mcq.c      | 30 +++++++++++++----------
 drivers/ufs/core/ufshcd.c       | 53 ++++++++++++++++++++-----------------=
----
 drivers/ufs/host/ufs-mediatek.c | 18 ++++++++++++--
 5 files changed, 69 insertions(+), 64 deletions(-)

---

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 4010fdbf813c..c36539c83ed1 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -112,7 +112,6 @@ typedef struct {
 	int                 minor;
 	char                name[8];
 	struct scsi_device  *device;
-	struct scsi_device  **dt;        /* ptrs to data transfer elements */
 	u_int               firsts[CH_TYPES];
 	u_int               counts[CH_TYPES];
 	u_int		    voltags;
@@ -363,15 +362,10 @@ ch_readconfig(scsi_changer *ch)
 			vendor_labels[i]);
 	}
=20
-	/* look up the devices of the data transfer elements */
-	ch->dt =3D kzalloc_objs(*ch->dt, ch->counts[CHET_DT]);
-
-	if (!ch->dt) {
-		kfree(buffer);
-		return -ENOMEM;
-	}
-
+	/* report the devices of the data transfer elements */
 	for (elem =3D 0; elem < ch->counts[CHET_DT]; elem++) {
+		struct scsi_device *sdev;
+
 		id  =3D -1;
 		lun =3D 0;
 		if (elem < CH_DT_MAX  &&  -1 !=3D dt_id[elem]) {
@@ -387,10 +381,8 @@ ch_readconfig(scsi_changer *ch)
 			VPRINTK(KERN_INFO, "dt 0x%x: ",elem+ch->firsts[CHET_DT]);
 			if (data[6] & 0x80) {
 				VPRINTK(KERN_CONT, "not this SCSI bus\n");
-				ch->dt[elem] =3D NULL;
 			} else if (0 =3D=3D (data[6] & 0x30)) {
 				VPRINTK(KERN_CONT, "ID/LUN unknown\n");
-				ch->dt[elem] =3D NULL;
 			} else {
 				id  =3D ch->device->id;
 				lun =3D 0;
@@ -400,18 +392,16 @@ ch_readconfig(scsi_changer *ch)
 		}
 		if (-1 !=3D id) {
 			VPRINTK(KERN_CONT, "ID %i, LUN %i, ",id,lun);
-			ch->dt[elem] =3D
-				scsi_device_lookup(ch->device->host,
-						   ch->device->channel,
-						   id,lun);
-			if (!ch->dt[elem]) {
+			sdev =3D scsi_device_lookup(ch->device->host,
+						  ch->device->channel,
+						  id, lun);
+			if (!sdev) {
 				/* should not happen */
 				VPRINTK(KERN_CONT, "Huh? device not found!\n");
 			} else {
 				VPRINTK(KERN_CONT, "name: %8.8s %16.16s %4.4s\n",
-					ch->dt[elem]->vendor,
-					ch->dt[elem]->model,
-					ch->dt[elem]->rev);
+					sdev->vendor, sdev->model, sdev->rev);
+				scsi_device_put(sdev);
 			}
 		}
 	}
@@ -575,7 +565,6 @@ static void ch_destroy(struct kref *ref)
 	scsi_changer *ch =3D container_of(ref, scsi_changer, ref);
=20
 	ch->device =3D NULL;
-	kfree(ch->dt);
 	kfree(ch);
 }
=20
diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 227ff7bd1bdc..f394fcbb97e7 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -2652,8 +2652,6 @@ static int __qedi_probe(struct pci_dev *pdev, int mod=
e)
 	snprintf(host_buf, sizeof(host_buf), "host_%d", qedi->shost->host_no);
 	qedi_ops->common->set_name(qedi->cdev, host_buf);
=20
-	qedi_ops->register_ops(qedi->cdev, &qedi_cb_ops, qedi);
-
 	memset(&params, 0, sizeof(params));
 	params.mtu =3D DEF_PATH_MTU + IPV6_HDR_LEN + TCP_HDR_LEN;
 	qedi->ll2_mtu =3D DEF_PATH_MTU;
@@ -2670,6 +2668,7 @@ static int __qedi_probe(struct pci_dev *pdev, int mod=
e)
 		spin_lock_init(&qedi->task_idx_lock);
 		mutex_init(&qedi->stats_lock);
 	}
+	qedi_ops->register_ops(qedi->cdev, &qedi_cb_ops, qedi);
 	qedi_ops->ll2->register_cb_ops(qedi->cdev, &qedi_ll2_cb_ops, qedi);
 	qedi_ops->ll2->start(qedi->cdev, &params);
=20
diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 8106d55f4041..df293b66350d 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -312,20 +312,24 @@ static int ufshcd_mcq_get_tag(struct ufs_hba *hba, st=
ruct cq_entry *cqe)
 		UFSHCD_NUM_RESERVED;
 }
=20
+static void ufshcd_mcq_compl_cqe(struct ufs_hba *hba, struct cq_entry *cqe=
)
+{
+	int tag =3D ufshcd_mcq_get_tag(hba, cqe);
+
+	ufshcd_compl_one_cqe(hba, tag, cqe);
+	/* After processing the CQE, mark it as an empty (invalid) entry. */
+	cqe->command_desc_base_addr =3D 0;
+}
+
 static void ufshcd_mcq_process_cqe(struct ufs_hba *hba,
 				   struct ufs_hw_queue *hwq)
 {
 	struct cq_entry *cqe =3D ufshcd_mcq_cur_cqe(hwq);
=20
-	if (cqe->command_desc_base_addr) {
-		int tag =3D ufshcd_mcq_get_tag(hba, cqe);
-
-		ufshcd_compl_one_cqe(hba, tag, cqe);
-		/* After processed the cqe, mark it empty (invalid) entry */
-		cqe->command_desc_base_addr =3D 0;
-	} else {
+	if (cqe->command_desc_base_addr)
+		ufshcd_mcq_compl_cqe(hba, cqe);
+	else
 		dev_err(hba->dev, "Abnormal CQ entry!\n");
-	}
 }
=20
 /*
@@ -333,7 +337,7 @@ static void ufshcd_mcq_process_cqe(struct ufs_hba *hba,
  * controller disabled (HCE =3D 0). Reading host controller registers, e.g=
. the
  * CQ tail pointer (CQTPy), may not be safe with the host controller disab=
led.
  * Hence, iterate over all completion queue entries. This won't result in
- * double completions because ufshcd_mcq_process_cqe() clears a CQE after =
it
+ * double completions because ufshcd_mcq_compl_cqe() clears a CQE after it
  * has been processed.
  */
 void ufshcd_mcq_compl_all_cqes_lock(struct ufs_hba *hba,
@@ -344,13 +348,13 @@ void ufshcd_mcq_compl_all_cqes_lock(struct ufs_hba *h=
ba,
=20
 	spin_lock_irqsave(&hwq->cq_lock, flags);
 	while (entries > 0) {
-		ufshcd_mcq_process_cqe(hba, hwq);
+		struct cq_entry *cqe =3D ufshcd_mcq_cur_cqe(hwq);
+
+		if (cqe->command_desc_base_addr)
+			ufshcd_mcq_compl_cqe(hba, cqe);
 		ufshcd_mcq_inc_cq_head_slot(hwq);
 		entries--;
 	}
-
-	ufshcd_mcq_update_cq_tail_slot(hwq);
-	hwq->cq_head_slot =3D hwq->cq_tail_slot;
 	spin_unlock_irqrestore(&hwq->cq_lock, flags);
 }
=20
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 54f4e7d7de02..ca8329052cbc 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6044,8 +6044,6 @@ static bool ufshcd_mcq_force_compl_one(struct request=
 *rq, void *priv)
 	if (blk_mq_is_reserved_rq(rq) || !hwq)
 		return true;
=20
-	ufshcd_mcq_compl_all_cqes_lock(hba, hwq);
-
 	/*
 	 * For those cmds of which the cqes are not present in the cq, complete
 	 * them explicitly.
@@ -6061,19 +6059,6 @@ static bool ufshcd_mcq_force_compl_one(struct reques=
t *rq, void *priv)
 	return true;
 }
=20
-static bool ufshcd_mcq_compl_one(struct request *rq, void *priv)
-{
-	struct scsi_device *sdev =3D rq->q->queuedata;
-	struct Scsi_Host *shost =3D sdev->host;
-	struct ufs_hba *hba =3D shost_priv(shost);
-	struct ufs_hw_queue *hwq =3D ufshcd_mcq_req_to_hwq(hba, rq);
-
-	if (!blk_mq_is_reserved_rq(rq) && hwq)
-		ufshcd_mcq_poll_cqe_lock(hba, hwq);
-
-	return true;
-}
-
 /**
  * ufshcd_mcq_compl_pending_transfer - MCQ mode function. It is
  * invoked from the error handler context or ufshcd_host_reset_and_restore=
()
@@ -6088,10 +6073,18 @@ static bool ufshcd_mcq_compl_one(struct request *rq=
, void *priv)
 static void ufshcd_mcq_compl_pending_transfer(struct ufs_hba *hba,
 					      bool force_compl)
 {
-	blk_mq_tagset_busy_iter(&hba->host->tag_set,
-				force_compl ? ufshcd_mcq_force_compl_one :
-					      ufshcd_mcq_compl_one,
-				NULL);
+	int i;
+
+	for (i =3D 0; i < hba->nr_hw_queues; i++) {
+		if (force_compl)
+			ufshcd_mcq_compl_all_cqes_lock(hba, &hba->uhq[i]);
+		else
+			ufshcd_mcq_poll_cqe_lock(hba, &hba->uhq[i]);
+	}
+
+	if (force_compl)
+		blk_mq_tagset_busy_iter(&hba->host->tag_set,
+					ufshcd_mcq_force_compl_one, NULL);
 }
=20
 /**
@@ -9556,6 +9549,7 @@ static void ufshcd_async_scan(void *data, async_cooki=
e_t cookie)
 	ret =3D ufshcd_add_lus(hba);
=20
 out:
+	ufshcd_release(hba);
 	pm_runtime_put_sync(hba->dev);
=20
 	if (ret)
@@ -11278,6 +11272,9 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *=
mmio_base, unsigned int irq)
=20
 	ufshcd_init_clk_gating(hba);
=20
+	/* Released by ufshcd_async_scan(), or by out_release on failure. */
+	ufshcd_hold(hba);
+
 	ufshcd_init_clk_scaling(hba);
=20
 	/*
@@ -11298,7 +11295,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *=
mmio_base, unsigned int irq)
 	err =3D devm_request_irq(dev, irq, ufshcd_intr, IRQF_SHARED, UFSHCD, hba)=
;
 	if (err) {
 		dev_err(hba->dev, "request irq failed\n");
-		goto out_disable;
+		goto out_release;
 	} else {
 		hba->is_irq_enabled =3D true;
 	}
@@ -11314,7 +11311,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *=
mmio_base, unsigned int irq)
 		dev_err(hba->dev, "Host controller enable failed\n");
 		ufshcd_print_evt_hist(hba);
 		ufshcd_print_host_state(hba);
-		goto out_disable;
+		goto out_release;
 	}
=20
 	INIT_DELAYED_WORK(&hba->rpm_dev_flush_recheck_work, ufshcd_rpm_dev_flush_=
recheck_work);
@@ -11328,7 +11325,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *=
mmio_base, unsigned int irq)
=20
 	err =3D ufshcd_add_scsi_host(hba);
 	if (err)
-		goto out_disable;
+		goto out_release;
=20
 	/* Hold auto suspend until async scan completes */
 	pm_runtime_get_sync(dev);
@@ -11348,7 +11345,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *=
mmio_base, unsigned int irq)
=20
 	err =3D ufshcd_link_startup(hba);
 	if (err)
-		goto out_disable;
+		goto out_release;
=20
 	if (hba->mcq_enabled)
 		ufshcd_config_mcq(hba);
@@ -11365,23 +11362,23 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem=
 *mmio_base, unsigned int irq)
 	/* Verify device initialization by sending NOP OUT UPIU */
 	err =3D ufshcd_verify_dev_init(hba);
 	if (err)
-		goto out_disable;
+		goto out_release;
=20
 	/* Initiate UFS initialization, and waiting until completion */
 	err =3D ufshcd_complete_dev_init(hba);
 	if (err)
-		goto out_disable;
+		goto out_release;
=20
 	err =3D ufshcd_device_params_init(hba);
 	if (err)
-		goto out_disable;
+		goto out_release;
=20
 	err =3D ufshcd_post_device_init(hba);
=20
 initialized:
 	ufshcd_process_probe_result(hba, probe_start, err);
 	if (err)
-		goto out_disable;
+		goto out_release;
=20
 	ufs_sysfs_add_nodes(hba->dev);
 	hba->dme_qos_sysfs_handle =3D sysfs_get_dirent(hba->dev->kobj.sd,
@@ -11392,6 +11389,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *=
mmio_base, unsigned int irq)
 	ufshcd_pm_qos_init(hba);
 	return 0;
=20
+out_release:
+	ufshcd_release(hba);
 out_disable:
 	hba->is_irq_enabled =3D false;
 	ufshcd_hba_exit(hba);
diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediate=
k.c
index 814c1b7343b9..12a6d4138e44 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -509,6 +509,7 @@ static int ufs_mtk_mphy_power_on(struct ufs_hba *hba, b=
ool on)
 	struct ufs_mtk_host *host =3D ufshcd_get_variant(hba);
 	struct phy *mphy =3D host->mphy;
 	struct arm_smccc_res res;
+	int err;
 	int ret =3D 0;
=20
 	if (!mphy || !(on ^ host->mphy_powered_on))
@@ -523,7 +524,18 @@ static int ufs_mtk_mphy_power_on(struct ufs_hba *hba, =
bool on)
 			usleep_range(200, 210);
 			ufs_mtk_va09_pwr_ctrl(res, 1);
 		}
-		phy_power_on(mphy);
+		ret =3D phy_power_on(mphy);
+		if (ret) {
+			if (ufs_mtk_is_va09_supported(hba)) {
+				ufs_mtk_va09_pwr_ctrl(res, 0);
+				err =3D regulator_disable(host->reg_va09);
+				if (err)
+					dev_err(hba->dev,
+						"failed to unwind va09: %d\n", err);
+			}
+			dev_err(hba->dev, "failed to enable mphy: %d\n", ret);
+			return ret;
+		}
 	} else {
 		phy_power_off(mphy);
 		if (ufs_mtk_is_va09_supported(hba)) {
@@ -1295,7 +1307,9 @@ static int ufs_mtk_init(struct ufs_hba *hba)
 	 *
 	 * Enable phy clocks specifically here.
 	 */
-	ufs_mtk_mphy_power_on(hba, true);
+	err =3D ufs_mtk_mphy_power_on(hba, true);
+	if (err)
+		goto out_variant_clear;
=20
 	if (ufs_mtk_is_rtff_mtcmos(hba)) {
 		/* First Restore here, to avoid backup unexpected value */
