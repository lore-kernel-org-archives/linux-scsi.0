Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A47381C4;
	Mon, 18 May 2026 07:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779090125; cv=none; b=V6ZSA1kmQbzTR9U0air7FSW2Jsm0yxUalawsIu8ok0CdtWg5JZto2fuxZ3QluVAiTTmr6sUs8iBUK7diqzceudM4iV6BQ2OeuVFRip8HmJ0+Kx/sWtPJj+pAjSDtftVKbxT5m8lCZeupJ4sWBGRlrUX+QoTzLZvz3zBEkicRaPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779090125; c=relaxed/simple;
	bh=vd3o61gDFIxhyp+hvjREj8AV+gPv9A3qWAbRG98uieU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bDwpCMUES5CYS6wtYSaxqe2C/DxKMy+oBEWwX1h53Kfwln3T6brq7bLPkxpGeB/8MucarOm4tnfuXpBWWZWuh2uOuobEr0CaZCku6+B+vgBHKNHjEf8ApfEj60CJytW0CR0D5sSmgK7ej1RofydW5tQuvI693cnsN93RaeSZ4aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MJqjkGxa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MJqjkGxa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10F4CC2BCB7;
	Mon, 18 May 2026 07:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779090124;
	bh=vd3o61gDFIxhyp+hvjREj8AV+gPv9A3qWAbRG98uieU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MJqjkGxaKu/6qIYBU6XrIBkAEGhftVuNa2i9rkrk94a3oovPBZNtJ+tTEP8p0H0sn
	 iKMjjkSAJjD4pUzkNj3wH6MHcJo5Y7pAoGq9v0BCeadBv8Pxl9Ep/vrD9queHeG+p2
	 eDFlHN/Nzhk5fd0eh4UmRXxljcsPMNcD9V7g4wEKnlRrXg8eBkB71ejk/0MzCVVpcm
	 xsH27+Sdn4JWydTZe3uinXQU+pwLAOxS6lsFZIak9W2Yv/Tz4uAWTzngk8eloYDg3O
	 NraWABBfEB0lm2pEbyC3QmfHhwSqjLyaKI9q5TgrRd8YVsKBThQ9NWhnrApEUojDXl
	 MtIZi7vsl3awA==
Message-ID: <92b868fa-d619-427e-9457-da622e46bf23@kernel.org>
Date: Mon, 18 May 2026 09:42:01 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/6] ata: libata-scsi: add atapi_max_lun module
 parameter
To: Phil Pemberton <philpem@philpem.me.uk>, linux-ide@vger.kernel.org,
 linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Niklas Cassel <cassel@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Hannes Reinecke <hare@suse.de>
References: <20260512202728.299414-1-philpem@philpem.me.uk>
 <20260512202728.299414-2-philpem@philpem.me.uk>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260512202728.299414-2-philpem@philpem.me.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/05/12 22:27, Phil Pemberton wrote:
> Until now libata has hard-coded shost->max_lun = 1 for every ATA host,
> so the SCSI layer never scans past LUN 0.  This blocks support for
> the small handful of multi-LUN ATAPI devices (Panasonic LF-1195C and
> COMPAQ PD-1 PD/CD combos export CD on LUN 0 and PD on LUN 1; old
> Nakamichi MJ-x.y CD changers expose one LUN per disc slot, up to 7).
> 
> Introduce a libata module parameter, atapi_max_lun, that controls the
> upper bound of the per-host SCSI LUN scan.  Default is 1, preserving
> current behaviour exactly: out-of-the-box only LUN 0 is scanned.
> Range is clamped to 1..ATAPI_MAX_LUN (8, the SCSI-2 ceiling).
> 
> Subsequent patches gate actual LUN>0 probing on BLIST_FORCELUN, so a
> device must both be on the SCSI device list (or carry the appropriate
> quirk) and run on a host whose atapi_max_lun has been raised before
> any extra LUNs are scanned.
> 
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>

This looks OK to me:

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
