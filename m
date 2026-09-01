Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7380E47B437
	for <linux-scsi@vger.kernel.org>; Tue,  1 Sep 2026 11:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788260582; cv=none; b=UR2nhExGEWM1kpnRjBk1ZB5zeSNDShJJSmv0LhvhzS9s5OZiC5ELaTZDu5ViJ9/bAF0IqEWxGiseUXTpX7gPfRqEeIagNmKr7Gjid+yckY8sbpyG36n7tUqtwJvdbSN5dpzSy2WGbgOaBqPit8gDkXEFEUwcsyv9Ohlp9bnLJ3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788260582; c=relaxed/simple;
	bh=hiBKWxHg4HCzBCztD3OK2KVdSz0UwV5VWm0s8WF3I9U=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Lkvu9O9jsyaqVVA4aENRoogiebRQz6AjAiZ/TcyeSm8ztHO6t5TE4V+PQQJ4zR/liXWp9WDV4L0nKV9OS/BsxXB0BdHYgYk33HYSPu0cxjkXnT9Z3XL20NCtOjXEUdwXCqFNT+LLOzioX8xu+Da1jXsRAZbbOco49lplmox+25M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gc7OLGKl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gc7OLGKl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC23F1F000E9;
	Tue,  1 Sep 2026 11:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788260581;
	bh=1B6aWfhIc9yjQPee1RO11vwT4mGJqJwj3XTsMZ0y2mI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gc7OLGKlY2wSuOlb2ydmUcZWFIVzyimqIjiDFDp200HI4aUBPjYxlviokn4Bw/2pQ
	 C5ZIWj6TWNRQLmHhDzB0WBWQ7xeEKwei0Yqdyyx89SqPTxahGc+UyUVa2pPI/FSptJ
	 CnfDhHU+FCpmpInRBesMA9//sX+lIQRvjeLQ1YC8XYs7MNg6JZCm8e0Tj2ez2I7quU
	 Z4PoKJl+9nFpxXozxPyLfRXVZSkgVivbluAVJLzcLgfOp3kq3/sTCSsLR+Qo6+fiVW
	 foegVCUBuSkLjJmE3c0wbLL+15sZi4H6PR3oWXJ01BDErOTYna4c5aBJk5neP54RCQ
	 2Ti5lmFbnJ8EQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 01/27] libmultipath: Add initial framework
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260901104526.3850621-2-john.g.garry@oracle.com>
References: <20260901104526.3850621-1-john.g.garry@oracle.com>
 <20260901104526.3850621-2-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 01 Sep 2026 11:03:00 +0000
Message-Id: <20260901110300.DC23F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Missing synchronize_srcu() before cleanup_srcu_struct() in mpath_h=
ead_uninit() leads to SRCU leaks and use-after-free.
--

commit 6f039c958c0ecba8ea01ef606d22d9dd4d06104b
Author: John Garry <john.garry@linux.dev>

libmultipath: Add initial framework
   =20
This commit adds an initial framework for libmultipath, a library for
multipath-capable block drivers. It introduces basic support to add and
remove the mpath_head structure, which manages available paths and path
selection.

> diff --git a/lib/multipath.c b/lib/multipath.c
> new file mode 100644
> index 0000000000000..f7b26c66eac7c
> --- /dev/null
> +++ b/lib/multipath.c
> @@ -0,0 +1,67 @@
[ ... ]
> +void mpath_head_uninit(struct mpath_head *mpath_head)
> +{
> +	refcount_t *refcount =3D &mpath_head->refcount;
> +
> +	if (!refcount_dec_and_test(refcount))
> +		wait_var_event(refcount, !refcount_read(refcount));
> +	cleanup_srcu_struct(&mpath_head->srcu);

[Severity: High]
Is it possible we need a synchronize_srcu() call before cleanup_srcu_struct=
()
in mpath_head_uninit()?

Active SRCU readers could trigger a WARN_ON(srcu_readers_active(ssp)) in
cleanup_srcu_struct(), resulting in an SRCU leak. More critically, when the
memory containing mpath_head is subsequently freed by the caller, any
still-executing SRCU readers will experience a use-after-free crash when th=
ey
call srcu_read_unlock() or access mpath_head fields.

During device removal, mpath_head_uninit() waits for mpath_head->refcount to
reach 0. However, SRCU read-side critical sections do not increment this ba=
se
refcount to maintain lockless fast-paths. Furthermore, del_gendisk() for
bio-based queues does not automatically freeze the queue or wait for
q_usage_counter to drain active submit_bio calls. Thus, cleanup_srcu_struct=
()
might be called while readers are still executing.

> +}
> +EXPORT_SYMBOL_GPL(mpath_head_uninit);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901104526.3850=
621-1-john.g.garry@oracle.com?part=3D1
