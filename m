Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A54E372ED9;
	Thu,  5 Mar 2026 12:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772713261; cv=none; b=A9wAN/FDHO0cKkNspumnwjKOZStV1BotpArtvWj+3KtDeDYVh41NLFd/cQzj3maKIekG1ghMXHNIFDF/IHHASgDrCAYkiqIg4IMsX2UG5EmTjo9q2cLw/wtPfAgTZBuFDi9WEZyD0xUO2P03CLA4trtK/37Jbs/3yf80EvJyjb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772713261; c=relaxed/simple;
	bh=s2g6Qeaj3tkM2kpJNp/B0QXk+CcvvugYMYtG6LI7uFQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ecX48INzfTY+zDEjsCdHg87SSC3Qa+QcOSpt4ybFvuTr7o+qoohoImH67HRHnx+/atgAcQ8//ztGoyR5ZagzexiespQL8MRdiwKap5EnAHb380KtpmMkKn5V/qnAx3m0bNpz+9hwOxLnt3iRWH3CzGk84Po6KBED5ZJPCQlihTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=SZbaEMJQ; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="SZbaEMJQ"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fRTCc0SNFz1XM5kW;
	Thu,  5 Mar 2026 12:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1772713255; x=1775305256; bh=VxlWN5VHxU2836UMOWl//1bZ
	U+D0OzhZKMnKSPhaYT0=; b=SZbaEMJQiSNKvzikXuJEpXYE3IOu9NrxZkkOIQu3
	Z8sRSVIzH4KxGjFNf3F34w+/bJwhaHPTavVGVcjyX2yA6D9XEPwDzGf4Z0jSCT5T
	J9mjFXvogOeF6uzEGdvo1THQ6mjcT3kUSgpxjhny46OfzmPb9kp82CtKc8OLGU+G
	yqYKJe/luExc6OMM6c18dwA8jnt9W+exne8kG3Ht2x0q2Dd9ZrhyhEFnN+DGMdGZ
	mgmZEhnrqVbJgQ1x4XhPA2hsyvFwwtDfqTBengvzCs50dr4II90r4ssu119UxKLl
	PcucoLXwh/PoRob+bSoyOUJrNEQAyyATgWpGvDj2FY10oA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id USyP4OT_KOKZ; Thu,  5 Mar 2026 12:20:55 +0000 (UTC)
Received: from [192.168.132.187] (unknown [12.150.89.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fRTCR58TDz1XM5kD;
	Thu,  5 Mar 2026 12:20:51 +0000 (UTC)
Message-ID: <f298d3f3-1382-478d-87f2-ae9b212001da@acm.org>
Date: Thu, 5 Mar 2026 06:20:49 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] ufs: host: mediatek: Add VCC on delay for stability
To: ed.tsai@mediatek.com, Peter Wang <peter.wang@mediatek.com>,
 Chaotian Jing <chaotian.jing@mediatek.com>,
 Stanley Jhu <chu.stanley@gmail.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: linux-scsi@vger.kernel.org, linux-mediatek@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <20260305083610.2672344-1-ed.tsai@mediatek.com>
 <20260305083610.2672344-3-ed.tsai@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260305083610.2672344-3-ed.tsai@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/5/26 2:29 AM, ed.tsai@mediatek.com wrote:
> Introduced a delay after enabling UFS5 VCC for MT6995 to ensure
> voltage stability before refclk activation.

Patch descriptions should use the imperative mood (Introduced ->
Introduce).

> +	/*
> +	 * Add a delay after enable UFS5 VCC to ensure the voltage is
> +	 * stable before the refclk enable.
> +	 */

after enable -> after enabling
refclk enable -> refclk is enabled

Otherwise this patch looks good to me.

Thanks,

Bart.
