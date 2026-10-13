Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00CD4BD342
	for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 10:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791888277; cv=none; b=QqhWPvlcuYuyoRL9B3j4pXWEhqjuQO3hco4XJlbcq+rUsdHSNt3LOkh9rTgLgZVRNimqDfx1dmaijyTu8ULR7JVjsgRZpmtH2XqX/tWcr6nH/ut1VZPoZ0zji/a+nUV0FrTgpIcukSRr+s7OWekStoV1qxeSdB7NDh2IE7WxXV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791888277; c=relaxed/simple;
	bh=ZfD9taIgppAaheSyBRRuUOc0VQFjUqKfS3dhl8QWwPQ=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Zp3WzIF1zoF0D0pUIR5T1N164GJ5JhOic36qc1Un+RadoEPr+XCK7bC0LG6Taz+sHCK6w9SloEdBy2gPuYJUukNvxK0egJwbLETecJ8gMX3e5BMkQaVwlhdkGi5rQIiDrN9spL3YNFyAyG7nNHnxh0ETkOTLzJq25uPKT+WplIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cF2x2RK+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cF2x2RK+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 286641F000FF;
	Tue, 13 Oct 2026 10:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791888275;
	bh=2MGzsv1FrgIDa+hLg/RVS9nFxo5DemV06CIfviFWNS4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cF2x2RK+w9/r0C64GhJk94Ox4eJ+p0PBS+FlJw2qzeoSAajtCQeA6lw37kloWzTWU
	 KRYjcFWADo4fZWS3EUMmL/YHc9lYZ7WCWVRqS3a2rOrOD5ox3WB2mKTQqswo4XH7kK
	 Bt6xOjQ8Kjuuehw1T+lhRVwnzajl/rovr9Kxg35hQDmz2So7bYcXwYH60A+JTI58ys
	 DZFs5VzWb/dUqsE0bCUsB04FhSoiftTgs879QE4F+x4H5UbGe9ih79ZTXWLaXUrU8o
	 LMZAF1PrYiAbutCcC9gCKdkJnOc8HwrKOQFdDfbROjN7eh4OAkC3Wu46UIMi0K/b9R
	 x3HwjBEDjfXrQ==
Message-ID: <sashiko-outbox-169538@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/3] scsi: ufs: bsg: Validate request_len before
 accessing request
Reply-To: sashiko-reviews@lists.linux.dev
To: "Stanley Jhu" <stanleyjhu@google.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261013102913.948718-2-stanleyjhu@google.com>
References: <20261013102913.948718-1-stanleyjhu@google.com>
 <20261013102913.948718-2-stanleyjhu@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 10:44:34 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] ufs/bsg: heap buffer overflow in Advanced RPMB reply handling
- [Medium] block: memory and device refcount leak on ufs_bsg_request() erro=
r path
--

commit 6c7ab99a857f0be8f1f19eb78aa230d8ccb39b14
Author: Stanley Jhu <stanleyjhu@google.com>

scsi: ufs: bsg: Validate request_len before accessing request

This commit adds validation checks for job->request_len in the UFS
BSG paths to prevent out-of-bounds reads when userspace provides
short requests.

> diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
> index 7a66917b3fc0e..dab1f05aff383 100644
> --- a/drivers/ufs/core/ufs_bsg.c
> +++ b/drivers/ufs/core/ufs_bsg.c
> @@ -73,6 +73,9 @@ static int ufs_bsg_exec_advanced_rpmb_req(struct ufs_hb=
a *hba, struct bsg_job *j
>  	if (hba->ufs_version < ufshci_version(4, 0) || !hba->dev_info.b_advance=
d_rpmb_en)
>  		return -EINVAL;
> =20
> +	if (job->request_len < sizeof(*rpmb_request))
> +		return -EINVAL;
> +

[Severity: High]
While this properly validates the request size, does the reply handling
contain a heap buffer overflow for advanced RPMB requests?

The BSG core allocates job->reply in bsg_init_rq() with a fixed size of
SCSI_SENSE_BUFFERSIZE (96 bytes). However, ufs_bsg_exec_advanced_rpmb_req()
casts job->reply to struct ufs_rpmb_reply, which has a size of 104 bytes:
sizeof(struct ufs_bsg_reply) (40 bytes) + sizeof(struct ufs_ehs) (64 bytes).

When ufshcd_advanced_rpmb_req_handler() is called, it writes 64 bytes
to the ehs_rsp field at offset 40, resulting in an 8-byte out-of-bounds
write on the heap:

drivers/ufs/core/ufshcd.c:ufshcd_advanced_rpmb_req_handler() {
    ...
    memcpy(rsp_ehs, ehs_data, ehs_len * 32);
    ...
}

Later, ufs_bsg_request() sets job->reply_len to 104 for RPMB replies,
which configures the block layer to copy 104 bytes to user space from
this 96-byte allocation. Will this leak adjacent heap memory to userspace?

[ ... ]

> @@ -142,6 +145,11 @@ static int ufs_bsg_request(struct bsg_job *job)
> =20
>  	bsg_reply->reply_payload_rcv_len =3D 0;
> =20
> +	if (job->request_len < sizeof(*bsg_request)) {
> +		bsg_reply->result =3D -EINVAL;
> +		return -EINVAL;
> +	}
> +

[Severity: Medium]
Does returning -EINVAL directly bypass the BSG job completion mechanism
and permanently leak the job's resources?

When ufs_bsg_request() returns -EINVAL directly, the block layer's
bsg_queue_rq() returns BLK_STS_IOERR. This causes blk_mq_end_request()
to complete the request without invoking the queue's .complete callback
(bsg_complete()).

Because bsg_complete() is bypassed, bsg_job_put() is never called,
meaning bsg_teardown_job() never executes. This leaves the sg_list
memory and the job->dev reference count permanently leaked, which would
prevent the UFS device from ever being cleanly removed.

Should this error path instead call bsg_job_done(job, -EINVAL, 0)
and return 0 to ensure proper teardown?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013102913.9487=
18-1-stanleyjhu@google.com?part=3D1
