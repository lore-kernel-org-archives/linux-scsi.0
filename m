Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794415596;
	b=k6gvLKCS8asygicU8ml6TRhm8WUJSfQUct/tercL3CAmpVVTpADAJjpRWe4k8VeE3PTl
	 nMHbn1h3aKdNKN2RSGqqugLS6u1qbg5UI/XT3/DnrJE4x5m74sLSAlQaLrWB/XFyGRPRI
	 96YjvgwGfR/DiBoxleGHRqreVtQUeJHQDhQwsF3BZcjIDaCILXwhvUq68Ofx/vwyIuO2U
	 LMTnydDDMm1IQecvorET5tDLNuYtvZczzzFCHrE17/HPJfpAuFM8cCggB/jfZaE81s7gz
	 oGFMrUg7MPVZa2mJkbB7tnzxYtqIf7bnBMCNJCuaK7N64O2Gf583fhW5qOTk6Z2no7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794415596;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=O74kyc5xiy0hKL1kTBXoUvLQVBTCX/iWzJNxpqN4taU=;
	b=kTQqiQkxOEImdhHAMGE0ijt+zPkBfqvVGx4vUNzGcFuEdyDbQYDjc4dORM8grYTs6IDs
	 q6uK/ksmJJTiFCkGeusUgD+XwGAojP8+7F8lff8cCcF8mj62Q0bpYRgzHGuRqvPMAMbhW
	 kmFCnMtdKuf+THbcc18Ruz4YKTMY/3le43HkFx0edpyk+AMRZDm0x0jg+1KlUzAHWpFib
	 MRE3bM9essB419kdz5ACr5NLthkUj0LVFRjmdnsR7QEUnOPOABVHUXowm2eAb+T+zONba
	 wfwk3p3aLrtMYa37McelrcrzH+77NkV9ngsNxuFudwLLKGFLCLJHzwYeF+MmJ1jvgtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71321606A31C;
	Wed, 11 Nov 2026 16:46:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 71321606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7158768D17; Wed, 11 Nov 2026 17:46:32 +0100 (CET)
Date: Wed, 11 Nov 2026 17:46:32 +0100
From: Christoph Hellwig <hch@lst.de>
To: Chris Down <chris@chrisdown.name>
Cc: "Martin K. Petersen" <mkp@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 1/2] scsi: sd: Fix data corruption in WRITE SAME(10)
 write zeroes
Message-ID: <20261111164632.GB18355@lst.de>
References: <cover.1794069087.git.chris@chrisdown.name> <5cb23933fe87df3c342d9805a7fe8c2a1e08ff37.1794069087.git.chris@chrisdown.name>
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
In-Reply-To: <5cb23933fe87df3c342d9805a7fe8c2a1e08ff37.1794069087.git.chris@chrisdown.name>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sat, Nov 07, 2026 at 08:35:14AM -0800, Chris Down wrote:
> In writesame_10_unmap mode, we send write zeroes as WRITE SAME(10).
> If the LBA or count doesn't fit, we truncate it and can return
> success without zeroing the requested range. If the LBA wraps, we
> can also corrupt live data near the start of the disk.
> 
> Cap the queue limit when sd selects this mode so large requests can
> still unmap in chunks. If the LBA or count still won't fit, fall back
> to WRITE SAME(16) with UNMAP clear. All the caller needs is for the
> requested blocks to read back as zeroes.

Shoudn't we simply refuse to use writesame_10_unmap for devices
where 10-byte commands can't fit the entire capacity instead?

