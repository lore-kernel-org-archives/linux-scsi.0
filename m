Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC941DE2BB
	for <linux-scsi@vger.kernel.org>; Thu, 17 Oct 2024 17:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729185802; cv=none; b=uEEf0E2AVd7vYScCHyiXcuRQbQtSWZNfL10Al9AYc+a1/4/5UBqWXVOtgknCxSUyVdSBpBb2nXXJ+2zk83ohJZs12woxibW4WIqpti6hkl5VkHYnoROQ0W7QD8uJojCzW0mcG3FHFP98I1mpuYT7A6vL/HFVGQX0m+E6E6dBdEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729185802; c=relaxed/simple;
	bh=p4oYaGdlPnNrZijCuuw2pbeYTATWiryxyqm478md6so=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GpxAsM6S/l5c42q+8p1moOit94WURSm25JB8q8k6yX1ruZwyhP5PBYb7xPdlisAiIhm2iuL1YPQ+yCyopZPnC2xwokeumNeN+HtCvpkFNRzU2LZUkQZ3bwpRoiu74Qq3Hv737AaTu/Kl/7WvI6lW0NTM/qiM6J5ad9/Xh6S2Tk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Nfoabern; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Nfoabern"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XTvn34x6wzlgVnF;
	Thu, 17 Oct 2024 17:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1729185795; x=1731777796; bh=xwRUnWi7NfNzofYiO/YosGgZ
	yYUAgeODU5dxtybZ1Gc=; b=Nfoabernv2dzQM/2Vt3it0/tmlwkD1LoFjZDHUu8
	Q/i1lhW5z+ZVgq7aAP5/bJev+r8/A1LkHAaadsV4PClfqbrHoskYIUczIMD/FS6l
	JfMOy1/stb4ZSMtNwiSE/JMhDtDYzeF9EHO13RgpPM4QeSBIE37bKXBnbOc/wHsn
	XknQeDzlINACz931G6d1qM9SW2j4Q48jn18wXgkSmaHzCecqhHoZkxaabuuEXIr8
	njwQ+e2Jx0mYjeWgQuqccUoXYsuRWnKkRqzMqkAZiYMTMLFxXSJ1ZTbEAAE/BHJL
	XYYyV6QjrAsrPZCsqpFVKWPEswB59rgd+Vwaca8+y/HfuQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id whlXu651-MYe; Thu, 17 Oct 2024 17:23:15 +0000 (UTC)
Received: from [IPV6:2620:0:1000:2514:f052:5dba:b913:ed45] (unknown [104.132.0.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XTvmx4YknzlgTWG;
	Thu, 17 Oct 2024 17:23:13 +0000 (UTC)
Message-ID: <32ac6ae2-e8f5-484b-b42d-3982ed9d55ab@acm.org>
Date: Thu, 17 Oct 2024 10:23:07 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/7] scsi: ufs: core: Simplify ufshcd_try_to_abort_task()
To: Avri Altman <Avri.Altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Peter Wang <peter.wang@mediatek.com>, Andrew Halaney <ahalaney@redhat.com>,
 Bean Huo <beanhuo@micron.com>, Maramaina Naresh <quic_mnaresh@quicinc.com>
References: <20241016211154.2425403-1-bvanassche@acm.org>
 <20241016211154.2425403-4-bvanassche@acm.org>
 <DM6PR04MB6575200F7AC6B1590BBEA8DCFC472@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB6575200F7AC6B1590BBEA8DCFC472@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/16/24 11:31 PM, Avri Altman wrote:
>> -                       /* Single Doorbell Mode */
>> -                       reg = ufshcd_readl(hba,
>> REG_UTP_TRANSFER_REQ_DOOR_BELL);
>> -                       if (reg & (1 << tag)) {
>> -                               /* sleep for max. 200us to stabilize */
>> -                               usleep_range(100, 200);
>> -                               continue;
>> -                       }
 >
> If we no longer use the doorbell to determine the inflight requests,
> I think this should be your patch title, or at least a clear indication in your commit log.

Hmm ... I see this as an implementation detail. To me, the key
aspect of this patch is that the legacy and MCQ mode code paths
are combined into a single code path.

Thanks,

Bart.

