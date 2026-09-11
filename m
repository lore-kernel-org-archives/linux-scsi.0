Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 325792EBDE9
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 02:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789094061; cv=none; b=imrR/2xOr2hEntrFxIEGahuj/9fC+Gie1BT53L0+aT95dPCAzpGG+vOSetz5rQ9dCkwPAezYTNKs4hzHI472QCCpmGBOREN8FTrLUH6oV+pQHPIeQYXnvyqNSLerZzePcAL1bVD3YLEd1REYxzWIQ8pkLeFQnkfiDbhzy69pdF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789094061; c=relaxed/simple;
	bh=bL2ZaUvU8WNkPQCs8Wz4rM6zZX99WRXMOhMQHJ9ZJU4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lAaDJU3CTLiA7Q/4cgkdLNQpfY9tTDGmwawOJsDaMxUY87JCNGL554xFDgxBKKsSg0fndnA0BYT2cpbUtrMVM/93/gdDTVNS6A9dFFzlDlcYIkB5Hea2nXu1W/NpwaTmdBKQCpK718S6jpPWHsw1+mR5LAdmoBaonzHBaknGN4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dGza4GLH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dGza4GLH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A464E1F000FF;
	Fri, 11 Sep 2026 02:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789094059;
	bh=wfO/HHMVv8nIcn31QO7XxUh9vpHKfxnCqzsdg4afzZg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dGza4GLHP8eP24U27eEtKRMJVDFs/ljSpk63IJyb6CiT3SzqDM5VVamihe585fxgK
	 FKNBaxBZno5fw2vEWaENb56lWT6KmbNu+J39+Upddmjx+1WFqgyCOwS0Nz28c29QmR
	 gTdLkjVH+r0PN0KGZuN773KJXZEBtPtGgZ3ehDN6FUJBPdxazzRBE9imT6FJyEvTrm
	 WwihJgpvDJjGYWQLZHS1TZGQVdTN6mR8+26xII5Nesrne+kDRdmhwGaYrWkrgyXwUx
	 Fn8P5nrvVKNpxGfv7P/SD9jcenLMoFuqvMgUB24SpGWyh9bmTb0LPBW+vDGjvaN0cD
	 AGbgGV9pWT2uA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 7/9] scsi: ibmvfc: fix IRQ leak and guard deregister
 on channel reg failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260911021910.1038128-8-tyreld@linux.ibm.com>
References: <20260911021910.1038128-1-tyreld@linux.ibm.com>
 <20260911021910.1038128-8-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 11 Sep 2026 02:34:19 +0000
Message-Id: <20260911023419.A464E1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Error code from request_irq failure is swallowed, causing initiali=
zation functions to falsely return success.
- [High] Unconditional execution of H_FREE_SUB_CRQ and failure to clear `sc=
rq->cookie` leads to hypervisor double-free and use-after-free of sub-CRQs.
--

commit 2c9e0fcaebe0c140397143556c20f5137db7357d
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: fix IRQ leak and guard deregister on channel reg failure

This commit fixes an IRQ leak where the error path leaves scrq->irq
populated, causing a subsequent deregister call to double-free the IRQ.
It explicitly sets scrq->irq to 0 on failure and guards the teardown
process against unregistered queues.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index fa312a58471fa..8eeb125ee13b8 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> @@ -6891,6 +6891,7 @@ static int ibmvfc_register_channel(struct ibmvfc_ho=
st *vhost,
>  		else
>  			dev_err(dev, "Couldn't register async sub-crq irq\n");
>  		irq_dispose_mapping(scrq->irq);
> +		scrq->irq =3D 0;
>  		goto irq_failed;
>  	}
> =20
> @@ -6933,9 +6934,11 @@ static void ibmvfc_deregister_channel(struct ibmvf=
c_host *vhost,
> =20
>  	ENTER;
> =20
> -	free_irq(scrq->irq, scrq);
> -	irq_dispose_mapping(scrq->irq);
> -	scrq->irq =3D 0;
> +	if (scrq->irq) {
> +		free_irq(scrq->irq, scrq);
> +		irq_dispose_mapping(scrq->irq);
> +		scrq->irq =3D 0;
> +	}
> =20
>  	do {
>  		rc =3D plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address,

[Severity: High]
This is a pre-existing issue, but by clearing the irq here, should we also =
be
clearing scrq->cookie?

If ibmvfc_reg_sub_crqs() fails, it triggers a rollback that calls
ibmvfc_deregister_channel(), which executes H_FREE_SUB_CRQ but leaves
scrq->cookie populated.

Since ibmvfc_dereg_sub_crqs() unconditionally loops over channels->max_queu=
es
and calls H_FREE_SUB_CRQ on everything during teardown, couldn't this lead =
to
passing stale cookies to the hypervisor?

If those cookies were reused for NVMe queues, would this destroy active que=
ues
and cause use-after-free corruption?

Similarly, in ibmvfc_register_channel(), if request_irq() fails, the error
path executes H_FREE_SUB_CRQ without clearing scrq->cookie:

irq_failed:
	do {
		hcall_rc =3D plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address, scrq-=
>cookie);
	} while (hcall_rc =3D=3D H_BUSY || H_IS_LONG_BUSY(hcall_rc));
reg_failed:


[Severity: High]
This is a pre-existing issue, but while reviewing the initialization code,
does ibmvfc_init_crq() swallow the error code from request_irq() failures?

In ibmvfc_init_crq(), retrc is set to 0 upon successful CRQ registration:

	retrc =3D 0;
	...
	if ((rc =3D request_irq(vdev->irq, ibmvfc_interrupt, 0, IBMVFC_NAME, vhost=
))) {
		dev_err(dev, "Couldn't register irq 0x%x. rc=3D%d\n", vdev->irq, rc);
		goto req_irq_failed;
	}
	...
req_irq_failed:
	tasklet_kill(&vhost->tasklet);
	do {
		rc =3D plpar_hcall_norets(H_FREE_CRQ, vdev->unit_address);
	} while (rc =3D=3D H_BUSY || H_IS_LONG_BUSY(rc));
reg_crq_failed:
	ibmvfc_free_queue(vhost, crq);
	return retrc;

Since retrc is already 0, the error path unconditionally returns success
instead of propagating rc.

Could this cause the probe function to consider the adapter successfully
initialized, even though it lacks a functional IRQ handler?

Would this lead to a silent hang during IO operations since no completion
interrupts will be processed?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260911021910.1038=
128-1-tyreld@linux.ibm.com?part=3D7
