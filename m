Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFBBC38F934
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jul 2026 15:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785165960; cv=none; b=MxW5BW60OfGFQflC4L0XJ4qmyGhkC7/RPojZgbUYxetQl9y+eGH51sbH4KyAR+Me86uYB94C2dFrI7DquhzAFclarYiG0aW7iUGdFpfXncH+1+OZ5vajDSXKv8DsBhiP6DWYEOx15GnhViSX3h7GpwR8RIkBpFK+OP2CvoJmM+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785165960; c=relaxed/simple;
	bh=YLzPNPnKWog4nETqHerjuK8B/G/zRcZr0cISQ3io1Oo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=D8CPpK//iySmUKBobyQwETKc5RlatsWJbuRVbt15/I56fHranOPzXXqwS3W3NjulGDFSlKs1HmW63MLYAzuYLvytk/MfGjl5H9i5b1CFnm/QN41uGVZvYxAd79n6Yj5UvE7GqjDip/SGpq8szxzrMC+cJsv/3xXBTS4HDMfrljM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AoOQxyWq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AoOQxyWq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3565D1F000E9;
	Mon, 27 Jul 2026 15:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785165958;
	bh=bW25N40bBL+n4TI3y9gcsUg824fZibS7qYRFLc3piQU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AoOQxyWqvg+ElY0xA/PKBBvxQ/Qp9dwGp2DCsYsa+wknzc5gXXZJugtmjONp+HauY
	 /WJ01yyGjYu1tKuCnBBNp6HNICFFIYK1OpH0cb3GY9+K4TKyuxA2TQzkEEMjldhptX
	 731VKeACo/oGimQhraFVhyvk4pcaBZud/UGLlddzSzAe2QeRVJMrR9mfyBxFN+obnF
	 LW16MIFH711p5VQJWAeWbo2+IGfSpUoPo2fCp5f4CZgNIqTgNQ7ZJNfDXHtJRc+RfK
	 F+MWTZogjJJnvOioasBu1YcAC5DhOXZOzEYl2smNS83hK/dW+L+PFdH9QVie2spndr
	 u6yXPo9K2YgKA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 20/27] scsi-multipath: add
 scsi_mpath_{start,end}_request()
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260727144234.3802948-21-john.g.garry@oracle.com>
References: <20260727144234.3802948-1-john.g.garry@oracle.com>
 <20260727144234.3802948-21-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 27 Jul 2026 15:25:57 +0000
Message-Id: <20260727152558.3565D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] Synchronous dispatch errors and request cancellations bypass `=
scsi_mpath_end_request()`, permanently leaking resources and causing NULL p=
ointer dereferences on recycled tags.
- [Critical] The dummy implementation of `scsi_mpath_end_request()` skips `=
blk_update_request()`, silently dropping bio completions if CONFIG_SCSI_MUL=
TIPATH is disabled.
--

--- Patch [20]: [PATCH v5 20/27] scsi-multipath: add scsi_mpath_{start,end}=
_request() ---
commit 375ed243ce77c97b0b6e6eb569248a68ab42aec6
Author: John Garry <john.garry@linux.dev>
scsi-multipath: add scsi_mpath_{start,end}_request()

This commit introduces scsi_mpath_start_request() and scsi_mpath_end_reques=
t()
to update private multipath request data. It also adds mpath_nr_active to
Scsi_Host to support queue depth multipath iopolicies.

> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 6a2d7dbfbe8c3..36e5c5543754f 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -669,7 +669,10 @@ static bool scsi_end_request(struct request *req, bl=
k_status_t error,
>  	struct scsi_device *sdev =3D cmd->device;
>  	struct request_queue *q =3D sdev->request_queue;
> =20
> -	if (blk_update_request(req, error, bytes))
> +	if (is_mpath_request(req)) {
> +		if (scsi_mpath_end_request(req, error, bytes))
> +			return true;
> +	} else if (blk_update_request(req, error, bytes))
>  		return true;

[Severity: Critical]
If CONFIG_SCSI_MULTIPATH is disabled, the dummy stub for
scsi_mpath_end_request() unconditionally returns false.

If a request has REQ_MPATH set (which aliases REQ_DRV and can be set by
other subsystems like Device Mapper), won't the else if branch be completely
skipped?

Could this result in blk_update_request() never being called, leaking bios
and hanging the submitting task waiting for completion?

> [ ... ]
> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index d79e1b7b90051..eae5864ce5826 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c
> [ ... ]
> +bool scsi_mpath_end_request(struct request *req, blk_status_t error,
> +				unsigned int nr_bytes)
> +{
> +	struct scsi_cmnd *scmd =3D blk_mq_rq_to_pdu(req);
> +	struct scsi_device *sdev =3D scmd->device;
> +	struct block_device *bi_bdev =3D NULL;
> +
> +	if (scmd->flags & SCMD_MPATH_IO_STATS) {
> +		struct bio *clone =3D req->bio, *master =3D clone->bi_private;
> +
> +		bi_bdev =3D master->bi_bdev;
> +	}

[Severity: Critical]
If a request is requeued, SCMD_MPATH_IO_STATS and SCMD_MPATH_CNT_ACTIVE are
preserved by SCMD_PRESERVED_FLAGS. If the request later fails an early state
check in scsi_queue_rq() (e.g., the device goes offline), blk-mq ends it
directly via blk_mq_end_request(), bypassing scsi_end_request().

When the tag is reused for a dataless request, scsi_mpath_start_request()
returns early without clearing the flags. Will this cause
scsi_mpath_end_request() to read the leaked SCMD_MPATH_IO_STATS flag and
dereference req->bio which is NULL?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260727144234.3802=
948-1-john.g.garry@oracle.com?part=3D20
