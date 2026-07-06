Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627753B27D8;
	Mon,  6 Jul 2026 09:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783328468; cv=none; b=hwsqlVZcJu0tmq5eDVuPpa5Yyc23YoflUuxzhr70eRiDeVrM2QztUTb/k/OPgcb9Kv+QHV7EcZidBp5sLc83mREAdyG8pdVTpM+bOO3tQFc0HdQDBAWECHAPuIN3e59yUA/uWn0hTM6k2DKSOC1Bk7HXrXOMVDamFHT0DunVm2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783328468; c=relaxed/simple;
	bh=Y+LvtnbFS7Pk8rMTIi6bBfp9mbHm4Uhyusiwi5v+XCg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=TnTxvwtvybETXEDYkJ9BaLyLe/dxdBcMFbQ5Zr8y4tQh13C2IFgu4U8bDILkKCtmX8VYYz/DdK8PBsu9d8FDA4wXJIn3QPEldOOwdUlJILpINWvnZSGAIRvD201sZ5YdYj2rFIki3fxDQUJC1IfNDHv/wuIXnYsdcAY4K4TQgDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FzGTWbLT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FzGTWbLT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C9C41F00A3A;
	Mon,  6 Jul 2026 09:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783328456;
	bh=3fHynrpnm/i0ACjcT4Z/n2urCPV7odE64YZ7oCtLtRg=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=FzGTWbLTzr/WvlX+6Me+CfuAk9B81b8QLqJOQ0qnfE6AWdtbWxq/YWZOIiwmraUMN
	 4Uo/xwZ5DVmWtfGZWJX1Z1PkRe6uDbflrGZEpWEDloJw2aZs0kSuj1raS9qkkDWkkt
	 UjNO0AF3otjkbWsmRYngK6AiEv691y13bFQ7zMHH4ZE1m3rzXJ9BnUGM0akmzf9d0u
	 zTEkaet4KR0OAea7YJ6eQ0UUUr0a0U8fMmBJAsPDjTlgF9y7GEMYPXSAoNZSLH2K0p
	 D4GLcjDXLYM3mnS43XFU7iwNFmLwij67RkyHrDvlQGRnF7TdkEF2s6sUtdN3+kLJXZ
	 Q7yWMrKIzhCqA==
Message-ID: <cfc34288-244e-417a-9586-36fc2b2642c3@kernel.org>
Date: Mon, 6 Jul 2026 18:00:45 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/9] scsi: scsi_debug: move ASC and ASCQ definitions to
 scsi_proto.h
To: Hannes Reinecke <hare@suse.de>, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20260706065610.3559692-1-dlemoal@kernel.org>
 <20260706065610.3559692-2-dlemoal@kernel.org>
 <78b0142a-23a6-4959-8535-fef18d62bb46@suse.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <78b0142a-23a6-4959-8535-fef18d62bb46@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/6/26 5:44 PM, Hannes Reinecke wrote:
> Weelll ... _technically_ the ASC/ASCQ codes have to be evaluated
> together, and the individual definitions only make sense for a
> combination of ASC/ASCQ codes.

Yes, I am well aware.

> EG SPC-5 defines the ASC/ASCQ 0x20/0x00 as 'Invalid command opcode',
> but with this we would deocde it as 'INVALID_OPCODE'/'POWER_ON_RESET_ASCQ',
> but 'POWER ON RESET OCCURRED' is ASC/ASCQ 0x29/0x00.
> So if we were to define ASCQ codes we would need to define the
> ASCQ codes for each ASC to avoid these issues.

Yes, this is messy. But re-check the specs. There are plenty of places that say
"with additional sense code XXX" without actually specifying the exact
combination of ASC/ASCQ as they are defined on the T10 site
(https://www.t10.org/lists/asc-num.htm).

> Makes me wonder if we shouldn't introduce u16 for sense code
> handling ...

Maybe, but that will be more work as we have many functions and code that
handle asc and ascq separatly. Which I kind of like.

The main benefit of having the macros and using them is code readability: the
values used/tested for ASC & ASCQ become self explanatory, making it far easier
to match code and specs.

-- 
Damien Le Moal
Western Digital Research
