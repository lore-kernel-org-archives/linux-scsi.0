Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B82204F6E
	for <linux-scsi@vger.kernel.org>; Fri, 14 Feb 2025 12:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739535607; cv=none; b=U03ZkQGY8A44Ty/eiaGdb5KGV+DGO16fv4abrJy98qn7MxHN2ruswq2+f02DxsHyhjTtoIlFcfoe8gtSLaIPFcyXPkbytuyNzvyLRulUj94fDX77UTc5wYRh83niu6yzNr0XZCYrzVxJOVwT2W51fknu4OO3qG8PApiLUqWyPKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739535607; c=relaxed/simple;
	bh=De+vmjaqnFamTkhuUc13zkI64EmpCP/N52/DQmkKJmk=;
	h=Mime-Version:Subject:From:To:CC:Message-ID:Date:Content-Type:
	 References; b=sdnW2d01suyYwgyKw45a5g9xnyGiwAG+Vfk2oVignpcBi0aSXFnc+C/u6ciqutpCUHhv5OrwkMSgfbZOOnvlzhs8e7Gn37odSBj/nfzAOECV264Ng063YUfnAbKDiL07esMAa+HKTnVjshaQMKMRi6sCLSCpntyPnBMkcQbjISw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=PARbXb/a; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="PARbXb/a"
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250214122003epoutp02d8c0b48a847aaad67195b5b9a8bc6273~kEmocJI5K3213432134epoutp02f
	for <linux-scsi@vger.kernel.org>; Fri, 14 Feb 2025 12:20:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250214122003epoutp02d8c0b48a847aaad67195b5b9a8bc6273~kEmocJI5K3213432134epoutp02f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1739535603;
	bh=SE3/PBnj+kUlDZG7aR8PEM/EIX4WzDNA2ccU6mMTP4w=;
	h=Subject:Reply-To:From:To:CC:Date:References:From;
	b=PARbXb/aqfU9MnBq5O/mBns7aIDDjr3JdJihljm488RtmtbtCaNZXkI5GBD1LT2Wk
	 6lb6LOZEVug0PLpiTZcOc9l8cSRcvZCIz0CTXAldSjX158EYw3HHILAt+AJkQHAB71
	 GTA1k7JUmLApZ4Tk7QNyaKUxIP+Ran1PGoPR03Ns=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTP id
	20250214122002epcas2p4e0d98b01441ebf8a38e0c9f431b2cee5~kEmn6xulS2864328643epcas2p4h;
	Fri, 14 Feb 2025 12:20:02 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4YvWMk32Frz4x9Pv; Fri, 14 Feb
	2025 12:20:02 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: [PATCH] scsi: ufs: Fix incorrect bit assignment for temperature
 notifications
Reply-To: keosung.park@samsung.com
Sender: Keoseong Park <keosung.park@samsung.com>
From: Keoseong Park <keosung.park@samsung.com>
To: "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "beanhuo@micron.com" <beanhuo@micron.com>,
	"linux@roeck-us.net" <linux@roeck-us.net>, Daejun Park
	<daejun7.park@samsung.com>, Keoseong Park <keosung.park@samsung.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1891546521.01739535602406.JavaMail.epsvc@epcpadp1new>
Date: Fri, 14 Feb 2025 19:52:19 +0900
X-CMS-MailID: 20250214105219epcms2p3a60810a14e6181092cb397924ce36019
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250214105219epcms2p3a60810a14e6181092cb397924ce36019
References: <CGME20250214105219epcms2p3a60810a14e6181092cb397924ce36019@epcms2p3>

According to the UFS specification, the bit positions for
`UFS_DEV_HIGH_TEMP_NOTIF` and `UFS_DEV_LOW_TEMP_NOTIF` were incorrectly
assigned. This patch corrects the bit assignment to align with the
specification.

If this issue is not fixed, devices that support both high and low
temperature notifications may function correctly, but devices that
support only one of them may fail to trigger the corresponding
exception event.

Fixes: e88e2d32200a ("scsi: ufs: core: Probe for temperature notification support")
Signed-off-by: Keoseong Park <keosung.park@samsung.com>
---
 include/ufs/ufs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
index d335bff1a310..8a24ed59ec46 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -385,8 +385,8 @@ enum {
 
 /* Possible values for dExtendedUFSFeaturesSupport */
 enum {
-	UFS_DEV_LOW_TEMP_NOTIF		= BIT(4),
-	UFS_DEV_HIGH_TEMP_NOTIF		= BIT(5),
+	UFS_DEV_HIGH_TEMP_NOTIF		= BIT(4),
+	UFS_DEV_LOW_TEMP_NOTIF		= BIT(5),
 	UFS_DEV_EXT_TEMP_NOTIF		= BIT(6),
 	UFS_DEV_HPB_SUPPORT		= BIT(7),
 	UFS_DEV_WRITE_BOOSTER_SUP	= BIT(8),
-- 
2.25.1


