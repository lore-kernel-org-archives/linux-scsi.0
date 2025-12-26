Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45115221F39
	for <linux-scsi@vger.kernel.org>; Fri, 26 Dec 2025 04:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766723317; cv=none; b=o4MaevTZhMUlU9XuwU97+EWrI1Cwj3AOzX/b/UTdY4O2Ixd4A/PSY3ExAzJU5CAghpPJyOTuHjqOPUjo8nLUy8pCElYyNvAmDeONw0VMg1uEdYpLoDZK7S9wt0fk3Ww4S1z6TF3fSkZi/4zZb8IPB8VTtA1caB+Hi5SDWT/i9m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766723317; c=relaxed/simple;
	bh=+tp0gEPz03QFeRezzYlj3p1rjgo3WEDCN4pO99wTDwM=;
	h=Mime-Version:Subject:From:To:CC:Message-ID:Date:Content-Type:
	 References; b=YmV0WxNK+M67kxKi/qtbpCJeti/TGUWW/IRisn+SzoQmxh1ZqMHq6FNQgHmSCagwt3vTs2C1Y4R4t6NYwjy6+qoS2P7spTtJf5+FIn1VYNZeqEPU37vk2jTCiq/rm6T0TAm/tGV1fKpY+RMl1CY4TpR61LkJT7NURWWstZoz7wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Vr8fPAbH; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Vr8fPAbH"
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20251226042826epoutp03cc5df09c800b30b525e261fcc570a151~EqXyXaADX0149101491epoutp03f
	for <linux-scsi@vger.kernel.org>; Fri, 26 Dec 2025 04:28:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20251226042826epoutp03cc5df09c800b30b525e261fcc570a151~EqXyXaADX0149101491epoutp03f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1766723306;
	bh=dg5bdLxpRj2vclq+WxQF56vM7e2akIt77jtRkyJ6xRA=;
	h=Subject:Reply-To:From:To:CC:Date:References:From;
	b=Vr8fPAbHH+/j5DbxsNg47acHX3zYQsopV3G1e40jBcnyUsoVXP9SJU5ExanGrOnWY
	 +gL2nEWkPS8iU3MFBa0Gr/D+3wu0IyUOGsYj84cWRC5RxQDS6rpvahWOtzZBgsSkZ9
	 RbQhlCSctiKPK0tSUbNppaVl//8ZWlcZJsBYux/s=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTPS id
	20251226042825epcas2p4eea46355325d7ae585407ede7c6259ae~EqXx49-PI0326503265epcas2p4M;
	Fri, 26 Dec 2025 04:28:25 +0000 (GMT)
Received: from epcas2p1.samsung.com (unknown [182.195.38.200]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4dct0947vqz2SSKZ; Fri, 26 Dec
	2025 04:28:25 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: [PATCH] scsi: ufs: core: Handle sentinel value for
 dHIDAvailableSize
Reply-To: keosung.park@samsung.com
Sender: Keoseong Park <keosung.park@samsung.com>
From: Keoseong Park <keosung.park@samsung.com>
To: ALIM AKHTAR <alim.akhtar@samsung.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "peter.wang@mediatek.com"
	<peter.wang@mediatek.com>, "tanghuan@vivo.com" <tanghuan@vivo.com>, Keoseong
	Park <keosung.park@samsung.com>, "zhongqiu.han@oss.qualcomm.com"
	<zhongqiu.han@oss.qualcomm.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "liu.song13@zte.com.cn" <liu.song13@zte.com.cn>,
	"chullee@google.com" <chullee@google.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20251226042825epcms2p6f02ba12fa97ff4a69c00f6fb9ff55603@epcms2p6>
Date: Fri, 26 Dec 2025 13:28:25 +0900
X-CMS-MailID: 20251226042825epcms2p6f02ba12fa97ff4a69c00f6fb9ff55603
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251226042825epcms2p6f02ba12fa97ff4a69c00f6fb9ff55603
References: <CGME20251226042825epcms2p6f02ba12fa97ff4a69c00f6fb9ff55603@epcms2p6>

JEDEC UFS spec defines 0xFFFFFFFF for dHIDAvailableSize as indicating no
valid fragmented size information. Returning the raw value can mislead
userspace. Return -ENODATA instead when the value is unavailable.

Signed-off-by: Keoseong Park <keosung.park@samsung.com>
---
 drivers/ufs/core/ufs-sysfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index b33f8656edb5..1017dd3ae5d3 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -1847,6 +1847,7 @@ static ssize_t defrag_trigger_store(struct device *dev,
 
 static DEVICE_ATTR_WO(defrag_trigger);
 
+#define UFS_HID_AVAILABLE_SIZE_INVALID 0xFFFFFFFFU
 static ssize_t fragmented_size_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -1859,6 +1860,9 @@ static ssize_t fragmented_size_show(struct device *dev,
 	if (ret)
 		return ret;
 
+	if (value == UFS_HID_AVAILABLE_SIZE_INVALID)
+		return -ENODATA;
+
 	return sysfs_emit(buf, "%u\n", value);
 }
 
-- 
2.25.1

