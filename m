Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B22382371
	for <linux-scsi@vger.kernel.org>; Tue,  1 Sep 2026 11:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788260659; cv=none; b=D1YivZYhPT7PBehPhmxx0fdLM6x26QWw5BAChIk/vpGSwExsg6OWKWgfrfL+aMREI+alhkvoCTXqL4Qmmvnn4XG8+RktAralcN9VWfJd83z8XTrhtOgUY26q5scWvzsIRTD5jVUczoes+L+/Oi2taOE/7T9xUv1p5eehbQi023E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788260659; c=relaxed/simple;
	bh=9jFpj01UiWybTS53YKdX1c6dhixEoySa+Ia3a7VLsuw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Bj0LC7RF4CfMb0FYrlDxgugTUCVj4WWaQZZKqVBLky8lBUs9OarTKbZmO8dasOzgN0KEn0GNTSwflC9dcr/tB1ljkRZUQHJLMhhhnJch1CJbX8WsrOTHtUJTGmgm+jmpKsuY/hcbLYjMMNKM5hS43xCRNfUw1+DkD2rtSFJKcYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cMT0u6ne; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cMT0u6ne"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30DD1F000E9;
	Tue,  1 Sep 2026 11:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788260658;
	bh=UMlBoGtpe/uy6cp9QhXy658InntFjYbBuud2nhoRqMs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cMT0u6neVI2+/ctBqAtKnJL4zwHS301LyKfzxHqW6cBEJt4GuItVMVbLKWe9ctAeW
	 1wgG9kMzIGZG3X5zxeO3UrKIjZkCVp5K4L+Qw35k8Knp/nlwy9tTqXI/FRZcx8S2vX
	 8psm/kieceRankI3PytbTKxXKQ8SjYg9Hpb8oenchi57S4seR4GZClpSzCpWukQqkQ
	 Ia8E+cKuut2olXQgb81rxAeFtpTuuvplbQIABN4suXERjESQEBzi74sLf3G59jJ2U8
	 Bfl1t4f5ldNJNmLVgzA+0AaWIVism+XGj2U98KevyqDZYFK4HGSacX+9ohlHg2esVW
	 aBkIC/ajSbg9w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 03/27] libmultipath: Add path selection support
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260901104526.3850621-4-john.g.garry@oracle.com>
References: <20260901104526.3850621-1-john.g.garry@oracle.com>
 <20260901104526.3850621-4-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 01 Sep 2026 11:04:17 +0000
Message-Id: <20260901110417.E30DD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Infinite loop in mpath_round_robin_path() due to concurrent path r=
emoval and cache overwrite.
--

commit 5ea7b90698a3876a3c3c747f99ff79a9d52b1e32
Author: John Garry <john.garry@linux.dev>

libmultipath: Add path selection support

This commit abstracts NVMe ANA into enum mpath_access_state to support
SCSI ALUA. It also adds path selection modes for round-robin, NUMA, and
queue-depth.

> diff --git a/lib/multipath.c b/lib/multipath.c
> index 1cf20b0f62d07..26714116023a3 100644
> --- a/lib/multipath.c
> +++ b/lib/multipath.c

[ ... ]

> @@ -109,6 +231,146 @@ static struct mpath_device *mpath_next_dev(struct m=
path_head *mpath_head,
> +static struct mpath_device *mpath_round_robin_path(
> +				struct mpath_head *mpath_head)
> +{
> +	struct mpath_device *mpath_device, *found =3D NULL;
> +	int node =3D numa_node_id();
> +	enum mpath_access_state access_state_old;
> +	struct mpath_device *old =3D
> +			srcu_dereference(mpath_head->current_path[node],
> +				&mpath_head->srcu);
> +
> +	if (unlikely(!old))
> +		return __mpath_find_path(mpath_head, node);
> +
> +	if (list_is_singular(&mpath_head->dev_list)) {
> +		if (mpath_path_is_disabled(mpath_head, old))
> +			return NULL;
> +		return old;
> +	}
> +
> +	for (mpath_device =3D mpath_next_dev(mpath_head, old);
> +	    mpath_device && mpath_device !=3D old;
> +	    mpath_device =3D mpath_next_dev(mpath_head, mpath_device)) {

[Severity: High]
Could this loop run infinitely if `old` is unlinked from the list concurren=
tly?

If Thread 1 enters mpath_round_robin_path(), loads `old =3D D` from=20
`current_path[node]`, and is preempted, another thread could enter, find a=
=20
fallback path Y, and overwrite `current_path[node] =3D Y`.

When a removal thread subsequently calls mpath_clear_current_path(D), it wo=
uld=20
return false because the cached path is now Y. If this causes the removal=20
thread to skip mpath_synchronize() and directly unlink D via=20
mpath_delete_device(D), the path is removed from the list while Thread 1 st=
ill=20
holds a reference to it.

When Thread 1 resumes, `old` is no longer linked. If there are no=20
MPATH_STATE_OPTIMIZED paths to trigger an early break, mpath_next_dev() wou=
ld=20
cycle infinitely between the remaining active paths, because=20
`mpath_device !=3D old` would never evaluate to false.=20

Is there a way to ensure the loop termination condition remains valid even =
if=20
`old` is concurrently replaced and removed?

> +
> +		if (mpath_path_is_disabled(mpath_head, mpath_device))
> +			continue;
> +		if (mpath_device->access_state =3D=3D MPATH_STATE_OPTIMIZED) {
> +			found =3D mpath_device;
> +			goto out;
> +		}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901104526.3850=
621-1-john.g.garry@oracle.com?part=3D3
