Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794973452;
	b=0msA+DyreMNnk6UdWn3NLbR+90ckDUITPN6czUxXy6+//DpImsRryOUxYrn68AO/sRoC
	 Q2d6MOrGyLEVgWniT9mCq+g3h5f3x5/6bWC7vanKUIZhZaz37u6GE50yAQVlAr26pJ7Sb
	 Kulg7hdX7y3qFRpXHNUAy/RZgcZzF9xS7o4Mg070yE/oeBcGnW0qm9dCedA6B6D5kXaf3
	 NsyvEB6vs4+cTkbccE+cEzVwB9uVgjOxTcZqHa7byIqLVzVt6UO5bRbLZotNwSAoNQ6ep
	 O8kzFJVwoAlliSasZAja5mc6CsCxJVTrG57L0PSN9uhe/qKOc3KZFAiVrRxPM1flm/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794973452;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=oeN4UYKbcgSbiY4OCoag9qZm+b1F9hp1E8jsUt1GOFE=;
	b=rSQuKyyOgCVKnc05CeV0SnWeoWQusSc1c2VNLCbXVQsVbWDXwa93fGsERDmnOLH64WXr
	 9qG3AWrv8DnUncmI6PQ4FSnnWMGRPsmoDmlZF4gQFDt8qmzHJQxQdb8PknHA3xIU7cBCm
	 bYdZxZinm09HFJ4/8HVxat5mihA611HlHHH3gWzN9/t0wiodTWi7DPX4JVPMs5OL1JF+z
	 I7r0VAGeS1XV5eE2fuNnRDTxjq5PL9J89nLqCBEDp0InVLe/QUtDw5FqUP9C1CLFV2J+F
	 etj57tQa3FT/2ZDB3mgbdWIrnkD41ZT8xmzAwN1AnPMe822ZIeP1b4WiXKxX7NArBBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nXy+iuCQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48294606A31C;
	Wed, 18 Nov 2026 03:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nXy+iuCQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74ABE1F000C4;
	Wed, 18 Nov 2026 03:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794973451;
	bh=oeN4UYKbcgSbiY4OCoag9qZm+b1F9hp1E8jsUt1GOFE=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=nXy+iuCQ7ptXv1Y+PJ4LrEDWKnA1lLI5kPQirXSRT9Y6GXELoiPbEiPXaAwPfmC9v
	 TZxVgE0sdOJmEDAKy2hKRIh9pjid/Nh7NtNZ7jePwlJFH9icN320U+YOmTILUn2JEC
	 tqOLos4bhzc5HmBMKY0Njl3j9p5eHsZ6Nn+HUIM1kr7Uim++aDCcK3+dvIzI84kdRQ
	 RbuHprEf9+Ph0R73wTOpVO7WkirG9mWsDVwF9MbwJ5y6kj3UR01YVws8FTqokM9u+E
	 vz+pQW7LjNWbrhDmCpgsJwzHEUeylnduXu5MFBW+jliYnstSZnN0bVj38ABSb4SCut
	 0JlpDk9GMpEIg==
To: HOYOUNG SEO <hy50.seo@samsung.com>
Cc: linux-scsi@vger.kernel.org,  linux-kernel@vger.kernel.org,
  bvanassche@acm.org,  mkp@kernel.org,  martin.petersen@oracle.com,
  stanleyjhu@google.com,  peter.wang@mediatek.com,
  alim.akhtar@samsung.com,  kwangwon.min@samsung.com,
  kwmad.kim@samsung.com,  cpgsproxy1@samsung.com,  h10.kim@samsung.com
Subject: Re: [PATCH v10 0/4] scsi: ufs: core: Avoid redundant link recovery
 from the error handler during PM
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <2052256418.81794387787276.JavaMail.epsvc@epcpadp2new>
Message-ID: <yq1mrr6st1j.fsf@mail.kernel.org>
References: <CGME20261111082303epcas2p180a7cf157dedd181634550630fe78df5@epcas2p1.samsung.com>
	<2052256418.81794387787276.JavaMail.epsvc@epcpadp2new>
Date: Tue, 17 Nov 2026 22:44:10 -0500
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

> If a LINERESET is reported and the hibern8 exit fails during system
> resume, both ufshcd_err_handler() and __ufshcd_wl_resume() call
> ufshcd_link_recovery(), and the two recoveries are not serialized.
>
> Patch 1 makes ufshcd_link_recovery() clear the saved errors like
> ufshcd_reset_and_restore() does, so the error handler does not act on
> errors that have already been recovered.
>
> Patches 2 and 3 make ufshcd_wl_poweroff() behave like
> ufshcd_wl_suspend() by sharing its implementation. In particular it now
> holds host_sem, so that the error handler waits for it, and the release
> of host_sem is balanced if hibernation is aborted.
>
> Patch 4 restricts the early link recovery in ufshcd_err_handler(), which
> does not hold host_sem, to runtime PM. For system PM and poweroff the
> error handler now waits for host_sem, and for shutdown it stops.

Applied to 7.5/scsi-staging, thanks!

-- 
Martin K. Petersen
