Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC5A10E9
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2024 18:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724695561; cv=none; b=Hy9xW4QrdmMQ+Xp1a6z4htpXvW7rWa2yMN5UAsg6vMgQ0WlKDQLmaKEbrf9hIiz/C8n3FU/otaXtESIBfq422L+zsJWPGVzSfPKilVahaAF2/wMpNS7zbTw+9enCuCQSnGxags1UgspDylpsvxxdd/ka6hT8RGs4pJIXrodAsnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724695561; c=relaxed/simple;
	bh=tBE1R9Ug8xlXzfm5VwVI4PjUuyZq8G9eo/PwJWmzBcI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lyvbaXKNTz86BMsqMTIKofc3KTr6MAJ1Uk3ZfEjLnDE07wqcfGakxY0Slm9UR7KF1/KyDkWbUp9L7tKV1zueT/CR3USRL/3TpQ8nlWdldUxJBPU2CK0j3/IjepEWskCIAVBo7hvC5mDK1dFpUHXXx0U6tOaxXkbT/m5ZqceCQp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=oFFZlLS9; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="oFFZlLS9"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WszB93KtnzlgVnf;
	Mon, 26 Aug 2024 18:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1724695550; x=1727287551; bh=tBE1R9Ug8xlXzfm5VwVI4PjU
	uyZq8G9eo/PwJWmzBcI=; b=oFFZlLS9sq43/soBY5o06QDuemCNYcTcdpbUQPQ8
	ZNPFZPrNqBL09S2zm9UA2LO4jPZxA2EJrRVuL/QRYgxpPqz3MVq1Azlrhetb69lC
	yhB6NGPbx/2JeksUvytEK8EQRV265GHM7uhYMSmb4XIBoc5Nst7iU1kztk8Vlm1C
	QiLlGcafMcnxCLWg5y7LWM87ggXZ8vsSX3vQa+HsbcRxVgWjSOqOdTpeCDDHCCBr
	bxw99Egsm9UxmjZHNLl3kkWNkb55KtWsWVayO28Lj73KlbgQLTWUYHh1fmM9L6W8
	QHfjnoA11XvdpPGJrtbf4AYqyj0zDD1Ee1+YC4R82Yv0KQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Gsf3Jt8i6Laa; Mon, 26 Aug 2024 18:05:50 +0000 (UTC)
Received: from [172.31.110.201] (unknown [216.9.110.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WszB451SBzlgVnN;
	Mon, 26 Aug 2024 18:05:48 +0000 (UTC)
Message-ID: <602421aa-d546-49c2-a08f-6779d3c0f9af@acm.org>
Date: Mon, 26 Aug 2024 11:05:47 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] scsi: ufs: core: Make ufshcd_uic_cmd_compl() easier
 to read
To: Dan Carpenter <dan.carpenter@linaro.org>, oe-kbuild@lists.linux.dev,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev, linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 Peter Wang <peter.wang@mediatek.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Avri Altman <avri.altman@wdc.com>, Bean Huo <beanhuo@micron.com>,
 Andrew Halaney <ahalaney@redhat.com>
References: <2d3d17c7-c3f9-4596-aa50-3226163242eb@stanley.mountain>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <2d3d17c7-c3f9-4596-aa50-3226163242eb@stanley.mountain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/25/24 11:25 PM, Dan Carpenter wrote:
> New smatch warnings:
> drivers/ufs/core/ufshcd.c:5484 ufshcd_uic_cmd_compl() error: we previously assumed 'cmd' could be null (see line 5474)

This smatch warning is a false positive. There are multiple code blocks
in this functions that are guarded by if-statements. The two code blocks
this warning applies to are mutually exclusive. Hence, the 'cmd' check
from one block should not be used to draw conclusions about other code
blocks. I will consider to introduce the 'else' keyword to suppress this
false positive.

Thanks,

Bart.

