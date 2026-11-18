Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794997275;
	b=c+o6tN2bP45I0HGHXFHFA/ytuCS8Qr2yV38PuYrj9yiG9/cyoQ5ANcsvqVc0D3pKOzCx
	 QOv8YRqRi9zwn+bGlZVrLQbUnpteIm3i5Jz2j3iqGY8mrVhVQpTu4Q8wW3KXuaUGeaQVN
	 mWeTYKcZSUitq7UKicm31yIK9yHqSVWETmljFYfsg/nRkCEW3mzkh/8CPLTeQoBkpwBbJ
	 oC9An+x8X+ooPBo1eLQS81KdXovXKq2EWrFm/JW0TGIVQrppjcVdyqHnKNEsix8XiYIYT
	 NuAoJVv95q3YIc6+XcxAuYWxAFI6gkbZxTsahlSgIkNYU4cmYRhrfd/zGS381yiG8Bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794997275;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=E2yq1TgRqocusz3bycICyr9GvmLdWKiYvRafhlH9GWU=;
	b=dyy/pLhfwjyeWQhgfvOOV6SJA4O2E6xu8GRHkFZWtB3CUQ00+vCNrMSukF8lUxl9UsYa
	 YvkA6FF4+zz23oiSe6umP5mCgXKhgRAKE59HOk60SbQjFqlRY2pnmXoDrBVc9FzYeZTRA
	 y0zTGV2/2RSPasbXY8HPsrzFHNTEDUkcIpexaoHlqQZt8jpYdDl+p7a4UAzZdArRvvOpw
	 25gJmqcuxm+VgJDrLOpSOWitZQrqlDxwO3MPzFG6krbQ8nIuDq8u52wdgsQzyT96XVTUY
	 /+J6j+EHr4RHSpMBwWwGFPu5t7YVIA9rNReVWKhVDvf13f78QOmQClpp35yVC3Iwz5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Pgp62wQP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999D6606A31C
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Pgp62wQP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 327C81F000C5;
	Wed, 18 Nov 2026 10:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794997275;
	bh=E2yq1TgRqocusz3bycICyr9GvmLdWKiYvRafhlH9GWU=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=Pgp62wQPfUTz4CvRQNG4g88ymQW74OgeTzaaqlxTwCPHfVhIBqQGOQOhlgNVimQpa
	 fRv9vlSEdbH0JKpDGXTaHN8hq/YW1+xMi8YkDvfYVNKxtJ77t4vKSroC9PrA+VreD/
	 BmfIjI72i+MnZDGrZ7JNllSKo4gRIy+MihxREyvLNOfmjuX7/fWxPcq9ZJb4sPfy7Y
	 Prm4AJG/ooJUlxeX6I4a83O9RWvPd3zkeIc38R9OloTuX57xpouZk3dazLz5FCtPot
	 Gop40Ept0TxU2fE4AoibPWaPDl8PLH3kJ1ibTMFtz/cmrlYqAXeDm7DObrPbv4qsha
	 aTk4pLCjWgNyQ==
Message-ID: <sashiko-outbox-220680@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 14/37] scsi: mpt3sas: Fix buffer overflow in
 _scsih_scsi_ioc_info
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shivasharan S" <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
In-Reply-To: <1794995806-5835-15-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1794995806-5835-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1794995806-5835-15-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 10:21:14 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] scsi: mpt3sas: missing Fixes trailer for _scsih_scsi_ioc_info()
  fix
--

commit fa67a5252633dddcb65a2dd6aaf05d7ae84cb968
Author: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

> scsi: mpt3sas: Fix buffer overflow in _scsih_scsi_ioc_info
>
> Build the SCSIState description string with a bounds-checked
> snprintf() instead of a chain of unbounded strcat()s.
>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>

[Severity: Low]
Both the 64-byte MPT_STRING_LENGTH definition and the unbounded strcat()
chain in _scsih_scsi_ioc_info() were introduced when the driver was added.
Should this include:

  Fixes: f92363d12359 ("[SCSI] mpt3sas: add new driver supporting 12GB SAS")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1794995806-5835-1-g=
it-send-email-shivasharan.srikanteshwara@broadcom.com?part=3D14
