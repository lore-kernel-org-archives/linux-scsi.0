Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793032312;
	b=475e8fmkntio+0yG521C6VrKo40di3VwiJGDbEIYdIApYk2Y7vfXBF1MFn2u00G6l28P
	 ogvkFEmC27+VLYbeFVGxv+I/rPBKBeG4rO/jmrbgcLcIqnQCCNiDEBHEmEd4eA2N9rmR+
	 ZwsWFBDn4dGnRS6vDxcoUG0R/6yN3HCHF6G3UgmpPGdAYBeiKYuSys0J9yYeNhrull6Fm
	 FEoPRdYTVJO3a99/TtdSqJIwVyM0S+uXxh5EeaExrSvZMpTg1CzainVHEzF7T1It2I5Bc
	 TCFGrCRRuoXAvDSYVi1SkPiHZct2roLs3+tZQKz1sSrpl1tpwgolNDTAd6aybUkgKOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793032312;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=17Sb3RBUjHmIJ3f9t/Bg0TQGr1ZFBKIeLRe6lADamVg=;
	b=KoaDzeEvRdNbLqATgs8YUt+J8uYc5lOVP3rFl8Fnil9+BPJx5p74DVXXitw+h+0ImWrc
	 OXeAkiCOTkhgfnT5Dy85Brwy4UpXTuFImWGK/S/SNt22co9TcPSZ5RbnBOD26dGh4Sc2m
	 fhfAKmEGN//MeUmQWnHpVYKTtauRao7BgBX5nTEIYkcBYssJTFEFHufcbEZfUARR6DYmR
	 HhNx/rM7n1A5yhXrEcAfI10tCB+nyk2jnCDEgv6UiatsqvHyP8La84ID/OpbfIOI4OV2Q
	 sLnOcjubSz3+ddZGgx+k+FG8Pz2shX+O8yZ/h04hcfdGzPRB1P80WloymJORegZ7/+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="d9kh8/iZ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A1B606A320
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 16:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d9kh8/iZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 760D51F01829;
	Mon, 26 Oct 2026 16:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793032311;
	bh=17Sb3RBUjHmIJ3f9t/Bg0TQGr1ZFBKIeLRe6lADamVg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=d9kh8/iZ0kCVZcjADywjtbvw0WblX8T++eZUXVti5oGcYZU6GdICFQRXZt9RJbxzH
	 PgZyagw2Or0dZ348Cb+8Ts9vVubOmpHqCZbMze0PuWuApKrnBVQ19RKLcX2J5x4Soe
	 V7/0fhc/yz9bxfj2adHYx6EcynoBqemhvrKgmi1acLExXd3ZAMFlQkI0EaIrdBtT++
	 tTeEPzk7qnPC/RfSKnbGlSX2U114oZPdCP1V87kfBSjzbhUOgubsZwNtK6/PKfmHxZ
	 mhnVVX7pj9Afkd+/GgRDC7cooryxkYBZob8aTzTRiMUKpMsV/1U9zJVV2If9Z2Prre
	 ID1WasJmwt31g==
Message-ID: <sashiko-outbox-185519@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v16 11/12] scsi: ibmvfc: register and use asynchronous
 sub CRQ for events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261026-ibmvfc-fpin-support-v16-11-a900aa657ed5@linux.ibm.com>
References: <20261026-ibmvfc-fpin-support-v16-0-a900aa657ed5@linux.ibm.com>
 <20261026-ibmvfc-fpin-support-v16-11-a900aa657ed5@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 16:31:51 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: ibmvfc: broken error unwind and MQ disable in ibmvfc_reg_sub=
_crqs()
--

commit 0ac96c5239b66a2d4b7e04178af6f76c367e358d
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: register and use asynchronous sub CRQ for events

