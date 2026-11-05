Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793894536;
	b=eWqtXJ28VLYt30O/c4EoXUwRbjxcw3VK9DnyWyX7G0UlgkidbmBpYNDvvaq7W4u4sHxi
	 6L2iGm1ph5pUdn1dfQUCyanuiODOHd1Z8PvQ0mH56gbwb8Z1FI2hfvLFkZdZl29XrWbRu
	 GskWr1CwrXYnEANy+7qeQp06U/stLqziN4dcY3xhq1YN84NenbgBy9+ULvch//38BzhLa
	 mw0vl+8bJykwTGOjOJ74VGJhTRKzC2MwOM47H4O+bQEqVJLZnI7HbddbADrJHyj+zTOOT
	 LAB1AdS8j52Z4RbFSqbOOdhDdZswC9zg9lPySop14J7LUGziyHkHH3ZgQuT1cenYH5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793894536;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=aqCzNdwdFXbkiMBNueOzUtHr/O5k6VyeO9VmVzV7WAE=;
	b=0n+zsZnuemsboxVNeCs64meBWnuXWqvN0/bUayXZJf1HhkYAZ08HQPwz0AlfGM/3wS0p
	 wr3ndBQm8eA6mxIZBqK+jzDXhVUMuHs+7xjsmtmyT9wG0eQ0mXTkC81V4gGs4klKAwAdj
	 CAif2OLSWw7KowAmb3HBsSl6M38oOP8nNcFwjUoYUeacblZUQ3aoZhLUnKrKF6y0YohT7
	 3fJetnq2rGyZW8pzXoyEV4xTz89vopxQaYMDm6Q92gxN6qXYN9ANmGV5Ixg7IB5mmC0sJ
	 PV7opmBehkFTDJfrFKjCC8jFfwDI0TzE5Ybf6eVQB8yiXxLYyzKCQ0ivrBPuhAcLhGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="n4+f/j9F";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B982606F940
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 16:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n4+f/j9F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E92371F00919;
	Thu,  5 Nov 2026 16:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793894536;
	bh=aqCzNdwdFXbkiMBNueOzUtHr/O5k6VyeO9VmVzV7WAE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=n4+f/j9FRQbdex8rpGrOu1/VSzFnNy2L6ZK/rKIm1qOC1buwmrM+jrqhtf7PrThxB
	 RWquUTsrdU0pUafZ7/xmNDO5eyimwJZFnJx0tnvYZcx7HfApo0OpgL/TSKqJorZWar
	 in3ZnPudZSRsfaA3LtZavFW88CYpdzDZZ2HI8ZDsHklz61yA3Fkat3P8hIYNawgX29
	 PapZrKhCPyrnYNiT0nMpTAIwsxYacgZL9WpIMyrzJVw84ARE/16b3XCgCMHjFgnSvT
	 nbRMWM2hKiEQs5Xdbrlv9azZ/RDL+IfSCOz/aubkRIfFERefAuiEVNsOA5xDhgfHwy
	 2/kjXw6vTgR0A==
Message-ID: <sashiko-outbox-199397@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: lpfc: fix ndlp use-after-free in RLS accept
 callback
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wentao Liang" <vulab@iscas.ac.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261104025348.1527601-1-vulab@iscas.ac.cn>
References: <20261104025348.1527601-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 16:02:15 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] scsi: lpfc: inaccurate Fixes tag in commit message for lpfc_els_rsp=
_rls_acc()
--

commit 8109741dc29cffda7f87382c25b20f6a9dd30b92
Author: Wentao Liang <vulab@iscas.ac.cn>

scsi: lpfc: fix ndlp use-after-free in RLS accept callback

This commit fixes a use-after-free of ndlp in lpfc_els_rsp_rls_acc() by
delaying lpfc_nlp_put(ndlp) until after the IOCB reference on ndlp has
been acquired, and releasing it on earlier error paths.

>     scsi: lpfc: fix ndlp use-after-free in RLS accept callback
>    =20
>     lpfc_els_rcv_rls() takes a reference on the ndlp for the pending
>     MBX_READ_LNK_STAT command.  lpfc_els_rsp_rls_acc() drops that
>     reference right after building the ACC IOCB, but then keeps
>     dereferencing ndlp in the trace message and takes a fresh reference
>     for the IOCB.
>    =20
>     The node can be removed from the nodelist while the mailbox is
>     pending, so the put may be the last one and release ndlp through
>     lpfc_nlp_release().  The later ndlp->vport, ndlp->nlp_DID and
>     lpfc_nlp_get() calls then touch freed memory.
>    =20
>     Move the put after the reference for the IOCB has been acquired, and
>     release it on the paths that bail out before that point.
>    =20
>     Fixes: 12265f68ae92 ("[SCSI] lpfc 8.3.18: Add support of received ELS=
 commands")
>     Cc: stable@vger.kernel.org
>     Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
>     Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>

[Severity: Low]
In commit 12265f68ae92 ("[SCSI] lpfc 8.3.18: Add support of received ELS
commands"), lpfc_prep_els_iocb() itself acquired the IOCB reference on
ndlp via elsiocb->context1 =3D lpfc_nlp_get(ndlp) before returning elsiocb.
Calling lpfc_nlp_put(ndlp) right after lpfc_prep_els_iocb() in
lpfc_els_rsp_rls_acc() kept the IOCB's reference live when elsiocb was
non-NULL, and returned immediately without dereferencing ndlp when
elsiocb was NULL.

Commit 4430f7fd09ec ("scsi: lpfc: Rework locations of ndlp reference
taking") later removed lpfc_nlp_get(ndlp) from lpfc_prep_els_iocb() and
moved it to the end of lpfc_els_rsp_rls_acc(), while leaving the
lpfc_nlp_put(ndlp) call immediately after lpfc_prep_els_iocb().

Should the Fixes tag instead be:

  Fixes: 4430f7fd09ec ("scsi: lpfc: Rework locations of ndlp reference taki=
ng")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104025348.1527=
601-1-vulab@iscas.ac.cn?part=3D1
