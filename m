Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117B0490C0C;
	Thu, 27 Aug 2026 16:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787847899; cv=none; b=EYYhp1N9MWEMn+sNH3Q4lKuXk7VCbWboJjRu7WY5JAYsMUBSH/0JIJrB+E4C1mJhToGmN7KoD7OHOm8qjn4eTyeIeqsOr2k9nZp3KCOxmzNxFqXvSdiGP8ffW0cJMU29RwgEixVUww8EBB1zJB66hQ9pITW4bI7eg3LVLKw28h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787847899; c=relaxed/simple;
	bh=AAaAhpDY4KAM1i06B/ju3TrttQ5WOn58RzSf14pscyo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ijKg3zlBwXTvkx1wSQi0L9CxQelYQci9jZFY9Zwna9V7LLO+AJDfCnfihWqHywDc6+K9E9/VmznCnUK6RS4W347/YMNGSfetVvuEI9ExK4jLwhvVNKJ05XHU0VwdbPEH6PBvaEXlW6bNkqbARCtnNUOyIDR0v8t5LFB/Fyts0mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gJYsD68y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gJYsD68y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D0D21F00A3A;
	Thu, 27 Aug 2026 16:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787847896;
	bh=KcbZDW6Fi62cdlu1LueiTwmxFeY2s3DoNR8fleT0L+k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gJYsD68yKSCAAhtzNLtxrKYU4wdWR5pxNiTpyCztngsnxj5d5f8Ix+ix3K9gW5E/X
	 lYK8fud5WZLZQnQrUPKhL3vncYZtJP1I89Nc1MDH9ZMaS92DRRx3J1RVay9MxTtipS
	 jta4qGjl8pUtUqHpAMEBFT6qtVZfjNhOezVN+sAPzWQ0ZHjrrgIzEVpQ23N7Bp7AX+
	 YEl/D/6CeJTR5h8/nzd9vT9K93yyk8MOcM7D53tQYtQLi0yFltKb3NG8QV8F5Iwk2G
	 krK1yOvdsQwBrHX4YS0IcVqo8aotGh16lQY5hkk0SL/SIiYYoFf2Kn/EqytG90MNAC
	 2tRN+3AbtAu8A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 08/11] block: add /dev/blk-crypto-proxy for host-side
 virtio-blk inline encryption
Reply-To: sashiko-reviews@lists.linux.dev
To: "Linlin Zhang" <linlin.zhang@oss.qualcomm.com>
Cc: conor+dt@kernel.org, robh@kernel.org, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org
In-Reply-To: <20260827160806.1295313-9-linlin.zhang@oss.qualcomm.com>
References: <20260827160806.1295313-1-linlin.zhang@oss.qualcomm.com>
 <20260827160806.1295313-9-linlin.zhang@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 27 Aug 2026 16:24:55 +0000
Message-Id: <20260827162456.1D0D21F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 7 potential issue(=
s) to consider:
- [Critical] Kernel crash when calling import_iovec with iov_cnt =3D=3D 1 a=
nd a NULL iov pointer.
- [High] Sleeping in Atomic Context inside bcp_ioctl_bind_context.
- [High] UAPI mismatch causes silent data corruption for 32-bit compat user=
space processes.
- [High] Pinned user pages are leaked unconditionally on every successful o=
r failed bio submission.
- [High] The driver passes guest-provided data_unit_size_bits directly to h=
ardware without validating it against the block device's supported crypto p=
rofile.
- [High] Missing little-endian to host-endian conversion for arg.dun.
- [Low] Dead error handling path for bio_alloc() using GFP_KERNEL.
--

commit 654e63cd96fb66a7cdbe2a3c22748ad74f166ab2
Author: linlzhan <linlin.zhang@oss.qualcomm.com>

block: add /dev/blk-crypto-proxy for host-side virtio-blk inline encryption
   =20
This patch introduces a misc character device to allow userspace virtio-blk
backends to submit inline-encrypted block I/O on behalf of virtual machines.
It maps virtual keyslots to physical hardware keyslots and submits bios
synchronously.

