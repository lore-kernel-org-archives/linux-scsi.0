Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB094FC8ED;
	Fri, 25 Sep 2026 21:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790371376; cv=none; b=WIj6MRtafjcD8v598VEuOSALxzVUVaKiQlCqWDbUyGmvPy93xO3cxYRZgNFYO6rskmrlcWAeM/V/zyoHNZGZ85FtYSzWw///8B94Te/P9EIrbbi9vBuOALaO7UoEnak1ZSu3CFFEtD25l4z0ZaFRcgOli9U+bGAl3K4MHLs6aV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790371376; c=relaxed/simple;
	bh=1jjx419xuWeOE0eWSXfxs94Ts7PrWqRp59TJUaHT/io=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=Ude50+2KPW1vewjCKBNIJQcJZ4XWduXtmiQ52cxmMbWtB/PNoQRV/Z30sAn+FGBmmrFzwqACVHAbU6nfDi4sewSzNc42clDf7KRb44AJml481XK6JgaMIljnJWNn+MRPukSxdp7geD5gdG3XKwUKP2zrf9hDIkOuQw61ke4xBkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=NyDkqU69; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="NyDkqU69"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1790371372;
	bh=1jjx419xuWeOE0eWSXfxs94Ts7PrWqRp59TJUaHT/io=;
	h=Message-ID:Subject:From:To:Date:From;
	b=NyDkqU69Bq3EEhRsifL5FSEN3Km3XtoY/SRlng2CToPh25/h15kyacnaIyK1t0nNQ
	 FiVNvuPMF8TTcoxICzTdCLjVVU8Wi3WO0N4vBvR6GRg3kZFXcLtP76uliVFfUaQ+w1
	 G6MYjfJRpiT7vp3Ymp/41e3OximlbWJhN00MKTC4=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:d341::8309])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id 095DC1C0350;
	Fri, 25 Sep 2026 17:22:52 -0400 (EDT)
Message-ID: <ea8f769b49f7d1185f588cf5b9202f300c280af7.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 7.3-rc4+
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Fri, 25 Sep 2026 17:22:51 -0400
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

