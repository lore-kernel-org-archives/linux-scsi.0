Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A544E757E5
	for <linux-scsi@vger.kernel.org>; Sun, 19 May 2024 22:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716157580; cv=none; b=H5SyW9YXH+NCdexeX5MIYuStDGsiQZKt3a0UFo4DRq+XQwEmNJooWM0qQbq0TUiCigXsE74J7vqmRgC0HYXjHdKxJw1uoHxC15rEdydrVdEBuWVisuuLZUgqKV4fecREMYHj3tY7qzu1EwW2ty/6/3UavrTigyDeYX26KByWdqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716157580; c=relaxed/simple;
	bh=xFS9+1krzqC3TFDlOBwIXd0p8y4k4bTu1j6C5Kt0iCw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=uYSDs66LHdD6omhWH0X0qzCQ1iQnQvtDGOMoabLtaH8AkU7mKj7i1MdtdWWJZVQv2CegoB69297U+9zQKbA9em9jFBV+XHBcv3ab5IKjQpMGm6TSKtafZiTVsbHX6MZFqU60UiXdbmJOGFAedJTRcI3XcYoMByIiE8R8+26EkiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=fgrNiBQn; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="fgrNiBQn"
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240519222610epoutp021d62cca4454c125aadc0b4134a5f8198~RBDeuQt0G1014710147epoutp02y
	for <linux-scsi@vger.kernel.org>; Sun, 19 May 2024 22:26:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240519222610epoutp021d62cca4454c125aadc0b4134a5f8198~RBDeuQt0G1014710147epoutp02y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1716157570;
	bh=VQSvF43ksr4+WFT26ev9vTngdVwUCAnSIvHXHAFpqnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fgrNiBQnvg+72JfPRAjHn2wbLqNmD+zuSG4ogGzrEJEwMJM8eS7KozxNt7XYizFKY
	 WLERu9M5rFsxrP20l5GwCjsuXCm7pTgOHu5u6SzGWlozPhd/yf7NMXz0G4aUQQYkSD
	 EYTcUAPjCu+KR8CyHlW+6dMEtOKQpwO79qZkXa4k=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTP id
	20240519222609epcas2p275da2ac08842d21165ab00ae038ae82e~RBDdxsa4Y2723627236epcas2p28;
	Sun, 19 May 2024 22:26:09 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.36.98]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4VjFf82fVlz4x9Pv; Sun, 19 May
	2024 22:26:08 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
	epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
	20.97.09639.08C7A466; Mon, 20 May 2024 07:26:08 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
	20240519222607epcas2p1c485b3cc264fdabc2c1e90daf228664d~RBDcG3dHX0608206082epcas2p1C;
	Sun, 19 May 2024 22:26:07 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240519222607epsmtrp269432760c30cc058a4386e53042cb38d~RBDcGHq9_2869528695epsmtrp2F;
	Sun, 19 May 2024 22:26:07 +0000 (GMT)
