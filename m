Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7162853EA
	for <linux-scsi@vger.kernel.org>; Tue, 30 Sep 2025 06:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759212976; cv=none; b=fY1rbdY9hPoAPYQR6//RHbF8UUjfigXpu7C577PQdvfmaEAUk/VNU5Q99Wm7yiqDwBvSEuybnDYTOhTacXYCq2UGgKH94I+RffCUdZ/04gAlW3HIJZfPAQfW4E8pUu0RVZL+xpMDG5Bs/2jAQffrTIJitmaMFPtMysHm3TKhieM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759212976; c=relaxed/simple;
	bh=k0Ug0hMXyIEV3oBtM+Lrs7aTQfqpqy8gXoc5ze1Ye3g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=lQnfWCSbRWqFghfjHDLYZjQwdsEbmJjz8gH32302ZFmUoVlIZ/0bGmxmFFFlNnAycsVr8dUeTlQQU4csLbiQSjhNVcGeBcW1B6BWKKZPpIHxKcAAmvk1ilBPYk8+4Cb8GEFh2s6yZ1Z/TA19gwbrbDsHvcwEq5ApscABMYn/AEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=nR2gDAUR; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="nR2gDAUR"
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250930061606epoutp012640a4d61e9b829d39acd92b51b7c8e7~p_t9KKuVT1550715507epoutp01H
	for <linux-scsi@vger.kernel.org>; Tue, 30 Sep 2025 06:16:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250930061606epoutp012640a4d61e9b829d39acd92b51b7c8e7~p_t9KKuVT1550715507epoutp01H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1759212966;
	bh=9IHweh2/nHqBNVgVlNFzRjEmwx0dq4MK0rQu9sv5zAc=;
	h=From:To:Cc:Subject:Date:References:From;
	b=nR2gDAURlPm3REj30phqLf6AhI8ADA9lOkILL6OFwB9oTIyZiePRDglNAsSPWYnCC
	 cDpE4iCjqw6a8feXekXjTmRcgYHO6HEwef4OeMDjycpZmp7bYZpvak+r+pWfmG8/qd
	 g9g6bxWu1YyuzphJd+DuniFPU0/BrWLLo8EZ/EHY=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPS id
	20250930061605epcas2p2bdad3af7870c3f550ab0421867229a2f~p_t8peC6m2133821338epcas2p25;
	Tue, 30 Sep 2025 06:16:05 +0000 (GMT)
Received: from epcas2p4.samsung.com (unknown [182.195.38.202]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4cbSVY35fFz2SSKg; Tue, 30 Sep
	2025 06:16:05 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
	20250930061604epcas2p3f341c32c50f267aa6bd3ae0e82adfbf3~p_t7lFDmk3099130991epcas2p3A;
	Tue, 30 Sep 2025 06:16:04 +0000 (GMT)
Received: from ubuntu.dsn.sec.samsung.com (unknown [10.229.95.128]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250930061604epsmtip270a46a41a48491c577be74cb3cb7ec77~p_t7gUFjg1548315483epsmtip2G;
	Tue, 30 Sep 2025 06:16:04 +0000 (GMT)
From: HOYOUNG SEO <hy50.seo@samsung.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
	martin.petersen@oracle.com, beanhuo@micron.com, bvanassche@acm.org,
	kwangwon.min@samsung.com, kwmad.kim@samsung.com, cpgs@samsung.com,
	h10.kim@samsung.com
Cc: "hy50.seo" <hy50.seo@samsung.com>
Subject: [PATCH v2] scsi: ufs: core: Include UTP error in INT_FATAL_ERRORS
Date: Tue, 30 Sep 2025 15:14:28 +0900
Message-Id: <20250930061428.617955-1-hy50.seo@samsung.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250930061604epcas2p3f341c32c50f267aa6bd3ae0e82adfbf3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
cpgsPolicy: CPGSC10-234,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250930061604epcas2p3f341c32c50f267aa6bd3ae0e82adfbf3
References: <CGME20250930061604epcas2p3f341c32c50f267aa6bd3ae0e82adfbf3@epcas2p3.samsung.com>

From: "hy50.seo" <hy50.seo@samsung.com>

If the UTP error occurs alone, the UFS is not recovered.
It does not check for error and only generates io timeout or OCS error.
This is because UTP error is not defined in error handler.
To fixed this, added UTP error flag in FATAL_ERROR.
So UFS will reset is performed when a UTP error occurs.

sd 0:0:0:0: [sda] tag#38 UNKNOWN(0x2003) Result: hostbyte=0x07
driverbyte=DRIVER_OK cmd_age=0s
sd 0:0:0:0: [sda] tag#38 CDB: opcode=0x28 28 00 00 51 24 e2 00 00 08 00
I/O error, dev sda, sector 42542864 op 0x0:(READ) flags 0x80700 phys_seg
8 prio class 2
OCS error from controller = 9 for tag 39
pa_err[1] = 0x80000010 at 2667224756 us
pa_err: total cnt=2
dl_err[0] = 0x80000002 at 2667148060 us
dl_err[1] = 0x80002000 at 2667282844 us
No record of nl_err
No record of tl_err
No record of dme_err
No record of auto_hibern8_err
fatal_err[0] = 0x804 at 2667282836 us

---------------------------------------------------
		REGISTER
---------------------------------------------------
                           NAME	      OFFSET	         VALUE
                    STD HCI SFR	  0xfffffff0	           0x0
                           AHIT	        0x18	         0x814
               INTERRUPT STATUS	        0x20	        0x1000
               INTERRUPT ENABLE	        0x24	       0x70ef5

Signed-off-by: hy50.seo <hy50.seo@samsung.com>
---
 include/ufs/ufshci.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
index 612500a7088f..e64b70132101 100644
--- a/include/ufs/ufshci.h
+++ b/include/ufs/ufshci.h
@@ -180,6 +180,7 @@ static inline u32 ufshci_version(u32 major, u32 minor)
 #define UTP_TASK_REQ_COMPL			0x200
 #define UIC_COMMAND_COMPL			0x400
 #define DEVICE_FATAL_ERROR			0x800
+#define UTP_ERROR				0x1000
 #define CONTROLLER_FATAL_ERROR			0x10000
 #define SYSTEM_BUS_FATAL_ERROR			0x20000
 #define CRYPTO_ENGINE_FATAL_ERROR		0x40000
@@ -199,7 +200,8 @@ static inline u32 ufshci_version(u32 major, u32 minor)
 				CONTROLLER_FATAL_ERROR |\
 				SYSTEM_BUS_FATAL_ERROR |\
 				CRYPTO_ENGINE_FATAL_ERROR |\
-				UIC_LINK_LOST)
+				UIC_LINK_LOST |\
+				UTP_ERROR)
 
 /* HCS - Host Controller Status 30h */
 #define DEVICE_PRESENT				0x1
-- 
2.34.1

