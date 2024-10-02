Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E82A116419;
	Wed,  2 Oct 2024 23:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727911557; cv=none; b=r+Hx5S3NT07ZuwUedaplygrZaJb3M+PXNxJlfaQe7wmhS7CZtYWHtZ1yw8MrTZT0owBUAJrFV0M6ZDq+r3pt0Qy6uooJFaUh3MlcxEDLJEKn9Mf6MKlKLEcjr2Frkiu1k7AOn1OrMMEFsOhGOQP37XDKG085D/PqiCOE9XNIStg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727911557; c=relaxed/simple;
	bh=Spgh0nrvjjAlwuzc8l05vKO2JLa4EIPhGSkSkf66ZEg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=swcqy64iQ1eV+shlcsnsouHmdpji6NQOetYs/mAaIVUFPE4GUmuAuEJunxSfhDNR26wdmCC7zUeaWIapfwJHLJN1A8OtjiDMuiqVn2ynpUO0lrIrdFJNZEQ/BzNxkQwEFqVDMBL+3TI775gZw4ree0ogInleXdwXtf0H0ofQhMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Xk/32Lhr; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Xk/32Lhr"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XJrXM2YNvzlgMWH;
	Wed,  2 Oct 2024 23:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1727911553; x=1730503554; bh=Spgh0nrvjjAlwuzc8l05vKO2
	JLa4EIPhGSkSkf66ZEg=; b=Xk/32LhrMafzx4wEd6bL9Nek2GCkhJ82TDGIkB6s
	asPXGSac2WbcB2sM7S6veNavVk7k0hktsgryCLVZYnknZkFb1gPmzjRJFnFd5EGc
	aN1NUTqzdXhCT3ZXvHlbWT3z1/r900+rxNg5CPgKQ/JD4fnFn/76YYByrOGPSKI9
	ewoFABSVsEEs7DtVk7+aXZMBo7YRr110tapnc7w07JQtITXv58aguh/YFaFc7EUI
	ibTkZUwE/wnFUpMWxFMDs0D1s/zRNC4rww2XJx9Ia1mJ/MWMDGWyXOqAnO2nJV72
	Dfl+Wbw44fbuHV9u9c4RI52xhZVY/mV79TxUcdQAprOIWw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id o5LB0KC6MTNg; Wed,  2 Oct 2024 23:25:53 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XJrXG5WdHzlgMWG;
	Wed,  2 Oct 2024 23:25:50 +0000 (UTC)
Message-ID: <c667633b-98a4-444d-8e5d-65a5b1446985@acm.org>
Date: Wed, 2 Oct 2024 16:25:46 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: ufs: Use pre-calculated offsets in
 ufshcd_init_lrb
To: Avri Altman <Avri.Altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>,
 Alim Akhtar <alim.akhtar@samsung.com>, Daejun Park <daejun7.park@samsung.com>
References: <20240910044543.3812642-1-avri.altman@wdc.com>
 <5c15b6c8-b47b-40fc-ba05-e71ef6681ad2@acm.org>
 <DM6PR04MB657594C85E06F458EEEDB7C0FC6D2@DM6PR04MB6575.namprd04.prod.outlook.com>
 <DM6PR04MB6575B4ADD2F9E4A9DC80C81EFC772@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB6575B4ADD2F9E4A9DC80C81EFC772@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/1/24 12:19 AM, Avri Altman wrote:
> Bart - How do you want to proceed with this fix?

As one can see here [1], if this patch is applied on top of the
android-mainline kernel branch (close to v6.12-rc1) then all presubmit
tests pass. This includes booting the kernel on a Pixel 6 device that
has an Exynos UFS host controller. So I'm fine with this patch.

[1] https://android-review.googlesource.com/c/kernel/common/+/3291741

Thanks,

Bart.

