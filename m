Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7842F13E3EA;
	Tue, 16 Jul 2024 21:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721166261; cv=none; b=B/KuDSss+F5fHXcmDJjSuzBfhlxnEEX2dLPb/xZ+RIEeiDQi/ypHeKdErRcFQVeRozk/iY4l8ZalRCpBv6ZrR/L4nzvIGn25Zy9bL97zYxrXdxxAlXsO6XUKiVx5L1h9A0JK9TGv7tIdri2QBNTWAu4yXWTAadzJ1CVkvzfZ23s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721166261; c=relaxed/simple;
	bh=qwihffuM8/DrrQ9zeFgfLv/otk8t9ehBE7KDdulwOxw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VRBt5mk78y3bGjbAyKpU/OJ5BHCukKcau4abEaxbqrIT4lnRwVn8tWc9U7zdqbHbO8g/QnmIcogI1c691m7sNwb0hLTxmNWHcx1/uz5nMFoAjJTIFD4C/cHY2XtxZCN3Gc8AhWMGmAf6I8uiQmEzdfma/fgSU8aCOeRrzaQCdOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=s//2ibG3; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="s//2ibG3"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WNsz65xChz6CmM6V;
	Tue, 16 Jul 2024 21:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1721166256; x=1723758257; bh=qwihffuM8/DrrQ9zeFgfLv/o
	tk8t9ehBE7KDdulwOxw=; b=s//2ibG3Px+7SDNsL0V3hOECRUEv9SnWMqi6k9yt
	Bwf968YbhEteUCvyIJkNZ2eer0kPms81pqfZus46lXfNI4n/BKKPOODjsAoR5uMm
	d72T3eoLyu/SgEErPkaIhv2+BArkLrLQLOGhSKdN0LQ4phFW5esPzkdwA5Pe5kJl
	ipoMpD00+m5V6A+iydveZteMBQ+wY+RivAV3JuMrCoin3gdztvD2Jouj4kqo5/PY
	GpPX8mq3G2aNPI/w65UeSHKOVWosDqAUwZ0ZkEcevOqYIt6y+FHm3T7ft9hygwmf
	naLQITb5soQ9HtNi5erPo4IeLwqurIBQOaJMSItYrMEd1Q==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id E0RecbNBRlSp; Tue, 16 Jul 2024 21:44:16 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WNsz30Kg2z6CmM6T;
	Tue, 16 Jul 2024 21:44:14 +0000 (UTC)
Message-ID: <fcdc2791-1fca-4ff6-8684-f4522ef6eddc@acm.org>
Date: Tue, 16 Jul 2024 14:44:12 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "scsi: sd: Do not repeat the starting disk
 message"
To: Johan Hovold <johan+linaro@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Damien Le Moal <dlemoal@kernel.org>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20240716161101.30692-1-johan+linaro@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240716161101.30692-1-johan+linaro@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/16/24 9:11 AM, Johan Hovold wrote:
> This reverts commit 7a6bbc2829d4ab592c7e440a6f6f5deb3cd95db4.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
