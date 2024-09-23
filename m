Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F0A15D1;
	Mon, 23 Sep 2024 17:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727112712; cv=none; b=NfbO3MJbGAci3Af8RUrTanSRlGKzMJ3QfDE0ieD7QLbZN+/gwp1Pxo7516jKe2Y9io20lsaMJn0yZS1MHRI8n23o2TtOI7HLjlQSAJXEIORCtknu4wuQw6ZlOF94DH5TfuQFyAu01A3RJkp76lyaD1JfaxsGCTBMEMvUbRyQ/jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727112712; c=relaxed/simple;
	bh=40rs9ZJYvUrK7g9KIL5niqwlLMK8H1EN1ciEegYswQk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ob+sEn/KIJMvrrh4sMdP0xu5U5GFfYsl3TPJPvcy79rXLU3pztOdv5efNGtV4Wm4XFEb7SECNdxXlP899Xw3wKA5QDOjHZf8ubdHv8Cv4KNT2X1N54GH0IQi47yy+BNEF50d7N/b2ltr/husNTS7FQFSqog2YJzdixxMjQTWzGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=23BeIyal; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="23BeIyal"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XC95r3WX2z6ClY9d;
	Mon, 23 Sep 2024 17:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1727112699; x=1729704700; bh=40rs9ZJYvUrK7g9KIL5niqwl
	LMK8H1EN1ciEegYswQk=; b=23BeIyalq1fR/PvyX95ggjGDsAdQjaxCjrdU8d1h
	qrrEl2uFIhAxwIA8pL+2eWFloktyI9ZtjcE/1d/PefNYD+T6VgxbKSAIEVgJHqp5
	f2xq0Bd/5wush+iZCjCvoJ/wMP8jR+cZFDoX8FD+kyJYKPOiTAA5dBKeblQcMZHu
	8ngi9XQvoS8kkPxyuRB418JloYe5wprpDECWhkoAe6eDJy7yCh+wnCNSxFfNZbjx
	Yv0S4VyN+ns3sOVWMcdr/lV0sJfBeL0m+SDNYApj8openSmiteuoI/jclvRpMQNK
	Iy67fUv0seEFkcsT7Kzyew+CjAxznbMRyRToBDQG+GZZNw==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 8YFiwgf2yGLY; Mon, 23 Sep 2024 17:31:39 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XC95g5fgbz6ClY9c;
	Mon, 23 Sep 2024 17:31:35 +0000 (UTC)
Message-ID: <a6cf0ed9-5a0d-4b63-96cf-8ac9da1cbbdd@acm.org>
Date: Mon, 23 Sep 2024 10:31:33 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/1] ufs: core: set SDEV_OFFLINE when ufs shutdown.
To: Seunghwan Baek <sh8267.baek@samsung.com>, linux-kernel@vger.kernel.org,
 linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
 James.Bottomley@HansenPartnership.com, avri.altman@wdc.com,
 alim.akhtar@samsung.com
Cc: grant.jung@samsung.com, jt77.jang@samsung.com, junwoo80.lee@samsung.com,
 dh0421.hwang@samsung.com, jangsub.yi@samsung.com, sh043.lee@samsung.com,
 cw9316.lee@samsung.com, wkon.kim@samsung.com, stable@vger.kernel.org
References: <20240829093913.6282-1-sh8267.baek@samsung.com>
 <CGME20240829093921epcas1p35d28696b0f79e2ae39d8e3690f088e64@epcas1p3.samsung.com>
 <20240829093913.6282-2-sh8267.baek@samsung.com>
 <015101db0d8d$daacd030$90067090$@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <015101db0d8d$daacd030$90067090$@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/23/24 12:54 AM, Seunghwan Baek wrote:
> Could you please review this patch? It's been almost a month.
> If you have any opinions about this patch, share and comment it.

Thanks for the reminder. I'm not sure why this patch got overlooked but
I will take a look.

Bart.

