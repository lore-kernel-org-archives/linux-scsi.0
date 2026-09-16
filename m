Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87A34B5150
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 23:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789601954; cv=none; b=ldka/caZ5Pw1uLy/rp/bVSLbWOZKXqhlTXh+ZSdJcVPAVusS6Qi+5VZ7v+lAaWX6afaBRZRsMXJcKhYQqrZGgBU2fhpduKUsSVlXp00tJmW0Cpn2na2LQtDPocmy+SIlzXBL2qSibwOajN07KT61SGEuyyX6vWUljCClyBUOHco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789601954; c=relaxed/simple;
	bh=uPzts3ELUI6k9SKgbbpiCXFPNxYtJfrh2Ofzh1uefVw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=dLX4Z/+gJ4pMDb9PuxO9/6W9noYY3VwfYuDr4/N/aBeneefVI9+AzpziizQBL2sKUbn6+Ju8ElDnSR2oLs+12/Al2QTuP6gdkhmqaKCElciJ1fPNxvvHLUM8+kI8E9RRrIIuxAVTjm8Rf0mu73BqCBV6UAFxxa1KPrvfdOps+Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Se6KQDFi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Se6KQDFi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC38F1F000FF;
	Wed, 16 Sep 2026 23:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789601950;
	bh=Bd66oiTHtXy2YWHAS/kbYYUnWhyh+y/Hay2Gh/Vc2Eo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Se6KQDFimLxN7t4HwzOj24ec+1wUnIJ3nEWE441vnvdOOp4PwGUl4Wpm03ExwTaQW
	 gsgRCV2MEn5ZvFFsaZOWGVPynF6cWwkrLitXRgfARKbSPGuLXJFE+bQJoVIGueTikn
	 ZMT13lORvRsZdml2XZLvl+uw1rsGykAzx4tewJ+slucokH9PzIXy4CR3drKlymZmYI
	 mHdMAWN8CUK3z32zJ/bbXZKoMOb/J2yvkNkomOlk0PzjgBMGBc7iqQ/ipZzhBfCM29
	 SAJG4M0mQgYqILT/HGLnMjQM/Ljv7pWQjDHV3XaKWHgRVPShsCizJeAzmj9Sv/So9R
	 yRQkm5qL1/EUw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 18/20] scsi: ibmvfc: fix NVMe sub-queue registration
 failure disabling SCSI multiqueue
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260916230921.2204729-19-tyreld@linux.ibm.com>
References: <20260916230921.2204729-1-tyreld@linux.ibm.com>
 <20260916230921.2204729-19-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 16 Sep 2026 23:39:09 +0000
Message-Id: <20260916233909.BC38F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] ibmvfc: permanent loss of NVMe MQ after transient registration fai=
lure
--

commit 3196ff84a81b6364f0d8e7add637cd7dce662d03
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

scsi: ibmvfc: fix NVMe sub-queue registration failure disabling SCSI multiq=
ueue

This commit modifies ibmvfc_reg_sub_crqs() to check the channel protocol
during registration failure. It clears vhost->do_enquiry for SCSI failures
and vhost->nvme_enabled for NVMe failures, preventing NVMe registration
failures from silently disabling SCSI multiqueue support.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 93189692191e3..d79a6ae278a2c 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> @@ -6527,7 +6527,10 @@ static void ibmvfc_reg_sub_crqs(struct ibmvfc_host=
 *vhost,
>  		if (ibmvfc_register_channel(vhost, channels, i)) {
>  			for (j =3D i; j > 0; j--)
>  				ibmvfc_deregister_channel(vhost, channels, j - 1);
> -			vhost->do_enquiry =3D 0;
> +			if (channels->protocol =3D=3D IBMVFC_PROTO_SCSI)
> +				vhost->do_enquiry =3D 0;
> +			else
> +				vhost->nvme_enabled =3D 0;

[Severity: High]
Does this permanently disable NVMe multiqueue support if an NVMe sub-queue
registration failure is transient?

When an NVMe registration fails, vhost->nvme_enabled is now set to 0.
The host will eventually reset and retry registration, for example via
ibmvfc_reset_crq() or ibmvfc_reenable_crq_queue().

Unlike vhost->do_enquiry which is explicitly restored to 1 during reset:

ibmvfc_reset_crq() {
	...
	vhost->do_enquiry =3D 1;
	vhost->using_channels =3D 0;
	vhost->do_scsi_login =3D 0;
	vhost->do_nvme_login =3D 0;
	...
}

vhost->nvme_enabled is never restored.

If the subsequent registration retry succeeds, the NVMe channels are
successfully registered with the hypervisor, but nvme_enabled remains 0.
Could this prevent the driver from advertising IBMVFC_YES_NVMEOF during
NPIV login, leaving the newly registered channels permanently unused by the
VIOS and breaking the multiqueue recovery mechanism?

>  			return;
>  		}
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260916230921.2204=
729-1-tyreld@linux.ibm.com?part=3D18
