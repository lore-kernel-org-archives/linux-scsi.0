Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1EB034F24E
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 13:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791813161; cv=none; b=o47NBDeGLjBZbQVSS7UlOnK7qPFc2wze4qq32vgQLFxNmG6O7CiIdt4aHmqF4gVdqSapbrU9WCPUoOnHI4eMJZ5amLwIkpfsJESnS/OiC+MdYkdwRNEZ2NxnRBeQVHF+/1Akmk3wyiP/cFZG6yx4f0/p3Oxc8q9v0iyfuu685zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791813161; c=relaxed/simple;
	bh=jM3657Xt6iZn0PGjEX+7EjwK3RdDBY+7QTU5JF8HN3M=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=DzalE8gpEeO148CrS0rqKdHEwchNscbg3UN2COhH+YMJfLavSST3MnA+WQTyhmPpiTwVUJvF9zHnzo0edJSpK6Rij/BzntmHo/pLkwmWiSJXhuM1ol7FMoYn6XCHzbEZzLKT+FtoHKdRiharJPNBKTHNeLUCYZzfi7Z+RBj3j64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OFX2J5l1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OFX2J5l1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AC471F0089B;
	Mon, 12 Oct 2026 13:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791813159;
	bh=lJWLY2C6khpaI2PxuUnRdHoV2G/maB9xNQ0O1qriVyQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OFX2J5l1LYjY3KKtw0fO0MEos8n1GVkoG582wU9i1N6+s8+9OykUzOYVaJLZSKFML
	 WHS5l9mD/Ce9iSFQFypAjVuxEH5myj5CFNHmnuIhPcMdMV471cks7YkY5Oe1cDDB+6
	 uzvpkxFR/frnSkdeG8S2BYM5MB0bN7syCCvjZHgymPacy7+24xh/soSLBNu+isFKMc
	 7TGkZn9cckKZyXW9iqB/DA9hp5JgmShGGvEeJHQDY7FIA7lQW4HO9jez2NKnbm1Hs7
	 07doL4zy3/5ZjmBXLUtzrFKhifCuQ0O8FDyqHT+yiLGdwy6cT3Ehtu3sXX7zOGJVTA
	 cPySkaE+maXlA==
Message-ID: <sashiko-outbox-168219@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 5/9] zloop: add storage element emulation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261012130121.1902634-6-dlemoal@kernel.org>
References: <20261012130121.1902634-1-dlemoal@kernel.org>
 <20261012130121.1902634-6-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 13:52:39 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:
- [High] block: array underflow in zloop_remove_element() via element_id =
=3D=3D 0
- [High] block: UAF of disk->queue in delayed works during zloop_free_disk()
- [High] block: double-free of elements and other structures in zloop_ctl_a=
dd() error path
- [High] block/zloop: softirq deadlock on wp_lock in process context
- [Medium] block: emulation state inconsistency on partial restore failure
- [Medium] block: zone management commands bypass element removal lock-out
--

commit 1027b8e5f9403129fc0dca5c5db75877129cfc64
Author: Damien Le Moal <dlemoal@kernel.org>

    zloop: add storage element emulation

This commit adds storage element emulation to the zloop driver, simulating
the depopulation feature of SMR disks. It allows mapping zones to specific
storage elements to test offline behaviors and transitions.

> diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
> index 394dc2408ed73..11481577b9cb2 100644
> --- a/drivers/block/zloop.c
> +++ b/drivers/block/zloop.c
> @@ -985,6 +1011,41 @@ static bool zloop_prep_rq(struct zloop_device *zlo,=
 struct request *rq)
