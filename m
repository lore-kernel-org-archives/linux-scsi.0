Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5F029D293
	for <linux-scsi@vger.kernel.org>; Thu, 29 Jan 2026 03:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769656824; cv=none; b=mClPLPEJHjloSXfI+jS2NBk65yR/rjA42c3v5Zum72NKtwXg7AkUFhLxjwsJ/ezX24U0hegYzc0SSwROf3Hf/85YuL7fobwC5RgEWGqV5TtxtF/5DTE/WspCi4BfmUtJPU1ON5Xm+wNvT/7dVpC17d4XF0VYZEjxnMrbLXFbox4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769656824; c=relaxed/simple;
	bh=yQPJ4GFNyXGAOkR8CTwUmXYRfxABL75TYNhGtTZmUTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:MIME-Version:
	 Content-Type:References; b=uMT5gz89xTDCJHWAjHpeX6MtfeGNVtr5fDTm+l5r8i3ex7smR7LT4+9oCG+jcPzYHupn/wU62Z588v7sSNOLPc8ZpqlSVEzRmq4oqo2I7QTUicr6dQKyOE4T7DiW1kQP0rb1O/aidwmZgu4wJmWfrd8F2GlPR5fn/wuoxa7c5Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=myXdrCbq; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="myXdrCbq"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20260129032019epoutp0382c44a3d500f2376c1b26b7543c6bcc7~PFYBxT5An2252322523epoutp03I
	for <linux-scsi@vger.kernel.org>; Thu, 29 Jan 2026 03:20:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20260129032019epoutp0382c44a3d500f2376c1b26b7543c6bcc7~PFYBxT5An2252322523epoutp03I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1769656820;
	bh=dxOGgWTz2qsdcXCisfq99m95YS1mWPUuBANvG+zg+/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=myXdrCbqThfNV1xjnqjCves6hDLF4+sGYS9/FMeYhTvc8ijujGY8Q7YJC8TBr3lNf
	 NkwbAbxm8L4tWZ9KQ8EZR53ty3JQ77miBZuFIRx8nLUCpn50yxwp1mrPp0GGo/kfdr
	 7wAbS2IL2etT/ZXYPmhkm1yxfUIpRaoSKl3v1238=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20260129032019epcas5p21f605eac32f9f1d2dabc4c067af323ba~PFYBQh4ON1818718187epcas5p2b;
	Thu, 29 Jan 2026 03:20:19 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.93]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4f1kst2ypjz2SSKj; Thu, 29 Jan
	2026 03:20:18 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20260129031038epcas5p3975b1f66414a7393b85c362523ebe1b8~PFPkiqM3y1571115711epcas5p3b;
	Thu, 29 Jan 2026 03:10:38 +0000 (GMT)
Received: from testpc12933.samsungds.net (unknown [109.105.129.33]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260129031037epsmtip168365c55793bea30e129507021d865ea~PFPjj5UKO0411304113epsmtip1o;
	Thu, 29 Jan 2026 03:10:37 +0000 (GMT)
From: "zheng.gong" <zheng.gong@samsung.com>
To: linux-scsi@vger.kernel.org
Cc: avri.altman@wdc.com, bvanassche@acm.org, quic_cang@quicinc.com,
	alim.akhtar@samsung.com, martin.petersen@oracle.com, ebiggers@kernel.org,
	linux-kernel@vger.kernel.org, "zheng.gong" <zheng.gong@samsung.com>
Subject: [PATCH v4 0/3] scsi: ufs: Add crypto_keyslot_remap support
Date: Thu, 29 Jan 2026 11:10:30 +0800
Message-ID: <20260129031033.3428295-1-zheng.gong@samsung.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251112031035.GA2832160@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260129031038epcas5p3975b1f66414a7393b85c362523ebe1b8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-505,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260129031038epcas5p3975b1f66414a7393b85c362523ebe1b8
References: <20251112031035.GA2832160@google.com>
	<CGME20260129031038epcas5p3975b1f66414a7393b85c362523ebe1b8@epcas5p3.samsung.com>

Hello Eric,

Sorry for late due to other affairs.

Readjuest the patchset adds support for platform-specific crypto keyslot
remapping in the exynos UFS host driver.

The 1st patch raise a new variant op:
  ufs_hba_variant_ops::crypto_keyslot_remap
which allows platforms to adjust the keyslot index at io request period.

The 2nd patch adds a real, upstream user in ufs-exynos.c that supports
remapping via device tree. This makes the hook justifiable for mainline
inclusion.

The 3rd patch adds DT binding description for the new property
'ufs-keyslot-offset'.

zheng.gong (3):
  scsi: ufs: crypto: Add ufs_hba_variant_ops::crypto_keyslot_remap
  scsi: ufs: exynos: Support crypto keyslot remapping via DT
  dt-bindings: ufs: Add binding for ufs-keyslot-offset

 .../bindings/ufs/samsung,exynos-ufs.yaml         |  5 +++++
 drivers/ufs/core/ufshcd-crypto.h                 | 10 ++++++++--
 drivers/ufs/core/ufshcd.c                        |  9 +++++----
 drivers/ufs/host/ufs-exynos.c                    | 16 ++++++++++++++++
 include/ufs/ufshcd.h                             |  6 ++++++
 5 files changed, 40 insertions(+), 6 deletions(-)

-- 
2.50.1

