Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9114B448393;
	Thu, 27 Aug 2026 16:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787847532; cv=none; b=UcXHUCSxjtFRsdU2EZoYsQrW0j4K3XsC5INrzqctn+hMIpn3HGcJZdORQdgd8486E0/HwKh3iDFmHfZeQ3MwJDpIE+rwZxRL9LjTZsqr0eVI31I3wIKZqtLcVoipNgbvr6zfb8wzYcPniCS7apBt1yqFTB8DrvYndI90xGG6Nyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787847532; c=relaxed/simple;
	bh=87c11ldS0HqVl+PaZzbB5fh02V1b/d7q3Gd9io5Jgy8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=A26HKNwyZYBYVP+HOgd74pBMuhNVdnxH6V2IcJgg/Hwol11ZI+4SPCFyDcMLTjWSMUvwkiBUn0HSeXCvbAAJaS6Nhk/j8+5t+6zG14ATDc8LzXR5yK9bp7KMqe2jui6MtCF8MsD1F07HfV1oIddkd6WLlU5xjZpDLPqH1S898Gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gu7u4Dqk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gu7u4Dqk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D87801F000E9;
	Thu, 27 Aug 2026 16:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787847531;
	bh=xRDI+5oD/8/TgBl5cPM2VmNwJzTiQZ3MYmjGxwleGdU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Gu7u4DqkQGKijlrs7KW8YXjKKEL5m5eD39YlBPB3e4WwIGlXRDGR+ih+mpGyq/61j
	 b8qN5uCVdDmIZzBYF+skvxLyRW4rAAhfcfDiwdDXi9urFFYZW/oi9EL3aVTK1I7uXd
	 mI/fxuBPevKYbXcL9dsojkZO2ry1LwZVUwIIp69Y2a5JAUVJ+2Kc5bN8QBidL1OZcs
	 9aiSOy2YDvfuLNi9VEYw980zWEpcHizBSV4zOU36rPQXmYYcXsMt9ArQIX03EP31R5
	 ZcnPoCM3IRPqUQ14ujiS0WesXvozN0BrIurECD17HaMIPtp+B80Ercp9yjyyF/PgM4
	 Ueiz6/rHbN43g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 07/11] blk-crypto: move bio_crypt_dun_increment() to
 the public header
Reply-To: sashiko-reviews@lists.linux.dev
To: "Linlin Zhang" <linlin.zhang@oss.qualcomm.com>
Cc: devicetree@vger.kernel.org, linux-scsi@vger.kernel.org, conor+dt@kernel.org, robh@kernel.org
In-Reply-To: <20260827160806.1295313-8-linlin.zhang@oss.qualcomm.com>
References: <20260827160806.1295313-1-linlin.zhang@oss.qualcomm.com>
 <20260827160806.1295313-8-linlin.zhang@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 27 Aug 2026 16:18:50 +0000
Message-Id: <20260827161850.D87801F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Missing EXPORT_SYMBOL_GPL for bio_crypt_dun_increment causes module=
 build failures.
--

commit a07e0dacccb884a51c1f14000f1404eb1f5c2cf7
Author: linlzhan <linlin.zhang@oss.qualcomm.com>
blk-crypto: move bio_crypt_dun_increment() to the public header

This commit moves the declaration of bio_crypt_dun_increment() from the
internal block header to the public blk-crypto.h header. This allows drivers
managing inline-encrypted I/O directly to advance the data unit number.

> diff --git a/include/linux/blk-crypto.h b/include/linux/blk-crypto.h
> index 33ae52b77522b..c9f436b6b2ef4 100644
> --- a/include/linux/blk-crypto.h
> +++ b/include/linux/blk-crypto.h
> @@ -181,6 +181,9 @@ bool bio_crypt_dun_is_contiguous(const struct bio_cry=
pt_ctx *bc,
>  				 unsigned int bytes,
>  				 const u64 next_dun[BLK_CRYPTO_DUN_ARRAY_SIZE]);
> =20
> +void bio_crypt_dun_increment(u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE],
> +			     unsigned int inc);
> +

[Severity: Low]
Does the missing EXPORT_SYMBOL_GPL() for this function cause module build
failures?

Since this function is now exposed for external drivers to use, if a driver
using it is configured as a loadable module, it seems the kernel build will
fail at the modpost step with an undefined symbol error.

Should an EXPORT_SYMBOL_GPL(bio_crypt_dun_increment) be added alongside its
implementation in block/blk-crypto.c so that modules can successfully link
against it?

>  int blk_crypto_init_key(struct blk_crypto_key *blk_key,
>  			const u8 *key_bytes, size_t key_size,
>  			enum blk_crypto_key_type key_type,

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260827160806.1295=
313-1-linlin.zhang@oss.qualcomm.com?part=3D7
