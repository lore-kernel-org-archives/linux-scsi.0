Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B915A36B928
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 03:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784863676; cv=none; b=fTS6Kkj4+u3onoLVSIhftFrK8kDwxFeSW91KBc/i3mN9aQdi+/3eWB3b1ViHsVhVAEyaZ9glpL5I0odJq/1WJVT0kCtQKz+olgr3bQxSLUU5ETvEtEME8NkDy9e+8wyaiVqVlitnuO00uj3N7a5VGRnAbefege9UNPuhCg4bu7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784863676; c=relaxed/simple;
	bh=+3lD4dRF+kNiPjbC4VEpjrL4yY/9RLiRM+M+OaAT0Hg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=AOfmmI+L8nkuv2zdXIK0fbWwBHAcmSm1Jf3yrrTNVFA/8yv+0hpZbpp9gUodoVUKTK4uW9gLCFMxsmktruzDUlG3Gi3CiXa3RMt9JSZBGol0MgQczEfoY1pViv9nQA66iR521YaQ728aCTv2WKF62KCT+1E3X65zOdCKdAL3EYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lBVYbhXG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lBVYbhXG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D281F000E9;
	Fri, 24 Jul 2026 03:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784863675;
	bh=Vk7e7pMzKEaTMP8+hNxEPWbLPfpC3AxZXnJwTogOsPs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lBVYbhXGRAsL4KgTjtgrAYnCOZAt4AHOjHGdvfUbhsYCOyVKtCU5ZjMdUIpvZS+YN
	 Iebo508JvQkwKwCGI2kdAbk6B0swmnuHEqB0BY/rVr5eVXYvCEL5VqdUthkcjyfMAB
	 gJygKMw5AtjnjCRI9HpcCDp8nKHs38p6PV60fdjMG1CxSuvDkU0XAUr4ZLwT0EuxXW
	 M4Ewnid4z8JA6iuR1MBaWbEB1VJ/cv0rIJQtIRmVK2tTAR610fHvrqssyYZhHFu7WH
	 sb37DmuQn6u0PfqHCmTz7IOvlYMeyz63RxtNMKFS/YTfIMsliYZWtM2Xdj7gnNbw4g
	 Q7RA4VXSndN5Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/2] scsi: ufs: Add support for the aggregated read
 query opcode
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hyeoncheol Jeong" <hyenc.jeong@samsung.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260724031215epcms2p4d3f734cacf21104ef1396e893edd141d@epcms2p4>
References: <20260724030812epcms2p4eb2c77cb4dcd5fd51ca9c3eaa5ea4bfa@epcms2p4>
 <CGME20260724030812epcms2p4eb2c77cb4dcd5fd51ca9c3eaa5ea4bfa@epcms2p4>
 <20260724031215epcms2p4d3f734cacf21104ef1396e893edd141d@epcms2p4>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 03:27:54 +0000
Message-Id: <20260724032754.E5D281F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The patch introduces a dedicated DMA allocation for the device man=
agement command descriptor (`devman_ucd_base_addr`) and restricts its Physi=
cal Region Descriptor Table (PRDT) size to only 2 entries (`UFSHCD_DEVMAN_S=
G_ENTRIES`). However, Advanced RPMB requests originating from userspace via=
 the block layer's BSG interface are mapped into scatter-gather lists witho=
ut enforcing this 2-entry limit. Because userspace can submit highly fragme=
nted I/O vectors (or even a contiguous 4KB buffer that spans across three m=
emory pages), the block layer can generate an `sg_cnt` greater than 2. The =
driver blindly passes this `sg_cnt` to `ufshcd_sgl_to_prdt()`, which iterat=
es over the scatterlist and writes beyond the bounds of the 2-entry `prd_ta=
ble`. This results in a silent out-of-bounds write that corrupts adjacent D=
MA-coherent memory.
--

--- Patch [2]: [PATCH v3 2/2] scsi: ufs: Add support for the aggregated rea=
d query opcode ---
commit e3d69e949ea76c3908ee9edb0203a7ddef6ca03f
Author: Hyeoncheol Jeong <hyenc.jeong@samsung.com>

scsi: ufs: Add support for the aggregated read query opcode

UFS 5.0 / JEDEC 220H introduces the AGGREGATED READ query opcode (0x9),
which retrieves an aggregated data packet in a single query request. This
patch adds a dedicated utp_devman_cmd_desc with a 4 KiB response area,
allocated once for the reserved (device management) tag that aggregated
read uses.

> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> index 1c732601afcea..d59e701851683 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h

[ ... ]

> @@ -1359,6 +1367,18 @@ static inline size_t ufshcd_get_ucd_size(const str=
uct ufs_hba *hba)
>  	return sizeof(struct utp_transfer_cmd_desc) + SG_ALL * ufshcd_sg_entry_=
size(hba);
>  }
> =20
> +/*
> + * Two entries should be enough for the largest devman PRDT transfer (4 =
KiB),
> + * like advanced RPMB.
> + */
> +#define UFSHCD_DEVMAN_SG_ENTRIES	2
> +
> +static inline size_t ufshcd_get_devman_ucd_size(const struct ufs_hba *hb=
a)
> +{
> +	return sizeof(struct utp_devman_cmd_desc) +
> +		UFSHCD_DEVMAN_SG_ENTRIES * ufshcd_sg_entry_size(hba);
> +}

[Severity: High]
Does this 2-entry limit expose us to an out-of-bounds write when handling
Advanced RPMB BSG requests?

Advanced RPMB requests coming from userspace (via the BSG interface) can
supply highly fragmented scatter-gather lists. For example, a contiguous 4KB
user buffer could cross page boundaries and span 3 memory pages, producing =
an
sg_cnt greater than 2.

When ufs_bsg_request() dispatches to ufshcd_advanced_rpmb_req_handler(),
the unvalidated sg_cnt is passed directly to ufshcd_sgl_to_prdt():

ufshcd_advanced_rpmb_req_handler() {
        ...
        if (dir !=3D DMA_NONE && sg_list)
                ufshcd_sgl_to_prdt(hba, lrbp, sg_cnt, sg_list);
        ...
}

ufshcd_sgl_to_prdt() will then iterate over the scatterlist up to sg_cnt:

ufshcd_sgl_to_prdt() {
        ...
        for_each_sg(sg, sg, sg_segments, i) {
                prd_table[i].addr =3D cpu_to_le64(sg_dma_address(sg));
                prd_table[i].size =3D cpu_to_le32(sg_dma_len(sg) - 1);
                ...
}

Could this write past the end of the newly introduced 2-entry prd_table arr=
ay
and corrupt adjacent DMA-coherent memory if a privileged user submits a
request with sg_cnt greater than 2?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724030812epcms=
2p4eb2c77cb4dcd5fd51ca9c3eaa5ea4bfa@epcms2p4?part=3D2