The following changes since commit 3d676e458fe0c566f5a62753dc696b6a862fc412=
:

  scsi: core: Validate MODE SENSE lengths in scsi_cdl_enable() (2026-09-09 =
22:23:00 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git/ tags/scsi-=
fixes

for you to fetch changes up to 42d1221d321e55afc7bba9109a77aaf5a817c8a3:

  scsi: megaraid_sas: Protect megasas_get_ctrl_info() in megasas_resume() (=
2026-09-16 21:33:30 -0400)

----------------------------------------------------------------
Mostly small driver fixes.  The biggest fix is the one to the block zone
handling which might trip for real or virtual hardware if the number of
zones is > 2^32.

----------------------------------------------------------------
Arnd Bergmann (1):
      scsi: leapraid: Avoid -Wformat-security warning

Bart Van Assche (1):
      scsi: megaraid_sas: Protect megasas_get_ctrl_info() in megasas_resume=
()

Ewan D. Milne (1):
      scsi: devinfo: Add BLIST_SKIP_IO_HINTS for EMC Symmetrix

Geert Uytterhoeven (1):
      scsi: ufs: pltfrm: Add quirk for R-Car S4 lacking lanes-per-direction

Stanley Jhu (1):
      scsi: ufs: core: Keep internal commands dispatchable during error han=
dling

Yehyeong Lee (1):
      scsi: libiscsi_tcp: Check the data direction of a Data-In PDU

ZHOU Jiaxiang (2):
      scsi: block: Fix zones_cond out-of-bounds write on zone report
      scsi: sd_zbc: Reject disks with too many zones

 block/blk-zoned.c                         | 15 +++++++++++++--
 drivers/scsi/leapraid/leapraid_func.h     |  2 --
 drivers/scsi/leapraid/leapraid_os.c       |  8 +++-----
 drivers/scsi/libiscsi_tcp.c               |  3 +++
 drivers/scsi/megaraid/megaraid_sas_base.c |  4 +++-
 drivers/scsi/scsi_devinfo.c               |  2 +-
 drivers/scsi/sd_zbc.c                     |  8 +++++++-
 drivers/ufs/core/ufshcd.c                 |  6 ++++++
 drivers/ufs/host/ufshcd-pltfrm.c          |  6 +++++-
 9 files changed, 41 insertions(+), 13 deletions(-)

---
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index a5afb842bf35..475aa16bc41a 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -2018,12 +2018,17 @@ static int disk_revalidate_zone_resources(struct ge=
ndisk *disk,
 				struct blk_revalidate_zone_args *args)
 {
 	struct queue_limits *lim =3D &disk->queue->limits;
+	unsigned long long nr_zones;
 	unsigned int pool_size;
 	int ret =3D 0;
=20
 	args->disk =3D disk;
-	args->nr_zones =3D
-		DIV_ROUND_UP_ULL(get_capacity(disk), lim->chunk_sectors);
+	nr_zones =3D DIV_ROUND_UP_ULL(get_capacity(disk), lim->chunk_sectors);
+	if (nr_zones > UINT_MAX) {
+		pr_warn("%s: Too many zones (%llu)\n", disk->disk_name, nr_zones);
+		return -EINVAL;
+	}
+	args->nr_zones =3D nr_zones;
=20
 	/* Cached zone conditions: 1 byte per zone */
 	args->zones_cond =3D kzalloc(args->nr_zones, GFP_NOIO);
@@ -2131,6 +2136,12 @@ static int blk_revalidate_zone_cond(struct blk_zone =
*zone, unsigned int idx,
 {
 	enum blk_zone_cond cond =3D zone->cond;
=20
+	if (idx >=3D args->nr_zones) {
+		pr_warn("%s: Zone report index %u exceeds zone count %u\n",
+			args->disk->disk_name, idx, args->nr_zones);
+		return -EINVAL;
+	}
+
 	/* Check that the zone condition is consistent with the zone type. */
 	switch (cond) {
 	case BLK_ZONE_COND_NOT_WP:
diff --git a/drivers/scsi/leapraid/leapraid_func.h b/drivers/scsi/leapraid/=
leapraid_func.h
index 4c0b9ca728d8..e8a0815bf95f 100644
--- a/drivers/scsi/leapraid/leapraid_func.h
+++ b/drivers/scsi/leapraid/leapraid_func.h
@@ -554,7 +554,6 @@ struct leapraid_fw_evt_work {
 /**
  * struct leapraid_fw_evt_struct - Firmware event handling structure
  *
- * @fw_evt_name: Name of the firmware event.
  * @fw_evt_thread: Workqueue used for processing firmware events.
  * @fw_evt_lock: Spinlock protecting access to the firmware event list.
  * @fw_evt_list: Linked list of pending firmware events.
@@ -565,7 +564,6 @@ struct leapraid_fw_evt_work {
  */
 struct leapraid_fw_evt_struct {
 	u32 leapraid_evt_masks[4];
-	char fw_evt_name[48];
 	struct workqueue_struct *fw_evt_thread;
 	spinlock_t fw_evt_lock; /* protects firmware event */
 	struct list_head fw_evt_list;
diff --git a/drivers/scsi/leapraid/leapraid_os.c b/drivers/scsi/leapraid/le=
apraid_os.c
index ee3242779dfd..507f11862276 100644
--- a/drivers/scsi/leapraid/leapraid_os.c
+++ b/drivers/scsi/leapraid/leapraid_os.c
@@ -2054,12 +2054,10 @@ static int leapraid_probe(struct pci_dev *pdev, con=
st struct pci_device_id *id)
 	shost->transportt =3D leapraid_transport_template;
 	shost->unique_id =3D adapter->adapter_attr.id;
=20
-	snprintf(adapter->fw_evt_s.fw_evt_name,
-		 sizeof(adapter->fw_evt_s.fw_evt_name),
-		 "fw_event_%s%d", LEAPRAID_DRIVER_NAME,
-		 adapter->adapter_attr.id);
 	adapter->fw_evt_s.fw_evt_thread =3D
-		alloc_ordered_workqueue(adapter->fw_evt_s.fw_evt_name, 0);
+		alloc_ordered_workqueue("fw_event_%s%d", 0,
+					LEAPRAID_DRIVER_NAME,
+					adapter->adapter_attr.id);
 	if (!adapter->fw_evt_s.fw_evt_thread) {
 		dev_err(&adapter->pdev->dev,
 			"%s: Failed to create fw event workqueue\n", __func__);
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 7223bb18b048..d35f93451ee9 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -480,6 +480,9 @@ static int iscsi_tcp_data_in(struct iscsi_conn *conn, s=
truct iscsi_task *task)
 	int datasn =3D be32_to_cpu(rhdr->datasn);
 	unsigned total_in_length =3D task->sc->sdb.length;
=20
+	if (task->sc->sc_data_direction !=3D DMA_FROM_DEVICE)
+		return ISCSI_ERR_PROTO;
+
 	/*
 	 * lib iscsi will update this in the completion handling if there
 	 * is status.
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megar=
aid/megaraid_sas_base.c
index b95f187297ae..4f9a53769966 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -7886,7 +7886,9 @@ megasas_resume(struct device *dev)
 			goto fail_init_mfi;
 	}
=20
-	if (megasas_get_ctrl_info(instance) !=3D DCMD_SUCCESS)
+	scoped_guard(mutex, &instance->reset_mutex)
+		rval =3D megasas_get_ctrl_info(instance);
+	if (rval !=3D DCMD_SUCCESS)
 		goto fail_init_mfi;
=20
 	tasklet_init(&instance->isr_tasklet, instance->instancet->tasklet,
diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 15ffbe93ac72..88a911b35c94 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -161,7 +161,7 @@ static struct {
 	{"DGC", "DISK", NULL, BLIST_SPARSELUN},	/* EMC CLARiiON, no storage on LU=
N 0 */
 	{"EMC",  "Invista", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"EMC", "SYMMETRIX", NULL, BLIST_SPARSELUN | BLIST_LARGELUN |
-	 BLIST_REPORTLUN2 | BLIST_RETRY_ITF},
+	 BLIST_REPORTLUN2 | BLIST_RETRY_ITF | BLIST_SKIP_IO_HINTS},
 	{"EMULEX", "MD21/S2     ESDI", NULL, BLIST_SINGLELUN},
 	{"easyRAID", "16P", NULL, BLIST_NOREPORTLUN},
 	{"easyRAID", "X6P", NULL, BLIST_NOREPORTLUN},
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 56e455fb5add..456beaf2e769 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -589,7 +589,7 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
 int sd_zbc_read_zones(struct scsi_disk *sdkp, struct queue_limits *lim,
 		u8 buf[SD_BUF_SIZE])
 {
-	unsigned int nr_zones;
+	u64 nr_zones;
 	u32 zone_blocks =3D 0;
 	int ret;
=20
@@ -621,6 +621,12 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, struct q=
ueue_limits *lim,
 		goto err;
=20
 	nr_zones =3D round_up(sdkp->capacity, zone_blocks) >> ilog2(zone_blocks);
+	if (nr_zones > INT_MAX) {
+		sd_printk(KERN_ERR, sdkp, "Too many zones (%llu)\n",
+			  nr_zones);
+		ret =3D -EINVAL;
+		goto err;
+	}
 	sdkp->early_zone_info.nr_zones =3D nr_zones;
 	sdkp->early_zone_info.zone_blocks =3D zone_blocks;
=20
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 2ba244cf40ac..54f4e7d7de02 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6817,11 +6817,17 @@ static void ufshcd_err_handling_prepare(struct ufs_=
hba *hba)
 	}
 	/* Wait for ongoing ufshcd_queuecommand() calls to finish. */
 	blk_mq_quiesce_tagset(&hba->host->tag_set);
+	/*
+	 * Internal commands are submitted on the pseudo SCSI device. Let them
+	 * through so that the error handler can recover the link.
+	 */
+	blk_mq_unquiesce_queue(hba->host->pseudo_sdev->request_queue);
 	cancel_work_sync(&hba->eeh_work);
 }
=20
 static void ufshcd_err_handling_unprepare(struct ufs_hba *hba)
 {
+	blk_mq_quiesce_queue_nowait(hba->host->pseudo_sdev->request_queue);
 	blk_mq_unquiesce_tagset(&hba->host->tag_set);
 	ufshcd_release(hba);
 	if (ufshcd_is_clkscaling_supported(hba))
diff --git a/drivers/ufs/host/ufshcd-pltfrm.c b/drivers/ufs/host/ufshcd-plt=
frm.c
index 5ac7afe75934..169dbc1a75fe 100644
--- a/drivers/ufs/host/ufshcd-pltfrm.c
+++ b/drivers/ufs/host/ufshcd-pltfrm.c
@@ -206,7 +206,11 @@ static void ufshcd_init_lanes_per_dir(struct ufs_hba *=
hba)
 		dev_dbg(hba->dev,
 			"%s: failed to read lanes-per-direction, ret=3D%d\n",
 			__func__, ret);
-		hba->lanes_per_direction =3D UFSHCD_DEFAULT_LANES_PER_DIRECTION;
+		/* Old R-Car S4 DTBs lack "lanes-per-direction =3D <1>" */
+		if (of_device_is_compatible(dev->of_node, "renesas,r8a779f0-ufs"))
+			hba->lanes_per_direction =3D 1;
+		else
+			hba->lanes_per_direction =3D UFSHCD_DEFAULT_LANES_PER_DIRECTION;
 	}
 }
=20
