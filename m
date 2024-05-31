Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C0778297
	for <linux-scsi@vger.kernel.org>; Fri, 31 May 2024 21:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717191271; cv=none; b=sgDfLqEtV6mceaJ18JueKQFnhnI+fqqcgHNNNOFS75iwtopdeLp8X8x1j3wFMwoe0YY2dTTJw6x8T0BxgJFatp+R29LRRMH2cCD6zA+oiwiP4iUjNaPZVlwMqrgL2onzyiojBy7cq6RgU3zWH3HnKLvcw2CMB1o9ZyGNJJzfuC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717191271; c=relaxed/simple;
	bh=GQCNueVU/9ZOo06IRCXUFDNPZm/J7Rk/p9IGD9D1TlY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=U3KFQvIbzjfzKa5JkapjRT5MSPfnGphxdI0ULHpBMMBAVAVbqUIr1SS0IG/O+uZwpV6doNr/tV9oSlPvQ9FYGAlF7xMYI+F95gv9m+j/1zagr1y09Uawm5swUMrMavumdYDuaqDmbxp+3aKuIKJNyK1AelU2tveRnwoBsQQbNLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=rpGW0ysu; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="rpGW0ysu"
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240531213427epoutp03b07ca6966e0d3353c3cc3d4f7cd3cf87~UsFwolYRA2046020460epoutp03Z
	for <linux-scsi@vger.kernel.org>; Fri, 31 May 2024 21:34:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240531213427epoutp03b07ca6966e0d3353c3cc3d4f7cd3cf87~UsFwolYRA2046020460epoutp03Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1717191267;
	bh=np+kZDwq54J+RLGtokzPjJwKIlHLVeCMqvllwQS11sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rpGW0ysumc+i0/MQ4eyWwah23BRw9p8dFcO4+1M7sNQdW8IOKQgJbvq/gaKJqx2bq
	 +QdF8to09L2LSCMovP7HQAAEHepDU8ib/Oh1bjf2izy+sLi76NwDS3pYgDel9uYjIi
	 y4RaEx3knvkNOGKW1r4MQ7Jrvq1ojX7MgN/xvo+k=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTP id
	20240531213426epcas2p26603886d9d90d1a9a8f85c7df0f25160~UsFvxCZEP3087230872epcas2p2C;
	Fri, 31 May 2024 21:34:26 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.36.100]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4Vrbwy0sZjz4x9Pr; Fri, 31 May
	2024 21:34:26 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
	epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
	77.EC.09806.1624A566; Sat,  1 Jun 2024 06:34:26 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
	20240531213425epcas2p2d6291fd4547354afbb067c27b7d1e12f~UsFuE6cHR3087230872epcas2p2-;
	Fri, 31 May 2024 21:34:25 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240531213425epsmtrp13ecf70e911f7bfcda4e88425d6b2a5ed~UsFuEErl70490304903epsmtrp1i;
	Fri, 31 May 2024 21:34:25 +0000 (GMT)
