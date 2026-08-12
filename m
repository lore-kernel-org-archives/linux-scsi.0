Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44FD8481FD6
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 18:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786559381; cv=none; b=BbxzUH/9HvEgLbDexvXn+jNVienoecI3U8TRgbzoqYJtphO+JR7w38NbqZJf9vlrfZHdCc/YUxTwMtS5QqhCyDVszZh6MlUTX2URF1dVHhZaMXd4uXRKQmfgjjgtQFsiIblUq4phBKy2AJ43yQJVNI0XIZD1SKtuJbORi7uljDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786559381; c=relaxed/simple;
	bh=Qus58GfvTA2DAP9HFTSs3GEo0/Bs1yDw5Ig1c9O/8m0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=S9X5cgZ60iNi/LwEFokpf7sizHbv8cGhGBzRzl1FKelRRdX61BFVE18JmRDVm3LKB+9kDuDSkDTSoGXhWLDlePWY6OQfn1TWupnKLF6fhVP592kgtOXeU8jOgHXcTz/oAKtOMYE9KnNZFVlfvhV0yFjThf73ojXvG1/fo8r6zfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jOLh37qj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jOLh37qj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1D171F00A3A;
	Wed, 12 Aug 2026 18:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786559379;
	bh=92Oyo5hsSO5Xf7IntfwZAgO2ZvMGG7wAQidnzfTrBFQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jOLh37qjhQYFxOQk7NCl2DFjtLrPiipop1OF7gV4sK2sD4sltU5CJT3obhM1TemgI
	 B5z2GyFDsWLqc9pHmKZqxbW5IH0qru6af6i11mvC6ORctKJQFkAfvu2+TMqXIr6aU8
	 1du4CryByrcjIfbuR3IEdcgwAQzGO/Ez6AtdRJFz6nf3K0kcj30xJWp0GNhtJOdr84
	 cIOoV7j0M8LrWf7kaXscSIqjNVAjc7B02AVIeu3dknQHFe3C6erPYmqUBMfPfUs6Rv
	 Mh8iiqNuVH/lpjBozU0mcAFlggI2kuMmGpApTsqxqo3k+Ba7RjM35qDM957XQJCeWG
	 Wo2+M6v2R8nFA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 03/13] nvme-multipath: numa support for marginal paths
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jesse Taube" <jtaubepe@redhat.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260812181300.3712426-4-jtaubepe@redhat.com>
References: <20260812181300.3712426-1-jtaubepe@redhat.com>
 <20260812181300.3712426-4-jtaubepe@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 12 Aug 2026 18:29:39 +0000
Message-Id: <20260812182939.C1D171F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Medium] Double evaluation of volatile controller state creates a TOCTOU =
race that can select a sub-optimal marginal path over a better non-marginal=
 path.
- [Medium] The round-robin multipath I/O policy (`nvme_round_robin_path`) w=
as not updated to handle marginal paths, bypassing the new `NVME_CTRL_MARGI=
NAL` priority logic.
- [Low] The comment explaining the fallback path selection has inverted log=
ic.
--

--- Patch [3]: [PATCH 03/13] nvme-multipath: numa support for marginal path=
s ---
commit 820a8648fdbfc8327ddaf233abd513210c265d17
Author: Jesse Taube <jtaubepe@redhat.com>

nvme-multipath: numa support for marginal paths

This patch introduces the NVME_CTRL_MARGINAL flag to handle FPIN LI
(link integrity) messages indicating hardware errors. The multipath
scheduler is updated to direct I/O away from affected marginal ports by
skipping them when non-marginal optimized paths are available.

> diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
> index 9b9a657fa330f..02936c580a373 100644
> --- a/drivers/nvme/host/multipath.c
> +++ b/drivers/nvme/host/multipath.c

[ ... ]

