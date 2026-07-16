Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C0227587D
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2026 02:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784170312; cv=none; b=sFs4CByQNxKpPH5VsJ/ou6YClnv+kJc9W2VPSnGJMJ6HD4UJy3CU0QZL6bHWhjZ+MOFQqIhVFrK3eHdxXCKvUbwHDFCwQoVlIcQ32Wk8IVDyfnvSqgWjLD6xn8uB2q3I/gzG1RIWB31nFto7VznafPhlaGwwB2WenkPXRKA3d7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784170312; c=relaxed/simple;
	bh=alJeeTHB7A8GEpExkSUYkHBHKeMWjTtaE27dZdg9TZ0=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=h5GkYwmaXoPuiAFF2gr6v5FRLMvJtshM6iTFP+M/EtpLHJa6wl2zh8SXJyEQb9jcd1SD3kgXdyhKa3z6xcW9Xpldg7LMYLlHN7u7CqD8I3Hks+9sXk3iuT8Lxl90qNMlqnfO7GNjDu27eWhH2rL041cCEn/JH8eP1WE/LgLE9eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=XkVIKtRn; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="XkVIKtRn"
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260716025141epoutp011a50a4d1a794f85e1024a7af1bb01ad8~CpW_5aQ130874608746epoutp01Y
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2026 02:51:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260716025141epoutp011a50a4d1a794f85e1024a7af1bb01ad8~CpW_5aQ130874608746epoutp01Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1784170301;
	bh=CTrAxUFhVtk9JM5cJE+p52NPXzFmUGmAmfja3jZ6GoU=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=XkVIKtRnEkS0fudtaMFHqV1Rz+hr5HMxj1G13LdaDFsMldmYb9popym/3TdiIPldB
	 M7P20CSSHiZxfaV0UgjBCb3meJALYz5jJujC8EKmQDUeiVPTpfTG6Mj9o0vwzX2RgT
	 UGOCKoil25GraHYCNVGiSL+DwCJZFp3/kKtB+J28=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPS id
	20260716025141epcas2p2df0eb3c6e337d4f8838f40606b33d689~CpW_gik7w2085520855epcas2p2d;
	Thu, 16 Jul 2026 02:51:41 +0000 (GMT)
Received: from epcas2p3.samsung.com (unknown [182.195.38.204]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4h0yHJ6Wr9z6B9m9; Thu, 16 Jul
	2026 02:51:40 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: Re: [PATCH] scsi: ufs: Add support for the aggregated read query
 opcode
Reply-To: hyenc.jeong@samsung.com
Sender: Hyeoncheol Jeong <hyenc.jeong@samsung.com>
From: Hyeoncheol Jeong <hyenc.jeong@samsung.com>
To: Bart Van Assche <bvanassche@acm.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>
CC: ALIM AKHTAR <alim.akhtar@samsung.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Jinyoung Choi <j-young.choi@samsung.com>,
	Dukhyun Kwon <d_hyun.kwon@samsung.com>, Jeuk Kim <jeuk20.kim@samsung.com>,
	Keoseong Park <keosung.park@samsung.com>, Jaemyung Lee
	<jaemyung.lee@samsung.com>, Jieon Seol <jieon.seol@samsung.com>, Gyusun Lee
	<gyusun.lee@samsung.com>, Yunjae Jo <yunjae00.jo@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <a0d5f2bc-c343-43c5-93c9-a7b58be13242@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20260716025140epcms2p4f46c9c232d81ac1ffb9c2961ca758fde@epcms2p4>
Date: Thu, 16 Jul 2026 11:51:40 +0900
X-CMS-MailID: 20260716025140epcms2p4f46c9c232d81ac1ffb9c2961ca758fde
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260710053524epcms2p82121eba4240c37112fc5669430035442
References: <a0d5f2bc-c343-43c5-93c9-a7b58be13242@acm.org>
	<6d087f28-5795-4929-b5d3-3f78d9b9bc60@acm.org>
	<20260710054556epcms2p68986e2af26f42e63c87ab8fde034e450@epcms2p6>
	<20260713025227epcms2p41de509bb713eb7a6be2c945073be6b3a@epcms2p4>
	<CGME20260710053524epcms2p82121eba4240c37112fc5669430035442@epcms2p4>

On 7/13/26 09:55 PM, Bart Van Assche wrote:
> On 7/12/26 7:52 PM, Hyeoncheol Jeong wrote:
> > Would it be okay to keep utp_transfer_cmd_desc as is and give
> > just the reserved tag a dedicated 4 KiB response descriptor?
> > Regular tags and normal I/O would stay unchanged.
>
> That sounds better to me but how to implement the above proposal
> without slowing down the hot path?

Hi Bart,

Here's what I'm thinking. Keep utp_transfer_cmd_desc as is (512 B) and
add a dedicated 4 KiB one just for the reserved tag:

struct utp_devman_cmd_desc {
	u8 command_upiu[ALIGNED_UPIU_SIZE];
	u8 response_upiu[ALIGNED_DEVMAN_RSP_SIZE];      /* 4 KiB */
	u8 prd_table[];
};
Allocated as a single instance, this keeps the extra cost to +(4 KiB - 512 B)
per host without growing any per-tag structure.

This probably touches two spots on the hot path, though hopefully only
slightly. First, ufshcd_init_lrb() would gain a reserved-tag check to
pick the descriptor:

if (unlikely(blk_mq_is_reserved_rq(scsi_cmd_to_rq(cmd))))
	p = hba->devman_ucd_base_addr;
else
	p = ... + (i - UFSHCD_NUM_RESERVED) * ufshcd_get_ucd_size(hba);
Since the reserved tag is only ever used for device management, this
branch is always false for normal I/O and should be well predicted.

The other is the pre-4.1 MCQ tag recovery, which would gain a check
before the existing division:

if (addr == hba->devman_ucd_dma_addr)
    return 0;       /* reserved tag */
It just gets one extra compare, and on UFSHCI 4.1+ the CQE carries
the tag directly, so that path isn't hit at all.

If the direction sounds reasonable, I'll prepare it as v2.

Thanks.