X-AuditID: b6c32a46-8ddfa700000025a7-2a-664a7c801fc2
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	8B.40.19234.F7C7A466; Mon, 20 May 2024 07:26:07 +0900 (KST)
Received: from localhost.dsn.sec.samsung.com (unknown [10.229.54.230]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240519222607epsmtip23d76be780fd325515b88d70df34d4b8d~RBDb2_O8Z0459304593epsmtip2O;
	Sun, 19 May 2024 22:26:07 +0000 (GMT)
From: Minwoo Im <minwoo.im@samsung.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>, Alim Akhtar
	<alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Bart Van
	Assche  <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Joel Granados
	<j.granados@samsung.com>, gost.dev@samsung.com, Minwoo Im
	<minwoo.im@samsung.com>, Asutosh Das <quic_asutoshd@quicinc.com>
Subject: [PATCH v2 2/2] ufs: mcq: Convert MCQ_CFG_n to a inline function
Date: Mon, 20 May 2024 07:14:57 +0900
Message-Id: <20240519221457.772346-3-minwoo.im@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240519221457.772346-1-minwoo.im@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGJsWRmVeSWpSXmKPExsWy7bCmmW5DjVeawbn1QhYP5m1js3j58yqb
	xbQPP5ktbh7YyWSxdP9DRouN/RwWl3fNYbPovr6DzWL58X9MFs9OH2C2WNgxl8WB2+PyFW+P
	aZNOsXl8fHqLxWPinjqPvi2rGD0+b5LzaD/QzRTAHpVtk5GamJJapJCal5yfkpmXbqvkHRzv
	HG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0oZJCWWJOKVAoILG4WEnfzqYov7QkVSEjv7jE
	Vim1ICWnwLxArzgxt7g0L10vL7XEytDAwMgUqDAhO2P3Zc6CQ0oV32ZuYGxgfCzdxcjJISFg
	InH7yTLGLkYuDiGBHYwSX1qPskA4nxglVl2cyQTnXFy9ix2mZe3mhVCJnYwSj7csZ4ZwfjNK
	PJr2nBGkik1AXaJh6isWEFtE4AOjxKY3BiBFzAKnGCU+328HKxIW8JD48+QhK4jNIqAq0fv/
	PlicV8Ba4u3kNlaIdfIS+w+eZQaxOQVsJKbdv84MUSMocXLmE7AFzEA1zVtng10hIdDJITF9
	/XFGiGYXibt7nzBB2MISr45vgfpBSuLzu71sEHa5xM83k6DqKyQOzroNFOcAsu0lrj1PATGZ
	BTQl1u/Sh4gqSxy5BbWVT6Lj8F92iDCvREebEMQMZYmPhw4xQ9iSEssvvYba4yEx79gDdkhQ
	9TNKnJ25n3ECo8IsJM/MQvLMLITFCxiZVzGKpRYU56anFhsVGMEjODk/dxMjOMFque1gnPL2
	g94hRiYOxkOMEhzMSiK8m7Z4pgnxpiRWVqUW5ccXleakFh9iNAUG9URmKdHkfGCKzyuJNzSx
	NDAxMzM0NzI1MFcS573XOjdFSCA9sSQ1OzW1ILUIpo+Jg1OqgWmFI/+5iL1ugccvnJWa/Oew
	++fraza+uRjo8I3himszj+e+i/aCB0+4cMa1eq3c9bPOdPfpxeKhZz6sdRJrOPfkRbH+vG0L
	Pm1Yc+X2N76pM4/edS2RNpxzKMJz9f5p3v0FosvOvegtPpH/p3OOWsTTe/ujd/1sdlK4tGiT
	818hi6MPlD5tW3wwW2LOs5QDR9y+Z1+7+9Dea/uXDakSVlIFDmck23j+ejsJ7hDpUp6w5ejq
	xDOtu8K+bSyf9iAuN1LimX/Ho2PXpr4L2vE7I9PhT/zPTkUx446rOXorij7M5Vd++8rMvPew
	xL/7JdozpVOaNVxzDmzb+nieYdleljP5Nneb2w6LTpp/VZ9t10enRiWW4oxEQy3mouJEAMJ7
	YZk5BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsWy7bCSvG59jVeawewJfBYP5m1js3j58yqb
	xbQPP5ktbh7YyWSxdP9DRouN/RwWl3fNYbPovr6DzWL58X9MFs9OH2C2WNgxl8WB2+PyFW+P
	aZNOsXl8fHqLxWPinjqPvi2rGD0+b5LzaD/QzRTAHsVlk5Kak1mWWqRvl8CVsfsyZ8EhpYpv
	MzcwNjA+lu5i5OSQEDCRWLt5IVMXIxeHkMB2RokJLy+zQyQkJfadvskKYQtL3G85wgpR9JNR
	Yn3PF7AiNgF1iYapr1hAEiICnxglNnV1gDnMAhcYJeZ8+sQMUiUs4CHx58lDsFEsAqoSvf/v
	M4LYvALWEm8nt0GtkJfYf/AsWD2ngI3EtPvXwWwhoJofWy+zQNQLSpyc+QTMZgaqb946m3kC
	o8AsJKlZSFILGJlWMYqmFhTnpucmFxjqFSfmFpfmpesl5+duYgTHgVbQDsZl6//qHWJk4mA8
	xCjBwawkwrtpi2eaEG9KYmVValF+fFFpTmrxIUZpDhYlcV7lnM4UIYH0xJLU7NTUgtQimCwT
	B6dUA5PldmUliacfKiU4ctSdq9e9yy+qdZtklRNzON32+JO2sjVuB9mmXVaYtLJf54rR2nV/
	/iy/q64av29WR5HP+kkbt1SWdb9K4nz4bdlOk3bXh9dWnr+dteLa3j156wP4Tb7+WfZeLWHO
	5hNVlcV3tBh8qmI5VF0U2E4lc83vWx7/YmH8Lj4Z443TWzSin/5b2/Dq+pGnU75rndV1Z7p6
	fvKvx5XOKefEdJdx3A1UWD7HVlIy45fLz6sHJm81/O5usGlLXOnFxQ2b1/0u0Jj9x9k0+sAb
	YanHivFr+890TnzAf+Aaq4ytXMLxIG3unpgt4k7Cq1znX/Lq/iMsVrCjzHG76O65ioH8fPkq
	9iw/Pz1VYinOSDTUYi4qTgQAvDHD9/ICAAA=
X-CMS-MailID: 20240519222607epcas2p1c485b3cc264fdabc2c1e90daf228664d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240519222607epcas2p1c485b3cc264fdabc2c1e90daf228664d
References: <20240519221457.772346-1-minwoo.im@samsung.com>
	<CGME20240519222607epcas2p1c485b3cc264fdabc2c1e90daf228664d@epcas2p1.samsung.com>

Unlike the previous patch, this patch does not fix any issues, but,
inline functions are much more preferred over macros, so this patch
converted MCQ_CFG_n macro in ufs-mcq to an inline function along with
the previous patch.

Signed-off-by: Minwoo Im <minwoo.im@samsung.com>
---
 drivers/ufs/core/ufs-mcq.c | 25 ++++++++++---------------
 include/ufs/ufshcd.h       |  7 +++++++
 2 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index b93ec147641c..d15817a3900b 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -25,7 +25,6 @@
 #define QUEUE_ID_OFFSET 16
 
 #define MCQ_CFG_MAC_MASK	GENMASK(16, 8)
-#define MCQ_QCFG_SIZE		0x40
 #define MCQ_ENTRY_SIZE_IN_DWORD	8
 #define CQE_UCD_BA GENMASK_ULL(63, 7)
 
@@ -228,10 +227,6 @@ int ufshcd_mcq_memory_alloc(struct ufs_hba *hba)
 	return 0;
 }
 
