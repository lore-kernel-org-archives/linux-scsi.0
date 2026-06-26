Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7661A28725B
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2026 12:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782475348; cv=none; b=D3ACVzPiLC5NKMNqSrf9COSdn2WZeQL9MKCt4FKyhDYF/7QWIcJJclNDoYu6SInor0+mkT7T8AOyNoo2hBOtNQ8oaEL/CvhPdKrZfZYFDV5dbnyx42IVxOD8lEQKYQXDXvWzQubfvg5m4+BgyJsFcerhQzXmG5Jn8ruVot/Ordk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782475348; c=relaxed/simple;
	bh=104P5lB0u4KpUUHwtRwchlGbC8VeJD7xLWpSoZ979UY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=RCgPsRpkzitTyncDBD2t2GwVkbLaBah1wyoGzPUOdg693e4wFS2AD69hwdXsbYkAsyZcjh5OUTaY9CU7ar02NUThhe0o6cjeQhuPIApUj47Z9NRsaVvMgqrnMD5dnBf96NGwPTOGdBLoScHbUBN1m/9IMA63h3PKKsQmoU1w/g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kYhemm8v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kYhemm8v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC0BD1F000E9;
	Fri, 26 Jun 2026 12:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782475347;
	bh=puNPgm58wtgTdJjAzzz/cXy9X00q6PUMNqeIovHBqHo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kYhemm8vr9A+vDEsr6eKRvcHAjWKKKHgyxdWfH2NF19iSItwlrlzhcJ/+sEiXMK9k
	 ELChl60civ220hYXotJgx9LYck/+VCL7N2/wbOOSoyLCxQ3gg/Fokpd9p+ssRWbW9o
	 XWIL4z0ScoxCVdmDl8tT8J+NLVC7LwAY2EATMJsaXP7SfqKS38X1t1LaOeuH4aea17
	 BvDeysUpF6lFg0JNPfJc13LUAkW6AmypfetEUU6jDY/lWuoAYH67KyTDXXgcwZSj4o
	 m7PIPqU0rfaETRFnaxyhd88NW1obcIIgGcDxUx3HitcpEXSyARkn47J0DFXRqbRtek
	 hheirJJnPImRA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 06/10] mpi3mr: Fix memory leak on operational queue
 creation failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ranjan Kumar" <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260626114109.43685-7-ranjan.kumar@broadcom.com>
References: <20260626114109.43685-1-ranjan.kumar@broadcom.com>
 <20260626114109.43685-7-ranjan.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 26 Jun 2026 12:02:25 +0000
Message-Id: <20260626120226.DC0BD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] The newly added cleanup loop unconditionally dereferences `req_qin=
fo` and `op_reply_qinfo`, causing a kernel panic if their initial allocatio=
ns fail.

Pre-existing issues:
- [High] Failure during reset leaves `num_op_req_q` non-zero but `req_qinfo=
` NULL, leading to a deferred kernel panic during driver cleanup.
- [High] The memory leak is not fully fixed: if a queue fails to create but=
 the controller remains in a ready state, the partially allocated segments =
are leaked.
--

commit 9ead875c2a5e252d14e44cff611d464fadb0d332
Author: Ranjan Kumar <ranjan.kumar@broadcom.com>

mpi3mr: Fix memory leak on operational queue creation failure

This commit modifies the error handling path in mpi3mr_create_op_queues()=20
to iterate over the number of queues and release the DMA memory segments=20
before freeing the main queue information arrays.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr=
_fw.c
> index 32aeae20481ec..88444f04fb6a6 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -2529,6 +2529,10 @@ static int mpi3mr_create_op_queues(struct mpi3mr_i=
oc *mrioc)
> =20
>  	return retval;

[Severity: High]
This isn't a bug introduced by this patch, but does this function still leak
memory if a queue fails to create and the controller remains ready?

If queue creation fails inside the allocation loop:

mpi3mr_create_op_queues() {
        ...
        for (i =3D 0; i < num_queues; i++) {
                if (mpi3mr_create_op_reply_q(mrioc, i)) {
                        break;
                }
        ...
}

The loop breaks, but if the controller state is still MRIOC_STATE_READY,
the function skips out_failed entirely, updates mrioc->num_op_req_q =3D i,
and returns 0. The segments allocated for the failed queue at index i
are abandoned and never cleaned up.

>  out_failed:
> +	for (i =3D 0; i < num_queues; i++) {
> +		mpi3mr_free_op_req_q_segments(mrioc, i);
> +		mpi3mr_free_op_reply_q_segments(mrioc, i);
> +	}

[Severity: High]
Will this cause a null pointer dereference if the initial queue information
allocation fails?

If kzalloc() fails to allocate mrioc->req_qinfo or mrioc->op_reply_qinfo
at the start of the function, execution jumps directly to out_failed.
This loop will then execute and call mpi3mr_free_op_req_q_segments(),
which blindly dereferences the unallocated array:

mpi3mr_free_op_req_q_segments() {
        ...
        segments =3D mrioc->req_qinfo[q_idx].q_segments;
        ...
}

>  	kfree(mrioc->req_qinfo);
>  	mrioc->req_qinfo =3D NULL;

[Severity: High]
This is a pre-existing issue, but does freeing the array here lead to a
deferred crash if a controller reset fails?

If mpi3mr_create_op_queues() fails during a reset, mrioc->req_qinfo is
freed and set to null here, but mrioc->num_op_req_q retains its non-zero
value from before the reset.

Later, when the driver cleans up, mpi3mr_free_mem() loops up to the stale
num_op_req_q count and calls mpi3mr_free_op_req_q_segments(), which will
dereference the null req_qinfo array.

>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260626114109.4368=
5-1-ranjan.kumar@broadcom.com?part=3D6