>  {
>  	struct zloop_zone *zone =3D &zlo->zones[rq_zone_no(rq)];
>  	bool is_write =3D op_is_write(req_op(rq));
>  	bool ret =3D true;
> =20
>  	spin_lock(&zone->wp_lock);

[Severity: High]
Can this cause a softirq deadlock? The zloop_prep_rq() function is called f=
rom
zloop_queue_rq(), which runs in softirq context. It acquires zone->wp_lock
using a plain spin_lock(). Later in this file, several new process-context
functions (such as zloop_remove_element_work and zloop_restore_conv_zone) a=
lso
acquire zone->wp_lock without disabling softirqs. If a process holding the
lock is preempted by a softirq attempting to queue I/O to the same zone, it
could result in a deadlock.

> =20
> +	if (zlo->nr_elements) {
> +		struct blk_se *se;
> +
> +		/*
> +		 * Check the zone condition and the health state of the storage
> +		 * element serving the zone: do not allow any operation to
> +		 * offline zones or if the storage element serving the zone is
> +		 * being removed, and allow only reads to read-only zones.
> +		 */
> +		if (is_write)
> +			se =3D &zlo->elements[zone->wr_se_id - 1];
> +		else
> +			se =3D &zlo->elements[zone->rd_se_id - 1];
> +		if (READ_ONCE(se->status) =3D=3D BLK_SE_STS_REMOVE_IN_PROGRESS) {
> +			ret =3D false;
> +			goto unlock;
> +		}
> +
> +		if (zone->cond =3D=3D BLK_ZONE_COND_OFFLINE ||
> +		    (zone->cond =3D=3D BLK_ZONE_COND_READONLY && is_write)) {
> +			ret =3D false;
> +			goto unlock;
> +		}
> +	}
> +
[ ... ]
> @@ -1040,11 +1188,19 @@ static blk_status_t zloop_queue_rq(struct blk_mq_=
hw_ctx *hctx,
>  	}
> =20
>  	/*
> -	 * If we need to strongly order zone append operations, set the request
> -	 * sector to the zone write pointer location now instead of when the
> -	 * command work runs.
> +	 * Do not allow commands while the restoration of storage elements is
> +	 * in progress.
>  	 */
> -	if (zlo->ordered_zone_append && req_op(rq) =3D=3D REQ_OP_ZONE_APPEND) {
> -		if (!zloop_set_zone_append_sector(rq))
> +	if (READ_ONCE(zlo->restore_in_progress))
> +		return BLK_STS_IOERR;
> +
> +	switch (req_op(rq)) {
> +	case REQ_OP_READ:
> +	case REQ_OP_WRITE:
> +	case REQ_OP_ZONE_APPEND:
> +		if (!zloop_prep_rq(zlo, rq))
>  			return BLK_STS_IOERR;
> +		break;
> +	default:
> +		break;
>  	}

[Severity: Medium]
Do zone management commands bypass the element removal lock-out? Operations
like REQ_OP_ZONE_RESET are not handled by zloop_prep_rq() here, meaning they
do not check if the storage element is in the BLK_SE_STS_REMOVE_IN_PROGRESS
state. Could this allow them to proceed on zones belonging to a storage
element that is actively undergoing depopulation?

[ ... ]
> +static void zloop_remove_element_work(struct work_struct *work)
> +{
> +	struct zloop_device *zlo =3D container_of(work, struct zloop_device,
> +						remove_element_work.work);
> +	struct blk_se *se, *paired_se =3D NULL;
> +	enum blk_zone_cond cond;
> +	struct zloop_zone *zone;
> +	unsigned int memflags, i;
> +
> +	mutex_lock(&zlo->stor_elements_lock);
> +
> +	/* Wait for all IOs to complete. */
> +	memflags =3D blk_mq_freeze_queue(zlo->disk->queue);
> +	blk_mq_unfreeze_queue(zlo->disk->queue, memflags);

[Severity: High]
Does this worker access the queue after it may have been freed? When the di=
sk
is removed, disk_release() drops the queue reference and schedules it for R=
CU
free, followed by a call to zloop_free_disk() which calls
cancel_delayed_work_sync(). If this worker executes during that time, could=
 it
result in a use-after-free on zlo->disk->queue here?

[ ... ]
> +static int zloop_remove_element(struct gendisk *disk, unsigned int eleme=
nt_id)
> +{
> +	struct zloop_device *zlo =3D disk->private_data;
> +	struct blk_se *se, *paired_se =3D NULL;
> +	unsigned int nr_remove =3D 1;
> +	int ret =3D 0;
> +
> +	if (zlo->stor_elements =3D=3D ZLOOP_STOR_ELEMENTS_NONE)
> +		return -EOPNOTSUPP;
> +
> +	if (element_id > zlo->nr_elements)
> +		return -EINVAL;
> +
> +	mutex_lock(&zlo->stor_elements_lock);
> +
> +	if (zlo->remove_element_id || READ_ONCE(zlo->restore_in_progress)) {
> +		ret =3D -EBUSY;
> +		goto unlock;
> +	}
> +
> +	/*
> +	 * Get the element to remove. If it is already removed, we have nothing
> +	 * to do.
> +	 */
> +	se =3D &zlo->elements[element_id - 1];

[Severity: High]
Is it possible for element_id to be 0 here? The bounds check above prevents
element_id > zlo->nr_elements, but does not check for element_id =3D=3D 0.
If element_id is 0, element_id - 1 could underflow and result in an
out-of-bounds array access on zlo->elements.

[ ... ]
> +static void zloop_restore_elements_work(struct work_struct *work)
> +{
> +	struct zloop_device *zlo =3D container_of(work, struct zloop_device,
> +						restore_elements_work.work);
> +	struct zloop_zone *zone;
> +	struct blk_se *se;
> +	unsigned int memflags, i;
> +	enum blk_se_status sts;
> +	int ret =3D 0;
> +
> +	mutex_lock(&zlo->stor_elements_lock);
> +
> +	/* Wait for all IOs to complete. */
> +	memflags =3D blk_mq_freeze_queue(zlo->disk->queue);
> +	blk_mq_unfreeze_queue(zlo->disk->queue, memflags);
> +
> +	/* Reset all zones. */
> +	for (i =3D 0, zone =3D zlo->zones; i < zlo->nr_zones; i++, zone++) {
> +		if (test_bit(ZLOOP_ZONE_CONV, &zone->flags)) {
> +			zloop_restore_conv_zone(zlo, zone);
> +			continue;
> +		}
> +		ret =3D zloop_restore_seq_zone(zlo, zone);
> +		if (ret)
> +			break;
> +	}
> +
> +	/*
> +	 * If we had an error, maintain all elements as removed instead of
> +	 * using the restore error status.
> +	 */
> +	if (ret)
> +		sts =3D BLK_SE_STS_REMOVED;
> +	else
> +		sts =3D BLK_SE_STS_OK;
> +
> +	/* Restore all removed elements. */
> +	for (i =3D 0, se =3D zlo->elements; i < zlo->nr_elements; i++, se++) {
> +		if (READ_ONCE(se->status) =3D=3D BLK_SE_STS_RESTORE_IN_PROGRESS)
> +			WRITE_ONCE(se->status, sts);
> +	}

[Severity: Medium]
If zloop_restore_seq_zone() fails and breaks the loop, does this leave the
already-processed zones in the BLK_ZONE_COND_EMPTY state? Since the element
status reverts to BLK_SE_STS_REMOVED on failure, this mismatch might trick
zloop_prep_rq() into allowing I/O to those EMPTY zones, even though their
storage element is officially removed.

[ ... ]
>  static void zloop_free_disk(struct gendisk *disk)
>  {
>  	struct zloop_device *zlo =3D disk->private_data;
>  	unsigned int i;
> =20
> +	cancel_delayed_work_sync(&zlo->remove_element_work);
> +	cancel_delayed_work_sync(&zlo->restore_elements_work);
> +
>  	blk_mq_free_tag_set(&zlo->tag_set);
> =20
>  	for (i =3D 0; i < zlo->nr_zones; i++) {
> @@ -1019,15 +1434,24 @@ static void zloop_free_disk(struct gendisk *disk)
> =20
>  	fput(zlo->data_dir);
>  	destroy_workqueue(zlo->workqueue);
> +	kfree(zlo->elements);
>  	kfree(zlo->base_dir);
>  	kvfree(zlo);
>  }
[ ... ]
> @@ -1384,6 +1915,8 @@ static int zloop_ctl_add(struct zloop_options *opts)
>  	kfree(zlo->base_dir);
>  out_destroy_workqueue:
>  	destroy_workqueue(zlo->workqueue);
> +out_destroy_storage_elements:
> +	kfree(zlo->elements);
>  out_free_idr:
>  	mutex_lock(&zloop_ctl_mutex);
>  	idr_remove(&zloop_index_idr, zlo->id);
>  	mutex_unlock(&zloop_ctl_mutex);
>  out_free_dev:
>  	kvfree(zlo);

[Severity: High]
Does this error path cause a double-free? If add_disk() fails, the code jum=
ps
to out_cleanup_disk, which calls put_disk(zlo->disk). This drops the final
reference and invokes zloop_free_disk(), successfully freeing zlo->elements,
the workqueue, and zlo itself. Continuing the fall-through then explicitly
calls kfree(zlo->elements) and kvfree(zlo) again on the already-freed memor=
y.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012130121.1902=
634-1-dlemoal@kernel.org?part=3D5
