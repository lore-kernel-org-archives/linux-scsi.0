Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3528233938
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 07:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784792856; cv=none; b=p1UU0OmSO9Pra8g1gsC+iweuJeUDqwt3HR3HS1WvOBK+DhmSZ7uPywEM/gotNH+KE3ZAM1Mp+MpTtQ2dvujTclZaIQG48mc8U021GSyAu3Q1y7q72NMJvG3iQTKRm7wwLhEsY+mHyFJFTgpHSIYV9Ss0z9pYKH/vm7NvPeT5ekI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784792856; c=relaxed/simple;
	bh=GDDizwXh09Qv81UVMsJEwZE5e6/RHAuCYgzrAyeXefw=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=NB1NCgKTnB0vK15TuliWKHg6ed7fuqUn/b/y66F7wmToMrdzinJd6nvOu01bupvZx+JAYtSY0avPsGfzwPWKd1NWfoVkHm46Sq9+AQncUcmxHR4AlDGPlQy/1wLzSRp40RTg2ZkZVQvUWb/w5RhJsF5JLzwmucKgXf67LNNMJ80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=n09yYiya; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="n09yYiya"
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20260723074726epoutp03d6ec44e76ebbf585ab797de92e3ea722~E26MmTO-D2749027490epoutp03G
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 07:47:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20260723074726epoutp03d6ec44e76ebbf585ab797de92e3ea722~E26MmTO-D2749027490epoutp03G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1784792846;
	bh=xUhdjHYTDqk1gm9uAS8I6T7vW6ta4GdrhV+NmxfuMvM=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=n09yYiyaK9kbjXVQEjhHaQeqOFe3ujbW0+Z/PtTUn87Fz0VlLDOIePeBOvDyAq7Nl
	 FEzi5eLYfdn09doC1XvpgClhTcV9O21A/B8hOivWxj7YjwBGufTWf03Toi9Xuk49He
	 nilrZYabl9oYWs3W1d5AwUS2sM3ViwvWxi1c+g64=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas2p2.samsung.com (KnoxPortal) with ESMTPS id
	20260723074725epcas2p2c53632d213bfd0e526c26a823f7450ee~E26MPjYbb0373503735epcas2p25;
	Thu, 23 Jul 2026 07:47:25 +0000 (GMT)
