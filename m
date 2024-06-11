Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04DB17CA01;
	Tue, 11 Jun 2024 13:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718113908; cv=none; b=HrYPYmVbbpcz2SPe9cHcTomND03xFFM2QVwCA6EBmtoGKjJFMPbKq8Rx7UceTXV83jkm27ben5flZ8go39httgWR6o2Cr/1Pq6PUOX0b3f8itCUn5ab1DWK8ICZz0dzRwnFcGUo4/UuvKNAg70SeuQq+He1HIl93Gf2yK7a5BPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718113908; c=relaxed/simple;
	bh=KEtwGw8gBMQNvYwzxuaWOdG9vehq+myAeUV1kWaA5b8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O7zJD+/m7+zp4ZU3t2AbATk7VVJ5kQanI+eoDg6CIOzEVMc+uqCpwAr314B6t3QFdyesfNIDhZeB1+jw+Axk+2DkMmxkrK9MLia0v1XrU97fpa4FjZqttQoBXdIeMVGEw+dL6kLLAznNJSzzOH7hlFpg9SlZfg3tPqVyGEh2TmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=27six3R8; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="27six3R8"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Vz98219DYzlgMVP;
	Tue, 11 Jun 2024 13:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1718113901; x=1720705902; bh=L/NnVA4j3P/w1z9DUblp7sR3
	Ma4khnp/4r72AD/Yqus=; b=27six3R8Cz4rI0jx31AXI5a6krlIfya578XMExEp
	9WHS7oGyO0n3AdczG2AEqZoj8/iS/hnUy21hKOwJKJdUBnt6KGnISN4KUhXikY+W
	1dQ6iOlOLrH2FCxGW4qota/E5Sh5VGwXEotQcE67C4F/HMmiV6cFKUFJZ7xvhr30
	oTbBcTfXSu0vISIhZ84mMZd5RiitkXsHUje8JU5ffdHhV4hY6DPwG84R8FLFS2PO
	cD3m6NFzyYfuiTWMY/NC4kAb2hBUhF0oA9uhd6rhsCKc7MVvCG5QDZYf7a1evw80
	hqsqqWIIplpqj0SXMdRksB7plF914g8cvrimeC0LFq2shw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id EEoas1mS21Az; Tue, 11 Jun 2024 13:51:41 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Vz97t1TTqzlgMVN;
	Tue, 11 Jun 2024 13:51:37 +0000 (UTC)
Message-ID: <16b2cd1b-8f1a-4fb1-823f-a73463c6f7a0@acm.org>
Date: Tue, 11 Jun 2024 06:51:35 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: quiesce request queues before check
 pending cmds
To: Ziqi Chen <quic_ziqichen@quicinc.com>, quic_cang@quicinc.com,
 mani@kernel.org, beanhuo@micron.com, avri.altman@wdc.com,
 junwoo80.lee@samsung.com, martin.petersen@oracle.com,
 quic_nguyenb@quicinc.com, quic_nitirawa@quicinc.com,
 quic_rampraka@quicinc.com
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>,
 Peter Wang <peter.wang@mediatek.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Maramaina Naresh <quic_mnaresh@quicinc.com>,
 Asutosh Das <quic_asutoshd@quicinc.com>,
 open list <linux-kernel@vger.kernel.org>, quic_richardp@quicinc.com
References: <1717754818-39863-1-git-send-email-quic_ziqichen@quicinc.com>
 <7ba3bbb8-a5c3-4ecd-9c2a-c9586c9d6bf2@acm.org>
 <6d636c36-ce05-4825-b916-b97484c41c5b@quicinc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <6d636c36-ce05-4825-b916-b97484c41c5b@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/11/24 04:02, Ziqi Chen wrote:
> As for removing the rest calls to ufshcd_scsi_block_requests() and 
> ufshcd_scsi_unblock_requests(), I think you are right, but I am not 
> quite sure because we haven't seen issue reported w.r.t those spots. If 
> possible, we can co-work on this sometime later.

If you want I can work on the removal of the
ufshcd_scsi_block_requests() and ufshcd_scsi_unblock_requests()
functions.

Thanks,

Bart.

