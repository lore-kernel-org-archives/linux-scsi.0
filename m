Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30061B4257;
	Sat,  5 Sep 2026 16:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788625060; cv=none; b=uYLLrs+mft+3w9piTQMd12bH73H+zRf7mdpBQPZnDjXLEQJYqZERf9ezfRmV38yRgYI6TUuqy//N6NTkKRoIBJy7abaLEHBiE0YU1cj47m8l0ygiQfHMbopnSE321oIMX9FsxFQZjqJxRUSW3gLSoBDVHMLTc5LXN3aQicXEYPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788625060; c=relaxed/simple;
	bh=/hnzcZ75qHwc0Diu6+dkbu/FcXDqfB+dSUHWbD52UUc=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=jwgI1Mqu1A3vF29FcHVGbM97Rsv8d36AKMoX53py2fp52/qRqWSOyFWXNkEGAlpDf9U85H0fgQKiJH+mKTQL2hcF4oe7Rtp/ZGwy++kFuc5WuHNL6Fx4fozeVI/PhqxnnGvBnADo1H9RBIbnRlh8im83veOeIHM09yRGL3eKAq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=WXMkrP1t; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="WXMkrP1t"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1788625056;
	bh=/hnzcZ75qHwc0Diu6+dkbu/FcXDqfB+dSUHWbD52UUc=;
	h=Message-ID:Subject:From:To:Date:From;
	b=WXMkrP1t8pHEe9vkUgUoe2aVVZNtO7sxX3ubsR8vDUVfMK8lPy5FPnFXN8tcZqpBw
	 L/kTLkH5eMr2WcI085DkmAUAX67HeFi0Lf/hmFdUih8w14hvC5CNOguO+bH1pm+/M2
	 rziR7FaMMwGNG3++mJg2uOQucYaTRQWUydHCdIW0=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:d341::8309])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id 3624F1C0159;
	Sat, 05 Sep 2026 12:17:36 -0400 (EDT)
Message-ID: <d7c2465525ad601d8569fa7219a8add38bf4aa26.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 7.3-rc1+
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Sat, 05 Sep 2026 12:17:35 -0400
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

