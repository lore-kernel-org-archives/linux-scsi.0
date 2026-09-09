Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 031093B8948
	for <linux-scsi@vger.kernel.org>; Wed,  9 Sep 2026 19:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788981580; cv=none; b=eumq8SKcwrqdP/1aQnku/3tlC8y68E4vT/2Mtt1Cn5ky8magVdAMIRg/5/6WH8QodSnI4k6gDZotAs3kGtYVh2QMqDPAYfgYMNq6J1N0J9onJ36WEfDpDXcbXpQG4pPnGK4OUmXE6yEMc3ncFmP5ZHs7OicVgVg49VRO9q7j2j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788981580; c=relaxed/simple;
	bh=qF9uTcRx0u2W8zEa24jUafLrLZgy1JpbfpQRWeuSang=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=rjcsDoZKfCLZHvoHKPLCEZpEAv5fRFPKB/adSXZIq3XvPmUG7CKlsXk3mOPZm6wP/SbpUNzk3UYwFFvphRYcC84GKaYi39+TruwGDvM62JupigGc1LSH8HikTbMToJ8jnRaXuvoOJ2kDZdOS1s0l5a/zX+uq7Zj/V9gwev7GYtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P4GHqp4e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P4GHqp4e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EA041F000FF;
	Wed,  9 Sep 2026 19:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788981578;
	bh=snpanDmFnRfRp9EFAsCOEDBBAQ6oxH9OjVMc7jXBwRE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=P4GHqp4eKiPqyxdtm7Wv0FK5TKyk2VnZwmdri5piaBQs1KOjLOGfBZPdoizIfQ1cZ
	 0ToolBWe6xliK1hpjFyrvd4bT8eJWhcJvghixfmHLbCqVFjAriznbpF4zmPEiJiHJd
	 8Kz7r5CJVCNRSGpl0S55ohsEQUmdZxuK1MuswLajWeVofIslYJDwLUQ+QtINTef3m7
	 LPH/LiVqP2n2h5N7TeIqfY4Zclzyz7JeiW9e1GJmkF4xfbJry9l+IR8AxamHxg0g/L
	 CN4XIClSUaVulXBLlH3fq83Qk0M0k4ldBCeBfcIeglYiDm55+jcCmFLKVSBvBaUr6a
	 rxE2JA4ALs0kg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 2/9] scsi: ibmvfc: add NOOP command support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260909-ibmvfc-fpin-support-v8-2-b27183b055af@linux.ibm.com>
References: <20260909-ibmvfc-fpin-support-v8-0-b27183b055af@linux.ibm.com>
 <20260909-ibmvfc-fpin-support-v8-2-b27183b055af@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 19:19:37 +0000
Message-Id: <20260909191938.5EA041F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Dereferencing an unvalidated, untrusted pointer `evt` before it is=
 validated in `ibmvfc_handle_scrq` can cause a kernel panic if the hardware=
/VIOS provides an invalid (but non-null) correlation token.
--

commit a3402903e48bf8efffefe3982091a3c0b9147837
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: add NOOP command support

Add support for handling IBMVFC_NOOP format CRQ messages from the VIOS
partner. Advertise the client's ability to handle NOOP commands and ignore
IBMVFC_NOOP format messages in both ibmvfc_handle_crq() and
ibmvfc_handle_scrq(). Also fix a typo and add guards against null event
pointers before processing CRQ responses.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 0dde8dcf43de3..c985eb3400a7c 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
[ ... ]
> @@ -4223,7 +4233,20 @@ static void ibmvfc_handle_scrq(struct ibmvfc_crq *=
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

[Severity: High]
This isn't a bug introduced by this patch, but could dereferencing an
unvalidated, untrusted pointer evt before it is validated in
ibmvfc_handle_scrq() cause a kernel panic if the hardware/VIOS provides an
invalid (but non-null) correlation token?

The explicit validation check demonstrates the driver anticipates and guards
against corrupted or invalid tokens, however evt is accessed before it is
validated immediately following the new check for a null event:

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_handle_scrq() {
    if (unlikely(!evt)) {
        dev_err(vhost->dev, "Received null event\n");
        return;
    }

    /* The only kind of payload CRQs we should get are responses to
     * things we send. Make sure this response is to something we
     * actually sent
     */
    if (unlikely(!ibmvfc_valid_event(&evt->queue->evt_pool, evt))) {
        dev_err(vhost->dev, "Returned correlation_token 0x%08llx is invalid=
!\n",
                crq->ioba);
        return;
    }
}

The validation call ibmvfc_valid_event() dereferences evt->queue to find the
pool, which will crash if evt is a garbage pointer, entirely bypassing the
safety mechanism.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909-ibmvfc-fpi=
n-support-v8-0-b27183b055af@linux.ibm.com?part=3D2
