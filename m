Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B93170A3D
	for <linux-scsi@vger.kernel.org>; Mon, 21 Oct 2024 23:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729553086; cv=none; b=Hg/7ZeMALWXx1MlN/Qv1pU0dD5UG6aYdvbeqqm2WArfAFR2eHAb4kdMzq7GAMAy7HmPxNTx1z8XWHlMfbsnaxkYSN8Flt1TtMqKEp9jZNZutiorKHGOwEJcMhrNz4dlxlM1jzzg1wCdKacg27u+8/faG4RuPpmQqDz5hFPt7boE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729553086; c=relaxed/simple;
	bh=vfEzaUod3yocc/rxCeVII8TTLjwTbC+/GM58oNeIHWM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IfZeFagVQoK3L4FkNEM2dDEd07ubt81/18QFoL5JUXXih3YCGn3JwNC2hRWbk+Y692+4pYBtt07TBPh+dEGYVPNJMpEUU/MXJZtSLFaLTd35tqjeDmki/iTNzGgGwr962WgWGK0JRUiOc3QgDDl2n2ML+PfqKnexWB+BDtnZH3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=WX+ixKod; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="WX+ixKod"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XXWcC2m5WzlgMVX;
	Mon, 21 Oct 2024 23:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1729553082; x=1732145083; bh=vfEzaUod3yocc/rxCeVII8TT
	LjwTbC+/GM58oNeIHWM=; b=WX+ixKodhyer4PXplqeh9PBESB7FueHGYXRaqwiY
	/1mdhpVde3FHs1TOMc31OOE2vCUAge5N0Wvmu1SKaLNZKlwLg8cS8wrLW4UTAVd0
	5fnu5zbo2d4hOELKK9D5O2hyRrZQGa9Fqd1IzIUWXCxDIe8KY+FzO4+fn2PNw6Q6
	hyb8ZJIPNzY/jaldt2nKXjnwyNzC0srT7I+WZJquhwGLyxOna5Orz9X1YeNX4qkk
	WN4RebBUvwgWFMRFfaBMiU+T68coZH8kjanqUijqoJ+UK+Ndg0374jDtgY84Kah1
	iNfTDOLdiAqWWT25sgetn77pU8VJwgoCLuULr5TXT5Ykog==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id EyuCeDjoHkvU; Mon, 21 Oct 2024 23:24:42 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XXWc93BfxzlgMVW;
	Mon, 21 Oct 2024 23:24:40 +0000 (UTC)
Message-ID: <b385c84b-1755-49d7-9125-20e3b482e6d2@acm.org>
Date: Mon, 21 Oct 2024 16:24:39 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: ufs: core: Make DMA mask configuration more
 flexible
To: Avri Altman <Avri.Altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <20241018194753.775074-1-bvanassche@acm.org>
 <DM6PR04MB657551A72CB90ADDEFC49F48FC412@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB657551A72CB90ADDEFC49F48FC412@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/18/24 11:24 PM, Avri Altman wrote:
> This patch allows to ignore bit 24 (64AS) in the host controller capabilities register.

That's correct. It is unfortunate that the DMA information reported by
the controller is not more detailed.

> Personally, I am not religious about quirks, not sure however that this is what vop is made for.
> Also, there is another host-specific option, e.g. the opts member of struct exynos_ufs.

I need this patch for another controller than an Exynos host controller.

> Looks good to me.

Does this count as a Reviewed-by ?

Thanks,

Bart.

