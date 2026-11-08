Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794172524;
	b=rMCArm4FEt30yhBOQNOimIohcNDj3ucI4NSptaSo6WPIwQBArtrgODu7yArBTJI/RX1W
	 rYIENU+38pXpeuF9vZh7YKyoCrAYJX7x0taF5LxKvMGOHoqM5kU/7THebvQ99lZSoFxl4
	 rZjoYdEBJe2K8X1sjb2gmV4PUpQ7mGhfyM9F+cjdQAWwKtXDjMISwF5n83bm6bo533N6j
	 BgWiF7NAwamzeCn1rp6rPE0yDjJ0Wxtii+HisZ/oy4cvzF4ADgS5qFhf5CTm3Ughmz9be
	 oNBhrL018vyugCjmBz0yloDyQ7ojYR5kSvmpzuQ0qWUWV/UsA9oM7R/TyCpM5B3JPBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794172524;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=41ovcgGt/hDkagMqctSqqa9jwlzfYOa7jbc6Drc6/4M=;
	b=XmilVo8a9+PN9HkJnIivhTbHhPyJtN/+tl0jlB17dqxLCh0fp7/NZEDbufTucNH3MohP
	 4BQrw5euFJM/5Ov5f5eqhVZpUBpJrBBNpgytAmGYZxEGfbUhAW5c9C/wcwE6o8aAMhbfk
	 84JA07P7SI9Y7mZfH1jfhmCBA4WSTCI6Ww8IiGThJyf55Z1um6LtRoT52KajQX+geTAFI
	 jd00sGhQwDIQ/LR9FEDRG7s0cPQ59K42TTn//4pEGg1/0eDgZ4Rbgcrg4ukRRAl6YRvlP
	 0EDCwBuvWgsuRjG7W11GAF5h+kDovnil95aePdZ/qJ+ZPk+aTL1G4a4iDOoTUiYhPKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BBid533i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A8F606A320;
	Sun,  8 Nov 2026 21:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BBid533i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD97A1F0089F;
	Sun,  8 Nov 2026 21:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794172523;
	bh=41ovcgGt/hDkagMqctSqqa9jwlzfYOa7jbc6Drc6/4M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BBid533i/0/fSOye+R55kjmqgMrjINDkjIcNCWh4xn/S5ob2paYa5xv4HPXymtWh2
	 eGXyN9ja5SLEOZ2e5noRHEZiaI8xja718C4yPB12k1YZs1Ee0nr0bV9GqOvhRokCs/
	 e06a1O8pNP90kOxm26/Qo49fJb5g6l9dFrXjLn+MrED5xUxcJ0UxTwmKvF64QPHd98
	 WbuKUwAWvkulJU1oW9kqL8q8CXtquL7su5IbNUX/IpLcsvmuIALaPH9uxPUdZv2GQX
	 1G6wE23xbCIAcTtLvYtokQyPCKcl40y3CYksVJxfAMze9CwwALNAmRFFnaK4t5b2Tu
	 AHF6mVWvqYvBA==
Message-ID: <sashiko-outbox-204067@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 19/29] scsi-multipath: failover handling
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.garry@linux.dev>, james.bottomley@hansenpartnership.com, mkp@kernel.org
Cc: hare@suse.com, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, snitzer@kernel.org, jmeneghi@redhat.com, bmarzins@redhat.com, dm-devel@lists.linux.dev, hch@lst.de, michael.christie@oracle.com
In-Reply-To: <20261108204733.557995-20-john.garry@linux.dev>
References: <20261108204733.557995-1-john.garry@linux.dev>
 <20261108204733.557995-20-john.garry@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 21:15:22 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [High] scsi-multipath: infinite bio retry loop in
  scsi_mpath_clone_end_io()
- [Medium] scsi: multipath: premature master_bio publish in
  scsi_mpath_clone_end_io()
- [Low] scsi-multipath: commit message describes scsi_cmnd request
  failover
--

commit 8db30403f561c839e4114d28ecdf086eb7458c31
Author: John Garry <john.garry@linux.dev>

scsi-multipath: failover handling