-
-/* Operation and runtime registers configuration */
-#define MCQ_CFG_n(r, i)	((r) + MCQ_QCFG_SIZE * (i))
-
 static void __iomem *mcq_opr_base(struct ufs_hba *hba,
 					 enum ufshcd_mcq_opr n, int i)
 {
@@ -336,29 +331,29 @@ void ufshcd_mcq_make_queues_operational(struct ufs_hba *hba)
 
 		/* Submission Queue Lower Base Address */
 		ufsmcq_writelx(hba, lower_32_bits(hwq->sqe_dma_addr),
-			      MCQ_CFG_n(REG_SQLBA, i));
+			      ufshcd_mcq_cfg_offset(REG_SQLBA, i));
 		/* Submission Queue Upper Base Address */
 		ufsmcq_writelx(hba, upper_32_bits(hwq->sqe_dma_addr),
-			      MCQ_CFG_n(REG_SQUBA, i));
+			      ufshcd_mcq_cfg_offset(REG_SQUBA, i));
 		/* Submission Queue Doorbell Address Offset */
 		ufsmcq_writelx(hba, ufshcd_mcq_opr_offset(hba, OPR_SQD, i),
-			      MCQ_CFG_n(REG_SQDAO, i));
+			      ufshcd_mcq_cfg_offset(REG_SQDAO, i));
 		/* Submission Queue Interrupt Status Address Offset */
 		ufsmcq_writelx(hba, ufshcd_mcq_opr_offset(hba, OPR_SQIS, i),
-			      MCQ_CFG_n(REG_SQISAO, i));
+			      ufshcd_mcq_cfg_offset(REG_SQISAO, i));
 
 		/* Completion Queue Lower Base Address */
 		ufsmcq_writelx(hba, lower_32_bits(hwq->cqe_dma_addr),
-			      MCQ_CFG_n(REG_CQLBA, i));
+			      ufshcd_mcq_cfg_offset(REG_CQLBA, i));
 		/* Completion Queue Upper Base Address */
 		ufsmcq_writelx(hba, upper_32_bits(hwq->cqe_dma_addr),
-			      MCQ_CFG_n(REG_CQUBA, i));
+			      ufshcd_mcq_cfg_offset(REG_CQUBA, i));
 		/* Completion Queue Doorbell Address Offset */
 		ufsmcq_writelx(hba, ufshcd_mcq_opr_offset(hba, OPR_CQD, i),
-			      MCQ_CFG_n(REG_CQDAO, i));
+			      ufshcd_mcq_cfg_offset(REG_CQDAO, i));
 		/* Completion Queue Interrupt Status Address Offset */
 		ufsmcq_writelx(hba, ufshcd_mcq_opr_offset(hba, OPR_CQIS, i),
-			      MCQ_CFG_n(REG_CQISAO, i));
+			      ufshcd_mcq_cfg_offset(REG_CQISAO, i));
 
 		/* Save the base addresses for quicker access */
 		hwq->mcq_sq_head = mcq_opr_base(hba, OPR_SQD, i) + REG_SQHP;
