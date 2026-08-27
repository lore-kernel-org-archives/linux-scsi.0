Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1073C47D933;
	Thu, 27 Aug 2026 16:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787847821; cv=none; b=t+5MyiWC6MNi4jx20VXsRj+9CmkTtw9DAj2UqHyl7GC1v3XOMgajQYZom2kGP/qGCrSZFDlZ55zWv6frlul54JeFoY35G/0iBfD36H7l8o+3uSekypWjartcl9YF+kcbUu7BZ1I9blprkWm1VxVXDU+NljJvQ0qbDz76wIGJUKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787847821; c=relaxed/simple;
	bh=bBim+wGR9QnFRs+7oS5n8nAYYOm0NZC6Nw8f2R3bbpY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=RclZL3cHhHVyd5mJHeGVsZZ2O0U7GjxKTCP+oULX9reFuqxsftFh80+iINI1BgfnSa5/8SfsQJOq/kuozx/KjwM7AWQvMGLLVLugRRyccxgAdepv7vfGXHWQeHSilLN3Y9hGAjGNJ0tV2pnoZnrcmMJRbFBUGO46Os3WW/KTyzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aP/nwW5A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aP/nwW5A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA8101F000E9;
	Thu, 27 Aug 2026 16:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787847820;
	bh=NiE0DU2hO0d9CosO3gd+PFxcxdHd/yHWJkZiV5RxOKE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aP/nwW5A2AzqmCnIxoZbZitHw+mVYBR0mVm6VFpSG6xO55wyURcB9LGlsvnmtB60J
	 QcqEDCVzSzEfwjhvEBTSaInMvMQHL49utdnuMxNnPUhStEwcbkClfyubeNyfUL0cAl
	 Smv/Bvw1fsbh/LZlYeZj0sGHceyoPknnQZlS3dKcy/ua2lLMpYJqkW6JPaQ3aiyWpx
	 l+lHM/TQ68g11DzqFVBY9gr2ijALhDRWCpMYBaLIM115DYT8Q7N1UWl9AIsFYAqnaJ
	 dtza1MOOsF+b6SHVPWyFOYuDCHz4f4EFrrkJb+Gqh6rZX+2foXT8+eWc1c3RPl7SYD
	 7YV4mQ7Ih3ozA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 10/11] blk-crypto: add slot_offset to
 blk_crypto_profile
Reply-To: sashiko-reviews@lists.linux.dev
To: "Linlin Zhang" <linlin.zhang@oss.qualcomm.com>
Cc: conor+dt@kernel.org, robh@kernel.org, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org
In-Reply-To: <20260827160806.1295313-11-linlin.zhang@oss.qualcomm.com>
References: <20260827160806.1295313-1-linlin.zhang@oss.qualcomm.com>
 <20260827160806.1295313-11-linlin.zhang@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 27 Aug 2026 16:23:39 +0000
Message-Id: <20260827162339.BA8101F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] Loops iterating over keyslots in block and driver crypto initi=
alization and reprogramming paths pass logical indices instead of physical =
indices to keyslot_program/keyslot_evict, failing to account for the new sl=
ot_offset.
--

commit 2859a14efba8a99150c0d93c45a6b7ad003d0250
Author: linlzhan <linlin.zhang@oss.qualcomm.com>

blk-crypto: add slot_offset to blk_crypto_profile
   =20
On platforms where ICE keyslots are partitioned across the host and
guest VMs, the host's physical keyslot range does not necessarily start
at slot 0.  blk_crypto_keyslot_index() currently returns a 0-based
array index, which is wrong for such configurations =E2=80=94 hardware
programming requires the physical slot number, not the array position.

Add an unsigned int slot_offset field to struct blk_crypto_profile.
It defaults to zero (no change for existing drivers) and is set by
storage drivers that share ICE hardware across guests.

Update blk_crypto_keyslot_index() to add slot_offset to the array
index so that callers always receive the correct physical ICE keyslot
number to program into hardware.

> diff --git a/block/blk-crypto-profile.c b/block/blk-crypto-profile.c
> index 53126c091b0be..64202d64a0182 100644
> --- a/block/blk-crypto-profile.c
> +++ b/block/blk-crypto-profile.c
> @@ -218,14 +218,15 @@ blk_crypto_find_and_grab_keyslot(struct blk_crypto_=
profile *profile,
>  }
> =20
>  /**
> - * blk_crypto_keyslot_index() - Get the index of a keyslot
> + * blk_crypto_keyslot_index() - Get the physical index of a keyslot
>   * @slot: a keyslot that blk_crypto_get_keyslot() returned
>   *
> - * Return: the 0-based index of the keyslot within the device's keyslots.
> + * Return: the physical ICE keyslot index, i.e. the 0-based position of =
@slot
> + * within the profile's keyslot array plus @slot->profile->slot_offset.
>   */
>  unsigned int blk_crypto_keyslot_index(struct blk_crypto_keyslot *slot)
>  {
> -	return slot - slot->profile->slots;
> +	return (slot - slot->profile->slots) + slot->profile->slot_offset;
>  }
>  EXPORT_SYMBOL_GPL(blk_crypto_keyslot_index);
> =20

[ ... ]

> diff --git a/include/linux/blk-crypto-profile.h b/include/linux/blk-crypt=
o-profile.h
> index 4f39e9cd75766..a9bdc05abfa3c 100644
> --- a/include/linux/blk-crypto-profile.h
> +++ b/include/linux/blk-crypto-profile.h
> @@ -162,6 +162,15 @@ struct blk_crypto_profile {
>  	 */
>  	struct device *dev;
> =20
> +	/**
> +	 * @slot_offset: offset added to the slot array index to obtain the
> +	 * physical ICE keyslot number.  Zero in the common case.  Set to a
> +	 * non-zero value by storage drivers that share ICE hardware across
> +	 * multiple guests, where the host's keyslots do not start at physical
> +	 * slot 0.
> +	 */
> +	unsigned int slot_offset;
> +

[Severity: Critical]
Does this new slot_offset need to be applied in loops that manually iterate
over keyslots?

For example, in block/blk-crypto-profile.c:blk_crypto_reprogram_all_keys(),
the logical loop counter slot is passed directly to keyslot_program():

	for (slot =3D 0; slot < profile->num_slots; slot++) {
		...
		err =3D profile->ll_ops.keyslot_program(profile, key, slot);
		...
	}

Since this bypasses the new slot_offset, will it program keys into physical
slots starting at 0 during device resume, corrupting foreign keyslots belon=
ging
to the host or other VMs?

Similarly, in drivers/ufs/core/ufshcd-crypto.c:ufshcd_init_crypto():

	for (slot =3D 0; slot < hba->crypto_profile.num_slots; slot++)
		hba->crypto_profile.ll_ops.keyslot_evict(&hba->crypto_profile,
							 NULL, slot);

And in drivers/mmc/host/cqhci-crypto.c:cqhci_crypto_init():

	for (slot =3D 0; slot < profile->num_slots; slot++)
		profile->ll_ops.keyslot_evict(profile, NULL, slot);

Do these initialization paths also incorrectly evict physical keyslots star=
ting
at 0 because they ignore slot_offset, destroying host/guest ICE keyslots?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260827160806.1295=
313-1-linlin.zhang@oss.qualcomm.com?part=3D10
