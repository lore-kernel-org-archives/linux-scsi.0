Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33AC385D99
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2026 01:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782179705; cv=none; b=T+YuYLBWm4qsLWYF90Lg8rqBCwEIG/1BaKpiHoytr3q7j+GYbd0JbjMGQqCyVbCOf8B4ItYTd4xCwdXbxFnm11/SKpSh02cUFgetvkGS4WZdgecj+hbMDzSpgChlKUQnTw49FryRBW6iTvuH4QcnzEuJ7uFsJ1FQaNT5Rej6dq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782179705; c=relaxed/simple;
	bh=P3Ibs+YEPwCWN4Olq/7LvGWInWZh+WqvE0RxNtGa5D0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hFqPeNLVNZVS8dad2HtmVaAyN8tfGi8I8NphZrpcuhWZJ5lziAPiMvkroDgEZXvJfXpDsbDrdP8eZZ5GfecVgGp9PJPPBWimDq4Dv8hTyx2TwddBEea0HIHGp91BL61JkCcJtM+9PUVAS4+xfbGO6tNRBpl8wkVdlLxkSL6IRS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b+pb9h9x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b+pb9h9x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F02A1F000E9;
	Tue, 23 Jun 2026 01:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782179704;
	bh=xAMDvAKDiuPTE2XsiG3pVnO6dvj48OSykmPNRn4PKng=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=b+pb9h9xnvpU6AxK6UqmWtbsGex2Vyul5cGrDwgrwafPcappse3eqVHNS51HBXNg/
	 v7Zdtx2YAmJRgPI9aA0htdf/08kCIy/kjeOmbVkavGKXpF5HjN+Mhl+zXbOufnuGdO
	 mYK9WjPyE284+Stq4zgJ7DoyqPFgUWNMwZlgYc47QXWhV+/Y4NY5ED7ccVJnzPYNNJ
	 5m0z7I0iWRGB6OG86f9WmNtVxLzFrj9Bioz5P9pMiGlgMEVJcfbBsOVJgC1mdN5FMH
	 v2DhsEEyYfSqTuKydmvwct+3fg/VR8UmrcYP7fXBR/+reKv4ErLYPlRqGxVZRyz9hA
	 A17oNhZbtp66w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 05/29] ibmvfc: alloc/dealloc sub-queues for nvme
 channels
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260623013035.3436640-6-tyreld@linux.ibm.com>
References: <20260623013035.3436640-1-tyreld@linux.ibm.com>
 <20260623013035.3436640-6-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 01:55:04 +0000
Message-Id: <20260623015504.9F02A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Failure to register NVMe sub-queues silently disables SCSI multiqu=
eue support due to a shared state flag.
--

commit 6eb0f2ef7c51067f6c97ea8c13211afa2e19dcc4
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

ibmvfc: alloc/dealloc sub-queues for nvme channels

This patch allocates, registers, deregisters, and releases NVMe subordinate
CRQs alongside the existing SCSI sub-CRQs. It integrates the NVMe queue
lifecycle with the existing SCSI queue lifecycle to ensure both protocols
are reset consistently.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 5732ccf2ac1c0..6f5e8b3cbfc82 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c

[ ... ]

> @@ -6109,6 +6113,13 @@ static void ibmvfc_init_sub_crqs(struct ibmvfc_hos=
t *vhost)
> =20
>  	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
> =20
> +	if (vhost->nvme_enabled) {
> +		if (ibmvfc_alloc_channels(vhost, &vhost->nvme_scrqs))
> +			vhost->nvme_enabled =3D 0;
> +		else
> +			ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs);

[Severity: High]
Does a failure to register NVMe sub-queues unintentionally disable SCSI
multiqueue support here?

If ibmvfc_reg_sub_crqs() fails while registering the NVMe channels, it hand=
les
the error by unregistering the partial channels and setting a shared host f=
lag:

ibmvfc_reg_sub_crqs() {
    ...
    if (ibmvfc_register_channel(vhost, channels, i)) {
        for (j =3D i; j > 0; j--)
            ...
        vhost->do_enquiry =3D 0;
        return;
    }
}

Since ibmvfc_reg_sub_crqs() is now called for NVMe right after successfully
registering the SCSI sub-queues, setting vhost->do_enquiry to 0 upon an NVMe
registration failure will cause the driver to skip channel enquiry during t=
he
NPIV login sequence.=20

Will this cause the successfully registered SCSI channels to be silently
ignored if the hypervisor rejects the NVMe sub-crqs allocation?

> +	}
> +
>  	LEAVE;
>  }
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623013035.3436=
640-1-tyreld@linux.ibm.com?part=3D5
