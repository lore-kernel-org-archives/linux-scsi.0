Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDBD9533D6;
	Thu, 27 Aug 2026 16:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787847975; cv=none; b=kh1u9FQI4upvc49+sB+M/4ipHeGbMnqDp/kSNji3/nYntZZbJAOZZe//HVau0ZVCa2pAVH5W42C2dlXHYQOloeYaah0sJ2Kxc8Q4++revHFcdXIExdyBpiB2DiIEg8bDu5pllR8coqbpGsav0Uwbh3K1QBgrFrI30/waycky6lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787847975; c=relaxed/simple;
	bh=y4z7pXi/f2h2F8t/MJBJCbm46bLQ3AV2E4cYkrYvHHM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=OIuX51vCepqZL9szOwA7zZHncwbdzLSkZd+LpjDD/xzHyZSBEH4WZHiZNNzk2B7lvLHjYSP2HrKD0g7m0DIJyTiq2poS6P77V7BEfFlZX4GHCLEEY+riCJpkzVXugUFV/Yzi3UGc2dSciwtQ4lvUVbE2il+n4VILcuselJpleC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jMMbF7v3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jMMbF7v3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1BE11F000E9;
	Thu, 27 Aug 2026 16:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787847973;
	bh=hdMbmkCE7pXCHP34n0Fylp281GvvUrhcb+Z6S6RMcZI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jMMbF7v3zPviEGfDXyiFAn71+c+07DcqmRCR5gg0JxMb/8iOYFle0r7Chk9aXudiG
	 Ud2C4WpBCK5Pie/or6PVxwqf281puZWX1xtqAt5OhsZ46Xc3ctJDWRKmBZNMxFncaE
	 aNeczObArpHqpsoE6xBSk9b6MOrEGISPoiqLXYcrpNfXQkQvyk485XuCmXiOz7ICfT
	 njbMH1bGbV9fC5PoJPkFt3xIIPakJzegrN7RrZWdzW4nMKpCkQxlbed7MvNi+4mMCg
	 5g4GZW12ToSnIScoRQ3h/VAKL5nH71SutdiePKipe+TgCsD0qCSMsCHAvQNGXf3UkM
	 kQRltgP/BALBg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 11/11] scsi: ufs: ufs-qcom: support ICE keyslot
 partitioning for guest VMs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Linlin Zhang" <linlin.zhang@oss.qualcomm.com>
Cc: devicetree@vger.kernel.org, linux-scsi@vger.kernel.org, robh@kernel.org, conor+dt@kernel.org
In-Reply-To: <20260827160806.1295313-12-linlin.zhang@oss.qualcomm.com>
References: <20260827160806.1295313-1-linlin.zhang@oss.qualcomm.com>
 <20260827160806.1295313-12-linlin.zhang@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 27 Aug 2026 16:26:12 +0000
Message-Id: <20260827162612.F1BE11F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] Integer overflow in ICE keyslot boundary checks allows out-of-boun=
ds hardware register access.
- [High] Missing overlap validation for keyslot partitions causes silent da=
ta corruption across VMs.
- [High] Inability to distinguish between a missing DT node and a 0-slot ho=
st reservation overrides explicit 0-slot allocations, breaking VM partition=
ing.
--

commit f3bdc5333b93892b7c3cc455d6a3fd8e3b213cb4
Author: linlzhan <linlin.zhang@oss.qualcomm.com>

scsi: ufs: ufs-qcom: support ICE keyslot partitioning for guest VMs

This commit adds support for partitioning ICE hardware keyslots so that the
host and guest VMs can operate within their own physical slot ranges. It
introduces a new function to parse the keyslot map from the device tree and
initializes the crypto profile with the host's specific slot count.

> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 62396212a0a73..0611ab50f4cc9 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
[ ... ]
> +static int ufs_qcom_ice_parse_slot_table(struct device *dev,
> +					 unsigned int hw_max_slots,
> +					 unsigned int *num_slots,
> +					 unsigned int *slot_offset)
> +{
> +	struct device_node *slots_np, *child;
> +	unsigned int total_slots =3D 0;
> +	bool first =3D true;
> +	int ret =3D 0;
> +
> +	*num_slots   =3D 0;
> +	*slot_offset =3D 0;
> +
> +	slots_np =3D of_parse_phandle(dev->of_node, "qcom,ice-keyslot-map", 0);
> +	if (!slots_np)
> +		return 0;
> +
> +	for_each_child_of_node(slots_np, child) {
> +		u32 off, max;
> +
> +		if (of_property_read_u32(child, "qcom,ice-slot-offset", &off) ||
> +		    of_property_read_u32(child, "qcom,max-ice-slots", &max))
> +			continue;
> +
> +		if (off + max > hw_max_slots) {

[Severity: High]
If a malformed device tree provides excessively large values for
qcom,ice-slot-offset and qcom,max-ice-slots, can off + max wrap around
the 32-bit limit? This could defeat the bounds check and potentially
allow out-of-bounds hardware register accesses.

> +			dev_err(dev,
> +				"ice-keyslot-map: slots [%u..%u) exceed hw max %u\n",
> +				off, off + max, hw_max_slots);
> +			of_node_put(child);
> +			ret =3D -EINVAL;
> +			break;
> +		}
> +
> +		if (first) {
> +			*num_slots   =3D max;
> +			*slot_offset =3D off;
> +			first =3D false;
> +		}
> +		total_slots +=3D max;

[Severity: High]
Can total_slots overflow a 32-bit integer when adding max? This could
defeat the subsequent check that ensures the total allocated slots do not
exceed the hardware maximum.

[Severity: High]
Does this logic only sum the capacities and miss bounds collision detection
between different VM partition ranges?

If the explicit slot intervals overlap in the device tree configuration,
could the host and guests silently overwrite each other's keys because the
total sum still fits within the hardware maximum?

> +	}
> +
> +	of_node_put(slots_np);
[ ... ]
> @@ -192,7 +262,23 @@ static int ufs_qcom_ice_init(struct ufs_qcom_host *h=
ost)
[ ... ]
> +	/*
> +	 * Parse the qcom,ice-keyslot-map DT node: validate all entries against
> +	 * the hardware slot count and read the host's own reservation.  If no
> +	 * partitioning is configured (num_slots =3D=3D 0), the profile manages=
 the
> +	 * full hardware slot range.
> +	 */
> +	err =3D ufs_qcom_ice_parse_slot_table(dev, hw_max_slots,
> +					    &num_slots, &slot_offset);
> +	if (err) {
> +		dev_err(dev, "failed to parse ICE slot table: %d\n", err);
> +		return err;
> +	}
> +
> +	err =3D devm_blk_crypto_profile_init(dev, profile,
> +					   num_slots ? num_slots : hw_max_slots);

[Severity: High]
Since ufs_qcom_ice_parse_slot_table() initializes num_slots to 0 and returns
0 when the device tree node is absent, is it possible to distinguish between
a missing node and a valid 0-slot host allocation?

If a device tree explicitly allocates 0 slots to the host to dedicate all
physical keyslots to VMs, does this ternary operation conflate the valid
empty partition with a missing configuration and forcefully assign all
hardware slots to the host's crypto profile?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260827160806.1295=
313-1-linlin.zhang@oss.qualcomm.com?part=3D11
