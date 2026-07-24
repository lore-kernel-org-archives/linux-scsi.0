Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B056816DC28
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 11:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784892815; cv=none; b=GFVOscgT+x/gLo7GGbPPZh9VVNRQHck6YMxVE/qVB3plyxlsgRX2UVRWmT7eFuXm8ScXNzBwfmLppIMkedybbgKT5z44+fN77/cfZET1g//0RypEul3oUmggsMq9pzhocj26GQMo9B8H6qmxqqVhfOp2san4OyTRHm98X3DGWBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784892815; c=relaxed/simple;
	bh=qFIE4rJ7kT4Nmw14oHslYPlM2PR59KN1Z075wjwLmi8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=osEA/yNPUS3pYQGC+bonXgji+4cKFICQDG4hzu+lUNtS2tjvUt576+/AsmcgzSv7l8skMGvu9wqd6TyIFRRX0hKT2JLFc69+pXNdjySxNANhzOFv1PgwazhKmIQe6z1bgGJ3rEE1OZa+AMkWJ8h/ZNA2Uhjz6H/wD7XYlMA/TXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bv0MCWWp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bv0MCWWp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 413E91F000E9;
	Fri, 24 Jul 2026 11:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784892813;
	bh=CuN0QmoPsCfwHJ8fQD2a8j5HeXx3/6NF1k7GHaSWqFI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bv0MCWWpdFQKVG5fNpGiUe1zioOlxqng+XtGSIrtEsQuBYtSvBIP2UUmwMgUAiikn
	 EFEPQpDp419bpqTdWYd+AmuzP559+dJTGVrNqDP8z5ui/R4o4WnMCrWpopA9zhHK1i
	 928/M3zw/6KjNbotRetSmIwmVUUtv6dbBHBr/2i0aYaw8tKAx6/1AM6oIGW1+6B3yB
	 zxEXynJbxQ++4WSmuZQ0lprIXqO55Z6Z8Cv2cJV5zHu4tr2W2/HI5BEmupCi7Mm4mu
	 ZfOqDIIRtN9vi/bKJO/UgraelaWkNCAEvJfrIY/C0b8Ztf9fwsVefve9rsT26El0E8
	 Zq6YrWsT31a9g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mpi3mr: Fix potential deadlock in
 mpi3mr_fault_uevent_emit
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chandrakanth Patil" <chandrakanth.patil@broadcom.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260724164630.924288-1-chandrakanth.patil@broadcom.com>
References: <20260724164630.924288-1-chandrakanth.patil@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 11:33:32 +0000
Message-Id: <20260724113333.413E91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Incomplete deadlock fix: kobject_uevent_env() unconditionally perf=
orms GFP_KERNEL allocations
--

--- Patch [1]: [PATCH] mpi3mr: Fix potential deadlock in mpi3mr_fault_ueven=
t_emit ---
commit 7bbe5234e6fc72077b0934f22beb787676fbb5b2
Author: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

mpi3mr: Fix potential deadlock in mpi3mr_fault_uevent_emit
   =20
Change GFP_KERNEL to GFP_NOIO in mpi3mr_fault_uevent_emit() to avoid
a potential deadlock during memory reclaim when the controller is in
a fault state and cannot process I/O.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr=
_fw.c
> index 31b19ed1528e5..e772874ea77ce 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -1289,7 +1289,7 @@ static void mpi3mr_fault_uevent_emit(struct mpi3mr_=
ioc *mrioc)
>  	struct kobj_uevent_env *env;
>  	int ret;
> =20
> -	env =3D kzalloc_obj(*env);
> +	env =3D kzalloc_obj(*env, GFP_NOIO);
>  	if (!env)
>  		return;
> =20

[Severity: High]
This is a pre-existing issue, but does this patch fully prevent the deadlock
it claims to fix?

While the local environment allocation is updated to use GFP_NOIO, this
function later calls kobject_uevent_env():

drivers/scsi/mpi3mr/mpi3mr_fw.c:mpi3mr_fault_uevent_emit() {
    ...
    env =3D kzalloc_obj(*env, GFP_NOIO);
    ...
    kobject_uevent_env(&mrioc->shost->shost_gendev.kobj,
                       KOBJ_CHANGE, env->envp);
}

The kobject_uevent_env() API unconditionally performs multiple memory
allocations using GFP_KERNEL. For example, in lib/kobject_uevent.c:

lib/kobject_uevent.c:kobject_uevent_env() {
    ...
    env =3D kzalloc_obj(struct kobj_uevent_env);
    ...
    devpath =3D kobject_get_path(kobj, GFP_KERNEL);
    ...
}

And also when allocating the netlink broadcast socket buffer:

lib/kobject_uevent.c:alloc_uevent_skb() {
    ...
    skb =3D alloc_skb(len + env->buflen, GFP_KERNEL);
    ...
}

Since these nested calls still rely on GFP_KERNEL, can the deadlock still
occur during memory reclaim when the system is under memory pressure and the
storage controller is in a fault state?

Would it be better to use memalloc_noio_save() and memalloc_noio_restore()
to properly apply NOIO semantics to all nested allocations during the fault
uevent emission?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724164630.9242=
88-1-chandrakanth.patil@broadcom.com?part=3D1
