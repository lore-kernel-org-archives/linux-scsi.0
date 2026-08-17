Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52795305665
	for <linux-scsi@vger.kernel.org>; Mon, 17 Aug 2026 01:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786931569; cv=none; b=QgaGKLRGve5sEqvwB5Wugwr0x4drz+CgdZnLTtKDQqbrvJZDMRYXX8JcuVAImJkaMXZxn/8uQkBFSZp+u01fqiOAixOe52oW0WcACMEbPbBtDILmo91Vjhh2lnowEA3fEbsf4RFHUSJkJDlhqpWhPA16VgqfUCEMNq1HrS7pyNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786931569; c=relaxed/simple;
	bh=ipvK/zTATFJu+YoI5DjUfGzZksnhkenvLuhHrW73byk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bgNjyehlCut8DnF/t1NdSfDq7wR5Xa+EWVLb4vRiOkH1LczvHAHsyx5+j+DbN8W0BXC7kpHL51kEHloaNUka4hGrAuYbCMBVxct+4AT2D7F0l+mbGP3vRgsMx4/Zn9KxJKCTafGq1rLUBCU0GQ3jRNsoQeKUMwcJXC4271gAH0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GbmhiDDo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GbmhiDDo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9CF61F000E9;
	Mon, 17 Aug 2026 01:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786931567;
	bh=20g+Gtv1YsxHjjrQMvxbRbbpbM4QNqV+AAApLTJ+Wnk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GbmhiDDoLENF9jT5H4jnAkFnIO2xGQWem54U8mkDXZBEUIjUL3uTLk+PMxLXjz3Vy
	 0mZ0HpZazfMS72+pYt27GKmptBV1UVjes8TCfvcRueiKuf5fczk2QsNxOsBzHk69Z2
	 4oBG1KVQmup1u3+LqlDBkW3jeXiECx9vjOdBD9Nu7rIF4WiRQIoa7rCOeKbJVrY4hW
	 rSSL0n7vgMG9LT4xvSZncGujfxwxU84j68Bb9N86BVoNoe//G8rSgEussS/JyHTyVa
	 Mrf4NOpiDbYgMroMi8o9F4nB5pZxW2xw4S//Q6cvMOTmAEXnNUoR8RuAOyRWwlZfGL
	 Mye0jtiUjPmmg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/2] scsi: bsg: fix TOCTOU in io_uring passthrough
 command setup
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yang Xiuwei" <yangxiuwei@kylinos.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260817013959.165425-2-yangxiuwei@kylinos.cn>
References: <20260817013959.165425-1-yangxiuwei@kylinos.cn>
 <20260817013959.165425-2-yangxiuwei@kylinos.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 17 Aug 2026 01:52:47 +0000
Message-Id: <20260817015247.B9CF61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The completion callback writes out-of-bounds to user space by fail=
ing to cap `sense_len` with `max_response_len`.
--

--- Patch [1]: [PATCH v3 1/2] scsi: bsg: fix TOCTOU in io_uring passthrough=
 command setup ---
commit 2cc4e90253ec0a7b16f7c596b055fcc02296f149
Author: Rahul Chandelkar <rc@rexion.ai>

scsi: bsg: fix TOCTOU in io_uring passthrough command setup

This commit addresses a TOCTOU vulnerability by reading bsg_uring_cmd
fields from the shared mmap'd SQE into local variables once before use.
This ensures bounds checks cannot be bypassed if userspace changes the
values concurrently.

Link: https://lore.kernel.org/r/20260527105931.3950913-1-rc@rexion.ai

> diff --git a/drivers/scsi/scsi_bsg.c b/drivers/scsi/scsi_bsg.c
> index e80dec53174ea..7758c5f22a7e9 100644
> --- a/drivers/scsi/scsi_bsg.c
> +++ b/drivers/scsi/scsi_bsg.c

[ ... ]

> @@ -155,11 +161,17 @@ static int scsi_bsg_uring_cmd(struct request_queue =
*q, struct io_uring_cmd *iouc
>  	}
> =20
>  	pdu->response_addr =3D cmd->response;
> -	scmd->sense_len =3D cmd->max_response_len ?
> -		min(cmd->max_response_len, SCSI_SENSE_BUFFERSIZE) : SCSI_SENSE_BUFFERS=
IZE;
> +	scmd->sense_len =3D max_response_len ?
> +		min(max_response_len, SCSI_SENSE_BUFFERSIZE) : SCSI_SENSE_BUFFERSIZE;

[Severity: High]
This isn't a bug introduced by this patch, but the completion logic in
scsi_bsg_uring_task_cb() contains a buffer overflow vulnerability affecting
user space.

When a command completes with a check condition, the SCSI core in
scsi_io_completion_nz_result() overwrites scmd->sense_len with the actual
length of the sense data.

Later in scsi_bsg_uring_task_cb(), the code calculates the write length:

	sense_len_wr =3D min_t(u8, scmd->sense_len,
			     SCSI_SENSE_BUFFERSIZE);
	...
	if (copy_to_user(uptr64(pdu->response_addr), scmd->sense_buffer,
			 sense_len_wr))

Since max_response_len was only stored in scmd->sense_len (which was
overwritten) and not saved in the PDU, the kernel uses the unbounded sense
data length.

Can this copy unbounded sense data to user space, overflowing the provided
buffer if the sense data exceeds the original max_response_len?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260817013959.1654=
25-1-yangxiuwei@kylinos.cn?part=3D1
