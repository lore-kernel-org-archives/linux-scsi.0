Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152D530C629;
	Fri, 24 Jul 2026 14:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784902788; cv=none; b=lYfl/cj76W6kv3Gl1CY+rSjLTGC53E8qiuYexaTd/wFd8cMvtciDfusi0oyF2luhz/RXXYVPCv4ItHEpx9NXW2gHEdYm66vI9zpSNQJNXN6T0ZlvS+JzoPFuKgeoTl32FvepUjdUDaZQu6zClRPVWU5ZdwAJb3V8PgJ78ddMZPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784902788; c=relaxed/simple;
	bh=oDE76LGcD44mptApTkiR+wHZmqDZpUxirwCkPpM6/0E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UmVywJowq72h3iD0hk194VLuInNO0hGbJJJkXlk/xo0R3JJR0FYzdFi5nFokIIdwpfEFc/s4RdX5A9UpwKi835o7aoerhc4YHtgoliFMppjYqxm3SN+3/5ACXy9irHYE9KBFDcFJC7MBbqhSZugyo3DNKiUx3JDftTvYSIFlpCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=GgSuLgsz; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="GgSuLgsz"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4h699Z3hpFzlfq9t;
	Fri, 24 Jul 2026 14:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1784902782; x=1787494783; bh=oDE76LGcD44mptApTkiR+wHZ
	mqDZpUxirwCkPpM6/0E=; b=GgSuLgsz0wFaOU2Zmd/4CQSzTH2MKS5y+mwQ14UX
	op8882Ya6XojlwSzt9RUgLnqCsK1cPWAqonbRPppS9C4fdOx0bxbRV/rQ2UwUzjs
	aAxP3lI+6qNSWP6Ho1UdCmQ0I0AHq/dxvmk2n7jAtFc6wyjJVEIEGK6Y7VuHBbir
	hB2OVdWc9k7VA8pEDn1B+EiWPGFzOIgxP2BHArYpkcS5hTPRsuHhV9r3w/8V2pPr
	+467+bHvUuEAe8+TM2PAq0TBIbY/PTTt9skN1MsFspddwqzNNRFq+vpKqwH5w7tc
	MF3/UqfX5u2SzrH9NR1xmPgwk9GVwkl34koFNbePMjag3w==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id a_4a_GbfdtpO; Fri, 24 Jul 2026 14:19:42 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4h699Q3s7xzlfq9R;
	Fri, 24 Jul 2026 14:19:38 +0000 (UTC)
Message-ID: <a1d56354-a556-4e47-875e-e6a079fd4938@acm.org>
Date: Fri, 24 Jul 2026 07:19:34 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "scsi: ufs: core: Remove unnecessary block I/O
 quiesce for clock scaling"
To: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
 alim.akhtar@samsung.com, avri.altman@sandisk.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 Shawn Guo <shengchao.guo@oss.qualcomm.com>
References: <20260723124733.341789-1-manivannan.sadhasivam@oss.qualcomm.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260723124733.341789-1-manivannan.sadhasivam@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/23/26 5:47 AM, Manivannan Sadhasivam wrote:
> Reported-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>
> Closes: https://lore.kernel.org/linux-scsi/al8YkXydXJQZrl_Y@QCOM-aGQu4IUr3Y
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Has it been considered to add a Fixes: tag to guarantee that this patch
gets backported to stable kernels?

Thanks,

Bart.