X-AuditID: b6c32a47-ecbfa7000000264e-98-665a426190d4
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	49.C7.18846.0624A566; Sat,  1 Jun 2024 06:34:24 +0900 (KST)
Received: from localhost.dsn.sec.samsung.com (unknown [10.229.54.230]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240531213424epsmtip2a6f06c9196e78f18a66cac65b4c5083f~UsFt1aYrm1666216662epsmtip2d;
	Fri, 31 May 2024 21:34:24 +0000 (GMT)
From: Minwoo Im <minwoo.im@samsung.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>, Bart Van Assche
	<bvanassche@acm.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman
	<avri.altman@wdc.com>, Minwoo Im <minwoo.im@samsung.com>,
	gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, Jeuk Kim <jeuk20.kim@samsung.com>
Subject: [PATCH v2 1/2] ufs: pci: Add support MCQ for QEMU-based UFS
Date: Sat,  1 Jun 2024 06:22:43 +0900
Message-Id: <20240531212244.1593535-2-minwoo.im@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240531212244.1593535-1-minwoo.im@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNJsWRmVeSWpSXmKPExsWy7bCmqW6SU1SaQcs3JosH87axWbz8eZXN
	YtqHn8wWNw/sZLLY2M9hcX/rNUaLy7vmsFl0X9/BZrH8+D8mi2enDzA7cHlcvuLtMW3SKTaP
	j09vsXj0bVnF6PF5k5xH+4FupgC2qGybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sL
	cyWFvMTcVFslF58AXbfMHKDDlBTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2SqkFKTkF5gV6
	xYm5xaV56Xp5qSVWhgYGRqZAhQnZGZOfexfsUq2Y2HmArYFxj3wXIyeHhICJxJU7h1i6GLk4
	hAR2MEqcPH6MDcL5xCixY+FJFgRn31sWmJbuv0eYIBI7GSWa1kxiBkkICfxmlHjVngtiswmo
	SzRMfQXWICKwmFFi7mo+kAZmgReMEt8WzmMCSQgLuEis2HcczGYRUJWY0/2LEcTmFbCRWDLz
	CTPENnmJ/QfPgtmcArYS77duZ4aoEZQ4OfMJ2AJmoJrmrbOZQRZICPxll1g/eQsTRLOLxNfn
	N6HOFpZ4dXwLO4QtJfGyvw3KLpf4+WYSI4RdIXFw1m1gAHAA2fYS156ngJjMApoS63fpQ0SV
	JY7cgtrKJ9Fx+C87RJhXoqNNCGKGssTHQ4egjpeUWH7pNdQ8D4nzb60goTaBUeL1wcdsExgV
	ZiH5ZRaSX2Yh7F3AyLyKUSy1oDg3PbXYqMAYHr3J+bmbGMGpVMt9B+OMtx/0DjEycTAeYpTg
	YFYS4f2VHpEmxJuSWFmVWpQfX1Sak1p8iNEUGNITmaVEk/OByTyvJN7QxNLAxMzM0NzI1MBc
	SZz3XuvcFCGB9MSS1OzU1ILUIpg+Jg5OqQYmlmXvL6TVrNl7rDCyV8wq99STRa3vNk1KvX7s
	1bXf1pN8VtziOVv8kpd7X1PXhMi6CTOS6hrq5XT6rBsmH+AQL9zx+sjbv0x1u6dc/Lmr5P5G
	ucrp8943qv8+0X7IZr1JaNtVySsVpy5nxiiE5MUW7YjmF0m64Nn4r2Bl34ops9p1Oi4JOW1P
	0zxws1t130LjjZ/uCvJ8btz41N3u5e87MRfPbrNbeL9szokJ6e8/Wwh+fTb3RpaGzupbrrPd
	38Sc+ZuzKXKi8I6tAS+ux3lWnlIvzRY9V3fYxYYlYeXc2WdEL73YECqbeiAwaJNM5OXd2bes
	55hL3UtYaeLrbZpl1Pu7NTr6ZsSqjGUu+615tiixFGckGmoxFxUnAgCzG88vLgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsWy7bCSvG6CU1SawdVuc4sH87axWbz8eZXN
	YtqHn8wWNw/sZLLY2M9hcX/rNUaLy7vmsFl0X9/BZrH8+D8mi2enDzA7cHlcvuLtMW3SKTaP
	j09vsXj0bVnF6PF5k5xH+4FupgC2KC6blNSczLLUIn27BK6Myc+9C3apVkzsPMDWwLhHvouR
	k0NCwESi++8Rpi5GLg4hge2MEnvO3GGHSEhK7Dt9kxXCFpa433KEFaLoJ6PEhjfzmUASbALq
	Eg1TX7GAJEQEFjNKPDn3BsxhFnjHKLF7zwSwKmEBF4kV+46D2SwCqhJzun8xgti8AjYSS2Y+
	YYZYIS+x/+BZMJtTwFbi/dbtYLYQUM3r3dOZIeoFJU7OfMICYjMD1Tdvnc08gVFgFpLULCSp
	BYxMqxhFUwuKc9NzkwsM9YoTc4tL89L1kvNzNzGCg14raAfjsvV/9Q4xMnEwHmKU4GBWEuH9
	lR6RJsSbklhZlVqUH19UmpNafIhRmoNFSZxXOaczRUggPbEkNTs1tSC1CCbLxMEp1cA0T+67
	dnLtpPNykvUWUr0Jd/ZUe6zN4770dZnhbBGrdUzHHhn9u8rZr7KlRCVqxYpcgZlxhnserleY
	eq9wStfClG+tC2N/Hu8xqmG+/kX6gVXIm0BVxZr6z68d1zCfCzBccNw7/lj8rbRg7rtSfX9d
	LN2k3kb7Tz+g2PxoVevsn863D6yasTm91CFD81idnLl6WSWPO8ezQ3YVQlt2Zvd0353L6Pby
	0Pd5iUZeRn6ZW2x4PH50qmzmY73W2J2Qqz0paes3kS/35zrGXktOmh3YdKXif0RphuQ8EU/v
	41W6bM+Zrx58PmNCsUn7vt5Y2ZPvPCf13NevVV98Ts2eefnbX/lmKcGXJOVE61je7FZiKc5I
	NNRiLipOBABuYp416QIAAA==
X-CMS-MailID: 20240531213425epcas2p2d6291fd4547354afbb067c27b7d1e12f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240531213425epcas2p2d6291fd4547354afbb067c27b7d1e12f
References: <20240531212244.1593535-1-minwoo.im@samsung.com>
	<CGME20240531213425epcas2p2d6291fd4547354afbb067c27b7d1e12f@epcas2p2.samsung.com>

Recently, ufs-mcq feature has been introduced to QEMU hw/ufs device [1].
This patch adds MCQ support for upstream QEMU UFS PCI controller.  This
patch provides mandatory vops callbacks to make UFS controller work
properly on MCQ mode.  Operation and Runtime Config register stride is
fixed to 48bytes which is implemented by qemu.

[1] https://lore.kernel.org/qemu-devel/cover.1716876237.git.jeuk20.kim@samsung.com/

Signed-off-by: Minwoo Im <minwoo.im@samsung.com>
---
 drivers/ufs/core/ufs-mcq.c    | 14 ++++++++++
 drivers/ufs/host/ufshcd-pci.c | 48 ++++++++++++++++++++++++++++++++++-
 include/ufs/ufshcd.h          |  1 +
 3 files changed, 62 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 52210c4c20dc..46faa54aea94 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -18,6 +18,7 @@
 #include <linux/iopoll.h>
 
 #define MAX_QUEUE_SUP GENMASK(7, 0)
+#define QCFGPTR GENMASK(23, 16)
 #define UFS_MCQ_MIN_RW_QUEUES 2
 #define UFS_MCQ_MIN_READ_QUEUES 0
 #define UFS_MCQ_MIN_POLL_QUEUES 0
@@ -116,6 +117,19 @@ struct ufs_hw_queue *ufshcd_mcq_req_to_hwq(struct ufs_hba *hba,
 	return &hba->uhq[hwq];
 }
 
+/**
+ * ufshcd_mcq_queue_cfg_addr - get an start address of the MCQ Queue Config
+ * Registers.
+ * @hba: per adapter instance
+ *
+ * Return: Start address of MCQ Queue Config Registers in HCI
+ */
+unsigned int ufshcd_mcq_queue_cfg_addr(struct ufs_hba *hba)
+{
+	return FIELD_GET(QCFGPTR, hba->mcq_capabilities) * 0x200;
+}
+EXPORT_SYMBOL_GPL(ufshcd_mcq_queue_cfg_addr);
+
 /**
  * ufshcd_mcq_decide_queue_depth - decide the queue depth
  * @hba: per adapter instance
diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
index 0aca666d2199..ba8af9c0e77f 100644
--- a/drivers/ufs/host/ufshcd-pci.c
+++ b/drivers/ufs/host/ufshcd-pci.c
@@ -20,6 +20,8 @@
 #include <linux/acpi.h>
 #include <linux/gpio/consumer.h>
 
+#define MAX_SUPP_MAC 64
+
 struct ufs_host {
 	void (*late_init)(struct ufs_hba *hba);
 };
@@ -446,6 +448,49 @@ static int ufs_intel_mtl_init(struct ufs_hba *hba)
 	return ufs_intel_common_init(hba);
 }
 
+static int ufs_qemu_get_hba_mac(struct ufs_hba *hba)
+{
+	return MAX_SUPP_MAC;
+}
+
+static int ufs_qemu_mcq_config_resource(struct ufs_hba *hba)
+{
+	hba->mcq_base = hba->mmio_base + ufshcd_mcq_queue_cfg_addr(hba);
+
+	return 0;
+}
+
+static int ufs_qemu_op_runtime_config(struct ufs_hba *hba)
+{
+	struct ufshcd_mcq_opr_info_t *opr;
+	int i;
+
+	u32 sqdao = ufsmcq_readl(hba, ufshcd_mcq_cfg_offset(REG_SQDAO, 0));
+	u32 sqisao = ufsmcq_readl(hba, ufshcd_mcq_cfg_offset(REG_SQISAO, 0));
+	u32 cqdao = ufsmcq_readl(hba, ufshcd_mcq_cfg_offset(REG_CQDAO, 0));
+	u32 cqisao = ufsmcq_readl(hba, ufshcd_mcq_cfg_offset(REG_CQISAO, 0));
+
+	hba->mcq_opr[OPR_SQD].offset = sqdao;
+	hba->mcq_opr[OPR_SQIS].offset = sqisao;
+	hba->mcq_opr[OPR_CQD].offset = cqdao;
+	hba->mcq_opr[OPR_CQIS].offset = cqisao;
+
+	for (i = 0; i < OPR_MAX; i++) {
+		opr = &hba->mcq_opr[i];
+		opr->stride = 48;
+		opr->base = hba->mmio_base + opr->offset;
+	}
+
+	return 0;
+}
+
+static struct ufs_hba_variant_ops ufs_qemu_hba_vops = {
+	.name                   = "qemu-pci",
+	.get_hba_mac		= ufs_qemu_get_hba_mac,
+	.mcq_config_resource	= ufs_qemu_mcq_config_resource,
+	.op_runtime_config	= ufs_qemu_op_runtime_config,
+};
+
 static struct ufs_hba_variant_ops ufs_intel_cnl_hba_vops = {
 	.name                   = "intel-pci",
 	.init			= ufs_intel_common_init,
@@ -591,7 +636,8 @@ static const struct dev_pm_ops ufshcd_pci_pm_ops = {
 };
 
 static const struct pci_device_id ufshcd_pci_tbl[] = {
-	{ PCI_VENDOR_ID_REDHAT, 0x0013, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
+	{ PCI_VENDOR_ID_REDHAT, 0x0013, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		(kernel_ulong_t)&ufs_qemu_hba_vops },
 	{ PCI_VENDOR_ID_SAMSUNG, 0xC00C, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
 	{ PCI_VDEVICE(INTEL, 0x9DFA), (kernel_ulong_t)&ufs_intel_cnl_hba_vops },
 	{ PCI_VDEVICE(INTEL, 0x4B41), (kernel_ulong_t)&ufs_intel_ehl_hba_vops },
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index df68fb1d4f3f..9e0581115b34 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1278,6 +1278,7 @@ void ufshcd_update_evt_hist(struct ufs_hba *hba, u32 id, u32 val);
 void ufshcd_hba_stop(struct ufs_hba *hba);
 void ufshcd_schedule_eh_work(struct ufs_hba *hba);
 void ufshcd_mcq_config_mac(struct ufs_hba *hba, u32 max_active_cmds);
+unsigned int ufshcd_mcq_queue_cfg_addr(struct ufs_hba *hba);
 u32 ufshcd_mcq_read_cqis(struct ufs_hba *hba, int i);
 void ufshcd_mcq_write_cqis(struct ufs_hba *hba, u32 val, int i);
 unsigned long ufshcd_mcq_poll_cqe_lock(struct ufs_hba *hba,
-- 
2.34.1