@@ -375,7 +370,7 @@ void ufshcd_mcq_make_queues_operational(struct ufs_hba *hba)
 
 		/* Completion Queue Enable|Size to Completion Queue Attribute */
 		ufsmcq_writel(hba, (1 << QUEUE_EN_OFFSET) | qsize,
-			      MCQ_CFG_n(REG_CQATTR, i));
+			      ufshcd_mcq_cfg_offset(REG_CQATTR, i));
 
 		/*
 		 * Submission Qeueue Enable|Size|Completion Queue ID to
@@ -383,7 +378,7 @@ void ufshcd_mcq_make_queues_operational(struct ufs_hba *hba)
 		 */
 		ufsmcq_writel(hba, (1 << QUEUE_EN_OFFSET) | qsize |
 			      (i << QUEUE_ID_OFFSET),
-			      MCQ_CFG_n(REG_SQATTR, i));
+			      ufshcd_mcq_cfg_offset(REG_SQATTR, i));
 	}
 }
 EXPORT_SYMBOL_GPL(ufshcd_mcq_make_queues_operational);
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index eec7c97e3dbe..94fa400b646e 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1127,6 +1127,8 @@ struct ufs_hw_queue {
 	struct mutex sq_mutex;
 };
 
+#define MCQ_QCFG_SIZE		0x40
+
 static inline bool is_mcq_enabled(struct ufs_hba *hba)
 {
 	return hba->mcq_enabled;
@@ -1138,6 +1140,11 @@ static inline unsigned int ufshcd_mcq_opr_offset(struct ufs_hba *hba,
 	return hba->mcq_opr[opr].offset + hba->mcq_opr[opr].stride * idx;
 }
 
+static inline unsigned int ufshcd_mcq_cfg_offset(unsigned int reg, int idx)
+{
+	return reg + MCQ_QCFG_SIZE * idx;
+}
+
 #ifdef CONFIG_SCSI_UFS_VARIABLE_SG_ENTRY_SIZE
 static inline size_t ufshcd_sg_entry_size(const struct ufs_hba *hba)
 {
-- 
2.34.1

