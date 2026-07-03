Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE52331EB6
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2026 10:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783075757; cv=none; b=RJM5qibtRzpJJmBSeLkBC3Khj4Xr6EP7tROZPW0MRbEknVsy4iMO9de3peCnpgjK9ZGCmx+XioDuCoScl/MtX/rATgvFmByl6QayHGCowCvSa1Kq3PAfCgXULj8O6yYwZaBoypch9JQt66T5dwJQzu9rJ1p6hOcoVfnSPqjWKDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783075757; c=relaxed/simple;
	bh=KMNAOBsdW7VszHV/dB2OPDm//huZtrLX0s7OgzK293M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=EKHEmGTVnQboULGzdpsfekc7q6nRKhcH4OT0G8PdvkRW1xJlI3/0ZqsqepLr6LQHlMGShKkcU59p5kTIuatZBbGKc3ZAcQ5lZXqQERtf37BcbhApGUYQYZM2wdo883cRuhGaBPo2ilsndPBu5f1M76Jjld3kwuDVEQOro5OCReg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NnXPTX7o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NnXPTX7o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EBEA1F000E9;
	Fri,  3 Jul 2026 10:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783075755;
	bh=0ohOmmhKeR8I3Vx4CzDLogop48qwzi+u7c4/bf2d0K4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NnXPTX7oQ28P1+Wm+9rEzQ0Gnonj6jRahcWcylZBxdp7ZVj+zRao9/D0Z1S0HcTC8
	 dL3zK67mu7+7PAvDTjUGB05bcajFa/79Pl11pulll97VlyJKjGkkSMi+chPRc/Aw+q
	 g4Ruga1ISZc6IBZ0xQA/WOwM9qiJHSVxDIMn6GOYIX76a0RFPAyQReC6mx7fJlf0EQ
	 scOU/iBX4KS+wFgCKG1Gm5hqz653Nhzz7JXzxmnRMj40yA4wapNwD0ZWWFwCqDeTtJ
	 Hxs7KAL4nZBmtdil1E+aQ94hJnVXYpnEM9sy9nNZJFzMIljqTEnHAXMx9eC6Npfbps
	 fURcEmpJAnVyQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 04/13] libmultipath: Add bio handling
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260703102918.3723667-5-john.g.garry@oracle.com>
References: <20260703102918.3723667-1-john.g.garry@oracle.com>
 <20260703102918.3723667-5-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 10:49:14 +0000
Message-Id: <20260703104915.5EBEA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] TOCTOU race in `mpath_remove_disk` can strand a bio on `requeue_li=
st`, causing `del_gendisk` to deadlock.
- [Medium] The `trace_block_bio_remap` tracepoint is called with the wrong =
device argument for `old_dev`, causing the trace event to emit identical de=
vices for source and destination.
--

commit 1f99dbf217347b66f1710f734eac617209a4e8c6
Author: John Garry <john.g.garry@oracle.com>

libmultipath: Add bio handling

This commit adds per-path bio submission support and failover requeuing
logic for libmultipath. It introduces mechanisms similar to NVMe multipath
to clone bios and submit them with the REQ_MPATH flag.

> diff --git a/lib/multipath.c b/lib/multipath.c
> index 21f7ffdb22d60..81e737c1ce469 100644
> --- a/lib/multipath.c
> +++ b/lib/multipath.c

[ ... ]

> @@ -243,6 +242,81 @@ static struct mpath_device *mpath_find_path(struct m=
path_head *mpath_head)
> +static void mpath_bdev_submit_bio(struct bio *bio)
> +{

[ ... ]

> +		bio_set_dev(bio, mpath_device->disk->part0);
> +		/*
> +		 * Use BIO_REMAPPED to skip bio_check_eod() when this bio
> +		 * enters submit_bio_noacct() for the per-path device. The EOD
> +		 * check already passed on the multipath head.
> +		 */
> +		bio_set_flag(bio, BIO_REMAPPED);
> +		bio->bi_opf |=3D REQ_MPATH;
> +		trace_block_bio_remap(bio, disk_devt(mpath_device->disk),
> +				      bio->bi_iter.bi_sector);

[Severity: Medium]
Does this tracepoint call incorrectly use the target path device instead of
the original head device?=20

By passing disk_devt(mpath_device->disk), it seems the trace event will log
the new path device as both the source and destination, which might break
trace analysis. Should this be disk_devt(mpath_head->disk)?

> +		submit_bio_noacct(bio);
> +	} else if (mpath_available_path(mpath_head)) {
> +		dev_warn_ratelimited(dev, "no usable path - requeuing I/O\n");
> +
> +		spin_lock_irq(&mpath_head->requeue_lock);
> +		bio_list_add(&mpath_head->requeue_list, bio);
> +		spin_unlock_irq(&mpath_head->requeue_lock);
> +		atomic_long_inc(&mpath_head->requeue_no_usable_path_cnt);
> +	} else {

[ ... ]

> @@ -314,11 +389,34 @@ static void multipath_partition_scan_work(struct wo=
rk_struct *work)
>  void mpath_remove_disk(struct mpath_head *mpath_head)
>  {
>  	if (test_and_clear_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags)) {
>  		struct gendisk *disk =3D mpath_head->disk;
> =20
> +		/*
> +		 * requeue I/O after MPATH_HEAD_DISK_LIVE has been cleared
> +		 * to allow multipath to fail all I/O.
> +		 */
> +		mpath_schedule_requeue_work(mpath_head);
> +
>  		mpath_synchronize(mpath_head);

[Severity: High]
Could scheduling the requeue work before synchronizing SRCU cause a deadlock
during device removal?

If mpath_bdev_submit_bio() checks mpath_available_path() and sees the disk
is live, but then gets preempted before taking the requeue_lock,
mpath_remove_disk() might clear MPATH_HEAD_DISK_LIVE and schedule the
requeue worker.

The worker would run and find the requeue_list empty. When the submitter
wakes up and adds the bio, it will be stranded on the requeue_list.

Because the bio holds a q_usage_counter reference, will del_gendisk()
hang forever waiting for the queue to freeze?

>  		del_gendisk(disk);
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703102918.3723=
667-1-john.g.garry@oracle.com?part=3D4
