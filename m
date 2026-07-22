Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6267A43B6EB
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jul 2026 09:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784711001; cv=none; b=M6ImyUOhnqnLetYGWCDpGISVtQ4F/MIH6sME83qoSs8B0dmLYhqszFGh+EwlBEk3b3Hw3CSiLeLN6j48mOXTdOfQceAcvj1zLgQ8ZyvdpVCpOggletsa8Gc7pdH15qUipt/KB8Nzu6ihjPsnp3HGL9vAMjJpYHc7pcpkhKV71ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784711001; c=relaxed/simple;
	bh=mkKp0F5DS09FZ+evtYgGLmieK6SHWt0ya8+M9MypTgA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=S4gcS32d3tUiGMuGRZdJUv6eYo+VdCo9AeRhWhAJ4WJFIZA4pvs+ZLyI55mK2S7Bjr1/vpaTpQwrjANySv+ptP6QUWnTRzaE63hUp0/Jifguxit42gqBlwXe0lJDl4BaTxCbvGSC7cy9LdJHA4e4ED7ZxU4IC2Uoi7k8jYzTP4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S+wWKUvd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S+wWKUvd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C1C11F00A3A;
	Wed, 22 Jul 2026 09:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784711000;
	bh=a5Ai8Ob2Pa3KSY70NRh+ac1CuYw/3fOjAdsvPGgO/5k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=S+wWKUvdODI/QX9mSdRU04/1u4khq+colghKvtOp65wMD0tvWjon7rNAuGWItYWKb
	 fFrKNYoG/wHw8O99rC6jbS2NN0kXDaSjGd9+i2P9+nw3TDqjsGpLEBKi5SIaGbVXb6
	 ePNzcOXf8Vzj0aec4PFMshiAZwA1J0DjUTWnXTwpiVvYkPvsRSF69z/AmEvvlJKKFD
	 Tn9KlV4ghI/hvqm+JGPWfgD4dANLfQnN+i+yZuAl730IllyydcNvNmg4YDLEKq81oO
	 KSieJKfcoDnTOxCw9V5zcellTRDeUsSAs1X31cRs4Ngt2Xbj204H4DXp9aXsnfYPX0
	 QrmvZLUhlH8eQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] scsi: ufs: Add support for the aggregated read query
 opcode
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hyeoncheol Jeong" <hyenc.jeong@samsung.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260722084819epcms2p49c27fce999e821385f7b5d7ea5a02868@epcms2p4>
References: <CGME20260710053524epcms2p82121eba4240c37112fc5669430035442@epcms2p4>
 <20260722084819epcms2p49c27fce999e821385f7b5d7ea5a02868@epcms2p4>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 22 Jul 2026 09:03:19 +0000
Message-Id: <20260722090319.8C1C11F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The dedicated device management response buffer (ALIGNED_DEVMAN_RS=
P_SIZE) is exactly 4096 bytes, failing to account for the 32-byte Query Res=
ponse UPIU header. This leads to an out-of-bounds read into the adjacent PR=
DT array during a maximum-sized aggregated read, leaking kernel physical me=
mory addresses to userspace.
--

--- Patch [1]: [PATCH v2] scsi: ufs: Add support for the aggregated read qu=
ery opcode ---
commit b0be9d1800d5bb45da1d07516b525d85f757798b
Author: Hyeoncheol Jeong <hyenc.jeong@samsung.com>

scsi: ufs: Add support for the aggregated read query opcode

This commit introduces the AGGREGATED READ query opcode (0x9), returning an
aggregated data packet in a single query request. It allocates a dedicated
device management descriptor with a 4 KiB response area for the reserved tag
to handle the larger responses.

> diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
> index 58b506eac6dc4..176fedd496afe 100644
> --- a/drivers/ufs/core/ufs_bsg.c
> +++ b/drivers/ufs/core/ufs_bsg.c
> @@ -14,14 +14,18 @@
>  #include "ufshcd-priv.h"
> =20
>  static int ufs_bsg_get_query_desc_size(struct ufs_hba *hba, int *desc_le=
n,
> -				       struct utp_upiu_query *qr)
> +				       struct utp_upiu_query *qr,
> +				       enum query_opcode desc_op)
>  {
>  	int desc_size =3D be16_to_cpu(qr->length);
> =20
>  	if (desc_size <=3D 0)
>  		return -EINVAL;
> =20
> -	*desc_len =3D min_t(int, QUERY_DESC_MAX_SIZE, desc_size);
> +	if (desc_op =3D=3D UPIU_QUERY_OPCODE_AGGREGATED_READ)
> +		*desc_len =3D min_t(int, QUERY_AGGREGATED_MAX_SIZE, desc_size);
> +	else
> +		*desc_len =3D min_t(int, QUERY_DESC_MAX_SIZE, desc_size);
> =20
>  	return 0;
>  }

