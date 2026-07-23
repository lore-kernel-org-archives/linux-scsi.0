Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13F8439F84
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 10:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784802771; cv=none; b=i30Jn8npDuvraVhD3UJ4PsoXwb1HtxMSKP6e+ERT531oyE5Y0yPvDRF59UsPiVQSlZXPQI/2ipEbNYxULsq7LzUiXR+S2TSfGK4vy9YOZA3zQigniU2oB9ftKmEmGSXFFJ9OH12JbG/3yohcwazz9/2UDb+CzN2D2rMd15+OzuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784802771; c=relaxed/simple;
	bh=xAbZIv4QD9/6yRHpQKf67hGWCGYIE5WEyVkLw7kUSuw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=drzaBKOdOLQRHQnJOsaaADzAYWizJwLdcGkKqDMN5Jr8n3Tx/FaKJGUhtOeRsxSqMQpQbLMbWfbr4Q41bOmos2ZSmiVpeSgQyHJvuVjejq13IrVRTlbQk2OJv1TuRChOcFfWVQ0th7a72FqnqnpGU33vkrzNIAoIpN2CDyone2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AFSTU8Nh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AFSTU8Nh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF5C61F000E9;
	Thu, 23 Jul 2026 10:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784802765;
	bh=8Own+P+QqWdpA7zAh44r4jHeSg7gC0YuFz59Y0jArTY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AFSTU8Nhl4Bbe0AfUnGUzatTyyRHMcCI6zOjbKeOgujsUT4Qh51k2wsEF9QH9RlIB
	 t1iWNztv5H1JTC/cHHH6d9c0z3/zIneMZcEMthw9QeBCNjp64+bSNRUvxCrprAKe4N
	 YCv1CbRXJn89bi/7KWg6RJe8vzHUp3OeCvbxFl8o4Vc3BbLt8eamLlkzryAxl2G3EO
	 OwRJ87Ax1ckFGNH7/T4Sh4UXPYi7p1vF5ZmESiCOmLL/O9ovl8FqUtAfOjjPfqyMQa
	 8ovFCkdsYSLwggt2NGfDkUU43ehyr5KT8ZLm7l4QdcUxhOjhrFnd0deO9aSXBgFkxK
	 eOPEod33VGnYg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 21/28] scsi-multipath: add
 scsi_mpath_{start,end}_request()
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723093627.2327456-22-john.g.garry@oracle.com>
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
 <20260723093627.2327456-22-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 10:32:41 +0000
Message-Id: <20260723103244.DF5C61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Critical] Unconditional dereference of `req->bio` and `req->bio->bi_priv=
ate` leads to a kernel panic for requests lacking a valid block layer bio s=
etup (like passthrough or empty flushes).
- [High] Resource leaks and state corruption due to multipath flags not bei=
ng preserved across request requeue operations.
- [High] Use-after-free of the master bio structure (`master->bi_bdev`) aft=
er request completion.
--

--- Patch [21]: [PATCH v4 21/28] scsi-multipath: add scsi_mpath_{start,end}=
_request() ---
commit b237b1f6dbfe052243ff199e6fb756310c17d07b
Author: John Garry <john.garry@linux.dev>

scsi-multipath: add scsi_mpath_{start,end}_request()

Add scsi_mpath_{start,end}_request() to handle updating private multipath
request data, like nvme_mpath_{start,end}_request().

> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index e566d47199fcc..6c50fdde70d65 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c
> @@ -555,6 +555,59 @@ void scsi_mpath_put_head(struct scsi_mpath_head *scs=
i_mpath_head)
>  }
>  EXPORT_SYMBOL_GPL(scsi_mpath_put_head);
> =20
> +void scsi_mpath_start_request(struct request *req)
> +{
> +	struct scsi_cmnd *scmd =3D blk_mq_rq_to_pdu(req);
> +	struct scsi_device *sdev =3D scmd->device;
> +	struct scsi_mpath_device *scsi_mpath_dev =3D sdev->scsi_mpath_dev;
> +	struct scsi_mpath_head *scsi_mpath_head =3D
> +				scsi_mpath_dev->scsi_mpath_head;
> +	struct bio *clone =3D req->bio;
> +	struct bio *master =3D clone->bi_private;

[Severity: Critical]
Are we dereferencing a potentially invalid bio here?

If a request lacks a bio (like an empty flush) or is a passthrough request,
req->bio could be NULL, which would cause a panic when dereferencing
clone->bi_private.

> +
> +	if (mpath_qd_iopolicy(&scsi_mpath_head->iopolicy) &&
> +	    !(scmd->flags & SCMD_MPATH_CNT_ACTIVE)) {
> +		struct Scsi_Host *shost =3D sdev->host;
> +
> +		atomic_inc(&shost->mpath_nr_active);
> +		scmd->flags |=3D SCMD_MPATH_CNT_ACTIVE;
> +	}
> +
> +	if (!blk_queue_io_stat(master->bi_bdev->bd_queue) || blk_rq_is_passthro=
ugh(req) ||

[Severity: Critical]
Is the safety check for passthrough requests too late?

The master->bi_bdev pointer is dereferenced in the blk_queue_io_stat() check
before the blk_rq_is_passthrough(req) condition is evaluated.

Could this trigger a NULL pointer dereference for passthrough commands where
the bio wasn't cloned by multipath?

> +	    (scmd->flags & SCMD_MPATH_IO_STATS))
> +		return;
> +
> +	scmd->flags |=3D SCMD_MPATH_IO_STATS;
> +	scmd->start_time =3D bdev_start_io_acct(master->bi_bdev, req_op(req),
> +				jiffies);
> +	scmd->start_bytes =3D blk_rq_bytes(req);
> +}
> +
> +bool scsi_mpath_end_request(struct request *req, blk_status_t error,
> +				unsigned int nr_bytes)
> +{
> +	struct scsi_cmnd *scmd =3D blk_mq_rq_to_pdu(req);
> +	struct scsi_device *sdev =3D scmd->device;
> +	struct bio *clone =3D req->bio, *master =3D clone->bi_private;
> +
> +	if (blk_update_request(req, error, nr_bytes))
> +		return true;
> +
> +	if (scmd->flags & SCMD_MPATH_CNT_ACTIVE) {
> +		struct Scsi_Host *shost =3D sdev->host;
> +
> +		atomic_dec_if_positive(&shost->mpath_nr_active);
> +	}
> +
> +	if (!(scmd->flags & SCMD_MPATH_IO_STATS))
> +		return false;
> +	bdev_end_io_acct(master->bi_bdev, req_op(req),

[Severity: High]
Does this code introduce a use-after-free of the master bio structure?

When blk_update_request() finishes a request, it returns false and invokes
bio_endio(). For a cloned bio, this completes the master bio, which the
upper layers (like the filesystem) may immediately free.

Could accessing master->bi_bdev here trigger memory corruption or kernel
panics if the bio structure has already been freed?

> +			 scmd->start_bytes >> SECTOR_SHIFT,
> +			 scmd->start_time);
> +
> +	return false;
> +}

[ ... ]

> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index 8ecfb94049db5..3ff425c5f1e56 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -60,6 +60,8 @@ struct scsi_pointer {
>  #define SCMD_FAIL_IF_RECOVERING	(1 << 4)
>  /* flags preserved across unprep / reprep */
>  #define SCMD_PRESERVED_FLAGS	(SCMD_INITIALIZED | SCMD_FAIL_IF_RECOVERING)
> +#define SCMD_MPATH_IO_STATS	(1 << 5)
> +#define SCMD_MPATH_CNT_ACTIVE	(1 << 6)

[Severity: High]
Should these new multipath state flags be included in SCMD_PRESERVED_FLAGS?

In scsi_queue_rq(), cmd->flags is masked with SCMD_PRESERVED_FLAGS before
dispatching:

drivers/scsi/scsi_lib.c:scsi_queue_rq() {
    ...
    cmd->flags &=3D SCMD_PRESERVED_FLAGS;
    ...
    if (is_mpath_request(req))
        scsi_mpath_start_request(req);
    ...
}

If a command fails to dispatch and is requeued, the flags would be cleared.

Could this cause scsi_mpath_start_request() to erroneously increment the
host's active request counter (mpath_nr_active) multiple times, leading to a
permanent leak when the request finally completes and only decrements it on=
ce?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723093627.2327=
456-1-john.g.garry@oracle.com?part=3D21
