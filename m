Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A446C156F42
	for <linux-scsi@vger.kernel.org>; Fri, 31 May 2024 10:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717152595; cv=none; b=t1uvti+sVClVO0sF57NFYNgZYzOVqC8vjM0U4NhHTiWjx4NUYbuuGVZG37JjOLI60qQZ+l1iKgsySBEIfDzd+E9xe+r1v+dfnnfKW6EtL3pDbbg15cPWPlwxzGtMYCU4bUbJOOIQq5+3nb4GFoa30XhUtt+N5YdZEIWJhrfaqh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717152595; c=relaxed/simple;
	bh=JL0jkyun2LxE4J4kzViXyje0GZZot6jmyEQrYG1n/pc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=bzsTBQrNxDc0avtadlPhP7g600GWLF7Yc4mRpU5dpiqh/uS3hkLoXqxsohkYGkwjD1jBsfWnLwgHs/1PAlfH96+FGc/0Myu3oC5Up7UPWlsvNs1mNAbg8V+NY9Bx4PxnabXSSGI4XSyimjkop4MmUIGUTgQxKS/VcU2u8sS50vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=SeP2Imor; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="SeP2Imor"
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240531104949epoutp030bbfb51a6da4f333fd290a1a38b69f91~UjS64m2Fl1958019580epoutp03l
	for <linux-scsi@vger.kernel.org>; Fri, 31 May 2024 10:49:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240531104949epoutp030bbfb51a6da4f333fd290a1a38b69f91~UjS64m2Fl1958019580epoutp03l
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1717152589;
	bh=NeMgLSvpR+9j44c4Bok8cPMbulX9XuhRpiv420ziGJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SeP2ImorqzQSiuGAc/C3m6Qok5m74agez4jjeg+cuh3TbzS1q3c5eURYqsu8K73Ko
	 KNnSRtOxShgKPLrl8BgEKh3sBF6Dzv5iQGdQ//1NRjJRlST9ynmKFwyrxhkaIVpn16
	 h+Ui5v+o+4Y5TM4W0xsMEisPu6Z1Zh3BrKheaXMs=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTP id
	20240531104949epcas2p368bacccfff56e330e9d04d559aa7383b~UjS6jeLLP2726827268epcas2p3_;
	Fri, 31 May 2024 10:49:49 +0000 (GMT)
