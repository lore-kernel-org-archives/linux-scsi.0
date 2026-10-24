Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792809899;
	b=1Fbc53nflIcF3+Lb5F06OMMHByod4DwO64pydESv4VkGcL33XniHTCJiq8SPYPBSPjF9
	 4QMhvV7yjaoijx2lyRU0Be3330KRVd7p5ZCcA3FONRaLKhoQtGETKYDBMOvyuh3Fg1HYL
	 JqFO2gECJc8B9O2UJeeK0YMrC5qDYlSqJJ387+r5lhfVBfweV6fvW2D/r+97pG2j7iq9R
	 Eqm9r0BBEwmyk31YncJ5nNO8/k4m+4VnIdMzfiBQ5l4DsFAYkW2GQkKzb8rLck0l1MDe9
	 XbovDYGgDRNWd5zzWJ+obo9BMIVQ+F8Hlb69Cu6qQe02mnnVkH3J5OaiE5AzVLXWS0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792809899;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=5oOHR80kln4/FKXjXlh94PGILjhb4KFwok10GjZHwZE=;
	b=SLZtdNgDzSBfjyYsXy9S0SwYDXnpSrJ8g2E8I/ECb3abpQ2HpUGE1zz5aPWGqyXJ4WRM
	 5HRf1MiIfYeB65G+tUQ06wO3wG8ygfDX5zSPeICrzB99s3g7rv8ezsJPDQFHmWshwkjAN
	 UfGCTdsrGY0SxbGhW9AAaJvrS+6uXPYZnim3CpWYIroXIo1GBQ/Bf1Z6CbtckbfQFR8Zo
	 FTNIUXl/HJ1SXfKwLBLa38owOG2u3bfvNheBRkj2SM7CTKqBZyWOn9E0DIcf9i6Yj6kxg
	 K15rqiv9lL7wZvMonaKAJMbECIHhjSULGfrkNd3LA296JpyFFrqERIkNQdVWA0tBzGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JaoBz6IE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDA4606A31B
	for <linux-scsi@vger.kernel.org>; Sat, 24 Oct 2026 02:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JaoBz6IE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ADE81F01825;
	Sat, 24 Oct 2026 02:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792809898;
	bh=5oOHR80kln4/FKXjXlh94PGILjhb4KFwok10GjZHwZE=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=JaoBz6IEu1xkalTjVfqwo4prB8AsE4gVficIJa3w2Ke7AlaDiMd+ci2muLWCLlztJ
	 QPzXp6vl2rVw1JdYgQlgqhKOdrS7/14Xk+qJdhpXZSBmElXVZeBtv3+06Xia9hYYyW
	 W7nL2ZxBcxRIPh4nnPJiwSmLG+HkHd9UE7aZz2JqNIjQbbK6CqSbQn7i/C7xaURSJ1
	 enF9ivyxr2h1GxSi8lCS/EyCUZKhKs6juw3b48flOiduJswG3jRrK4BSSl4EXxFOZJ
	 e92+YXYXYzYjgANpsR65RnoN0XPcYZrayUYmIFgKl3UKG1YzE8SXWEGdf+NVdpUP3M
	 xUnx8eT7G3klw==
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
  linux-scsi@vger.kernel.org,  Nathan Chancellor <nathan@kernel.org>,
  Satish Kharat <satishkh@cisco.com>,  Sesidhar Baddela
 <sebaddel@cisco.com>,  Karan Tilak Kumar <kartilak@cisco.com>,  "James
 E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,  "Martin K.
 Petersen" <mkp@kernel.org>
Subject: Re: [PATCH] scsi: fnic: Annotate fnic_nvme functions with
 __must_hold()
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <3c41b84d7d832dd767b30bc04cf875f800ce748d.1792283587.git.bvanassche@acm.org>
Message-ID: <yq11p9fakbl.fsf@mail.kernel.org>
References: <3c41b84d7d832dd767b30bc04cf875f800ce748d.1792283587.git.bvanassche@acm.org>
Date: Fri, 23 Oct 2026 22:44:57 -0400
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


Bart,

> Add __must_hold() annotations for fnic_lock to
> nvfnic_process_ls_abts_rsp(), nvfnic_ls_rsp_recv(),
> nvfnic_delete_tport(), and nvfnic_add_tport() in
> drivers/scsi/fnic/fnic_nvme.c.

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
