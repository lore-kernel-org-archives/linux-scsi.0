Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A6225A645
	for <linux-scsi@vger.kernel.org>; Mon,  9 Feb 2026 17:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770659283; cv=none; b=r48LmM9vISCDSD1uNmDDyfPGU/eNoykei07T2ctspskyC5U+/QozpTeR/2+175ZVELpuws33ylExBGUnGAH6bjnOT7/s3xXvfH9EM9sBC4jUJ2FRiWbeggEazHifJV92ssuMbQqA9fWFcAfpYlUD75uvPJLrokYDVjHNJyWfm6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770659283; c=relaxed/simple;
	bh=Gh8g6hRLHlpIwCI7xiDxAXUIN5RSex/6mgDx6zrZX9A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MulrHVeDy0aMhtyUFVRgscVxQTmfWgERAjypcmpKFEUv2J9OTC1m0V+b9mmA/5lAWNEkXS+Ae3o8wNi2uxwcsqE8wl4blPhUZGpnZhASNnyiVr/+yhuNRu7syQ6LhGO6w23KEeqhPykemolAm9pTvxLl45p37pkL9XCNkZxNZsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=tdYHH+Ok; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="tdYHH+Ok"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4f8sc22nWWzlfddY;
	Mon,  9 Feb 2026 17:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1770659280; x=1773251281; bh=Gh8g6hRLHlpIwCI7xiDxAXUI
	N5RSex/6mgDx6zrZX9A=; b=tdYHH+Okx3zxNPKNcyCY0/6MXdfAk852OM0+ggI2
	ZC2h2kcmc3YSBFMSmBFF0o+602tBndu1XsI21+4nTyGO5IkUwQZ11ucErLC+m15g
	ILIQ4OAgR4i+XyVRRR7hPvoYmMMEsGOiRhWEWuCLCvszp6/Q316Xv+h4bqWulL7A
	8N/CAsLXO0nSM7wpbfuxrkgR3m80sD/bsp6NUb4ger4Syu4JyN+G5b5vnU2YTukQ
	OhnhYl51RQeOFAYyIGCo1PCSOrbhbRN+1Of8GJB9rwrgUuTfqqClq/2Xd9+f20aw
	FE+abYS8xBayva2cYUcO784H5n/U9WyM2Gdh8Cg713ZmgQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 0TASwtBsH3t4; Mon,  9 Feb 2026 17:48:00 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4f8sbz3vClzlfvpH;
	Mon,  9 Feb 2026 17:47:59 +0000 (UTC)
Message-ID: <b40028c0-910b-4228-8ed9-9843e3db394e@acm.org>
Date: Mon, 9 Feb 2026 09:47:57 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] scsi: sg: minor bugfix and cleanup
To: Yang Erkun <yangerkun@huawei.com>, dgilbert@interlog.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org
Cc: yangerkun@huaweicloud.com
References: <20260127062044.3034148-1-yangerkun@huawei.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260127062044.3034148-1-yangerkun@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/26/26 10:20 PM, Yang Erkun wrote:
> [ ... ]

For the entire series:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
