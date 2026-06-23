Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9771338736C
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2026 02:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782183436; cv=none; b=Ea5IML4FnnDzxk1qUPbZ3VLzCsSJ9bPll/hQTiOZ/CeKwQMQJlDNHvazQyXWoTZ3VD+seOE09fQOHhiPZMe4YHeKO8shwraCAZh29lQGUt+mFCDswkZ53B7hxYMVHGPXA6X9RQ7NKQkBHBOyPOT/lnDf7i1/IdaU0ROTev8Mp/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782183436; c=relaxed/simple;
	bh=MWvnpP1WhUkMNl6bcIWgnnhyejDRXtu3rW2tX17nkQU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=KjN1kCBYFrbeopRrGBCXgPv2qcz0bj/MBYnfr+yijJ4JSrubuAl1N7UqAvkiF2qa4UwWjaQWKB7RH1tv7Mu2OYpzFY/DhSgoXtVuio6Kl/2ZABCOtUEaCRu9nEAkBXLGuGu3Q9/IX5Lh4nTvgqQBzDiuqh6coSuz49oUgOCe8pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UbB58Vwd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UbB58Vwd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 569241F000E9;
	Tue, 23 Jun 2026 02:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782183435;
	bh=9QVFbw0iJKBKzfDSNoV+fTRio0+WEZic6HZ/jVZnT80=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UbB58Vwd8i4getjVuctkED5Xq9v43iFS3sq7tU+tt0OQ0q1Wa8Ml8FQxlc62+fA9q
	 Nk+sI4zQjKUfy+Z0hP40tUAPJSJWHC4jVFhkXAkeRCCqQ9LtfNN/QT0+pzkcK9PMjH
	 jXWZb4LCyIrZSqnkb7m9G+oM5ApLwrSctcqvPiY+B+YDLYzepsbmXkJLHuaHHEUnFX
	 fsqk5L49E97omAJpy77ndzbv9ZXaQ1oUJ+qsNk1Fv+A0xQUqz3kigsF7KIS26itiqW
	 Q7HZ9Y5kkWrNxgir6As447Z9HE7VNdVyJn9YfbnyzMy0iAKD752gDtB6qVIWZOU7sj
	 zARfqeQyIpazg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 2/2] scsi: libsas: Add linkrate and sas_addr change
 detection in rediscover
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xingui Yang" <yangxingui@huawei.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260623024304.714582-3-yangxingui@huawei.com>
References: <20260623024304.714582-1-yangxingui@huawei.com>
 <20260623024304.714582-3-yangxingui@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 02:57:14 +0000
Message-Id: <20260623025715.569241F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Medium] `sas_dev_is_flutter()` improperly bypasses PHY discovery when `c=
hild_dev` is NULL, failing to update the libsas routing table and PHY state.

Pre-existing issues:
- [High] Attempting to prevent UAF by acquiring a reference via `kref_get(&=
child_dev->kref)` results in a TOCTOU race because `sas_find_dev_by_rphy()`=
 returns a raw pointer without holding a reference.
--

commit 4a9be29a10948d7f2b0efa1425b3ea27e6c08b1f
Author: Xingui Yang <yangxingui@huawei.com>

scsi: libsas: Add linkrate and sas_addr change detection in rediscover

This commit introduces sas_dev_is_flutter() and sas_rediscover_ex_phy()
to improve flutter and device replace detection during rediscovery.
It holds a kref on the child device during SMP discovery and uses async
discovery to avoid ordering issues.

> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas=
_expander.c
> index cb9d3b7482225..63d033e789855 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
[ ... ]
> @@ -1966,6 +1966,78 @@ static bool dev_type_flutter(enum sas_device_type =
new, enum sas_device_type old)
[ ... ]
> +static bool sas_dev_is_flutter(struct domain_device *dev, int phy_id,
> +			       u8 *sas_addr, enum sas_device_type type)
> +{
> +	struct expander_device *ex =3D &dev->ex_dev;
> +	struct ex_phy *phy =3D &ex->ex_phy[phy_id];
> +	struct domain_device *child_dev =3D NULL;
> +	char *action =3D "";
> +	int res;
> +
> +	if (SAS_ADDR(sas_addr) !=3D SAS_ADDR(phy->attached_sas_addr) ||
> +	    !dev_type_flutter(type, phy->attached_dev_type))
> +		return false;
> +
> +	child_dev =3D sas_ex_to_dev(dev, phy_id);
> +	if (!child_dev)
> +		goto out;

[Severity: Medium]
In the original code, sas_ex_phy_discover() was called unconditionally.
Will this new early return bypass the SMP request that updates the PHY state
(via sas_set_ex_phy()) when the child device is not instantiated or has been
removed?

> +
> +	kref_get(&child_dev->kref);

[Severity: High]
This is a pre-existing issue, but could attempting to prevent a use-after-f=
ree
by acquiring a reference here result in a time-of-check to time-of-use
(TOCTOU) race?

Looking at sas_find_dev_by_rphy() (called by sas_ex_to_dev()), it acquires
port->dev_list_lock, finds the device, and drops the lock before returning
the raw pointer:

drivers/scsi/libsas/sas_scsi_host.c:sas_find_dev_by_rphy() {
    ...
    found_dev =3D dev;
    spin_unlock(&port->dev_list_lock);
    goto found;
    ...
}

If a concurrent link-loss or device removal event runs, can it acquire the
lock, remove the device, and drop its last reference before we call
kref_get(&child_dev->kref) here, leading to a use-after-free?

> +	res =3D sas_ex_phy_discover(dev, phy_id);
> +	if (res)
> +		goto out_put;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623024304.7145=
82-1-yangxingui@huawei.com?part=3D2
