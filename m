Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE482904
	for <linux-scsi@vger.kernel.org>; Tue, 25 Feb 2025 05:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740460327; cv=none; b=ccjRVRlgXx4Xwr13jOzhujNQvq7YGIpNjlKZzT3MX6tCfTkrcCZBY87l7NxsrdrPsGscXEcmGLEMZluhClb7mItC/3JKFO1fh8fhLIEUWYuBOpLjXOKpG68B9ed96IN6Dx118hpEaEL55H1VmxUiEG6R/f41zC8YXafA4HSDZeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740460327; c=relaxed/simple;
	bh=HK1Iqsygj+kpxTqmu43IDP04/FHAkBMHLKaFyoM1VMU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=RwJSnSsmvWNcy/yY6v9fjHO61bsKZ07rsjyBsjNJ2rKHE953n4r/a+Zg5odg1FcCj00xaXmb57CfCzjsiLxmvS0ieXfL6rSQQEl+RdH9LNgihuI0SlsRvBGVXxGAkEi2N0B8pSiZZ83wkgNYum40cRgKAcEkeywJ1KYajVILMS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=kfFV4Ei4; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="kfFV4Ei4"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250225051203epoutp03c0381281c05a7bb6aba3099484f724be~nW3FwKx5_2775827758epoutp03y
	for <linux-scsi@vger.kernel.org>; Tue, 25 Feb 2025 05:12:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250225051203epoutp03c0381281c05a7bb6aba3099484f724be~nW3FwKx5_2775827758epoutp03y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1740460323;
	bh=VCXl3ajc+8ZGubQRsc7OXxF8hZHNLnv0fXU3im0PirA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kfFV4Ei4dE1XoP9SgTWJS9FnDXk+KM4UurLRHZ9w/MRuW91WmPszo/xUxeJDMP1GR
	 MWztxGMDVFQtKkJeb2uAKeM7nd8I0ub7lzLl2Z3cAwgkBLNqsbURVw79Pjn3EYa3ki
	 F/+k+HX26sphiOUos6BVC0IVT+N8a4vD9EaGSnvc=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20250225051203epcas5p3e5bc333ffb75a03da2a22817f626fb7a~nW3FWZG1d0515805158epcas5p3N;
	Tue, 25 Feb 2025 05:12:03 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4Z25Lp0H1wz4x9Q3; Tue, 25 Feb
	2025 05:12:02 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	AC.9F.20052.1215DB76; Tue, 25 Feb 2025 14:12:01 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250225045519epcas5p2f1431355b6ab69305c1a431bfafbf7b6~nWoeeeuwb1006010060epcas5p2w;
	Tue, 25 Feb 2025 04:55:19 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20250225045519epsmtrp2f25a8ee5f1234328739692a4ca6fa6f4~nWoedwFPu0367803678epsmtrp22;
	Tue, 25 Feb 2025 04:55:19 +0000 (GMT)
X-AuditID: b6c32a49-3fffd70000004e54-42-67bd51216c0b
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	9F.4C.23488.73D4DB76; Tue, 25 Feb 2025 13:55:19 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250225045517epsmtip260411173872e85ea6cb80ea78ae41ad9~nWocTJ5_o2728127281epsmtip2c;
	Tue, 25 Feb 2025 04:55:16 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com
Cc: anuj1072538@gmail.com, nikh1092@linux.ibm.com,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org, dm-devel@lists.linux.dev, Anuj Gupta
	<anuj20.g@samsung.com>, M Nikhil <nikhilm@linux.ibm.com>
Subject: [PATCH v1 3/3] scsi: Fix incorrect integrity sysfs values when HBA
 doesn't support DIX
