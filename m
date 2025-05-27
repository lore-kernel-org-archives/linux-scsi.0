Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730F91F8F04
	for <linux-scsi@vger.kernel.org>; Tue, 27 May 2025 22:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748383334; cv=none; b=L0G0Gf5ulg6MlhB7iAHixRQtYs2OJiRN/SGAfluuQ9XLuPUL/n8N+Odv/+pRAkekiEit7+UjOv/7pIq4ZI0ADQqP7mBSTeSEG7Y/MoBxQmIJaeyWH9akPwHRhGHJFASsFGj1p8z04pfGxwyoj29leKt+QqB8KPvyufBI+gtg9T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748383334; c=relaxed/simple;
	bh=Mfa3BLDzbcNA8HH/x/VF6Be8yEFoI/Lb2dSYFkYH1yk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NDAXgGci/fywhVVfiUJRHxZs+cGV053IcidrTQ3q2Uxe2UN5bavaGV+eXCgIZQGWCkEs6/xGovegVl7r5UTe4apSEGIMELInVM/82cl+Ou6SwUS1sSWII5mEDbb3Fto6ocpyBIn83VgjkoxVzUais5ylM8E4xksAEva1Tzj61go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=LViMEsFO; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="LViMEsFO"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4b6RSM28sVzm0ytW;
	Tue, 27 May 2025 22:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1748383328; x=1750975329; bh=Mfa3BLDzbcNA8HH/x/VF6Be8
	yEFoI/Lb2dSYFkYH1yk=; b=LViMEsFOHSGdxJ/BQ/yXzz/7e14MPn9Y+5SjZa8C
	iTsqqFKeJWKbhiXgHEiHcKCiY/q4dfzO0ubxvL2F042eiNl14GPtdx51EZufl/YE
	kV13RqqfPb6Ms4nCglkeXvdgrg4RGhrLYH4CFwJPWILQCL9jWnO4VIGFuP70oPX8
	s7Xuv+r5s5yRAZF6Z3fGh5PODDgL+U8lvpEL1+VDe7sJ8qoUb/GMMkgqFHsMUrgO
	SMv2fgTAKTFW8pY5Va+ddx71vumWfe7LykvdRSNxutzoM2lJ7bWgsrfJlH5UCdmH
	HbvCKaqegMXT22rprJkn3LMuTd3a/Dg105kRLUH36g+JxQ==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Bw3z7EWBbdCm; Tue, 27 May 2025 22:02:08 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4b6RS844Kkzm0jvk;
	Tue, 27 May 2025 22:01:59 +0000 (UTC)
Message-ID: <ecfd1748-d257-48ae-808e-c672ac2f1536@acm.org>
Date: Tue, 27 May 2025 15:01:58 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: ufs: Fix a hang in the error handler
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "jejb@linux.ibm.com" <jejb@linux.ibm.com>, Sanjeev Y
 <Sanjeev.Y@mediatek.com>, "santoshsy@gmail.com" <santoshsy@gmail.com>,
 "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 "manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
 "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>
References: <20250523201409.1676055-1-bvanassche@acm.org>
 <2ab0ae98fd101d893d4f20112771cdb623fbca67.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <2ab0ae98fd101d893d4f20112771cdb623fbca67.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 5/26/25 6:21 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> On Fri, 2025-05-23 at 13:14 -0700, Bart Van Assche wrote:
>>
>> From: Sanjeev Yadav <sanjeev.y@mediatek.com>
>>
>> ufshcd_err_handling_prepare() calls ufshcd_rpm_get_sync(). The latter
>> function can only succeed if UFSHCD_EH_IN_PROGRESS is not set because
>> resuming involves submitting a SCSI command and ufshcd_queuecommand()
>> returns SCSI_MLQUEUE_HOST_BUSY if UFSHCD_EH_IN_PROGRESS is set. Fix
>> this hang by setting UFSHCD_EH_IN_PROGRESS after
>> ufshcd_rpm_get_sync() has been called instead of before.
>>
>> Backtrace:
>> __switch_to+0x174/0x338
>> __schedule+0x600/0x9e4
>> schedule+0x7c/0xe8
>> schedule_timeout+0xa4/0x1c8
>> io_schedule_timeout+0x48/0x70
>> wait_for_common_io+0xa8/0x160 //waiting on START_STOP
>> wait_for_completion_io_timeout+0x10/0x20
>> blk_execute_rq+0xe4/0x1e4
>> scsi_execute_cmd+0x108/0x244
>> ufshcd_set_dev_pwr_mode+0xe8/0x250
>> __ufshcd_wl_resume+0x94/0x354
>> ufshcd_wl_runtime_resume+0x3c/0x174
>> scsi_runtime_resume+0x64/0xa4
>> rpm_resume+0x15c/0xa1c
>> __pm_runtime_resume+0x4c/0x90 // Runtime resume ongoing
>> ufshcd_err_handler+0x1a0/0xd08
>> process_one_work+0x174/0x808
>> worker_thread+0x15c/0x490
>> kthread+0xf4/0x1ec
>> ret_from_fork+0x10/0x20
>>
>> Signed-off-by: Sanjeev Yadav <sanjeev.y@mediatek.com>
>> [ bvanassche: rewrote patch description ]
>> Fixes: 62694735ca95 ("[SCSI] ufs: Add runtime PM support for UFS host
>> controller driver")
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>=20
> I'm a bit curious why the ufshcd_err_handler was triggered?
> Because during the runtime suspend/resume process, if there
> are any errors, it should use ufshcd_link_recovery directly?

Hi Peter,

I have not yet tried to perform a full root-cause analysis. I decided
to share this patch since this issue has been observed not only by the
author of the above patch but also by my colleagues.

Regarding your question, are you referring to the ufshcd_link_recovery()
call in ufshcd_eh_host_reset_handler()? ufshcd_eh_host_reset_handler()
is not the only function that can trigger the UFS error handler. There
are several ufshcd_schedule_eh_work() calls outside the
ufshcd_eh_host_reset_handler() function.

Bart.
