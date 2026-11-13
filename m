Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794542340;
	b=QOLtD1VvtbTigHkW20Kf/Haoqsbo7lbIiXXNwxsYXr39/BVKRG1ZS7Mx2yR8HLKDnBBR
	 zHR1AlmTQhzDjH6Vp9S7Beetl9lIj6+A63OPoX0PzDdQA1DfPPydP75hbYQMsvsDOvVbU
	 LK+zCRfldFSCSsC39Fu/WsWr8zJ58p8/fEjNS9ipHFbyJgqD/Ruu/QXJ48mK/V3crXlBO
	 7dagQvz19yoSWazM3Unpbqc2WA2cf0Amhb07S0+xt/eZwq4l9E1c8tGCcdtp86UGR8Pwe
	 N8bBoe6Zj8L8v9A+6jeP8R6IzOOyg/COFbboyENyseMWWXau5tcsfnWKthquN5/8rQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794542340;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=YNwftnnoDQaO1cbVmr7F7KU58HWyTpxMeoA5xvSqT3k=;
	b=ngDnG/H94kIv7r8TAz3YMo6ev5FccFa2YN5qddLwhRVxiaB9Ry3pUsHHplZkipGxGPTU
	 P0yEvLabpSNMD5cnkR7ekfVu/MFuRCc25i8NAkYOyqTFajtoXkyANDuHS6RruiBGY8a6+
	 elyH0eP1iSN3T2iqY71gfY/UHM4rgPASHz0FwC0cMSRRbrxQVFfZQA+wVdZrhDrRXT+wL
	 461vlwS81lAAIOxtTnBIK88VUiscf1VmfoGnWhdSERyyXQ3yYoG4b3FHwSbTuvNliJFAT
	 zxAgnnKPPFc5+Ve8f5drSte4O2lYpoSogBfD5zVUjnV5UTzbAWW8F9dA9QLb/a13HrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BahpqMvX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02F8606A321;
	Fri, 13 Nov 2026 03:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BahpqMvX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E0F01F000C4;
	Fri, 13 Nov 2026 03:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794542340;
	bh=YNwftnnoDQaO1cbVmr7F7KU58HWyTpxMeoA5xvSqT3k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BahpqMvXKdY1E7ojyt66ROo53+0AotY+niLlLRTwhYPOSjguOlEVRCO9MF6C1vwXN
	 3SS9CQPC3FuRzw66vpdXvdCgOYkU7apaubFDPvp90mkjut6CcurUFg0fjJE+TiCK40
	 w/Ymlq4hrjt6AoL6vurmaalsullWo0cyFledIqIsTbc+7eZudpy7K+NUXrFsqiOLFU
	 HeZU14g8tRGAFm2DHJwIqNsyJKOU97qGamBCXw/dwK6K1wa969ejhOrpk050G8gWB6
	 NQxyz9zjyG69dd3oVt3bZ+XV3Sk5yHF0FNfclQSSuIHAXiUim2fnWMQkdtI5i0tqKr
	 WizazPJV0756A==
Date: Thu, 12 Nov 2026 19:58:58 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>, Ulf Hansson <ulfh@kernel.org>,
	Abel Vesa <abelvesa@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>, linux-mmc@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 1/3] mmc: sdhci-msm: Enable ICE before enabling crypto
 support
Message-ID: <20261113035858.GD1742@sol>
References: <20261022-qcom_ice_pm_enable-v1-0-f7a84086c651@oss.qualcomm.com>
 <20261022-qcom_ice_pm_enable-v1-1-f7a84086c651@oss.qualcomm.com>
 <20261024182904.GD2553@quark>
 <172229a8-a4c5-4103-a38b-e4cce3f18718@oss.qualcomm.com>
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
In-Reply-To: <172229a8-a4c5-4103-a38b-e4cce3f18718@oss.qualcomm.com>

On Thu, Nov 12, 2026 at 05:00:56PM +0530, Kuldeep Singh wrote:
> On 24-10-2026 23:59, Eric Biggers wrote:
> > On Thu, Oct 22, 2026 at 03:21:50PM +0530, Kuldeep Singh wrote:
> >> Remove ICE enable call from CQE path, since ICE is now enabled
> >> during SDHCI crypto initialization only.
> 
> Sorry for delayed response as I was away on vacation for more than
> 2weeks and hence couldn't catchup on the thread!!
> 
> > 
> > This change makes the low-power and "optimization" settings in
> > QCOM_ICE_REG_ADVANCED_CONTROL be set only once, during probe.  Is that
> > correct?  Those settings never get lost at runtime?
> 
> Yes, the low-power and optimization settings are set once and are
> retained over suspend/resume cycle.

What about hibernation?  We recently went through this for keyslot
reprogramming, and it was established that keyslots need to be
reprogrammed after a hibernation image is restored.  See the commit
https://git.kernel.org/linus/8b190e9c0b36aac5
Doesn't the same apply to qcom_ice_enable()?  If so, this commit breaks
ICE upon restoring a hibernation image.

- Eric
