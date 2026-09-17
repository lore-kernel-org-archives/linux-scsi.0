Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4152F38E8A7;
	Thu, 17 Sep 2026 02:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789612176; cv=none; b=WhMnk2l8ej6x05c+cRX0qXEn7dXo9CcFbVw2YWeKQR4TcefaQYaOVDFtdfPyW6Zp1qOL3GkmVaorj2z+scWSYcSLLePF/gOQ2QfPYGUWHxDlm1s3FtjUglPTYW4c+XqC7a9KGHhLTiYt8H6PPqA74Ty0qZLlYUsxTkTX2ec/JJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789612176; c=relaxed/simple;
	bh=dEv/y9WE2/+rjDp15vTiJ99YZS959Yai84H5aIO5DBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WU/aTf8YA829Qr1U4mmF6wHAhX70gb+rhfmQ3Npye6RIdgKbxN4d6CB8aKVIcqM+/jOQXT2TMeOg0D523KDWMrlsU2jAKAlme7ayZCksrvZzAVHS/n7lZSspP9+8zAx/fULENZkkkDYy11DgLY4OY9BHuWUto/NIeU7fbE1W7rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WsoryqXP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WsoryqXP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F0201F00899;
	Thu, 17 Sep 2026 02:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789612152;
	bh=33VwnawZhqR1I5iYawm8pYsiO9Ps5rqOBZ2lsKJryU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WsoryqXPFcmLS5vs7VtdTgz55opxbfr8MS5k8aEomMWlk8JxtGeRqEajJugl9vGFJ
	 PAa7drIx08kixbFdfIvOIhby9iUzpJ498rnlEuEYdsazt/mQD+xt8Rwp7fDuIBLyk7
	 gXFAcJafWPizh2HxB9u/L3mLk887hGNhOwlZH5cKLaZhpdOIWO4yjzu3ycnfGXXyoD
	 m22K33evqVV/EsPfBM3bzGz2jUu9KzeCwew3HrMmYOut5rIpPEqYjT5a6uc271D4QI
	 9OIReysOG863a2zeqsI1Iif56agClJTjJF1LVQKOhSvyk3zP1QzT0iYRbcJu5A55va
	 tB37S4KYZS2bA==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: James.Bottomley@HansenPartnership.com,
	John Garry <john.garry@linux.dev>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org,
	djwong@kernel.org,
	hch@lst.de,
	fstests@vger.kernel.org,
	bvanassche@acm.org
Subject: Re: [PATCH] scsi: scsi_debug: default to a higher throughput config
Date: Wed, 16 Sep 2026 22:29:01 -0400
Message-ID: <178952247936.2757716.16340169242532492744.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260902092844.1741533-1-john.garry@linux.dev>
References: <20260902092844.1741533-1-john.garry@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 02 Sep 2026 10:28:44 +0100, John Garry wrote:

> Currently the default config goes not give as high a throughput as some
> would like.
> 
> Give a higher default throughput by modifying the following:
> - set completion response delay as 0
> - increase shost can_queue to 4096, which aligns better with modern
>   high-speed HBAs
> - turn on clustering
> 
> [...]

Applied to 7.4/scsi-queue, thanks!

[1/1] scsi: scsi_debug: default to a higher throughput config
      https://git.kernel.org/mkp/scsi/c/2cf34575b649

-- 
Martin K. Petersen
