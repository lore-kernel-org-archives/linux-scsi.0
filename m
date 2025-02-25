Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702842561AF
	for <linux-scsi@vger.kernel.org>; Tue, 25 Feb 2025 05:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740460323; cv=none; b=DZ9QxEY68/QtxXkXM3pAQ8651qW6Ed0XFEQ9JrUYelo003ZQ8qgnLAqbRLd7CCwHL3eZZ4zE1silCv5agk+qGQrGFoXMY16i3nUL33toCJuNJn8JtWJ9csa4jzc+uJKGoqfN/KrWzz7cxK1UgFphOnwsp01Zka1PfLiejVr999M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740460323; c=relaxed/simple;
	bh=yJi2Cx14sSyS29LWyd5Tm76UaUyTByOH9I+D8gJFLQw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=A/BE9sMmVecViEQioG/guIl2qV3owBz0338+/rcKL1M44poh2JJb5rSFdR776pITo/9yxERugFUIsJsYe2rYKTyspvTo9HhmLETFD6H+L1DW0XEtW2Hp0yKKf1xJcAQg/vNRCdzdsTcWVNhvibRnFCxHHGzPP3e6GM07+WN5row=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=AS9bOm6U; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="AS9bOm6U"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250225051153epoutp04d45ccf6cbb213e8c4c35472207f76bda~nW28P9oUE0082400824epoutp04c
	for <linux-scsi@vger.kernel.org>; Tue, 25 Feb 2025 05:11:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250225051153epoutp04d45ccf6cbb213e8c4c35472207f76bda~nW28P9oUE0082400824epoutp04c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1740460313;
	bh=8FlbVLaO/o7H2l1eNQnRbhbKI/JOMdEUHa8eyijxoXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AS9bOm6UpuzkFcpS1xBnrrhqrEO5382y2eEMHsjCWwWdEOs4OJJSfF54HeJ/0Uu9a
	 9woK7LeThi15kZr2MDzxzDJJjLBO4NtMbigx13f51VDhustnMcg7mlmU9QD1sH5YYh
	 4RYJsovYIHrcja7WuM/NJ26eTYfAxSZ620ZykBAI=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20250225051153epcas5p4d72ff1e4eac5087087dfab0624a9e430~nW271EsKh0382603826epcas5p4o;
	Tue, 25 Feb 2025 05:11:53 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.182]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4Z25Lb0ySgz4x9Q2; Tue, 25 Feb
	2025 05:11:51 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	2B.0F.19710.6115DB76; Tue, 25 Feb 2025 14:11:50 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250225045514epcas5p10d06ab361a4125a94933fa8235fe3fa8~nWoaALfVu1699516995epcas5p1_;
	Tue, 25 Feb 2025 04:55:14 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20250225045514epsmtrp1d0f23dbbee92f5ff06566717c072b986~nWoZ-VYIG1649716497epsmtrp1F;
	Tue, 25 Feb 2025 04:55:14 +0000 (GMT)
X-AuditID: b6c32a44-36bdd70000004cfe-bc-67bd51160b69
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	8D.4C.23488.23D4DB76; Tue, 25 Feb 2025 13:55:14 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250225045512epsmtip261a520979b8ef8fd960439b5d14a5574~nWoYGLxXI3047130471epsmtip2b;
	Tue, 25 Feb 2025 04:55:12 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com
Cc: anuj1072538@gmail.com, nikh1092@linux.ibm.com,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org, dm-devel@lists.linux.dev, Anuj Gupta
	<anuj20.g@samsung.com>, M Nikhil <nikhilm@linux.ibm.com>
Subject: [PATCH v1 1/3] block: Fix incorrect integrity sysfs reporting for
 DM devices
