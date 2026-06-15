Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C803F1AA8;
	Mon, 15 Jun 2026 13:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781530897; cv=none; b=V8HV0XoSW3rTZj18eWydOqiBpzxWRE1fxHIyOBsDc0iNfqxQLAHUKYH4hfD+IyNIyo8qLhyv75G0wTM3K3Y1P/6vCMT4qAJJkdPUYEwu8wGY97WQ0oZ1yWsv8tl8CHJkB/FYYsQMFD5WNlhebTaW5uCtgnECJimT9e470lyT9zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781530897; c=relaxed/simple;
	bh=rGTGw5saMfWpogiLdHb3L8tLLsKOpgLzFfOmMVVS1Sw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WZDNinlmOpq3+jt6HHW5brJCGKW6j9F5dW+Pb8kDxQSWukIAhq2p+v3Gw366kUauNyMum6N43u46qfa5objSGQn0b74mUgxAjYr5dNs5UJtTY/f3A13A2DSKZQ+U+sqAT1tDEoOV5kuRoDV1Mo9XPAHIl4IerHSf9waLcJbFh6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=EXbibQZN; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="EXbibQZN"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4gfB9Q02Lfz1XM6J5;
	Mon, 15 Jun 2026 13:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1781530882; x=1784122883; bh=/JFdcv43vw4EPbj2pYJuXY1Y
	O+uQmOnZRhQpYncm8gw=; b=EXbibQZNF4hEuQlmCeXwJOs2bhoV87jci/OzDfxH
	zD7i6mpQjepum+hLG6tVbQO83m7U0yYkSpSkDTuekvd5DZEVkxphx7daMUtjSK+1
	mtEYY2+3uLJ1aenJ7OL8sZEP96UqQMfvA6kfaZOgF8I/6VjZURAr1YMjwzZutYAj
	E3wAok4+XrH5QSJ/Ee5PoTmEg8O1x1FsSEUjTp4+TMwUxVYG3Z0xhFZoKRHf+wgf
	CVedIOgcnJKPCYJ5RzFQNWgDuEqlDCK6sukqeKt8Dr7AP6ayjzjTxqFWp+sXIMuZ
	WfMYXN7L/GdBdzAzLFr1+Dc+zCRaIX3AY9U8SFktJEllag==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id dnAFi-96rd81; Mon, 15 Jun 2026 13:41:22 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4gfB982DHJz1XM5kW;
	Mon, 15 Jun 2026 13:41:15 +0000 (UTC)
Message-ID: <88ccf330-28b9-4101-9f5f-c05130c75636@acm.org>
Date: Mon, 15 Jun 2026 06:41:14 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] ufs: core: Add get_hba_nortt callback for
 vendor-specific RTT capability
To: ed.tsai@mediatek.com, alim.akhtar@samsung.com, avri.altman@wdc.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org, wsd_upstream@mediatek.com,
 peter.wang@mediatek.com, alice.chao@mediatek.com, naomi.chu@mediatek.com,
 chun-hung.wu@mediatek.com
References: <20260615055802.105479-1-ed.tsai@mediatek.com>
 <20260615055802.105479-2-ed.tsai@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260615055802.105479-2-ed.tsai@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/14/26 10:57 PM, ed.tsai@mediatek.com wrote:
> The number of outstanding RTTs read from host controller capability
> register is problematic on some platforms. Add a new vendor callback
> get_hba_nortt() to allow platform vendors to override the default RTT
> capability value with platform-specific handling.
> 
> This patch keeps max_num_rtt field for bisectability and will be removed
> in a later patch once all platforms are migrated.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
