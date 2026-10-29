Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793237713;
	b=JnpkJFG8UcqLmnypfRAa1Fzxmbc3UOMCD0Q8jnkQ0UIrwdTLomdsYbdM0jvVmIsaz13c
	 11Gi0rs5iSA4O0BJkN49aBf4vgRvXRZb1Q04Esm+FQ8226kC0vrqgV3DSI15RAmV46UJI
	 UrW6X2YzuDntKF1Dk4IxXx5OTr1ej7McuNOcAb4cgxXpO02Twvk506GpVc9jM5/er61G1
	 koTWgOkmHEeLiXvOmwO2IIhie2alld5AYq8li4160AAZONtNT77QYqydeaVaNmizfl0bz
	 UjvdfY1HL3l+Iq6+3tx+MHnTu2IsySjh3nsaCLHInXwqUoW5QfQL2eNQGIazpfEVtTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793237713;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=YTQbPLZdljynDrxBo8DTmK6uAqdHD2fhUvpVN91xXPg=;
	b=pzpqueStFawYWzTVClebu28x2C/o1gME4eQko44YlXqTRLONxsTxB6pfiBxAbRh5Vq3W
	 VFFtYHnjtCeZWaD2BtlhDotK4e11ZyT2B8HMx74gKtzsPbjtIwKOfRz9A/M1B53ASC50s
	 qm0Jj87Msy5CHJbDVxR6vZg6LlZ+NUVxBiJ0BFWtEjFbMEnlxunUuGdvCfcarbrPcmcto
	 AY13trT4DsZo9zB/r/vdq+jynLB9rsQJYSEdakIrwbT79FAfWyTdKLyun0bdRW2SuLzMV
	 lAsTR4q/etgnxno06KjcAMS0XpIf6UJv3fLS3y/oPKTFMEcxG2LlvTgjgscEhlPENTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hvUkdLWo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92A7606A31A
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 01:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hvUkdLWo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26CD11F01825;
	Thu, 29 Oct 2026 01:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793237712;
	bh=YTQbPLZdljynDrxBo8DTmK6uAqdHD2fhUvpVN91xXPg=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=hvUkdLWo8XlAtMy4FDOfOhvbl6UnwFFsLMQjIxg8nJeKwq5Tetlxfem1ydIE0zh//
	 mbvUulHQtb9O1SO7UZKHXFnfbPXk9ByvcmkuQndtfneas52CJyjaPDooNAyApM+f1L
	 gGmoT4xvFoP9A1WumPZ7DnPY2AMqrXSxJ7DJcsi63ZoRQ7xFZsK3QVKxQsbbp6Tfvy
	 Slaf3g+6x+p5nNn+hYdO/WcqBudYxHC7TrEeE7EqCCpIGpdZ2vNnMenmUnGkh0NBqk
	 0FxM2xtwjet4LntW7nI0eg72lBQvplfUXVhFfMr2jnjRVKPqWF7NxTndEjzenpu8BP
	 E4X+pNsWc+Urw==
To: Matthew Whitehead <tedheadster@gmail.com>
Cc: linux-scsi@vger.kernel.org,  mkp@kernel.org,
  James.Bottomley@hansenpartnership.com,  loberman@redhat.com,
  emilne@redhat.com
Subject: Re: [PATCH] scsi: aha1542: Remove unneeded scsi_dma_unmap() call
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20260929144528.7061-1-tedheadster@gmail.com>
Message-ID: <yq1fqxp47cq.fsf@mail.kernel.org>
References: <20260929144528.7061-1-tedheadster@gmail.com>
Date: Wed, 28 Oct 2026 21:35:11 -0400
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


Matthew,

> aha1542 never DMA maps the command's scatterlist. Data is bounced
> through a per-command buffer allocated with dma_alloc_coherent() in
> aha1542_init_cmd_priv(), the adapter is programmed with
> acmd->data_buffer_handle, and the payload is copied to and from the
> request segments in aha1542_queuecommand() and aha1542_free_cmd().

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