Date: Tue, 25 Feb 2025 10:16:51 +0530
Message-Id: <20250225044653.6867-2-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250225044653.6867-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIJsWRmVeSWpSXmKPExsWy7bCmlq5Y4N50g+37bSw+fv3NYtE04S+z
	xeq7/WwWCxbNZbFYufook8WkQ9cYLfbe0raYv+wpu0X39R1sFsuP/2OyuHvxKbPFzvZjjA48
	Hjtn3WX3uHy21GPTqk42jwmLDjB6bF5S7/Fi80xGj903G9g8Pj69xeLRt2UVo8fnTXIBXFHZ
	NhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAVysplCXm
	lAKFAhKLi5X07WyK8ktLUhUy8otLbJVSC1JyCkwK9IoTc4tL89L18lJLrAwNDIxMgQoTsjMW
	PlnAUnBAuGJnx12mBsbFAl2MnBwSAiYSr6edYuti5OIQEtjNKLFi/SVmCOcTo8TkP++ZIJxv
	jBI73i9ngmk58fssVGIvo0R74ywo5zOjxJUVN1hAqtgE1CWOPG9lBLFFBAIkZp2+wghSxCzw
	nlHidX8XG0hCWCBc4tnm2WA2i4CqxNTm9cwgNq+AhcSvr+tZIdbJS8y89J0dxOYUsJSYcKiX
	FaJGUOLkzCdgy5iBapq3zgY7XEJgLYdEZ8McqFtdJD7f/Q5lC0u8Or6FHcKWknjZ3wZlp0v8
	uPwUqqZAovnYPkYI216i9VQ/0FAOoAWaEut36UOEZSWmnlrHBLGXT6L39xOoVl6JHfNgbCWJ
	9pUwJ0hI7D3XAGV7SLzc95EFElo9jBJNM/rZJjAqzELyzywk/8xCWL2AkXkVo2RqQXFuemqy
	aYFhXmo5PJ6T83M3MYLTspbLDsYb8//pHWJk4mA8xCjBwawkwsuZuSddiDclsbIqtSg/vqg0
	J7X4EKMpMMAnMkuJJucDM0NeSbyhiaWBiZmZmYmlsZmhkjhv886WdCGB9MSS1OzU1ILUIpg+
	Jg5OqQamSy52Vm0fRL746S9gtha/dmkS9xSP1Avb6vL5Lvh89zAqT7lUvsV46QHORxfDwzqv
	2L9xaui87nvF7Kz4tR1iNRF+G/e0yf7oOfae77C3gG76JZ/1siZ+h2Q3S4ZUmi+btE3dfqtV
	7FuuuivpTNHLPc5/Vd0hK9Y5gUs05+av2CrF3/Ha9e6HqsJ2fGVhqcxO8NNNdN7fx7VC/Jyn
	lYafz8yXuR0B+XJpZ2OY+LL2X627fedalXD2a+nUpaIZ0z1u/7FlqH2jz3uxt/O3X8S/DKtF
	Lze4zzeedULm5edJbCneFf5bjjAt3x6jL741hu224PSJAXersycazPrpt+ykwtRru/z/l/4x
	71P61qDEUpyRaKjFXFScCACo2ytsVAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCLMWRmVeSWpSXmKPExsWy7bCSvK6R7950g3sNShYfv/5msWia8JfZ
	YvXdfjaLBYvmslisXH2UyWLSoWuMFntvaVvMX/aU3aL7+g42i+XH/zFZ3L34lNliZ/sxRgce
	j52z7rJ7XD5b6rFpVSebx4RFBxg9Ni+p93ixeSajx+6bDWweH5/eYvHo27KK0ePzJrkArigu
	m5TUnMyy1CJ9uwSujIVPFrAUHBCu2Nlxl6mBcbFAFyMnh4SAicSJ32eZuhi5OIQEdjNKTG99
	yAyRkJA49XIZI4QtLLHy33N2EFtI4COjxNaZXCA2m4C6xJHnrUA1HBwiAiESPUdMQOYwC3xn
	lDjRcp0NpEZYIFRiy5XHLCA2i4CqxNTm9WDzeQUsJH59Xc8KMV9eYual72DzOQUsJSYc6mUF
	mSkEVHNhZTREuaDEyZlPwMYwA5U3b53NPIFRYBaS1CwkqQWMTKsYJVMLinPTc5MNCwzzUsv1
	ihNzi0vz0vWS83M3MYIjRktjB+O7b036hxiZOBgPMUpwMCuJ8HJm7kkX4k1JrKxKLcqPLyrN
	SS0+xCjNwaIkzrvSMCJdSCA9sSQ1OzW1ILUIJsvEwSnVwGQnX7XIWolb943U66WOUfstsyou
	fPWUV6tJ/787mNl2X2648ycnDu2Zrrt7LS2ucz9Rejv9F1+phNblyus6XoI3F81ifsoa9NJS
	54r+J/PDF/Pk1dOXfVaYml1VWxp+Qvfm1gdZ8Xfnq3SLH7t69FHM2k1Sa+wWb+ZaWJH/R+xS
	3LHzmR5cm74yvlZcE3j389O1rcJz1nYzp+za/SZNZa5oTtakOCXTLWf6PfKS+L4bPmo5c4uV
	Q59BNOlFJOsZGQum3GPvrx5Zt3vNSVuFtoMxDFLCSdwlfo1uc2zEZLZaynktsNXa8tCr2YiP
	02jPJkHhQ81ZDVOX66vuZ1e6obmo1UPvw4fwLX7M8z9UKbEUZyQaajEXFScCAHe30sIHAwAA
