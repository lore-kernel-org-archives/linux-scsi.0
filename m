Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59BD753CA92
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 15:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792077517; cv=none; b=I5yrehBmhZ/3YKYfdS5I5Zl7WsisU56WVR7Gmy7F9jnT7PVWVLB+1aAbCC01GDf6rksaFq5WnX1ohVZ2E2+LO2c7IhLycw4eU66z69AkN7JFWXlzOd1IEWfz/7eWDQm5Wvcj1e7GGQ7EaOr4R1ox9OWmGHeq6pVMa0u0lpxW/tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792077517; c=relaxed/simple;
	bh=UnBYyme45R+zUA/tE9foCguDTCsDsfu+MFWRgLn1eRo=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=e9LNkRwvaQwi/pDilSiIB5/dUrIqBaZzAB8YYWcoPpbp++uOJsZmzO1hNrL8NEjfWxCt3J3WVZkyblZfamePZNPB8lnKNumcSWd27235mSTjPsTzrbdKWPmcUfR4uiPaoimtQqZTnU0ayQSAfoZh9oVwjmr4fivkeHuOwUNZRJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GwiY/3ky; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GwiY/3ky"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B1EF1F000C4;
	Thu, 15 Oct 2026 15:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792077514;
	bh=FbW2mNqQn9DaV1YLb9MnpLWzLPTfNDX4vgm3G5rEVtU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GwiY/3kyIy5f329tzYIfdiwTTsu6tzkc60h8Aa3d4TQDeAqn6v1gOQ5f+0pWfKhJu
	 kUUiOErYBdV7cAJ0MU45QKLhkHki8JhH3DnYBx5DoqKchiq9OgR/vP2eIn/wWJ2ol/
	 S88rEzspgKcBC+83hpLQ6UKa3IwP9SyiL/QTc3RlG2YtjldMf7GA+xoW9b8QjhKfnI
	 FEBKa/C+8dUgxvr3YevpwRZ0F1X2SmuTctwSpKhkxzLoxN0QbCx5g2uJlC5Qat5VeV
	 kzvykuKqMsrG6xW6C/E/sl0gGrb14Q1qooGKnRTB1nCKIs0bBDlC2z0acd2kBdz63/
	 t+JmG62xI5yhA==
Message-ID: <sashiko-outbox-173047@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v14 04/11] scsi: ibmvfc: add basic FPIN support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261015-ibmvfc-fpin-support-v14-4-a0b063b8d825@linux.ibm.com>
References: <20261015-ibmvfc-fpin-support-v14-0-a0b063b8d825@linux.ibm.com>
 <20261015-ibmvfc-fpin-support-v14-4-a0b063b8d825@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 15:18:34 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: ibmvfc: missing flush of dynamically allocated system_wq ite=
ms causes UAF
--

commit 170496a5dbc89bab0a780529ef0e294023ca569c
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: add basic FPIN support

Implement support for a basic level of Fabric Performance Impact
Notifications (FPIN) in the ibmvfc driver to enable monitoring of
fabric congestion and link integrity events.

Add async event handler for IBMVFC_AE_FPIN events that offloads FPIN
processing via schedule_work(). Convert VIOS FPIN messages to standard
fc_els_fpin structures and pass them to fc_host_fpin_rcv() for processing
by the FC transport layer.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 0fe6b6f4260ba..871decab29856 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
[ ... ]
> @@ -3261,6 +3266,255 @@ static const char *ibmvfc_get_link_state(enum ibm=
vfc_ae_link_state state)
>  	return "";
>  }
> =20
[ ... ]
> +VISIBLE_IF_KUNIT void ibmvfc_process_async_work(struct work_struct *work)
> +{
> +	struct ibmvfc_async_work *aw;
> +	struct ibmvfc_async_crq *crq;
> +	struct ibmvfc_target *tgt;
> +	struct ibmvfc_host *vhost;
> +	struct fc_els_fpin *fpin;
> +	unsigned long flags;
> +
> +	aw =3D container_of_const(work, struct ibmvfc_async_work, async_work_s);
> +	vhost =3D aw->vhost;
> +	crq =3D &aw->crq;
[ ... ]
> +	fpin =3D ibmvfc_basic_fpin_to_desc(crq, tgt->wwpn);
> +	if (fpin) {
> +		fc_host_fpin_rcv(tgt->vhost->host,
> +				 sizeof(*fpin) + be32_to_cpu(fpin->desc_len),
> +				 (char *)fpin, 0);
> +		kfree(fpin);
> +	} else
> +		dev_err_ratelimited(vhost->dev, "FPIN event received, unable to proces=
s\n");
> +
> +	kref_put(&tgt->kref, ibmvfc_release_tgt);

[Severity: High]
Can this untracked async worker drop its reference and trigger the release
function on a destroyed mempool?

If ibmvfc_remove() has already completed and destroyed vhost->tgt_pool,
this final kref_put() triggers ibmvfc_release_tgt():

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_release_tgt() {
	...
	mempool_free(tgt, tgt->vhost->tgt_pool);
}

This accesses the destroyed target mempool, causing a Use-After-Free.

> + free:
> +	scsi_host_put(aw->vhost->host);
> +	kfree(aw);
> +}
> +EXPORT_SYMBOL_IF_KUNIT(ibmvfc_process_async_work);
> +
>  /**
>   * ibmvfc_handle_async - Handle an async event from the adapter
>   * @crq:	crq to process
[ ... ]
> @@ -3361,12 +3616,28 @@ static void ibmvfc_handle_async(struct ibmvfc_asy=
nc_crq *crq,
>  	case IBMVFC_AE_HALT:
>  		ibmvfc_link_down(vhost, IBMVFC_HALTED);
>  		break;
> +	case IBMVFC_AE_FPIN:
> +		if (vhost->state =3D=3D IBMVFC_HOST_OFFLINE)
> +			break;
> +		aw =3D kzalloc_obj(*aw, GFP_ATOMIC);
> +		if (aw) {
> +			if (!scsi_host_get(vhost->host)) {
> +				kfree(aw);
> +				break;
> +			}
> +			INIT_WORK(&aw->async_work_s, ibmvfc_process_async_work);
> +			aw->vhost =3D vhost;
> +			aw->crq =3D *crq;
> +			schedule_work(&aw->async_work_s);

[Severity: High]
Does this code risk a Use-After-Free during teardown?

Since aw is queued to the global system_wq without being tracked,
there doesn't seem to be a way to flush it in ibmvfc_remove().

If ibmvfc_remove() runs concurrently with this pending work item, it calls
ibmvfc_free_mem() which unconditionally destroys the target mempool:

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_free_mem() {
	...
	mempool_destroy(vhost->tgt_pool);
	...
}

This could lead to a crash when ibmvfc_process_async_work() completes and
drops its reference.

Additionally, because it is untracked on the global workqueue, it can execu=
te
after the module is unloaded, leading to a fatal instruction page fault.

> +		} else
> +			dev_err_ratelimited(vhost->dev,
> +					    "can't offload async CRQ to work queue\n");
> +		break;
>  	default:
>  		dev_err(vhost->dev, "Unknown async event received: %lld\n", crq->event=
);
>  		break;
>  	}
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015-ibmvfc-fpi=
n-support-v14-0-a0b063b8d825@linux.ibm.com?part=3D4
