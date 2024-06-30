Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51DC2AE68;
	Sun, 30 Jun 2024 21:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719781534; cv=none; b=Fbbx+lNWfCukdLGevVQetuJyZyGXJz9mXnyZzIkCmleJ1YzcZ8fQCqGBM4ZGOtZzUNrXGdLaRJBfFE0vU2AkVP80gkBJ9uM3XdKNF2s7/5HTj82Vm/FH5ZpouffnxPLsKMW9Qn+gJLwleCwG3eSW7y0s0yto1/Y8xUvvm6hr1xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719781534; c=relaxed/simple;
	bh=rDKT9dJvwG1HlbpPQHiBUojKC3eE7KphcGqU7ssG1p8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=kAeGq+JBsmbBDUStBUi/ENF31VsF8WgrWiGN5dz/vZ1LHaNFB091vObRMuYUH+ssOg9ej0SwRqw8nDjRVIqPK6wPMLaKZX8kvLsGbGEuwiLEl0/3R8gFx7mFCBYEVJVpGjTkEieCl5z2QudipffdBMruD2SgTdhiBaVuTYv0aAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SjG6u6oi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SjG6u6oi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A4BFC2BD10;
	Sun, 30 Jun 2024 21:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719781534;
	bh=rDKT9dJvwG1HlbpPQHiBUojKC3eE7KphcGqU7ssG1p8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=SjG6u6oiBJcpQS4yWA01UfmGdWOAoKQLFdfH+z2SPxJCxmQ/zeRPAYUzL+DKfa4Wx
	 AhLDK0zaGVrUNoNCLgbmzQ8vY2tmXIvR3g6QYjq7z0H7lXg3wC8oXMpTgM7ZQ3F/dl
	 GcwdREzTtfhgY2Gh1baRrq+A+d2WsPL1hOPNcQbMJ6QSkvXRkWaCbkEjWu34dLJ/1R
	 H8MYy0FojAWIckwekoY84gT42mcCbbf9EJX4BrXTinKLc76XBaKuFzC7npu1Ff46Um
	 bpB/jUQYqlbM1bGrjV09JnoWma10d/qF1lLSfi2CgiSOOA773bMp4unGIhGd5vmbFN
	 0l7+3God9VBww==
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>, 
 John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>, 
 Hannes Reinecke <hare@suse.de>, Colin Ian King <colin.i.king@gmail.com>, 
 Jens Axboe <axboe@kernel.dk>, Kai-Heng Feng <kai.heng.feng@canonical.com>, 
 Niklas Cassel <cassel@kernel.org>
Cc: linux-scsi@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>, 
 linux-ide@vger.kernel.org
In-Reply-To: <20240629124210.181537-6-cassel@kernel.org>
References: <20240629124210.181537-6-cassel@kernel.org>
Subject: Re: [PATCH 0/4] libata/libsas cleanup fixes
Message-Id: <171978153101.206174.2694352550562640412.b4-ty@kernel.org>
Date: Sun, 30 Jun 2024 23:05:31 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13.0

On Sat, 29 Jun 2024 14:42:10 +0200, Niklas Cassel wrote:
> This series takes the patches that are -stable material from this series:
> https://lore.kernel.org/linux-ide/20240626180031.4050226-15-cassel@kernel.org/
> 
> Changes since series above:
> -Fixed minor review comments for the four patches included in the series.
> -Picked up tags.
> 
> [...]

Applied to libata/linux.git (for-6.10-fixes), thanks!

[1/4] ata: libata-core: Fix null pointer dereference on error
      https://git.kernel.org/libata/linux/c/5d92c7c5
[2/4] ata,scsi: libata-core: Do not leak memory for ata_port struct members
      https://git.kernel.org/libata/linux/c/f6549f53
[3/4] ata: libata-core: Fix double free on error
      https://git.kernel.org/libata/linux/c/ab9e0c52
[4/4] ata: ahci: Clean up sysfs file on error
      https://git.kernel.org/libata/linux/c/eeb25a09

Kind regards,
Niklas

