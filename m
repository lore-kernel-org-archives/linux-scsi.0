Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F88F1A6809;
	Mon,  4 May 2026 03:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777863980; cv=none; b=uDUgaEZ+hqK2sPh7QJR5NllPP4DnxguXuFlkxGmcyqr3QWmxoH/hVD47gXtIJiTP2EUizWJPCf1jpL3HQAH46IsfYeCyUd44RZG8YfqZRJroOIayp4F1H/ldIVqo2Hd/kX4/HyD0Cs8K5DWwvHVDL3gtoqPlTEHMnp3HmMEG4KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777863980; c=relaxed/simple;
	bh=nqai79gF5PEjKhwEpnORYbrybKr0FLnKacIORrXYgW4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rh5NTzMtQS4RL7UZyXjz/WDRnAci4LAZuYMnyAfC/61InxQPkrazOjkuF91K3vCvbFPAZ5PAYo4f/zp6MuJPpk0mg9nhJZjBliZoqu5uTQxYm2rEf8OVuc6RS3bp+ST1P5UF+LffAYF4EGwKNaQDT1s663hpuguX2BKDsCD1BQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ZfiiIufz; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ZfiiIufz"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4g863m14w4z1XM6JY;
	Mon,  4 May 2026 03:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1777863968; x=1780455969; bh=YaPJJaYT9ZeWKaZ4bOV3JWfH
	3ZvpMdBnyqU3I9W3x/A=; b=ZfiiIufzgF4FMy6WCEsNhQkcfz8tpxJI7kSFtNHE
	z6E+9agwX2BDD9caatWXz1+f1cDwUKhtOpr2rAYMukVpPOXX12FPerVHlc1KgWgu
	BIDIMtZKyvtG2lmZkp5DqtPd/wDr1mf6O/b2doJ08L+EZOs/BFOXyBHYTSXeLjbl
	P36QQFtAT2sN6BqOFm5j0hKe4gRFvr3KWI/S8BEf7AK560GWT2tsdxqsTkId+ORX
	Y5nDGw/SokQ9M7xBeguLAwl64YqUqEOQAsjBQ56mT78sQzp3fR5fKkuDvV7X59j5
	wOjqEWMtoPiRt2Zww9h6OOWUdSbUqCEoe/keeZP88gLJ2g==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id GkyQzn9gaC04; Mon,  4 May 2026 03:06:08 +0000 (UTC)
Received: from [10.211.8.56] (unknown [213.147.98.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4g863b5nqVz1XM6JR;
	Mon,  4 May 2026 03:06:03 +0000 (UTC)
Message-ID: <326ac80b-c433-42a1-a18c-3979f7abf1fe@acm.org>
Date: Mon, 4 May 2026 05:06:00 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: ufs: ufs-qcom: Use quirk
 EXTENDED_TX_EQTR_ADAPT_LENGTH_L0L1L2L3
To: Can Guo <can.guo@oss.qualcomm.com>, avri.altman@wdc.com,
 beanhuo@micron.com, peter.wang@mediatek.com, martin.petersen@oracle.com,
 mani@kernel.org
Cc: linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "open list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER..."
 <linux-arm-msm@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
References: <20260501131641.826258-1-can.guo@oss.qualcomm.com>
 <20260501131641.826258-3-can.guo@oss.qualcomm.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260501131641.826258-3-can.guo@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/1/26 3:16 PM, Can Guo wrote:
> +	if (host->hw_ver.major == 0x7 && host->hw_ver.minor == 0x1)
> +		hba->quirks |= UFSHCD_QUIRK_EXTENDED_TX_EQTR_ADAPT_LENGTH_L0L1L2L3;
How about future versions of the Qualcomm controller? Will future 
versions support this feature?

Thanks,

Bart.
