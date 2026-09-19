Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF7A3C8C71
	for <linux-scsi@vger.kernel.org>; Sat, 19 Sep 2026 01:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789782841; cv=none; b=ZJvRY4BXFMoHalsEvpSP04eucDHZXAMkmLyL1Xiahk6K5jRVOOzWlPNSKAuDH74/K9HU3QNCnMeXs/+qFTSwczm1kap1cyIb9L8Qkc+dtrLXw8LVG5JY99RtYLKImShdMmhjbM9tjSrGf72JnHsspNzghVeXmM1LeXxB+Otd5oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789782841; c=relaxed/simple;
	bh=tOmKz12DUrZuN4FCn/C+ha+6npn8QrLDkPBFmzgEkDo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=CnVLUkSSodU/hLT0m7hog6RT6zdSelsB7vlF9mHn3RY82w8rffWcsMaO5WZYNEZfO2xH2Aj8wBuhl4TknHJtRq0Ocu6luN/zo41eW6hZu8vpzaB9AZOUwLKrrmIBDhWN/uBZg2DDxNgu8R5NLCYdoTer2lr23/Q74sZQRoo5rcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FrL3dJqv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FrL3dJqv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EDCC1F000FF;
	Sat, 19 Sep 2026 01:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789782840;
	bh=P0MDEqldweXaOim3DXEorXrtjMtEe84CtwTHlNQQtfk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FrL3dJqv+VCUUOprLvgJlKSeqINgB82AMnBB+xOmygqPPG0mOdQotuoTFHMj9hD/c
	 Xj0IWe4366oxst2+cPZWnt9RNbkrVD5KTrSLnumjGBOrxGInglTheJBFu7udsGHUJL
	 Fpnz1XmABgMbEsoXc3R+mzeQ1kb7n55XvZgT7A9Fz45hQ4xcacFetjgL3eTjUEbCH8
	 dv028QCUUVGI03YpAv3ZKTRUI+WX+Czb9IL7Nnw3XSu/tDg5RJavOzggSsCRJtHG6M
	 KpTdAE9Yy9XTPfzK5l8fIAuVvwWyIHgtTMfl3YskqP6AsOaHSNpOUTWctgj4QRRXr4
	 3HGT2PkPC0rjQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 14/20] scsi: ibmvfc: fix UAF and stall in NVMe LS
 abort callback
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260919013306.2948028-15-tyreld@linux.ibm.com>
References: <20260919013306.2948028-1-tyreld@linux.ibm.com>
 <20260919013306.2948028-15-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 19 Sep 2026 01:53:59 +0000
Message-Id: <20260919015400.0EDCC1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: ibmvfc: ls_abort validity check defeated by stale ls_req
--

commit 0d745a9ce0a68c1aa95c0283c60b12feb6ac43d9
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

scsi: ibmvfc: fix UAF and stall in NVMe LS abort callback

This commit fixes a use-after-free and a blocking wait in the NVMe LS abort
callback. It moves event validation inside the host_lock and replaces the
synchronous wait with an asynchronous callback.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c b/drivers/scsi/ibmvscsi/=
ibmvfc-nvme.c
> index d23e5f31f8b51..475177cda103a 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
[ ... ]
> @@ -202,34 +204,36 @@ static void ibmvfc_nvme_ls_abort(struct nvme_fc_loc=
al_port *lport,
>  {
>  	struct ibmvfc_host *vhost =3D lport->private;
>  	struct ibmvfc_target *tgt =3D rport->private;
> -	struct ibmvfc_event *evt;
> -	union ibmvfc_iu rsp;
> +	struct ibmvfc_event *evt, *abt_evt;
>  	unsigned long flags;
> -	u16 status =3D IBMVFC_MAD_CRQ_ERROR;
> +
> +	spin_lock_irqsave(&vhost->host->host_lock, flags);
> +
> +	/*
> +	 * If the original LS has already completed naturally, abt_evt will
> +	 * have been freed back to the pool (evt->free set to 1 under
> +	 * host_lock by ibmvfc_free_event()).  Nothing left to cancel.
> +	 */
> +	abt_evt =3D ls_abort->private;
> +	if (!abt_evt || atomic_read(&abt_evt->free) || abt_evt->ls_req !=3D ls_=
abort) {

[Severity: High]
If an LS request fails during send, ibmvfc_vfc_eh_done() frees the event wi=
thout
clearing evt->ls_req:

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_vfc_eh_done() {
	...
	} else if (ls_req) {
		ls_req->done(ls_req, -EIO);
		kref_put(&evt->tgt->kref, ibmvfc_release_tgt);
	}

	ibmvfc_free_event(evt);
}

If this event is subsequently reallocated for a new command, evt->free
becomes 0 but evt->ls_req remains stale.

If the NVMe core then calls ibmvfc_nvme_ls_abort() concurrently
(before the new command calls ibmvfc_init_event()), wouldn't this
validation bypass the check since abt_evt->ls_req still matches
ls_abort?

If the check is bypassed, the abort path will dereference abt_evt->tgt
which was already released by the error path, potentially causing a
use-after-free or sending an unintended abort MAD for an active command.

> +		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
> +		return;
> +	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260919013306.2948=
028-1-tyreld@linux.ibm.com?part=3D14
