Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA388501F55
	for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 13:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791898782; cv=none; b=Ti8jPKuBeE6Tufu1ggeKlYzbLdwL+pPLC93qiD1999wjFw1MOO32wSFF0JXfFxPvutZlS+nYxwLk0NcvNRF19z6/WKkMyZuzsUzQFJUjyEH7iR39VbW9j9C7etmjwIEo8mmnx2MW4mIGYsifPb27nC6Dj9X/9Wmz3wWErkriXCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791898782; c=relaxed/simple;
	bh=iSlbNbInN2yWdjZ8oUC6DTl96hlZtRJbFDaxMksL+bg=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=jNcdFjI3VRzhDzqybKOvMt6Kx1jrx557ocvhE6fKHUeLwujYAsKRTnlZPYGo7za9tDLwzs/ksynSIYegvIx898A3kkm/R1iJZR5otw966yRMQ8h03ll5gXvt+RbBG1969B4lmg/YFc3yQx8r6PeGmN3JmixlfZO0Yo9aDSUETeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RB4WyIe6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RB4WyIe6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 352841F000FF;
	Tue, 13 Oct 2026 13:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791898781;
	bh=FkMdkNc4FPtDrel0iOM8K6I2Xfehw+ATa2h2uBT4oFc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RB4WyIe6D2NC9ypOamqPj27aChOcIsWZQyahyX+JFv2aPP1tqx/sPgkoVM2YDdUYx
	 HL1NfGpSH3JQIzGFdRxuX4Pju+4LAmnD2SmdsQoiRFp0P6/KoC3DLpSvFlzVc3ZH5y
	 Ojc4JeWGSUDvGZhkqxovFyWBBG61bIcljK2e2obPNLPG49e1JRJuZVd9CHQacBVbeV
	 ZWFXeUc0w7I00hGwUzrzb4H+fwlpUQNYYqFbIwjzLA80B78OIvB1UDFFlRp7BJKf0S
	 2DY133aZqPvJbkscceWEtMzgL6UPewrzrJGRsL5rlojbGwI8uuBOv1fvub91WwZi6t
	 X85AssuobU5ng==
Message-ID: <sashiko-outbox-169843@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: bsg: Pass reply_len to bsg_setup_queue() to fit
 UFS ARPMB replies
Reply-To: sashiko-reviews@lists.linux.dev
To: "Stanley Jhu" <stanleyjhu@google.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261013132708.1669415-1-stanleyjhu@google.com>
References: <20261013132708.1669415-1-stanleyjhu@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 13:39:40 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] block/bsg: infoleak of recycled reply buffer on synchronous LLD =
error
--

commit 52ec043e68f598e70d8f2fbea510e68eefe133cc
Author: Stanley Jhu <stanleyjhu@google.com>

scsi: bsg: Pass reply_len to bsg_setup_queue() to fit UFS ARPMB replies

This commit updates bsg_setup_queue() to accept a reply_len parameter,
allowing BSG transports like UFS to specify custom reply buffer sizes.
It modifies bsg-lib to use this dynamic length for memory allocation
and reply copying.

> diff --git a/block/bsg-lib.c b/block/bsg-lib.c
> index 895db30a7033d..536cee4430a76 100644
> --- a/block/bsg-lib.c
> +++ b/block/bsg-lib.c
> @@ -50,7 +53,7 @@ static int bsg_transport_sg_io_fn(struct request_queue =
*q, struct sg_io_v4 *hdr,
>  	reply =3D job->reply;
>  	memset(job, 0, sizeof(*job));
>  	job->reply =3D reply;
> -	job->reply_len =3D SCSI_SENSE_BUFFERSIZE;
> +	job->reply_len =3D bset->reply_len;

[Severity: Medium]
Does this code leak the contents of the recycled reply buffer to user space
on a synchronous low level driver error?

The job->reply buffer is allocated once per tag during queue setup and is
reused across requests. While the job struct itself is cleared with memset()
here, the job->reply buffer is not zeroed per-request.

If the transport's job handler fails synchronously, the request is completed
with an error, but job->result might not be updated and remains 0.

Later in bsg_transport_sg_io_fn(), the code relies on job->result to restri=
ct
the copy length:

    if (job->result < 0) {
        /* we're only returning the result field in the reply */
        job->reply_len =3D sizeof(u32);
        ret =3D job->result;
    }

    if (job->reply_len && hdr->response) {
        int len =3D min(hdr->max_response_len, job->reply_len);

        if (copy_to_user(uptr64(hdr->response), job->reply, len))

Since job->result is 0, this check is bypassed and the full bset->reply_len
bytes of the uninitialized or recycled job->reply buffer will be copied to
user space. For UFS Advanced RPMB, this could leak up to 104 bytes of the
previous request's data.

Should the reply buffer be cleared when initializing the job, or should
job->result be explicitly set on all error paths?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013132708.1669=
415-1-stanleyjhu@google.com?part=3D1
