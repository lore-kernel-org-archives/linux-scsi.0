Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07736480348
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2026 12:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785328102; cv=none; b=T3QIUXwroLVZH5VtuHw9JH5ElqHMOHPCfu+fo+L277g9ujLTfCGF9sfuXJ69SJLc38IaRiZzgw0gE0OhkkP7+hsggC1AH+m76HqIt+Of4crOac/vbM6jnUVaameV9WD17EHPvbVTi/jg4JMfMgmzYH9YnYyQNGLNlX1UBmVnM14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785328102; c=relaxed/simple;
	bh=HudjLt24K5uAIhlNqnNNVnlT4vwC1lzgOwIGCCdNBUQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UxC6MlBw6k0rcX2Vm2Zd/vOjRaCwTiNGtEPMOYK2vA88Vj7tYm/tIFNRM39oZuPGJwfJVbfHq38ULuVDW84QbL3vRO1YDk4eLy5hWRu6ZiiChQTxfiT8LU7f+9/cht53W3utatKX48BQb4I+rSi5HDUQZ71N5uKG79NUwOjbPoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gb22TBlP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gb22TBlP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 874581F00A3A;
	Wed, 29 Jul 2026 12:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785328088;
	bh=ObHqXcD4Bssto4VWDA3UlLTI4gXFSExPBBYYhIY6mXU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Gb22TBlPFqvUyWnz0INgD5mc4HzYK5wE+uCC2pJZuCoSCiIXnKdDWGEwJyTkMgMrE
	 Y8U9BaJ9qhhCIEEBkrAyA1TyqlyeXQaUlRxgrU5YYI0GROffV3HeaTjImwFCFLKSWT
	 KqBsIQqXpdQfJGOlDMzOjV6twZsvAZmfmgvScaI6IxHBsDTns+9J2XaKswxwqnTCqG
	 AqTlvWXHQ8bNV37oQ9OxKrW3n+ss9DUI+nTjhvVzX5tBYvTd1z6zDiZJAlBtO+fbAA
	 oGSWGdF7OeClHSnidR3ggMqfn3ru2LX8PfSdY7mH0saLGwZWLuF3woSzx+uKgybvip
	 SaBoqkvKzc/8Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 07/27] libmultipath: Add sysfs helpers
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260729105107.255712-8-john.g.garry@oracle.com>
References: <20260729105107.255712-1-john.g.garry@oracle.com>
 <20260729105107.255712-8-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 29 Jul 2026 12:28:08 +0000
Message-Id: <20260729122808.874581F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] The sysfs store helper `mpath_iopolicy_store` updates the `iopolic=
y` locklessly and without invalidating cached paths, creating a TOCTOU race=
 on concurrent writes and leaving the system operating on stale paths.
- [Medium] Inconsistent evaluation of `iopolicy` in `__mpath_find_path` due=
 to reading the state inside the device loop.
--

--- Patch [7]: [PATCH v6 07/27] libmultipath: Add sysfs helpers ---
commit ceaf280cc3938326ee64a5bab20fde5b9a603a83
Author: John Garry <john.g.garry@oracle.com>

libmultipath: Add sysfs helpers

This commit adds helper functions for driver sysfs code to get/set the
iopolicy, show device paths per NUMA node, and manage multipath attribute
groups.

> diff --git a/lib/multipath.c b/lib/multipath.c
> index fada92bf9754c..58eb9be5bebbe 100644
> --- a/lib/multipath.c
> +++ b/lib/multipath.c

[ ... ]

> @@ -620,6 +620,100 @@ void mpath_device_set_live(struct mpath_device *mpa=
th_device)

[ ... ]

> +static void mpath_iopolicy_update(enum mpath_iopolicy_e *iopolicy,
> +		int new)
> +{
> +	int old =3D READ_ONCE(*iopolicy);
> +
> +	if (old =3D=3D new)
> +		return;
> +
> +	WRITE_ONCE(*iopolicy, new);

[Severity: High]
Since kernfs does not serialize store callbacks, can this lockless
read-compare-update sequence lead to TOCTOU races on concurrent writes?

If multiple threads execute this simultaneously, could they both read the
same old state, overwrite it, and emit inconsistent logs?

Additionally, does this policy update need a way to invalidate the cached
paths? Because this helper only updates the policy and has no reference to
mpath_head, it doesn't invalidate mpath_head->current_path.

Will the new policy continue using the stale path cached by the old policy?

> +
> +	pr_info("iopolicy changed from %s to %s\n",
> +		mpath_iopolicy_names[old],
> +		mpath_iopolicy_names[new]);
> +}

[Severity: Medium]
Does introducing this concurrent sysfs update expose a TOCTOU race in
__mpath_find_path()?

If __mpath_find_path() iterates over devices and reads the IO policy on each
iteration via mpath_read_iopolicy(mpath_head):

	if (mpath_device->numa_node !=3D NUMA_NO_NODE &&
	    (mpath_read_iopolicy(mpath_head) =3D=3D
		MPATH_IOPOLICY_NUMA))
		distance =3D node_distance(node,
				mpath_device->numa_node);
	else
		distance =3D LOCAL_DISTANCE;

Could a concurrent change here transition the policy mid-loop, causing the
function to mix incompatible node_distance metrics with LOCAL_DISTANCE and
potentially corrupting the minimum-finding logic?

Should the policy be read exactly once before the loop?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260729105107.2557=
12-1-john.g.garry@oracle.com?part=3D7
