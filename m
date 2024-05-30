Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D34C433CA;
	Thu, 30 May 2024 19:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717098669; cv=none; b=meFG7kGNYWUVzIgCmrdkMqI20wugsaZALQD+MMVPFvIw7jmfWvQ+RR2a8+NhYs0Y29FllM0Gsru+cVa05b6XpD1edQKTx7bQg7jsiCScd8Ytzq/iTHAR9fWw70QnWlN+12YeH1sUPzbJ+pKCF+DjN4I/SsoxYR6GzZPpCKk8Atw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717098669; c=relaxed/simple;
	bh=dESl1sR1i4zs7HMjTvjybivNkuLrDDgildKTh5A/YLk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IxsX6j+lAw518+95mSfwbLwm1r/2GXfjrYaQ7W83aMsY5zmnMwKDMRx3VaPnCVIk4fx8UgAw5CewhMnXPRZPCBkSU0BlRN43gB5hmV5dNYcNEoRppkJxkj/5emTy8L6+7Uh8tcx694KUsNRY8NvyGiFzUvUz6JhXcxMIfwFXLGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=BMa7rd7X; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="BMa7rd7X"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4VqxhD06zdz6Cnk9V;
	Thu, 30 May 2024 19:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1717098663; x=1719690664; bh=BLwZbOo2VuEjeawIOT3dZywp
	LeD1IzBghu5o+yp6hiA=; b=BMa7rd7XppGue5oaVmK2KHUY3MIK85AfzEEn+EKp
	bcNLOjbFEai52dS82B0yhSPKs5RyqQXlGiN4QD+YUDbrcAZHAjNBuw86VOjnbcWc
	KpSflEQS63VRNlvjxLG6uywRVDTYgOMSrCxedOS87bGL09MYLZfeGA3T5ub8rgQI
	sS/meOXbeO/ZoOUiTMgwb/aGcVJUK8awiaLnzIKJ7y1nfc5R9zHMSdwMeuPfjcqP
	3xL2my5/vEmEuShKNLcDV1pHPpTg6z1N0uk5Ah0GFOd0IfgaFouOWdGCAH9KTqO3
	3vxrR40G8smQRaSEyQHqccCit4O/AMIRLYUJfU2LODky0g==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id x4rVbmHKH9zP; Thu, 30 May 2024 19:51:03 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Vqxh56rNhz6Cnk9T;
	Thu, 30 May 2024 19:51:01 +0000 (UTC)
Message-ID: <391fad91-7a65-4b2d-aa5d-58a5bc341d5f@acm.org>
Date: Thu, 30 May 2024 12:51:01 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/12] sd: add a sd_disable_write_same helper
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>, Josef Bacik
 <josef@toxicpanda.com>, Ilya Dryomov <idryomov@gmail.com>,
 Dongsheng Yang <dongsheng.yang@easystack.cn>,
 =?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>,
 linux-um@lists.infradead.org, linux-block@vger.kernel.org,
 nbd@other.debian.org, ceph-devel@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org
References: <20240529050507.1392041-1-hch@lst.de>
 <20240529050507.1392041-6-hch@lst.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240529050507.1392041-6-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/28/24 22:04, Christoph Hellwig wrote:
> Add helper to disable WRITE SAME when it is not supported and use it
> instead of sd_config_write_same in the I/O completion handler.  This
> avoids touching more fields than required in the I/O completion handler
> and  prepares for converting sd to use the atomic queue limits API.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

