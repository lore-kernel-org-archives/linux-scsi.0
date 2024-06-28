Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC1554662;
	Fri, 28 Jun 2024 19:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719602829; cv=none; b=YCvzaN8xHdn0k56YMwRL1Zz+zmfK9ssbQ2jjrJ2dOFHpn/P09v5dQw/2cD1TS54EssfF6P4cbrqGYtTdEBgO5vmxtq9cesr1Ua+QX4+cAbLEkzEfTED2VunHc6Pcr2yar1gwXDrEWPQBQh+Uqx9/tRdF3xbaNVqJb5Cg9d3SDYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719602829; c=relaxed/simple;
	bh=485Fk9bkb6KlofxU+R4jbvQ87vsY7/owh8sq1O1xVG0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kokKzE9MRxzfLXiE/zHanneGZFVwaFXDXYknT/vkmy7e5sH8KqeCw/3Sv2D4V3obKLsNWLbG6mJP9ftYBzX79BEy4bXZBt4oXf3+DcJj0ZwPdeb7P7u9UT7OfAMPyf0aFF7WI2qmKKaQKnESnfoVs7xezGQZmgnHOz/osch0IQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=CSw6V+Fn; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="CSw6V+Fn"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4W9ln13zVjzlnNry;
	Fri, 28 Jun 2024 19:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1719602816; x=1722194817; bh=485Fk9bkb6KlofxU+R4jbvQ8
	7vsY7/owh8sq1O1xVG0=; b=CSw6V+FnF1T9nPtu9cz4hErzJc5YB86TJltQ3YOL
	QepTaCdpERfk51mQKuWpzkI0Yhn3mGlTQIZITvY7vvyWhIue38OmdBJZVKEGbatz
	k5sUxj4AEaOB15PNMRmWx+aRoPqUOq4f3qa0o/l/CSRkU8Oz2ZqNwYzpiotZKE4+
	TDFjXaEFGcSZOrtgJ74fShgu9+50xxxVkRQMyysIqSJnN/Ah3y8wYosi7uoEaFuf
	PgbKKYBsKtzC/V/bgYh6xRp8d0Sx2uhNKoMbbLz8u5zEu/MawqFWQb3oq6ndI+KH
	6A61toxxEz/VrIek/4KPGykWsm2fge2q90ZeNJoxBowGRA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id qVxaLc59fd0F; Fri, 28 Jun 2024 19:26:56 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4W9lmp29p4zlnQjf;
	Fri, 28 Jun 2024 19:26:49 +0000 (UTC)
Message-ID: <292a598b-6cc8-48b5-bf1f-17a27ba8c57a@acm.org>
Date: Fri, 28 Jun 2024 12:26:47 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] ufs: core: fix ufshcd_abort_one racing issue
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com,
 jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com, powen.kao@mediatek.com,
 qilin.tan@mediatek.com, lin.gui@mediatek.com, tun-yu.yu@mediatek.com,
 eddie.huang@mediatek.com, naomi.chu@mediatek.com, chu.stanley@gmail.com,
 stable@vger.kernel.org
References: <20240628070030.30929-1-peter.wang@mediatek.com>
 <20240628070030.30929-3-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240628070030.30929-3-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/28/24 12:00 AM, peter.wang@mediatek.com wrote:
> When ufshcd_abort_one racing with complete ISR,
> the completed tag of request's mq_hctx pointer will set NULL by ISR.
> Same as previous patch race condition.
> Return success when request is completed by ISR beacuse ufshcd_abort_one
> dose't need do anything.

dose't -> doesn't. Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
