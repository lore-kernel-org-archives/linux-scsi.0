Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792502565;
	b=2CAVvq0hHS0pAW1SkrkGlG7x1McnjjVnbEac7qWaAoQkrddG6RLOkHNv4aNPY+GXMbph
	 8LHnDkiKoMekvP7NXqqeKDMoKYqHkwxpKNvQ6HJr9gHfKUVI51OhfXKzyiehd+rcY3dz+
	 deA3eAkhpnLHFswKjunOtstt/o/UroFZzJuOGJQof86lWj9aTo7zb8Bgq+Xvby06lZMNI
	 OguYOaty9Vv7oV6Zc3FscZv1l2wPST6lqhipxkGdzGAq+Bc1hD9Fx/PfFN9YpZC6ryJHt
	 +0d2hU/zgGS3b9FN8hO+gVAZ1TOL+2RcwV0ZmHwAXdW/0blCHrUYlh/9A9QIH1p2xug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792502565;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=nBiUvq5hcSNVovnt6mmcsqdakbdKO+FxhfID33l0e9c=;
	b=DGMnMkNMNEFpCRmE+yq4IqgkO3QOXS+COOVqr7UpoYL561pOh5CI//tE+VfkceJdDErx
	 xMqugY8mttDoghooWWaGtNI48/EkYvh5TY0vRUximX3ZuNNgrHHKY/dfeOabO5IwiKRzH
	 eCETuC+lLkJ4Dl8nQ3kPCV8efYCuSu/G0K/6YHdmsXgEorQvWJa+BgjqyOAtoK7zNWKcK
	 cL+Dad6V/ir6luJ2881kZPaSCIKnEDAuVk1fEV1pU2nzv7NV9YLb9i4X/rzw0CVzwXys0
	 IpBYu0khUurGXo7x4fiCM/42m8BQ5gdTEvrJGiPkkwl7cCaqabBIcJpIjH3PmqEe1lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YzoVMOoc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEFB6606A320;
	Tue, 20 Oct 2026 13:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YzoVMOoc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13BFE1F000CC;
	Tue, 20 Oct 2026 13:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792502564;
	bh=nBiUvq5hcSNVovnt6mmcsqdakbdKO+FxhfID33l0e9c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YzoVMOocGpM9V85xcNbutUBG2ypQpLmpvkqrbkfyV+iXWmjnwnj2uccIBkqhGOYUb
	 Z3QpPe9cw2iBldYvbURP6zNZDzZD0ziddzzAxT6sBkHPZDNyzhkOXtNKFK5szjb57N
	 Ue4r1RR1w9Z/rzZgL9L5OEu/QsdjmxWHOEDS3xjzfupBcluwd+SrVC4j6TcIgIyN1d
	 ePPR31VIId9PzMBDFt0YScMRB1KTWadJnzcJ7rdqBpbyIdHFL0uOJPvoMvHj7FIVDo
	 o8WVl2ZD7bp/4UEyVK8CttLJcHNV9arkMp4oDUKkYXJdxROiJwbAiK1hKe7cuizKfI
	 fybXMYKFloNoA==
Message-ID: <sashiko-outbox-179020@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] libcxgb: use raw_cpu_ptr() in ppm_get_cpu_entries()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Haoran Wang" <haoranwangsec@gmail.com>
Cc: linux-rt-devel@lists.linux.dev, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <179241614797.5916.13928836073297916808@whr>
References: <179241614797.5916.13928836073297916808@whr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 20 Oct 2026 13:22:43 +0000
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
- [Critical] libcxgb: CPU migration between raw_smp_processor_id() and raw_=
cpu_ptr()
--

commit 45e692c0f47c6b069f27d74df45dc3a4a6360a3d
Author: Haoran Wang <haoranwangsec@gmail.com>

libcxgb: use raw_cpu_ptr() in ppm_get_cpu_entries()

This commit replaces get_cpu(), per_cpu_ptr(), and put_cpu() in
ppm_get_cpu_entries() with raw_smp_processor_id() and raw_cpu_ptr() to avoid
acquiring spin_lock_bh() with preemption disabled on PREEMPT_RT kernels.

> diff --git a/drivers/net/ethernet/chelsio/libcxgb/libcxgb_ppm.c b/drivers=
/net/ethernet/chelsio/libcxgb/libcxgb_ppm.c
> index 2e3973a32d9d1..5f68c5d5766e5 100644
> --- a/drivers/net/ethernet/chelsio/libcxgb/libcxgb_ppm.c
> +++ b/drivers/net/ethernet/chelsio/libcxgb/libcxgb_ppm.c
> @@ -125,10 +125,9 @@ static int ppm_get_cpu_entries(struct cxgbi_ppm *ppm=
, unsigned int count,
>  	if (!ppm->pool)
>  		return -EINVAL;
> =20
> -	cpu =3D get_cpu();
> -	pool =3D per_cpu_ptr(ppm->pool, cpu);
> +	cpu =3D raw_smp_processor_id();
> +	pool =3D raw_cpu_ptr(ppm->pool);
>  	spin_lock_bh(&pool->lock);
> -	put_cpu();
> =20
>  	i =3D ppm_find_unused_entries(pool->bmap, ppm->pool_index_max,
>  				    pool->next, count, 0);

[Severity: Critical]
Can the task be preempted and migrated to another CPU between
raw_smp_processor_id() and raw_cpu_ptr(ppm->pool)?

Because preemption is enabled here, if a task in a preemptible iSCSI offload
path (such as cxgbit_ddp_reserve() -> cxgbi_ppm_ppods_reserve() ->
ppm_get_cpu_entries()) is migrated from CPU A to CPU B between the two
calls, cpu will hold CPU A while pool will point to CPU B's per-CPU pool.

ppm_get_cpu_entries() will then allocate bits in CPU B's pool->bmap, but
compute the global pagepod index using CPU A's ID:

drivers/net/ethernet/chelsio/libcxgb/libcxgb_ppm.c:ppm_get_cpu_entries() {
	...
	i +=3D cpu * ppm->pool_index_max;
	ppm_mark_entries(ppm, i, count, caller_data);

	return i;
}

Because those bits were never marked in CPU A's pool->bmap, a subsequent
allocation on CPU A can hand out the same global index while it is still
active, overwriting ppm->ppod_data[i] and corrupting in-flight iSCSI DDP
DMA transfers.

Later, when cxgbi_ppm_ppod_release() -> ppm_unmark_entries() releases the
entries, it derives the pool from the global index:

drivers/net/ethernet/chelsio/libcxgb/libcxgb_ppm.c:ppm_unmark_entries() {
	...
	if (i < ppm->pool_rsvd) {
		unsigned int cpu;
		struct cxgbi_ppm_pool *pool;

		cpu =3D i / ppm->pool_index_max;
		i %=3D ppm->pool_index_max;

		pool =3D per_cpu_ptr(ppm->pool, cpu);
		spin_lock_bh(&pool->lock);
		bitmap_clear(pool->bmap, i, count);
	...
}

This clears the bits in CPU A's pool->bmap while permanently leaking the
bits that were set in CPU B's pool->bmap.

Would keeping per_cpu_ptr(ppm->pool, cpu) after raw_smp_processor_id() avoid
this mismatch by ensuring cpu and pool always refer to the same per-CPU pool
even if migration occurs?

([
---
])

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/179241614797.5916.1=
3928836073297916808@whr?part=3D1