> @@ -323,15 +357,19 @@ static struct nvme_ns *__nvme_find_path(struct nvme=
_ns_head *head, int node)
> =20
>  		switch (ns->ana_state) {
>  		case NVME_ANA_OPTIMIZED:
> -			if (distance < found_distance) {
> +			if (is_best_distance(found_is_marginal, nvme_ctrl_is_marginal(ns->ctr=
l),
> +					     found_distance, distance)) {
>  				found_distance =3D distance;
>  				found =3D ns;
> +				found_is_marginal =3D nvme_ctrl_is_marginal(ns->ctrl);
                                                    ^^^^^^^^^^^^^^^^^^^^^^^=
^^^^^^^^

[Severity: Medium]
Could this double evaluation of nvme_ctrl_is_marginal() cause a race
condition?

nvme_ctrl_is_marginal() uses test_bit(), which performs a volatile memory
read. If the controller's marginal state transitions from false to true bet=
ween
these two reads, a previously found non-marginal path will be incorrectly
replaced by this new path, which is then subsequently recorded as marginal.

Would it be better to read the marginal state into a local variable once per
iteration?

>  			}
>  			break;
>  		case NVME_ANA_NONOPTIMIZED:
> -			if (distance < fallback_distance) {
> +			if (is_best_distance(fallback_is_marginal, nvme_ctrl_is_marginal(ns->=
ctrl),
> +					     fallback_distance, distance)) {
>  				fallback_distance =3D distance;
>  				fallback =3D ns;
> +				fallback_is_marginal =3D nvme_ctrl_is_marginal(ns->ctrl);
                                                       ^^^^^^^^^^^^^^^^^^^^=
^^^^^^^^^^^

[Severity: Medium]
Does this have the same race condition as the NVME_ANA_OPTIMIZED case above?

Using a local variable for the marginal state might prevent inconsistencies
if the bit changes between the two checks.

>  			}
>  			break;
>  		default:

[ ... ]

> @@ -339,6 +377,14 @@ static struct nvme_ns *__nvme_find_path(struct nvme_=
ns_head *head, int node)
>  		}
>  	}
> =20
> +	/*
> +	 * Use non-optimized path only if it is not marginal
> +	 * and no optimized path is marginal.
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

[Severity: Low]
Is the logic in this comment inverted?

The code correctly falls back to a non-marginal path only when the optimized
path is marginal (found_is_marginal && !fallback_is_marginal). However, the
comment incorrectly states it falls back if "no optimized path is marginal",
which contradicts the implemented boolean logic.

> +	 */
> +	if (found_is_marginal && !fallback_is_marginal)
> +		found =3D fallback;
> +
> +	/* No optimized path found, use the fallback */
>  	if (!found)
>  		found =3D fallback;
>  	if (found)

[ ... ]

> @@ -444,7 +490,8 @@ static struct nvme_ns *nvme_queue_depth_path(struct n=
vme_ns_head *head)
>  static inline bool nvme_path_is_optimized(struct nvme_ns *ns)
>  {
>  	return nvme_ctrl_state(ns->ctrl) =3D=3D NVME_CTRL_LIVE &&
> -		ns->ana_state =3D=3D NVME_ANA_OPTIMIZED;
> +		ns->ana_state =3D=3D NVME_ANA_OPTIMIZED &&
> +		!nvme_ctrl_is_marginal(ns->ctrl);
>  }

[Severity: Medium]
Since marginal paths are now supported and skipped in the NUMA and queue de=
pth
policies, does nvme_round_robin_path() also need to be updated?

If a user configures iopolicy=3Dround-robin, the multipath scheduler seems =
to
actively route I/O to marginal paths without checking the state:

drivers/nvme/host/multipath.c:nvme_round_robin_path() {
    ...
		if (ns->ana_state =3D=3D NVME_ANA_OPTIMIZED) {
			found =3D ns;
			goto out;
		}
    ...
}

Could this risk I/O timeouts and dropped packets on unreliable hardware lin=
ks
by bypassing the new NVME_CTRL_MARGINAL priority logic?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260812181300.3712=
426-1-jtaubepe@redhat.com?part=3D3
