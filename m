Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1AF115351B
	for <linux-scsi@vger.kernel.org>; Tue,  9 Jul 2024 23:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720567526; cv=none; b=JHdW9hZg3HD3hv3X7WchS3vVmfqe9mIqiQGiAJfLzsjwzUkDyTrFJuDvpy4RULqt3jbulRpQZS9kytXTa84h2bg78lYusKQ2IB7gF3IjBou7T8QsrMZkWlQbMELH8Hrg6UH8/IW4eLMoZ7rlI/wFk3EMXSBIgaxyXMrcglmLCkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720567526; c=relaxed/simple;
	bh=U2SLuE6qHqdjCWbegx+bnEMN73I/j4PA4uCPGyTZKWo=;
	h=Mime-Version:Subject:From:To:CC:Message-ID:Date:Content-Type:
	 References; b=ftjI+Edln20YCrIAZbLdZ0XNVBtNr5FVRE8RGcJGPitYZZ7oWbhWZOZsYmLKsJ+Sm9mzKZPtwRaYprTPuaNelvCUuoS8LW8g/r0/vxzOaB6Z9zhNejbjUxlRr7UtmE+YGBQcpKHzktsocaYoILGrrsbq6KzoQn3o4zISNxbpsdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=q83dLOh1; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="q83dLOh1"
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240709232521epoutp03723cb8417fa8292b93c3da530cdb6b28~grwuFeqJa2298322983epoutp03n
	for <linux-scsi@vger.kernel.org>; Tue,  9 Jul 2024 23:25:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240709232521epoutp03723cb8417fa8292b93c3da530cdb6b28~grwuFeqJa2298322983epoutp03n
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1720567521;
	bh=ssb+IrsLv/SbnE+OAhPqs3L+hCzyjbN97NyqK+4980I=;
	h=Subject:Reply-To:From:To:CC:Date:References:From;
	b=q83dLOh1ziuGB3rpk8ulRAHMFsifagp3K6HIfM/CyFbnvZWGlEUH7QOnHozCWmAR0
	 PNR59r7VQzQcyYUtsVOV+K1iCwOI5gQQCsSvkDB1iqoRR7IoNOVSsvbMzrxmEKjZ0c
	 T4g9xs49+9gxHLSd+RKT4u8Y4jRIpb3ISG7X7000=
