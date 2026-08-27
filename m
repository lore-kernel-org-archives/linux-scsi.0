Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB6A1DF75B;
	Thu, 27 Aug 2026 16:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787847440; cv=none; b=WQILYMOftLiFVwowZKuWmAm8Qz38p6XqbkhmJDFPyXnfzZFFJzmma9+o5dXlEKKugwJWNTb1XifW8RVFsT8pQxE12jcD9BGCeZzxEP2KoxS3kjnbLuyiSz19j9iIkf4b7dOqTfdSjBY0dqiXdQ8p3SQAx3L7H8tDXRkrobezJqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787847440; c=relaxed/simple;
	bh=mPg5E9Wz/J+StTcFJqMKfVMjy12NM1cDpld4cb+oOTU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kC8gXAxQO9yFmv7Juv5vFYgAqBzwuqT5plUlBTkebSAa4gCSSD9sjOylFFXGc2RZmHi1qLkgogT/WMWJIa52GXCPjasoP2hSBOjMtm/bCCIV9Sq63QE7zlieJS+Hz6aTp4u0EqZPrNw2ecSPd5OunVuBV/1SsfaYrFVwMJ2Dbdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BdcrLK9I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BdcrLK9I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 164651F000E9;
	Thu, 27 Aug 2026 16:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787847439;
	bh=duiwqtSRB3f5GFN2HS6DF3PWBNj5zFUyJ9Qt6hqEzgc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BdcrLK9IBrVbYr9GrNHKjkUt0KHlOqgJaIO6w6fwjHa35d8iNXv2p6UYZ1qsglEnL
	 CgBtUu/ehxnYbTEl9ZASBtyF1cadVTxSTze/CdfRK7KLqXPgXUKssLGq9QxfjiPp5T
	 sKy2yJdmN9Mcc7CnAu1o+k4Zscw2bRpom7EhzWQA1xeGZC/kIr7jldYdogMObIgShe
	 nFjnF9US4f3AnT6hCWmql7yT54+ZmXXAHUPwjtlW2N1KR67Tj64TPAuUeVcLXNVm9q
	 jyS19UTEl+IUAbSzibWdiMle0nG/csb9CVk8vwPWYZ243JgGvTy8VDSjH9MuPNn9IP
	 NqL1kjBYutlcg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 09/11] soc: qcom: add ICE keyslot partitioning driver
 for guest VMs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Linlin Zhang" <linlin.zhang@oss.qualcomm.com>
Cc: robh@kernel.org, devicetree@vger.kernel.org, conor+dt@kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260827160806.1295313-10-linlin.zhang@oss.qualcomm.com>
References: <20260827160806.1295313-1-linlin.zhang@oss.qualcomm.com>
 <20260827160806.1295313-10-linlin.zhang@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 27 Aug 2026 16:17:18 +0000
Message-Id: <20260827161719.164651F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Probe error path leaves a dangling pointer in the global `g_ice_sl=
ots`, leading to a Use-After-Free.
- [Medium] Implicit assumptions about Device Tree node ordering falsely rej=
ect valid, disjoint keyslot allocations.
--

commit 298e1c705033929570b5634f841cfc46474229cd
Author: linlzhan <linlin.zhang@oss.qualcomm.com>

soc: qcom: add ICE keyslot partitioning driver for guest VMs

On Qualcomm platforms the ICE hardware has a fixed number of physical
keyslots shared across the host and all guest VMs. Add the QCOM_ICE_SLOTS
platform driver to parse qcom,ice-keyslot-map DT nodes and map guest=20
virtual keyslot indices to physical keyslots allocated to each VM.

> diff --git a/drivers/soc/qcom/qcom_ice_slots.c b/drivers/soc/qcom/qcom_ic=
e_slots.c
> new file mode 100644
> index 0000000000000..364ac93077c12
> --- /dev/null
> +++ b/drivers/soc/qcom/qcom_ice_slots.c
[ ... ]
> +static int qcom_ice_slots_get_guest_slots(struct blk_crypto_profile *pro=
file,
> +					  u32 guest_id)
> +{
> +	struct qcom_ice_slots *virt =3D virt_lookup(profile);
> +	unsigned int i;
> +
> +	if (!virt)
> +		return -ENOKEY;
> +
> +	/* entries[0] is the host; guest entries start at index 1. */
> +	for (i =3D 1; i < virt->num_entries; i++) {

[Severity: Medium]
Does this loop skip index 0 by hardcoding the assumption that the very first
parsed DT child node corresponds to the host?

This hides the first parsed entry from guest translation regardless of its
actual properties, which breaks guest VM keyslot partitioning if the host is
not the first child node in the device tree.

> +		if (virt->entries[i].guest_id =3D=3D guest_id)
> +			return virt->entries[i].max_slots;
> +	}
> +	return -ENOKEY;
> +}
[ ... ]
> +static int qcom_ice_slots_probe(struct platform_device *pdev)
> +{
[ ... ]
> +		if (idx > 0 &&
> +		    slot_offset <
> +		    virt->entries[idx - 1].slot_offset +
> +		    virt->entries[idx - 1].max_slots) {

[Severity: Medium]
Can this logic falsely abort the probe when the nodes are disjoint but appe=
ar
out-of-order in the Device Tree?

This check only verifies the current entry's offset against the immediate
predecessor's end. If the nodes are legitimately sorted by their unit-addre=
ss
reg instead of slot_offset, this mathematically flawed check evaluates to t=
rue
and falsely rejects valid physical keyslot mappings.

> +			dev_err(dev, "slot overlap: guest_id=3D%u overlaps guest_id=3D%u\n",
> +				guest_id, virt->entries[idx - 1].guest_id);
> +			ret =3D -EINVAL;
> +			of_node_put(child);
> +			goto err_free;
> +		}
[ ... ]
> +	virt->num_entries =3D idx;
> +
> +	/*
> +	 * Publish the singleton.  From this point on, bcp_slot_virt_ops
> +	 * callbacks can resolve virt via rcu_dereference(g_ice_slots).
> +	 */
> +	rcu_assign_pointer(g_ice_slots, virt);
> +
> +	ret =3D bcp_register_slot_virt_ops(&qcom_slot_virt_ops);
> +	if (ret) {
> +		dev_err(dev, "failed to register slot_virt_ops: %d\n", ret);
> +		goto err_free;
> +	}

[Severity: High]
Is it possible for this error path to leave a dangling pointer in the global
g_ice_slots resulting in a use-after-free regression?

The devm-allocated virt state is published to the global g_ice_slots pointer
via rcu_assign_pointer(). If bcp_register_slot_virt_ops() fails, the functi=
on
returns via the err_free label without setting g_ice_slots back to NULL.=20

When the devres framework subsequently frees virt, it leaves a dangling poi=
nter
that can be dereferenced by the hot path if blk-crypto-proxy invokes the
still-registered operations.

> +
> +	dev_info(dev, "registered: %u VMs, %u total ICE slots\n",
> +		 idx, total_slots);
> +	return 0;
> +
> +err_free:
> +	return ret;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260827160806.1295=
313-1-linlin.zhang@oss.qualcomm.com?part=3D9
