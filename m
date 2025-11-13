Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2335306495
	for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2025 16:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763051346; cv=none; b=E6FQmE/smsS7Re0xsJyDOidMC+lR9ZxiZgTLgeGnQAI09IJa1MteUr327nOFWFcW1Er+3t0mNX1awQVmT0c1xHA0E8/k7/kopBAv/jsJ50e4m8bTrTWUgsour9eMSe1QLDe1INTlchVfA2OWNmv5FA0wiTlN5oNf3fHnuEWxOMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763051346; c=relaxed/simple;
	bh=c6drLUcx4CVBp8LnzTJ1YF8Vgc4lVF7U+AKedegwYaA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jV10Manm0yQp2iWT4FOM7OWIFsdUuqN37gXuz1fci1f9VxjatUb+MIjAmeqKMXaD8EVYiT8l9gt+DxxTs+/WtmqB70mD8tv12VPhLEAgXKUGIETWzIgesoaixMtEsiLwNqtu3obrsQg24LM8cGBNy4yeTclVyX0WNWV1FOTC80Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=cYt5SnUJ; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="cYt5SnUJ"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4d6m1W53QszlgqjV;
	Thu, 13 Nov 2025 16:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1763051342; x=1765643343; bh=c6drLUcx4CVBp8LnzTJ1YF8V
	gc4lVF7U+AKedegwYaA=; b=cYt5SnUJU2ZW4ukdHeqDX2uK6p3PGL/rE2aS4KlW
	KVZaM5G7ydgc7Qr6ykcS2x5pciTwWsRywUo6v5W7fyApZs2LZ2Mq35P2JW85xplf
	jOcpvsFYzlDDD7ouaKHfuJTnrg9OFyQvOGrHdR/U8uNTkrx/uxhz5/7CjuV1syMR
	pW2OY69MYI4kMFLr+HkD6RoGyihw2+r9ibbwBrvlBmoP5gdO2a9Xua8YXEUbz0zn
	3GEhmph2MJYxAV9nshfTXjJVaRfJDIC6ruht4cAEj3IrPBYEn7NIPrShy8rQNj5u
	BxOx9rKEKhhOhYqToGOLha4J5is2FVSrzaIOYBlCDa+ahw==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 1qpylD2q_bhh; Thu, 13 Nov 2025 16:29:02 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4d6m1R3gdmzlgqjM;
	Thu, 13 Nov 2025 16:28:58 +0000 (UTC)
Message-ID: <faf2e938-5bb2-448b-8e34-a8422611f54f@acm.org>
Date: Thu, 13 Nov 2025 08:28:57 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: rockchip: Fix compile error without
 CONFIG_GPIOLIB
To: Shawn Lin <shawn.lin@rock-chips.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-rockchip@lists.infradead.org
References: <1763011091-243727-1-git-send-email-shawn.lin@rock-chips.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1763011091-243727-1-git-send-email-shawn.lin@rock-chips.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/12/25 9:18 PM, Shawn Lin wrote:
> drivers/ufs/host/ufs-rockchip.c:168:19: error: implicit declaration of function
> 'devm_gpiod_get'; did you mean 'em_pd_get'? [-Werror=implicit-function-declaration]
Reviewed-by: Bart Van Assche <bvanassche@acm.org>

