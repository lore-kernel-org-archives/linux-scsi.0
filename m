Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82FC8AD23
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jul 2025 21:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753134528; cv=none; b=LW06dv/WeWa9pOX5D+rfb/S72E+iAenhKRRN4AZUkuq5vmYp6KAE0aTy3kKuGE6RMuZLPimCyREPRzlDuOr0iNfqDivYeyAobabqAuAisApeTrG6VvPZGDkW7ga8w96MvR2Ctv5/ch5H8AyuQRJLobjMWvt1RXfaCWNsYDB4LxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753134528; c=relaxed/simple;
	bh=RdUjl0b4dpu4Da4B+j4nvS2O17PrcJTu9OE+lUweVgg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l6Wq3LE+RCcbh9x3ro0SKgK2//DpFcrRmDbs7tTSPJrAhh8DPqEkCRZJqFXdacTrd1ORylaop87ASnzUZhpz6jXR1DfjV3u7KhAinD1WW9pKzIxv7B0HTTx5Ijbf7DUM4JeeXIbHTdmV2CmNoFDWzmHWU8TmogQKyaAJl0Ks/dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=3ASJ4uwq; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="3ASJ4uwq"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bmDYT2pP1zltKFq;
	Mon, 21 Jul 2025 21:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1753134523; x=1755726524; bh=+AIAN/S7uOb/AetffA5dOhd5
	9a6FrVW7LWLsjXUgdqg=; b=3ASJ4uwqfhac4KTdgbHE6oS1GqIAVle56WDDQhyf
	eod7LKhzW/WlahwTXT6Ivf0BrkvQxRg1WhJfom+hWiCkmymeMEtSyhA+Mz3nbTkN
	tC7WiHmao2tjxorxnRBnn+83J2GcGA5dgvDDOfb6HQGXABY33eOBq2Lihzvba2Yc
	ZViZq2GAbZmDaDYtG1SI0RX3iT7QDenGBZ+gFmiN83vFWY3gW/0yo1cIfz9tMgXd
	JqI8Mbj/MLcKOPPqY8gwzVygP5Oxl5twXe07ENxGLeNh74N7G2NBkNFjr8gTLRbr
	g4dfyKOnMi/EfJdtIo8zX6W6JBo6AYL+V4lP4TviouHt9A==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id I2CnoWWiT6r1; Mon, 21 Jul 2025 21:48:43 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bmDYK0qFvzlgqV5;
	Mon, 21 Jul 2025 21:48:36 +0000 (UTC)
Message-ID: <00665ba7-8c4c-4b17-bc21-58d7de2b3be6@acm.org>
Date: Mon, 21 Jul 2025 14:48:34 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ufs: core: Fix IRQ lock inversion
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Neil Armstrong <neil.armstrong@linaro.org>,
 =?UTF-8?Q?Andr=C3=A9_Draszik?= <andre.draszik@linaro.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Peter Wang <peter.wang@mediatek.com>, Avri Altman <avri.altman@sandisk.com>,
 Bean Huo <huobean@gmail.com>, Manivannan Sadhasivam <mani@kernel.org>,
 "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
References: <20250721212236.2852001-1-bvanassche@acm.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250721212236.2852001-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/21/25 2:22 PM, Bart Van Assche wrote:
> -	spin_lock(hba->host->host_lock);
> +	guard(spinlock_irqsave, hba->host->host_lock);

The above change doesn't build and this version of the patch is not
the version that has been tested. Something went wrong while copying
this patch between kernel trees. I will send a v2.

Bart.