Received: from epsmgec2p1-new.samsung.com (unknown [182.195.36.98]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4VrKd84BZsz4x9Q6; Fri, 31 May
	2024 10:49:48 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
	epsmgec2p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	6F.D2.18956.C4BA9566; Fri, 31 May 2024 19:49:48 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
	20240531104947epcas2p30506632eb56025711dfb5768e2f77154~UjS5Qbnut1766317663epcas2p3C;
	Fri, 31 May 2024 10:49:47 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240531104947epsmtrp16b82d195884d3416abc8665b0a52af06~UjS5PHupy2848028480epsmtrp12;
	Fri, 31 May 2024 10:49:47 +0000 (GMT)
X-AuditID: b6c32a4d-247ff70000004a0c-19-6659ab4cf2ed
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	42.A0.07412.B4BA9566; Fri, 31 May 2024 19:49:47 +0900 (KST)
Received: from localhost.dsn.sec.samsung.com (unknown [10.229.54.230]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240531104947epsmtip1bd6f77365a18ee53f40c3fd56100775a~UjS5Gb4Sb0934709347epsmtip1L;
	Fri, 31 May 2024 10:49:47 +0000 (GMT)
From: Minwoo Im <minwoo.im@samsung.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman
	<avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Minwoo Im
	<minwoo.im@samsung.com>, gost.dev@samsung.com, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, Jeuk Kim <jeuk20.kim@samsung.com>
Subject: [PATCH 2/3] ufs: pci: Add support MCQ for QEMU-based UFS
Date: Fri, 31 May 2024 19:38:20 +0900
Message-Id: <20240531103821.1583934-3-minwoo.im@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240531103821.1583934-1-minwoo.im@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIJsWRmVeSWpSXmKPExsWy7bCmma7P6sg0g61XpCwezNvGZvHy51U2
	i2kffjJb3Dywk8liYz+Hxf2t1xgtLu+aw2bRfX0Hm8Xy4/+YLJ6dPsDswOVx+Yq3x7RJp9g8
	Pj69xeLRt2UVo8fnTXIe7Qe6mQLYorJtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0t
	zJUU8hJzU22VXHwCdN0yc4AOU1IoS8wpBQoFJBYXK+nb2RTll5akKmTkF5fYKqUWpOQUmBfo
	FSfmFpfmpevlpZZYGRoYGJkCFSZkZzTsv81U8EK8Yu6cTtYGxi/CXYycHBICJhI3jnxi62Lk
	4hAS2MMocWpWByOE84lRYtGmv8wQzjdGiROLnzDDtExqOcwEkdjLKLH67HwWCOc3o8Txt3sZ
	QarYBNQlGqa+YgGxRQSqJTa3/wVbwizQxyTRPns+axcjB4ewgKPE9dWGIDUsAqoS908tAuvl
	FbCRuHxyGRPENnmJ/QfPgm3mFLCVaPl/kg2iRlDi5MwnYPOZgWqat84GO1VCoJFD4s/7aYwQ
	zS4St46fZYewhSVeHd8CZUtJvOxvg7LLJX6+mQRVXyFxcNZtNpDbJATsJa49TwExmQU0Jdbv
	0oeIKkscuQW1lU+i4/Bfdogwr0RHmxDEDGWJj4cOQYNKUmL5pddsELaHxLPPa6GBO4FR4tP2
	XWwTGBVmIXlmFpJnZiEsXsDIvIpRKrWgODc9NdmowFA3L7UcHsnJ+bmbGMFpVct3B+Pr9X/1
	DjEycTAeYpTgYFYS4f2VHpEmxJuSWFmVWpQfX1Sak1p8iNEUGNwTmaVEk/OBiT2vJN7QxNLA
	xMzM0NzI1MBcSZz3XuvcFCGB9MSS1OzU1ILUIpg+Jg5OqQambkO/lBmG5k9fL45ObZnwrPXv
	7Sxv6fvybHnKlTwrb7/ZHfPQ0Uc6e4Pbb8t4L8153/99ntDwKcnSeb0jl2/f2jhfnhW3Q9T5
	TntJTlu7/rfkWl/lludS9SVFZyzPblm5RfUYhzy3plvWH1tL2V2cbMqrIrNuS+kcn/Hv6SLp
	45ueXOVZ8FPSeNmnb5O3Cf/gy5HRS/3uOXXSk27lltSHjgZzfjnoP791e56aiBbH4Q9HOi7v
	z1nRm2nL9Unu+h5DpYkPk85LteyM5Pq78OOCJXkLYp7rXD/2463WtuWWz6ZcCvgo0Xaq8VTu
	lP2NCZIGa0wMRD67ZO/JtuWNjXJ54z9Le9n/12/LGf7me/YVK7EUZyQaajEXFScCALMQ6w40
	BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsWy7bCSnK736sg0gwVbLCwezNvGZvHy51U2
	i2kffjJb3Dywk8liYz+Hxf2t1xgtLu+aw2bRfX0Hm8Xy4/+YLJ6dPsDswOVx+Yq3x7RJp9g8
	Pj69xeLRt2UVo8fnTXIe7Qe6mQLYorhsUlJzMstSi/TtErgyGvbfZip4IV4xd04nawPjF+Eu
	Rk4OCQETiUkth5m6GLk4hAR2M0q8aX3EApGQlNh3+iYrhC0scb/lCCtE0U9GiY1b+sGK2ATU
	JRqmvgKzRQSqJTa3/2UDKWIWmMYksWgWSDcHh7CAo8T11YYgNSwCqhL3Ty1iBLF5BWwkLp9c
	xgSxQF5i/8GzzCA2p4CtRMv/k2wgthBQzerLL1kg6gUlTs58AmYzA9U3b53NPIFRYBaS1Cwk
	qQWMTKsYJVMLinPTc5MNCwzzUsv1ihNzi0vz0vWS83M3MYJDX0tjB+O9+f/0DjEycTAeYpTg
	YFYS4f2VHpEmxJuSWFmVWpQfX1Sak1p8iFGag0VJnNdwxuwUIYH0xJLU7NTUgtQimCwTB6dU
	A9P5Jae2/80WWjdd7Ilj+aZUc6a/TEaSoZZNZgKTgreefbjwO9vagBtGL5JW1M4pm/vqe1L8
	yuT7Lxbd2GJebXc1MI0hUqc7wfbsvWdRW10q+Cz6bp5RlWLZve58ksOykuOz018aFOX9tth0
	p1+mpKraZFJt9f/n3nuPiVbqriz4Uic4w3MN6/3FnDxR4bfMNzDFV0Ve1jWT7c+ZWHExy9Rf
	Z4+r9KT9PzwWzHIOVbO8zZne4JpTZX1EeHpE6LNnr1NnfJJ5I6F/cM7f+0GTf29a4yW9oMz9
	qcTZC4KZKyuOt3keUbDO8qpX6F1yd21F3Y83GuFWUdskd1tVuqpObulJienymqipHcCrWC8T
	rcRSnJFoqMVcVJwIAHm00EfsAgAA
X-CMS-MailID: 20240531104947epcas2p30506632eb56025711dfb5768e2f77154
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240531104947epcas2p30506632eb56025711dfb5768e2f77154
References: <20240531103821.1583934-1-minwoo.im@samsung.com>
	<CGME20240531104947epcas2p30506632eb56025711dfb5768e2f77154@epcas2p3.samsung.com>

Recently, ufs-mcq feature has been introduced to QEMU hw/ufs device [1].
This patch adds MCQ support for upstream QEMU UFS PCI controller.  This
patch provides mandatory vops callbacks to make UFS controller work
properly on MCQ mode.  Operation and Runtime Config register stride is
fixed to 48bytes which is implemented by qemu.

[1] https://lore.kernel.org/qemu-devel/cover.1716876237.git.jeuk20.kim@samsung.com/

Signed-off-by: Minwoo Im <minwoo.im@samsung.com>
---
 drivers/ufs/host/ufshcd-pci.c | 48 ++++++++++++++++++++++++++++++++++-
 1 file changed, 47 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
index 0aca666d2199..d4d64a29390e 100644
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
 
+static int ufs_redhat_get_hba_mac(struct ufs_hba *hba)
+{
+	return MAX_SUPP_MAC;
+}
+
+static int ufs_redhat_mcq_config_resource(struct ufs_hba *hba)
+{
+	hba->mcq_base = hba->mmio_base + ufshcd_mcq_queue_cfg_addr(hba);
+
+	return 0;
+}
+
+static int ufs_redhat_op_runtime_config(struct ufs_hba *hba)
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
+static struct ufs_hba_variant_ops ufs_redhat_hba_vops = {
+	.name                   = "redhat-pci",
+	.get_hba_mac		= ufs_redhat_get_hba_mac,
+	.mcq_config_resource	= ufs_redhat_mcq_config_resource,
+	.op_runtime_config	= ufs_redhat_op_runtime_config,
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
+		(kernel_ulong_t)&ufs_redhat_hba_vops },
 	{ PCI_VENDOR_ID_SAMSUNG, 0xC00C, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
 	{ PCI_VDEVICE(INTEL, 0x9DFA), (kernel_ulong_t)&ufs_intel_cnl_hba_vops },
 	{ PCI_VDEVICE(INTEL, 0x4B41), (kernel_ulong_t)&ufs_intel_ehl_hba_vops },
-- 
2.34.1

