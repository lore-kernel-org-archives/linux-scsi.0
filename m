Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2392BCF6
	for <linux-scsi@vger.kernel.org>; Fri,  5 Jul 2024 08:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720168256; cv=none; b=aw1riG2N+tVONXU01+1PDga4JyAiP0snXqSDaujvBKCfIlS8lyNPHvaR5x9R0S60d/Gs/WTauBKw9BLWaQpvqNHPxGTxTVE2gyZP+/2doS9JQTyllWO1Rnu8aagbI+OB3hc0MiHFDYIgBwBVAAJ+A4n1z4Iay0ari0aoAb7wQF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720168256; c=relaxed/simple;
	bh=MGe/XQUtsS/7JvaTicgGLOI5fBOycUgNAaUpoxRDJOM=;
	h=Mime-Version:Subject:From:To:CC:Message-ID:Date:Content-Type:
	 References; b=eElttCxUtaAsLpedmJVzKwrR5T5F0mDiMHXWv0dqUVAPK6TrGiwbhqXvLAU9+Jb6As1XtpJwFeM2q+kIA9wakc324KZF8XFT7lx2nnslb4h1ipDZ1bjcDnuPgyPodwyosgUbgcvaJgv4yxddLWBAbavg/jtg3+KRoI2GrXr93FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=B3cMa9be; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="B3cMa9be"
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240705083051epoutp0253b87aaa9cc9575cdcf64b3802d4a3e7~fQ_k8iAbz0160101601epoutp02V
	for <linux-scsi@vger.kernel.org>; Fri,  5 Jul 2024 08:30:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240705083051epoutp0253b87aaa9cc9575cdcf64b3802d4a3e7~fQ_k8iAbz0160101601epoutp02V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1720168251;
	bh=p50gMO5LN79M+W2fkmVIdOs2ul/IDq/74DvL8xoOcv4=;
	h=Subject:Reply-To:From:To:CC:Date:References:From;
	b=B3cMa9beCVz1KFoeAmSRML98MDox3bZopVu4HXj97Y1cajklc2dM6Deqrba9Wy10Y
	 kUQKOteXq3fg8Ned22JyB4LMfA0njr1kXL0ynzl2B/4G0dE4tARXg/InZNPZuuw3oq
	 J/WFuXTV4mVLzcIauhRuqTaLGUGFdQ7L5GCwtL8U=