This commit adds failover handling to scsi_mpath_clone_end_io() by
requeueing the master bio onto mpath_head->requeue_list and scheduling
requeue work when a cloned bio fails with blk_path_error().

> Failover occurs when the scsi_cmnd has failed and it is discovered that t=
he
> target scsi_device has transport down.
>=20
> For a scsi command which suffers failover, requeue the master bio of each
> bio attached to its request.

[Severity: Low]
This isn't a bug, but do these first two paragraphs describe an earlier
request-based design?  The patch handles failover in
scsi_mpath_clone_end_io() based on blk_path_error(clone->bi_status) and
does not inspect scsi_cmnd, check whether the scsi_device transport is
down, or iterate over bios attached to a request.

> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index 008bcafe73ad2..4c965650c2bd3 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c
> @@ -262,6 +262,20 @@ static void scsi_mpath_clone_end_io(struct bio *clon=
e)
>  {
>  	struct bio *master_bio =3D clone->bi_private;
> =20
> +	if (clone->bi_status && blk_path_error(clone->bi_status)) {

[Severity: High]
Can requeueing master_bio on every blk_path_error() without checking or
disabling the path cause an infinite bio retry loop?

blk_path_error() returns true for any status other than BLK_STS_NOTSUPP,
BLK_STS_NOSPC, BLK_STS_TARGET, BLK_STS_RESV_CONFLICT, BLK_STS_MEDIUM, and
BLK_STS_PROTECTION.  When a command fails with a status such as
BLK_STS_IOERR (for example, from ABORTED_COMMAND or DID_ERROR) while the
scsi_device remains in SDEV_RUNNING, scsi_mpath_is_disabled() stays false
and mpath_head->current_path[node] is not cleared.  mpath_requeue_work()
then calls submit_bio_noacct(master_bio) -> mpath_bdev_submit_bio() ->
mpath_find_path(), which repeatedly selects the same active path and
resubmits master_bio in an unbounded loop on kblockd.

> +		struct mpath_head *mpath_head =3D
> +				master_bio->bi_bdev->bd_disk->private_data;
> +		unsigned long flags;
> +
> +		spin_lock_irqsave(&mpath_head->requeue_lock, flags);
> +		bio_list_add(&mpath_head->requeue_list, master_bio);
> +		spin_unlock_irqrestore(&mpath_head->requeue_lock, flags);
> +		bio_put(clone);
> +
> +		mpath_schedule_requeue_work(mpath_head);

[Severity: Medium]
Can releasing mpath_head->requeue_lock before bio_put(clone) and
mpath_schedule_requeue_work(mpath_head) cause a use-after-free on
scsi_mpath_head->bio_pool and mpath_head?

Because mpath_bdev_submit_bio() calls submit_bio_noacct(clone) while
current->bio_list is active, mpath_bdev_submit_bio() drops
mpath_head->srcu before __submit_bio_noacct() submits clone to the
underlying queue.  If clone fails during queue entry (such as on a dying
queue) or completes asynchronously after request teardown,
scsi_mpath_clone_end_io() runs without mpath_head->srcu or the underlying
q_usage_counter held.  Once requeue_lock is dropped, an already-running
mpath_requeue_work() on another CPU can dequeue and complete master_bio
 while the last device reference is being dropped:

CPU0                                  CPU1
scsi_mpath_clone_end_io()
  spin_lock_irqsave(&requeue_lock)
  bio_list_add(&requeue_list,
               master_bio)
  spin_unlock_irqrestore(&requeue_lock)
                                      mpath_requeue_work()
                                        bio_list_get(&requeue_list)
                                        submit_bio_noacct(master_bio)
                                          ...
                                            bio_io_error(master_bio)
                                      ...
                                      scsi_mpath_head_release()
                                        bioset_exit(&bio_pool)
                                        kfree(scsi_mpath_head)
  bio_put(clone)  <-- use-after-free
  mpath_schedule_requeue_work(
    mpath_head)   <-- use-after-free

Calling bio_put(clone) before acquiring mpath_head->requeue_lock and
calling mpath_schedule_requeue_work(mpath_head) while holding
mpath_head->requeue_lock avoids this race.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261108204733.5579=
95-1-john.garry@linux.dev?part=3D19
