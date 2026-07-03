Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5832D3D6488
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2026 10:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783075393; cv=none; b=bm98eTcu5VQqeAO8/elrUWjeD92nrEQfMuXkflMrKMhPief7n9/gWA1+i642MGEhXvMY9GxtX75Zi3WzVgmA+KO48TEZF0XV3cbuDHEUucMwB4Cm7Jao4RwdxwF+B5KV1yTNRDm+5VCwelY/IZR54wYOGM19sSepXPklhGRj/70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783075393; c=relaxed/simple;
	bh=E8OZvXfvhG/Ka1jc41xMOpU1C0GWXDCIjET7DK2fTU0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=CzwywltDLOIaTSphHTRr5o3Oqbf9HB0/8JkvxtACRutTp4h1iJQVyVTJ/YYG4NsBBiht9rS2Oi80Q6iO/HghA3kmydwxgIy8irM13D1se2RbTvKd+InY8uo2sclGnakit9DvxEbTqjNBtAZPCx0n0ixKXTElc3D3g+B/Ve0xmno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KObgD5qS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KObgD5qS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C18771F00A3D;
	Fri,  3 Jul 2026 10:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783075391;
	bh=DjLJbN0MGJfQNtVgAnyXQ6U3HSggWaRCMn93Y8QNrJw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KObgD5qScCXztQ2gWZwJysX92H9cX+foAckqaX+iSOThhk4W+5yTomwLmi2QNfTro
	 Z8WaiRkd3q6DPp8TvpgS2op8H9uTlsDCEAXMJT/8IQkUIoCceiapvietrubIWhVX3D
	 IcOVtRQaN/tY8TPEC6BQJjg8coqtZCd35KVFAtXAyor8K8pWmaDK4qUAPhFgF2WJ22
	 2sOi6oBMxShad/lanz0XH0fLqOfh1F7Vl/biT8M1epCmT2lXDOSIu/sKAMUzDkw4o6
	 Nll/Jd+lslFTzUNvm8ydR41zai2fzq91FKggS5QiU3N25rryqVQJ88EwwVZqmaydbv
	 /TXo6ad5Z963Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 01/13] libmultipath: Add initial framework
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260703102918.3723667-2-john.g.garry@oracle.com>
References: <20260703102918.3723667-1-john.g.garry@oracle.com>
 <20260703102918.3723667-2-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 10:43:10 +0000
Message-Id: <20260703104311.C18771F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] A race condition between mpath_put_head() and mpath_head_uninit() =
leads to a use-after-free vulnerability when accessing mpath_head for clean=
up.
--

commit 594f063adb51503b6e7af6741526b8d738fee5ba
Author: John Garry <john.g.garry@oracle.com>

libmultipath: Add initial framework

This commit adds the initial framework for libmultipath to support path
management, path selection, and failover handling for multipath-capable
block drivers. It introduces the mpath_head structure to manage available
paths and the multipath gendisk.

> diff --git a/lib/multipath.c b/lib/multipath.c
> new file mode 100644
> index 0000000000000..009d4bb875c6f
> --- /dev/null
> +++ b/lib/multipath.c

[ ... ]

> +void mpath_put_head(struct mpath_head *mpath_head)
> +{
> +	refcount_t *refcount =3D &mpath_head->refcount;
> +
> +	if (refcount_dec_and_test(refcount)) {

[Severity: High]
Could this introduce a use-after-free regression on the mpath_head structur=
e?

If a teardown thread calls mpath_head_uninit() concurrently, it blocks in
wait_var_event() waiting for the refcount to drop to 0.

Once refcount_dec_and_test() drops the refcount to 0 here, the condition
!refcount_read(refcount) in mpath_head_uninit() can evaluate to true
immediately. The uninit thread could then wake up, return, and free mpath_h=
ead
before this thread completes mpath_head_cleanup() and wake_up_var().

> +		mpath_head_cleanup(mpath_head);
> +		wake_up_var(refcount);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(mpath_put_head);
> +
> +void mpath_head_uninit(struct mpath_head *mpath_head)
> +{
> +	refcount_t *refcount =3D &mpath_head->refcount;
> +
> +	if (refcount_dec_and_test(refcount)) {
> +		mpath_head_cleanup(mpath_head);
> +	} else {
> +		wait_var_event(refcount, !refcount_read(refcount));
> +	}
> +}
> +EXPORT_SYMBOL_GPL(mpath_head_uninit);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703102918.3723=
667-1-john.g.garry@oracle.com?part=3D1
