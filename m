Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 372051FFC48;
	Sun, 26 Apr 2026 23:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777246664; cv=none; b=Va0pk+INmqIjPdslnjyogFi9HAr3IW1gCoxtA4PAC0P1WYHXswMVaLTP6FgAgSVKLUfdGeBhxCiKGLvqm0WoGlbafND/DJY6HhtAts20zESzU/GtyCmDHCLHSfS1ZeET6utl67z5oB314AVSl22OakLcWoajSBtntK8KFyp9NWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777246664; c=relaxed/simple;
	bh=jjLQOeEeaq4SWWERvSWhTQEcbsEiBXOnn6zgvp+NZSg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AY0APNIRt1aaWvU3WVf8Jv5LJFMxFWWgRnZzuZOaiLvLBWED8jdfdmA88cBVe88w0kWbiPJgyPPXHoY92KfT2IUxx736X8aZAXvVI9njvzAeAFI+6rByi4DaF5dpPCX9j/O713Vqh5Ws+09vemH8Bxvn+ycNL/TcCqGC1UFE4Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=enQEKt28; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="enQEKt28"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA21C2BCAF;
	Sun, 26 Apr 2026 23:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777246663;
	bh=jjLQOeEeaq4SWWERvSWhTQEcbsEiBXOnn6zgvp+NZSg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=enQEKt289jmHom4noRQUiPZGr+/woZI0bENttK/Zh4YT0HHmRVPG2aN/5dwOtZvHK
	 6Cq8YyXlgM3IWEjw7wo4doOzcAZNds7CqCWiu7Xgzyl1EOPJVRK5bEbxOPEAUDjt8A
	 ZO5vPEV1oCvEPMJPNRvtxeadNeNDJ1a0mcFMiPpxLlrZh2qy5suzAM064AlL4rw0SC
	 DshnPKD5s8aIjbCfYeD9nviNTHmOKv8qDNFdLle+zvE2OqndveW04BRjqCZ+KGnHny
	 8L8aC4hPIDTGWoui/HdbwCM7yNS4ZWWt3fWgkwe2Ki0hXQFmdai3RMvXdaGOgoVefU
	 eQGemo+4OMUew==
Message-ID: <c3f4fc2f-dda3-4c22-aac6-7b229074a13b@kernel.org>
Date: Mon, 27 Apr 2026 08:37:35 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 7/7] scsi: scsi_devinfo: extend BLIST_NO_LUN_1F to
 MATSHITA and NEC PD-1 variants
To: Phil Pemberton <philpem@philpem.me.uk>, linux-ide@vger.kernel.org,
 linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Niklas Cassel <cassel@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Hannes Reinecke <hare@suse.de>
References: <20260426190920.2051289-1-philpem@philpem.me.uk>
 <20260426190920.2051289-8-philpem@philpem.me.uk>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260426190920.2051289-8-philpem@philpem.me.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/27/26 4:09 AM, Phil Pemberton wrote:
> The Panasonic LF-1095/LF-1195 PD/CD combo drive was sold under three
> OEM identities: COMPAQ "PD-1", MATSHITA "PD-1", and NEC "PD-1 ODX654P".
> All three are the same drive mechanism with the same firmware family,
> so they should share the BLIST_NO_LUN_1F quirk that was applied to the
> COMPAQ variant: PDT 0x1f / PQ 0 INQUIRY responses on non-existent LUNs
> are treated as "LUN not present" rather than as a phantom sdev.
> 
> This patch is offered for completeness.  It has not been tested on the
> MATSHITA or NEC variants -- the author only has access to the COMPAQ
> unit -- but the drives are functionally identical and the flag is a
> no-op on devices that do not exhibit the PDT 0x1f response.  Drop or
> hold this patch if confirmation on real hardware is preferred before
> extending the quirk.
> 
> Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
