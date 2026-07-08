Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D2A24E4C6
	for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2026 19:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783540092; cv=none; b=d1soYsH933rjXA2lFWfvhroYQC4tpZpX8rBF9wl/rNeTdURIt7BP1eXj2EWVnkwWqTDvCbym2sBRGdGGREkL1oH8hedszoYPFx0gkAIU70LoynAJ76ROHeFzVI1yInjG2zhwv7Wrjq/zT3MlI8R0vEg3TxXIt49Ak1QqWABGKR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783540092; c=relaxed/simple;
	bh=I3heJWB3AYu8Q6tc1bhgPYQFFQo6r/NbHAjONraas5I=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=sHqbcvg/6ZUf+VzN82065uCwho591aFLPrOPW7JdRnc7Aa+8UiV8QMntIOXz0W13iEIFVeNc1ag9hAJ/0rLmPvEWK/j2mNXrdQs49vxVW07ZaQb5PGppQekMClSt6GOAIgnnsqbydaneDITkMtEpLwHDKYC2g+EMsPxS6EZ9hpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X32dnom/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X32dnom/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D1C71F000E9;
	Wed,  8 Jul 2026 19:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783540090;
	bh=ZB9MwXowpFbGyiWyLPyVB53pAH3Uvic7Fapt/VlDpKk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=X32dnom/1FjpXa69d3ViurH6/u7ysYsde5OAUPWY8CQ7Uv3WhY+7POo2Z0wD5SKg5
	 qaEW/Q+aNN0cSuVuJAIz7TbHDcRV+J3aY75XdK7U+ZxOoinrSosB/fJAwhyE3JEirb
	 3Yj5G3U/z/VoDZWDtK4Gl3L1SZjX0iMq9HmVmqwBFUhb2XBk5OcRqD6pE7MMZuPVec
	 /PQMjR1xlGASgM3qmNY7GzWpI3UMXeEEDCkYzYXK0mDMEemuYFX3Ooha6koBplb30w
	 byiZHm5lHjseADK6gI4uUwt7F+HO6Y3YAKw/cusD14xzr/n1v6eOd9HtNimstqtJI4
	 hP6q+kmjbPLCw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 06/10] mpi3mr: Fix memory leak on operational queue
 creation failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ranjan Kumar" <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260708183305.244485-7-ranjan.kumar@broadcom.com>
References: <20260708183305.244485-1-ranjan.kumar@broadcom.com>
 <20260708183305.244485-7-ranjan.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 08 Jul 2026 19:48:09 +0000
Message-Id: <20260708194810.6D1C71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] The patch introduces a newly triggerable NULL pointer dereference =
if a spurious interrupt fires on an IRQ vector associated with a queue that=
 was downgraded or freed.

Pre-existing issues:
- [High] The `out_failed` error path leaves dangling pointers in `mrioc->in=
tr_info[*].op_reply_q`, leading to a Use-After-Free in the interrupt handle=
r.
--

--- Patch [6]: [PATCH v2 06/10] mpi3mr: Fix memory leak on operational queu=
e creation failure ---
commit 442fad52bcdebc4eb17a6ed94630805034267b41
Author: Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: mpi3mr: Fix memory leak on operational queue creation failure

This commit fixes a memory leak where partially allocated DMA memory segmen=
ts
were not freed if operational queue creation failed. It also hardens the
error handling path by checking for NULL pointers before freeing segments
and resetting operational queue counts to prevent deferred panics.

Closes: https://sashiko.dev/#/patchset/20260626114109.43685-1-ranjan.kumar@=
broadcom.com?part=3D6

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr=
_fw.c
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
[ ... ]
> @@ -2533,6 +2533,13 @@ static int mpi3mr_create_op_queues(struct mpi3mr_i=
oc *mrioc)
>  		}
>  	}
> =20
> +	if (i < num_queues) {
> +		for (j =3D i; j < num_queues; j++) {
> +			mpi3mr_free_op_req_q_segments(mrioc, j);
> +			mpi3mr_free_op_reply_q_segments(mrioc, j);
> +		}
> +	}
> +

[Severity: High]
Does this introduce a NULL pointer dereference if a spurious interrupt fires
on an IRQ vector associated with a downgraded queue?

If operational queue creation partially fails during a controller reset
(e.g., i < num_queues), this loop explicitly sets=20
op_reply_qinfo[j].q_segments =3D NULL via mpi3mr_free_op_reply_q_segments()=
.=20
Since i > 0, the function succeeds and the controller downgrades to fewer=20
queues.

However, the driver appears to leave mrioc->intr_info[j].op_reply_q pointin=
g=20
to these unreached queues. If a spurious interrupt triggers on one of the=20
unreached vectors, the handler would do this:

mpi3mr_isr_primary() {
    if (intr_info->op_reply_q)
        mpi3mr_process_op_reply_q(mrioc, intr_info->op_reply_q)
}

And inside mpi3mr_process_op_reply_q():

mpi3mr_process_op_reply_q() {
    struct segments *segments =3D op_reply_q->q_segments;
    ...
    reply_desc =3D (struct mpi3_default_reply_descriptor *)segments[segment=
_ix].segment + ...
}

Could this unconditionally dereference the newly nullified q_segments array?

>  	if (i =3D=3D 0) {
>  		/* Not even one queue is created successfully*/
>  		retval =3D -1;
[ ... ]
>  out_failed:
> -	kfree(mrioc->req_qinfo);
> -	mrioc->req_qinfo =3D NULL;
> -
> +	if (mrioc->req_qinfo) {
> +		for (j =3D 0; j < i; j++) {
> +			mpi3mr_free_op_req_q_segments(mrioc, j);
> +			mpi3mr_free_op_reply_q_segments(mrioc, j);
> +		}
> +		kfree(mrioc->req_qinfo);
> +		mrioc->req_qinfo =3D NULL;
> +	}
> +	mrioc->num_op_req_q =3D 0;
>  	kfree(mrioc->op_reply_qinfo);
>  	mrioc->op_reply_qinfo =3D NULL;
> +	mrioc->num_op_reply_q =3D 0;
> =20
>  	return retval;
>  }

[Severity: High]
This is a pre-existing issue, but does this error path leave dangling point=
ers
that could cause a Use-After-Free?

If mpi3mr_create_op_queues completely fails during a controller reset=20
(e.g., i =3D=3D 0), the code jumps here and frees the mrioc->op_reply_qinfo=
 array.

However, it seems to leave pointers to this array intact inside=20
mrioc->intr_info[*].op_reply_q. Because these pointers were preserved from=
=20
the initial driver load, and interrupts are re-enabled earlier in the reset=
=20
sequence, any hardware or spurious interrupt could trigger the primary hand=
ler:

mpi3mr_isr_primary() {
    if (intr_info->op_reply_q)
        num_op_reply =3D mpi3mr_process_op_reply_q(mrioc, intr_info->op_rep=
ly_q);
}

Could this dereference the freed op_reply_qinfo memory? Should the referenc=
es
in intr_info be cleared when this array is freed?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260708183305.2444=
85-1-ranjan.kumar@broadcom.com?part=3D6
