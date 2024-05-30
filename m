Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E356A45BFD;
	Thu, 30 May 2024 18:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717093672; cv=none; b=Ibh6sMGnGPrMvoBGveFaE1Tzh+W2pPL/blzB5rX2rz1faLmqqj6ps0WDKu+qhVgtLsgAB9JLY3573A04r0uklwXKrGC6vhPcGI7Gkn98MyYgBxnZ+BnZ27OTEEBGLS+tPn5GDGpUjotnV3DCXXzhMfMfzw9cORxH4kAN+28K8qI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717093672; c=relaxed/simple;
	bh=KaQVEhoosL8YyKS5GoYRsFIKqwpsSrHtmCam8LMqLaE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p/XDZpEEkSRpN79mAwpQlHwkK25G2v2T1nCtPul6GOtVVV/xkfLvPpKUSocT6ArXk4w98GooFX1TtZFLH7dvtmFPUmQ62/tUccoxQjd61HY4YNioNoFYOjD8Gknfhj+ZgDweeQK+94biI2YtvIgdLUXvYRoT4Z4qpySUUbYWuAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Ntef0I0c; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Ntef0I0c"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Vqvr61TP1zlgMVW;
	Thu, 30 May 2024 18:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1717093668; x=1719685669; bh=KaQVEhoosL8YyKS5GoYRsFIK
	qwpsSrHtmCam8LMqLaE=; b=Ntef0I0cRYoPVfw8wyuZstTFu2PPyXBrVVEsoZHN
	PWkU/ez3V+ZE8eXi2p94x0TAf6Ef7qt5ZXGcefvg+S3+Pk9xxI+d0p5TwYHkGo0C
	wX5HQii6TxuyU1q9kOMdZniHP0L5Ka3/RN9dvvLvi16bTkK6UP3kDvZBOkAC9xJ/
	TlfAOnapEvu6ltiqmcmTHUozyFy/9F8aiY5zaukw3Y0wAbKHBQMsuKO4LzZ+N6wN
	i+zlMNNs+D0WnLrcIO/B5Jy3V08cHvqvolwwMO7pjEQ6vJMh1DygQPP0xuN/+A2P
	yB23QiVwxABf+0xoVfryvgfXSDuCID7mVxdBeDVo1bNSVQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id BI1ggWPdOuNp; Thu, 30 May 2024 18:27:48 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Vqvr414QGzlgMVV;
	Thu, 30 May 2024 18:27:47 +0000 (UTC)
Message-ID: <ce058689-9085-4214-94ef-939bd8f5963b@acm.org>
Date: Thu, 30 May 2024 11:27:47 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 3/3] scsi: ufs: sysfs: Make max_number_of_rtt
 read-write
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240530142510.734-1-avri.altman@wdc.com>
 <20240530142510.734-4-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240530142510.734-4-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/30/24 07:25, Avri Altman wrote:
> Given the importance of the RTT parameter, we want to be able to
> configure it via sysfs. This is because UFS users should be discouraged
> from change UFS device parameters without the UFSHCI driver being aware
> of these changes.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

