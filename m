Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297F84E06D5
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 19:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791401788; cv=none; b=S9FiwiBjEItfSsVu4yWPKhX6FsqjKBD7qFvWGaLpt5hl9uYZtOLJ+GhoHKAGoxa3YYblkszZPvdO1bSVvxRgmx/9rzBEUqFc3xMw3mruqKZCgYcgaSWw2Hy9i4AP7OAyTPj8vkaVkpF/sHQPQ8Hbbatg1y2BPredhCiC82Y6JOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791401788; c=relaxed/simple;
	bh=bS76AbhIhsOB2kXG5qofAe4/Z0o2a+UWeApnkvBYOvc=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=pwSiOHSHxF5vX1MfY6GDswsiwQkG1RkaVRASfR9Tzf9FGSxLs/UvPeCo4e0JSLRG5GszTr/V/1q3d9d09fDxMMPchLQ73+IeiME5bmF0tBaaE8EVuX5hq5j2o+Ji7sj3Oc2cs1AgKesLEk7NOpbskgUYXhddifjQ3Ogno5h/tJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TlObAgZz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TlObAgZz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B3E81F000FF;
	Wed,  7 Oct 2026 19:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791401786;
	bh=YDG95zIuciv9MKlpv0CGvkjTMcv/M7U/AzAltVkKpgo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TlObAgZzMLDR6JmlOFHnvJS3KtpD3gH6MaVf3RAdKs4PYFYj3m4JbobIDkCuNZaXx
	 ARXyMAs/+5D1b+7DKNJ70mbt5Ii8ZfsfGJcJwjVsJ1BMSsbO1ZQLqZbwEzJOGb0IkJ
	 FghxGEqldidObSmVbsfjtAwPVaulw8cW0BRy8kJwE2NRPUOwj1yFT3S0Z5+aSc1Nkw
	 fLX4CSKjUYnq6FiT0fCwhWCU5HApKZwrH8fD3/T+FvD6eI2yVAEEPBjJLFVf46mXwe
	 NpCb2qwh+6HI38L6cV9AaqEJW6Uf7MLq8roXNPTQJa08jS2Hy7qJLiWKtEMYZJxECT
	 Yb1A//dJyJ27w==
Message-ID: <sashiko-outbox-163312@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 05/11] scsi: ibmvfc: add NOOP command support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261007-ibmvfc-fpin-support-v13-5-b816abfa4fcc@linux.ibm.com>
References: <20261007-ibmvfc-fpin-support-v13-0-b816abfa4fcc@linux.ibm.com>
 <20261007-ibmvfc-fpin-support-v13-5-b816abfa4fcc@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 19:36:26 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: ibmvfc: wild pointer dereference in ibmvfc_handle_scrq() dur=
ing evt validation
--

commit 3a880d56c6f97510d8dc3b25b1c3b9b6711c3a6d
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: add NOOP command support

Add support for handling IBMVFC_NOOP format CRQ messages from the
VIOS partner. Advertise the client's ability to handle NOOP commands
by setting the IBMVFC_CAN_USE_NOOP_CMD capability in ibmvfc_set_login_info(=
).
Handle and ignore IBMVFC_NOOP format messages in both ibmvfc_handle_crq()
and ibmvfc_handle_scrq().

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index ac2571e9e1eb9..161d4679d7026 100644
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
Can this code dereference a wild pointer if the VIOS partner or hypervisor=
=20
sends an arbitrary, non-zero garbage token in crq->ioba?

At the top of ibmvfc_handle_scrq(), crq->ioba is cast to the evt pointer.
While this patch adds a check to prevent a NULL pointer dereference, if
crq->ioba is non-zero garbage, wouldn't evaluating evt->queue dereference
that untrusted pointer before ibmvfc_valid_event() has a chance to safely=20
validate it?

Looking at ibmvfc_handle_crq(), it avoids dereferencing the event entirely=
=20
during validation by checking against the host pool:

	if (unlikely(!ibmvfc_valid_event(&vhost->crq.evt_pool, evt))) {

Could we do something similar here by passing the valid scrq directly into=
=20
ibmvfc_handle_scrq() so it can safely use &scrq->evt_pool?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007-ibmvfc-fpi=
n-support-v13-0-b816abfa4fcc@linux.ibm.com?part=3D5
