Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF8A25A655
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 16:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783442505; cv=none; b=sRDhU+hgBPZtLzI15CRH0Cta4iqS9Eo9rA4nNRsZ8n9Asmc1xMny6lCQHv3ZHZ1hc5JWoX3G2OmDe3lLUurfqr0l5uGfxAbu3UNUTQZD1m9dxycyvK6FB6sf77cPCpJZ/ELPgWLUa6gr2EOlWYRVI72qk/edn1rnHgwXw0N/rTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783442505; c=relaxed/simple;
	bh=hBIxdwpKX6b0iYcFLLWOGESCEK+hJn9fX1uXUnoatdA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZGyRivuiBDj+x3VZYZyfcxXvB0VvYE2oNcA1PrKD8RtpRV8kaQLrQTxW/hmEVUIK40DhZYwh+ub3zBTgGkFE6TzCaBHJ7D48CTErtuEcGXpW3i8aVlRxvtEA7yIskUOENPFs2ZeElpLcvsD3bUMQ0d8rvzSzeanOLdJf/zEThto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=EeEb4OUg; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="EeEb4OUg"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4gvn763Nxzz1XM6JN;
	Tue,  7 Jul 2026 16:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1783442496; x=1786034497; bh=lgeAsz2Fv4jmxWdZ+UVQ8cym
	UNPH3QB9TNqvFSHwQd8=; b=EeEb4OUgSgFwpAl/929B50PzA1yWfTepm/9OgIcf
	QxSuVcnHpbfPXAIvSreyUojgVPWPvlEP4QjguYUSymnygKCqGwa0yK0Z4C4uE4bX
	wrcHM497yhowzkwNp5w+z/p69zFcymW19OWgw3Htpxu19Lc4Bxltveonke4smFS8
	T2pR9EiB8+RCeIAnWUSKV9QNU2U2Fui94glg2Invm7qfuHiACAsSFQXxJR6+uiBk
	Mzsoud6AlB4g5Jt2mKpKluOjGyFW2NwCP9uD+A4HJB9/kU/HZUC/8CSOK7GvMbUw
	58mu0R03owr9A34EGLx7PQl59U1zd/YXtTATdg2+Ivf+yQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id L9k2Bqgk7Dtq; Tue,  7 Jul 2026 16:41:36 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4gvn735jpdz1XM6JH;
	Tue,  7 Jul 2026 16:41:35 +0000 (UTC)
Message-ID: <20f076dd-636a-49f9-9a02-0046af2db0e2@acm.org>
Date: Tue, 7 Jul 2026 09:41:34 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Undeliverable: Re: [PATCH v2] scsi: ufs: core: Avoid possible
 memory reclaim deadlock in TX EQTR context
To: Manivannan Sadhasivam <mani@kernel.org>,
 Avri Altman <avri.altman@sandisk.com>
Cc: linux-scsi@vger.kernel.org
References: <20260618140941.902000-1-can.guo@oss.qualcomm.com>
 <h5lsilzmxhu3jyujladib3w75nsute7yrkr4t5sg57nwzwb2ek@d4btnbylvrvu>
 <f1960bd5-b583-4104-a343-e217ef7ed63d@SJ0PR04MB7504.namprd04.prod.outlook.com>
 <ucn5winjeqnixycuxldp3wgysrasrah4ie5egs4vo4prvy7e5c@6ef4y2gqqd7x>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ucn5winjeqnixycuxldp3wgysrasrah4ie5egs4vo4prvy7e5c@6ef4y2gqqd7x>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/7/26 9:29 AM, Manivannan Sadhasivam wrote:
> Are you willing to continue your role as UFS reviewer? If so, could you please
> fix your email address to avoid bouncing?
> 
> I can also send a patch for that if you want. Let me know!

Please take a look at upstream commit b65b608eb8ff ("scsi: mailmap:
Update Avri Altman's email address").

Bart.
