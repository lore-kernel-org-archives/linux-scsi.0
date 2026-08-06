Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759873B4E8F
	for <linux-scsi@vger.kernel.org>; Thu,  6 Aug 2026 15:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786031110; cv=none; b=mFPyw94jxUsd0Ef/f1+9LN64WhXaW3f0TQC1+4iYwy4+/BmGG++lgAnITsQ/mH1jXzPWvIHFTz1zhh9loCHpak4m4pQ4WAI+OdPcsJJy8EdrUZjDy9SgDYUAfBTcsjN0cXUwBymy1/mVGu3aX6XxR1tpECa2eQ0d97Tf5nBYvag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786031110; c=relaxed/simple;
	bh=wzziDTQ2F2paI2mYmoWTvI6/dlp7VOsMO9QuD2QXOnE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=OG/3PHzQ5FV4mu1EmLA407QgxY1mNMcXvtz9uNi7Oj7fc3APnGEv44kfDhA70B+kq4byGJ0evLkB/LbUhTRIuHhXzpAc0LYdaq7uesdp2Yq8ysc0sNEKgpd74flIxt8nLbam/R6oPNUI1wKc8JkH3rPp8End+bnVX7NLCtNUgTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QcCDKo1g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QcCDKo1g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E711F000E9;
	Thu,  6 Aug 2026 15:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786031109;
	bh=EjWMnOpQddUQkCU/UEhzPfRZtD6m8Wvy74fe9yI5IYQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QcCDKo1gLAvjSU2JWi97iWGhR1t4LP7B2oygC2KSnGR8M9PtcS29NNnXAk5jTfgR7
	 AdVIb74M5uzHOT0Wm7l+LrcjAXoKe/2y7kJ5YvFer5J1XRDff8h/WI+wdK47Ct6VmQ
	 y9YOUh2dk2tJFJIvGfvu8KRuxtl4NuMycEUAzu+jvgV3d0JN0wEEnhXONjczrr74j0
	 x0HZnoVEKjnPmybY2Pa8l5Wqv1GyIy5aJ9N1FHkIRsJQfmmVwlbhZ0i7toUJ3A6bqj
	 Ev1P6U/AyPlOcoXp0BbgxOX7WFtlHoY54uGOkO0M+ny94UwgTt/pdaPXVh32iNnuKJ
	 M+pF1An9ZRiZw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 2/7] scsi: ibmvfc: Add NOOP command support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260806-ibmvfc-fpin-support-v5-2-13fd6f8a8f8b@linux.ibm.com>
References: <20260806-ibmvfc-fpin-support-v5-0-13fd6f8a8f8b@linux.ibm.com>
 <20260806-ibmvfc-fpin-support-v5-2-13fd6f8a8f8b@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 06 Aug 2026 15:45:08 +0000
Message-Id: <20260806154508.D2E711F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Dereferencing the unvalidated, hardware-provided pointer `evt`=
 to access `evt->queue` before validating the pointer itself, which can lea=
d to out-of-bounds access, kernel panic, or arbitrary memory write.
--

--- Patch [2]: [PATCH v5 2/7] scsi: ibmvfc: Add NOOP command support ---
commit 62ab2a186e05dc64b296e88c19571f798767a9fa
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: Add NOOP command support

Adds support for VFC_NOOP messages from VIOS to enable keep-alive
functionality between the client and server. Defines the VFC_NOOP CRQ format
and handles it in the main and sub-CRQ handlers.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 2829f4e4b5636..04a405b0860fa 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c

[ ... ]

> @@ -4212,7 +4222,15 @@ static void ibmvfc_handle_scrq(struct ibmvfc_crq *=
crq, struct ibmvfc_host *vhost
>  	case IBMVFC_CRQ_XPORT_EVENT:
>  		return;
>  	default:
> -		dev_err(vhost->dev, "Got and invalid message type 0x%02x\n", crq->vali=
d);
> +		dev_err(vhost->dev, "Got an invalid message type 0x%02x\n", crq->valid=
);
> +		return;
> +	}
> +
> +	if (crq->format =3D=3D IBMVFC_NOOP)
> +		return;
> +
> +	if (unlikely(!evt)) {
> +		dev_err(vhost->dev, "Received null event\n");
>  		return;
>  	}
> =20

[Severity: Critical]
This is a pre-existing issue, but does this code dereference the
hardware-provided pointer before validating it?

Looking at ibmvfc_handle_scrq() in drivers/scsi/ibmvscsi/ibmvfc-core.c, evt=
 is
cast directly from the untrusted crq->ioba field provided by the hypervisor:

    struct ibmvfc_event *evt =3D (struct ibmvfc_event *)be64_to_cpu(crq->io=
ba);

Although the patch adds a check for a NULL evt, it then proceeds directly t=
o:

    if (unlikely(!ibmvfc_valid_event(&evt->queue->evt_pool, evt))) {
        ...
    }

If the hypervisor sends a corrupted or malicious non-NULL ioba value, won't
accessing evt->queue here cause an out-of-bounds access or kernel panic bef=
ore
the pointer is actually validated by ibmvfc_valid_event()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260806-ibmvfc-fpi=
n-support-v5-0-13fd6f8a8f8b@linux.ibm.com?part=3D2
