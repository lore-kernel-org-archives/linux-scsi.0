Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC6114E2CF;
	Tue, 20 Aug 2024 21:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724190314; cv=none; b=D+WeMHEwhBy9OiqAnIHhvnimMrpGhNkxx96VE+Chok5pxWEfc8mK3YmBV/m16XdGRFXoEATKP+XUSSxe9yBdU7aA0hideHZgjs0eZeEXw92dnC4x9MpBhpXdqRTKyY6LNi2O54u3E5MUbDOZwMC3/3x2AFz2NJLMGS9Nlig0eVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724190314; c=relaxed/simple;
	bh=MW4i48apLBolo+/0Ycj5RuNW0EZ08jw/ag/KEk0XfSk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HRygjPKQI6+x1y1oshXoQFoxKzd+2ejTos4HUlO02I77lbm6Cwq02kXoWVYP1EH1nqWxFD2gIIVXI6h7leJdDow4g90rYIREKSBnJtfmZuq23vrk21RPZhBpv9BykMDwPwzjfmnhCffoV9gmeYyQM+PEHwa1CgDWav0Jn+oM1bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=4GStP2Vi; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="4GStP2Vi"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WpNL008lCzlgVnK;
	Tue, 20 Aug 2024 21:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1724190310; x=1726782311; bh=pDs0hipE5/gOxbODEqoiON/O
	iSacltQTNbDPcc9nCJY=; b=4GStP2ViU1t9IVoYvWCuz+k4ekveyUzgcBB9gy3u
	jYTbsDYFIiL6RMdZHM+2eSei3ksDJs5TigZfIvdIRF8QAwZ8GcutLMQ1mnW/tuT9
	x2v/JFV2Ua205F4eyHb2Yogv0t+5vZ09+2hHp66vKwouHZqlSES4lSUQQYZwxPtf
	22KByT0O3qYAfwFhTaKcUdIlcC2dzt0SY8wYa5mu4tFhxCE2UtqSDw54UBKIwQYG
	8BkAXMjJ6DBpWgCuEyZ/gO3sD98stR08Xc/PljvCushl/D6R3NMvE2m0N5jk/DZr
	3BoMYKefWYeK5LBHfI5fjRZ6+i/4HbHY30IJO8S9cUF29w==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 0ps_iG3hBmk1; Tue, 20 Aug 2024 21:45:10 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WpNKx42xCzlgVnF;
	Tue, 20 Aug 2024 21:45:09 +0000 (UTC)
Message-ID: <2040ab22-da54-4b7f-a1a3-3d2f7846f216@acm.org>
Date: Tue, 20 Aug 2024 14:45:07 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: Move UFS trace events to private header
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240820035826.3124001-1-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240820035826.3124001-1-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/19/24 8:58 PM, Avri Altman wrote:
> ufs trace events are called exclusively from the ufs core drivers.  Make
> those events privet to the core driver.

Once the spelling of "private" is corrected, feel free to add:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
