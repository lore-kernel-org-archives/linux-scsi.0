Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1E7407576;
	Mon,  6 Jul 2026 08:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783328143; cv=none; b=bTxqCRQiiNX1PIgkiLsPDXn+YGk4kwmyuUANTXKGXIDrPosZ3ob0m6jLT77Q543JYWoIMp05YTr3xV3OIWL4WzxE3lPmiguNQQdPOxFTRkizSQUEHXanCDpyGMiswjjceraI1lSQ9kuFPGRl3RGAq8IcMJSnduQwAZ6UvUd47Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783328143; c=relaxed/simple;
	bh=4AsiANEPQQNn16+DkjnvaEFha/mXnJm8flL8tWtxPys=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=sykOJA+hpP6CNg0ESsdCBb/EIdc1H9hBOFr6iohoUzIVbhp6/JDSnbf4mM8GquXImvjwZruvQ+ZLhGMFjLmLkoOtmtuR5i25GQ8Na7hzS0JwvAl1xcBewXZOb8lsyoEu/h0obYjqD0agirtyeuZce/gUZc/zLd4/dl5SYEn/FeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I9gnGgEC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I9gnGgEC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E7CD1F00A3A;
	Mon,  6 Jul 2026 08:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783328133;
	bh=xUWLi5662FKqa6Hfl+915YdSn0wbC+NLoKBB+bv4hKU=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=I9gnGgEC3Qm66+NnVo0tfd5r5M8OGgFdfbMHIBEsVebXaq+dGlZprr4H1OalpmWIG
	 wuwHaUAecQBkUslxifKVsE6ziGcdNcmQTgJ1zBw/sOX+6Xo3b/dQdxCyJTYUpE2y7W
	 T8IoiJHmP1JG7rS/ildvDPf+FObvkM+9/VJdUZCbFMFok3jRJ9TkaTVv8j5ZAYOKp5
	 7QzLYsrEvhuqnAqFcKBo/cAgTQBlOVpQQUsETji4B4k2DwRNYAJIKwoqREfVMdAJJE
	 xAfe/cCuFYLQMeils4dFfGTl1/v8LMMhkbDWIBCxFWGXnb5yaxedFU/7Vz9DzKWO1M
	 Jxv9TtcsmBvuA==
Message-ID: <e92d2139-d8df-40c3-8350-68b9e37b8197@kernel.org>
Date: Mon, 6 Jul 2026 17:55:22 +0900
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
 <b7971067-1025-48ca-8ba4-d76714c283d5@suse.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <b7971067-1025-48ca-8ba4-d76714c283d5@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/6/26 5:29 PM, Hannes Reinecke wrote:
> While at it, would you mind converting the raw asc/ascq numbers
> in drivers/scsi/scsi_lib.c to use these definitions?
> That will make the code in there _so much_ more readable ...

100% agree. And not just scsi_lib, but also sd.c, libata, etc. We have so many
places where ASC/ASCQ are hardcoded/hard to understand, that this will be a
great cleanup.

BUT, that's too much for this series. I was planning such cleanup as a follow-up.

-- 
Damien Le Moal
Western Digital Research
