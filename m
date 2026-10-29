Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793237316;
	b=Mj9PFeW60Xx/egNaoGtsDlL1dmXnp75KAZ8ZNCQIujKhVqELytGm/0qv3OHS0o2oa7JI
	 JassDsLD/6PKRZdpRtZkv6MJu0EnaD8xfP9b3Zhzl3juh6bhaLgreiJGCxL0nFHjn+SDZ
	 hWuao7PQGrEnw5p8e5SNFQqz4VHjTkQEG93XKyms1ZxTLql6ddkj4RI0Ifta76m/iMFtg
	 Du4N50DbnWYrxZdKIElZHX9uBcd8PL6cpLJ4/I8pTEBewFpPLRsyS0bTJaYLfi2542sc7
	 I41gBH51Y4epAdg+hCVXaoFI4R83HDoOAY9LjDWkRTTTGQNoQhECdOU7dsBzHrYpqRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793237316;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=D0bcWDtBiSC9G7p3sTH868ZySBSNWw7tmJ+S91FtIWs=;
	b=lqcokY/b0mIYFBDAP1kLOzXJlhcwB9iotVzVk8u3+cK+C4n/x+oOOC80uHDT5BdiL2Cn
	 Y4ocaSxXnLtpUEk6j4Zkmh7/dajYOd4ESvxffSIVAs83Wq1RfWIC9wkEP3O+UFfRdpdHW
	 ZrbS/TjxDjJ+We40VnHKG3vi0kLlJTMH5E73fuLbTdSiCXbMpte523mvnECxHiaP2y3Z3
	 C/HUW1uLkZhkFWrKf3mnfak5hH3ItL07XYFjT6kcDuqtKORN8zOpzLKzSAu+tHqnoSMzQ
	 R24bsE1KRmIv+OPz+J+IMmar9ursn1IFID74ObxrXL4OwpL8cP16sdOGPdYLmtL6AcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hFiahoOw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F99606A31A;
	Thu, 29 Oct 2026 01:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hFiahoOw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 607431F01828;
	Thu, 29 Oct 2026 01:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793237315;
	bh=D0bcWDtBiSC9G7p3sTH868ZySBSNWw7tmJ+S91FtIWs=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=hFiahoOw+yTvzSdWbA/Ilkc9NNZDe4fkDxRkbB9SsxzJJQdub+nXyVLS8nlfFgefy
	 0PyuviXBKzDyHHv1IeIqrs7vmKEyZr6u65M+xRdiVBDFjSJFYZ/IAY6logCooQ9thM
	 tT8DpYHlhFl1a3Fp4bRjTIkVYwobU7ebw3BBLhvfU+TKEmellhdfeIh7s06fKER3jI
	 BNK5iBzgqgahWn2KfpxudUuRckuSojqeou0D6Bco/u/aS/kwKvjRE6bghjcHOV1Ut0
	 KCgCN9p6fhlv/l5vLto3Ft/THw3WWZmTAxDDFHtIgLQPUezyisyDOJ5tCkELqMPlcv
	 IHvC4xGmL4tWg==
To: HOYOUNG SEO <hy50.seo@samsung.com>
Cc: linux-scsi@vger.kernel.org,  linux-kernel@vger.kernel.org,
  alim.akhtar@samsung.com,  avri.altman@wdc.com,  jejb@linux.ibm.com,
  martin.petersen@oracle.com,  bvanassche@acm.org,
  kwangwon.min@samsung.com,  kwmad.kim@samsung.com,  cpgs@samsung.com,
  h10.kim@samsung.com,  stable@vger.kernel.org,  Stanley Jhu
 <stanleyjhu@google.com>
Subject: Re: [PATCH v6] scsi: ufs: Change the error check sequence for auto
 hibern8
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261027110357.3649301-1-hy50.seo@samsung.com>
Message-ID: <yq1qzh947ny.fsf@mail.kernel.org>
References: <CGME20261027110813epcas2p4011de6cde600db5c995d3a3e45b056fb@epcas2p4.samsung.com>
	<20261027110357.3649301-1-hy50.seo@samsung.com>
Date: Wed, 28 Oct 2026 21:28:34 -0400
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


Hoyoung,

> Auto-hibern8 enter and exit are performed by the host controller
> without a UIC command, and the auto-hibern8 idle timer only runs while
> no UIC command is outstanding. An auto-hibern8 error (IS.UHES or
> IS.UHXS) is therefore usually reported while hba->active_uic_cmd is
> NULL.

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
