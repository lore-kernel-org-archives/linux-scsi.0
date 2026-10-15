Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF6B1FF5E3;
	Thu, 15 Oct 2026 02:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792029890; cv=none; b=lX75rhePNC6sRBYW8RokyBaIYi4lRc60QxeGIGCY/e1QOGBf5i+mR27PruO16LGjsaZ3Uf3fEbLP0GS5NOAPsVpQlnTQb8rq3sVBsSFwMyXXadm+C1lwqm/7yPRsBvT4OaSc2E8i+8iJdHYRqtBe6WO6Wi6TU8hBuVSXWEV714c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792029890; c=relaxed/simple;
	bh=3EN2n6tsRfuLqtnC2GF+hhqDN8T293BZ5Fa+7NgYhCM=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=ePabu5APAq0vEIGG7i36NV6MPHuDu4RLIPS/kkbm8oLZVSd+KoSlUO3LANs9bIIiq4lJb9YQAL30UY3YmusU8eUknyhTL2x/h+N1vel3vMl9IizKh50WIgxalVXPMA/gFVA8VcbIaLJVrvXL8YruHz2VFqCPAiatRgDWnV8FXNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=euw69Xlh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="euw69Xlh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AB1E1F000C4;
	Thu, 15 Oct 2026 02:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792029888;
	bh=RHVtziQSmgYAsUkHUqLWwiNHBBLscznwCyo0DD3VuI4=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=euw69XlhYResONp7UkDOuhNCCkHRo4y0qVEJAS0dp2TegBo9tn96ZPneHF2YTKiMX
	 spjMOW+8yRWRcvfI8SuDYebAPGhbtRvFZxHQwPN47nCC4tz+X5nKKrlTxdL8/2T6Yb
	 y6OPVed0PZ8BauRSnt0EMJqaJzjO3rj1ON37K6dJcM8Sy/dC43SczkJ3+3muww8AjC
	 dILQ1T29yGyhktRvHpsBySKTpXf2thEg8gIdGIE7OaY77iam4kQ1X0yBlsvMJgINW/
	 /NgjWd0ptktgw4Hj5K9wqVykbKvK1wvz70/PFFygoJbrFUzQtYRUKyPSE8jBlFbQJe
	 BuZIhxvvwYGYg==
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-scsi@vger.kernel.org,  target-devel@vger.kernel.org,  "Martin K .
 Petersen" <mkp@kernel.org>,  linux-crypto@vger.kernel.org,
  linux-kernel@vger.kernel.org,  David Disseldorp <ddiss@suse.de>,  Lee
 Duncan <lduncan@suse.com>,  Alexandru Hossu <hossu.alexandru@gmail.com>
Subject: Re: [PATCH] scsi: target: iscsi: Use crypto library API
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261001044857.169487-1-ebiggers@kernel.org>
Message-ID: <yq1tsmnen2z.fsf@mail.kernel.org>
References: <20261001044857.169487-1-ebiggers@kernel.org>
Date: Wed, 14 Oct 2026 22:04:47 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Eric,

> Make iscsi_target_auth.c call into the crypto library directly instead
> of going through crypto_shash. This is simpler and much more
> efficient, as it avoids overhead of the crypto_shash layer. The hash
> computation itself also no longer has error codes that need to be
> checked.

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
