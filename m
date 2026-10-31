Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793410828;
	b=ReVLVH+xF3pVM3QyiV6KNqn/Z6traAmJja3gsQgk6vNJISVMLDN5I/swAWN+CgL73KCo
	 Mz/YQurTzTWQ/njM+0QX5Vdj8ciO6Aq2QDL+zlEYcEBvuNEd3z7qI96y3KQm8wEWEXxj5
	 DVCdNRFMaTEdzTDJnWNx2A3n1rWrVQjEMUiwrCwEUpDPXy9+xQmjtv2gSPu3nOliEAzgM
	 Fd3qI/G+fw5vUWq/bo2/KHKGi22umiWiwPH0OFo0o8jYNu1zROwpehiS39s3sobN1I0nk
	 l3kfbLUkmpBIEso7d3UXeQaVRkImO6Ti59lQd1K+orzZZ5HY29x8MAgQIP1HbQ6Qjdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793410828;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=98D7mBse7sjFF0w4g4HxetS/1PSF+M12i5Y1TE9fdT0=;
	b=zDPBpuIdWtSdAotcgwQuqcrK4ZdrTTsJKkgcV2I62zWrilU2uTRdReHv1GI8fXxWTfpl
	 dKwCC3b2o7b1TrUHIV+lZM8kxpcr0GbNZuXUzKCYJEHV3AZ1w4fU7f4k7ogwGKcIjyT3A
	 /tMdtXbFASPMLLz42hAg7HZ8sOqCiuLUN21xBB1QSxPKYVtWK/9gnvKs5dSqSowH1aT8D
	 u6LSEW58DZCCXZTEGUmVpLRQ+Hsf18LimQ1XfhDJGiq25Z2utEedmjwC4IqOfls6KIw48
	 sBqcQQn2EyFnBWXdb9B4rHeGjOBbGG4sAsykne3vpmIZ3ijcjRZIzQnp/Cib7+BGD8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VvXvjg4b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C81260A2607
	for <linux-scsi@vger.kernel.org>; Sat, 31 Oct 2026 01:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VvXvjg4b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D9471F00A02;
	Sat, 31 Oct 2026 01:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793410828;
	bh=98D7mBse7sjFF0w4g4HxetS/1PSF+M12i5Y1TE9fdT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VvXvjg4bCkvUXbJKfc14oU32QvZU648SerRsuy5PLoko+tO4KCODs6s9rwjKCVXZg
	 Q0Bk4SOhEaddZ989WaeDngQJw3MjMqI9JWIWBYS3ttMe9yxdtVXxCI/KVt1MJBxNxd
	 ikllmnqLSiJyrx7bapcGjzSDKSff2txClIn46q6R+l0SBbYBGZ7UaLRWmgEMV6vDqf
	 a60Eo7dz+QWwCAkgbTmZ3ynViwXnF3s+WgfaZzSy56bykl5eoFJQpA3tgJkd6A4D6F
	 KXaXsxPfxgdc3ylGfbB+lRknFA9L2nMEzrK90n3NuxnnTBgFGm5w8p/xZbiwpFF/0n
	 ewk71V/zxBYhA==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: linux-scsi@vger.kernel.org,
	Matthew Whitehead <tedheadster@gmail.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	James.Bottomley@hansenpartnership.com,
	loberman@redhat.com,
	emilne@redhat.com
Subject: Re: [PATCH] scsi: aha1542: Remove unneeded scsi_dma_unmap() call
Date: Fri, 30 Oct 2026 21:40:13 -0400
Message-ID: <179340755638.952351.662755375610107343.b4-ty@b4>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20260929144528.7061-1-tedheadster@gmail.com>
References: <20260929144528.7061-1-tedheadster@gmail.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Tue, 29 Sep 2026 10:45:28 -0400, Matthew Whitehead wrote:

> aha1542 never DMA maps the command's scatterlist. Data is bounced
> through a per-command buffer allocated with dma_alloc_coherent() in
> aha1542_init_cmd_priv(), the adapter is programmed with
> acmd->data_buffer_handle, and the payload is copied to and from the
> request segments in aha1542_queuecommand() and aha1542_free_cmd().
> 
> The scsi_dma_unmap() call left in aha1542_free_cmd() therefore unmaps
> a scatterlist that was never mapped. With CONFIG_DMA_API_DEBUG enabled
> this results in:
> 
> [...]

Applied to 7.4/scsi-queue, thanks!

[1/1] scsi: aha1542: Remove unneeded scsi_dma_unmap() call
      https://git.kernel.org/mkp/scsi/c/9ec6671b137d

-- 
Martin K. Petersen