> diff --git a/drivers/block/blk-crypto-proxy.c b/drivers/block/blk-crypto-=
proxy.c
> index 0000000000000..60722884dbcd7
> --- /dev/null
> +++ b/drivers/block/blk-crypto-proxy.c
[ ... ]
> @@ -180,11 +180,11 @@ static long bcp_ioctl_bind_context(struct file *fil=
e,
> +	/*
> +	 * get_guest_id() may sleep; call it before taking bind_lock.
> +	 */
> +	rcu_read_lock();
> +	hv_ops =3D rcu_dereference(g_hypervisor_ops);
> +	if (!hv_ops) {
> +		rcu_read_unlock();
> +		return -EOPNOTSUPP;
> +	}
> +	ret =3D hv_ops->get_guest_id(arg.vm_fd, &guest_id);

[Severity: High]
Since the comment explicitly mentions that get_guest_id() may sleep, is it
safe to call it while holding the RCU read lock? Sleeping in an RCU
read-side critical section typically leads to scheduling while atomic
warnings or panics.

> +	rcu_read_unlock();
[ ... ]
> @@ -411,10 +411,10 @@ static long bcp_ioctl_submit_io_by_vslot(struct fil=
e *file,
[ ... ]
> +	memset(dun, 0, sizeof(dun));
> +	dun[0] =3D arg.dun;

[Severity: High]
Does this assignment need a little-endian to host-endian conversion? The
UAPI specifies arg.dun as little-endian, but it is being assigned verbatim
to dun[0] which the crypto subsystem expects to be host-endian. On a
big-endian system, this might result in an incorrect data unit number and
silent decryption failures.

> +
> +	slot.phy_slot            =3D phy_slot;
> +	slot.data_unit_size_bits =3D arg.data_unit_size_bits;

[Severity: High]
Is it safe to pass the guest-provided data_unit_size_bits directly into the
crypto slot configuration without validating it against the block device's
supported crypto profile? For slot-based bios, the block layer skips
blk_crypto_config_supported_natively(), meaning an invalid unit size could
be pushed directly to the hardware driver.

> +
> +	align =3D 1ULL << arg.data_unit_size_bits;
[ ... ]
> +	/*
> +	 * Import the caller's iovec once.  import_iovec() validates every
> +	 * segment with access_ok(), returns the total byte count, and takes a
> +	 * private kernel copy that eliminates TOCTOU from a guest mutating its
> +	 * own iovec array mid-ioctl.
> +	 */
> +	ret =3D import_iovec(arg.direction =3D=3D BCP_DIR_READ ? ITER_DEST : IT=
ER_SOURCE,
> +			   (const struct iovec __user *)u64_to_user_ptr(arg.iov_ptr),
> +			   arg.iov_cnt, 0, &iov, &iter);

[Severity: Critical]
Can this crash if a userspace process provides iov_cnt =3D=3D 1 and a NULL
iov_ptr? The fast_segs parameter is set to 0 and iov is initialized
to NULL. When nr_segs is 1, import_iovec() will clear the iov pointer and
pass it to copy_iovec_from_user(), which directly writes to the NULL pointe=
r.

[Severity: High]
Does this also cause an issue for 32-bit compat userspace processes? The
UAPI bcp_iovec is exactly 16 bytes. However, when in_compat_syscall() is
true, import_iovec() parses the input using copy_compat_iovec_from_user(),
which assumes 8-byte array elements (struct compat_iovec). This UAPI
mismatch could lead to memory corruption or misdirected block I/O.

> +	if (ret < 0)
> +		return ret;
[ ... ]
> +	/*
> +	 * Reject an out-of-range DUN: slot-based bios skip
> +	 * bio_crypt_check_alignment(), so an overflow would silently truncate
> +	 * in the hardware DUN field rather than error out.
> +	 */
> +	{
> +		u64 total_units =3D total_bytes >> arg.data_unit_size_bits;
> +		u64 max_dun_used, dun_limit;
> +
> +		if (check_add_overflow(arg.dun, total_units - 1, &max_dun_used)) {

[Severity: High]
Could this overflow check yield incorrect results on big-endian hosts? It
performs host-endian arithmetic directly on arg.dun, which is a little-endi=
an
value according to the UAPI.

> +			ret =3D -EINVAL;
> +			goto out;
> +		}
[ ... ]
> +		if (bio_bytes =3D=3D 0)
> +			break;
> +
> +		bio =3D bio_alloc(bdev, pages_used,
> +				arg.direction =3D=3D BCP_DIR_WRITE ?
> +					REQ_OP_WRITE : REQ_OP_READ,
> +				GFP_KERNEL);
> +		if (!bio) {
> +			ret =3D -ENOMEM;
> +			goto out;
> +		}

[Severity: Low]
Can this allocation ever fail? bio_alloc() is backed by a mempool and is
called here with GFP_KERNEL (which implies __GFP_DIRECT_RECLAIM). Standard
block subsystem guidelines suggest this failure path is unreachable. Treati=
ng
it as reachable can lead to incorrect assumptions about memory allocation
behaviors.

> +		bio->bi_iter.bi_sector =3D arg.sector + (bytes_done >> SECTOR_SHIFT);
[ ... ]
> +		remaining_before =3D iov_iter_count(&iter);
> +		iov_iter_truncate(&iter, bio_bytes);
> +		ret =3D bio_iov_iter_get_pages(bio, &iter, 0, 0);
> +		if (ret < 0) {
> +			bio_put(bio);
> +			goto out;
> +		}
> +		if (iov_iter_count(&iter) !=3D 0) {
> +			/*
> +			 * The lookahead verified bio_bytes fits in BIO_MAX_VECS;
> +			 * if bio_iov_iter_get_pages() stopped early, its page
> +			 * accounting disagreed with bcp_iov_pages_for_bytes().
> +			 */
> +			bio_put(bio);
> +			ret =3D -EIO;
> +			goto out;
> +		}

[Severity: High]
When iov_iter_count is not zero, bio_put() is called, but it does not
implicitly release the pages pinned by bio_iov_iter_get_pages(). Should this
error path explicitly call bio_release_pages(bio, false) to prevent memory
leaks?

> +		iov_iter_reexpand(&iter, remaining_before - bio_bytes);
[ ... ]
> +		bio_crypt_set_ctx_by_slot(bio, &slot, dun, GFP_KERNEL);
> +
> +		ret =3D submit_bio_wait(bio);
> +		bio_put(bio);
> +		if (ret)
> +			goto out;

[Severity: High]
Similar to the error path above, should there be a call to
bio_release_pages(bio, false) before or after bio_put() finishes? Otherwise
the pinned user pages appear to be leaked unconditionally for every bio
submitted.

> +
> +		/*

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260827160806.1295=
313-1-linlin.zhang@oss.qualcomm.com?part=3D8
