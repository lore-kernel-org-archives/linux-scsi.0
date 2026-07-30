Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D992D0C63;
	Thu, 30 Jul 2026 18:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785436388; cv=none; b=NT68UvY02lxkhm1lghifwD76YU23OQ3m7Hxqx8R6ofCe9micyl1BWHdQ5+3u2jgSBowsl0I6mAxAYExIYhBmNb00Djjei1LE7zVH/dWpfOM9dAVY+8yap2fBubxXJyOeAgh5HntrSWg8myQJyBOZNa6g4br3FnflyPy3d+I8Xmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785436388; c=relaxed/simple;
	bh=JRBSz+j7NV+icGpYud0NxAkSUZalOJxOw0Z/TmS6xko=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cY8F5PdgXNdn2CDDvBAc8LsUv8NWRnSAInUYQNMaFYtjNzZws1YiR/t4wsUdDhCY+ccXQv6pmqqB7tUb80paGKlIHXL2D5Pn4NHLjgyv1C6NuCfy5dA0BWrWaddCdtqr4Az+zsylsFPxpGSwqmn7BHux+amnYrRlXtfxU+gq2X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=qlMkCcMc; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="qlMkCcMc"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4h9yW63kJNz1XM30k;
	Thu, 30 Jul 2026 18:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1785436383; x=1788028384; bh=JRBSz+j7NV+icGpYud0NxAkS
	UZalOJxOw0Z/TmS6xko=; b=qlMkCcMcwyAIYIWlzNVJJkwf7XDtC8bIz2EkR4IJ
	Obf3r34pOIZzevf/cb75fhkJb8BfawmA9emEmiLLhY/m/p9dljVu+Upmy6wfyEwx
	p9Kvez0qnkapxcBuSDxlE7IH2awJVSlpsHoyfyxSAYZvslQrE6aOtETZE1KT9Wlq
	h9M890HoUb04wZNOdg29hjfIdAmownm8or7pGY2aV5RDPr/VAK82B6V9sl4VNU/a
	eBYr8VTg7e7lKsHPrU7ERy/S+a9yDRFI3DkzUhWInKhqCgHhetdLSARlKK3SpdRU
	1r23rOm7hRYU/O3B5fsmrPuLusAwzZCW2T4TEkD4oazlGA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id iRHa5HedVWMX; Thu, 30 Jul 2026 18:33:03 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4h9yW11fNdz1XM4TB;
	Thu, 30 Jul 2026 18:33:00 +0000 (UTC)
Message-ID: <15019e27-c759-4e31-a722-505e55016015@acm.org>
Date: Thu, 30 Jul 2026 11:33:00 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: core: pair EH runtime PM get and put
To: Hongjie Fang <hongjiefang@asrmicro.com>,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 avri.altman@wdc.com, stern@rowland.harvard.edu, peter.wang@mediatek.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260729111614.2407559-1-hongjiefang@asrmicro.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260729111614.2407559-1-hongjiefang@asrmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/29/26 4:16 AM, Hongjie Fang wrote:
> Fix this by making eh_noresume a regular bool so it can be accessed with
> READ_ONCE() and WRITE_ONCE(). Snapshot it once per EH iteration and use
> that snapshot for both runtime PM get and put decisions.
Reviewed-by: Bart Van Assche <bvanassche@acm.org>

