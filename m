Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D90A4964E
	for <linux-scsi@vger.kernel.org>; Wed,  3 Jul 2024 20:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720038873; cv=none; b=FYZqM4m4u1fV5uCm1NhHCV1EBaXhGk/V7R1tRoAph3RD5P4heesznQbk+NHMBq06C1AeCcU9D/ApkKagS9tsomlZtm5Wu6npx6ZeHGWkQCwOv5VEAO5lFPAgtWpfbxNNcuQv2LFbsuY4fudFzdszm8oJVC+K8ogNmCYEO4jl73g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720038873; c=relaxed/simple;
	bh=qw6fryPdqiSk1snmkzRS02Lkfc6+LRKWw++gKOGN0QE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bjGhjgKeKZavG8H02X9VYnjTHx0qmOLyXvxYXbPorK2BApvNizDwkUygaGJcbk2TAw9xXo3fUd/Qw8gC3gRs3Waa7wO/qdK4X7HBMNsOUX0cQ5KW3niA/NLa6VaNIO/g/y/eFo+kv/QyJ85y0fP1uNza5XHzuSQh9Op56/cwAb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=1Qq8Meq5; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="1Qq8Meq5"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WDs0257x6zlnQkp;
	Wed,  3 Jul 2024 20:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1720038736; x=1722630737; bh=qw6fryPdqiSk1snmkzRS02Lk
	fc6+LRKWw++gKOGN0QE=; b=1Qq8Meq5gmXHAdlRU4k1aRCjS6TC26fC8PUWY7Bn
	u+2aeSIivkbyER6aIyVVMfwC5pQ+8ku5dJHKwtKNn1PWvO0enhf2/7fGts0YEcx3
	1mbEazzZS0hA1m35zZbsBpb0Jri4i/i2UZbhUAAeDmpWuk/J++193YOnBRK/Pl6/
	xVr7ij2Wj+yECIZULm6nBG8ZEZoC32bVhGP7ab6pa5+LS6QC6wG7vhYZAQh1mn+U
	mkEGPgjGWuK6NcC1xnX1BT1aZJzFN5HhS+ZOjZH2QK2W6GPp1dvWXPILiynP/OH3
	oV/rvEa27eYEAqpLm4tlzvTPnCcbCkjM18+stMxa0v3QJA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id UTobZnKUOnGn; Wed,  3 Jul 2024 20:32:16 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WDrzy10YHzlnRRS;
	Wed,  3 Jul 2024 20:32:13 +0000 (UTC)
Message-ID: <4fc88c6e-9087-4df8-8069-2da9df95bd4f@acm.org>
Date: Wed, 3 Jul 2024 13:32:12 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 7/9] scsi: ufs: Move the ufshcd_mcq_enable() call
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Avri Altman <avri.altman@wdc.com>, Peter Wang <peter.wang@mediatek.com>,
 Andrew Halaney <ahalaney@redhat.com>, Bean Huo <beanhuo@micron.com>
References: <20240702204020.2489324-1-bvanassche@acm.org>
 <20240702204020.2489324-8-bvanassche@acm.org>
 <20240703131041.GD3498@thinkpad>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240703131041.GD3498@thinkpad>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/3/24 6:10 AM, Manivannan Sadhasivam wrote:
> But neither the subject, nor the commit message explains _why_ this change is
> needed.

Right, I should have mentioned why I came up with this patch. If I have
to repost this patch series, I will make it clear in the patch
description that this patch is a refactoring patch that makes a later
patch easier to read ("scsi: ufs: Make .get_hba_mac() optional").

Thanks,

Bart.

