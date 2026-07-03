Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758A534252C
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2026 11:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783077867; cv=none; b=uchD4fsjwFC78PZZvaNCCW5wY1a+fUzScp/f0H1rV5Jvi9B8yD9er9rWNNoPrs2vyDU+uHi3isFWPFw9pBjXE1POFiQXKyBKZdSII/dzC2KjlYXOzw2twX9VdOsuHicQmdo1c2Zr7wQKY1MYxXPBBbZHqXQRj7R35DgiJCddjNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783077867; c=relaxed/simple;
	bh=imwS4tVzJdpkAVeb3y0exh0k5Dssw8K+NmxKXmjgSKQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FmaBIWf4bVoqwCw4NaMREmfvTkpY9Mt3xqbpLNo7KgwUIMz27WwnXtMhwFr+D62F+djgqJUTnzR3btcBMXLaitDZgeQAOgSSfw0b9g0lB7UxcmUT3dxipdaQ1BFHmKvTLWmADtPbZr0wlBOGo3krIWEhpAswBPG23MWJdOeqjBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RYYo2Lc5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RYYo2Lc5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083E51F000E9;
	Fri,  3 Jul 2026 11:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783077853;
	bh=EITj1JjU8QbxlSPX3feSsP1M0YwFygBT+oUhzD9B0xI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RYYo2Lc5N3XdCdQr9brDZSfDES6DQsT/awhjZrdUWTqytwATPEyLAjd4q97/z40AV
	 5TT5KZZNFdzgczzv9cg5UEIwHFo+VjDZ2TaWB5ZLlASlsUDwQILGaEI8hPXR9btfkp
	 E3tr6TZt7fQv1e1dFr+OrPhyyXzMrc03gOK+JNl12JKDH7XqiIw0RuHvPECbAQpp1I
	 arCIv0KwQo5NESUeaQ9nByFrzsPUb1hpezR+jThdG6DqDBjQVvZ9mwuvYpt2xBgbX3
	 pVs8paYKKYdo7L5Tbkb8rqv6wkSKq8XBrAnDw4W/1MnSX5tVEnn9gkbI40lok5u4vp
	 EYUSSjz+wzA9Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 07/10] nvme-multipath: add nvme_mpath_synchronize()
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260703103204.3724406-8-john.g.garry@oracle.com>
References: <20260703103204.3724406-1-john.g.garry@oracle.com>
 <20260703103204.3724406-8-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 11:24:12 +0000
Message-Id: <20260703112413.083E51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] The patch introduces a wrapper `nvme_mpath_synchronize()` that call=
s an undefined function `mpath_synchronize()`, relying on a missing depende=
ncy (`libmultipath`), which leads to a build failure.
--

commit f655883eea782b4086749f2985502e444177db21
Author: John Garry <john.g.garry@oracle.com>

nvme-multipath: add nvme_mpath_synchronize()

This commit adds a wrapper function which calls into mpath_synchronize
for the NVME multipath subsystem.

> diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
> index 35618285caf89..292526c9dda29 100644
> --- a/drivers/nvme/host/nvme.h
> +++ b/drivers/nvme/host/nvme.h
> @@ -1078,6 +1078,11 @@ void nvme_mpath_ioctl_begin(struct mpath_device *m=
path_device,
>  			unsigned int cmd, void **opaque);
>  void nvme_mpath_ioctl_finish(void *opaque);
> =20
> +static inline void nvme_mpath_synchronize(struct nvme_ns_head *head)
> +{
> +	mpath_synchronize(&head->mpath_head);

[Severity: Low]
Does this code build cleanly? It appears that mpath_synchronize() is not=20
declared or defined in the current tree. This seems like it would cause=20
a compiler error due to an implicit function declaration when building=20
with NVME multipath enabled.=20

Is this patch relying on a missing dependency or missing header inclusion?

> +}
> +
>  static inline void nvme_trace_bio_complete(struct request *req)

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703103204.3724=
406-1-john.g.garry@oracle.com?part=3D7
