Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E9B935DA41;
	Fri, 18 Sep 2026 19:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789759590; cv=none; b=gUHto6ojeNcZBxjppS3aTzfvP1tqd79dHVHIei0toXVwOjc1DdSmRqW2w8NVPu4gFZUScbph8b9em9zfT1CkOHQy6FwgY0es/Xt9r7a3nL51sp0kzvPNU68/zolmhfnk8UYoWHLwxoyXYbWbY7qtL1EvdNV0Z1qlKZj/NHTJjXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789759590; c=relaxed/simple;
	bh=DerffHky16ckkjzbuLiv2bB5lWXY+g3WEzzavx4AyNs=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=nIaFTkNB+brD54AISdXmXcWnZ/l35FfcDMbGaL6ymVn3UbA4+3SGrrE0aGZuxY+itiP4a0OMeRqIqVzRKVBLcszX8KvYOfEyRo1pg1TZffpo1rHLKFkpsRE2SikTuLi6oKhcGbBFvCcQZphX8WGtctRO3Qm60R7ksIsxkjDbAAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=tjzBGw9P; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="tjzBGw9P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1789759584;
	bh=DerffHky16ckkjzbuLiv2bB5lWXY+g3WEzzavx4AyNs=;
	h=Message-ID:Subject:From:To:Date:From;
	b=tjzBGw9PvDxw2I8ofN0PwmvZv7fzi8Gp5QHF1G8vYq5vcEH6xafthOXxyUbCO4y1h
	 khfY6JCYscxTIKbNJOIXxOrJ6ijcZKSNiYF38jzwlZzmA2tatv9wKeRUqnDBCfnhUR
	 4OHTsenvtAf5ujFOVnXHdPSeAjXBdD8Q1rBoBoOs=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:d341::8309])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id D9A7A1C0413;
	Fri, 18 Sep 2026 15:26:23 -0400 (EDT)
Message-ID: <71da251528b9af2948fb5a4c8bcd045e65b3e42e.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 7.3-rc3+
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Fri, 18 Sep 2026 15:26:23 -0400
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

