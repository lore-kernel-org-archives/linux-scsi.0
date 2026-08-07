Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA323BB10C
	for <linux-scsi@vger.kernel.org>; Fri,  7 Aug 2026 08:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786090736; cv=none; b=b1XlsDPejS4XtgrKkN/ZrwoPojYhN5UcCoXQsds9Y5FKPCrz5j/61+U1jsQfeJxbekLEBSXen2tZcdtbcZyqE3sABw8dqjfetmjbyOy4IpAtaoR5N2XitTaJ6O0n1WzDh9J6xeEElEDzAdgE7lhrN+BEU5w/7y2qYpvtv6d+bMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786090736; c=relaxed/simple;
	bh=5pkbo+eW92aOutHaX1wT9Efj9kDzqaxk8Qab00VXSOA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=RP+FQNws/YnDHg1R3zQ20tr3uOkswLMC3Hjlh+ditBANMp5jj/ivXSGHdguadMLfpPKdsmpKW9+pjR7v2zhxaxWoSByYgPnQ4YIS2hTRZ2WCEVSPaxHb1Ta9UF30vO38Ul2JRLBRCss2RrcUsGi6ClKBBwN50+VA0up7atZXP2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RRg5pxFI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RRg5pxFI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 054121F000E9;
	Fri,  7 Aug 2026 08:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786090735;
	bh=ifEM+kUFd2A9xEatGkvh7N0QgWCTAsk1xXH13OoyHaA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RRg5pxFI7Wfuwr9f6wN1wgaN9fbe3ZfuD0Eg9bKosMpDmKEgN0hrV+RHs304HKHYd
	 dpJkcN633pMDfwWy3mnpQyDWjSLqyVF1izWTtOkmVce+mMhqYTnBWTtkYZCv6IeG1/
	 6nTg8Fwq4hGI0ejl7pjMSzQf19qprhEdUwh0Hubv+rbVatUWBuzjg7gUee3i5SOKZh
	 AB8c7r7lTtBRx53Ma7cd374wX7I+XZzBmFOBqCSom0RL7gylTJN9ass7SsPowPSRbw
	 wns4zD5AKD0hUwYcw2F2d50bmUe39VLVteHRHnYqrasOSNzDhbCGUJArgMYW8QQCCL
	 by440rHgq2LEg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: advansys: Fix invalid comparison in
 AdvBuildCarrierFreelist
Reply-To: sashiko-reviews@lists.linux.dev
To: "Roman Demidov" <roman.demidov.nn@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260807080339.9365-1-roman.demidov.nn@gmail.com>
References: <20260807080339.9365-1-roman.demidov.nn@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 08:18:54 +0000
Message-Id: <20260807081855.054121F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Boundary checks in `adv_get_carrier()` and `adv_get_reqp()` contai=
n off-by-one errors by using strict inequality (`>`), allowing out-of-bound=
s pointer dereferences if the hardware provides specific boundary offsets.
- [High] Missing `dma_rmb()` and `dma_wmb()` barriers in the hardware DMA r=
ing (carrier) management lead to race conditions with the device.
--

--- Patch [1]: [PATCH] scsi: advansys: Fix invalid comparison in AdvBuildCa=
rrierFreelist ---
commit 1fec77d68ab535d94e22469fc8d09c10da06eab9
Author: Roman Demidov <roman.demidov.nn@gmail.com>

scsi: advansys: Fix invalid comparison in AdvBuildCarrierFreelist

The loop index i takes values from 0 to carr_num - 1 therefore
the comparison i =3D=3D carr_num is always false. The assignment
next_offset =3D ~0 must occur for the last element of the list,
its index is carr_num - 1.

> diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
> index 5cdbf2bdb13df..95a227420b283 100644
> --- a/drivers/scsi/advansys.c
> +++ b/drivers/scsi/advansys.c
> @@ -4169,7 +4169,7 @@ static void AdvBuildCarrierFreelist(struct adv_dvc_=
var *adv_dvc)
>  		adv_dvc->carrier[i].carr_va =3D cpu_to_le32(carr_offset);
>  		adv_dvc->carrier[i].areq_vpa =3D 0;
>  		next_offset =3D carr_offset + sizeof(ADV_CARR_T);
> -		if (i =3D=3D carr_num)
> +		if (i =3D=3D carr_num - 1)
>  			next_offset =3D ~0;
>  		adv_dvc->carrier[i].next_vpa =3D cpu_to_le32(next_offset);
>  	}

[Severity: High]
This isn't a bug introduced by this patch, but I noticed a potential
out-of-bounds dereference in adv_get_carrier(). The driver receives offsets
from the device and validates them:

drivers/scsi/advansys.c:adv_get_carrier()
    ...
    BUG_ON(offset > ADV_CARRIER_BUFSIZE);
    ...

Could this allow an offset exactly equal to ADV_CARRIER_BUFSIZE to pass
the check, resulting in an index pointing one element past the end of the
carrier array? Should this use greater-than-or-equal instead?

The same pattern exists in adv_get_reqp():

drivers/scsi/advansys.c:adv_get_reqp()
    ...
    BUG_ON(offset > adv_dvc->max_host_qng);
    ...

Can an offset equal to max_host_qng bypass the safeguard and cause memory
corruption if malicious hardware provides this exact value?

[Severity: High]
This is a pre-existing issue, but are there missing DMA barriers in the
hardware DMA ring management?

In the submission path:

drivers/scsi/advansys.c:AdvExeScsiQueue()
    ...
    asc_dvc->icq_sp->areq_vpa =3D scsiq->scsiq_rptr;
    asc_dvc->icq_sp->next_vpa =3D new_carrp->carr_pa;
    ...

Without a dma_wmb() between writing the payload (areq_vpa) and the valid
flag (next_vpa), could weakly ordered CPUs reorder the stores, causing the
hardware to observe the new next_vpa while still reading a stale areq_vpa?

Similarly, in the completion path:

drivers/scsi/advansys.c:AdvISR()
    ...
    while (((irq_next_vpa =3D le32_to_cpu(asc_dvc->irq_sp->next_vpa)) & ADV=
_RQ_DONE) !=3D 0) {
        u32 pa_offset =3D le32_to_cpu(asc_dvc->irq_sp->areq_vpa);
    ...

Without a dma_rmb() after checking the done flag (next_vpa), could weakly
ordered CPUs speculatively read the payload field (areq_vpa) before the
device has written it, leading to the processing of stale state?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807080339.9365=
-1-roman.demidov.nn@gmail.com?part=3D1
