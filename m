Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB7B4C630
	for <linux-scsi@vger.kernel.org>; Tue, 18 Jun 2024 16:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718727284; cv=none; b=cRkqGyFgndysmHry82MCrUHy3wtkXhNiyfvHCZc2YGCOyx774k3r2q4/VmWRzyCtZNoOV3fKacNXNyXITy42C4v6NBn8WmUp9dDjg4rp+GVfa5hK09jaP+SHdj5sBpm6dx4C9szq1/3EQOL4xUN3SnuphKpDuGILFEl/tKZG3wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718727284; c=relaxed/simple;
	bh=fZz0CsEQJisyMAc0ZIclM8DH2bA0BOYudzSObTIVOGw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bt+U0O3VjjMf++5EYqkM+kTz+WlLarJvdY7wMvUvNw1vcCUKZ1UQD4c5/SxWDp4awq6q32SFj2UInTI2bg/PsjUyOrGxLS30WIAHtU/bmTKpdWTddM/s+LOHiIK+JOA3KmHNxlSZGhhCdoq2sXXxbG8W5FwN+PvO4gyL8MGkiEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=I2bH68bA; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="I2bH68bA"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4W3Wzh52m5z6Cnk9F;
	Tue, 18 Jun 2024 16:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1718727277; x=1721319278; bh=EQACVgOsopCvwWL0SJrwghYJ
	huSc+wd5B7xQ2v54wC4=; b=I2bH68bApLX3iUbUr/fI4AmUZAPY+8aq7r1a+Lft
	UQ2x5GQbf1A/gVst5JsBgGWr1lYub4R0C8R9YECcGPNggEjB1qduOTe9c0yO7Vxh
	jQ2mck9uLlNjfQJaSep4aHKTB0yVxkqSrU4Q8yFZcGJmdPHaGs5yuH8iIKTEQCSB
	pufJTJUwgmKFp39cKdhamJaLm4hqxbjGrQXy7jR4NxTNOdWcwfMZEqFH5XCh7o7q
	yZjgraudKQSViCSvO/27t1Hys/h9hKJgQZHD9b+Sn7+iouQzBPRMKVCcE2ogJOrf
	hJRbP/JCTSNi2f/6Os9NCWeOcPqmig9yVuPUke/zKT/mRg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 4rcoqZJaNacT; Tue, 18 Jun 2024 16:14:37 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4W3WzZ1byvz6Cnk9B;
	Tue, 18 Jun 2024 16:14:33 +0000 (UTC)
Message-ID: <c83af0c8-b19c-499f-8de7-fa193b2033d3@acm.org>
Date: Tue, 18 Jun 2024 09:14:32 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/8] scsi: ufs: Inline ufshcd_mcq_vops_get_hba_mac()
To: Avri Altman <Avri.Altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Minwoo Im <minwoo.im@samsung.com>, Peter Wang <peter.wang@mediatek.com>,
 ChanWoo Lee <cw9316.lee@samsung.com>,
 "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 Po-Wen Kao <powen.kao@mediatek.com>, Yang Li <yang.lee@linux.alibaba.com>,
 Keoseong Park <keosung.park@samsung.com>
References: <20240617210844.337476-1-bvanassche@acm.org>
 <20240617210844.337476-4-bvanassche@acm.org>
 <DM6PR04MB6575721D80D8B63E840E9941FCCE2@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB6575721D80D8B63E840E9941FCCE2@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/17/24 11:23 PM, Avri Altman wrote:
> 
>> Make ufshcd_mcq_decide_queue_depth() easier to read by inlining
>> ufshcd_mcq_vops_get_hba_mac().
 >
> This changes its functionality by making it non-mandatory.
> Maybe relate to that in the commit log.

I do not agree. Even with this patch applied, .get_hba_mac() is still
mandatory.

> Also, it would make sense to squash it to the next patch, so your line of reasoning is clear.

I prefer to keep the inlining (no functional change) separate from the
patch that introduces a behavior change.

Thanks,

Bart.

