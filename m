Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3BA486E43
	for <linux-scsi@vger.kernel.org>; Mon,  7 Sep 2026 12:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788782555; cv=none; b=ofKh0IIjLd318E5TjMWyC2vxiUKLLL5SeUWGVeyhHGRK9FTEbROicLLa+qPIPlqozSvhyEpH0TD2RBxOoJfq+6Gm23jkgmu7Y4r3ndxt2sM3e9WpGOrJCimNXLjUSa/schwqJXyGDKWB7C6bnWlhpHiJbHbfCSpeeVbSt3WUEns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788782555; c=relaxed/simple;
	bh=hsi4TY++X018F9yxVTjrD532GUqbNafsKCSZco/TcHA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZmtH5OxOAmeBgEOyxqcJMSVHAiRa4gMQmV0ff6hYwW/dOrsntshK6EuUSzLHeBGjEYkVIHm0tRfbMJFE9S/hTXXCYhd7WMtqKFtthtM3unzmwmrxtE5KuRNXUSQo6ZyKY9dAT9cPBXRRa/gfR9S2ALX7DAAeuVHrSvjQcNBFTE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LtES5EVg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LtES5EVg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A50C1F00A3A;
	Mon,  7 Sep 2026 12:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788782553;
	bh=gMYDulDcCI1WsWJzlTSHqtKdVDDSu9fueC2VpqeVrWU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LtES5EVgEpQc8TkeGduQfnSrOFOuAsGbzjH1GqrvlVHOkbZ+bpa2IUxjbUrEnnm8Z
	 KZnSw65CuEQyPc9g2JfqotoCywtLi2qm7lNxGh6FPCH9A5A/0kBIL4Y8zYq86XP1wJ
	 s2J8udsYZzb1Amyh/YaLWJ02NY1Xxaao+T3wZ+aVgb58NP6p1eBMwSw068/pjo6gyR
	 X760sm83Sv9YhdZNizvpEH+2Vk9O99g/C8T7K43gY/F5bH/crCP6hjw56JHK7+ocoq
	 Ij+uuLcxr853d4F5SVgCKrs2qQiIoCZACKmuNpyXjeHFiKeKhqn/cAIxkltBeeMPoP
	 +gatoxX2dc8xw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 18/27] scsi-multipath: failover handling
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260907105021.1763236-19-john.g.garry@oracle.com>
References: <20260907105021.1763236-1-john.g.garry@oracle.com>
 <20260907105021.1763236-19-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 12:02:33 +0000
Message-Id: <20260907120233.8A50C1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Missing cancellation of `requeue_work` during `scsi_mpath_head` de=
struction leads to Use-After-Free.
- [Low] The custom `bio_list_add_master()` function is an unnecessary and u=
nsafe reinvention of `bio_list_add()`.
--

commit 9189539f81df33ce64a7c19420baf37ebf587b37
Author: John Garry <john.garry@linux.dev>

scsi-multipath: failover handling

This patch implements failover handling for SCSI commands when the target
device's transport is down. It requeues the master bio of each attached
bio when a failover occurs, using scsi_mpath_clone_end_io() to handle
the failover process.

> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index 456351fee4b98..12200664ed676 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c
> @@ -256,10 +256,34 @@ void scsi_mpath_dev_clear_path(struct scsi_mpath_de=
vice *scsi_mpath_dev)
>                 mpath_synchronize(mpath_head);
>  }
> =20
> +static inline void bio_list_add_master(struct bio_list *bl,
> +				struct bio *master_bio)
> +{
> +	if (bl->tail)
> +		bl->tail->bi_next =3D master_bio;
> +	else
> +		bl->head =3D master_bio;
> +	bl->tail =3D master_bio;
> +}

[Severity: Low]
Is it necessary to use this custom list insertion function instead of the
standard bio_list_add()?

This custom bio_list_add_master() function mimics bio_list_add() but omits
the master_bio->bi_next =3D NULL assignment. While master_bio->bi_next is
structurally guaranteed to be NULL in the block layer at this point,
reinventing bio_list_add() without its safety guarantees seems to add
unnecessary complexity and a theoretical risk of singly-linked list
corruption.

> +
>  static void scsi_mpath_clone_end_io(struct bio *clone)
>  {
>  	struct bio *master_bio =3D clone->bi_private;
> =20
> +	if (clone->bi_status && blk_path_error(clone->bi_status)) {
> +		struct mpath_head *mpath_head =3D
> +				master_bio->bi_bdev->bd_disk->private_data;
> +		unsigned long flags;
> +
> +		spin_lock_irqsave(&mpath_head->requeue_lock, flags);
> +		bio_list_add_master(&mpath_head->requeue_list, master_bio);
> +		spin_unlock_irqrestore(&mpath_head->requeue_lock, flags);
> +		bio_put(clone);
> +
> +		mpath_schedule_requeue_work(mpath_head);

[Severity: High]
Can scheduling this requeue work lead to a use-after-free during device
destruction?

While the I/O failover path here is protected for disk devices because
del_gendisk() blocks until the bio completes, non-disk SCSI devices
(like tape drives) do not create an mpath disk. If an ALUA state change
event triggers scsi_mpath_revalidate_paths(), requeue_work can be scheduled.

If the device is hot-removed, scsi_mpath_head_release() frees the
scsi_mpath_head structure without calling
cancel_work_sync(&mpath_head->requeue_work):

drivers/scsi/scsi_multipath.c:scsi_mpath_head_release() {
    ...
    mpath_head_uninit(mpath_head);
    kfree(scsi_mpath_head);
}

If asynchronous mpath_requeue_work() executes after the structure is freed,
it could access the freed mpath_head structure and cause a kernel panic.

> +		return;
> +	}
> +
>  	master_bio->bi_status =3D clone->bi_status;
>  	bio_put(clone);
>  	bio_endio(master_bio);
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907105021.1763=
236-1-john.g.garry@oracle.com?part=3D18