X-CMS-MailID: 20250225045514epcas5p10d06ab361a4125a94933fa8235fe3fa8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250225045514epcas5p10d06ab361a4125a94933fa8235fe3fa8
References: <20250225044653.6867-1-anuj20.g@samsung.com>
	<CGME20250225045514epcas5p10d06ab361a4125a94933fa8235fe3fa8@epcas5p1.samsung.com>

The integrity stacking logic in device-mapper currently does not
explicitly mark the device with BLK_INTEGRITY_NOGENERATE and
BLK_INTEGRITY_NOVERIFY when the underlying device(s) do not support
integrity. This can lead to incorrect sysfs reporting of integrity
attributes.

Additionally, queue_limits_stack_integrity() incorrectly sets
BLK_INTEGRITY_DEVICE_CAPABLE for a DM device even when none of its
underlying devices support integrity. This happens because the flag is
blindly inherited from the first base device, even if it lacks integrity
support.

This patch ensures:
1. BLK_INTEGRITY_NOGENERATE and BLK_INTEGRITY_NOVERIFY are set correctly:
   - When the underlying device does not support integrity.
   - When integrity stacking fails due to incompatible profiles.
2. device_is_integrity_capable is correctly propagated to reflect the
actual capability of the stacked device.

Reported-by: M Nikhil <nikhilm@linux.ibm.com>
Link: https://lore.kernel.org/linux-block/f6130475-3ccd-45d2-abde-3ccceada0f0a@linux.ibm.com/
Fixes: c6e56cf6b2e7 ("block: move integrity information into queue_limits")
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 block/blk-settings.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index c44dadc35e1e..c32517c8bc2e 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -861,7 +861,8 @@ bool queue_limits_stack_integrity(struct queue_limits *t,
 
 	if (!ti->tuple_size) {
 		/* inherit the settings from the first underlying device */
-		if (!(ti->flags & BLK_INTEGRITY_STACKED)) {
+		if (!(ti->flags & BLK_INTEGRITY_STACKED) &&
+		    (bi->flags & BLK_INTEGRITY_DEVICE_CAPABLE)) {
 			ti->flags = BLK_INTEGRITY_DEVICE_CAPABLE |
 				(bi->flags & BLK_INTEGRITY_REF_TAG);
 			ti->csum_type = bi->csum_type;
@@ -871,8 +872,11 @@ bool queue_limits_stack_integrity(struct queue_limits *t,
 			ti->tag_size = bi->tag_size;
 			goto done;
 		}
-		if (!bi->tuple_size)
+		if (!bi->tuple_size) {
+			ti->flags |= BLK_INTEGRITY_NOGENERATE |
+				     BLK_INTEGRITY_NOVERIFY;
 			goto done;
+		}
 	}
 
 	if (ti->tuple_size != bi->tuple_size)
@@ -893,6 +897,7 @@ bool queue_limits_stack_integrity(struct queue_limits *t,
 
 incompatible:
 	memset(ti, 0, sizeof(*ti));
+	ti->flags |= BLK_INTEGRITY_NOGENERATE | BLK_INTEGRITY_NOVERIFY;
 	return false;
 }
 EXPORT_SYMBOL_GPL(queue_limits_stack_integrity);
-- 
2.25.1

