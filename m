Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542AF282F20;
	Thu,  6 Aug 2026 03:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785987510; cv=none; b=AEtg4XAcrHNtVRxti7rj+/Y7W5tc4LpKhBakNPtwa/f40jcJJvJBfpbXKe9asR58aK+D2U7Aifw9PilMTbZ2W1YuYWaQToYGKblWCpmkN3fd9I1/dQEgchfJiCcEuLXydI1bfYRBMpMmt6VF8oDwEvAmCphEgjcu/YUNFu+pLY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785987510; c=relaxed/simple;
	bh=CZD2fLYy+JZvIuw8RaJ0fPRTTeYol11buYqkI4IjKJg=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U3fgtqauz1kY5btJpfaKom9d/zJvJaoh9GJacPnq0sFcfqXmXqUxTgmhFLlQEAWC3EMmzzmEuK2IrEufE6m8gxWmAJ48HaPPlt1zQwMFBZeAI6yBrnmJjb+55V4kcRaFxtAO7vRu+x8Sp3LLQ3fk6Rtv79unG65HrXdHk8elJSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BILbr089; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BILbr089"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DA7C1F000E9;
	Thu,  6 Aug 2026 03:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785987509;
	bh=cBoiD3UwaMAXmdjVDF6b0NCkZrKukBc8VfE7Nh4Nz90=;
	h=Date:From:To:Subject:References:In-Reply-To;
	b=BILbr089B5EelOBerH9RbPZsF2cxqaqtCd7PtO5dxK1mB+stj0NPBSU5R8X+LPEFd
	 qiGrI27/h1CMYO3U9mzUPUOlv9Wk97yAxSj+9DlUPSuiegBQCWHZUvPooXxZuC+82i
	 wViulUCK8e1r24tNn86mSzZcS14/o15wmTpBuavMeCQQiTOgBlPcmE98/YqESk19HA
	 VZDcnuUEDqvadEsCe+7SH7+nxqzUtEx3tpv1wAp1LCMinM1QEbOxJxyEMWMN9M8HND
	 jyLuWoqxQXLFmuX5MH2pxa40+ErmQgim+aAzQqRJ3YoGlEkBIokXsQnCoT8qEyTNhy
	 17wKT6Fn6E1Dw==
Date: Thu, 6 Aug 2026 03:38:26 +0000
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
	Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>,
	Jennifer Berringer <jberring@redhat.com>,
	linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
	linux-riscv@lists.infradead.org, spacemit@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] Add UFS Host driver support for SpacemiT K3 SoC
Message-ID: <20260806033826-GKM76518@kernel.org>
References: <20260725-08-k3-ufs-support-v2-0-45036a2a2418@kernel.org>
 <amdyzkFplQqJvMl1@aurel32.net>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <amdyzkFplQqJvMl1@aurel32.net>

Hi Aurelien,

On 17:01 Mon 27 Jul     , Aurelien Jarno wrote:
> > change-id: 20260605-08-k3-ufs-support-c8b308e415e2
> 
> Thanks for this new version. Patches 2 and 3 are:
> 
> Tested-by: Aurelien Jarno <aurelien@aurel32.net>
> 
I forgot to update v3 with your Tested-by tags, but the notable
changes were the error checking added, which should be safe..

-- 
Yixun Lan (dlan)
