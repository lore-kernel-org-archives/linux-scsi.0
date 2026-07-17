Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2648126FA4B
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 16:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784307440; cv=none; b=iFI+Fts/x40kJfhGFUzBDQ7ZdpxBTtF4u5YJGItWhSaDF7W7VXpldSn/gM9RxhCpEiFSC2tmlc1qQmusYlXlRkLVe5UP7kM9j4bWQO4UfUwM4ELFABB05KbVUvXRSlQmqypF2asBTu2o/2zZS0M3AfdqAOAO1KN6aQpmYAhERMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784307440; c=relaxed/simple;
	bh=cT/K3Uhf4wiCaQ+YWOcTIbYSA0ymHwLWhPlDADVRFPU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=S/5k0OlIlu8rfmd62syw1FnZXtVZu9f/61LEVLOYks1XzbFCW1aLl7QzHy8BLwtm6C2HSQlDPIBAzzTP6xZyhY/8BCpmsp4kYtoUA85UnAefFTfT4jgGJoMPjYSq2cdPtw1HvEKCpmoQKMERHRb9RnnuQ3TTe3AFhFyQI3Kclfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hQYNcvmF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hQYNcvmF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30AC1F000E9;
	Fri, 17 Jul 2026 16:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784307439;
	bh=OcxjMQIarxEap4AGxfuepRl84K9JTl45Jekl2xeopWE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hQYNcvmFzaN8M76hdt/0F/EvTyR6dHhegh1AFIlwKdDj62vDc/xWrj6wlAsc2ELzl
	 Gnd3EObB4Fm+H1IYNWqfCNyjjEvoZ3OpkxeIJfRzUXNBs2rxBt4w0M6AkAY5cdcuZF
	 Te+fABGhh6XFGzxdNXk9cPz92hPfem2ur5kIn3uSnA4NO4Lh1hfwlI2pMUS1aXDyS9
	 iDecZjNcbl5AelTNvEZxl+ntGWQ07yOkDYnQx+zhGwmT2UYgDOBR+YE4vrYffBNA79
	 PNnKAfPAWH4/baEc7ym3abHhtLYQR0jEwOjE83Czj9hV/VFe/lc/a49sont9FfE3h/
	 Jyubb7Psybtcw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 54/56] scsi: qla2xxx: Fix BSG job leak on validate
 flash image error path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260717152904.3155730-55-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
 <20260717152904.3155730-55-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 16:57:18 +0000
Message-Id: <20260717165718.E30AC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Pervasive slab out-of-bounds reads when accessing BSG vendor_cmd p=
ayload due to missing request_len checks.
--

--- Patch [54]: [PATCH v5 54/56] scsi: qla2xxx: Fix BSG job leak on validat=
e flash image error path ---
commit f84362ea09312f70b70c60c0ecfaeb501ca572d1
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Fix BSG job leak on validate flash image error path

qla28xx_validate_flash_image() returns QLA_SUCCESS unconditionally, telling
the FC BSG transport that the driver owns and will complete the request.
However, bsg_job_done() was guarded by an error check, causing requests to
dangle on error paths until timeout. This commit removes the error check
to ensure the job is always completed.

> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bs=
g.c
> index 3bf3a7b96eb50..2f73c9af418d7 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -3848,9 +3848,8 @@ static int qla28xx_validate_flash_image(struct bsg_=
job *bsg_job)
>  	bsg_reply->result =3D DID_OK << 16;
>  	bsg_reply->reply_payload_rcv_len =3D 0;
>  	bsg_job->reply_len =3D sizeof(struct fc_bsg_reply);
> -	if (!rval)
> -		bsg_job_done(bsg_job, bsg_reply->result,
> -			     bsg_reply->reply_payload_rcv_len);
> +	bsg_job_done(bsg_job, bsg_reply->result,
> +		     bsg_reply->reply_payload_rcv_len);

[Severity: High]
This isn't a bug introduced by this patch, but there is a pervasive slab
out-of-bounds read issue when accessing the BSG vendor_cmd payload due to
missing request_len checks.

Is it possible for a privileged user (with CAP_SYS_RAWIO) to issue a short
BSG command with a small request_len (e.g. 4 or 8 bytes), causing the driver
to read out-of-bounds slab memory?

For example, when this function calls qla28xx_do_validate_flash_image(),
the command reads vendor_cmd[1] unconditionally:

qla28xx_do_validate_flash_image() {
    ...
    img_idx =3D bsg_request->rqst_data.h_vendor.vendor_cmd[1];
    ...
}

Similarly, earlier in the BSG path, qla24xx_bsg_request() unconditionally
reads vendor_cmd[0] before checking if the request length covers it:

qla24xx_bsg_request() {
    ...
    if (bsg_request->rqst_data.h_vendor.vendor_cmd[0] =3D=3D QL_VND_MANAGE_=
HOST_PORT ||
        bsg_request->rqst_data.h_vendor.vendor_cmd[0] =3D=3D QL_VND_GET_HOS=
T_STATS)
    ...
}

Should the transport layer or the driver validate that the user's length is
large enough before accessing these vendor command array elements to avoid
a KASAN panic or executing arbitrary driver logic with uninitialized memory?

> =20
>  	return QLA_SUCCESS;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717152904.3155=
730-1-njavali@marvell.com?part=3D54
