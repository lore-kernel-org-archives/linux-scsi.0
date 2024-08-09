Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5991A321A3;
	Fri,  9 Aug 2024 18:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723228054; cv=none; b=Y/g3XlkzQl2+e6mwO8pUU9zmwQliSQCy1A7DKdWH20TGD9jEUo+nBbB1wD6UI9DnBu/VVe9s47e6xmE+/9Ga5gdB8sL90nvprERZRXjCEBVwT6QuQ5aHdPwjCHorNedLETf6n7zDapxPCZS54S+p/xplYILz1CI6UiufBr/X9z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723228054; c=relaxed/simple;
	bh=JwLQU18qPLACTYfrm3egbp54GenfTciW0oFQ/jU7HCA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dSW6LnrHiFsHVHwPVlu9eOb5msOIEfIAlUPyFt18HGwpEthmmZPKP+ftQ9kBOwXjHVyEiTCMTV0iG1Q1aIqKkF7S+NbthGhbVn4jCCEFDnjeigaorf7TvWHzhD+fx4Jszfwk9O8PdEt5rxoFnGwP9B81nAQ6mVZo2UCV+EhE170=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=bawISMY7; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="bawISMY7"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WgXT05LbHz6ClY8r;
	Fri,  9 Aug 2024 18:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1723228047; x=1725820048; bh=JwLQU18qPLACTYfrm3egbp54
	GenfTciW0oFQ/jU7HCA=; b=bawISMY76lSeg5zyp23V9zy8tLA88ECu/QhvSU+z
	IwOQl/VoxwXHLPQgsR8+x1+LeyBqyCpudAbZjyGym5txc+TaWPTWhwcwsGC/EUZ1
	2lA3F4qJMmHFoabtnwhhn8TvtbgOR/XLyeYojhqTjxPTSV5uLM9PGLeyam5nsQ/y
	Awwf5X4ITdcB9Xh8ub7SdbwYKuLrwcePSBgXqUjBFQyZYPG1HDMnBNaL0m1piPeN
	qWLaQ9lE1v1MfEj8cBQTSFQGPAGRAsHwJqu5XwMr4sJ4fw+HjgYtBF9pi0VxIQUW
	n4qqtTCcXWkGXqJApdI59C6P5H4LEsCBhv546p6U8KPxUA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id tH2dpFgiuWcp; Fri,  9 Aug 2024 18:27:27 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WgXSr0BxHz6ClY8p;
	Fri,  9 Aug 2024 18:27:23 +0000 (UTC)
Message-ID: <4ae81cc8-03ff-4dc0-a912-49f0c139389a@acm.org>
Date: Fri, 9 Aug 2024 11:27:21 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] scsi: ufs: core: Export ufshcd_dme_link_startup()
 helper
To: Shawn Lin <shawn.lin@rock-chips.com>, Rob Herring <robh+dt@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>
Cc: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Heiko Stuebner <heiko@sntech.de>, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@wdc.com>, YiFeng Zhao <zyf@rock-chips.com>,
 Liang Chen <cl@rock-chips.com>, linux-scsi@vger.kernel.org,
 linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
 devicetree@vger.kernel.org
References: <1723089163-28983-1-git-send-email-shawn.lin@rock-chips.com>
 <1723089163-28983-2-git-send-email-shawn.lin@rock-chips.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1723089163-28983-2-git-send-email-shawn.lin@rock-chips.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/7/24 8:52 PM, Shawn Lin wrote:
> Export it for host drivers.

That's a very short patch description. Please explain in the patch
description why your host driver is the only host driver that needs to
call this function.

Thanks,

Bart.

