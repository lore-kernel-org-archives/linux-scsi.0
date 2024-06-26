Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452AB1891D0;
	Wed, 26 Jun 2024 16:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719419630; cv=none; b=jE7YLQuHZZEjF2hhMS51ySoABCy6jgjRgAYmjDjn6WSkk1Ta1BtN42Vx6KdJ0PGkv2x/INOklOXrfiYQL23s29kcRWumFCZ8dph7nSFVzqkXrNAsMfhbMbdD7E3XCAM6/x2GNR60l8vugzKs+8h1oG/731mSDqbo2x9rj8+g++k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719419630; c=relaxed/simple;
	bh=YQY/Xi1Gb1tt/jaqRVo07BJZLQKnrQMKV6tif6YwiiY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gmY7j+XDqprIBbRU/oaVd70rlamRhyIa095HMqGPrDkHFzllTjs3RI7bh3agp5LLztfcy6luKA9dpFupgcjQyKxckVMr1jH4cGoC7RtRhi2MjUBdDG0yFPedStaD4JYHjnj3twMRkM18WbC1AzqmV54gUOgzD9x/BJGleYKc5X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=pY67NDG9; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="pY67NDG9"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4W8S1y3tYJzlhw8y;
	Wed, 26 Jun 2024 16:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1719419616; x=1722011617; bh=6ny5mb2NbK52sUNMrSeXYyT/
	VKWcErgnneCbH+jSyGw=; b=pY67NDG9B0FqG3yGrtYTxT/ESIlfUqnnni8s8KgZ
	QSb/uQzSA7qDyb7bszEqlXx/9any89K1gpi6gvo9cfbA0lLeEJvBtt/JpBYSa/PP
	cnCVjold3SEfAIsJNymU47MN1bCR7IC0FBsHlFAYhXN5xRXgw7/PF+VORI4dgpqL
	O6LIokyhGKrg2Azd/8OnvfpFD92R/SmfoxYJ8ogPU0PRPXo9EOcrV87hQUPOFKJn
	U6fhtacgrcndR9nbQrGcqDS7aEc0z/TmHBDETCmO4mXfmosqzWgo9LquHxNi5ri0
	NItpn/izlUMEI1OK51wZ+Eo2Wty2Vexr22eAmSsr7fziyg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id IOoAp_9bYx9O; Wed, 26 Jun 2024 16:33:36 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4W8S1q0nG5zll9bG;
	Wed, 26 Jun 2024 16:33:35 +0000 (UTC)
Message-ID: <d1768030-28fe-476b-9161-2b26f296c0dd@acm.org>
Date: Wed, 26 Jun 2024 09:33:33 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: quiesce request queues before check
 pending cmds
To: Ziqi Chen <quic_ziqichen@quicinc.com>,
 =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "quic_rampraka@quicinc.com" <quic_rampraka@quicinc.com>,
 "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
 "quic_nitirawa@quicinc.com" <quic_nitirawa@quicinc.com>,
 "beanhuo@micron.com" <beanhuo@micron.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "junwoo80.lee@samsung.com" <junwoo80.lee@samsung.com>,
 "mani@kernel.org" <mani@kernel.org>,
 "quic_cang@quicinc.com" <quic_cang@quicinc.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
 "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
 "quic_asutoshd@quicinc.com" <quic_asutoshd@quicinc.com>,
 "quic_mnaresh@quicinc.com" <quic_mnaresh@quicinc.com>,
 "manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1717754818-39863-1-git-send-email-quic_ziqichen@quicinc.com>
 <d3fc4d2b-81b0-4ab2-9606-5f4a5fb8b867@acm.org>
 <efc80348-46c0-4307-a363-a242a7b44d94@quicinc.com>
 <b1173b6f-445c-4d6d-9c78-b0351da2893a@acm.org>
 <ee45ce9429b1f69147c1a01e07b050275b4009bf.camel@mediatek.com>
 <3c7e776e-df2e-4718-995f-5e5dfa3cc916@acm.org>
 <272184ed-2fd8-413a-816c-9470bf9332da@quicinc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <272184ed-2fd8-413a-816c-9470bf9332da@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/26/24 6:18 AM, Ziqi Chen wrote:
> On 6/26/2024 12:13 AM, Bart Van Assche wrote:
>> ufshcd_wait_for_doorbell_clr() should be removed and 
>> ufshcd_clock_scaling_prepare() should use blk_mq_freeze_*().
>> See also my patch "ufs: Simplify the clock scaling mechanism
>> implementation" from 5 years ago 
>> (https://lore.kernel.org/linux-scsi/20191112173743.141503-5-bvanassche@acm.org/).
>
> The defect of blk_mq_freeze_*() is that it would bring in significant 
> latency and performance regression. I don't think it is what many people 
> want to see.

This can be solved by inserting a synchronize_srcu_expedited() call
between the blk_freeze_queue_start() and the
blk_mq_freeze_queue_wait_timeout() calls. With that call added, the
latency of the new code should be lower than that of the
io_schedule_timeout(msecs_to_jiffies(20)) call in the current code.

blk_mq_freeze_*() is only slow if the RCU grace period is not expedited.

Bart.
