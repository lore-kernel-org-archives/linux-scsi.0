Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C975F34E744
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 19:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791402099; cv=none; b=miqAil/qQlS2uUmeprFglDv+Bsjh+K4z4tPaZV1JWOv3nO4B6IVoeKrMd4BTq5K84jUp9DW3E2lI1S4Y2VomAcFDllmXZp+9fHT3A344GR2tPYdEdfpHlrRCFOOgQd3yCix0AyDJHzAx+Aitg3SAkX8S+9s9hDw875nzWc5cbwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791402099; c=relaxed/simple;
	bh=R3Jv+iOsa6KhONmjp5uZ2xa1qYYxsD1Q4tNN9QfbDVo=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=dfob0u4eefac+RvlRngOXk63jYUVO4qJu/rYx3QeRnGdTP8pBjOBDmvqLatn/zBEwlbk7/ItL5imLtmRUCLlPLGsuV1j13LLhzWWhLbKo1RPj4OCbrvmp5D7aDlflCKb2s3G5478CpmNrfRKMLh5I7jkoznRZGqHpUITsx5dQ+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oMhbmeyK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oMhbmeyK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 230201F000FF;
	Wed,  7 Oct 2026 19:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791402095;
	bh=8NmvcPEcnw2/a+LTN4zgO+Kc03c29GGmtrxLf3YfmKY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oMhbmeyKwgkTUq0hWkKK4dSkL8KrVCFXT0tasCBHdVPkBNszSzswo1BaSQ6OoZn3R
	 OSmQe5Lo7AYbKkWdOJZ9JS7SQVyI91FiLDyFkDluwjGbwvBVqKRSTkVp16wogb/I/Q
	 x9nCsN2lLetOajBoPqjUketA7zzvZXDZalgbt7Vhf83cqWrGVLiOJgZ47RIJZRuSK/
	 /RNlPnBJT/qbDqnOmO6OlvwM3FTtMQb4GtP18spsBXElz///vcWUM8HJZahOQZcba6
	 1HXfSXusFDo82FHWS6YVdhRXvmvMjn1LUdxvSpJD8aQGRx20wmZivI7PrmD/twl5IT
	 nGg+NJ713gkRg==
Message-ID: <sashiko-outbox-163317@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 04/11] scsi: ibmvfc: add basic FPIN support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261007-ibmvfc-fpin-support-v13-4-b816abfa4fcc@linux.ibm.com>
References: <20261007-ibmvfc-fpin-support-v13-0-b816abfa4fcc@linux.ibm.com>
 <20261007-ibmvfc-fpin-support-v13-4-b816abfa4fcc@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 19:41:34 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: ibmvfc: NULL pointer dereference in queue_work on FPIN event=
 during remove
--

commit 03a2b80a223e0071e893709993671bdb91c0e958
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: add basic FPIN support

Implement support for a basic level of Fabric Performance Impact Notificati=
ons
(FPIN) in the ibmvfc driver to enable monitoring of fabric congestion and l=
ink
integrity events. This adds an async event handler for IBMVFC_AE_FPIN events
that offloads processing to a dedicated workqueue.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> @@ -3361,11 +3609,25 @@ static void ibmvfc_handle_async(struct ibmvfc_asy=
nc_crq *crq,
>  	case IBMVFC_AE_HALT:
>  		ibmvfc_link_down(vhost, IBMVFC_HALTED);
>  		break;
> +	case IBMVFC_AE_FPIN:
> +		if (vhost->state =3D=3D IBMVFC_HOST_OFFLINE)
> +			break;
> +		aw =3D kzalloc_obj(*aw, GFP_ATOMIC);
> +		if (aw) {
> +			INIT_WORK(&aw->async_work_s, ibmvfc_process_async_work);
> +			aw->vhost =3D vhost;
> +			aw->crq =3D *crq;
> +			queue_work(vhost->fpin_workq, &aw->async_work_s);

[Severity: High]
Does this code risk a NULL pointer dereference or use-after-free during dri=
ver
removal?

During ibmvfc_remove(), vhost->fpin_workq is destroyed and set to NULL befo=
re
the CRQ interrupts are disabled and the tasklet is killed (which occurs lat=
er
in ibmvfc_release_crq_queue()).

If a transport event (IBMVFC_CRQ_XPORT_EVENT) arrives concurrently,
ibmvfc_handle_crq() unconditionally overwrites vhost->state to IBMVFC_NO_CR=
Q.
This erases the IBMVFC_HOST_OFFLINE state set earlier by ibmvfc_remove().

If an IBMVFC_AE_FPIN event is subsequently processed by the still-active
tasklet, the vhost->state =3D=3D IBMVFC_HOST_OFFLINE safety check here in
ibmvfc_handle_async() fails to block it. This causes queue_work() to be
called with a NULL or already-destroyed fpin_workq pointer.

> +		} else
> +			dev_err_ratelimited(vhost->dev,
> +					    "can't offload async CRQ to work queue\n");
> +		break;
>  	default:

[ ... ]

> @@ -6958,6 +7229,8 @@ static void ibmvfc_remove(struct vio_dev *vdev)
>  	ibmvfc_wait_while_resetting(vhost);
>  	kthread_stop(vhost->work_thread);
>  	flush_work(&vhost->rport_add_work_q);
> +	destroy_workqueue(vhost->fpin_workq);
> +	vhost->fpin_workq =3D NULL;
>  	fc_remove_host(vhost->host);
>  	scsi_remove_host(vhost->host);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007-ibmvfc-fpi=
n-support-v13-0-b816abfa4fcc@linux.ibm.com?part=3D4
