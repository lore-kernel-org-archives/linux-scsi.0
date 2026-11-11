Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794415629;
	b=IAPsybxEWQNPpoWSsPPcuo2XZkC66I+sIPKK3uFwkYiQ/ZI+nar/wjZGBmC723feJYcm
	 G2C79cdaf28XwMxhPbJSvLhxMdtilbDZLRzN5gaWPcJimF8ztGOfl8Sijjh0RcuLeSK8P
	 GfDn8pavfpUU9hIo7k5XxxsSSXNP5pyIwk8LrOYpdi0paSW+jOrhxZOO4JsWse//qgpvt
	 pnAIsORETGkBLjcVSx7UEZDckI7S6eFxyFiTNPdx+mYHj+cvyuyW269r0/7tJQ6UeA4SO
	 W4Bk3hafbmdMe2XdDrYrb7uyiblF0fiOX+OYC2w9MKjhg5lqeR4P1QTUJPIchBnYSgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794415629;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=fqAC3CLiYV1ZVFzIMhAc2i9cwxWcjynZhQQ1mEPd5K4=;
	b=rICwBoYfkvbn/HzMPVCC9w+ytC+NsRu8dfScvvtNCEA5w5Uy0pC0FXSIThfYHPLIrVnr
	 Shljh/576jyaPTLvkBFt/6Or8toC2OEdmGdk5j/PDYx8Z3Qq1SkCmZgW0eGDO1wIfCNMI
	 fmpPShSoRp2+gb6+hp9b+TTHertbQthtryPnfn1EnUJY+Ls4VEgCHcXziPLjUuSgoNobk
	 gVSF8gy67a0ZSJkAChKeLMRc3c+LdG3eziDN0rF95SIpR4Aiu8M4tevLg0TmW27XZkJvj
	 IWApclB59ZSkz48vt4tSFk/Ourn3k9izBzwWZhV+TtR++vJjJT8swZnOANmtAsZcXZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3AC606A31C;
	Wed, 11 Nov 2026 16:47:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4C3AC606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 21F7F68D17; Wed, 11 Nov 2026 17:47:06 +0100 (CET)
Date: Wed, 11 Nov 2026 17:47:05 +0100
From: Christoph Hellwig <hch@lst.de>
To: Chris Down <chris@chrisdown.name>
Cc: "Martin K. Petersen" <mkp@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 2/2] scsi: sd: Fix data corruption in WRITE SAME(10)
 discards
Message-ID: <20261111164705.GC18355@lst.de>
References: <cover.1794069087.git.chris@chrisdown.name> <c58578f870580f92d1acd6cb73b59b7a7867d80b.1794069087.git.chris@chrisdown.name>
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
In-Reply-To: <c58578f870580f92d1acd6cb73b59b7a7867d80b.1794069087.git.chris@chrisdown.name>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sat, Nov 07, 2026 at 08:35:29AM -0800, Chris Down wrote:
> We already cap the discard length in writesame_10 and writesame_zero
> mode, but we still truncate the starting LBA to 32 bits. A discard at
> or above block 2^32 can corrupt live data near the start of the disk
> and still report success.
> 
> Discard is advisory, so return BLK_STS_NOTSUPP if the request won't
> fit in WRITE SAME(10). Discards that fit can still go through.

Nah, that's not really how things work.  See my reply to patch 1
for the suggested proper fix.