The following changes since commit cee9395acd8043be0644b25c34bfa86623f2b935=
:

  Linux 7.3-rc1 (2026-08-30 13:34:40 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git/ tags/scsi-=
fixes

for you to fetch changes up to af8c27375733fb6a6df9fa484cda77cc3dd0cb80:

  scsi: megaraid_sas: Limit NVMe request size to the PRP chain frame (2026-=
09-02 12:13:15 -0400)

----------------------------------------------------------------
2 enhancements to add support and MCQ for additional Intel 4.0
controller types. The rest are all driver fixes, the largest of which is
the mpi3mr target use after free fix, follwed by a similar TOCTOU fix
for io_uring passthrough in bsg.

----------------------------------------------------------------
Ivy Lopez (1):
      scsi: mpt3sas: Avoid out-of-bounds cpumask_of_node() call in _base_as=
sign_reply_queues()

Laurence Oberman (1):
      scsi: mpi3mr: Fix use-after-free on tgt_dev->starget during target de=
vice refresh/update

Linmao Li (1):
      scsi: fnic: Initialize the NVMe local port info before registering

Maurizio Lombardi (1):
      scsi: target: iscsi: Fix hang for aborted WRITE_PENDING commands

Milan P. Gandhi (2):
      scsi: mpi3mr: Fix NULL pointer dereference in mpi3mr_sas_port_add()
      scsi: mpi3mr: Fix target device refcount leak in mpi3mr_sas_port_add(=
)

Muhammad Falak R Wani (2):
      scsi: ibmvfc: Fix kernel-doc name for ibmvfc_scsi_relogin()
      scsi: ibmvfc: Document protocol parameter of ibmvfc_alloc_target()

Nitin Rawat (2):
      scsi: ufs: ufs-qcom: Restore HS/LS link startup mode for Qualcomm UFS=
 controller v6.2+
      scsi: ufs: ufs-qcom: Fix sequential read variance

Rahul Chandelkar (1):
      scsi: bsg: Fix TOCTOU in io_uring passthrough command setup

Runyu Xiao (1):
      scsi: pm8001: Use rollback index when freeing MSI-X vectors

Sujal Tuladhar (1):
      scsi: target: iscsi: Reserve a terminator byte for the login payload

Thomas Lamprecht (1):
      scsi: megaraid_sas: Limit NVMe request size to the PRP chain frame

Xu Rao (1):
      scsi: sg: Report request-table problems when any status is set

Yang Xiuwei (1):
      scsi: bsg: Cap io_uring sense copy to max_response_len

sangram kumar yerra (2):
      scsi: ufs: ufs-pci: Add support for Intel UFS 4.0 HS-Gear5
      scsi: ufs: ufs-pci: Add MCQ support for Intel UFS 4.0 controllers

 drivers/scsi/fnic/fnic_nvme.c             |  2 +-
 drivers/scsi/ibmvscsi/ibmvfc-core.c       |  3 +-
 drivers/scsi/megaraid/megaraid_sas_base.c | 13 ++++++-
 drivers/scsi/mpi3mr/mpi3mr_os.c           | 45 +++++++++++++++++------
 drivers/scsi/mpi3mr/mpi3mr_transport.c    |  8 +++++
 drivers/scsi/mpt3sas/mpt3sas_base.c       |  5 ++-
 drivers/scsi/pm8001/pm8001_init.c         |  4 +--
 drivers/scsi/scsi_bsg.c                   | 47 ++++++++++++++----------
 drivers/target/iscsi/iscsi_target.c       |  4 ++-
 drivers/target/iscsi/iscsi_target_login.c |  2 +-
 drivers/ufs/host/ufs-qcom.c               | 17 ++++++---
 drivers/ufs/host/ufs-qcom.h               |  1 +
 drivers/ufs/host/ufshcd-pci.c             | 59 +++++++++++++++++++++++++++=
++++
 13 files changed, 170 insertions(+), 40 deletions(-)

---
diff --git a/drivers/scsi/fnic/fnic_nvme.c b/drivers/scsi/fnic/fnic_nvme.c
index b237948dcafd..00d9d5d439a3 100644
--- a/drivers/scsi/fnic/fnic_nvme.c
+++ b/drivers/scsi/fnic/fnic_nvme.c
@@ -2216,7 +2216,7 @@ int nvfnic_add_tport(struct fnic *fnic, struct fnic_t=
port_s *tport,
=20
 int nvfnic_add_lport(struct fnic *fnic)
 {
-	struct nvme_fc_port_info pinfo;
+	struct nvme_fc_port_info pinfo =3D {};
 	struct fnic_iport_s *iport =3D &fnic->iport;
 	int ret =3D 0;
=20
diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ib=
mvfc-core.c
index b3bc3ce872d6..3534ac45e9b8 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -1894,7 +1894,7 @@ static void ibmvfc_log_error(struct ibmvfc_event *evt=
)
 }
=20
 /**
- * ibmvfc_relogin - Log back into the specified device
+ * ibmvfc_scsi_relogin - Log back into the specified device
  * @sdev:	scsi device struct
  *
  **/
@@ -4987,6 +4987,7 @@ static void ibmvfc_tgt_query_target(struct ibmvfc_tar=
get *tgt)
  * ibmvfc_alloc_target - Allocate and initialize an ibmvfc target
  * @vhost:		ibmvfc host struct
  * @target:		Holds SCSI ID to allocate target forand the WWPN
+ * @protocol:		protocol of the target to allocate
  *
  * Returns:
  *	0 on success / other on failure
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megar=
aid/megaraid_sas_base.c
index f0152b043e18..b95f187297ae 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1973,12 +1973,23 @@ megasas_set_nvme_device_properties(struct scsi_devi=
ce *sdev,
 {
 	struct megasas_instance *instance;
 	u32 mr_nvme_pg_size;
+	u64 max_prp_io;
=20
 	instance =3D (struct megasas_instance *)sdev->host->hostdata;
 	mr_nvme_pg_size =3D max_t(u32, instance->nvme_page_size,
 				MR_DEFAULT_NVME_PAGE_SIZE);
=20
-	lim->max_hw_sectors =3D max_io_size / 512;
+	/*
+	 * megasas_make_prp_nvme() builds the PRP list in cmd->sg_frame without
+	 * bounding it against that buffer, and spends one entry per page of
+	 * it on the chain pointer. Cap the transfer at what the buffer holds,
+	 * less one page for lists that start off a page boundary.
+	 */
+	max_prp_io =3D (u64)((instance->max_chain_frame_sz / sizeof(u64)) -
+			   (instance->max_chain_frame_sz / mr_nvme_pg_size) - 1) *
+		     mr_nvme_pg_size;
+
+	lim->max_hw_sectors =3D min_t(u64, max_io_size, max_prp_io) >> SECTOR_SHI=
FT;
 	lim->virt_boundary_mask =3D mr_nvme_pg_size - 1;
 }
=20
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_o=
s.c
index f80a21ec161b..0f7380448718 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -1094,10 +1094,13 @@ static void mpi3mr_refresh_tgtdevs(struct mpi3mr_io=
c *mrioc)
 {
 	struct mpi3mr_tgt_dev *tgtdev, *tgtdev_next;
 	struct mpi3mr_stgt_priv_data *tgt_priv;
+	struct scsi_target *starget;
+	unsigned long flags;
=20
 	dprint_reset(mrioc, "refresh target devices: check for removals\n");
 	list_for_each_entry_safe(tgtdev, tgtdev_next, &mrioc->tgtdev_list,
 	    list) {
+		spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
 		if (((tgtdev->dev_handle =3D=3D MPI3MR_INVALID_DEV_HANDLE) ||
 		     tgtdev->is_hidden) &&
 		     tgtdev->host_exposed && tgtdev->starget &&
@@ -1106,6 +1109,7 @@ static void mpi3mr_refresh_tgtdevs(struct mpi3mr_ioc =
*mrioc)
 			tgt_priv->dev_removed =3D 1;
 			atomic_set(&tgt_priv->block_io, 0);
 		}
+		spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
 	}
=20
 	list_for_each_entry_safe(tgtdev, tgtdev_next, &mrioc->tgtdev_list,
@@ -1127,15 +1131,25 @@ static void mpi3mr_refresh_tgtdevs(struct mpi3mr_io=
c *mrioc)
 	tgtdev =3D NULL;
 	list_for_each_entry(tgtdev, &mrioc->tgtdev_list, list) {
 		if ((tgtdev->dev_handle !=3D MPI3MR_INVALID_DEV_HANDLE) &&
-		    !tgtdev->is_hidden) {
-			if (!tgtdev->host_exposed)
+				!tgtdev->is_hidden) {
+			if (!tgtdev->host_exposed) {
 				mpi3mr_report_tgtdev_to_host(mrioc,
-							     tgtdev->perst_id);
-			else if (tgtdev->starget)
-				starget_for_each_device(tgtdev->starget,
-							(void *)tgtdev, mpi3mr_update_sdev);
-	}
+				     tgtdev->perst_id);
+				continue;
+			}
+			spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
+			starget =3D tgtdev->starget;
+			if (starget)
+				get_device(&starget->dev);
+			spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
+			if (starget) {
+				starget_for_each_device(starget, (void *)tgtdev,
+							mpi3mr_update_sdev);
+				put_device(&starget->dev);
+			}
+		}
 	}
+	dprint_reset(mrioc, "refresh target devices: done\n");
 }
=20
 /**
@@ -1515,6 +1529,8 @@ static void mpi3mr_devinfochg_evt_bh(struct mpi3mr_io=
c *mrioc,
 	struct mpi3_device_page0 *dev_pg0)
 {
 	struct mpi3mr_tgt_dev *tgtdev =3D NULL;
+	struct scsi_target *starget;
+	unsigned long flags;
 	u16 dev_handle =3D 0, perst_id =3D 0;
=20
 	perst_id =3D le16_to_cpu(dev_pg0->persistent_id);
@@ -1535,9 +1551,18 @@ static void mpi3mr_devinfochg_evt_bh(struct mpi3mr_i=
oc *mrioc,
 		mpi3mr_report_tgtdev_to_host(mrioc, perst_id);
 	if (tgtdev->is_hidden && tgtdev->host_exposed)
 		mpi3mr_remove_tgtdev_from_host(mrioc, tgtdev);
-	if (!tgtdev->is_hidden && tgtdev->host_exposed && tgtdev->starget)
-		starget_for_each_device(tgtdev->starget, (void *)tgtdev,
-		    mpi3mr_update_sdev);
+	if (!tgtdev->is_hidden && tgtdev->host_exposed) {
+		spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
+		starget =3D tgtdev->starget;
+		if (starget)
+			get_device(&starget->dev);
+		spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
+		if (starget) {
+			starget_for_each_device(starget, (void *)tgtdev,
+						mpi3mr_update_sdev);
+			put_device(&starget->dev);
+		}
+	}
 out:
 	if (tgtdev)
 		mpi3mr_tgtdev_put(tgtdev);
diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/m=
pi3mr_transport.c
index 240f67a8e2e3..232af978d737 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -1428,9 +1428,15 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(s=
truct mpi3mr_ioc *mrioc,
 	}
=20
 	port =3D sas_port_alloc_num(mr_sas_node->parent_dev);
+	if (!port) {
+		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		goto out_fail;
+	}
 	if ((sas_port_add(port))) {
 		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
 		    __FILE__, __LINE__, __func__);
+		sas_port_free(port);
 		goto out_fail;
 	}
=20
@@ -1501,6 +1507,8 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(st=
ruct mpi3mr_ioc *mrioc,
 	list_for_each_entry_safe(mr_sas_phy, next, &mr_sas_port->phy_list,
 	    port_siblings)
 		list_del(&mr_sas_phy->port_siblings);
+	if (tgtdev)
+		mpi3mr_tgtdev_put(tgtdev);
 	kfree(mr_sas_port);
 	return NULL;
 }
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt=
3sas_base.c
index fed7aeffec58..1af25a22611a 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3238,7 +3238,10 @@ _base_assign_reply_queues(struct MPT3SAS_ADAPTER *io=
c)
 		 * corresponding to high iops queues.
 		 */
 		if (ioc->high_iops_queues) {
-			mask =3D cpumask_of_node(dev_to_node(&ioc->pdev->dev));
+			int node =3D dev_to_node(&ioc->pdev->dev);
+
+			mask =3D (node =3D=3D NUMA_NO_NODE) ?
+				cpu_online_mask : cpumask_of_node(node);
 			for (index =3D 0; index < ioc->high_iops_queues;
 			    index++) {
 				irq =3D pci_irq_vector(ioc->pdev, index);
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001=
_init.c
index e93ea76b565e..54b35893261a 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1029,8 +1029,8 @@ static u32 pm8001_request_msix(struct pm8001_hba_info=
 *pm8001_ha)
 			&(pm8001_ha->irq_vector[i]));
 		if (rc) {
 			for (j =3D 0; j < i; j++) {
-				free_irq(pci_irq_vector(pm8001_ha->pdev, i),
-					&(pm8001_ha->irq_vector[i]));
+				free_irq(pci_irq_vector(pm8001_ha->pdev, j),
+					 &pm8001_ha->irq_vector[j]);
 			}
 			pci_free_irq_vectors(pm8001_ha->pdev);
 			break;
diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c
index e80dec53174e..5eec248a77a6 100644
--- a/drivers/scsi/scsi_bsg.c
+++ b/drivers/scsi/scsi_bsg.c
@@ -18,6 +18,7 @@ struct scsi_bsg_uring_cmd_pdu {
 	struct bio *bio;		/* mapped user buffer, unmap in task work */
 	struct request *req;		/* block request, freed in task work */
 	u64 response_addr;		/* user space response buffer address */
+	u32 max_response_len;		/* user response buffer size */
 };
 static_assert(sizeof(struct scsi_bsg_uring_cmd_pdu) <=3D sizeof_field(stru=
ct io_uring_cmd, pdu));
=20
@@ -45,8 +46,8 @@ static void scsi_bsg_uring_task_cb(struct io_tw_req tw_re=
q, io_tw_token_t tw)
 	if (scsi_status_is_check_condition(scmd->result)) {
 		driver_status =3D DRIVER_SENSE;
 		if (pdu->response_addr)
-			sense_len_wr =3D min_t(u8, scmd->sense_len,
-					     SCSI_SENSE_BUFFERSIZE);
+			sense_len_wr =3D min_t(unsigned int, pdu->max_response_len,
+					     scmd->sense_len);
 	}
=20
 	if (sense_len_wr) {
@@ -76,12 +77,10 @@ static enum rq_end_io_ret scsi_bsg_uring_cmd_done(struc=
t request *req,
=20
 static int scsi_bsg_map_user_buffer(struct request *req,
 				    struct io_uring_cmd *ioucmd,
-				    unsigned int issue_flags, gfp_t gfp_mask)
+				    unsigned int issue_flags, gfp_t gfp_mask,
+				    bool is_write, u64 buf_addr,
+				    unsigned long buf_len)
 {
-	const struct bsg_uring_cmd *cmd =3D io_uring_sqe128_cmd(ioucmd->sqe, stru=
ct bsg_uring_cmd);
-	bool is_write =3D cmd->dout_xfer_len > 0;
-	u64 buf_addr =3D is_write ? cmd->dout_xferp : cmd->din_xferp;
-	unsigned long buf_len =3D is_write ? cmd->dout_xfer_len : cmd->din_xfer_l=
en;
 	struct iov_iter iter;
 	int ret;
=20
@@ -104,21 +103,28 @@ static int scsi_bsg_uring_cmd(struct request_queue *q=
, struct io_uring_cmd *iouc
 			       unsigned int issue_flags, bool open_for_write)
 {
 	struct scsi_bsg_uring_cmd_pdu *pdu =3D scsi_bsg_uring_cmd_pdu(ioucmd);
-	const struct bsg_uring_cmd *cmd =3D io_uring_sqe128_cmd(ioucmd->sqe, stru=
ct bsg_uring_cmd);
+	const struct bsg_uring_cmd *cmd =3D
+		io_uring_sqe128_cmd(ioucmd->sqe, struct bsg_uring_cmd);
 	struct scsi_cmnd *scmd;
 	struct request *req;
 	blk_mq_req_flags_t blk_flags =3D 0;
 	gfp_t gfp_mask =3D GFP_KERNEL;
+	u64 request =3D READ_ONCE(cmd->request);
+	u32 request_len =3D READ_ONCE(cmd->request_len);
+	u64 dout_xferp =3D READ_ONCE(cmd->dout_xferp);
+	u32 dout_xfer_len =3D READ_ONCE(cmd->dout_xfer_len);
+	u64 din_xferp =3D READ_ONCE(cmd->din_xferp);
+	u32 din_xfer_len =3D READ_ONCE(cmd->din_xfer_len);
 	int ret;
=20
 	if (cmd->protocol !=3D BSG_PROTOCOL_SCSI ||
 	    cmd->subprotocol !=3D BSG_SUB_PROTOCOL_SCSI_CMD)
 		return -EINVAL;
=20
-	if (!cmd->request || cmd->request_len =3D=3D 0)
+	if (!request || request_len =3D=3D 0)
 		return -EINVAL;
=20
-	if (cmd->dout_xfer_len && cmd->din_xfer_len) {
+	if (dout_xfer_len && din_xfer_len) {
 		pr_warn_once("BIDI support in bsg has been removed.\n");
 		return -EOPNOTSUPP;
 	}
@@ -131,20 +137,20 @@ static int scsi_bsg_uring_cmd(struct request_queue *q=
, struct io_uring_cmd *iouc
 		gfp_mask =3D GFP_NOWAIT;
 	}
=20
-	req =3D scsi_alloc_request(q, cmd->dout_xfer_len ?
+	req =3D scsi_alloc_request(q, dout_xfer_len ?
 				 REQ_OP_DRV_OUT : REQ_OP_DRV_IN, blk_flags);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
=20
 	scmd =3D blk_mq_rq_to_pdu(req);
-	if (cmd->request_len > sizeof(scmd->cmnd)) {
+	if (request_len > sizeof(scmd->cmnd)) {
 		ret =3D -EINVAL;
 		goto out_free_req;
 	}
-	scmd->cmd_len =3D cmd->request_len;
+	scmd->cmd_len =3D request_len;
 	scmd->allowed =3D SG_DEFAULT_RETRIES;
=20
-	if (copy_from_user(scmd->cmnd, uptr64(cmd->request), cmd->request_len)) {
+	if (copy_from_user(scmd->cmnd, uptr64(request), request_len)) {
 		ret =3D -EFAULT;
 		goto out_free_req;
 	}
@@ -155,11 +161,16 @@ static int scsi_bsg_uring_cmd(struct request_queue *q=
, struct io_uring_cmd *iouc
 	}
=20
 	pdu->response_addr =3D cmd->response;
-	scmd->sense_len =3D cmd->max_response_len ?
-		min(cmd->max_response_len, SCSI_SENSE_BUFFERSIZE) : SCSI_SENSE_BUFFERSIZ=
E;
+	pdu->max_response_len =3D cmd->max_response_len;
=20
-	if (cmd->dout_xfer_len || cmd->din_xfer_len) {
-		ret =3D scsi_bsg_map_user_buffer(req, ioucmd, issue_flags, gfp_mask);
+	if (dout_xfer_len || din_xfer_len) {
+		bool is_write =3D dout_xfer_len > 0;
+		u64 buf_addr =3D is_write ? dout_xferp : din_xferp;
+		unsigned long buf_len =3D is_write ? dout_xfer_len : din_xfer_len;
+
+		ret =3D scsi_bsg_map_user_buffer(req, ioucmd, issue_flags,
+					       gfp_mask, is_write, buf_addr,
+					       buf_len);
 		if (ret)
 			goto out_free_req;
 		pdu->bio =3D req->bio;
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/isc=
si_target.c
index 62ada3a52210..124ff269b8e7 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1533,8 +1533,10 @@ __iscsit_check_dataout_hdr(struct iscsit_conn *conn,=
 void *buf,
 		 */
 		if (se_cmd->transport_state & CMD_T_ABORTED) {
 			if (hdr->flags & ISCSI_FLAG_CMD_FINAL &&
-			    --cmd->outstanding_r2ts < 1)
+			    --cmd->outstanding_r2ts < 1) {
 				iscsit_stop_dataout_timer(cmd);
+				target_complete_cmd(se_cmd, SAM_STAT_TASK_ABORTED);
+			}
=20
 			return iscsit_dump_data_payload(conn, payload_length, 1);
 		}
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/isc=
si/iscsi_target_login.c
index aafc94bcb635..c282b6a70296 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -47,7 +47,7 @@ static struct iscsi_login *iscsi_login_init_conn(struct i=
scsit_conn *conn)
 	login->conn =3D conn;
 	login->first_request =3D 1;
=20
-	login->req_buf =3D kzalloc(MAX_KEY_VALUE_PAIRS, GFP_KERNEL);
+	login->req_buf =3D kzalloc(MAX_KEY_VALUE_PAIRS + 1, GFP_KERNEL);
 	if (!login->req_buf) {
 		pr_err("Unable to allocate memory for response buffer.\n");
 		goto out_login;
diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 62396212a0a7..b31c04b5461e 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -715,6 +715,7 @@ static void ufs_qcom_link_startup_post_change(struct uf=
s_hba *hba)
 static int ufs_qcom_link_startup_notify(struct ufs_hba *hba,
 					enum ufs_notify_change_status status)
 {
+	struct ufs_qcom_host *host =3D ufshcd_get_variant(hba);
 	int err =3D 0;
=20
 	switch (status) {
@@ -737,6 +738,14 @@ static int ufs_qcom_link_startup_notify(struct ufs_hba=
 *hba,
 		 */
 		err =3D ufshcd_disable_host_tx_lcc(hba);
=20
+		/*
+		 * Restore HS/LS link startup mode set by bootloader
+		 * after UFS reset clears REG_UFS_DEBUG_SPARE_CFG.
+		 */
+		if (host->hw_ver.major > 0x6 ||
+		    (host->hw_ver.major =3D=3D 0x6 && host->hw_ver.minor >=3D 0x2))
+			ufshcd_writel(hba, host->boot_spare_cfg,
+				      REG_UFS_DEBUG_SPARE_CFG);
 		break;
 	case POST_CHANGE:
 		ufs_qcom_link_startup_post_change(hba);
@@ -1325,7 +1334,7 @@ static void ufs_qcom_advertise_quirks(struct ufs_hba =
*hba)
 static void ufs_qcom_set_phy_gear(struct ufs_qcom_host *host)
 {
 	struct ufs_host_params *host_params =3D &host->host_params;
-	u32 val, dev_major;
+	u32 dev_major;
=20
 	/*
 	 * Default to powering up the PHY to the max gear possible, which is
@@ -1344,8 +1353,8 @@ static void ufs_qcom_set_phy_gear(struct ufs_qcom_hos=
t *host)
 		 */
 		host->phy_gear =3D UFS_HS_G2;
 	} else if (host->hw_ver.major >=3D 0x5) {
-		val =3D ufshcd_readl(host->hba, REG_UFS_DEBUG_SPARE_CFG);
-		dev_major =3D FIELD_GET(UFS_DEV_VER_MAJOR_MASK, val);
+		host->boot_spare_cfg =3D ufshcd_readl(host->hba, REG_UFS_DEBUG_SPARE_CFG=
);
+		dev_major =3D FIELD_GET(UFS_DEV_VER_MAJOR_MASK, host->boot_spare_cfg);
=20
 		/*
 		 * Since the UFS device version is populated, let's remove the
@@ -2282,7 +2291,7 @@ static void ufs_qcom_config_scaling_param(struct ufs_=
hba *hba,
 	p->polling_ms =3D 60;
 	p->timer =3D DEVFREQ_TIMER_DELAYED;
 	d->upthreshold =3D 70;
-	d->downdifferential =3D 5;
+	d->downdifferential =3D 65;
=20
 	hba->clk_scaling.suspend_on_no_request =3D true;
 }
diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
index e20b3ca50577..a5ad5ce44a19 100644
--- a/drivers/ufs/host/ufs-qcom.h
+++ b/drivers/ufs/host/ufs-qcom.h
@@ -361,6 +361,7 @@ struct ufs_qcom_host {
 	bool esi_enabled;
=20
 	u32 saved_tx_eq_g1_setting;
+	u32 boot_spare_cfg;
 };
=20
 struct ufs_qcom_drvdata {
diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
index f2433879b0eb..21bb11c724be 100644
--- a/drivers/ufs/host/ufshcd-pci.c
+++ b/drivers/ufs/host/ufshcd-pci.c
@@ -181,6 +181,25 @@ static int ufs_intel_lkf_pwr_change_notify(struct ufs_=
hba *hba,
 	return err;
 }
=20
+static int ufs_intel_nvl_pwr_change_notify(struct ufs_hba *hba,
+					   enum ufs_notify_change_status stage,
+					   struct ufs_pa_layer_attr *dev_req_params)
+{
+	int adapt_val;
+
+	if (stage !=3D PRE_CHANGE || hba->ufs_version < ufshci_version(4, 0))
+		return 0;
+
+	if (dev_req_params->pwr_tx =3D=3D FAST_MODE || dev_req_params->pwr_tx =3D=
=3D FASTAUTO_MODE)
+		adapt_val =3D PA_INITIAL_ADAPT;
+	else
+		adapt_val =3D PA_NO_ADAPT;
+
+	ufshcd_dme_configure_adapt(hba, dev_req_params->gear_tx, adapt_val);
+
+	return 0;
+}
+
 static int ufs_intel_lkf_apply_dev_quirks(struct ufs_hba *hba)
 {
 	u32 granularity, peer_granularity;
@@ -441,6 +460,43 @@ static int ufs_intel_mtl_init(struct ufs_hba *hba)
 	return ufs_intel_common_init(hba);
 }
=20
+static int ufs_intel_mcq_config_resource(struct ufs_hba *hba)
+{
+	hba->mcq_base =3D hba->mmio_base + ufshcd_mcq_queue_cfg_addr(hba);
+
+	return 0;
+}
+
+/*
+ * This Intel UFS4.0 controller maps MCQ doorbell and interrupt-status
+ * registers into the same PCI BAR as the legacy HCI space, at this
+ * fixed offset/stride.
+ */
+#define UFS_INTEL_SQDAO0	0x2800
+#define UFS_INTEL_SQISAO0	0x2814
+#define UFS_INTEL_CQDAO0	0x281C
+#define UFS_INTEL_CQISAO0	0x2824
+#define UFS_INTEL_MCQ_STRIDE	0x30
+
+static int ufs_intel_op_runtime_config(struct ufs_hba *hba)
+{
+	struct ufshcd_mcq_opr_info_t *opr;
+	int i;
+
+	hba->mcq_opr[OPR_SQD].offset  =3D UFS_INTEL_SQDAO0;
+	hba->mcq_opr[OPR_SQIS].offset =3D UFS_INTEL_SQISAO0;
+	hba->mcq_opr[OPR_CQD].offset  =3D UFS_INTEL_CQDAO0;
+	hba->mcq_opr[OPR_CQIS].offset =3D UFS_INTEL_CQISAO0;
+
+	for (i =3D 0; i < OPR_MAX; i++) {
+		opr =3D &hba->mcq_opr[i];
+		opr->stride =3D UFS_INTEL_MCQ_STRIDE;
+		opr->base =3D hba->mmio_base + opr->offset;
+	}
+
+	return 0;
+}
+
 static int ufs_qemu_get_hba_mac(struct ufs_hba *hba)
 {
 	return MAX_SUPP_MAC;
@@ -527,6 +583,9 @@ static struct ufs_hba_variant_ops ufs_intel_mtl_hba_vop=
s =3D {
 	.exit			=3D ufs_intel_common_exit,
 	.hce_enable_notify	=3D ufs_intel_hce_enable_notify,
 	.link_startup_notify	=3D ufs_intel_link_startup_notify,
+	.pwr_change_notify	=3D ufs_intel_nvl_pwr_change_notify,
+	.mcq_config_resource	=3D ufs_intel_mcq_config_resource,
+	.op_runtime_config	=3D ufs_intel_op_runtime_config,
 	.resume			=3D ufs_intel_resume,
 	.device_reset		=3D ufs_intel_device_reset,
 };
