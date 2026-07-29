Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7FAD27732
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2026 15:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785338044; cv=none; b=AxqA+IUBMZyY4b0pgWoivmYDVHXKWUmhgtQrKFmnXCQfOXVUqnqJWHj3IGabDhNwCXClCLVHer1kJMR4nBfYRNoW9V9/EmGyd6JVbvz8Yp/PkaFYBGkPNXhJPwPhCBUbjJ7yFFh8HMEIc1xld5kliNu+l5/C+qOkQn1+yaXJZWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785338044; c=relaxed/simple;
	bh=zKy7AdZ1SO9cOGWB2lza0Lrzz6FFcHA7UC4CCQ0MM1Y=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Qg0dqnX9zHzgN6mgDbjXMyHFTrEAulZ9CIEEAYy94RO+zaifSezf8sPliuellZj7vOw4QQycvLbIXERD8DDyl6BDA4p/FfGJ2VNElHSYN3Z/tv509UR5JA6AYqV7uRYN8tAH7agIfZlm8SoI4+ZzEoprruYJ23sd8pPaZIjjUw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ojjrl1WY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ojjrl1WY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C1F01F000E9;
	Wed, 29 Jul 2026 15:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785338043;
	bh=1FljH+bEjjiwVzP5rQLsUtc8xfnSY5QxcBmjQtX0TXA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ojjrl1WYivQVfJsiKgMpClSdtIB1YAumM9y/J1Emxw24TbugHV0pm++8VtvqZ0St6
	 oEhfFZsFD6TQM3gXZsfhicXycr0yMQHSH7Zr/EYkRpwwcJxzrLG4IE8GcMIkkZbkyG
	 Dn+C6VChwg3M1H2FE7XZsCQFO5ONoCBTyMol94cdNNPY831SercGa+VtBAvdZS8en8
	 7ff4QYn0rX0/vWbC0UMqTiOC3bqc9+oCE1En6Ot06ObzT9f6w3BhsaaD5mkOQ1SLru
	 h4YCEpcI2dognjDhcR0VQxydG8YFqSH67xGTc7AmmD5XBE5byULNFkmD13i0LUb7zb
	 MPv0Fup5RxEEg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 18/27] scsi-multipath: failover handling
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260729105107.255712-19-john.g.garry@oracle.com>
References: <20260729105107.255712-1-john.g.garry@oracle.com>
 <20260729105107.255712-19-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 29 Jul 2026 15:14:02 +0000
Message-Id: <20260729151403.2C1F01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] List corruption and use-after-free occur due to `bio_list_add_clon=
e()` failing to nullify `master_bio->bi_next`.
- [High] A use-after-free crash occurs because `cancel_work_sync()` is miss=
ing during `mpath_head` teardown.
--

--- Patch [18]: [PATCH v6 18/27] scsi-multipath: failover handling ---
commit d3d46b0330ddb0dc22577a7546f9765b9e1a4651
Author: John Garry <john.garry@linux.dev>

scsi-multipath: failover handling
   =20
For a scsi command which suffers failover, requeue the master bio of each
bio attached to its request.

> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index 12750621a7fc0..6ced89576368c 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c
> @@ -256,10 +256,49 @@ void scsi_mpath_dev_clear_path(struct scsi_mpath_de=
vice *scsi_mpath_dev)
[ ... ]
> +static inline void bio_list_add_clone(struct bio_list *bl,
> +				struct bio *clone)
> +{
> +	struct bio *master_bio =3D clone->bi_private;
> +
> +	if (bl->tail)
> +		bl->tail->bi_next =3D master_bio;
> +	else
> +		bl->head =3D master_bio;
> +	bl->tail =3D master_bio;
> +	bio_put(clone);
> +}

[Severity: High]
Will this leave the newly appended list element improperly terminated?

This custom insertion into requeue_list appears to omit the standard
master_bio->bi_next =3D NULL assignment for the new list tail.

If master_bio->bi_next happens to contain a stale pointer when it is added
here, could iterating the list later result in memory corruption or memory
being accessed after it has been freed?

[ ... ]
> +static void scsi_mpath_clone_end_io(struct bio *clone)
> +{
> +	struct bio *master_bio =3D clone->bi_private;
> +
> +	if (clone->bi_status && blk_path_error(clone->bi_status)) {
[ ... ]
> +		spin_lock_irqsave(&mpath_head->requeue_lock, flags);
> +		bio_list_add_clone(&mpath_head->requeue_list, clone);
> +		spin_unlock_irqrestore(&mpath_head->requeue_lock, flags);
> +
> +		mpath_schedule_requeue_work(mpath_head);

[Severity: High]
Is it possible for the scheduled requeue work item to run after the
mpath_head structure has been torn down?

If a device hot-unplug overlaps with I/O path errors, requeue_work is
scheduled here.

When teardown proceeds to remove the device and drops the last reference,
it appears scsi_mpath_head_release() frees the scsi_mpath_head structure
without calling cancel_work_sync() first.

Could this sequence lead to a delayed kworker executing on deallocated
memory?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260729105107.2557=
12-1-john.g.garry@oracle.com?part=3D18
