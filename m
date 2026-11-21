Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795231506;
	b=KTi2MINWFO5whvWm+sNpR9nGqLWKxm1JQ9X19SV/RQri1fubZhgNQtw+dms8x0xTRysU
	 RS9FDY6EUek6Ki0VDjDkgl5k3Aw+fJ8V+HY2hBkdTaewGrnc6N0XgCLuLApOAnAuVQkty
	 M5mxpw0SrAlVHGnfy4GWesXUlDFTepS3+dQwsv5/QOl9EZj/CrKoUfCNkKSExvHOiePim
	 X0Is2xmy0R+aY84hEIdTO40twQIFWv9qXK4mlxKWunW/mcCPCdiXkRFkOnJi5+teJ0S8P
	 bFQqCL01xD1YvrlA3LSUD6gWPMnAeAs7XCSdsBeCVRwiOZA7F06yvbZnitSrJFiq5lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795231506;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=IEi+AatW8creQi+GveL59vc5E0ntLQggVbochSSnoRc=;
	b=3KMpwK1E3YPhzOSUYa25UnM35mbFNJd9FFF7Q26BBqamCS+bNE+gU4M/X0bHk1t+WoxK
	 FKmLP6tnNBsG21yTy06Lrz5fYVRQ/G6jbjf0Dfh2s9kn22IjAqq5Eqd0n27smOyhZcvet
	 R61GZvJ4Nw+316uQ/NwwmLwz23MZ7R7q+EWcddwmHFdiTPPcrKi+D3hYZxuz+Z+jYT/v0
	 nyIUsEOz8ZVH19r/+uxgjvvS3Pmxj52gvmkS2qmgge0spQD9GeF0XPcVNkmvVb8mDYkG7
	 Qu+kpv5GcZ9Jv0aAU1nhq9hxd6fOqvDqdkv0JzUlpPcDWolNTHDOlb73REr+mjAVD9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Fw3J7XYG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED33460A2612;
	Sat, 21 Nov 2026 03:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Fw3J7XYG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 308161F000C6;
	Sat, 21 Nov 2026 03:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795231505;
	bh=IEi+AatW8creQi+GveL59vc5E0ntLQggVbochSSnoRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fw3J7XYG/YcmjDlBYwy8FNi7OJwZY6j34Hf4b2LXcTwa0eGPKipryluuHjFxqEO3j
	 joR2cEJ5eeKlvc/jWSFDFeZloQgv/LNRjBewmSVbop5uBUNGr1bA3BfFu311YOxkjr
	 9p5bio7qcJdWD80XErD0FpXccPaKIHVVLc7T02PYTajZon1JK8C6vbefyr5A0CuuRz
	 WTJHXLDOD0xI+z1q76qa/yC/PgOkN/xYLrKiAgH1UWdZTcgnpX5hMi7MFQwLxkQLc0
	 EmEcMpTLcSH9WZdj0s0jIWZEVv988t6lxGaOm3RY1h89E0nMjmg6dmquqSpe+EY3U7
	 pok5P4rrOWp+Q==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: linux-scsi@vger.kernel.org,
	suganath-prabu.subramani@broadcom.com,
	sreekanth.reddy@broadcom.com,
	ranjan.kumar@broadcom.com,
	sathya.prakash@broadcom.com,
	Weibin Liu <liuwb@xiaopeng.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	linux-kernel@vger.kernel.org,
	James.Bottomley@HansenPartnership.com,
	MPT-FusionLinux.pdl@broadcom.com,
	stable@vger.kernel.org,
	zhugl3@xiaopeng.com
Subject: Re: [PATCH v2] scsi: mpt3sas: validate data_out size before SMP link-reset check
Date: Fri, 20 Nov 2026 22:24:51 -0500
Message-ID: <179523145641.420187.8741773838840772742.b4-ty@b4>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261029073316.4188569-1-liuwb@xiaopeng.com>
References: <20261029073316.4188569-1-liuwb@xiaopeng.com>
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

On Thu, 29 Oct 2026 15:33:16 +0800, Weibin Liu wrote:

> _ctl_do_mpt_command() handles MPI2_FUNCTION_SMP_PASSTHROUGH by reading
> data[1] and data[10] of the data_out buffer to detect SMP link-reset
> requests. The non-IMMEDIATE path sets data = data_out after checking only
> for a NULL pointer, so a payload shorter than 11 bytes can read past the
> end of the buffer, and out-of-bounds bytes can unexpectedly set
> ioc_link_reset_in_progress and ignore_loginfos.
> 
> [...]

Applied to 7.4/scsi-fixes, thanks!

[1/1] scsi: mpt3sas: validate data_out size before SMP link-reset check
      https://git.kernel.org/mkp/scsi/c/efd68f17acca

-- 
Martin K. Petersen
