Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A263033F5;
	Tue, 10 Mar 2026 17:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773164606; cv=none; b=pnaPkLzcwSYgBzSV8uqg8vBavOGGO6gzx6kaR9Mh0d/cUo9/BWwS9iptD9E3WRMezZUEk6nPEcb/iK3LBZcVOgr6L4MRS0sEqqLwqxE6xYSa1EDlCRFdbBDbbf67eez9e2lPHBfSuIudKvaKfl81NwpI86deYYVxNVlcs/nm4dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773164606; c=relaxed/simple;
	bh=i1WnQlulk5+h/fVZtviCyMDuoShu+IDNA1sgxDyDVcc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eGV1XkwfAdd6/An6wZIp65isx9Ei8HGsD/ez13cjzWQr3AcULcWVaGOooU6BR8XNH6IQcxyMXXq18gh+02/cjVOlIGK82cKz4YRqUh6vElBD8zZygUaam+eWzfQl1FoGHXgUuiH2w5gEcj0fkRHMXlTKh63FYxtw74+5C88yTYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=tzyIO8rq; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="tzyIO8rq"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fVh7C2vfxz1XM5kD;
	Tue, 10 Mar 2026 17:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1773164593; x=1775756594; bh=i1WnQlulk5+h/fVZtviCyMDu
	oShu+IDNA1sgxDyDVcc=; b=tzyIO8rqapXsA1jVegCXlqS5rpes7rfKPHxVPnzo
	erERWxDzaeVkgcntugBSXMp1g1g0z8Yr8YCHx6Q+TbFPvphugqqnYdatI7qHVRfU
	+ucXhsVbz4HSqYS1/0jLBzSX1dIOS6w0tTj35oSyeq8zS2c3z7h8yIlpmPLC8N31
	i10royHxuuVZa5dDxkdbQAbH/PSJzAu6LHqRcFoeYc59/nBbZLDdZRrfbCnecwme
	FSO2qs0/cCz/b1YqAfZZQkBA75JbovjLxyOZTDE6aRbASQrCHxDxtAxqeyVz7kKG
	eFmfK0XGr29ilVpz6YJZaZr+tojI2uuyvTGU7KSI7hGb8A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 83yIVxWhxkc3; Tue, 10 Mar 2026 17:43:13 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fVh714YWZz1XM6JT;
	Tue, 10 Mar 2026 17:43:09 +0000 (UTC)
Message-ID: <fd64c25d-12aa-49b2-b95e-d6c640096b41@acm.org>
Date: Tue, 10 Mar 2026 10:43:08 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] ufs: host: mediatek: Add VCC on delay for
 stability
To: ed.tsai@mediatek.com, Peter Wang <peter.wang@mediatek.com>,
 Chaotian Jing <chaotian.jing@mediatek.com>,
 Stanley Jhu <chu.stanley@gmail.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org, wsd_upstream@mediatek.com,
 alice.chao@mediatek.com, naomi.chu@mediatek.com, chun-hung.wu@mediatek.com,
 linux-scsi@vger.kernel.org
References: <20260310005230.4001904-2-ed.tsai@mediatek.com>
 <20260310005230.4001904-6-ed.tsai@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260310005230.4001904-6-ed.tsai@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/9/26 5:52 PM, ed.tsai@mediatek.com wrote:
> Introduce a delay after enabling UFS5 VCC for MT6995 to ensure
> voltage stability before refclk activation.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
