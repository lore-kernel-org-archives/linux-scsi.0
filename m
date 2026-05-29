Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A50386C25;
	Fri, 29 May 2026 17:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780076127; cv=none; b=XPa+ppzddPnzYX9w8eg/i4pHk4Au8P3Lp/kcjjtqYFBDHV7MNWLtQoDcMV8ZhTAoYdr6EM0Ku0/KqkvaJi83PCSGix14JpjgYFCNyByucJ5sfBZBIEiYMgJWGRdr4cgZUWMxPFqRasXBh97VcSTzMc6ZTZIQdgJYbg2owQbyK2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780076127; c=relaxed/simple;
	bh=buTOsQ/GYEYv94HHmm0EnS5yZSzYHzuAWTu1hZC/I+E=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=VbStGczBkXeE/u0rlmmmVAHbqh5EP3NkqRmoRByITjmyB4TXogGCj8q619PLUYr4DmkMaY3TMzWahlhvibZRrhX9nJoFUy+RXuk+pMiA6JFwE2cg+oS8NvSvSUuI95rAe9PEloZO49zUGXsyFf2rKmaoFQNB1XWgIvQgg54HyUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=oL2HhRRr; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="oL2HhRRr"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4gRr9315wVz1XM6Jm;
	Fri, 29 May 2026 17:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1780076114; x=1782668115; bh=buTOsQ/GYEYv94HHmm0EnS5y
	ZSzYHzuAWTu1hZC/I+E=; b=oL2HhRRrOBQz6f1S862vX3lO8Bwu9Ol6bv19bHG5
	RAhEzXygN8h6jAQSgRvR+18dBmdQJB9TSX4WbF+9SJfdhAoMNAZHeNZStLNGpWig
	S73Uxw+U74gaE+DkpqKdY3s2pSh9YJZ3lRi4fxmaoPNYm5/3p/9PmYhXVlxGo2kR
	RT7JiEhs0/WVRTQ9gXENcYRO0W2cByDXj9jw8oysvG5wNNPsQdWxEff9gmimAWCk
	iiAfXtpR8LBp0nON2ycNYJpQViy6BMW3EeOuiotABIDfQiDU5d23d9W2InGJ1KaM
	myKb1eZ7yMujukRcKK7mtsqgh9eL2s7TKPegKEoNZxTw8A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id cAfnU9gEaM50; Fri, 29 May 2026 17:35:14 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4gRr8s2Nbtz1XM6JV;
	Fri, 29 May 2026 17:35:08 +0000 (UTC)
Message-ID: <02a8450c-1371-419b-88c2-421f3472ab7d@acm.org>
Date: Fri, 29 May 2026 10:35:08 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: Remove unnecessary return in void vops
 wrappers
To: Chanwoo Lee <cw9316.lee@samsung.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Peter Wang <peter.wang@mediatek.com>, Bean Huo <beanhuo@micron.com>,
 Can Guo <can.guo@oss.qualcomm.com>,
 "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
 vamshi gajjela <vamshigajjela@google.com>,
 "open list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER"
 <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
References: <CGME20260529061506epcas1p298f7ccf8e65e713c3cc2b8fc07549dbf@epcas1p2.samsung.com>
 <20260529061503.301182-1-cw9316.lee@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260529061503.301182-1-cw9316.lee@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/28/26 11:15 PM, Chanwoo Lee wrote:
> ufshcd_vops_exit(), ufshcd_vops_setup_task_mgmt(), and
> ufshcd_vops_hibern8_notify() use 'return hba->vops->xxx()'
> while other void vops wrappers call without return.
> Remove the unnecessary return keywords for consistency.
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
