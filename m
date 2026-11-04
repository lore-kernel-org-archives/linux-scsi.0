Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793776241;
	b=Yw1RIRrTC4LmBxAH4e7Jc5kegilq/mo1Thx8qoVFY9q/wkHV7+i1M1uMTxwcfwAkROw0
	 1P0xsfhW55s6xx69ymQ5BF8cmNLBPpuLPNNADN/MJqvWNh5NTYftg7QLuk7YrMp8xH4g8
	 OjpNAjFJFsYywvimgN7hSWmA6jH+P5ErulVY4YrtT1NeO66Bf5SlJKXrBnLAGVUn0Lnnw
	 86YVS5aiEDmT6yJq1wCmxqOyvLm1q0iP3RlnwR3/cLGH8c0DrVwLxBmRYhCv/GZyV23N2
	 aGuf9u2W3jj7TfSFdz78Icvv/Vp3p7gmWZZtvc6dtiJxeRIpoYKsTVUDSz+sbqOS8vA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793776241;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=wCIXzG8hEUoU6+HavHSBkbQkCt3sTY8kJOQ+/aju710=;
	b=ELt4p06FwRFLrwXcvSqtHXseVe4CCLUyDUPjr6TxgBbF5bntCt3WERbk+i0dK0b1mwuA
	 YgZq3DH5WmXLFh8AcH5XuYQdqoaahHqbXoB9DS5LIL9l0h2ik7zTwbFbuIIcGtYz8uE9h
	 wrByDA++WlnJenjvIYBYl7nPCntIvNHVpkZbwJ/XCxSqlfFHZPNIIfre/YDbmRDJPLJE0
	 RBJm6rCkf6Bo2MLIRRgHTihi4aIXzUTZrC43Y9g/+xAfITzOaqYP55J7Xx8ucWxUoFJ2C
	 vNk21UJxBtHCs4VzSmYXV1F/jIcVMjQYOE9aeOTsjJ+7HRYF+kH6o7Jz+vnjkmkFeFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C4k3GAoJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42275606A328
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 07:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C4k3GAoJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80CB71F00919;
	Wed,  4 Nov 2026 07:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793776240;
	bh=wCIXzG8hEUoU6+HavHSBkbQkCt3sTY8kJOQ+/aju710=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=C4k3GAoJ5T8m13wGVCGGSYZdBHL9stdU7ZcuysJKzkKbjmo5aIJwtZ8etozTsFC95
	 dFLtj/wypwG+PuO3lkZrdqdt1HdKetUU+vlFSfLjyHpvua02GaxhntdKIg7Q0fF12R
	 mNCAhYpXAaQH4sjui7jT58025jmS/oZFh7fEJA+GNYLFphooj1XlKNqGGsw3a1Y/XY
	 sk/xTHcvwz1tsj0LuJZDmQREo1KnKfcOYk9gMMuRqasHlJMIohnSgJ7Yo4+9dcpOjM
	 EfHGQPE27MiaKBqc1LWUxZDvGGEBJWgC83u3NUNGJauIoFc4JViAV88UZ5DsiueWL8
	 qu2rFzLeuT9Ow==
Date: Wed, 4 Nov 2026 08:10:37 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: Paul Ely <paul.ely@broadcom.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH] scsi: lpfc: fix ndlp use-after-free in RLS accept
 callback
Message-ID: <20261104-incredible-lynx-of-progress-748bb1@quoll>
References: <20261104025348.1527601-1-vulab@iscas.ac.cn>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261104025348.1527601-1-vulab@iscas.ac.cn>


On Wed, 04 Nov 2026 02:53:48 +0000, Wentao Liang wrote:
> lpfc_els_rcv_rls() takes a reference on the ndlp for the pending
> MBX_READ_LNK_STAT command.  lpfc_els_rsp_rls_acc() drops that
> reference right after building the ACC IOCB, but then keeps
> dereferencing ndlp in the trace message and takes a fresh reference
> for the IOCB.
> 
> The node can be removed from the nodelist while the mailbox is
> pending, so the put may be the last one and release ndlp through
> lpfc_nlp_release().  The later ndlp->vport, ndlp->nlp_DID and
> lpfc_nlp_get() calls then touch freed memory.
> 
> Move the put after the reference for the IOCB has been acquired, and
> release it on the paths that bail out before that point.
> 
> Fixes: 12265f68ae92 ("[SCSI] lpfc 8.3.18: Add support of received ELS commands")
> Cc: stable@vger.kernel.org
> Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>  drivers/scsi/lpfc/lpfc_els.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 

Multiple things here:
1. Your team ignored completely previous feedback. Multiple times.

2. You use multiple identities with this email address, thus I doubt that we
   speak with an actual person.

3. Your bot does not even bother running checkpatch, right?

4. Nothing of this was reproduced nor tested.

5. Finally, the same feedback:
You sent multiple independent patches, to multiple independent
subsystems. The amount of these patches clearly suggest this was
AI generated and most likely not tested.

More importantly, you sent all this work without properly organizing
relevant patches into patchsets. This makes reviewing difficult
and might cause multiple reviewers to address the same issue.
Replying to the entire set is impossible and requires handling each
patch independently, instead of applying or discarding the set.
Maintainers also won't see the bigger picture of your work. Quite
worrying.

This is on the verge of hostile patch: bomb us with so many
contributions, we won't be able to handle them in efficient manner,
like responding ONCE to ask you to slow down.  Considering all this
is untested and LLM generated, I have even more doubts whether this
should be considered for review.

Please read kernel documentation BEFORE posting more work. It will
explain you how to identify subsystems, how to organize your work per
subsystem (so a patchset grouping multiple patches with a short cover
letter), how to document the issue discovery method and what was
or was not tested.

Best regards,
Krzysztof




