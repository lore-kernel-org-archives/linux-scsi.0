Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793763219;
	b=0CYAruCixDH7rDszMBSAzNQR75kn8L4t+PU3t3lLMowTguQH6CX2YEGKdWseWN8wbZN8
	 u5gNnL9TXRWjU9Aem4zQTlSCPiCwJVTP6FxdVS+DtL7/WWGX/mfu19XFOgy+4sfAh9p7m
	 1I7VbbVPRHjz5JSMG7QIbdGleL+8pt8LqrmB2DPWX/hYB5n1sFLgd7tDVNo6XkJvQGL2P
	 pjKgVH0kmSF3CypSF6dDz8dOd+NjVb+xn9r7+4STTlS4yOpbzL8ekxsa7IGcMM2ohpjPt
	 17ojxK0fjhsbwAU4HGpK+GdO1SmFv62aIqinq/SSTWT+di5Cg5TFW9XkA1PtVy4Z8mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793763219;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=ceplu2oppQPensG9AZykMphuy6zcdHZhji9fasLS54I=;
	b=23z2FjcEEsgvWSZ/Ri0wg+bWtzZRPj3VMNnd5P9EJT78x+5TonAPLsvouN9xFK3LYF0v
	 Uvnr9HwXK34HCPY6wYKHuxb7TZqWpNb1M5G3lIDEHv4RjNKxp5BqpaA41E9lPrxCyhuj/
	 p9WeM5nUsU/L9nCUhFGFot+S9h3k7DlIsF6gQfC80PbjfpUYPuc65Xrh4CqzrVXSJwgVy
	 0sxMzFcOAwBfWqzv43BYGPm7XvY0vujDuZzgEFJuCjsYOKVn8m30Uk1kHoN/3+qbmnP5t
	 RSYBzWYGjyD9juNGvWemW49BgzfqCB60IzHcCW+xWDMtKcdh2PfGP8WQJVrE/20iT7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="TF8/JiTE";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6E0606A31B
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 03:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TF8/JiTE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D9C1F000C1;
	Wed,  4 Nov 2026 03:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793763218;
	bh=ceplu2oppQPensG9AZykMphuy6zcdHZhji9fasLS54I=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=TF8/JiTEI6ENgd4mp4nRn0ubTzuCzY9vduKSihsdftrdYWtbzjsBx+JNaTBc657KM
	 ay8Q2NvAbMVmTPzbCKiFhnwn3j9ndwKK+0n0JqkvXNF7u5AA/ka1f3ZE2spaWQrfjy
	 GtOSmBjlXZvyM5YKwgWhm4e6B/HrtU6ihhUnmu/rVlr9ArobYYVe4JArquCHTHHe1L
	 QIH2I3DmFuO64/o9nzpCvbiW0Y5s7dj8/oYgJMDWLzl1Vqa8AohfD764ybXGoJzuzJ
	 IHGcuJaZj+nmBCYGr9PD+vSAjL8ItFW06Oxpf1cX3Q1u6w0EmsEORUGgCLL2nK0Tbp
	 LudA202w8bRAw==
To: Matt Wang <matt.wang@broadcom.com>
Cc: vishal.bhakta@broadcom.com,  bcm-kernel-feedback-list@broadcom.com,
  linux-scsi@vger.kernel.org
Subject: Re: scsi: vmw_pvscsi: add boundary check for cmd_map access.
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20260929231459.630938-1-matt.wang@broadcom.com>
Message-ID: <yq1wlqt1d9y.fsf@mail.kernel.org>
References: <20260929231459.630938-1-matt.wang@broadcom.com>
Date: Tue, 03 Nov 2026 22:33:37 -0500
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain


Matt,

> The context value provided by the device in a completion is used to
> index into cmd_map to find the command that was completed. To prevent
> out of bounds access or completion of an inactive context, check that
> the context value is in-bounds and that it maps to an active context.

Applied to 7.5/scsi-staging, thanks!

-- 
Martin K. Petersen
