Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5941A4A3867;
	Fri, 11 Sep 2026 16:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789144515; cv=none; b=ltys0uqCxmCf+ackidBLMIhBh1xJGisxS+fwZqUb4/7qnrahJGctJkkmZjdPu/z8UY54Wc6oWREiSbvCINNiXicPPnZEs8nZ19hNs202mvuRfAh+dgZaCqh6CynwfUKZjkcUN+aqnZfPN6HPNpyeFkMG5qGXG19jmAPYJWnNCKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789144515; c=relaxed/simple;
	bh=ww8FPPvfInyCZe8uHOUA9eu/BMfelKj0o4FkpN2RF+Q=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=YEUT53iiBWmaSaG1mkINvhUZCpzl9d1B3y93kIq1TixqT+8OQa29TMthdki6jSPBukHrY+eNgQQ3+N1WZtedCeSNuK64iAmUu3Rsgk1UsKBNxJFa1aUiahuXrNCwVPJpnx9e+Wjxdl2WT/7VhlS94pnjg1qiSpjQJ/1j6fiLp+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YZgxeHmF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YZgxeHmF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 684191F000FF;
	Fri, 11 Sep 2026 16:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789144509;
	bh=thOhBW7p+DX7cc580JX/G0TFDJHV6SnjvhVyFdFgF3w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YZgxeHmF2iJToDAzhKSmCN/I1/b4YpexTHkiVavKfUxTZnif5h2/Ig67lD+UUp3Sy
	 SVBkEn714VEhzRXzrlcpJWjOGzs5+vZ+PZHfhbdflF4emx/GCwuUkKQOo+m4b0FC3j
	 7CcWVYLnD2bHajrh+wsusc9+hBf/yr3udGlKgjyTteLf3JwdHrA/FMs7lWGMPw78hD
	 CCFmzVBfiL2tiyJ7h2RGWzExH5/fBmtxkunPXyShZSD5yznKP5nuG+cttZnfiq3u9X
	 1lEQAyBHvh5FGNsoEbhTURc0RA7d6UJ/7Z6ug0QGQCaXNctJqXtH+c/v/BX0ndUxSY
	 udeEoUcy8GrCw==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH] scsi: virtio_scsi: bound EH timer resets to avoid
 unkillable hang
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nguyen Ngoc Thang" <ngocthang2710.1999@gmail.com>
Cc: virtualization@lists.linux.dev, linux-scsi@vger.kernel.org, "Michael S.
 Tsirkin" <mst@redhat.com>, "Eugenio Perez" <eperezma@redhat.com>
In-Reply-To: <20260911162118.32414-1-ngocthang2710.1999@gmail.com>
References: <20260911162118.32414-1-ngocthang2710.1999@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 11 Sep 2026 16:35:08 +0000
Message-Id: <20260911163509.684191F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] Missing eh_host_reset_handler causes SCSI EH to free commands =
while the host is active, resulting in DMA memory corruption and Use-After-=
Free.
--

commit c1b61825f071ba8c8020eead463039fdb142c7b0
Author: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>

scsi: virtio_scsi: bound EH timer resets to avoid unkillable hang

This commit limits the number of times virtscsi_eh_timed_out() can reset
the command timer to 5, returning SCSI_EH_NOT_HANDLED afterward. It also
bounds the wait time in virtscsi_tmf() when handling aborts and resets to
prevent infinite hangs if the transport breaks.

Closes: https://syzkaller.appspot.com/bug?extid=3D53706c567afab5131044

> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index 35731b18c519e..b4f20c4877182 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c

[ ... ]

> @@ -783,13 +818,19 @@ static void virtscsi_commit_rqs(struct Scsi_Host *s=
host, u16 hwq)
>  }
> =20
>  /*
> - * The host guarantees to respond to each command, although I/O
> - * latencies might be higher than on bare metal.  Reset the timer
> - * unconditionally to give the host a chance to perform EH.
> + * The host normally answers every command, so reset the timer and keep
> + * waiting. But if the transport is broken (e.g. bus mastering was turned
> + * off), no completion can ever arrive: give up after a few resets so SC=
SI
> + * EH fails the command instead of blocking its submitter forever.
>   */
>  static enum scsi_timeout_action virtscsi_eh_timed_out(struct scsi_cmnd *=
scmnd)
>  {
> -	return SCSI_EH_RESET_TIMER;
> +	struct virtio_scsi_cmd *cmd =3D scsi_cmd_priv(scmnd);
> +
> +	if (++cmd->eh_resets < VIRTSCSI_EH_RESET_LIMIT)
> +		return SCSI_EH_RESET_TIMER;
> +
> +	return SCSI_EH_NOT_HANDLED;

[Severity: Critical]
Does returning SCSI_EH_NOT_HANDLED here allow SCSI EH to run and eventually
free the command without ensuring the host has dropped its DMA references?

If the virtio host experiences a severe delay and eventually completes the
timed-out commands, could it DMA the response directly into memory that has
already been freed by SCSI EH and potentially reallocated to new requests?

If this happens, wouldn't it result in a use-after-free and DMA memory
corruption when virtscsi_complete_cmd() runs?

For example:

virtscsi_complete_cmd() {
	struct virtio_scsi_cmd *cmd =3D buf;
	struct scsi_cmnd *sc =3D cmd->sc;
	struct virtio_scsi_cmd_resp *resp =3D &cmd->resp.cmd;
	...
	scsi_done(sc);
}

Here the dangling pointer from the virtqueue would be dereferenced after
the command has been freed by SCSI EH, potentially followed by a kernel
panic when scsi_done() is called on the corrupted scsi_cmnd pointer.

>  }
> =20
>  static const struct scsi_host_template virtscsi_host_template =3D {

[Severity: Critical]
Does the host template lack an eh_host_reset_handler?

Without this, SCSI EH cannot safely stop the virtio device before freeing
the timed-out commands. If SCSI EH attempts aborts and device resets which
also time out, it will give up, offline the device, and flush (free) the
commands. When the host later resumes and processes the virtqueue, could it
overwrite the freed memory?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260911162118.3241=
4-1-ngocthang2710.1999@gmail.com?part=3D1
