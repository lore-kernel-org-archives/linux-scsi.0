Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF253883F
	for <linux-scsi@vger.kernel.org>; Sat, 29 Nov 2025 02:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764383522; cv=none; b=bgI88nvdqUcLWTXZsHz+3lL4KPNjIwh6imisasKqmX0w+6zjRz4qByQqzRzUsoNZmbJekxiXoDHp/EbfTmGIrJyy7ZylQgkXz41qtZyoZJ5QPsyih5mnvd5ALQ65ucwb3tvXDugigdEEW6Mu1ZczjcGJCpLZeb7HJvLUFt0ZecA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764383522; c=relaxed/simple;
	bh=JzlAL3Q3U+zD9uPF1rWPXpxKA8Fhht1H8H80I4HJ5mQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=daB7+LZzsGp7noraCuGKqq107AS9e/RbCXxptCQDZbFMpQpwrMV0ARIu3IUTPdnsoYAnCuKcw1XjTVQvyoYw4Fg9BpPZeW8ekie0cyrl2pzWlUszVRQ58D56q9yDBeIzJgOPhW1WAaUJm/jMWkW4gG38ZNUP7GuDrm3Kgj5JGnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=JqL2vdDc; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="JqL2vdDc"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4dJDhB2Vqmzm2Xgx;
	Sat, 29 Nov 2025 02:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1764383512; x=1766975513; bh=JzlAL3Q3U+zD9uPF1rWPXpxK
	A8Fhht1H8H80I4HJ5mQ=; b=JqL2vdDcNqUtMjN/2kU5LzJXlZgH/LApptoHxwAF
	/5x2vezMFMYRdgovxnYJ7DYd18hvTA8ZYNNy5uxMvNS+aMRB4zcNp4B2T+knYnP1
	FPYxORxKjyxV2uK3rLccUkPBhdQ9B9WYoGoS3G2FAruYxUoVhIbtGdYJcApwFAq/
	PiTuNR70qp1gz+u4vmE29xd9q6ZZyxaTZH6QnjkV36DXRD05cvIOwccKcNB7J7ke
	b0LVEQ2ccqoTEW29Hsp3OMTOo8UqjW5dWonKel33n8+NMofx/c+yXJ61r6ulS51o
	pl32CvdSDNPZTx4AN+LTttJF4lSGFGGtQqxRjZHV7he7CQ==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 0BTnTUsvikxO; Sat, 29 Nov 2025 02:31:52 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4dJDgy32clzm2SwN;
	Sat, 29 Nov 2025 02:31:41 +0000 (UTC)
Message-ID: <5f75d98a-2c0a-4fdf-a2a9-89bfe09fe751@acm.org>
Date: Fri, 28 Nov 2025 18:31:36 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 21/28] ufs: core: Make the reserved slot a reserved
 request
To: Manivannan Sadhasivam <mani@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 Peter Wang <peter.wang@mediatek.com>, Avri Altman <avri.altman@sandisk.com>,
 Bean Huo <beanhuo@micron.com>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
References: <20251031204029.2883185-1-bvanassche@acm.org>
 <20251031204029.2883185-22-bvanassche@acm.org>
 <ehorjaflathzab5oekx2nae2zss5vi2r36yqkqsfjb2fgsifz2@yk3us5g3igow>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ehorjaflathzab5oekx2nae2zss5vi2r36yqkqsfjb2fgsifz2@yk3us5g3igow>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/27/25 8:59 AM, Manivannan Sadhasivam wrote:
> [1] https://lore.kernel.org/linux-scsi/20251114193406.3097237-1-bvanassche@acm.org/

This log fragment is only 55 lines long. Please provide the full kernel
log.

Thanks,

Bart.
