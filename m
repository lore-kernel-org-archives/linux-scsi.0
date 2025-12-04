Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A973016A956
	for <linux-scsi@vger.kernel.org>; Thu,  4 Dec 2025 18:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764872769; cv=none; b=TpvT/mA97l/sbRk7cCCaiFuKvkM2RXVIcoD4mzdySEvTqZFnPmL6fucQ1HPdl7xXKcTGWxt4OWh1PuMOtZD399XMloldtS6ot1yknsb4MFDx5IFYSfgOFHAwzeWL7zQAp6Jt/dSznEoXJldvKlDA6dOqoC0IXfKpqin4qnSfJAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764872769; c=relaxed/simple;
	bh=UfzXyk5k5XwXK5on/6DAWQPWztVTXSu7a5gX1G9zqL4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=to9BB+UvhKbrB80oK6N/RK2ZxEALtjWxNudrb71dXY8o4OslTj74GCZgV41UK7kWli/kogNnY2FHdo1zi0bNnrnDpFBu7iW8jJ7s0riIZoAtedMI7/rB7JcUdxr5kMKm5h3MKNETwcTSDyu3q+akObnrO5gEVfCTjuPO+Tvf/7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=L02RQjp1; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="L02RQjp1"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4dMjcv2ZLQz1XM0pl;
	Thu,  4 Dec 2025 18:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1764872766; x=1767464767; bh=RyOGwDB77RMptSzs277PcqKq
	l+whtDh2Hz39Ff03Lic=; b=L02RQjp1Vu65CPW+9pidbrsNE88H3D67A88Chz33
	HB15TmhrUpLy5+yMdErlxq96CCh/aTsnsS1JaMwOldv0hlK0BOXRO6b56njBn/b7
	jHVBg+LHU5QV8Le1kwY8YMUA7+aQ+0BgvpSjyuHw3kWFfrHj48IjNCVYpEnATqX+
	jzF6IygUcf//qPPiKD4vMM4msoOltcx0GmLrJMEmqvei4umRMpEzB2M7ospKGSFO
	e/JpIb7uRDoBNjxUx4SkwUuna9SmkHjzj74rimoYDxcBCs/8RX2Br16zNeMOBohm
	UNiIUteUOk546ITGecVmSWJHBrOBuHa2wZ/BbSMNs2KWrA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id q7nqc_6S3BSP; Thu,  4 Dec 2025 18:26:06 +0000 (UTC)
Received: from [10.22.10.72] (syn-098-153-230-237.biz.spectrum.com [98.153.230.237])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4dMjcq3JrFz1XM0ph;
	Thu,  4 Dec 2025 18:26:02 +0000 (UTC)
Message-ID: <8fd25434-d796-4bd0-8806-7e919b41c6bc@acm.org>
Date: Thu, 4 Dec 2025 08:26:00 -1000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ufs: core: Fix an error handler crash
To: Nitin Rawat <nitin.rawat@oss.qualcomm.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20251204170457.994851-1-bvanassche@acm.org>
 <5bf4b4f0-4e76-43b9-a27c-e2f87f0de5a6@oss.qualcomm.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <5bf4b4f0-4e76-43b9-a27c-e2f87f0de5a6@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/4/25 7:38 AM, Nitin Rawat wrote:
> It seems you missed sending the below patch. Both patches are required 
> to address the issue (hang and clock scaling errors), except for the UIC 
> error, which still needs to be root-caused

My shell history tells me that I tried to send the fix for the clock
scaling hang to the linux-scsi mailing list yesterday. Apparently the
patch didn't reach the linux-scsi mailing list. Maybe this was caused by
the hotel Wi-Fi. Anyway, thanks for having pointed this out. I have
resent the fix for the clock scaling hang.

Bart.
