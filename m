Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9DA947143A
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 18:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786559184; cv=none; b=cyQLK2pv6QEZGPtHa+mbnMIv8i8Gyw+ZqzyjciotkU/q7qMqmxyO4DN3wy/t53e+69DgZ3qsgfZuLCdm00rmQXDSBiouxSUFI8aVzRVIVbjypD3AZOPVyafMfCf72Q+6+Ws/xBohiYogAqZg4dVZe03hxzIFJ9vrw+lvji63mtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786559184; c=relaxed/simple;
	bh=JnpiZyJS2hQtdm+vmlakSMKUGLMcfHO3tLWghjDYclc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=B2J3DYpvxPgVpMQOjUvvj03sZ8cmTn1TTaTN68aFUXXDk7rUdcKZ7RohMLSzumfImDC1TY5bZJvfhFDpAjS7EAfDF6t1ENXNzTMwESYVYrh13Pvb2yEyqfcK/MdlzHIaJqFrogYkwgZz0kOrDcHYNVaGePPZmfUio8B6iVf3vvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KZ5iMs5t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KZ5iMs5t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6024D1F00A3A;
	Wed, 12 Aug 2026 18:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786559182;
	bh=a9FCpXdS8sDEHI8Wlgv1qncakhFt7y2Xo+cZHSV8x0c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KZ5iMs5tV8A3SPacnK0FQnx+ngdzab9Fg575uSt2mZymL85hGUXwa3MT7QYtqo7y1
	 InG9KuOW4lBe6FfcfUeuJzffZB+VyYDyFjnGV4w6rkK/J4mPUBluB0O4fVZNQhY+5R
	 W5gIM5HCilXznlrSxgtEjW3phTGyoffqRw+CKLm0VH0DtdPiK7vXRn/hCB/LsqD4gw
	 AKExflztUVV/174VKekR4WU2VOV+4gp93t7hqh3t8l1MhpfnfdAS1ZobRC6ku+mKud
	 FoScJLBvSkX4fH2g5ce4jjKmHiJxYHr9KhLfvY/j9fdaQEEaNQ5r6ZnS1LzzjRhG1E
	 r5RwRWaTjHWkg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 05/13] nvme-multipath: round-robin support for marginal
 paths
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jesse Taube" <jtaubepe@redhat.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260812181300.3712426-6-jtaubepe@redhat.com>
References: <20260812181300.3712426-1-jtaubepe@redhat.com>
 <20260812181300.3712426-6-jtaubepe@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 12 Aug 2026 18:26:21 +0000
Message-Id: <20260812182622.6024D1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] Improper round-robin fallback logic causes path thrashing between =
marginal OPTIMIZED and marginal NONOPTIMIZED paths.
- [High] Path selection logic may incorrectly return paths in `INACCESSIBLE=
`, `CHANGE`, or `PERSISTENT_LOSS` ANA states.

Pre-existing issues:
- [High] The round-robin path selection can enter an infinite loop inside a=
n SRCU read-side critical section if the current path is removed concurrent=
ly.
--

--- Patch [5]: [PATCH 05/13] nvme-multipath: round-robin support for margin=
al paths ---
commit f4b9e08d0e0306a7a08b9e274efbbe8c287e6dde
Author: Jesse Taube <jtaubepe@redhat.com>

nvme-multipath: round-robin support for marginal paths

This commit modifies the NVMe round-robin path selection to exclude
marginal paths by default. It introduces logic to fall back to round-robin
on marginal paths only if no optimized or non-optimized non-marginal paths
are found.

> diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
> index dc34634842be8..11f474704fdd7 100644
> --- a/drivers/nvme/host/multipath.c
> +++ b/drivers/nvme/host/multipath.c

[ ... ]

> @@ -425,22 +426,58 @@ static struct nvme_ns *nvme_round_robin_path(struct=
 nvme_ns_head *head)
>  	for (ns =3D nvme_next_ns(head, old);
>  	     ns && ns !=3D old;
>  	     ns =3D nvme_next_ns(head, ns)) {

[Severity: High]
This is a pre-existing issue, but does this loop condition risk an infinite
loop if the current path is concurrently removed?

If old (the current path) is concurrently unlinked via list_del_rcu(),
nvme_next_ns() will continue into the active list, wrap around to the head,
and traverse indefinitely. Because old is no longer in the list, ns !=3D old
remains true forever.

Since this patch makes it easier to fall through without hitting a goto out
(for example, when all paths are marginal), could this cause a hard lockup
in the SRCU read-side critical section?

[ ... ]

>  	/*
>  	 * The loop above skips the current path for round-robin semantics.
>  	 * Fall back to the current path if either:
> -	 *  - no other optimized path found and current is optimized,
> +	 *  - no other non-marginal optimized path found and current is,
> +	 *      optimized and not marginal.
>  	 *  - no other usable path found and current is usable.
>  	 */
> -	if (!nvme_path_is_disabled(old) &&
> -	    (old->ana_state =3D=3D NVME_ANA_OPTIMIZED ||
> -	     (!found && old->ana_state =3D=3D NVME_ANA_NONOPTIMIZED)))
> +	/* no other usable path found and current is usable. */
> +	if (!nvme_path_is_disabled(old) && !found)
> +		return old;

[Severity: High]
Could this fallback condition incorrectly return paths that are in
inaccessible, change, or persistent loss ANA states?

When the current path transitions to an inaccessible state and no other
usable paths exist, the loop finds no paths (found is NULL). Because
nvme_path_is_disabled() does not check the ANA state, this fallback will
return the old path.

Will this lead to continuous submission of I/O to inaccessible paths and
unnecessary ANA log reads?

> +	/*
> +	 * no other non-marginal optimized path found and current is,
> +	 *   optimized and not marginal.
> +	 */
> +	if (!nvme_path_is_disabled(old) && !nvme_ctrl_is_marginal(old->ctrl) &&
> +	    (old->ana_state =3D=3D NVME_ANA_OPTIMIZED || found_is_marginal))
>  		return old;

[Severity: High]
Does this logic cause path thrashing between marginal optimized and
marginal non-optimized paths?

If the current path is marginal and optimized, and the loop finds a
marginal non-optimized path, this fallback unconditionally skips retaining
the current marginal path because of the !nvme_ctrl_is_marginal(old->ctrl)
check.

It then selects the non-optimized path instead. On the next I/O, the
reverse happens, causing a bounce between the two paths. Should marginal
optimized paths be retained over marginal non-optimized ones?

> =20
>  	if (!found)

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260812181300.3712=
426-1-jtaubepe@redhat.com?part=3D5
