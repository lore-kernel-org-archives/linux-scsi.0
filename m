Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3540436A004;
	Thu, 27 Aug 2026 16:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787847619; cv=none; b=VOKFQ2J1JhgCMXCZJHd6+r0JyFqI8/u18bwQPwAYzJ3fEbzPDMn6m4ipIAvbsoJcCkALR4AufV10TNUFN5d7hdGYNC/HlPwJFbl9yoLCS9F6RFWCthc4s+zXNZGQYlErXnbDvH/yGqdCYyg5pepcbcUUk/20Bo+tbdFYvOgOLMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787847619; c=relaxed/simple;
	bh=RjozzEK/mBaJ4pou6nS2k9gczW+DO+Fp2Z8m6+D6yp8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Rxl+X5dOesr2d3uYkKx28s+10fE//wLGOz+j8BvHXBSmFqAQxXSThuYTjjQcCFUmDgYACQ5G3/B2YPz5xIV9/LTAjqGx2AOr/nt5fV0NffLFSZcGRkqrZRpPw2N9cqob0Vwi+7uT00/J6m1kDggIAZuw06mSFZoMgmBQxQr6WVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L3H0MHxy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L3H0MHxy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CB7D1F00A3A;
	Thu, 27 Aug 2026 16:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787847617;
	bh=/ksg0JVedViNQKvOlYwvHgVgfdBPvf/W8cYrBdgEsvw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=L3H0MHxyVxvFV/qYF2V5j7MZpTs0WLY7AnKl6w+dvka0sBFtaprBfUXR9PWGre4FZ
	 QruvHFOGPO9po9cj7weRWJu9jhfG+1RxTRGNYtElVbEfPTdUAhLo7v2mpfU9HIaHRE
	 aAtdtMbRCX8npkMws6Vx5OLSP/r+Nqgo89nrq+AbQhXsNF3kbX74/LktairrqRe1DH
	 V7sfoANQmWcpKdNogZlgW3t3BRCskb9UAzNhLc8IunWGnZ0gAVQbZDAPHuI+eKlN6D
	 bNCJl+RTsHu4urfRFrqsat7w6LDbgrEi80lgXQkHboihwRejB/fjULTMo3ySvuo0MM
	 UBcr9GdDbkktQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 06/11] scsi: ufs: core: add slot path to
 ufshcd_prepare_lrbp_crypto
Reply-To: sashiko-reviews@lists.linux.dev
To: "Linlin Zhang" <linlin.zhang@oss.qualcomm.com>
Cc: linux-scsi@vger.kernel.org, conor+dt@kernel.org, devicetree@vger.kernel.org, robh@kernel.org
In-Reply-To: <20260827160806.1295313-7-linlin.zhang@oss.qualcomm.com>
References: <20260827160806.1295313-1-linlin.zhang@oss.qualcomm.com>
 <20260827160806.1295313-7-linlin.zhang@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 27 Aug 2026 16:20:17 +0000
Message-Id: <20260827162017.6CB7D1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Malformed crypto contexts with `data_unit_size_bits =3D=3D 0` sile=
ntly bypass encryption instead of failing the request.
--

commit 406714defb60086f0a0900753b849815524e2e23
Author: linlzhan <linlin.zhang@oss.qualcomm.com>

scsi: ufs: core: add slot path to ufshcd_prepare_lrbp_crypto

This commit extends ufshcd_prepare_lrbp_crypto() to support bios that carry=
 a
pre-programmed physical ICE keyslot index in crypt_ctx->bc_slot instead of
a blk_crypto_key pointer. It adds a check for bc_slot.data_unit_size_bits to
determine if the slot path should be used.

> diff --git a/drivers/ufs/core/ufshcd-crypto.h b/drivers/ufs/core/ufshcd-c=
rypto.h
> index 8f66db94e179a..2fc5601c0f769 100644
> --- a/drivers/ufs/core/ufshcd-crypto.h
> +++ b/drivers/ufs/core/ufshcd-crypto.h
> @@ -15,13 +15,21 @@
>  static inline void ufshcd_prepare_lrbp_crypto(struct request *rq,
>  					      struct ufshcd_lrb *lrbp)
>  {
> -	if (!rq || !rq->crypt_keyslot) {
> +	if (!rq) {
>  		lrbp->crypto_key_slot =3D -1;
>  		return;
>  	}
> =20
> -	lrbp->crypto_key_slot =3D blk_crypto_keyslot_index(rq->crypt_keyslot);
> -	lrbp->data_unit_num =3D rq->crypt_ctx->bc_dun[0];
> +	if (rq->crypt_keyslot) {
> +		lrbp->crypto_key_slot =3D blk_crypto_keyslot_index(rq->crypt_keyslot);
> +		lrbp->data_unit_num =3D rq->crypt_ctx->bc_dun[0];
> +	} else if (rq->crypt_ctx && rq->crypt_ctx->bc_slot.data_unit_size_bits)=
 {
> +		lrbp->crypto_key_slot =3D rq->crypt_ctx->bc_slot.phy_slot;
> +		lrbp->data_unit_num =3D rq->crypt_ctx->bc_dun[0];
> +	} else {
> +		lrbp->crypto_key_slot =3D -1;
> +	}
> +
>  }

[Severity: High]
Does this code silently bypass encryption if a malformed request is submitt=
ed?

If an IO request is submitted with a crypto context (rq->crypt_ctx !=3D NUL=
L) but
has data_unit_size_bits =3D=3D 0, this logic falls through to the final els=
e block
and sets crypto_key_slot to -1.

Since the block layer explicitly skips validation (bio_crypt_check_alignmen=
t())
for slot-based bios, could an untrusted guest VM submitting a virtio-blk
request with data_unit_size_bits =3D=3D 0 cause an explicitly encrypted IO =
to be
written to the physical storage device as plaintext?

Should this path fail the request rather than falling open to plaintext,
perhaps by surfacing an error up to the caller so it can be failed with
BLK_STS_IOERR?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260827160806.1295=
313-1-linlin.zhang@oss.qualcomm.com?part=3D6
