Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEBF921B9E9;
	Wed, 19 Feb 2025 20:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739997396; cv=none; b=jVaoYC5zNtCaPU9bhxQiarSrABAU9iRKmjLvqhtE55WfrTu+dUi6hxsXBdhDo4BK1JE3BGAqMs9hbJYFvNiXcssOZayrYQOCwsbvskbICofkc+ElDMKtffJzyZmfBpUR+wvOoHp02a9ujJ/01De4gOtFScoOpPeJupeaumr6vTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739997396; c=relaxed/simple;
	bh=kvcpF55O9IoYgGnwzhHUEbEPbDZFiOkhIAqxqYbbo1Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FVAYisAN/1bX1RwWcmPfHnoNu9/Q7nca4X2Y2aWn4rnHKaVmT/o0lGNrPPRHa5pIw7uDKDbP8vacDYONh/3rYnspWXXNjBXCMPu0Z+/EXoCL3WNYtIxS/zPlApR/YdkPFq1gxI8/rsI0qiUgWGQR35hvupP7c7YV4bwz2mM05Ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=MMckO1wj; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="MMckO1wj"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4Yyp8C6qlnzm0jvb;
	Wed, 19 Feb 2025 20:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1739997386; x=1742589387; bh=cXFXdL3Z4lMOrUAsHdxyFXuY
	LBQb5Cy9a/HKRtLgFo8=; b=MMckO1wjt9ujxXHUh5r9CoiEy2WGNy3wCg/GbvH5
	Iz7Bg6XE7IRSgZTnK45YpNkUqOEzRV88EiBziHBO5kWbF4DNU9UWVfoPOPlsCH+m
	0jYR/9EDUgpApOrkv9FvNHOTD3NKC2v5UR2MH84mzv2bAmY84209s33CXYExrVyr
	jThJ/Z+1MBSzWEM2wmiWD8ElzUuQtEnZ0Khf/fjOfgN7Zln4vog/9/QGegsORUAl
	MgwdlW/Z16Zv7Wymkg3GMZDWzpy//k09Z+Nn0/lr7/r6Gqs/yBWxfAUx0FFOQEPk
	T8icl+sYkDc46zP3ZAhyoKNmfb8f1XkNhNgSrstrqCtOJQ==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id u9_yOoYxWl9h; Wed, 19 Feb 2025 20:36:26 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4Yyp856tjqzm1HbX;
	Wed, 19 Feb 2025 20:36:20 +0000 (UTC)
Message-ID: <1194feaa-ea58-42cb-96fd-8bfd348d9589@acm.org>
Date: Wed, 19 Feb 2025 12:36:19 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: Set default runtime/system PM levels
 before ufshcd_hba_init()
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 alim.akhtar@samsung.com, avri.altman@wdc.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 "Bao D . Nguyen" <quic_nguyenb@quicinc.com>
References: <20250219105047.49932-1-manivannan.sadhasivam@linaro.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250219105047.49932-1-manivannan.sadhasivam@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/19/25 2:50 AM, Manivannan Sadhasivam wrote:
> Commit bb9850704c04 ("scsi: ufs: core: Honor runtime/system PM levels if
> set by host controller drivers") introduced the check for setting default
> PM levels only if the levels are uninitialized by the host controller
> drivers. But it missed the fact that the levels could initialized to 0
> (UFS_PM_LVL_0) on purpose by the controller drivers. Even though none of
> the drivers are doing so now, the logic should be fixed irrespectively.
> 
> So set the default levels unconditionally before calling ufshcd_hba_init()
> API which initializes the controller drivers. It ensures that the
> controller drivers could override the default levels if required.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
