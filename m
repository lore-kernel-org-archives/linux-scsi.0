Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997A21E47B6
	for <linux-scsi@vger.kernel.org>; Tue,  5 Nov 2024 18:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730833043; cv=none; b=kRIF4gXrpmlvcKR/BP4mn1lqYsIjiQ2Wj8pbMQr2ZR0pV+FLAF38uUIbOws6laqzCr3chuRmPD71HSxzrvPuCbN/hgEWbzQ2QcHot4J+0E7eY+Br33dUqY77pvzSXpEfv2bfux8kqJ9W3P2LZ8AC6atA0U8SbsrGBqAwsfiNQlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730833043; c=relaxed/simple;
	bh=42/yqzU1HOZKQf+awvRmZ6LnWN4BgiUZhy6FTYEt3pc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BrY4v68+0gfYq1yNd3PvBORPrTs1fPzHHGR249UjYBaeFGibhD4Tz9MEuK2onIhin0zhZLPbvoXgzhUs1fH5syZv+IRPod+vMMgld+DtgheJ+we1GbYQPt8g2bZHL+K0EQ56pp7rfQzTb3vOEZJNNKipVVdy7GIjAdEFlb1x1Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=NlFs6WEr; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="NlFs6WEr"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Xjcv848qTz6CmQwP;
	Tue,  5 Nov 2024 18:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1730832849; x=1733424850; bh=42/yqzU1HOZKQf+awvRmZ6Ln
	WN4BgiUZhy6FTYEt3pc=; b=NlFs6WErkG/DdL5EN6tTnwP81abg+fqSIgo8iz6G
	KUywwy+d/MRuRVhk4dsfrRSX3FJYHpCcb+ngd7UWSP/CDWkRw6z2mo0y22SbMQTB
	5TjU41IosDl/Ymz0XeUcu0HNuf4PcJDj1zLcxcx8Q8ijeh0CiPIvH9ySbwddE6np
	TSwMyCp74nlmHq0HYcyj3WKiDXnLPc/2gIF2rdR7MdYAmHudb2J7l1wc+9v236kn
	VKbUE1EQ5AphvKw5B2cJ9TP9+bCGQOVT3wEYeqjDl5gCD1jkxii8Dd7q9WpaALOy
	WcW4dh2fh2scy82NGn5zTDSYtLqE7U3Btpn/s8XHGhpSoQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id dmunFRu74lP0; Tue,  5 Nov 2024 18:54:09 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Xjcv43x1wz6CmQwN;
	Tue,  5 Nov 2024 18:54:08 +0000 (UTC)
Message-ID: <368c8634-9b2c-4d06-a3c0-b32332f9ae56@acm.org>
Date: Tue, 5 Nov 2024 10:54:07 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: Start the RTC update work later
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Neil Armstrong <neil.armstrong@linaro.org>,
 Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>
References: <20241031212632.2799127-1-bvanassche@acm.org>
 <yq1ttcm4dju.fsf@ca-mkp.ca.oracle.com>
 <74c56b1f29a08df52c22a0ac01c1b31813ce454b.camel@HansenPartnership.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <74c56b1f29a08df52c22a0ac01c1b31813ce454b.camel@HansenPartnership.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/24 7:48 PM, James Bottomley wrote:
> Since ufshcd_post_device_init is now called twice can you just check
> that the simple fixup of removing the schedule_delayed_work() from it
> is actually correct.

Hi James,

The conflict resolution in 6abc45870e04 ("Merge branch 'fixes' into for-
next") looks fine to me. If this would make things easier for the SCSI
maintainers I can rebase and retest my patch on top of the SCSI for-next
branch. This will cause it to be integrated later in the upstream kernel
(next merge window instead of current rc cycle).

Thank you,

Bart.


