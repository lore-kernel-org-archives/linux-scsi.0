Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49BF237756E
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 07:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783407831; cv=none; b=lMSpfKDLNj7RKp5AwTQiPM1+Smh2s0OuOyJNz3E6z9tVOYInnAE8xknJ5wuoeBiNCltw7kNgL6IL572uWiqxKjfVMwcs3duXXaIsCXC+ybryw4vilLBhLKyaOpjYM/FGyfH7SwoewbHDgVU5noePGdfzUmZbnP+UxmXPDKyvECM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783407831; c=relaxed/simple;
	bh=pyGoLbvZT9I8l5whKaRBp654srzoUqZG8qrVpASW0Tc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uAmsWnqc7NLIKmOL0Ayw+b9UtTuhc4I1RcPQlE8HbE/amd7ckgZ/iqzx+i+4VjLae5MM0oH7Aio/ymklD3BWbvVOOzkUPbxaOh0ZdGxVBz30Pc6esbz05aSiWLzlfXF0SFYZi/JowEvY01+nRYRGPcy3FflyqMd9wdd7i6cN+kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T5PobWRn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T5PobWRn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F3AE1F000E9;
	Tue,  7 Jul 2026 07:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783407830;
	bh=cMBQS142wmSTUcxWjR3qlTnA8xutf5Z5zLd8nQiR80Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=T5PobWRnSaKLfZKNRWR4FEvEdzgf9Oe3oQOfwW8FUs+VcUbUOiC7ZmSXjhSfJMYm1
	 lYaImSFaz75D9hytlQZQyeJzkpEPvsiEl4CwUDNg6HreTlPWTuB3bfeAbOU48zG2BB
	 HmQSQtPG12Puhd31/stUWL0BjXHlAgNcocfWahvfdEyYXkdyWVpf6ZjJabDVJDaQTy
	 86P+GmlinFyIYW2XdpFtp9qYJr5mmP77tBaX0mQBoW7dXuPlA8iUGjXgjFI3HWeICu
	 4o6D6hr0I/lqbvDrNTXYuvXS/irg3Eg9CsVbtn7GYZ6TI1aYoLpE9xk0nh9sk+n+m9
	 du/YU4ECIqbIw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 54/88] scsi: qla2xxx: Fix BSG job leak on validate
 flash image error path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-55-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-55-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 07:03:48 +0000
Message-Id: <20260707070350.0F3AE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Payload truncation and loss of vendor response on error paths in B=
SG handlers.
- [High] Out-of-bounds read of `vendor_cmd` array and other flexible fields=
 due to insufficient `request_len` validation in the BSG transport and qla2=
xxx driver.
--

--- Patch [54]: [PATCH v3 54/88] scsi: qla2xxx: Fix BSG job leak on validat=
e flash image error path ---
commit e89e7bde46a1b68a965d717fd50351f1638ad942
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Fix BSG job leak on validate flash image error path

This commit removes the conditional check around bsg_job_done() in
qla28xx_validate_flash_image() to ensure the BSG job is always completed.
Since the function unconditionally returns QLA_SUCCESS, the transport layer
will not complete the job, so the driver must do it to prevent resource
leaks on error paths.

> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bs=
g.c
> index e7739cead967a..0c9174d6c887a 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -3782,9 +3782,8 @@ static int qla28xx_validate_flash_image(struct bsg_=
job *bsg_job)
>  	bsg_reply->result =3D DID_OK << 16;
>  	bsg_reply->reply_payload_rcv_len =3D 0;
>  	bsg_job->reply_len =3D sizeof(struct fc_bsg_reply);
> -	if (!rval)
> -		bsg_job_done(bsg_job, bsg_reply->result,
> -			     bsg_reply->reply_payload_rcv_len);
> +	bsg_job_done(bsg_job, bsg_reply->result,
> +		     bsg_reply->reply_payload_rcv_len);
> =20
>  	return QLA_SUCCESS;
>  }

[Severity: High]
This is a pre-existing issue, but other BSG handlers seem to share the
same flawed error-handling pattern that was just fixed here. For example,=20
in drivers/scsi/qla2xxx/qla_bsg.c:qla2x00_mailbox_passthru():

        if (!ret)
                bsg_job_done(bsg_job, bsg_reply->result,=20
                             bsg_reply->reply_payload_rcv_len);
        kfree(req_data);
        return ret;

And similarly in qla2x00_manage_host_stats():

        if (!ret)
                bsg_job_done(bsg_job, bsg_reply->result,
                             bsg_reply->reply_payload_rcv_len);
        return ret;

When ret !=3D 0, bsg_job_done() is skipped and the error code is returned
to the transport. Does this cause the transport's error path to force
reply_payload_rcv_len =3D 0, discarding the mbx_out registers and vendor=20
status?

If so, user space applications relying on the BSG vendor response=20
payload to diagnose command failures might receive truncated payloads.

[Severity: High]
This is also a pre-existing issue, but could there be an out-of-bounds
read of the vendor_cmd array due to insufficient request_len validation?

In drivers/scsi/scsi_transport_fc.c:fc_bsg_host_dispatch(), the switch=20
statement updates cmdlen but appears to skip bounds-checking=20
job->request_len against it:

        cmdlen +=3D sizeof(struct fc_bsg_host_vendor);
        if ((shost->hostt->vendor_id =3D=3D 0L) ||
            (bsg_request->rqst_data.h_vendor.vendor_id !=3D
                shost->hostt->vendor_id)) {

Then, down in drivers/scsi/qla2xxx/qla_bsg.c:qla24xx_bsg_request(), the=20
driver blindly accesses vendor_cmd[0] before checking msgcode or=20
request_len:

        if (bsg_request->rqst_data.h_vendor.vendor_cmd[0] =3D=3D QL_VND_MAN=
AGE_HOST_PORT ||
            bsg_request->rqst_data.h_vendor.vendor_cmd[0] =3D=3D QL_VND_GET=
_HOST_STATS)

And in qla2x00_process_loopback(), it accesses vendor_cmd[1] and [2]:

        elreq.options =3D bsg_request->rqst_data.h_vendor.vendor_cmd[1];
        elreq.iteration_count =3D
            bsg_request->rqst_data.h_vendor.vendor_cmd[2];

If a privileged user sends a BSG command with a request_len smaller than=20
the expected size, could this lead to an out-of-bounds read past the=20
allocated buffer?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D54
