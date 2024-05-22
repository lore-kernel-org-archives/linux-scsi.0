Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB91339A8;
	Wed, 22 May 2024 18:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716401802; cv=none; b=bhZydTEMKS1eXFkpp4B3ZNSer6dFPgY+MgXtTamLdoo+rR96RWFzYwXFkE8jvHGs7zPWPurov6WgRPkqHdq/BP4W7tQ88mpVdqzlDqSvLKOU+6E4d6zyYy+eo+lU10RWJ2rYkp+F/RgPyr8vshhTbhOW52eKomcgExMky5YuEGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716401802; c=relaxed/simple;
	bh=pQlgvb9gWd8FmwqYj3EHCmBUlJXpivY4XTpWhjchJhc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QtHQbOKDgrrFPm0j/GhMGCPU+0KVxe8D3RQXxAPaAIapXtVPvSFDl+80F3+t4dBCCOF0xZZbcAnZRtUZGlQK0lKhSotO6Y0BFMuGNXkQ1ISky1DpI2jEbKGMlKPljAo7aLQi692AdAtlhvFE0z2OI8P6L/NDE32j1fvD/UlRz2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=y4z5gE2W; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="y4z5gE2W"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Vkzyw4GZjz6Cnk9W;
	Wed, 22 May 2024 18:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1716401796; x=1718993797; bh=pQlgvb9gWd8FmwqYj3EHCmBU
	lJXpivY4XTpWhjchJhc=; b=y4z5gE2WULgYmIX45LtUok34w3S4d968pcAU/g+L
	04B2eFLYMCRpqQAzA6jKwYmB3sCrxd/vS/1oILTGXe9oP3ig5ZRCu9pzNYk/A20g
	+G/JFzQoQ0F/OvtYDrQ+24eDb/Pe0WqYaMsRsptLR/VfrICtztFy5UHddjf35lK0
	iot+UOqtXgT/YqTOnbQ4lbFoY2571qTCyMWp6s5jTgN8fVYLS4AgJiw2nIo3MULI
	jU8iTMNkAsIUJBNrUhGyonwxXPFNDQUK+XmX8dwM5vdlhZn0DVkG9G1mdEerCNPR
	n62DAxveLtDW948gqNc7+w5J6kiBB+rhnMtRaAWZYdJe1g==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id bkN4BwfnFSdQ; Wed, 22 May 2024 18:16:36 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Vkzyp3pYWz6Cnk8s;
	Wed, 22 May 2024 18:16:34 +0000 (UTC)
Message-ID: <cb05bc3f-5fb0-45aa-961b-bb9edc007407@acm.org>
Date: Wed, 22 May 2024 11:16:33 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/2] scsi: ufs: core: Support Updating UIC Command
 Timeout
To: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, quic_cang@quicinc.com,
 quic_nitirawa@quicinc.com, avri.altman@wdc.com, beanhuo@micron.com,
 adrian.hunter@intel.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>,
 Stanley Chu <stanley.chu@mediatek.com>, Peter Wang
 <peter.wang@mediatek.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Po-Wen Kao <powen.kao@mediatek.com>,
 Maramaina Naresh <quic_mnaresh@quicinc.com>,
 open list <linux-kernel@vger.kernel.org>
References: <cover.1716359578.git.quic_nguyenb@quicinc.com>
 <292d7702e946ca513af51236ca9e38bf1b1eb269.1716359578.git.quic_nguyenb@quicinc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <292d7702e946ca513af51236ca9e38bf1b1eb269.1716359578.git.quic_nguyenb@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/22/24 00:01, Bao D. Nguyen wrote:
> interrupt starvations happen occasionally because the uart may
> print long debug messages from different modules in the system.

I think that's a bug in the UART driver that should be fixed in the
UART driver.

Thanks,

Bart.
