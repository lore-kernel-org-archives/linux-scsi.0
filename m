Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C0B208D0
	for <linux-scsi@vger.kernel.org>; Sat,  4 Jul 2026 17:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783187894; cv=none; b=UHGxNSc82Z/yZlZo+uUG9AEuPe7X9c/ArATY2zYa+9Zx3uqMv+wdA1FqIGt1lgmGMdgsy20rAa9VZr4vnJxRVcsia2YQLdVQ585S850y4beuXlnfodgFmYEc4+WNwT3qAk63jkIP7hHe9otv+d9FOCWAh9InTAOOW5dZXEcmaq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783187894; c=relaxed/simple;
	bh=CciqR7jhXiWmsRR2DW4F3pz73CVbVsd71cVK6w6XYSw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=EFDJ/H7Iu4YfTJEmFt+LiCCrSo++DwJVPSodoo/MkH/+p1ND7YhsMihvKAoSqfTCc1g/1VfsFuqdkFwW0Jd8qc1eAvQABC/Gehi2AR8i4af5YHlPX0KDU4V1F5Ug9bABltbVl/6qqBwjj2qbhXdP17UK9AlwE4rP7m2OcHSDl3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bE2jrQW3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bE2jrQW3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E1051F000E9;
	Sat,  4 Jul 2026 17:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783187892;
	bh=Pdj4FYRLzPu9WjEYRfDmdJpSSOvTKHX/PHtuHNukZ5c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bE2jrQW3qKGDnVPJlRginMCHmRqC+15/RYWqFFrW8S1uTcLvxULTo8pIdSpu72EnV
	 6FVrD36MvaTCSiLe6E3B4OWOqSGxofKPGYUqHY3tTGK89OFJ8z0BMb6lU9gMA6OqXM
	 4G/UqbsWWLnCBK04fZ3Pio5VLv2y24H57OgAs6vrlnlOxQ1XMQcwDy2z5tj5wIul5b
	 hI12SZMKvzSc99IKAYgBdTQXYZASNH0+meSX3ZrOKyS0E0Iy/x/D19t0Xij2Nby6YQ
	 zuEVn0icYnLTT+Riwq4NBGiGkmhs918aI6bjZKCSNLH7gkGdomt8wW7ykwonU+IsLM
	 5d6taxf6rAiQQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: Fix BSG request hang on flash image
 validation failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Guangshuo Li" <lgs201920130244@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260704174603.255881-1-lgs201920130244@gmail.com>
References: <20260704174603.255881-1-lgs201920130244@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 04 Jul 2026 17:58:12 +0000
Message-Id: <20260704175812.9E1051F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] Returning a negative error code to the BSG core truncates the =
reply payload, silently discarding vendor-specific diagnostic codes and bre=
aking userspace API expectations.
--

commit 4f9a7c7b8cae4329ddb272256609d33b20e03bb0
Author: Guangshuo Li <lgs201920130244@gmail.com>

scsi: qla2xxx: Fix BSG request hang on flash image validation failure

This patch aims to fix a hang when flash image validation fails. It modifies
qla28xx_validate_flash_image() to return an error code instead of QLA_SUCCE=
SS
when validation fails. This prevents the BSG request from remaining in-flig=
ht
until it times out.

> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bs=
g.c
> index 5e910b5ca670d..5b2201859f730 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -3369,5 +3369,5 @@ static int qla28xx_validate_flash_image(struct bsg_=
job *bsg_job)
>  		bsg_job_done(bsg_job, bsg_reply->result,
>  			     bsg_reply->reply_payload_rcv_len);
> =20
> -	return QLA_SUCCESS;
> +	return rval;

[Severity: Critical]
Does returning a negative error code here truncate the reply payload and
discard the vendor-specific diagnostic codes?

Earlier in qla28xx_validate_flash_image(), the code carefully constructs
an extended vendor status payload:

    if (rval)
        bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =3D
            (state =3D=3D 39) ? EXT_STATUS_IMG_SET_VALID_ERR :
            EXT_STATUS_IMG_SET_CONFIG_ERR;

However, when this function returns a negative error code instead of
QLA_SUCCESS, the BSG core intercepts it as a transport failure.

This occurs in the transport layer:

drivers/scsi/scsi_transport_fc.c:fc_bsg_host_dispatch() {
    ...
    if (ret) {
        /* transport error */
        job->reply_len =3D sizeof(uint32_t);
        ...
    }
    ...
}

Will this force the reply length to 4 bytes and silently drop the
reply_data payload, breaking userspace API expectations for these
validation errors?

>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260704174603.2558=
81-1-lgs201920130244@gmail.com?part=3D1
