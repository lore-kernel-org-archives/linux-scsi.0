Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08DF39022B;
	Sat, 25 Jul 2026 09:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784971218; cv=none; b=WAXHViKkYKy05ON732omnjJGuRxLPGfE94HkEZrHvtAT4kRgsmcy9QwIST4crk2AQNrWgT6xOdlr3FTBNdlZ1FCCOcgexH+806W/Ql/oj3X2mPxgrs9fAbe1SDtFg7qa2+PbiF6mA+cGNmqSCPxtaRAbHdk7xZwdl0Rk58n+M0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784971218; c=relaxed/simple;
	bh=CmJc5HWp7XIa9ZI3sswR5uenFjiapcxJLiuvdQ5Gxmc=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NGWnWI29BPSg/dmE/gU+VdKUbxldGIFMVXiqGZSWm792a1nqsUAXoGCRLHq/XpUPXU9k0JP+EKlPx9Bey39mG4fqBXfywTi8+O0oQrioGWjYa73UivPRKMcZKp64f2N/MBQdVaBVXUE9N7A6psMcA5ZbojHNxxWOmZ+1OPwNfzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=at+O6F6t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="at+O6F6t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 558F11F000E9;
	Sat, 25 Jul 2026 09:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784971216;
	bh=aaDUVqB32MI4QmsAjMF9hCDK2Ml6G6nBK4sVDZs312o=;
	h=Date:From:To:Subject:References:In-Reply-To;
	b=at+O6F6thh9JDAut+fw+N+7gfFvcjo1gZfqTqaWsQKfxd1v2ADwP2aYaRHlwpFW0f
	 Us4TytXumHMPea1ylzdlpEiZTHYgoyJ4pAxUQXXbtwBRw4cAnIOl/DmdA3nvgKTCqV
	 0QYXo6RvXWQSMKZoiMsAR/2umZj39aCRlJhLfRRIa3nR+Ul5rZ1wePWSaptBm1hDxu
	 /MgRsjjKCCdkLr8Ws9BT3vkLJ3zLg8A9AHpyV1/fDeuobJvzWv0pv6URJ10tJgJqBI
	 O8Pd3zHczfvXtiAA8Y0xyII1givDObJuu8hTdKyTeMEbKdD8tjeQ+gdibIWn5nTrrA
	 7jNmJ6o8Ntkpg==
Date: Sat, 25 Jul 2026 09:20:13 +0000
From: Yixun Lan <dlan@kernel.org>
To: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
	linux-riscv@lists.infradead.org, spacemit@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] scsi: ufs: spacemit: k3: Add UFS Host Controller
 driver
Message-ID: <20260725092013-GKB77545@kernel.org>
References: <20260702-08-k3-ufs-support-v1-0-1a64a3ab128f@kernel.org>
 <20260702-08-k3-ufs-support-v1-2-1a64a3ab128f@kernel.org>
 <allMTB6R7eHf_UZO@aurel32.net>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <allMTB6R7eHf_UZO@aurel32.net>

Hi Aurelien,

On 23:25 Thu 16 Jul     , Aurelien Jarno wrote:
> On 2026-07-02 02:31, Yixun Lan wrote:
> > SpacemiT K3 SoC consist of UFS (Universal Flash Storage) Host Controller
> > which has features compatible with JEDEC UFS 2.2, MIPI UniPro v1.61 and
> > M-PHY v3.0 standard.
> > 
> > Signed-off-by: Yixun Lan <dlan@kernel.org>
> > ---
> >  drivers/ufs/host/Kconfig        |  12 +
> >  drivers/ufs/host/Makefile       |   1 +
> >  drivers/ufs/host/ufs-spacemit.c | 931 ++++++++++++++++++++++++++++++++++++++++
> >  drivers/ufs/host/ufs-spacemit.h |  90 ++++
> >  4 files changed, 1034 insertions(+)
> 
> Tested-by: Aurelien Jarno <aurelien@aurel32.net>
> 

Thanks for testing, but FYI, I'm not adding your T-B due to massive changes in V2..

-- 
Yixun Lan (dlan)
