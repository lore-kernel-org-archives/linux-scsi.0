Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105D1377550
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2026 01:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782179559; cv=none; b=qHsTkz0X7GGMkaERcM8+lJxDOdY96nB5ZR/O0koHOoey+mI7fYwwAkSaZs2Qa6jMkLabg9If0pLnL1x26mmGyJa1Np8I0GC3HPSdbdVVtKpUGK9TRMhlLHhmAQ5fFUce+uIEV4FlZZeyJ/br4aYffgTknjP2ylnzfqHubqNDHRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782179559; c=relaxed/simple;
	bh=ZT3y9yI6VGuRPKSXCNUnBO/IeCUr+BgOQy6unmz5D64=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cPIx7U3KieoQ90v3ju/5z9BKv9I385A4QLQzmv9QWRs+odpDVOAC5XWon0Pw8eAHnNUcZd03ZiszwiDmax0Y5C0s1AepeHULXlHE32arKkYCjpcssWav7g2uJJquFoGk+oOMCvhdIaVRYIeQM4lIVn9pyT4y5DbZc8+l1VnZ20o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MPuUtGeA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MPuUtGeA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C58531F000E9;
	Tue, 23 Jun 2026 01:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782179558;
	bh=cUxNf/X5El3Y679HgFUOJxSLnpX0VevRKmBOb/7CUSc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MPuUtGeAPBZdUSiz+xeCHitfmeRLyJTGT4zCf1BjmUfETA27sLIdCb3Eq5CjZAwbx
	 VoWiixpcx9ZseUssuOw09IOr0pgcC6s2eOcjLSZs08VBRifXEZ5nL6OuCUlR42tF2J
	 VdOWgAl+4Q5eY+AsHwz5qKlMBQou3FPDUYEgERZv8d2uTOx1ejD5StMkt3Hndpcxxk
	 RldVY+Z3KriMLiRODYRKsOoEjD2qh3kqrwA76aUaiCcnQ5SuvKBE2FwIkLAZnxuKaU
	 S8GaNTlPMkJCR4dLOmjVj5tFAiw78oXdKrspkxmBTx8r3yP2NKVZkIQlTZ0MB83at+
	 DG3tZyjBACXrw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 15/29] ibmvfc: add NVMe/FC Query Target support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260623013035.3436640-16-tyreld@linux.ibm.com>
References: <20260623013035.3436640-1-tyreld@linux.ibm.com>
 <20260623013035.3436640-16-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 01:52:37 +0000
Message-Id: <20260623015237.C58531F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Low] The global array `proto_type` is missing the `static` keyword, caus=
ing namespace pollution.

Pre-existing issues:
- [High] Memory allocated from a mempool is freed directly via kfree(), per=
manently depleting the mempool reserve under memory pressure.
--

commit edf90dca8246218c80f44b69406be60422857d3c
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

ibmvfc: add NVMe/FC Query Target support

Add protocol-specific query-target support for NVMe/FC targets. It uses the
NVMe query-target specific MAD when querying an NVMe target and updates the
associated debug and error logging to include the target protocol.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index b45cd0183fb51..363bf75d62443 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> @@ -4849,7 +4849,7 @@ static void ibmvfc_tgt_query_target_done(struct ibm=
vfc_event *evt)
>  	ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_NONE);
>  	switch (status) {
>  	case IBMVFC_MAD_SUCCESS:
> -		tgt_dbg(tgt, "Query Target succeeded\n");
> +		tgt_dbg(tgt, "%s Query Target succeeded\n", proto_type[tgt->protocol]);

[Severity: Low]
Does proto_type need the static keyword? Since it is a generic identifier
defined at file scope without being in a header:

drivers/scsi/ibmvscsi/ibmvfc-core.c:
const char *proto_type[] =3D {
	"SCSI",
	"NVMe",
};

Could this cause symbol collisions in the global kernel namespace during
linking?

>  		if (be64_to_cpu(rsp->scsi_id) !=3D tgt->scsi_id)
>  			ibmvfc_del_tgt(tgt);
>  		else

[ ... ]

> @@ -4913,7 +4913,10 @@ static void ibmvfc_tgt_query_target(struct ibmvfc_=
target *tgt)
>  	query_tgt =3D &evt->iu.query_tgt;
>  	memset(query_tgt, 0, sizeof(*query_tgt));
>  	query_tgt->common.version =3D cpu_to_be32(1);
> -	query_tgt->common.opcode =3D cpu_to_be32(IBMVFC_QUERY_TARGET);
> +	if (tgt->protocol =3D=3D IBMVFC_PROTO_SCSI)
> +		query_tgt->common.opcode =3D cpu_to_be32(IBMVFC_QUERY_TARGET);
> +	else
> +		query_tgt->common.opcode =3D cpu_to_be32(IBMVFC_NVMF_QUERY_TARGET);
>  	query_tgt->common.length =3D cpu_to_be16(sizeof(*query_tgt));
>  	query_tgt->wwpn =3D cpu_to_be64(tgt->ids.port_name);
> =20
> @@ -4923,7 +4926,7 @@ static void ibmvfc_tgt_query_target(struct ibmvfc_t=
arget *tgt)
>  		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_NONE);
>  		kref_put(&tgt->kref, ibmvfc_release_tgt);

[Severity: High]
This is a pre-existing issue, but does ibmvfc_release_tgt() incorrectly free
the target?

The target is originally allocated using mempool_alloc():

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_alloc_target() {
    ...
	tgt =3D mempool_alloc(vhost->tgt_pool, GFP_NOIO);
    ...
}

However, it is freed directly via kfree() instead of mempool_free():

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_release_tgt() {
	struct ibmvfc_target *tgt =3D container_of(kref, struct ibmvfc_target, kre=
f);
	kfree(tgt);
}

Under memory pressure, mempool_alloc() falls back to its preallocated
reserve. Will bypassing mempool_free() permanently leak the reserved
elements, eventually causing deadlocks when the pool is depleted and
mempool_alloc() blocks waiting for elements to be returned?

>  	} else
> -		tgt_dbg(tgt, "Sent Query Target\n");
> +		tgt_dbg(tgt, "Sent %s Query Target\n", proto_type[tgt->protocol]);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623013035.3436=
640-1-tyreld@linux.ibm.com?part=3D15
