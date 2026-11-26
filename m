Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795664047;
	b=YhQxyH70Kw6EXqhCaKk5ei9ZaGj5BHfl40ep9TVq9tW5HKmdIAtxBZtI1soN/ce96mFY
	 bjDmRrCq5ITtSn21o2tcRctwHraVTFYHX6dHkzge5redn81QuPNrZgQaf/7gVyETq3tCe
	 QdF5SJfX1Vx5gRSlPPplpIgsvwffnjXUe0ofIPpPvVvP79jRrYMTy5dQR0+NE1ZLNB1lM
	 29poJRZSUhKxOm1poVSDSsd9wqR0uHy9PWKQrZE5ciLpWQ683OnoTsyH9iX3VvGqdBlyM
	 i23hDHO+ocEsJ1grYAxxqbT6LZfP14TkHw7EtJYopZkTv9XbhwGpHCZm+2M/xrkB9yA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795664047;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=a4ZWFEpxOzRrb4f83qhPqbcObb4Vu9618O1GUeM3IqE=;
	b=yLKgkfBUAgFNArYv+VMFqW7kSZ58eDmjTiLfy0aSLpuhTMrP5MzU42C4xIK9NtbHPj+Y
	 45mxv/F0zDU4C3UueER5LuUAtxdjKY8viHaOUQ7K4GbvD/IYhUtALoOuLgduUGMfxHPk0
	 okUxpbeeGa6kW2rMlzdqGE9pYGZvl+Pqn2h63r+7AZDx90aon/Y7yQlx/fraE4AZ60bN7
	 bHyjZy4vS+aK9tVIkv5JH0O9h2VcFVB3yn/laH01I5SsLvL2vvmRIY6BNFmVYqXftgvCK
	 bIplAcHv6jD1T0ffL0vT31cQ8yuG3omL7fwr6N+cEc5TSL1VPl32OFEtGvFRsK0dcXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LDe+k4vW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F67606A321;
	Thu, 26 Nov 2026 03:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LDe+k4vW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 321B01F000C0;
	Thu, 26 Nov 2026 03:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795664047;
	bh=a4ZWFEpxOzRrb4f83qhPqbcObb4Vu9618O1GUeM3IqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LDe+k4vWHFuGVjEhwNV6A9ag19z2clMSUZ2W92KAodG1PSO1oxy9Ic4fr2r8EZknJ
	 5Ncw4T94zrBzGA0bzp9+6DVT7CK5eXsPLtkjNB/wGWFfcJOkDFEA3l2KuwspDGL4i5
	 EOlw3IXDqBeNxl2ukW/vcWk0xEF2FS9dkhD7xWndGdwWAlrtdPNtqgXCwfUVyxo2nj
	 IEIkqRfyZe7XFwvI/gEXyv9fygzKUaY0auRdL5vRRi4gvoNeiabQVIAfoxulDvoN1u
	 xwueetMd2/lcccADa+EsaWYlxChL8wMkuoVoruZxgSKm8U5hr0FfOX81pO9wpvzYWB
	 3SuRDUOrPAlNQ==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Xiangwu Lai <laixiangwu@cmss.chinamobile.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	Orson Zhai <orsonzhai@gmail.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Chunyan Zhang <zhang.lyra@gmail.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: ufs-sprd: Fix vdd-mphy regulator leak on probe failure and remove
Date: Wed, 25 Nov 2026 22:34:03 -0500
Message-ID: <179566379528.549112.18355302489100184825.b4-ty@b4>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261110065457.1280-1-laixiangwu@cmss.chinamobile.com>
References: <20261110065457.1280-1-laixiangwu@cmss.chinamobile.com>
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

On Tue, 10 Nov 2026 14:54:57 +0800, Xiangwu Lai wrote:

> ufs_sprd_n6_init() enables the vdd-mphy regulator, but nothing ever
> disables it again: the driver has no .exit callback and no other path
> calls regulator_disable(), so the power rail stays enabled after a
> failed probe as well as after driver removal.
> 
> The UFS core calls the vops .exit callback from ufshcd_hba_exit(),
> which runs on probe failure and on remove, so an .exit hook is the
> natural place to release the supply.  All other vendor drivers in
> drivers/ufs/host/ already provide one.
> 
> [...]

Applied to 7.4/scsi-fixes, thanks!

[1/1] scsi: ufs: ufs-sprd: Fix vdd-mphy regulator leak on probe failure and remove
      https://git.kernel.org/mkp/scsi/c/4be084ac36f9

-- 
Martin K. Petersen
