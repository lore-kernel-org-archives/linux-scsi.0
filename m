Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5717C7580C
	for <linux-scsi@vger.kernel.org>; Fri, 28 Jun 2024 19:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719603026; cv=none; b=gj/K0QrlhM0Bxoc09hby26vuVCV6pLyRYBr6P3Q7AFUEa/2BS4RevnEa2kBpBZydZhJRnSjCCEXiWOYijVGQIz1BYNhL1/kUIovzs1Yg1lnrkHayLU0oTO+ikwpXNCekwzIJRQ5g/dfw2bmMTYjFq3CqS+sxz3n4wp3GS0hkEeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719603026; c=relaxed/simple;
	bh=I6NgU5jdvwnAuQtG0gcZRAuexE0WmkbG0PxoRIE+nxM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jpEQHVjV0A3e+wOao7I7NVLeWA4xLou7zW+nOgr4o5yzeCupdwIHrP2dhPjkn8WCMtC4+kwg0OFTENNtZog0NsyUbO+Hr8VJGfPvnedcuxCHqb7MIRfJcdGydJzI8oaDK2jLf3HtrLXmX9HqeQOfXoKqKyYCyrjP2/YlpJMpOOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=O3u44wXU; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="O3u44wXU"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4W9lrw6JkszlnPbn;
	Fri, 28 Jun 2024 19:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1719603023; x=1722195024; bh=I6NgU5jdvwnAuQtG0gcZRAue
	xE0WmkbG0PxoRIE+nxM=; b=O3u44wXU136Kod6AJs+BT3cglys5yFb/v0Bq3b+L
	ljg9jYrOfdaY0aN3X7OYR0DmuYhjFF9BMQXu/yY30S+Sqqh+Su3ry/sVIR1ilyuM
	czrUDetucky4bQtKF/7Lgea8672djuJO0TY4XS7TXSc1x4fmTVw4HI46aehLTPlA
	56dxu7F7Zbcgh+cb1CTHAfBxsmqI67LqHYdVsJLYOu47j/2Xic+gmk5WQ/4ppaTK
	4VIo0J2hY9qmDqNkNh9rIps/JCUfwl4utZYlgLB/j/wxV3Uxn/R/xy2ojVTi/SSo
	PYHjfK6WLnebT3JQWyc4+VrpZDIQNMU28f36wHLDDBUQ1A==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id a9QrkGyXs6xS; Fri, 28 Jun 2024 19:30:23 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4W9lrs6Q4DzlnPbx;
	Fri, 28 Jun 2024 19:30:21 +0000 (UTC)
Message-ID: <adbf2b00-541c-4ab8-9b13-7ad70a6353c9@acm.org>
Date: Fri, 28 Jun 2024 12:30:20 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ufs: core: Remove scsi host only if added
To: k831.kim@samsung.com,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 Minwoo Im <minwoo.im@samsung.com>
References: <2004249a-7130-42ab-8264-78f9c418bef3@acm.org>
 <20240627085104epcms2p5897a3870ea5c6416aa44f94df6c543d7@epcms2p5>
 <CGME20240627085104epcms2p5897a3870ea5c6416aa44f94df6c543d7@epcms2p7>
 <20240628021836epcms2p71dd5b348d5a386635d99fb342fe9cb04@epcms2p7>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240628021836epcms2p71dd5b348d5a386635d99fb342fe9cb04@epcms2p7>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/27/24 7:18 PM, Kyoungrul Kim wrote:
> Yes, scsi_add_host has been moved the async function (ufshcd_device_init)as MCQ patch applied.
> So the ufshcd driver attaches the device without knowing whether the probe fails or not.
> and if host tries to remove ufshcd driver, it makes kernel panic.
> So it became necessary to check whether to add a host or not.

There are two scsi_add_host() calls in the UFS driver and this patch
only adds one "hba->scsi_host_added = true" assignment. Shouldn't this
patch add two such assignments?

Thanks,

Bart.
