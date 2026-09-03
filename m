Received: from alln-iport-7.cisco.com (alln-iport-7.cisco.com [173.37.142.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905A1412C08
	for <linux-scsi@vger.kernel.org>; Thu,  3 Sep 2026 18:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.142.94
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788458749; cv=none; b=pvY9UVnGDEsN4LPgPDw9bR948O3k5RHIbqQX15le6G0mp+URBbOHrMjGPRBFjuONHylJ14y7VmUyhqPHr2NatgRg0LW/9FbaJLEp4ObKBgaAut/WY3o+eJzQNrVOCHEklv6y+aquTNHTUDudjBiiOTa7SBr5u9ZM8gb3HSE4Lhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788458749; c=relaxed/simple;
	bh=4I5ORS/Ub291+o+clCew30WQBOIoPo0WyvTsMIpaVCo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kWMQ25knJbMUMtVRhR3uqBsp63Y36MGTUVLe8Wyx56ORTk8d0C2M48c04B8c5mggxCYP1xt167gteR1n7oOCmV8Wj71+FE8XfCr6snlodoSsMzAkj7C+8cjZxStYAatCAMlLueMXSA4ezs0AAXOArBShgZsFBMB1jnGPEU99WnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=EPM+IDtq; arc=none smtp.client-ip=173.37.142.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="EPM+IDtq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=4750; q=dns/txt;
  s=iport01; t=1788458747; x=1789668347;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+gbYZQj5GiCyKjBAkWLCsuRahYfVxBkXbIK3vQFeYmY=;
  b=EPM+IDtqt/Tb6+AidN8XqMIQMweAPp1RfaL8dOEd3pGHhvFwj2+2HWyx
   1/F9z8oob6vx5/AtJnYcjJQee6sA+opXkGX7P9iD7A0gvD/D/KuZxXnoV
   wSwd9jglWTIIss3bUROVBOZk6fhTALfbr7Dp8KzsWhPOauIh9NHAQBeVr
   zQKn5BjJC6P6jmgjfcLrbpcNOVCRluIZZ5+9VR+XtRFLeJ2ccYNMF/rPP
   cYhT94bVoHmu26T4Xh36O+gkzercPmsfE2SkgVmTba3RtGkso8Rf0yhbf
   NsJqLGcZti7AsMuHqtULlpSznQSITwkkoZFYilo3ZuoZT6eyVAJYj1/Qr
   g==;
X-CSE-ConnectionGUID: SJpUee64Rqasmq1u75zx7g==
X-CSE-MsgGUID: Gl2ndB6wSUKMgdLhlcShzQ==
X-IPAS-Result: =?us-ascii?q?A0A/AgCxtZlq/4oQJK1aHgEBCxIMggULgleBVEMZMJZKg?=
 =?us-ascii?q?RadCIF+DwEBAQ9RBAEBhQWOAgImNAkOAQIEAwIDAQEBAQEBAQEBAQELAQEFA?=
 =?us-ascii?q?QEBAgEHBYEOE4ZckBwrCwFGgVCDAoJ1A8BtgXkzgQHeR4FnAQsUAYE4jWGFc?=
 =?us-ascii?q?icbgUlEgRQBgTuBOAdvgVKJNgSDLpNoSIEeA1ksAVUTDQoLBwWBZgM1EioVb?=
 =?us-ascii?q?jIdgSM+F4ENGwYFgR2BJ4M/Ixk2eoEJXoErKWABEheBCYIIAoJUggUCAUlDD?=
 =?us-ascii?q?gdHUwkYDzwLGA1IESw3FRkEPm4HjmEfglAtBCk1eyMQDVgsKZMdkVR0gTWfW?=
 =?us-ascii?q?oQooVwaM5dfkw0BmQijPDYPWYRpgWg8gVkzGggbFYMiUxkPji4WHM99JzI9A?=
 =?us-ascii?q?gcCBw4DC5NmAQE?=
IronPort-Data: A9a23:SFY9RK8v08ZGDKPZBFXTDrUDU3+TJUtcMsCJ2f8bNWPcYEJGY0x3y
 TAbWGyBP/zZamv3ctx/PYi+phwGsMXQzoUwQQs+rCFEQiMRo6IpJzg2wmQcns+2BpeeJK6yx
 5xGMrEsFOhtEDmE4EzrauS9xZVF/fngbqLmD+LZMTxGSwZhSSMw4TpugOdRbrRA2bBVOCvT/
 4mvyyHjEAX9gWAsYzpPs/7rRC5H5ZwehhtJ5jTSWtgT1LPuvyF9JI4SI6i3M0z5TuF8dsamR
 /zOxa2O5WjQ+REgELuNyt4XpWVTH9Y+lSDX4pZnc/DKbipq/0Te4Y5nXBYoUnq7vh3S9zxHJ
 HqhgrTrIeshFvWkdO3wyHC0GQkmVUFN0OevzXRSLaV/wmWeG0YAzcmCA2kNH5Ul9+spXVtX/
 OcdMWkQMU2Rl725lefTpulE3qzPLeHiOIcZ/3UlxjbDALN+GNbIQr7B4plT2zJYasJmRKmFI
 ZFHL2MxKk2bM3WjOX9PYH46tO6lj2L+WzZZs1mS46Ew5gA/ySQhiuizYICNJYHiqcN9sULCo
 G7soXvCPzI/O9C7yT6OyXK+v7qa9c/8cMdIfFGizdZojV+Z7mgSDgAGE1qxpL+yjUvWc9dWM
 VAV/Gw2oLQ/7lemSPH6RRSzpHPCtRkZM/JZH+Q57xmK14LO7gqZD3RCRTlEAPQkscIwSDMq1
 3eTkt/pDCApu7qQIVqZ8b2Ztza7PwAPIGMCbDNCRgwAi/H5rZ8+lAnnVNtvEKepyNbyHFnYx
 zyXqiM3gZ0IkNUGka68+DjvhzOqu4iMVQUu5y3JUW+/qAB0foioY8qv81ez0BpbBI+dSl/Eu
 D0PnNKTqbhXS5qMjyeKBu4KGdlF+sq4DdEVunY3d7FJythn0yfLkVx4iN2mGHpUDw==
IronPort-HdrOrdr: A9a23:3g9346pmwvfTET4Aah4iyoEaV5r1eYIsimQD101hICG9vPb1qy
 nIpoV46faaslgssR0b8+xoW5PwIk80l6QV3WB5B97LNzUO01HGEGgN1+bf6gylMzHi9+JbyK
 dre7VzBZnNF1Rg5PyKhTVQa+xB/PC3tIa1mOzZ03BhCStua61m8kNFLzzzKDwTeOGDbqBJcq
 Z1IaF81l2dRUg=
X-Talos-CUID: 9a23:cBwbzG6lYAxpLkz3wNssz2wMJ80oLCHn1X7LJlbhFDk0Wq3KRgrF
X-Talos-MUID: =?us-ascii?q?9a23=3AE/K80w8NbHG1CrNU2Q3VVE+Qf+hsuaKiIh4Sqqg?=
 =?us-ascii?q?lnsaIESx0MAydng3iFw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.25,260,1779148800"; 
   d="scan'208";a="828682075"
Received: from alln-l-core-01.cisco.com ([173.36.16.138])
  by alln-iport-7.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 03 Sep 2026 18:04:38 +0000
Received: from localhost.cisco.com (unknown [172.25.138.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: aeasi@cisco.com)
	by alln-l-core-01.cisco.com (Postfix) with ESMTPSA id 53DE11800019B;
	Thu,  3 Sep 2026 18:04:37 +0000 (GMT)
From: Arun Easi <aeasi@cisco.com>
To: sebaddel@cisco.com
Cc: arulponn@cisco.com,
	djhawar@cisco.com,
	gcboffa@cisco.com,
	mkai2@cisco.com,
	satishkh@cisco.com,
	kartilak@cisco.com,
	jejb@linux.ibm.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	jmeneghi@redhat.com,
	revers@redhat.com,
	loberman@redhat.com,
	adakopou@redhat.com,
	lduncan@suse.com
Subject: [PATCH] scsi: fnic: Fix missed link-up when a critical IRQ targets an offline CPU
Date: Thu,  3 Sep 2026 10:55:47 -0700
Message-ID: <20260903175547.57971-1-aeasi@cisco.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: aeasi@cisco.com
X-Outbound-Client-TLS: ANONYMOUS;unknown [172.25.138.101];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 172.25.138.101, [172.25.138.101]
X-Outbound-Node: alln-l-core-01.cisco.com

When CPU Hyper-Threading is disabled, sibling CPUs remain present but
are reported offline. Managed MSI-X IRQs can still receive affinity
masks that include those offline CPUs. If a driver-critical vector is
managed, it can be parked on an offline CPU and the driver may miss
critical events such as link-up.

Keep driver-critical vectors unmanaged so they can be migrated by the
IRQ core when their target CPU is offlined.

Since HWQ-0 is unmanaged now, in some queue combinations there can be no
mappings to it in mq_map. So without the blk-mq fix mentioned below,
system may crash during cpu offline/online tests.

Fixes: 8a8449ca5e33 ("scsi: fnic: Modify ISRs to support multiqueue (MQ)")
Cc: stable@vger.kernel.org
Depends-on: commit 10845a105bbc ("blk-mq: skip CPU offline notify on unmapped hctx")
Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Karan Tilak Kumar <kartilak@cisco.com>
Signed-off-by: Arun Easi <aeasi@cisco.com>
---
 drivers/scsi/fnic/fnic.h      |  2 +-
 drivers/scsi/fnic/fnic_isr.c  | 13 ++++++++---
 drivers/scsi/fnic/fnic_main.c | 41 ++++++++++++++++++++++++++++++++++-
 3 files changed, 51 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index c576a7f5083e..3ba1592940ca 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -31,7 +31,7 @@
 
 #define DRV_NAME		"fnic"
 #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
-#define DRV_VERSION		"1.9.0.0"
+#define DRV_VERSION		"1.9.0.1"
 #define PFX			DRV_NAME ": "
 #define DFX                     DRV_NAME "%d: "
 
diff --git a/drivers/scsi/fnic/fnic_isr.c b/drivers/scsi/fnic/fnic_isr.c
index 02856745580f..43149d8312ec 100644
--- a/drivers/scsi/fnic/fnic_isr.c
+++ b/drivers/scsi/fnic/fnic_isr.c
@@ -245,7 +245,14 @@ int fnic_set_intr_mode_msix(struct fnic *fnic)
 	unsigned int m = ARRAY_SIZE(fnic->wq);
 	unsigned int o = ARRAY_SIZE(fnic->hw_copy_wq);
 	unsigned int min_irqs = n + m + 1 + 1; /*rq, raw wq, wq, err*/
-
+	/*
+	 * Make driver critical vectors unmanaged, or else it can get tied
+	 * to an offline CPU. This can happen when hyper-threading is off.
+	 */
+	struct irq_affinity affd = {
+		.pre_vectors = n + m + 1, /* rq, raw wq, 1 ioq */
+		.post_vectors = 1, /* err */
+	};
 	/*
 	 * We need n RQs, m WQs, o Copy WQs, n+m+o CQs, and n+m+o+1 INTRs
 	 * (last INTR is used for WQ/RQ errors and notification area)
@@ -263,8 +270,8 @@ int fnic_set_intr_mode_msix(struct fnic *fnic)
 		int vec_count = 0;
 		int vecs = fnic->rq_count + fnic->raw_wq_count + fnic->wq_copy_count + 1;
 
-		vec_count = pci_alloc_irq_vectors(fnic->pdev, min_irqs, vecs,
-					PCI_IRQ_MSIX | PCI_IRQ_AFFINITY);
+		vec_count = pci_alloc_irq_vectors_affinity(fnic->pdev, min_irqs,
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
 
+static void fnic_mq_init_queue_map(struct fnic *fnic,
+		struct blk_mq_queue_map *qmap)
+{
+	unsigned int cpu;
+
+	for_each_possible_cpu(cpu)
+		qmap->mq_map[cpu] = 0;
+}
+
 void fnic_mq_map_queues_cpus(struct Scsi_Host *host)
 {
+	const struct cpumask *mask;
+	unsigned int queue, cpu;
 	struct fnic *fnic = *((struct fnic **) shost_priv(host));
 	struct pci_dev *l_pdev = fnic->pdev;
 	int intr_mode = fnic->config.intr_mode;
@@ -766,7 +777,35 @@ void fnic_mq_map_queues_cpus(struct Scsi_Host *host)
 		return;
 	}
 
-	blk_mq_map_hw_queues(qmap, &l_pdev->dev, FNIC_PCI_OFFSET);
+	fnic_mq_init_queue_map(fnic, qmap);
+
+	/*
+	 * Setup CPU to Queue mapping for all managed MSI-X IRQs.
+	 * Q0 is driver critical and non-managed, hence start from Q1.
+	 */
+	for (queue = 1; queue < qmap->nr_queues; queue++) {
+		int irq_num = pci_irq_vector(fnic->pdev,
+					     queue + FNIC_PCI_OFFSET);
+
+		if (irq_num < 0)
+			continue;
+
+		mask = pci_irq_get_affinity(fnic->pdev,
+					    queue + FNIC_PCI_OFFSET);
+		if (!mask) {
+			shost_printk(KERN_ERR, host,
+				"failed to get irq_affinity map for queue:%d\n", irq_num);
+			continue;
+		}
+		FNIC_MAIN_DBG(KERN_INFO, fnic,
+				"got irq_affinity map for %d:\n", irq_num);
+		for_each_cpu(cpu, mask) {
+			qmap->mq_map[cpu] = qmap->queue_offset + queue;
+			FNIC_MAIN_DBG(KERN_INFO, fnic,
+				      "[Q%d] cpu:%d <=> irq:%d\n",
+				      queue, cpu, irq_num);
+		}
+	}
 }
 
 static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
-- 
2.55.0