The following changes since commit af8c27375733fb6a6df9fa484cda77cc3dd0cb80=
:

  scsi: megaraid_sas: Limit NVMe request size to the PRP chain frame (2026-=
09-02 12:13:15 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git/ tags/scsi-=
fixes

for you to fetch changes up to 3d676e458fe0c566f5a62753dc696b6a862fc412:

  scsi: core: Validate MODE SENSE lengths in scsi_cdl_enable() (2026-09-09 =
22:23:00 -0400)

----------------------------------------------------------------
Four driver fixes, three of which are minor and one of which (fnic)
tries to add some logic to try to avoid MSI-X being ineffective if
hyperthreading is disabled.  The core fix adds validation to mode sense
buffer sizes because it is used by ATA and could, theoretically, be
exploited by a specially crafted USB device that can simply be plugged
in to any laptop or server.

----------------------------------------------------------------
Alberto Carboneri (1):
      scsi: core: Validate MODE SENSE lengths in scsi_cdl_enable()

Arun Easi (1):
      scsi: fnic: Fix missed link-up when critical IRQ targets offline CPU

Karl Mehltretter (2):
      scsi: pm80xx: Fix the use_msix, use_tasklet and read_wwn parameter de=
scriptions
      scsi: qla2xxx: Fix the ql2xfc2target parameter description

Venkat Rao Bagalkote (1):
      scsi: ibmvfc: Add Kconfig dependency to fix link failure when NVME_FC=
=3Dm

 drivers/scsi/Kconfig              |  1 +
 drivers/scsi/fnic/fnic.h          |  2 +-
 drivers/scsi/fnic/fnic_isr.c      | 13 ++++++++++---
 drivers/scsi/fnic/fnic_main.c     | 41 +++++++++++++++++++++++++++++++++++=
+++-
 drivers/scsi/pm8001/pm8001_init.c |  6 +++---
 drivers/scsi/qla2xxx/qla_os.c     |  2 +-
 drivers/scsi/scsi.c               | 24 ++++++++++++++++++-----
 7 files changed, 75 insertions(+), 14 deletions(-)

---

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 4a2af0f702e1..1eec66195cf4 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -753,6 +753,7 @@ config SCSI_IBMVFC
 	tristate "IBM Virtual FC support"
 	depends on PPC_PSERIES && SCSI
 	depends on SCSI_FC_ATTRS
+	depends on NVME_FC || NVME_FC=3Dn
 	help
 	  This is the IBM POWER Virtual FC Client
=20
diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index c576a7f5083e..3ba1592940ca 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -31,7 +31,7 @@
=20
 #define DRV_NAME		"fnic"
 #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
-#define DRV_VERSION		"1.9.0.0"
+#define DRV_VERSION		"1.9.0.1"
 #define PFX			DRV_NAME ": "
 #define DFX                     DRV_NAME "%d: "
=20
diff --git a/drivers/scsi/fnic/fnic_isr.c b/drivers/scsi/fnic/fnic_isr.c
index 02856745580f..43149d8312ec 100644
--- a/drivers/scsi/fnic/fnic_isr.c
+++ b/drivers/scsi/fnic/fnic_isr.c
@@ -245,7 +245,14 @@ int fnic_set_intr_mode_msix(struct fnic *fnic)
 	unsigned int m =3D ARRAY_SIZE(fnic->wq);
 	unsigned int o =3D ARRAY_SIZE(fnic->hw_copy_wq);
 	unsigned int min_irqs =3D n + m + 1 + 1; /*rq, raw wq, wq, err*/
-
+	/*
+	 * Make driver critical vectors unmanaged, or else it can get tied
+	 * to an offline CPU. This can happen when hyper-threading is off.
+	 */
+	struct irq_affinity affd =3D {
+		.pre_vectors =3D n + m + 1, /* rq, raw wq, 1 ioq */
+		.post_vectors =3D 1, /* err */
+	};
 	/*
 	 * We need n RQs, m WQs, o Copy WQs, n+m+o CQs, and n+m+o+1 INTRs
 	 * (last INTR is used for WQ/RQ errors and notification area)
@@ -263,8 +270,8 @@ int fnic_set_intr_mode_msix(struct fnic *fnic)
 		int vec_count =3D 0;
 		int vecs =3D fnic->rq_count + fnic->raw_wq_count + fnic->wq_copy_count +=
 1;
=20
-		vec_count =3D pci_alloc_irq_vectors(fnic->pdev, min_irqs, vecs,
-					PCI_IRQ_MSIX | PCI_IRQ_AFFINITY);
+		vec_count =3D pci_alloc_irq_vectors_affinity(fnic->pdev, min_irqs,
+			    vecs, PCI_IRQ_MSIX|PCI_IRQ_AFFINITY, &affd);
 		FNIC_ISR_DBG(KERN_INFO, fnic,
 					"allocated %d MSI-X vectors\n",
 					vec_count);
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 9b3025007075..f13c381a66d7 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -744,8 +744,19 @@ static int fnic_nvme_drv_init(struct fnic *fnic)
 	return ret;
 }
=20
+static void fnic_mq_init_queue_map(struct fnic *fnic,
+		struct blk_mq_queue_map *qmap)
+{
+	unsigned int cpu;
+
+	for_each_possible_cpu(cpu)
+		qmap->mq_map[cpu] =3D 0;
+}
+
 void fnic_mq_map_queues_cpus(struct Scsi_Host *host)
 {
+	const struct cpumask *mask;
+	unsigned int queue, cpu;
 	struct fnic *fnic =3D *((struct fnic **) shost_priv(host));
 	struct pci_dev *l_pdev =3D fnic->pdev;
 	int intr_mode =3D fnic->config.intr_mode;
@@ -766,7 +777,35 @@ void fnic_mq_map_queues_cpus(struct Scsi_Host *host)
 		return;
 	}
=20
-	blk_mq_map_hw_queues(qmap, &l_pdev->dev, FNIC_PCI_OFFSET);
+	fnic_mq_init_queue_map(fnic, qmap);
+
+	/*
+	 * Setup CPU to Queue mapping for all managed MSI-X IRQs.
+	 * Q0 is driver critical and non-managed, hence start from Q1.
+	 */
+	for (queue =3D 1; queue < qmap->nr_queues; queue++) {
+		int irq_num =3D pci_irq_vector(fnic->pdev,
+					     queue + FNIC_PCI_OFFSET);
+
+		if (irq_num < 0)
+			continue;
+
+		mask =3D pci_irq_get_affinity(fnic->pdev,
+					    queue + FNIC_PCI_OFFSET);
+		if (!mask) {
+			shost_printk(KERN_ERR, host,
+				"failed to get irq_affinity map for queue:%d\n", irq_num);
+			continue;
+		}
+		FNIC_MAIN_DBG(KERN_INFO, fnic,
+				"got irq_affinity map for %d:\n", irq_num);
+		for_each_cpu(cpu, mask) {
+			qmap->mq_map[cpu] =3D qmap->queue_offset + queue;
+			FNIC_MAIN_DBG(KERN_INFO, fnic,
+				      "[Q%d] cpu:%d <=3D> irq:%d\n",
+				      queue, cpu, irq_num);
+		}
+	}
 }