[Severity: High]
Is QUERY_AGGREGATED_MAX_SIZE allowing userspace to request a buffer that is
too large?

If userspace requests a 4096-byte desc_size (QUERY_AGGREGATED_MAX_SIZE), it
makes the subsequent response read up to 4096 bytes of payload data, which
may not fit into the dedicated devman response array once the 32-byte
UPIU header is included.

[ ... ]

> diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
> index 9f0fdd850e54e..c4d563420152d 100644
> --- a/include/ufs/ufshci.h
> +++ b/include/ufs/ufshci.h
> @@ -18,6 +18,8 @@ enum {
>  	TASK_REQ_UPIU_SIZE_DWORDS	=3D 8,
>  	TASK_RSP_UPIU_SIZE_DWORDS	=3D 8,
>  	ALIGNED_UPIU_SIZE		=3D 512,
> +	/* Larger response area, only for the devman UCD */
> +	ALIGNED_DEVMAN_RSP_SIZE		=3D 4096,
>  };
> =20
>  /* UFSHCI Registers */

[ ... ]

> @@ -501,6 +503,15 @@ struct utp_transfer_cmd_desc {
>  	u8 prd_table[];
>  };
> =20
> +/* Dedicated UCD for the devman/reserved slot */
> +struct utp_devman_cmd_desc {
> +	u8 command_upiu[ALIGNED_UPIU_SIZE];
> +	u8 response_upiu[ALIGNED_DEVMAN_RSP_SIZE];
> +	u8 prd_table[];
> +};
> +
> +static_assert(QUERY_AGGREGATED_MAX_SIZE <=3D ALIGNED_DEVMAN_RSP_SIZE);

[Severity: High]
Does ALIGNED_DEVMAN_RSP_SIZE need to be larger to safely accommodate the
UPIU header?

If the response data segment from the device is up to 4096 bytes
(QUERY_AGGREGATED_MAX_SIZE), and it follows the 32-byte header, the total
size needed here would be 4096 + 32 =3D 4128 bytes.

Since response_upiu is exactly 4096 bytes, wouldn't a maximum-sized aggrega=
ted
read overflow past the array and into the adjacent prd_table?

[ ... ]

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 79331c2bd38de..b30c314c75e6c 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c

[ ... ]

> @@ -7637,7 +7686,8 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_=
hba *hba,
> =20
>  	/* just copy the upiu response as it is */
>  	memcpy(rsp_upiu, lrbp->ucd_rsp_ptr, sizeof(*rsp_upiu));
> -	if (desc_buff && desc_op =3D=3D UPIU_QUERY_OPCODE_READ_DESC) {
> +	if (desc_buff && (desc_op =3D=3D UPIU_QUERY_OPCODE_READ_DESC ||
> +			  desc_op =3D=3D UPIU_QUERY_OPCODE_AGGREGATED_READ)) {
>  		u8 *descp =3D (u8 *)lrbp->ucd_rsp_ptr + sizeof(*rsp_upiu);
>  		u16 resp_len =3D be16_to_cpu(lrbp->ucd_rsp_ptr->header
>  					   .data_segment_length);

[Severity: High]
Can the subsequent memcpy read past the end of the response_upiu array?

If a userspace process issues a BSG query for AGGREGATED_READ and asks for
up to 4096 bytes, and the device returns a data_segment_length of 4096,
the descp pointer here is offset by sizeof(*rsp_upiu) (32 bytes).

The code shortly after this in ufshcd_issue_devman_upiu_cmd() does:

    if (*buff_len >=3D resp_len) {
        memcpy(desc_buff, descp, resp_len);
        ...

Calling memcpy(desc_buff, descp, 4096) will read 4096 bytes starting from
offset 32. Does this read past the end of the 4096-byte response_upiu array
and leak physical DMA addresses from the adjacent prd_table into the BSG
reply payload?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260722084819epcms=
2p49c27fce999e821385f7b5d7ea5a02868@epcms2p4?part=3D1
