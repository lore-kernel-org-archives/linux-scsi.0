Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37393E49EB
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 02:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789093869; cv=none; b=uIOl+lGt+StAQEU2dQ94XPSNIyuwRmE5H3Kp8yr1cz8uqEdOx9UJqXfL4uOnETAp9vUn6hB8gEbNhMxBOi9DBuE2YwEhJ6527eprb4FU099S+LVPtPqLzZKatNxpDqFpkmaaWP1uRnX5GqRhPpWN1cwIrmUHD7Z6RJx43Wpdre8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789093869; c=relaxed/simple;
	bh=XuaMgOSY5R1YduMTQnEfx+ZZtxzCE1aHa02Kmd+Z5kI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=d2YBpZCwYjYwHANYXxuwPgYIlDiMtvd7n6ldV+uDhKP0lkWHtxBDKU49gDcUZOMwyeREwAlPvSdRKO4iNfCW2uBnvocvAV3oYJzlsVLlDuAHRKF0+wslZ5wduMUQgQepojcQyE108UMQ46MwuwcaZcOKF4aMqKJYJgAHyjeGmpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U/g/eHZ6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U/g/eHZ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF63E1F00898;
	Fri, 11 Sep 2026 02:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789093867;
	bh=yf24MJSKbQRYzwHYE1rL+MA8mplIBQ9GguVzdG6cA/0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=U/g/eHZ6HPVcOKQg8FBcoDuov0v4KJi89cA+btHbGz/In0+tkBsgYmafKiU0WnXG4
	 vjdu3m7rSGta6srlSuQ53CDsWwaU9CVsS1z0QHJB/svg95lrkGx8UvuINf2iuTesTb
	 89pT1pRckOb1V49r+sN2Qx1FZ9NId8/1AGFYa94JMWtSj/RKv2Rz+mOlr49RyKqjRM
	 ZCXM3Zf7hhbVMAXrGzcg685B7MkGqkoL3GdwhJ8g4IsvexTq227hzafcVf8o7cQbgq
	 8PbUG52RGi0QiwhXsc1d1FFyUkByIjWCyqEyn+PDAXmc+H/PO17wwHQV8F4Mu6HUMP
	 EhBzHR5K9/OYQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 2/9] scsi: ibmvfc: add NOOP command support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260911021910.1038128-3-tyreld@linux.ibm.com>
References: <20260911021910.1038128-1-tyreld@linux.ibm.com>
 <20260911021910.1038128-3-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 11 Sep 2026 02:31:07 +0000
Message-Id: <20260911023107.AF63E1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Untrusted hypervisor input (`crq->ioba`) is dereferenced prior to =
validation, leading to a potential unmapped page fault (kernel panic).
--

commit 186cace34a3b58dd32c18fecc8f7d21b71c9763c
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: add NOOP command support

This commit adds support for handling IBMVFC_NOOP format CRQ messages from
the VIOS partner and advertises this capability during login. It updates
CRQ handlers to ignore NOOP messages while logging rate-limited errors if
the partner did not advertise support. Finally, it fixes a typo and adds a
null check for event pointers in ibmvfc_handle_scrq().

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 5259a80958ce1..6b2eb82ceb98d 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
[ ... ]
> @@ -4225,7 +4235,20 @@ static void ibmvfc_handle_scrq(struct ibmvfc_crq *=
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
> +	if (crq->format =3D=3D IBMVFC_NOOP) {
> +		if (vhost->state =3D=3D IBMVFC_ACTIVE &&
> +		    !ibmvfc_check_caps(vhost, IBMVFC_SUPPORT_NOOP_CMD))
> +			dev_err_ratelimited(vhost->dev,
> +					    "Received unexpected NOOP command from partner\n");
> +		return;
> +	}
> +
> +	if (unlikely(!evt)) {
> +		dev_err(vhost->dev, "Received null event\n");
>  		return;
>  	}
> =20
>  	/* The only kind of payload CRQs we should get are responses to
>  	 * things we send. Make sure this response is to something we
>  	 * actually sent
>  	 */
>  	if (unlikely(!ibmvfc_valid_event(&evt->queue->evt_pool, evt))) {

[Severity: High]
This isn't a bug introduced by this patch, but does ibmvfc_handle_scrq()
dereference the unvalidated evt pointer?

Since evt is derived from an untrusted hypervisor value (crq->ioba), if the
hypervisor sends an invalid non-null pointer, evaluating &evt->queue->evt_p=
ool
will dereference evt->queue before ibmvfc_valid_event() can check if evt
falls within the legitimate event pool bounds. Can this cause an unmapped
page fault and kernel panic?

Should the implementation bypass the untrusted pointer entirely when locati=
ng
the event pool, for instance by passing the actual scrq object from the
caller?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260911021910.1038=
128-1-tyreld@linux.ibm.com?part=3D2