Date: Tue, 25 Feb 2025 10:16:53 +0530
Message-Id: <20250225044653.6867-4-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250225044653.6867-1-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xbVRzHd+4t7aVZzV3H5qHLRr0ZLgyBVkt3MUUat7g7t5guRhOH2t3A
	TYv05W2x+KQDgcgKdBpMKAwQGQwIewBjBdbJKo9Q4nAMIaBNyFIydFNkOGRhbrbcovvv8/ud
	7+95zsFQ8QBfguWYbAxrog0EX8jr+T4hIemZo16d7N71feTS/TUeWej6ByXbA5V8sqHxNI9s
	bR9CyC99U4D0ziaS9c3zAvLktIdPtow8QsjAjXmU7C0dBurNVK87IKBu/pBHdbZ9wadcjQOA
	6moqoBa6qgHVP+PgU0vzszyqorsNUMuduzTCY7kqPUNnM6yUMWWZs3NMunTi8Ova/dpUpUye
	JE8j9xFSE21k0okDRzRJr+QYQl0T0g9oQ17IpaGtViLlJRVrzrMxUr3ZaksnGEu2waKwJFtp
	ozXPpEs2MbYX5TLZ86kh4fFcffvCA2BxCPN/qnUJHKAHKwPRGMQVcO27i1FlQIiJ8X4AL9f3
	CTjjHoCTrc0oZ6wAeK1mAd0Icd6qiKi8AM4F+xDOWAZwqPAXQVjFx/fAwdvFIMwxuAa6xyZB
	WITiiwDeqSzjhw+24jQ8O+RGwszD4+HFmW/WWYSTsHb0WhRXLg5WT/y9njQaT4MuX3kUp9kC
	R6uDvDCjIU3RpZr1XiHegcGRplmECz4A66/cF3C8Ff420h1hCVz+w8vnWAdXb85H9BZYNHwV
	cJwBi/2VoaRYqEACPN+Xwrl3wir/OYSr+xQsXwtGQkXQU7fBBCxtrY0whN7rDiScBuIUvD0H
	uWU5ATy30oG4gNT9xDjuJ8Zx/1+5AaBtIJaxWI06xppqkZsY+3/XnGU2doL1p7z3kAcE5v5M
	9gEEAz4AMZSIEUXnXNGJRdn0hx8xrFnL5hkYqw+khvZ9CpVsyzKH/oLJppUr0mQKpVKpSHtB
	KSeeFhX1fq4T4zraxuQyjIVhN+IQLFriQPZMupI8i/sDXwXtj39u0dd2KXs6lI8rzpyYGB8b
	Z1drVTPanfZ8Xa4noNgevHR8xdizFNN2erfaL80XvtOs1iee6rx6Qzpx8vfqqkHfconq2Fhc
	grZ8YOb8QwcS5TS4NhNEk/CEM+5wbGaJ8qz/E/dbk9KvX5Xsupuvk6ofdjR8VlN2a1sBb5gd
	rGPfuPxAptn06FvXj71V/qN3c2Njdjdi79ZllHwqKP1L0DOOOt9ejBpUdJb/ajh4wefZNFFY
	c+GQ6s3X/FPPFiAZmYnqfjGbMj1a7Oieu4P1rcxJtxu6jGvO6qkdCjuU7LC/F5wZGex/jlbE
	v/9yy1r8dObqmY8JnlVPy/eirJX+F/zReHZTBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsWy7bCSvK657950g833pCw+fv3NYtE04S+z
	xeq7/WwWCxbNZbFYufook8WkQ9cYLfbe0raYv+wpu0X39R1sFsuP/2OyuHvxKbPFzvZjjA48
	Hjtn3WX3uHy21GPTqk42jwmLDjB6bF5S7/Fi80xGj903G9g8Pj69xeLRt2UVo8fnTXIBXFFc
	NimpOZllqUX6dglcGatf/GQsaOCquDpnAnsD4zaOLkZODgkBE4meR33sXYxcHEICuxklLq+9
	zwyRkJA49XIZI4QtLLHy33Oooo+MEudXNLCCJNgE1CWOPG8FKuLgEBEIkeg5YgJSwyzwnVHi
	RMt1NpAaYYF4ifN/poDVswioSmy8uZAJxOYVsJCYc/IgK8QCeYmZl76zg9icApYSEw71soLM
	FAKqubAyGqJcUOLkzCcsIDYzUHnz1tnMExgFZiFJzUKSWsDItIpRMrWgODc9N9mwwDAvtVyv
	ODG3uDQvXS85P3cTIzhmtDR2ML771qR/iJGJg/EQowQHs5IIL2fmnnQh3pTEyqrUovz4otKc
	1OJDjNIcLErivCsNI9KFBNITS1KzU1MLUotgskwcnFINTJO1b8S+L7ZwOlUl8k6cpVdXw8zy
	4zqRl/tMOScctU1233/wX8lm30tqqTsdDz7MXP9E1ZMhpfjTsdTkxV0LXC3WfFzy8uPHPUWP
	N5Xdlg9MTEqsPVqTlytQtNhc8eGUXM/mF5qVYcJx08qbSo399U9aZ1TNfBlcE/X1hvrnZQ0r
	tAtr/tZeMnA+tuTZq/XdaR+6nqozv+OzY1QMdg/9v2RTjv2XtTcMPpdY2Uu9+8No+Svseevh
	h5NbFV1T79jfKq+4Mztyv++01zyTy99eqdudcUecK8Ba4eQ9lVrF/0s6eyt/+30ULvz/p2VF
	4ZPd75rVs6dMWWrzrClm7eP3F97YttQuiSzaoP7swCuXo0osxRmJhlrMRcWJAGfzQFsIAwAA
X-CMS-MailID: 20250225045519epcas5p2f1431355b6ab69305c1a431bfafbf7b6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250225045519epcas5p2f1431355b6ab69305c1a431bfafbf7b6
References: <20250225044653.6867-1-anuj20.g@samsung.com>
	<CGME20250225045519epcas5p2f1431355b6ab69305c1a431bfafbf7b6@epcas5p2.samsung.com>

For SCSI disks where the host bus adapter (HBA) does not support
Data Integrity Extensions (DIX), the write_generate and read_verify sysfs
attributes incorrectly report 1 instead of 0.

This happens because the BLK_INTEGRITY_NOGENERATE and
BLK_INTEGRITY_NOVERIFY flags are not explicitly set when DIX is disabled.
Fix this by properly setting these flags when DIX is not enabled.

Reported-by: M Nikhil <nikhilm@linux.ibm.com>
Link: https://lore.kernel.org/linux-block/f6130475-3ccd-45d2-abde-3ccceada0f0a@linux.ibm.com/
Fixes: 9f4aa46f2a74 ("block: invert the BLK_INTEGRITY_{GENERATE,VERIFY} flags")
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 drivers/scsi/sd_dif.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index ae6ce6f5d622..be2cd06f500b 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -40,8 +40,10 @@ void sd_dif_config_host(struct scsi_disk *sdkp, struct queue_limits *lim)
 		dif = 0; dix = 1;
 	}
 
-	if (!dix)
+	if (!dix) {
+		bi->flags |= BLK_INTEGRITY_NOGENERATE | BLK_INTEGRITY_NOVERIFY;
 		return;
+	}
 
 	/* Enable DMA of protection information */
 	if (scsi_host_get_guard(sdkp->device->host) & SHOST_DIX_GUARD_IP)
-- 
2.25.1

