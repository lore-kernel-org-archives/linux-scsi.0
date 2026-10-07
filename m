Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A93D1C5D72
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 05:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791350260; cv=none; b=hzYcwDIug5whNv5R1aLDWYN5KdBGra64z+K3U3JQrB6kZpjtFLpCdzCt56rftcTj7Zkk6PKBYzkezkkE8ijN8kBPIHAM24BZNTyC7rLJhajAj++HQHaYd0McQaA/sfvKddSvFYu4wwTFrZednSVuIMI4cGav72tVOEmSlw1eSVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791350260; c=relaxed/simple;
	bh=AoRBmdlYucb+wypqNGA0Kg8qifZO2i8MN7Z7k2/LSi4=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=t1Y/Q9qT9qj6/BZUhfvJTeGr/ma8EwLQl7uxz7GlPihE3TsHK0hLFYctxM/rcZKSdNwP3TqscYgyoREcP5EqD3ICQe5AEWGCE8RYfYYfs+OYlPH5wLRY6bssk0zM3cQ5hO5kHKgDZg4NdrDbsdO6qrtcPdSmpavzMxicevPgF2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WvGUouoi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WvGUouoi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D1A1F0089B;
	Wed,  7 Oct 2026 05:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791350259;
	bh=aQyy7GXSPCybtVRqMCsvg/GoyZd5XUGbBcRbiFKyQiI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WvGUouoiZwvRWe/Z0UQuF11rnfQ/oYMmEFgsu5fLahTfWdm3YPqHECxLuwbVnsNmI
	 tvOp7aM6LRathDUSmuJGbnDmDOv/YR7MizUwxqd0Z8nXatbmwA53AytgJ5rugOjdDA
	 IWIcB1y2a2Y7HC2MlOqBS0/Ts5n0BzceOSuYp+8DWZq0RYrtl8EjaaJa9ehtdBeA9Y
	 gJ8hmmO8XXhkBwrTtFxnK2qg9o9d7GFrRCrRwD89iUDHVwMHajLarKpEaoNt5Tc/rV
	 3ykScsxgQPMj6QU7rpe+UVIldqXFliDEGnyv99fHisYkkuENXFFgGmtA9BpcNkKAfE
	 GO338UlNCoHRg==
Message-ID: <sashiko-outbox-162635@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 7/8] scsi: scsi_debug: Improve lock context
 annotations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <765bf3683555f3d7fbe8510cde1eb50d5f6d0c6f.1791349129.git.bvanassche@acm.org>
References: <cover.1791349129.git.bvanassche@acm.org>
 <765bf3683555f3d7fbe8510cde1eb50d5f6d0c6f.1791349129.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 05:17:38 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: deadlock or oops due to unprotected sdebug_no_rwlock modific=
ation
--

commit c129c8944c668498a44ba3a38c88f4214c8204f7
Author: Bart Van Assche <bvanassche@acm.org>

scsi: scsi_debug: Improve lock context annotations

Prepare the scsi_debug driver for enabling compiler-based lock context
analysis:

- Annotate the lock and unlock helper functions with __acquires,
  __releases, __acquires_shared, and __releases_shared.

- Remove sparse __acquire() and __release() calls from the helper
  functions since these mislead the lock context analyzer.

> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 244250ba460bc..2edb70013cbc2 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -4052,42 +4052,43 @@ static inline struct sdeb_store_info *devip2sip(s=
truct sdebug_dev_info *devip,
> =20
>  static inline void
>  sdeb_read_lock(rwlock_t *lock)
> +	__acquires_shared(lock)
> +	__context_unsafe(/*conditional locking*/)
>  {
> -	if (sdebug_no_rwlock)
> -		__acquire(lock);
> -	else
> +	if (!sdebug_no_rwlock)
>  		read_lock(lock);
>  }

[Severity: High]
Does this conditional lock acquisition create a potential deadlock or oops?

The lock acquisition in sdeb_read_lock() is conditional on the unprotected
runtime value of sdebug_no_rwlock. If a user writes to the no_rwlock
attribute while I/O operations are actively being queued or processed, the
variable can change mid-flight.

drivers/scsi/scsi_debug.c:no_rwlock_store() {
	...
	if (kstrtobool(buf, &v))
		return -EINVAL;

	sdebug_no_rwlock =3D v;
	return count;
}

This sysfs store function modifies the global sdebug_no_rwlock variable
concurrently without any locking or quiescent state wait, allowing the race
condition to occur.

> =20
>  static inline void
>  sdeb_read_unlock(rwlock_t *lock)
> +	__releases_shared(lock)
> +	__context_unsafe(/*conditional locking*/)
>  {
> -	if (sdebug_no_rwlock)
> -		__release(lock);
> -	else
> +	if (!sdebug_no_rwlock)
>  		read_unlock(lock);
>  }

[Severity: High]
Does this lock release rely on the same unprotected global variable?

If sdebug_no_rwlock changed to true since acquisition, the unlock is
skipped, causing a permanent deadlock. If changed to false while inside
a lockless critical section, read_unlock() is called without a prior
read_lock(), causing a kernel oops.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1791349129.gi=
t.bvanassche@acm.org?part=3D7
