Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185811DA4C
	for <linux-scsi@vger.kernel.org>; Fri, 29 Mar 2024 18:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711736816; cv=none; b=CoMWWPgZEFVo0xmDqurOrdP/KeQJiguPeoVFiJPOq6dkXNTSulHhRtiPspUX7FRYNn55VmcOFu0cPQroS7Q0JIH/fJ9hMqkR8CZqoUqYF+UtzdvBp+5PXAarFT0JyVkR5DpUI0YwLLt/EZedAF4mH3/RPTndiM/BzuCyQYMjIpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711736816; c=relaxed/simple;
	bh=hcm3DmQ2iHw+PviwOCf9Ftc6RGJJ9+JQbwpOGmGLRmY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WXtSg9VjHMnIz3IiOBCWzAqj0gEopDyiJ1GiIN3kLlbhXsQzosPwFmTBivZaCa1bRcZflIAi2WAwg47xvvGC0n6FkdocnHGimxkt24XSpG9aualkyoseL8/W13Wiyy2h2FX973Lgqj55rhy44oAlTF6nxeMNUCgFGtacdKgmnrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=kgsCxlYN; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="kgsCxlYN"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4V5plf3fg3z6Cnk8t;
	Fri, 29 Mar 2024 18:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1711736808; x=1714328809; bh=hcm3DmQ2iHw+PviwOCf9Ftc6
	RGJJ9+JQbwpOGmGLRmY=; b=kgsCxlYNwKs2PPDeq6Ne5gyXzJcXO60aFH2NTYBP
	/3GyzAN1+kVOj+zGw9x59eq5H3ae+jB8/1WC9NZ98YNsLcWSuJ2RhU1IJFzre15K
	pn54eEr7JeMworiUnto/GQlYU1yy9h0e0dQAZ3vS+j0iy7EAKutYCAlXd3AdUKwS
	s7T5P0iIad7xL3eOLZ6B8xeI1+mYLN4gJDpdfebxerBSIdgLh6wXFqDDGvPNlzFe
	YUFqnEuCeoWjmYEkW63KMtfANmYA3+sB7YzxR6LVH7HsJkuKGCr2ngsYcvlimmvk
	O8FW9yjwWnOLhe4j4TAjHSu222LBNl+rzpPq8QSFa9fcFA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id rBxUXmIg8p1M; Fri, 29 Mar 2024 18:26:48 +0000 (UTC)
Received: from [192.168.3.219] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4V5plQ1wJrz6Cnk8m;
	Fri, 29 Mar 2024 18:26:41 +0000 (UTC)
Message-ID: <0e8f3f8f-2a60-4d52-b21f-bf36533e7a7e@acm.org>
Date: Fri, 29 Mar 2024 11:26:40 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ufs: core: wlun suspend dev/link state error recovery
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com,
 jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com, powen.kao@mediatek.com,
 qilin.tan@mediatek.com, lin.gui@mediatek.com, tun-yu.yu@mediatek.com,
 eddie.huang@mediatek.com, naomi.chu@mediatek.com, chu.stanley@gmail.com
References: <20240329015036.15707-1-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240329015036.15707-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/28/24 6:50 PM, peter.wang@mediatek.com wrote:
> When wl suspend error occurs, for example, BKOP or SSU timeout, the host
> triggers an error handler and returns -EBUSY to break the wl suspend process.
> However, it is possible for the runtime PM to enter wl suspend again before
> the error handler has finished, and return -EINVAL because the device is
> in an error state. To address this, ensure that the rumtime PM waits for the
> error handler to finish, or trigger the error handler in such cases,
> because returning -EINVAL can cause the I/O to hang.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