Received: from epcas2p2.samsung.com (unknown [182.195.38.212]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4h5NWK2jgHz6B9m6; Thu, 23 Jul
	2026 07:47:25 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: Re: [PATCH v2] scsi: ufs: Add support for the aggregated read query
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
In-Reply-To: <13d80afa-3d5c-405f-8845-6dccb048bd97@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20260723074724epcms2p16cc926dd07e3f932db8efb71d1e1268c@epcms2p1>
Date: Thu, 23 Jul 2026 16:47:24 +0900
X-CMS-MailID: 20260723074724epcms2p16cc926dd07e3f932db8efb71d1e1268c
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
cpgsPolicy: CPGSC10-223,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260710053524epcms2p82121eba4240c37112fc5669430035442
References: <13d80afa-3d5c-405f-8845-6dccb048bd97@acm.org>
	<20260722084819epcms2p49c27fce999e821385f7b5d7ea5a02868@epcms2p4>
	<CGME20260710053524epcms2p82121eba4240c37112fc5669430035442@epcms2p1>

Hi Bart,

Thanks a lot for the detailed review. I've addressed the comments and
will send a v3. Replies inline below.

On 7/23/26 2:09 AM, Bart Van Assche wrote:
> > -	/* sizeof(struct utp_transfer_cmd_desc) must be a multiple of 128 */
> > +	/* Both UCD types must be a multiple of 128 */
>
> "must be" -> "must have a size that is"
>
> "128" -> "128 bytes"

Done. Now the comment is:
	/* Both UCD types must have a size that is a multiple of 128 bytes */

> > -    *desc_len = min_t(int, QUERY_DESC_MAX_SIZE, desc_size);
> > +    if (desc_op == UPIU_QUERY_OPCODE_AGGREGATED_READ)
> > +        *desc_len = min_t(int, QUERY_AGGREGATED_MAX_SIZE, desc_size);
> > +    else
> > +        *desc_len = min_t(int, QUERY_DESC_MAX_SIZE, desc_size);
>
> Please convert this patch into a series and add a patch before this
> patch that changes the data types of desc_size and desc_len from 'int'
> and 'int *' into unsigned types (u16 or unsigned int). The length field
> is an unsigned 16-bits number according to the UFS standard. Hence, the
> UFS driver should use an unsigned type for the UPIU query length.
>
> This will allow to change "min_t(int, ...)" into "min(...)".

Done. v3 will be two-patch series:
  [1/2] scsi: ufs: Use unsigned types for the BSG query descriptor length
  [2/2] scsi: ufs: Add support for the aggregated read query opcode

Patch 1 switches the descriptor length/buffer to u16/u8 and uses min()
instead of min_t(int, ...).

> Since 'desc_op' is only used derive the maximum query size, wouldn't it
> be better to move the code that limits 'desc_len' into
> ufs_bsg_request()? Then 'desc_op' won't have to be passed to
> ufs_bsg_get_query_desc_size().

Agreed. ufs_bsg_get_query_desc_size() was trivial, so I folded it into
its only caller, ufs_bsg_alloc_desc_buffer(), where desc_op is already
available.

> > +    if (unlikely(blk_mq_is_reserved_rq(scsi_cmd_to_rq(cmd)))) {
> [...]
> > +    } else {
> > +        int slot = i - UFSHCD_NUM_RESERVED;
> [...]
>
> The above code is based on the assumption that
> !blk_mq_is_reserved_rq(rq) implies that i >= 1. Please add a
> WARN_ON_ONCE() statement that makes this assumption explicit, e.g.
> WARN_ON_ONCE(slot >= 0).

Done, added WARN_ON_ONCE(slot < 0) in the non-reserved branch (the
assumption is slot >= 0, so the WARN fires when it does not hold).

> > +    int tag;
>
> Shouldn't 'tag' have an unsigned type?

Done. I made it a u8 in struct ufs_dev_cmd.

> > +static inline size_t ufshcd_get_devman_ucd_size(const struct ufs_hba *hba)
> > +{
> > +    return sizeof(struct utp_devman_cmd_desc) + SG_ALL * ufshcd_sg_entry_size(hba);
> > +}
>
> Why SG_ALL? The data buffer for device management commands is allocated
> with kmalloc() and hence is contiguous so a single segment descriptor
> should be sufficient.

This is the one comment I haven't applied yet, and I'd like to
double-check with you before doing so.

The aggregated read path indeed does not use the PRDT at all. But
the reserved tag is also used by advanced RPMB. I understood that path
builds a PRDT via ufshcd_sgl_to_prdt() from the BSG payload, whose sg_cnt
can exceed one when the user buffer spans multiple segments. Keeping
SG_ALL preserves the existing RPMB behaviour; I thought shrinking to a
single segment could truncate multi-segment transfers.

Did I miss something about how RPMB maps its payload here? If a single
segment is in fact guaranteed, I'll drop the prd_table[] member and size
it as:
/* Dedicated UCD for the devman/reserved slot */
struct utp_devman_cmd_desc {
        u8 command_upiu[ALIGNED_UPIU_SIZE];
        u8 response_upiu[ALIGNED_DEVMAN_RSP_SIZE];
};

static inline size_t ufshcd_get_devman_ucd_size(const struct ufs_hba *hba)
{
        return sizeof(struct utp_devman_cmd_desc);
}

Separately, I fixed the Sashiko-flagged OOB read in v3. I capped
QUERY_AGGREGATED_MAX_SIZE (4096 -> 4064) so that the fixed 32-byte UPIU
header plus a full data segment fits within the 4096-byte
response_upiu[], and added a static_assert to prevent regression. 4064
is still well above the ~3 KiB the spec allows in practice.

Thanks.
