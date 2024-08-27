Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602901A0711
	for <linux-scsi@vger.kernel.org>; Tue, 27 Aug 2024 15:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724774129; cv=none; b=h+tZ4GRIjouqujQA/Go14iwB6kbWzbmwAXfK4AKV9pOtwdFASSKin1vlAZtJsrlyXzZAYx+0GNBoLHd5MvjSrRxB8RSviQluEJlyVbfaLi+gxKtqIUxuxN2G4XzeP0v2YbwsKI3ejUvHhATjEGyd0cRT7LrjRmsbZFx8vwy1ntU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724774129; c=relaxed/simple;
	bh=cyuNYYnVGusznZUHlWytb3IRr0Do1J7AXsF8KUsi2tw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Th0KXBrXgetRQf1q6EdvQv0MrxSW15pluy6UuHDmmvVepYCezvAzdx2QG+FdvB0JbcKA1ol81CLqziXIkUmzvxIDgBTAsxGR8Ti/izPXjbHn0P0OSRI8CuoaFsUcE5U+mfLIduVODeEXKqpJQQhMKzX10qwkECDziTD7rnWM+fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=DeXcA7kc; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="DeXcA7kc"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WtXFC57zhzlgVnY;
	Tue, 27 Aug 2024 15:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1724774121; x=1727366122; bh=z/zE4MH8MBPQdqBJOSv2ZbjB
	aJHehVZWIi7B/Klxpak=; b=DeXcA7kcD6cvQ1snzCipgyJ55Ws3L6MghCCGcp6o
	dcTQtvA8rWFf1uc1J7YMde9Cq+BaMILbm50JMFD0SCIPjoHdGMfiPAjD0hNc2eSh
	FV75BB7x4PtEeMwzDEooKzN7i4Qwe2ZxetQIt/NT7soMwwomA3p/YSVpn2j9CdGI
	tZqByQaoJDx5rQxtzj394rlynKF6+2XrCfsNzQsZeqEW0Y4H3fBe0JoMhopxNTyY
	XC+6WIQPiLeEZWmzdqbbWCO9ksUbL4GR8X6OfczF2WskOcz8/lajo+bV9eiqju3X
	35DpNX8oOzZg6lcYf4/U5PfD/UxeAhyz8pwO9urqDMQWkA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id LWJVzysLiIuy; Tue, 27 Aug 2024 15:55:21 +0000 (UTC)
Received: from [172.16.58.82] (modemcable170.180-37-24.static.videotron.ca [24.37.180.170])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WtXF012mXzlgVnW;
	Tue, 27 Aug 2024 15:55:15 +0000 (UTC)
Message-ID: <6bf76097-bcd7-4021-936f-9ea3d6e2f4b0@acm.org>
Date: Tue, 27 Aug 2024 11:55:14 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] ufs: core: force reset after mcq abort all
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com,
 jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com, powen.kao@mediatek.com,
 qilin.tan@mediatek.com, lin.gui@mediatek.com, tun-yu.yu@mediatek.com,
 eddie.huang@mediatek.com, naomi.chu@mediatek.com, chu.stanley@gmail.com
References: <20240826034509.17677-1-peter.wang@mediatek.com>
 <20240826034509.17677-3-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240826034509.17677-3-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/25/24 8:45 PM, peter.wang@mediatek.com wrote:
> From: Peter Wang <peter.wang@mediatek.com>
> 
> In mcq mode gerneal case, cq (head/tail) pointer is same as

Please capitalize "MCQ" and please fix the spelling of "general".

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 4bcd4e5b62bd..d9ef8f0279da 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -6519,6 +6519,8 @@ static bool ufshcd_abort_all(struct ufs_hba *hba)
>   	/* Complete the requests that are cleared by s/w */
>   	ufshcd_complete_requests(hba, false);
>   
> +	if (is_mcq_enabled(hba))
> +		return true;
>   	return ret != 0;
>   }

Please add a comment above the new if-test that explains why that code
is present otherwise it will be hard to understand why that statement
has been introduced.

Thanks,

Bart.

