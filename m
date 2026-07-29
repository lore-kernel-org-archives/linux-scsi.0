Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 413EA2DA749
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2026 15:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785339950; cv=none; b=ME3XWUHAgCCc4tDU5PNNJAW9Hs2sL8qd+MNCwl20cy7plmtQM1QpKWY/Qk46J5KlBC70rYB933GM8Yh0d9rNv3X6SLHETQ2a8Crbo59OpJpgPClWyCkJaeD0kJJeWV5PdIDUrpOJWfJETmMyMVQRu5UU/A4RYwuiQbmP/B9nXEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785339950; c=relaxed/simple;
	bh=9DHlYczCq3ChOivLv3xab9DoAfehUkiDVYdk5PcAIvk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=f/ey9dHcam8NSSfR8fPr/lz6YMu/TKE+LJuuUCMfn3nCWYVu9LYaE7QqkNDKsuTJ5yA42N7E29CK7upHBR446eFmH7kvb+pWLf41Q6MDDyPE21c5F3lSohqD1HxXIz4lRgVshL+wnFy4lzXef9NvPAkUIJmowixxd4tb24P/WL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cSGVWhk2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cSGVWhk2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F8B1F000E9;
	Wed, 29 Jul 2026 15:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785339948;
	bh=LPWRUbKnsVGljW6CqSguKfZJpa6CLp2exL2KGypjWoM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cSGVWhk2Mi5E7Itr13LY/+OzKT7NVtxCRSd1WkXPTEX5Ode1BZq3SyPIZJlFDGiK2
	 c7yKGEs1fSRx8Uk/jU5F1JwlIglPHGYiz3RocrTU/uC+rIeLNkjdgVdMreBpflspaz
	 ZlNu4q41lAIb1T62e0iSyB9q215Bx5wtAJ+Nit0Sl+yX2epwvsH2ln3ziG5PrX9BgK
	 2wetmDTFf8dZUFc6cHcU/R2plwRXNk6q5oY3rKkmiJfqId3J1NW1LerNISxea82utD
	 0ol4bkpNIa7KMk4qD6v0MduDE9glstUv5u14VuxUQ7CGtIUpiSr+omay4MtfqVyhp4
	 NYGsD04/Oo2LA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 5/5] scsi: lpfc: Replace strlcat() with sysfs_emit_at()
 in the sysfs show functions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ian Bridges" <icb@fastmail.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260729144617.1388646-6-icb@fastmail.org>
References: <20260729144617.1388646-1-icb@fastmail.org>
 <20260729144617.1388646-6-icb@fastmail.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 29 Jul 2026 15:45:48 +0000
Message-Id: <20260729154548.A3F8B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Use-after-free of `nrport` because it is dereferenced outside of i=
ts protecting lock.
--

--- Patch [5]: [PATCH 5/5] scsi: lpfc: Replace strlcat() with sysfs_emit_at=
() in the sysfs show functions ---
commit b85263748e0a979a8db2d3fc65264e450144763e
Author: Ian Bridges <icb@fastmail.org>
scsi: lpfc: Replace strlcat() with sysfs_emit_at() in the sysfs show functi=
ons

This commit replaces strlcat() with sysfs_emit_at() in several lpfc sysfs
show functions. It also removes the intermediate tmp buffers and per-fragme=
nt
overflow checks.

Link: https://github.com/KSPP/linux/issues/370 [1]

> diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
> --- a/drivers/scsi/lpfc/lpfc_attr.c
> +++ b/drivers/scsi/lpfc/lpfc_attr.c

[ ... ]

> @@ -702,77 +647,55 @@ lpfc_nvme_info_show(struct device *dev, struct devi=
ce_attribute *attr,
>  		}
> =20
>  		/* Tab in to show lport ownership. */
> -		if (strlcat(buf, "NVME RPORT       ", PAGE_SIZE) >=3D PAGE_SIZE)
> -			goto unlock_buf_done;
> -		if (phba->brd_no >=3D 10) {
> -			if (strlcat(buf, " ", PAGE_SIZE) >=3D PAGE_SIZE)
> -				goto unlock_buf_done;
> -		}
> +		len +=3D sysfs_emit_at(buf, len, "NVME RPORT       ");
> +		if (phba->brd_no >=3D 10)
> +			len +=3D sysfs_emit_at(buf, len, " ");
> =20
> -		scnprintf(tmp, sizeof(tmp), "WWPN x%llx ",
> -			  nrport->port_name);
> -		if (strlcat(buf, tmp, PAGE_SIZE) >=3D PAGE_SIZE)
> -			goto unlock_buf_done;
> +		len +=3D sysfs_emit_at(buf, len, "WWPN x%llx ",
> +				     nrport->port_name);

[Severity: High]
This is a pre-existing issue, but could this result in a use-after-free of =
the
nrport pointer?

Looking at lpfc_nvme_info_show() in drivers/scsi/lpfc/lpfc_attr.c, the nrpo=
rt
pointer is fetched from rport->remoteport under ndlp->lock. However, the lo=
ck
is released right before nrport is dereferenced to access fields like
port_state, port_name, node_name, and port_id.

If lpfc_nvme_unregister_port() runs concurrently (such as during a connecti=
on
reset or hot-unplug), it explicitly does not hold fc_nodes_list_lock when
retrieving rport->remoteport and calling nvme_fc_unregister_remoteport().

Does anything prevent the remote port from being unregistered and freed by =
the
NVMe FC transport while this sysfs file is being read, potentially leaving
nrport as a dangling pointer here?

> -		scnprintf(tmp, sizeof(tmp), "WWNN x%llx ",
> -			  nrport->node_name);
> -		if (strlcat(buf, tmp, PAGE_SIZE) >=3D PAGE_SIZE)
> -			goto unlock_buf_done;
> +		len +=3D sysfs_emit_at(buf, len, "WWNN x%llx ",
> +				     nrport->node_name);

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260729144617.1388=
646-1-icb@fastmail.org?part=3D5