=20
 static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *en=
t)
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001=
_init.c
index 54b35893261a..5af81c73a8f8 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -58,15 +58,15 @@ MODULE_PARM_DESC(link_rate, "Enable link rate.\n"
=20
 bool pm8001_use_msix =3D true;
 module_param_named(use_msix, pm8001_use_msix, bool, 0444);
-MODULE_PARM_DESC(zoned, "Use MSIX interrupts. Default: true");
+MODULE_PARM_DESC(use_msix, "Use MSIX interrupts. Default: true");
=20
 static bool pm8001_use_tasklet =3D true;
 module_param_named(use_tasklet, pm8001_use_tasklet, bool, 0444);
-MODULE_PARM_DESC(zoned, "Use MSIX interrupts. Default: true");
+MODULE_PARM_DESC(use_tasklet, "Use tasklets for interrupt handling. Defaul=
t: true");
=20
 static bool pm8001_read_wwn =3D true;
 module_param_named(read_wwn, pm8001_read_wwn, bool, 0444);
-MODULE_PARM_DESC(zoned, "Get WWN from the controller. Default: true");
+MODULE_PARM_DESC(read_wwn, "Get WWN from the controller. Default: true");
=20
 uint pcs_event_log_severity =3D 0x03;
 module_param(pcs_event_log_severity, int, 0644);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index c0efdbff5da7..3c412c7fb6fe 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -352,7 +352,7 @@ MODULE_PARM_DESC(ql2xnvme_queues,
=20
 int ql2xfc2target =3D 1;
 module_param(ql2xfc2target, int, 0444);
-MODULE_PARM_DESC(qla2xfc2target,
+MODULE_PARM_DESC(ql2xfc2target,
 		  "Enables FC2 Target support. "
 		  "0 - FC2 Target support is disabled. "
 		  "1 - FC2 Target support is enabled (default).");
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 76cdad063f7b..f285521d9de6 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -727,6 +727,7 @@ int scsi_cdl_enable(struct scsi_device *sdev, bool enab=
le)
 		struct scsi_mode_data data;
 		struct scsi_sense_hdr sshdr;
 		char *buf_data;
+		size_t avail, offset;
 		int len;
=20
 		ret =3D scsi_mode_sense(sdev, 0x08, 0x0a, 0xf2, buf, sizeof(buf),
@@ -735,11 +736,24 @@ int scsi_cdl_enable(struct scsi_device *sdev, bool en=
able)
 			return -EINVAL;
=20
 		/* Enable or disable CDL using the ATA feature page */
-		len =3D min_t(size_t, sizeof(buf),
-			    data.length - data.header_length -
-			    data.block_descriptor_length);
-		buf_data =3D buf + data.header_length +
-			data.block_descriptor_length;
+		avail =3D min_t(size_t, data.length, sizeof(buf));
+		if (data.header_length > avail)
+			return -EINVAL;
+
+		offset =3D data.header_length;
+		avail -=3D data.header_length;
+
+		if (data.block_descriptor_length > avail)
+			return -EINVAL;
+
+		offset +=3D data.block_descriptor_length;
+		avail -=3D data.block_descriptor_length;
+
+		if (avail < 5)
+			return -EINVAL;
+
+		buf_data =3D buf + offset;
+		len =3D avail;
=20
 		/*
 		 * If we want to enable CDL and CDL is already enabled on the
