Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90D218C322;
	Mon,  5 May 2025 16:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746464112; cv=none; b=Vn2x0VA00beSKwC0nAVzTEP+aos1IitdojfT7+sqLxMUi1kNZiFSsD6zn+19VMtg2SUpe/FeSIBs1YS0DI13pxRSqe9ypacGPsqDSRMi9W7pwq2zpLjteAM2IxvdsQgOZLm0o/JwoYRBUum4j8pnR2I7uJFY3D2de984kU6ihxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746464112; c=relaxed/simple;
	bh=KqMqzbRZc4K6m2I2OzYb3S8yTZKb+Bvk5nv6OKBxla4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k4yRYSaU9WpHeS3xPMD/nhXuQH7ssX+QwDlbm2J9wJWKLt+2ZCdWQjTLih6cuJ+TtlDLTeLQ5WxymnMucC0f2viZFKxbEEtuUTYq5BZYuU87+VB7+RBGmDpOFt3pJxnlL638/9Fsc8AXxhUTYpbXzAZam524UJWcL6c4Yw2tksw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=kpn6qr1A; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="kpn6qr1A"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4ZrnhD66klzlgqxr;
	Mon,  5 May 2025 16:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1746464106; x=1749056107; bh=KqMqzbRZc4K6m2I2OzYb3S8y
	TZKb+Bvk5nv6OKBxla4=; b=kpn6qr1Ak4EAZLphiBxb9e+Ur1vrPuJmL5+GCgDX
	JJXRF0WyA4bGKStuM25pBoTfd7w/m2BWC/imNO+IWLguHw1XU5DcDo5Syt3wk4HY
	mu1QIyRADZCN3oB9P2aR4dZ0bi3Uu1DfiPXLYZsUhZBqlNrzgOlG3N2OCAKNdUYE
	d4fgcA69ARpaWdRKsLVNxvQn0Ta+stFEkSMJifIl3Ag5l6rH5cVqNYO8Z8vEMwSM
	NAn2gDCZXq0GzjUwlidLr72RyHOtTn4PoZZ8a0gVDTERLz6TQ0m3pJrVWo6g7FMa
	F80omCGBEogfFwAXOY5v2QkrCFzzsNjwTbD2MORxTEIMQA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id S3c9Q-mRkkDm; Mon,  5 May 2025 16:55:06 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4Zrnh25QDJzlgqTs;
	Mon,  5 May 2025 16:54:57 +0000 (UTC)
Message-ID: <3743e95f-f900-4646-b82b-67c104174852@acm.org>
Date: Mon, 5 May 2025 09:54:57 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ufs: core: Remove redundant query_complete trace
To: Avri Altman <Avri.Altman@sandisk.com>,
 "keosung.park@samsung.com" <keosung.park@samsung.com>,
 ALIM AKHTAR <alim.akhtar@samsung.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
 "manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <CGME20250425010605epcms2p67e89b351398832fe0fd547404d3afc65@epcms2p6>
 <20250425010605epcms2p67e89b351398832fe0fd547404d3afc65@epcms2p6>
 <PH7PR16MB61962DED035E3F1F5F03B142E5842@PH7PR16MB6196.namprd16.prod.outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <PH7PR16MB61962DED035E3F1F5F03B142E5842@PH7PR16MB6196.namprd16.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/24/25 10:38 PM, Avri Altman wrote:
> Fixes: 71aabb747d5f ("scsi: ufs: core: Reuse exec_dev_cmd")
> Reviewed-by: Avri Altman <avri.altman@sandisk.com>
With the Fixes: tag added:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