Received: from epsmges2p2.samsung.com (unknown [182.195.42.70]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTP id
	20240705083051epcas2p15b53ba6df354e9001d497d8500d2d704~fQ_kifNjQ2946029460epcas2p1i;
	Fri,  5 Jul 2024 08:30:51 +0000 (GMT)
X-AuditID: b6c32a46-19bfa7000000250d-50-6687af3b74c2
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
	epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
	86.05.09485.B3FA7866; Fri,  5 Jul 2024 17:30:51 +0900 (KST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: [PATCH V2] scsi: ufs: core: Check LSDBS cap when !mcq
Reply-To: k831.kim@samsung.com
Sender: Kyoungrul Kim <k831.kim@samsung.com>
From: Kyoungrul Kim <k831.kim@samsung.com>
To: "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, Minwoo Im
	<minwoo.im@samsung.com>, Kyoungrul Kim <k831.kim@samsung.com>, SSDR Gost Dev
	<gost.dev@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20240705083050epcms2p85f6e53e075a0d8f6d7980cdad7e62b80@epcms2p8>
Date: Fri, 05 Jul 2024 17:30:50 +0900
X-CMS-MailID: 20240705083050epcms2p85f6e53e075a0d8f6d7980cdad7e62b80
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkleLIzCtJLcpLzFFi42LZdljTVNd6fXuawZuTrBbTPvxktrh5YCeT
	xcZ+Dospm74yWnRf38Fmsfz4PyaLZ6cPMDuwe1y+4u0xbdIpNo+PT2+xePRtWcXo8XmTXABr
	FJdNSmpOZllqkb5dAlfGo5kn2Ao+CFfMv3qbvYGxU6CLkZNDQsBE4se2N6xdjFwcQgI7GCUe
	duxg7GLk4OAVEJT4u0MYpEZYwE6i/845NhBbSEBO4vr8blaIuI5Ed/MHZhCbTUBLYuPxjWwg
	c0QEJjFK/P/+kgUkwSxwl1Hi8TlDiGW8EjPan7JA2NIS25dvZYSwNSR+LOtlhrBFJW6ufssO
	Y78/Nh+qRkSi9d5ZqBpBiQc/d0PFpSTaZv9mgrCrJa427mYBOUJCoINRoqX1IStEwlxi5epL
	YA28Ar4Sa060gdksAqoShx8vghrkIvGtdR3U0fIS29/OYQYFBLOApsT6XfogpoSAssSRW1AV
	fBIdh/+yw7y1Y94TqBOUJNq3XYXaKiHxbOIFqJM9JC6fnc0CMkZIIFBi6+20CYwKsxABPQvJ
	2lkIaxcwMq9iFEstKM5NTy02KjDSK07MLS7NS9dLzs/dxAhOLVpuOxinvP2gd4iRiYPxEKME
	B7OSCK/U++Y0Id6UxMqq1KL8+KLSnNTiQ4zSHCxK4rz3WuemCAmkJ5akZqemFqQWwWSZODil
	Gpikz7J2fl58xSv+68Zetud7OpbzvysIMJzVdG2b4d6c5//nh7NZ330ZcbmbZ9WmSam9mw5K
	RfzluVuUePuRt8Tl/fbM95t0ii6ra+x++6NtQwhXkiibi+/pmTyfP66cvVf8x1f59CNmYow2
	gUdsl51RLfHR+OG0z/PZ2mknDZmM7ZymHZ/1s7icZfoHuR277vxIrDmsZnuI3/NMvKpJpcOD
	mVu0RHfuSJ5eU6XDv94i/OUz4QfTLq86cj0qQO7u0QkbzQ65vqxjeNOs1t/x6FDJ396bfYxn
	U1ntjpRHaV0uvV9vnPBKwX7z/AXXF8+v/Ki1tHOxalTUNSdDxx9rNrG7/XjZm6elXi71YrJ/
	1+OzSizFGYmGWsxFxYkArIMNVZwDAAA=
X-CMS-RootMailID: 20240705083050epcms2p85f6e53e075a0d8f6d7980cdad7e62b80
References: <CGME20240705083050epcms2p85f6e53e075a0d8f6d7980cdad7e62b80@epcms2p8>

if the user set use_mcq_mode to 0, the host will activate the lsdb mode
unconditionally even when the lsdbs of device hci cap is 0. so it makes
timeout cmds and fail to device probing.

To prevent that problem. check the lsdbs cap when mcq is not supported
case.

Signed-off-by: k831.kim <k831.kim@samsung.com>

---
Changes to v1: Fix wrong bit of lsdb support.
---
 drivers/ufs/core/ufshcd.c | 16 ++++++++++++++++
 include/ufs/ufshcd.h      |  1 +
 include/ufs/ufshci.h      |  1 +
 3 files changed, 18 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 1b65e6ae4137..b5a05f8492c4 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2412,7 +2412,17 @@ static inline int ufshcd_hba_capabilities(struct ufs_hba *hba)
 		return err;
 	}
 
+	/*
+	 *  UFS 3.0 has no MCQ_SUPPORT and LSDB_SUPPORT, but [31:29] as reserved
+	 *  bits with reset value 0s, which means we can simply read values
+	 *  regardless to version
+	 */
 	hba->mcq_sup = FIELD_GET(MASK_MCQ_SUPPORT, hba->capabilities);
+	/*
+	 *  0h: legacy single doorbell support is available
+	 *  1h: indicate that legacy single doorbell support have been remove
+	 */
+	hba->lsdb_sup = !FIELD_GET(MASK_LSDB_SUPPORT, hba->capabilities);
 	if (!hba->mcq_sup)
 		return 0;
 
@@ -10449,6 +10459,12 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	}
 
 	if (!is_mcq_supported(hba)) {
+		if (!hba->lsdb_sup) {
+			dev_err(hba->dev, "%s: failed to initialize (legacy doorbell mode not supported\n",
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
