Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CDF03BB69F
	for <linux-scsi@vger.kernel.org>; Mon, 17 Aug 2026 20:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786999315; cv=none; b=lJt5tycTW+enav494XazMrQtvaMsiAHX/zQAipSbjkb73XgAMhPf/lptLD3OmE8m+6ppSfAlLH2bWBVhAGXg0Frqr4W8ot27rN5+9+iHRYpN9H2XcMTrFlax+knAg7bExeaQp51o+IH9H9Z/YyDOLe0mKNFzBaZ/zQQro83ueHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786999315; c=relaxed/simple;
	bh=7qENksdK3cl5s7M/xZtN7HO3inpe1vlsOGG1KeG9kSk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WjIwPjrbBVwnJWQnINcPsFIJ1dG0yXxcMY056slXAv7eUFanDdbDyn3XuAB63wRlzQOspCGT+/RU9/pWr1RF+oYGzRIj8+JZwmfxVctO5H+xHXux0OdkQ72zyBu4bIfMD6cV0kfQjU6AD5yR7zPsXXdCu9MPep71AbxUMepLPks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ODwIZOig; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ODwIZOig"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC6251F00A3A;
	Mon, 17 Aug 2026 20:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786999314;
	bh=e9Yio3eblHfZD5W8giqNBeiGcfuTo2nAV++IISb3n/I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ODwIZOig6x6GkuOzU3MqNOzAJgENIOlfz7iseoV2aJqSB6ekeQ61DLZldpzmNFzH1
	 MCVEGAE92SII8HHVqFW32kwlQCPtfiQX0+m6yONTxDBw96ohJ30PEuFkcA8jyeNFrN
	 lyU1g+2MZ1Ebkh0aRzNKwsD0pxj+FY9NdEPe/6EZ9UOYrY5bVJtHEahEfZXQkttGfJ
	 Js76CX+X6bf3RaNOXXBh6qhIE4BrYFGnDH5vWcVg1rO0iNT1HYqJUSOXjYB74Ablhy
	 JdJckR83TEb/NSXqS4dDbYgBM/7HBXAiqaIOcy6c8v+pTxqjK+4Y8foUF6/QzqyBAq
	 diCO/oK+CzUPQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 2/8] scsi: ibmvfc: Add NOOP command support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260817-ibmvfc-fpin-support-v6-2-62a2d525e70d@linux.ibm.com>
References: <20260817-ibmvfc-fpin-support-v6-0-62a2d525e70d@linux.ibm.com>
 <20260817-ibmvfc-fpin-support-v6-2-62a2d525e70d@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 17 Aug 2026 20:41:53 +0000
Message-Id: <20260817204153.DC6251F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] The `IBMVFC_NOOP` macro is incorrectly checked against `crq->valid=
` instead of `crq->format` in `ibmvfc_handle_scrq`.
- [High] Teardown asymmetry and Use-After-Free of `vhost->fpin_workq` durin=
g module removal.

Pre-existing issues:
- [High] Untrusted pointer dereference of `evt->queue` before validation in=
 `ibmvfc_handle_scrq`.
--

--- Patch [2]: [PATCH v6 2/8] scsi: ibmvfc: Add NOOP command support ---
commit b1d87be5bed78116ccdb644bdfced27ffa4dfe26
Author: Dave Marquardt <davemarq@linux.ibm.com>
Subject: scsi: ibmvfc: Add NOOP command support

Add support for VFC_NOOP messages from VIOS to enable keep-alive
functionality between the client and server.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 22b4d639e74be..19a3f12615648 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c

[ ... ]

> @@ -4220,9 +4230,15 @@ static void ibmvfc_handle_scrq(struct ibmvfc_crq *=
crq, struct ibmvfc_host *vhost
>  	case IBMVFC_CRQ_CMD_RSP:
>  		break;
>  	case IBMVFC_CRQ_XPORT_EVENT:
> +	case IBMVFC_NOOP:

[Severity: High]
Does this code check IBMVFC_NOOP against the correct field?

The switch statement evaluates crq->valid, but IBMVFC_NOOP is a message
format (0x03).  Will the NOOP case be functionally dead here, causing NOOP
messages to fall through to the command response handling?

>  		return;
>  	default:
> -		dev_err(vhost->dev, "Got and invalid message type 0x%02x\n", crq->vali=
d);
> +		dev_err(vhost->dev, "Got an invalid message type 0x%02x\n", crq->valid=
);
> +		return;
> +	}
> +
> +	if (unlikely(!evt)) {
> +		dev_err(vhost->dev, "Received null event\n");

[Severity: High]
Does this error path get triggered erroneously for every NOOP sent by the
VIOS?

If a NOOP message falls through to the command response handling, ioba is
likely zero, which would cause evt to be null.  Will this spam the kernel
log with 'Received null event' at a high rate and potentially cause disk
exhaustion?

[Severity: High]
This is a pre-existing issue, but is it safe to dereference evt->queue
before validation?

Immediately after this null check, the code executes:

        if (unlikely(!ibmvfc_valid_event(&evt->queue->evt_pool, evt))) {

If a malformed or malicious ioba payload is sent by the VIOS, couldn't this
cause an immediate out-of-bounds read or kernel panic when evt->queue is
dereferenced?  Should the queue pointer be securely passed down from
ibmvfc_drain_sub_crq() instead?

>  		return;
>  	}

[Severity: High]
Could the destruction of vhost->fpin_workq during module removal cause a
use-after-free?

In ibmvfc_remove():

        destroy_workqueue(vhost->fpin_workq);
        vhost->fpin_workq =3D NULL;

If hardware interrupts and tasklets are not disabled until
ibmvfc_release_crq_queue() is called later, an IBMVFC_AE_FPIN event could
trigger the interrupt handler and schedule the tasklet.

Would this result in ibmvfc_handle_async() executing:

        queue_work(vhost->fpin_workq, &aw->async_work_s);

on the explicitly destroyed and NULL-ed workqueue?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260817-ibmvfc-fpi=
n-support-v6-0-62a2d525e70d@linux.ibm.com?part=3D2