Received: from epsmges2p3.samsung.com (unknown [182.195.42.71]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTP id
	20240709232521epcas2p2db17271d27a679022ec93abb6a1fa5cf~grwt3LMzm0839008390epcas2p2t;
	Tue,  9 Jul 2024 23:25:21 +0000 (GMT)
X-AuditID: b6c32a47-c6bff7000000264e-b6-668dc6e11e12
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
	epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
	DE.EC.09806.1E6CD866; Wed, 10 Jul 2024 08:25:21 +0900 (KST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: [PATCH V4] scsi: ufs: core: Check LSDBS cap when !mcq
Reply-To: k831.kim@samsung.com
Sender: Kyoungrul Kim <k831.kim@samsung.com>
From: Kyoungrul Kim <k831.kim@samsung.com>
To: "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "bvanassche@acm.org" <bvanassche@acm.org>, "Ed.Tsai@mediatek.com"
	<Ed.Tsai@mediatek.com>, Minwoo Im <minwoo.im@samsung.com>, Kyoungrul Kim
	<k831.kim@samsung.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20240709232520epcms2p8ebdb5c4fccc30a6221390566589bf122@epcms2p8>
Date: Wed, 10 Jul 2024 08:25:20 +0900
X-CMS-MailID: 20240709232520epcms2p8ebdb5c4fccc30a6221390566589bf122
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42LZdljTQvfhsd40g4PbhCymffjJbLFnvZ3F
	xn4OiymbvjJadF/fwWax/Pg/Jotnpw8wO7B7XL7i7TFt0ik2j5aT+1k8Pj69xeLRt2UVo8fn
	TXIBbFFcNimpOZllqUX6dglcGU8332MvmCBa8f7AN7YGxqmCXYycHBICJhIbr71h7WLk4hAS
	2MEo8e3JBPYuRg4OXgFBib87hEFqhAXsJFZ8fs0GYgsJyElcn9/NChHXkehu/sAMYrMJaEls
	PL6RDWSOiMAkRon/31+ygDjMAs8YJR5NecQGsY1XYkb7UxYIW1pi+/KtjBC2hsSPZb3MELao
	xM3Vb9lh7PfH5kPViEi03jsLVSMo8eDnbqi4lETb7N9MEHa1xNXG3WCLJQQ6GCVaWh+yQiTM
	JVauvgTWwCvgK/G4awZYA4uAqsS/z81QNS4S09/8BDuUWUBeYvvbOcygkGAW0JRYv0sfxJQQ
	UJY4cosFooJPouPwX3aYt3bMewJ1gpJE+7arUBMlJJ5NvAB1sofE6/6H7JBADJR4v34z4wRG
	hVmIoJ6FZO8shL0LGJlXMYqlFhTnpqcWGxUY6xUn5haX5qXrJefnbmIEpxkt9x2MM95+0DvE
	yMTBeIhRgoNZSYR3/o3uNCHelMTKqtSi/Pii0pzU4kOM0hwsSuK891rnpggJpCeWpGanphak
	FsFkmTg4pRqYgqa9ulax/dXDlScKcpOXJXw2MBMIddmunSQVd2CGfPfMmZcrxJgf9DSoNcSF
	f/K8vVz6bOeLLdGnBbUsvSJ/S6bUR+YqGpmUeB+UMbDcry/Ykjt1lWUYW/C7wrZLntfPNz+d
	AEy/iruK15/b8DdZeWnR4SlBf7irztenSBw3/lVf5ODu1j/vzbppe2JmT9b8fnxlZA9f7HqT
	wODdL+yyBTWzY+cv/Tr3+c33Xtt/m/fVXtrfw6v/RSLzibpJR5jCR8NiKRHmtOQp/ydb1Ltr
	ckvYtWc/YP5y44pXwfn5V513vVx36cqGI5Y9rf8DyqeutEnYt1AsW0BgOcuza/U3S6/9sX4g
	5HerY1XBxGwlluKMREMt5qLiRAAv1ZN+ogMAAA==
X-CMS-RootMailID: 20240709232520epcms2p8ebdb5c4fccc30a6221390566589bf122
References: <CGME20240709232520epcms2p8ebdb5c4fccc30a6221390566589bf122@epcms2p8>

if the user sets use_mcq_mode to 0, the host will try to activate the
lsdb mode unconditionally even when the lsdbs of device hci cap is 1. so
it makes timeout cmds and fail to device probing.

To prevent that problem. check the lsdbs cap when mcq is not supported
case.

Signed-off-by: k831.kim <k831.kim@samsung.com>
---
Changes to v1: Fix wrong bit of lsdb support.
Changes to v2: Fix extra space and wrong commit messeage.
Changes to v3: Close missing parenthesis and fix grammatical error.
---
 drivers/ufs/core/ufshcd.c | 16 ++++++++++++++++
 include/ufs/ufshcd.h      |  1 +
 include/ufs/ufshci.h      |  1 +
 3 files changed, 18 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 1b65e6ae4137..8587aa592d51 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2412,7 +2412,17 @@ static inline int ufshcd_hba_capabilities(struct ufs_hba *hba)
 		return err;
 	}
 
+	/*
+	 * The UFSHCI 3.0 specification does not define MCQ_SUPPORT and
+	 * LSDB_SUPPORT, but [31:29] as reserved bits with reset value 0s, which
+	 * means we can simply read values regardless to version
+	 */
 	hba->mcq_sup = FIELD_GET(MASK_MCQ_SUPPORT, hba->capabilities);
+	/*
+	 * 0h: legacy single doorbell support is available
+	 * 1h: indicate that legacy single doorbell support has been removed
+	 */
+	hba->lsdb_sup = !FIELD_GET(MASK_LSDB_SUPPORT, hba->capabilities);
 	if (!hba->mcq_sup)
 		return 0;
 
@@ -10449,6 +10459,12 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	}
 
 	if (!is_mcq_supported(hba)) {
+		if (!hba->lsdb_sup) {
+			dev_err(hba->dev, "%s: failed to initialize (legacy doorbell mode not supported)\n",
+				__func__);
+			err = -EINVAL;
+			goto out_disable;
+		}
 		err = scsi_add_host(host, hba->dev);
 		if (err) {
 			dev_err(hba->dev, "scsi_add_host failed\n");
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index bad88bd91995..fd391f6eee73 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1074,6 +1074,7 @@ struct ufs_hba {
 	bool ext_iid_sup;
 	bool scsi_host_added;
 	bool mcq_sup;
+	bool lsdb_sup;
 	bool mcq_enabled;
 	struct ufshcd_res_info res[RES_MAX];
 	void __iomem *mcq_base;
diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
index 385e1c6b8d60..22ba85e81d8c 100644
--- a/include/ufs/ufshci.h
+++ b/include/ufs/ufshci.h
@@ -75,6 +75,7 @@ enum {
 	MASK_OUT_OF_ORDER_DATA_DELIVERY_SUPPORT	= 0x02000000,
 	MASK_UIC_DME_TEST_MODE_SUPPORT		= 0x04000000,
 	MASK_CRYPTO_SUPPORT			= 0x10000000,
+	MASK_LSDB_SUPPORT			= 0x20000000,
 	MASK_MCQ_SUPPORT			= 0x40000000,
 };
 
-- 
2.34.1
