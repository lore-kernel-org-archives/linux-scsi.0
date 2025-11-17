Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137FD2DCF74;
	Mon, 17 Nov 2025 16:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763397795; cv=none; b=ZJqmwt7957j+yiQ12t+/oQuCT/63/p18tZ8kE47Z00jP2Rvt9KNg9FZ2ZBY/XZOglhdm71r3ZY3wxZYZwR8zjkdNyVuCkQIkdwLsQR3atodjnyDGJL98eY6O0uX/xC0NOAwpPQdyP6DtQL1MQye4lgwV2QxKEfBRfRgzDtUCTrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763397795; c=relaxed/simple;
	bh=XEfzRxEO7F5zj772Ijr9ijHh1MZrXKox6q8ZD3vmsXY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ViQoEw9wGjJxJaR1xX0yhT0Kc9qrrzUEaF8JMsgV9Z49p3wdqcOaEKks+HHvi/0Go4ZWeenL+k0yVYbHwmFoRxNyfWOyH5hFsXjOV8w0RjQkdL0msdas4Zt+KNsqLc020MiqKkGqS+Ww0CBSlB0yyH+WHgYuqbv79NSUmH1YhVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=A8Y3eats; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="A8Y3eats"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4d9D810nnPzlsxFH;
	Mon, 17 Nov 2025 16:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1763397791; x=1765989792; bh=Er3omgx607TRgCU0FWtwm11N
	lBEh4OTitX48yjxLFN8=; b=A8Y3eatsxUwcG3A/jEJ9PzKS3VRUDPn5OaxZISXb
	wOLsnKnsTl279CbYIBuu0QNKo+liCGG5L3ALtTCq5GRrKs1Q5LBekK45EJsCOkp0
	/VwESssi1GEac+ZeBMwhORy2zeYdfIdkwSlCsBAHrhhQHe31YPUutnAgSICbdJ+n
	YEaZLmQkG3YEoLT6lqvb5MgM+TLnuki0pnJkdNe0omgq1udieYxyDbDJZg4LtzpP
	KNjzeapm/Tr9qm2qPWqA0OuCpAQoLxfrgdSlUAMoEwbW9wNFtNdBUH/ceOTdGEZ9
	3nGm8Ph9QbHkPTRlpDDiYS3auyRXzkYea+NLBFMYMukBMg==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id HTRSbywuD71m; Mon, 17 Nov 2025 16:43:11 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4d9D7s68WCzlnfqS;
	Mon, 17 Nov 2025 16:43:04 +0000 (UTC)
Message-ID: <e3dcb711-990d-4e4e-a128-8a0cd0ce8886@acm.org>
Date: Mon, 17 Nov 2025 08:43:04 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] UFS: Make TM command timeout configurable from host side
To: Seunghui Lee <sh043.lee@samsung.com>,
 =?UTF-8?B?J1BldGVyIFdhbmcgKOeOi+S/oeWPiykn?= <peter.wang@mediatek.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 martin.petersen@oracle.com
References: <CGME20251106012702epcas1p28fdeed020ea44f18dcc751c283fbbcc2@epcas1p2.samsung.com>
 <20251106012654.4094-1-sh043.lee@samsung.com>
 <e98df6a1b10d185358bdadf98cb3a940e5322dcb.camel@mediatek.com>
 <009401dc52e7$5d042cf0$170c86d0$@samsung.com>
 <f3b1641b9e611f2e4cac55e20a6410f9a9a88fa3.camel@mediatek.com>
 <be4dc430-ce62-46a8-bd42-16eb0c23c0a0@acm.org>
 <8d239f26e1011eee49b7c678ba07fd4d9ca81d24.camel@mediatek.com>
 <1bf9f247-8cd7-400e-a5c8-6f3936927dfc@acm.org>
 <b83804a8419f0e8cc1a6263144fbaf1583bab2ed.camel@mediatek.com>
 <000001dc5791$5f2ea880$1d8bf980$@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <000001dc5791$5f2ea880$1d8bf980$@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/16/25 11:11 PM, Seunghui Lee wrote:
>   /* maximum number of retries for a general UIC command  */
>   #define UFS_UIC_COMMAND_RETRIES 3
> @@ -7663,7 +7663,7 @@ int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag)
>          int poll_cnt;
>          u8 resp = 0xF;
>   
> -       for (poll_cnt = 100; poll_cnt; poll_cnt--) {
> +       for (poll_cnt = 30; poll_cnt; poll_cnt--) {
>                  err = ufshcd_issue_tm_cmd(hba, lrbp->lun, lrbp->task_tag,
>                                  UFS_QUERY_TASK, &resp);
>                  if (!err && resp == UPIU_TASK_MANAGEMENT_FUNC_SUCCEEDED) {

There are no other SCSI drivers I know of that have a retry loop around
the code that submits task management functions. I propose to reduce the
retry count in this function from 100 to 1.

Thanks,

Bart.
