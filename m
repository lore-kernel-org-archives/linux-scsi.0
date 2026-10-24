Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792866866;
	b=yyOtaUDLn03td5lpEHrl/Etd2Nzi/8UyYjGQVo/TuO7oNAE21J2bnqIQmIlc+NiFwHcH
	 UQKjr5z44kaLBcTlKqSYwvFuglHKrgD0XmuLRF4kYaeZxTupeAXPBg3r/7RoNPgw5y/4H
	 6OXPSh/4Gw+ovAMbsA1phTXuS44JAOU04W+3EHEGFb0+SI/BsTDBGDrumWKV8LuOwrMoG
	 6tTf8We7bz6BBxXb/EOGL94LVXoM2NitDSGmn6mudK4ZaSJDEuYOTarxn4tsjJ0hvy/uN
	 eHJAs/5VEIoZFhbLJU5Chzn0NdOJH/6as57K8GpfkBl4UPvYHg0GdwMSfooGhZqrgpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792866866;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=s9nU0Fvjo6mdgiLcbDY45ODCWAqQuhzbgwNHXYseekg=;
	b=5FYKVhwCP8F2kn5qFhcbsE+idRHKUdrhCgNa+9sRLw10hE7o8ApC0ym5Le8uZKgJYzx5
	 rlf+uTq/bs5iiibs9JaYBtufsbrcPLxVwsD5qP8kNPWed0NYURykQHEJhIJ4Isqz/PKGw
	 yoAFXreM7UoEUp2+3XG/UsmcepCUM40aNl6+MBk7sf2uL/wwTq+yyNs3cqgTlJZXEivbP
	 x1hxRMLlTPFH0hKOLW+aJlYDLI1pODkCxqHjDCQJ1v+EsNrdLlQhwMLDsFChexYV1ZQCR
	 /m5YbF7xiMxLcNFsGk/oDmotA+IfPpZYWLYajcrVti8kIzoO4EGS8B8TWvoaI51eHYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZEAfbq+Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7519A606A31A;
	Sat, 24 Oct 2026 18:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZEAfbq+Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5A3A1F01825;
	Sat, 24 Oct 2026 18:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792866866;
	bh=s9nU0Fvjo6mdgiLcbDY45ODCWAqQuhzbgwNHXYseekg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZEAfbq+QS+iGW5wz+Dd4IG/JP/4IWmkZACSMVb5KeFTV1lIJzPUc10pD/gIHcCDnd
	 6v5iqBCF8jpqrwyMGMQNJnRgyYxJWq/Of+OwLz56dh6TDTBM5VHn335gecS0Z4nVZZ
	 S3UvAP45hk3gy00vG+2kGgtgZANthcu+9Zwf4PhXzF/O1BHPTesKi5egOFaHV/cUpB
	 hSL7NIB17AYAlliqz01nMvgQUE0+R2fKBSfhkZILHDgL+cd+Y/Yf6w/rvHnfgpXeXd
	 OaJrrzbjP59vkr/D4b5S1OBGJYggjd4hGt+CavxDysPf1De5LLTD6XGoSxfVd5AW5H
	 Lmm0O0wbXebyg==
Date: Sat, 24 Oct 2026 11:34:24 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulfh@kernel.org>, Abel Vesa <abelvesa@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>, linux-scsi@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH 3/3] soc: qcom: ice: Add runtime PM support
Message-ID: <20261024183424.GE2553@quark>
References: <20261022-qcom_ice_pm_enable-v1-0-f7a84086c651@oss.qualcomm.com>
 <20261022-qcom_ice_pm_enable-v1-3-f7a84086c651@oss.qualcomm.com>
 <sashiko-outbox-181342@kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-181342@kernel.org>

On Thu, Oct 22, 2026 at 10:34:40AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 5 potential issue(s) to consider:
> - [High] soc: qcom: ice: unclocked MMIO access in qcom_ice_enable() when !CONFIG_PM
> - [High] soc: qcom: ice: unbalanced runtime PM refcount in qcom_ice_enable()
> - [High] soc: qcom: ice: clock and runtime PM leak on probe failure or unbind
> - [High] soc: qcom: ice: broken pm_runtime return handling in qcom_ice_suspend()
> - [High] soc: qcom: ice: skipped HWKM re-init and unclocked restore across system PM

I'll review this more carefully once these issues have been addressed.

- Eric
