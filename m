Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF9A314B6B
	for <linux-scsi@vger.kernel.org>; Thu, 27 Nov 2025 07:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764227299; cv=none; b=JGlgucV4mS4EJ7vHwaCpBgm5ec9GphD/DifnsO8Og6DlMS0ep3P5Kt8/EFAcHA5V5Kp4QgdHPDqXr9ws+siaL5IzCYMHsXHgSmhmi9r0vCI6CxD1nwUC1bQL+fjDQ7jm71ZkGIJNfiRSRQMw5v30l3F787215Ii78PqbbjrQM78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764227299; c=relaxed/simple;
	bh=RSZScOXXMI4KuMuqRbrRHS+sopsbVWnU+Gujt3UU+S8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:MIME-Version:
	 Content-Type:References; b=bLZ0ou5k6N6TH8fmsA0eHGI3+nbdu70Vn9zU7BK8XdKj8ceqVBHWeO4K2tDcvNwKo2mifymfB7FcEFPu6wO+E3VH6kO6cuWlJeFAfZ3Fg5gXY/l27ktZ0xiqy5k/rFEilQZGkWa/mCk+idSjZZANMrZJRHCRI6/xK4DkD6sHCjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ihDT2pY0; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ihDT2pY0"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20251127070814epoutp013acdbd3208559d619d1de6ff76a948f4~7y2BwQc6p1436114361epoutp01B
	for <linux-scsi@vger.kernel.org>; Thu, 27 Nov 2025 07:08:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20251127070814epoutp013acdbd3208559d619d1de6ff76a948f4~7y2BwQc6p1436114361epoutp01B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1764227294;
	bh=lHXqlqf/+U/0XZ9uZ9w8EqQ2AwbhYzEvTxuNr0Oi4tA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ihDT2pY05suGNfpCdKPtCUNdoh0uLlLPJx9iA3UrDy4vDsQe4vRT/rBlkwN1N0B4h
	 Q9xJ3at519oq//JQotp1JjwNVGF1FerWaZm55sFTiGtLoof7Zm5Bw3q8bU3Konw8rq
	 JFsvnv974BTqC3pDPohwB6LbYfgyejfLlCMV8qU4=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20251127070813epcas5p2d532acbf0bbfe0cbfb88854f306c7f5c~7y2Bdmsgn2005620056epcas5p2q;
	Thu, 27 Nov 2025 07:08:13 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.92]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4dH6vw53Kfz2SSKq; Thu, 27 Nov
	2025 07:08:12 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20251127070712epcas5p4113a2d14bd4be7eaef6be6164b1f8cec~7y1IvhyHB0624706247epcas5p43;
	Thu, 27 Nov 2025 07:07:12 +0000 (GMT)
Received: from testpc12933.samsungds.net (unknown [109.105.129.33]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20251127070711epsmtip26b2eaf00505a75e543b9ce7837da6c91~7y1HpO0F61979519795epsmtip2_;
	Thu, 27 Nov 2025 07:07:11 +0000 (GMT)
From: "zheng.gong" <zheng.gong@samsung.com>
To: linux-scsi@vger.kernel.org
Cc: avri.altman@wdc.com, bvanassche@acm.org, quic_cang@quicinc.com,
	alim.akhtar@samsung.com, martin.petersen@oracle.com, ebiggers@kernel.org,
	linux-kernel@vger.kernel.org, "zheng.gong" <zheng.gong@samsung.com>
Subject: [PATCH v2 0/2] scsi: ufs: Add crypto_keyslot_remap support
Date: Thu, 27 Nov 2025 15:06:57 +0800
Message-ID: <20251127070704.2935390-1-zheng.gong@samsung.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251112031035.GA2832160@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="1a2s3d4f!@"
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251127070712epcas5p4113a2d14bd4be7eaef6be6164b1f8cec
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-505,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251127070712epcas5p4113a2d14bd4be7eaef6be6164b1f8cec
References: <20251112031035.GA2832160@google.com>
	<CGME20251127070712epcas5p4113a2d14bd4be7eaef6be6164b1f8cec@epcas5p4.samsung.com>

This patch series adds support for platform-specific crypto keyslot remapping
in the UFS host driver, enabling secure inline encryption in multi-domain
environments (e.g., VMs).

The first patch introduces a new variant operation:
  ufs_hba_variant_ops::crypto_keyslot_remap
which allows platforms to adjust the keyslot index at request submission time.

The second patch adds a test module (CONFIG_SCSI_UFS_CRYPTO_TEST) to
demonstrate how the new hook is used — by applying a fixed offset to simulate
domain-specific keyslot layout. This patch series is in response to feedback from Eric on the v1 submission,
where he noted that the new callback needed to be used to make sense. Just a demonstration
of the new callback is included in this patch series.

Apologies for the delay in resubmitting — we have now added a test module to demonstrate
the usage of crypto_keyslot_remap in multi-domain environments.

Thank you for the review.

Changes since v1:
  - Added a test module to demonstrate usage of crypto_keyslot_remap
  - Fixed platform_driver.remove type (void, not int)
  - Improved commit message clarity

zheng.gong (2):
  scsi: ufs: crypto: Add ufs_hba_variant_ops::crypto_keyslot_remap
  scsi: ufs: Add crypto keyslot remapping test module

 drivers/ufs/core/Kconfig              | 17 +++++
 drivers/ufs/core/Makefile             |  1 +
 drivers/ufs/core/ufshcd-crypto-test.c | 90 +++++++++++++++++++++++++++
 drivers/ufs/core/ufshcd-crypto.h      | 10 ++-
 drivers/ufs/core/ufshcd.c             |  9 +--
 include/ufs/ufshcd.h                  |  6 ++
 6 files changed, 127 insertions(+), 6 deletions(-)
 create mode 100644 drivers/ufs/core/ufshcd-crypto-test.c
