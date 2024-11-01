Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866151CACC1
	for <linux-scsi@vger.kernel.org>; Fri,  1 Nov 2024 16:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730478220; cv=none; b=ZqLn6NmUxpPMbofA4Nz0bjDzRDL+gHr4t2RLLxf7bi1JsZ1TYg1YrmXibgXDRGmJkPvN60tN5nNe/NDgRMIIWw20LflU155W8JewnHrmr2auLh/YOEgGku7mammz6HQPnTQcY4tXfkt6SyPOHLZ8xnJwk6saPA8pbz1sjBlHY1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730478220; c=relaxed/simple;
	bh=C8tFC760GqZBJA5/2FfFz2hwcDoPPFjLX/D6Xvr0Ahk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R75VHVQ8jnujBL8S+3gMq1gLrvGZN08113XotG+H/njIgWyhUlb1+SfFg6cEszSpcO/Xt6xezDVRqpfiFzJFLO0JFMifuxpna31c0JRM4zRabmQxVdPGTcD/TS51DiSRf41FVfjyCMhseOYrE0P6qjg8WFaFDLyoqrl43Jm3jBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=CvrVt0rK; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="CvrVt0rK"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Xg5lF63nBz6CkhT1;
	Fri,  1 Nov 2024 16:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1730478214; x=1733070215; bh=G5bNgVRNVGtoEXD0y0hD+NCW
	1Q22ot7wU8ltfHVgdhU=; b=CvrVt0rK++793AyV5PeEmQ8Y+f4tuCc9+eOfbAVA
	4vgC3DHoNcceREll0bE8gG8lYd7XUhiyrxCXvaUZ3G+hZGru0Xnf3oLyqhtEB/v0
	VMLcgQMTZgzI5Dd6O8EZatAzg85t7Za7lXY6TR+4CippXmVi6s+QABwzjFQG/2C3
	nfGHHa2GQnGBJX645nTOk6z6NKPDYJDOgMTEn7BwxihjgEiZcCtOxOquZNc6kC/P
	CsXqtZtQ5SlayDCPVeF2TJuIfEMQj79E2CvvleK5ofxC3q6DWyGwB0UHnnh3wxbq
	GDfMUXB456r4Ugdr2Lwgo/uBI4N8YJUPpzyicogVvkB5nw==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id PgJbK1Kn4nff; Fri,  1 Nov 2024 16:23:34 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Xg5l75VNXz6Ckj6t;
	Fri,  1 Nov 2024 16:23:31 +0000 (UTC)
Message-ID: <5588fc82-888e-4be8-b28a-5ab2a69d2ce9@acm.org>
Date: Fri, 1 Nov 2024 09:23:29 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] ufs: core: Add WB buffer resize support
To: Huan Tang <tanghuan@vivo.com>
Cc: huobean@gmail.com, cang@qti.qualcomm.com, linux-scsi@vger.kernel.org,
 opensource.kernel@vivo.com, richardp@quicinc.com, luhongfei@vivo.com
References: <13aff452-0ce8-4ebf-986c-dd3bb7c322de@acm.org>
 <20241101093717.893-1-tanghuan@vivo.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241101093717.893-1-tanghuan@vivo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/1/24 2:37 AM, Huan Tang wrote:
>> For the three new attributes: please use words in sysfs instead of
>> numbers. Using numbers is not user-friendly.
> 
> 
> Hi Bart
> 
> Thank you for your reply!
> Thanks for your suggestions
> 
> I am confused about the above sentence and I don't understand it. Can you give me more detailed guidance?
> 
> v4
> https://lore.kernel.org/all/20241101093318.825-1-tanghuan@vivo.com/

Hi Huan,

Please modify the implementation of sysfs attributes like
wb_toggle_buf_resize such that a string is accepted (e.g. increase, 
decrease) instead of numbers (1, 2).

See also how sysfs_match_string() is used in e.g. drivers/scsi/sd.c.
Several sd sysfs attributes support writing a string into sysfs
attributes and that string is translated into a number.

Thanks,

Bart.
