Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5EB515D1
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2025 21:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758750886; cv=none; b=cunNRvzfRvvn8/kVkcjfRe3HguwQass9Og8sg9HKyKd5lJ889FZ0GjCfjMd6avU3BAgLUTncLhMQa7OmTAbeW50GDrsxyB7KXmtD0luCQnQWNQLvx/Or1INGP1wAjHfI2qkOuxZJ3FpwRezKCJMO4ie3HAfMazgSkT+rjZBnALM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758750886; c=relaxed/simple;
	bh=cFWbszHu8MBzpN96Sywn313X2hqSg/usWGUMqwcobVc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IJIE9aKIWcAFVkED9Mz4Ta2+bMSuuvayO00Xe+eD2cuvTrsMAANDQ5sBDh8S7yBEb0HeL/6UA4t0YofHmom0fKimF9rXdMI7F+iJMgKSOr9OtJapZsplA6GyQTklsURLW5hkm0yfp5KzWrsrDtSYsMLQ5Q6t9Axyt2CH+a0NQLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=3XNXIU+O; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="3XNXIU+O"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cX9cM6DWCzlgqVP;
	Wed, 24 Sep 2025 21:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1758750880; x=1761342881; bh=cFWbszHu8MBzpN96Sywn313X
	2hqSg/usWGUMqwcobVc=; b=3XNXIU+O8ciCKTZOOrdapdb6aoU/bWLRz1MX/2Xr
	Bhi1H+qae9hXQkexxfbanXXRtXDswI4XQuk3s1NuP9ONh3vk71xQUFZRRe+i/V+C
	zFnunAildHyjSy9tNsj8gh+M2IiyqAHoWdlASPqLq3hJEJbODXNKdIqnMUTnYuh/
	CDpc7EFAcAASWCZj2E/Z4ME6tDRSH3wtKKYtdo7NqgX15M5fgULWNBM34dxl9aPP
	ruD/AR7exe3r/ver/74gLmFppUFyQJBLYAmsZA/bDxB197ko8Ehq7bojjew8IBKp
	wc3/5mIHawcOQR+3yKGtt5ABiBmC90XTNb/YZ/iIXEHmPg==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id MUGoqSbcgXKz; Wed, 24 Sep 2025 21:54:40 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cX9c35Nz6zlgqTv;
	Wed, 24 Sep 2025 21:54:26 +0000 (UTC)
Message-ID: <6f7b6f14-4d9f-4487-ba7f-51cbbeff1f55@acm.org>
Date: Wed, 24 Sep 2025 14:54:25 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ufs: core: Change MCQ interrupt enable flow
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com,
 jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
 yi-fan.peng@mediatek.com, qilin.tan@mediatek.com, lin.gui@mediatek.com,
 tun-yu.yu@mediatek.com, eddie.huang@mediatek.com, naomi.chu@mediatek.com,
 ed.tsai@mediatek.com
References: <20250924091701.2982410-1-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250924091701.2982410-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/24/25 2:16 AM, peter.wang@mediatek.com wrote:
> Move the MCQ interrupt enable process to
> ufshcd_mcq_make_queues_operational to ensure that interrupts
> are set correctly when making queues operational, similar to
> ufshcd_make_hba_operational. This change addresses the issue
> where ufshcd_mcq_make_queues_operational was not fully
> operational due to missing interrupt enablement.

A changelog is missing and I think that the patch description
should say that this change only affects host drivers that call
ufshcd_mcq_make_queues_operational() (MediaTek). Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
