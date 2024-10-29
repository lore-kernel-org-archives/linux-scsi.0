Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4544620720B;
	Tue, 29 Oct 2024 19:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730229615; cv=none; b=tl6649ro0Pxx4eySCaC31kkXc0D48zSiOiFXhCoFQk0blHgySga/xmK6Wm7IGKulTQ4mUrtIuHPKS5vJEOQUwyYX++zYJWUJneTA6Dfo3IVbhaQuAMbA9khnhNx3kxabKGpXPcq3biFJokNhT6pgvPmDKyUAqw/rJKHAhCAQKeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730229615; c=relaxed/simple;
	bh=0S3HbNeEMeZLFputLr/SI6bgGIWnryvVavBo/pNfAjo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r6Qo6I8XSPpUwYbH+cFw+ec81Z8WiNENsJzpxjMUHG8loudj9kkR+Ub9qsp+saQZ91oNhXanSenlrMWadXSrbr4NGNG58o1BMw+V2YMCL/lpeGlbFMilX8EBKLAG2gbOH7/jaS3IX/Eea+YdT7qdVA7N0FqOt8ZOyzitGrualiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=UDwgSMze; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="UDwgSMze"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XdKpN4hQNzlgMVd;
	Tue, 29 Oct 2024 19:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1730229611; x=1732821612; bh=0S3HbNeEMeZLFputLr/SI6bg
	GIWnryvVavBo/pNfAjo=; b=UDwgSMze6E9vcloSUl9Se5uzRmcPrTqAegVvikHX
	KXrv+J+iUh8gPF57LSgI5zERXJ++2POQr7CkyUOhlRSsph2UaNNGp+sNYILsgk3l
	KOupgMX0ajOZaUESjvswolvGC7jML/XNSeQ6kMFTZvwUvWdyFimbSK08yqZRMCV9
	Ydu8kyk5rAbxx6jOQT5OrXOFuDdTA24U6RpcHtPfATCqb+qVCfeCHbncE7MhiEpE
	DEDb8FIPBq+Ltyg3x2GvNYTgFv1ASn7mIT9MX4+8FWsCJnitYQC/BqUEiwCSHeMM
	ZDK2lCQ+J/x9jyRBe9MnUy6n0OlY3IeBZzGeTV5Xkufn+g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ou-NNa0Knmxk; Tue, 29 Oct 2024 19:20:11 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XdKpL2tZmzlgMVY;
	Tue, 29 Oct 2024 19:20:09 +0000 (UTC)
Message-ID: <31df356f-9160-43e3-b1b9-bba43da5f0f2@acm.org>
Date: Tue, 29 Oct 2024 12:20:08 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] scsi: ufs: core: Introduce a new clock_gating lock
To: Avri Altman <Avri.Altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20241029102938.685835-1-avri.altman@wdc.com>
 <20241029102938.685835-2-avri.altman@wdc.com>
 <611fc99e-c947-463a-82e1-9d2a68d67aa4@acm.org>
 <BL0PR04MB6564D3BBB11D00067485F5CBFC4B2@BL0PR04MB6564.namprd04.prod.outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <BL0PR04MB6564D3BBB11D00067485F5CBFC4B2@BL0PR04MB6564.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/29/24 11:39 AM, Avri Altman wrote:
> But this is a format change while making functional change.

I think it's common to fix code style issues if code has to be modified
for one reason or another, in this case the indentation level?

Thanks,

Bart.

