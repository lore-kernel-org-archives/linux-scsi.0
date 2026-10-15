Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE2D1DED49
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 00:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792024331; cv=none; b=uNZl7dKFn9EUg3HWGtPjRdkHI5KGFCrAeD0U3CiCCZjEegqY+rLeHDwNtRoy/sWKYJQzsplPOpn41nSFMgJww9h9ckvH+8RAN5ZnT+fANvCeDogX6cU9fmZC4818+XWP1p8wTrAAf8gfZJXe3x6wU36t6vi6Kg5nQw2s1Bwl5WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792024331; c=relaxed/simple;
	bh=zds9UxSTaSx5yT9m/1VcVsZLFA7hwxVG1s5jO1bXKxU=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=P4FzYlPTWkQGD+sGv4zlNErD46r8SLKTpVhLLtAdDar91lHcupN9/U1WzRVge/IvH4e64wq/WqB9hdJCQUhIpuNjo/yFyLLb2pJLUcx4wNd8cGiasMPjDIVkbAeJo0VtKEWH/VlWPnhTyLJduG6FX8wnplB0uPC/NZLVBbdKihQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kqgaw8BS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kqgaw8BS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E99C1F000C4;
	Thu, 15 Oct 2026 00:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792024330;
	bh=3ivd+WsDTezRdCt3LJLNC6rieG9jo0qhWrynogpB0+Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Kqgaw8BSaFdS/VyekcQtcDTXI8JFNkiakfEGmSE/QAhC82btbMFdqHNz/ZQ45DLs+
	 jRhdPQPdHNSE5ymTpqgA2ez/tlHad1sxXFooBzDvz/vb3gpuYlPSnJ5FKpRfr5TBqx
	 ZQ3TbKCoZHXLaF55LJkcL4qFJyV2d1S9n4llzZmG7ScsHAoqI5MsLEFxrAXbPtq2TT
	 7Od5uPkdpC6Wfg/13Q4mMcp7NmzDbZ+5VjlzvTmwYjxBbZcrw2Ehwxplz646v704SY
	 AR5nMHLKUKeUc3bG02oARJl6gnWt+0Tr3Jzs7xVATj0H8DdFU0HujeXSI80meBtkqp
	 +w4rhlJOhB20g==
Message-ID: <sashiko-outbox-172057@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/5] scsi: ufs: bsg: Complete the job on error
Reply-To: sashiko-reviews@lists.linux.dev
To: "Stanley Jhu" <stanleyjhu@google.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261015001855.3450573-2-stanleyjhu@google.com>
References: <20261015001855.3450573-1-stanleyjhu@google.com>
 <20261015001855.3450573-2-stanleyjhu@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 00:32:09 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: ufs: bsg: heap out-of-bounds write/read in RPMB reply
--

commit 500adcab38ae23977180188472414e7c66ab1588
Author: Stanley Jhu <stanleyjhu@google.com>

scsi: ufs: bsg: Complete the job on error

This patch updates ufs_bsg_request to always complete the job via
bsg_job_done() and return 0, matching other BSG transports. It prevents
leaking the job's device reference and mapped scatterlists on error.
Positive status codes continue to return 0 from SG_IO with the reply header.

Cc: stable@vger.kernel.org

> diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
> index 7a66917b3fc0e..18c318d781224 100644
> --- a/drivers/ufs/core/ufs_bsg.c
> +++ b/drivers/ufs/core/ufs_bsg.c
> @@ -195,14 +195,12 @@ static int ufs_bsg_request(struct bsg_job *job)
>  	ufshcd_rpm_put_sync(hba);
>  	kfree(buff);
>  	bsg_reply->result =3D ret;
> -	/* complete the job here only if no error */
> -	if (ret =3D=3D 0) {
> +	if (ret =3D=3D 0)
>  		job->reply_len =3D rpmb ? sizeof(struct ufs_rpmb_reply) :
>  					sizeof(struct ufs_bsg_reply);

[Severity: High]
Does setting job->reply_len to sizeof(struct ufs_rpmb_reply) (which is 104
bytes) cause an out-of-bounds write and read?

The job->reply buffer is allocated with a fixed size of 96 bytes
(SCSI_SENSE_BUFFERSIZE) in bsg_init_rq().

During a UFS Advanced RPMB request, ufshcd_advanced_rpmb_req_handler() casts
the 96-byte job->reply buffer to a struct ufs_rpmb_reply and writes up to
104 bytes, overflowing the allocation by 8 bytes.

Later, bsg_complete_op() uses job->reply_len to copy the reply back to
userspace:

block/bsg-lib.c:bsg_complete_op() {
        ...
        int len =3D min(hdr->max_response_len, job->reply_len);
        if (copy_to_user(uptr64(hdr->response), job->reply, len))
        ...
}

Because job->reply_len is set to 104, this copies 8 bytes of adjacent
slab memory to userspace, which could lead to heap corruption and
memory disclosure.

> -		bsg_job_done(job, ret, bsg_reply->reply_payload_rcv_len);
> -	}
> +	bsg_job_done(job, ret, bsg_reply->reply_payload_rcv_len);
> =20
> -	return ret;
> +	return 0;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015001855.3450=
573-1-stanleyjhu@google.com?part=3D1