This commit wires the asynchronous sub-CRQ into the ibmvfc sub-CRQ lifecycle
so that it is allocated, registered, and released alongside the SCSI and NV=
Me
channel queues. It also updates channel setup and login capability flags to
advertise async sub-CRQ support.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index af11726b76beb..4d4ebe5f6f123 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
[ ... ]
> @@ -988,6 +989,7 @@ static int ibmvfc_reenable_crq_queue(struct ibmvfc_ho=
st *vhost)
>  	spin_unlock(vhost->crq.q_lock);
>  	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
> =20
> +	ibmvfc_reg_sub_crqs(vhost, &vhost->async_scrqs);
>  	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
>  	ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs);
> =20
[ ... ]
> @@ -1044,6 +1047,7 @@ static int ibmvfc_reset_crq(struct ibmvfc_host *vho=
st)
>  	spin_unlock(vhost->crq.q_lock);
>  	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
> =20
> +	ibmvfc_reg_sub_crqs(vhost, &vhost->async_scrqs);
>  	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
>  	ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs);
> =20
[ ... ]
> @@ -6976,25 +6994,45 @@ VISIBLE_IF_KUNIT void ibmvfc_deregister_channel(s=
truct ibmvfc_host *vhost,
>  }
>  EXPORT_SYMBOL_IF_KUNIT(ibmvfc_deregister_channel);
> =20
> -static void ibmvfc_reg_sub_crqs(struct ibmvfc_host *vhost,
[ ... ]
> +static int ibmvfc_reg_sub_crqs(struct ibmvfc_host *vhost,
>  				struct ibmvfc_channels *channels)
>  {
> +	unsigned long flags;
>  	int i, j;
> =20
>  	ENTER;
>  	if (!vhost->mq_enabled || !channels->scrqs)
> -		return;
> +		return 0;
> =20
>  	for (i =3D 0; i < channels->max_queues; i++) {
>  		if (ibmvfc_register_channel(vhost, channels, i)) {
>  			for (j =3D i; j > 0; j--)
>  				ibmvfc_deregister_channel(vhost, channels, j - 1);
> +			spin_lock_irqsave(&vhost->host->host_lock, flags);
>  			vhost->do_enquiry =3D 0;
> -			return;
> +			vhost->mq_enabled =3D 0;
> +			spin_unlock_irqrestore(&vhost->host->host_lock, flags);
> +			return -1;
>  		}
>  	}
> =20
>  	LEAVE;
> +	return 0;
>  }
[ ... ]
> @@ -7083,9 +7102,74 @@ static void ibmvfc_release_channels(struct ibmvfc_=
host *vhost,
>  	}
>  }
> =20
[ ... ]
> +static void ibmvfc_init_sub_crqs(struct ibmvfc_host *vhost)
> +{
> +	unsigned long flags;
> +
> +	ENTER;
> +	if (!vhost->mq_enabled)
> +		return;
> +
> +	/* register async_sub_crq channel */
> +	if (ibmvfc_alloc_channels(vhost, &vhost->async_scrqs))
> +		goto out;
> +
> +	if (ibmvfc_reg_sub_crqs(vhost, &vhost->async_scrqs))
> +		goto release_async_sub_crq;
> +
> +	if (ibmvfc_alloc_channels(vhost, &vhost->scsi_scrqs))
> +		goto deregister_async_sub_crq;
> +
> +	if (ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs))
> +		goto release_scsi_sub_crqs;
> +
> +	if (vhost->nvme_enabled) {
> +		if (ibmvfc_alloc_channels(vhost, &vhost->nvme_scrqs)) {
> +			spin_lock_irqsave(&vhost->host->host_lock, flags);
> +			vhost->nvme_enabled =3D 0;
> +			spin_unlock_irqrestore(&vhost->host->host_lock, flags);
> +		} else if (ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs)) {
> +			ibmvfc_release_channels(vhost, &vhost->nvme_scrqs);
> +			spin_lock_irqsave(&vhost->host->host_lock, flags);
> +			vhost->nvme_enabled =3D 0;
> +			spin_unlock_irqrestore(&vhost->host->host_lock, flags);
> +		}
> +	}

[Severity: High]
Does clearing vhost->do_enquiry and vhost->mq_enabled unconditionally inside
ibmvfc_reg_sub_crqs() cause inconsistent state and leaked sub-CRQ
registrations when a later channel set fails to register?

In ibmvfc_init_sub_crqs(), vhost->async_scrqs and vhost->scsi_scrqs are
allocated and registered first. When vhost->nvme_enabled is set and
ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs) fails, ibmvfc_init_sub_crqs()
appears to intend to only disable NVMe by releasing vhost->nvme_scrqs and
setting vhost->nvme_enabled =3D 0.

However, because ibmvfc_reg_sub_crqs() has already set vhost->do_enquiry =
=3D 0
and vhost->mq_enabled =3D 0, multi-queue and channel enquiry are disabled f=
or
the entire host while vhost->async_scrqs and vhost->scsi_scrqs remain
allocated and registered with the hypervisor with active IRQ handlers.

Similarly, in ibmvfc_reenable_crq_queue() and ibmvfc_reset_crq():

	ibmvfc_reg_sub_crqs(vhost, &vhost->async_scrqs);
	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
	ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs);

If registering vhost->async_scrqs succeeds, and a subsequent call to
ibmvfc_reg_sub_crqs() for vhost->scsi_scrqs or vhost->nvme_scrqs fails,
vhost->mq_enabled and vhost->do_enquiry are cleared to 0, but the already
registered channel sets are not deregistered via ibmvfc_dereg_sub_crqs().

Should the caller handle clearing vhost->mq_enabled and vhost->do_enquiry (=
or
unwinding previously registered channel sets) instead of clearing those fla=
gs
unconditionally in ibmvfc_reg_sub_crqs()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026-ibmvfc-fpi=
n-support-v16-0-a900aa657ed5@linux.ibm.com?part=3D11
