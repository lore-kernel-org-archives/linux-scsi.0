Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BDF433688B
	for <linux-scsi@vger.kernel.org>; Sat, 19 Sep 2026 01:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789782270; cv=none; b=HQ++xPSxyY7yyG8lPb8b+4lflmb001FvGR7Tox9jeR6PXlh1L6jxwKhsm1tmDp+WwwLlI/FrMFRKdajFZH7ZDmVQzfp7ctUTya+1GgSBF5z5fS8yC5Nq+eWpd0/iwzyzX+kMndNYhvQI2UE/4z/5TZQiCGDeTaXBhXlN2VjRZ+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789782270; c=relaxed/simple;
	bh=wR/QTW5DjiV85OfqgctE/uzP/cyb5y2aJvx5bWRl2T0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=MO6FqXlZZz3auBkhJwT+0oY5Avx9QGMCwwnYwvm/D5OQk14AqqgSoF33/M+sBxJ6sJVOuCH7krL8w0bpMk03JXHNr2x4/W4BOPslJM51y82wUhuQp87mj+aNwQWulVMt7QdHvHex6R7MCP/JAU2sS6h956gfkdLpvFAErRYRvKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=USPeyW0D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="USPeyW0D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E601F000FF;
	Sat, 19 Sep 2026 01:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789782268;
	bh=MeH2KZjyPSzKCin3Pb0OvB+Yk/JHVsBhoUNlrekhRu4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=USPeyW0Df6DtCAsa9lvJF6zk5NYVDbKoWB91KZxYGg4PeM0thlqxBeevZOXMkloo9
	 6T/BcecONKDLh1Y0RP+aMJtE14zBhoRFNyM1oPq6UJAEDpNJLWYzu3cum0iIp4xHqo
	 F9CaTU1zGhgAYF4I0XSJ8B115QV6d7yfXg0RHiEw8wMuPjAB1ZUVAEvDOLzJdgyZ96
	 Iax1Yk6EnxEY9i+tbdUz2Db5zbGZrklwqn60NdX+1RPBerAeka/+4nyY1lZobJFYkU
	 I3PhV1fwDlAvo7i78rDu4NkW39mPHM2iSwKJbfDNfHF9PL+VH56+hnohbOGaXH1X/j
	 RvSRbgOwlbYjQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 03/20] scsi: ibmvfc: complete NVMe FCP requests on
 H_CLOSED send failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260919013306.2948028-4-tyreld@linux.ibm.com>
References: <20260919013306.2948028-1-tyreld@linux.ibm.com>
 <20260919013306.2948028-4-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 19 Sep 2026 01:44:28 +0000
Message-Id: <20260919014428.A8E601F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] scsi: ibmvfc: misleading commit message contradicts safe impleme=
ntation
--

commit a9d59d0a40253b9e7dff6fac485fc0f17bf38172
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

scsi: ibmvfc: complete NVMe FCP requests on H_CLOSED send failure

This commit addresses a hang caused by silently dropped NVMe-FC requests=20
when ibmvfc_send_event() returns H_CLOSED. It changes the code to correctly
signal a retryable transport-level failure to the NVMe-FC transport.

>     Fix this by calling fcp_req->done() with a -EBUSY status before freei=
ng
>     the event in the H_CLOSED path, consistent with how other FC-NVMe LLD=
Ds
>     (e.g. lpfc) signal a retryable transport-level failure to the NVMe-FC
>     transport.

[ ... ]

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c b/drivers/scsi/ibmvscsi/=
ibmvfc-nvme.c
> index 9ed6522c2e9e3..08dd897b8e64e 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
> @@ -367,8 +367,12 @@ static int ibmvfc_nvme_fcp_io(struct nvme_fc_local_p=
ort *lport,
> =20
>  	vfc_cmd->correlation =3D cpu_to_be64((u64)evt);
> =20
> -	if (likely(!(rc =3D ibmvfc_nvme_map_sg_data(fcp_req, evt, vfc_cmd))))
> -		return ibmvfc_send_event(evt, vhost, 0);
> +	if (likely(!(rc =3D ibmvfc_nvme_map_sg_data(fcp_req, evt, vfc_cmd)))) {
> +		rc =3D ibmvfc_send_event(evt, vhost, 0);
> +		if (rc)
> +			return -EBUSY;

[Severity: Medium]
Does the commit message accurately describe the implementation here?

The commit message explicitly claims the fix is implemented by "calling
fcp_req->done() with a -EBUSY status before freeing the event". However,
the code safely returns -EBUSY directly to the NVMe-FC transport without
invoking the done() callback.

If the implementation actually matched the commit message, it would have
caused a double-completion bug by calling done() while also failing the
submission API. The code appears correct by returning -EBUSY, but the
commit message misrepresents the implemented transport interaction.

Could the commit message be updated to match the code?

> +		return 0;
> +	}
> =20
>  	ibmvfc_free_event(evt);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260919013306.2948=
028-1-tyreld@linux.ibm.com?part=3D3
