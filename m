Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E802468C2C
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 23:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785454078; cv=none; b=D7Rx1L2VCy5s1EvMWpOQfH4xkWR9WY/QsSz4UZHVff1kP6Cq1IBvz6zwJM9rPMlQ229iUnvXofZfb1E/dVwLA4jlRBXEBK9cg444Sry//IlUbbUnbHtSBEulFjXoZ5H3lOzwEzmhelRLvl0T4UNjZnExuhgHdjIWGfz0ZTQSazc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785454078; c=relaxed/simple;
	bh=lo9fQF+d/sxNHHqvjy9GPMF1hvKefe4oYZEat4gcthM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=L/2gUef1wOaZSZNVqevvqQgOb0+4oOlY/7ajsZoDsnvBb8y2+31oDdUCFWUR/MH5r+YV0wXHflJdQE9NI1R4nhk/XLRNFH/u4C/qqHXJufLI2e5bZ9YJexq4aaRy6Rp6m699tU8piJhJo74ISKJnItnjuTiy/Zc0yrHv0Lvkd18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hWgfBtEW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hWgfBtEW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C35DD1F000E9;
	Thu, 30 Jul 2026 23:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785454075;
	bh=DIFEuJc5/3NyHDGHqnzT4pCkGN3E1yVaypH6HZoo2SQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hWgfBtEWbYO44ZHCw2CTd+8h129jzX9xRORTrK8475MEh4Ub5xos5QULmk+Uy5TuN
	 tMfXP3qIA0vsxFzKpa6gIAmHinG8cvDvELrnBggNNwbb1W1Rb7K/b1izKuJYB44kTU
	 CX8lXf6elRnGcsQMJlBO434A5gT52D7Jd6YI4yWin/HNJncxUbmje5fiRbHId1mpAs
	 ilUuz7kzxKx9dYZsbBzhF9FI0uhoBcntNC7lYvVd8GdoF6c+mjflheSoRfJ1kZnsAe
	 w/4kvHj97BURWSVaciSzPnxRPQaEozQHRX80CzPWPoP4OcAvrCmsSedOs9ZIXtYxUA
	 gbU4yKVVs/aMQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 54/57] scsi: sym53c8xx_2: Enable lock context
 analysis
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <8edf4f7f4d8de5bacbcb89ebfd2fdea74a60f7f8.1785451174.git.bvanassche@acm.org>
References: <cover.1785451174.git.bvanassche@acm.org>
 <8edf4f7f4d8de5bacbcb89ebfd2fdea74a60f7f8.1785451174.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 23:27:55 +0000
Message-Id: <20260730232755.C35DD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Unconditional NULL pointer dereference (Undefined Behavior) in bnx=
2fc_process_cq_compl due to __assume_ctx_lock on uninitialized cb_arg point=
er.
--

--- Patch [54]: [PATCH v3 54/57] scsi: sym53c8xx_2: Enable lock context ana=
lysis ---
commit 914539bc4256a83053d649d7450d8f075fb16ba8
Author: Bart Van Assche <bvanassche@acm.org>

scsi: bnx2fc: Enable lock context analysis

This commit adds lock context analysis to the bnx2fc driver. It documents
locking requirements using __must_hold() and informs the compiler about
aliases for synchronization objects with __assume_ctx_lock().

> diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2f=
c_hwi.c
> index a5ecb87d5b2d7..a3670c48900ba 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
> @@ -880,6 +880,9 @@ void bnx2fc_process_cq_compl(struct bnx2fc_rport *tgt=
, u16 wqe,
>  		return;
>  	}
> =20
> +	/* Tell the compiler that there is an alias for tgt->tgt_lock. */
> +	__assume_ctx_lock(&io_req->cb_arg->aborted_io_req->tgt->tgt_lock);

[Severity: High]
Does this code trigger a NULL pointer dereference for standard SCSI
completions?

Looking at bnx2fc_process_cq_compl(), io_req->cb_arg is only allocated for =
ELS
or sequence cleanup commands. For standard FCoE SCSI completions
(BNX2FC_SCSI_CMD), io_req->cb_arg is NULL.

Since __assume_ctx_lock evaluates its argument to a pointer, evaluating this
nested pointer chain requires fetching the aborted_io_req pointer from the
memory addressed by cb_arg. Because cb_arg is NULL, this forces an invalid
memory read.

Can this be unconditionally reached on every SCSI completion, causing a hard
crash or triggering UndefinedBehaviorSanitizer warnings during normal I/O?

> +
>  	/* Timestamp IO completion time */
>  	cmd_type =3D io_req->cmd_type;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785451174.gi=
t.bvanassche@acm.org?part=3D54
