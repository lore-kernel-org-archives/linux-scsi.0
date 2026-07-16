Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3AE42475F7
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2026 18:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784224980; cv=none; b=Ysn9L+hsOLpaY7iF1YJU88iR6nKigfZgcwcBIBJAWWZ/uB8MZRXCwi8jFSJYZzcayIgVFf29N35GgE5iIWXQ46E6Muly+mywLT/QngxmuMgteKPJw7pV1QVbJGegjs2HUa0XnfgfVCh5hx5FPbj9fgLO1G2+0RVahdWdMgTP4XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784224980; c=relaxed/simple;
	bh=Z8W/U47CIk2DUkP7okDbJb2zdln9zGV3FO/BW93mLhs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PQKjtwbEmYUWyC2kJUWI13CISpEBGmF5X13l0ds5OxXYgcmoMCR4B/mHwnhKPjPwVLntDw3oqyOlB137HsAC9RuSJ3kX7OanxlVbTLd1iVWPKjU9s2VBfmrC8JIdPTfmibfOqwR59igiL1k+/a9Jw0dF78GZNGgfdQLRBbPjdRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=a+gIk9xU; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="a+gIk9xU"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4h1LVq1frlzlffvQ;
	Thu, 16 Jul 2026 18:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1784224977; x=1786816978; bh=Z8W/U47CIk2DUkP7okDbJb2z
	dln9zGV3FO/BW93mLhs=; b=a+gIk9xUbG7Uvex2qGdVH0AVS1GvCrKL9bqZMRRg
	dw74RjqC0KLy5s5+x93y8DHLzgWPE1eikq16gawkMUEOAQC/h+4ND9zMDLrTaogg
	nZjsYVnNltdElANw5M2vNfq/+MbmDJi1UmXN5N0VnvhEr9OC650CJoB7Ixb8rj/O
	Vb1OZ1/nw7JQIrdhR3EJZc8q6W2lo+QQJDkSPzB4DaJgHEkICfDwu36JQqAUx4Hn
	mTEvRR7xF1U6n4rd8UKvZdkeEGvF+N6XZOleGLQJq1RtlIbHWziIaXYWI2rHY1Nx
	bOTSKFq1wPABCOf/j5E4ZrKbzIH6a9k0XUH63GtHklTu2Q==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id a-OhdiZD0qgM; Thu, 16 Jul 2026 18:02:57 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4h1LVn4Rynzlh1VB;
	Thu, 16 Jul 2026 18:02:57 +0000 (UTC)
Message-ID: <b2c5aaa4-babc-4fc8-803a-1c8d75eebe59@acm.org>
Date: Thu, 16 Jul 2026 11:02:56 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: Add support for the aggregated read query
 opcode
To: hyenc.jeong@samsung.com
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <a0d5f2bc-c343-43c5-93c9-a7b58be13242@acm.org>
 <6d087f28-5795-4929-b5d3-3f78d9b9bc60@acm.org>
 <20260710054556epcms2p68986e2af26f42e63c87ab8fde034e450@epcms2p6>
 <20260713025227epcms2p41de509bb713eb7a6be2c945073be6b3a@epcms2p4>
 <CGME20260710053524epcms2p82121eba4240c37112fc5669430035442@epcms2p4>
 <20260716025140epcms2p4f46c9c232d81ac1ffb9c2961ca758fde@epcms2p4>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260716025140epcms2p4f46c9c232d81ac1ffb9c2961ca758fde@epcms2p4>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/15/26 7:51 PM, Hyeoncheol Jeong wrote:
> If the direction sounds reasonable, I'll prepare it as v2.

The above sounds reasonable to me.

Thanks,

Bart.
