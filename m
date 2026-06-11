Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3BF3537CD
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 23:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781220831; cv=none; b=EuRGNMsnsnpIGxg1qbNZIRCYV39SG+Krlz19CVNkz8/ZdCgrfTgc6ILltKzwjWK/pbJKJ5myHqTtF8LT0iXMSJHkKq2ZyWfM34xX/1agXYsDEE5XSRTku22SbOZLDXggK9wkWTInqE3L5deDvv3AZ6Q4Wby2zD9nNU454OiSneI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781220831; c=relaxed/simple;
	bh=TaZkHCtZC6QmZKhT+8voq1A9A2oAInE76juY7cwFrcM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bpI3uJpBkTE2nvXbIqyRVX6cjwXlLOlDZ+oO45V1u6p3uECNi8Yz5/0CTUZD+u5w1Le3bWfVBvlIcOuLA2iGRrDSTDhjvlkqPnPHcAkcwYwAvFrhQL1PG9GmfB0sgecuYtpIFqB9szGAS+tKKDLV3wewj+LXnGGzpbs0VV+jxt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=buzdj5Wa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="buzdj5Wa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199321F000E9;
	Thu, 11 Jun 2026 23:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781220830;
	bh=OX5kqvU20z8rISRHD7LEVA+MoBlYbLNTrKbcQAtLsyY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=buzdj5WahXRKfovccRVYnaFrM8+K5TGd75TQYnT8N9wt809idmgid362eUFwYa+jL
	 WLmJcWGTNu3mLOE3gL9nqhJFV6Zwcs4Z/TAdOycXxcDZn7jNoUq+nE5hduzRDKl8RK
	 7XREkMcnimHm8PiWOMfPp/JXz5Tdvg/l3a2SzQTjHCEglGOJ1cWBC8HJjFjbFeG3fa
	 DhhFPT1ppEiaIdIFWOWFiOmYslRnCrQoXBs89A0CYDmP/Lp1Jac2pqWpJdAn3aFB04
	 wMCoVaIyaIBCVQxOq6zD0hFbdt0b/Ou0gU6Ylf3ozn9di9SkCB6inGcKLEK0M9yKJE
	 6aXdfHAGtyEnA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/3] ufs: core: Remove max_num_rtt field from
 ufs_hba_variant_ops
Reply-To: sashiko-reviews@lists.linux.dev
To: ed.tsai@mediatek.com
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260611232632.2324422-4-ed.tsai@mediatek.com>
References: <20260611232632.2324422-4-ed.tsai@mediatek.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 11 Jun 2026 23:33:49 +0000
Message-Id: <20260611233350.199321F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The commit message claims to remove the `max_num_rtt` field from=
 `struct ufs_hba_variant_ops`, but the patch only removes its kerneldoc com=
ment, leaving the actual struct member behind as dead code.
--

commit 173e8bce82316be80209775ea63a6bbd458a4aa9
Author: Ed Tsai <ed.tsai@mediatek.com>

ufs: core: Remove max_num_rtt field from ufs_hba_variant_ops

This commit aims to remove the max_num_rtt field from the
ufs_hba_variant_ops structure. It removes its usage from ufshcd_set_rtt()
and replaces it with hba->nortt.

> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> index 8e24c4b8e9634..6a176ff05bfbc 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -372,7 +372,6 @@ struct ufshcd_tx_eq_params {
>  /**
>   * struct ufs_hba_variant_ops - variant specific callbacks
>   * @name: variant name
> - * @max_num_rtt: maximum RTT supported by the host
>   * @init: called when the driver is initialized
>   * @exit: called to cleanup everything done in init
>   * @set_dma_mask: For setting another DMA mask than indicated by the 64AS

[Severity: Medium]
The commit message states the max_num_rtt field is removed from
ufs_hba_variant_ops, but this hunk only removes its kerneldoc comment.

Did this miss removing the actual max_num_rtt field further down in
include/ufs/ufshcd.h inside struct ufs_hba_variant_ops?

    const char *name;
    int    max_num_rtt;
    int    (*init)(struct ufs_hba *);

Leaving the field behind as dead code without a kerneldoc comment might
trigger a kerneldoc warning.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260611232632.2324=
422-1-ed.tsai@mediatek.com?part=3D3
