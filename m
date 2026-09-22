Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4F35650F1;
	Tue, 22 Sep 2026 16:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790094650; cv=none; b=hw+cdnBPf+8vGPpjonjtriFwT+7gySFdpWq1j+P9ZB10o94tSM7dj1kJ8k8JovC2tYWJY1LEf+dgyRoxpPO1ukPWZ/LJ5TRQavDqTIjKkVUBzflTJYKoz/4HaCrYPJhiiWsB6aK+uB3tKQjOVIMJkeFN2cZLyGOMAshtpbklAu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790094650; c=relaxed/simple;
	bh=n0i9pglkjtDPlCZXO9mMSC3fpC5+97b7K6QwPl600kw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=at1SxfBhiaaIOBpHCJE2mPDStt8LeIQO7YJLXI6dlMcrW/hBhyGlGKMjhfEH9nvlZr4RHckj9+3Bqda5F3Ys3twLwPrtknkMoVkIpTuOpwGgeXbqvApv6YEBOtaVYbwWMXcbXnqc5uI3+BJbE++TuXF5/vkp57f6mQIj13I5PMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=YE+Rh2cP; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="YE+Rh2cP"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hq5Dt5mXnz1XM4TB;
	Tue, 22 Sep 2026 16:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1790094630; x=1792686631; bh=5wudMcqllVoD5NwPxCCiMaye
	Ueh3clA79hQ7lUy4QLU=; b=YE+Rh2cPPhXSa54yKO04vuTwFZr63CYukbzWRehT
	SNpD+Nc1VvpS19XO/NhrskYmPtKYoPSXdfQmRMTqtcwEkPMHL2KZuxB5Ia4S6obh
	UciyUWtB/P/cBKamlfNJxN9vMWH0Jk258oXzowFUlHmwADkJjeutYYcfp+otOq8p
	Skqpul2ViO/uKcaX4NoowXZms+mP1lkw4PNvlSA5obe/7Y/mei4nUZKaF71W7GQC
	T+BlGxUEjm1rcC0yYPvYPX/zVVANfv4uQveDwqu8jSkgCUXQdPKirDpCX0ndoT/3
	+Y6ZEUjShVRdmZlfbrbrnTdJ/jkpQRh6Igh2LxuajKveEA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ZLdxj2FYuNy9; Tue, 22 Sep 2026 16:30:30 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2ed2:d:1f32:8c6:3a87:d280] (unknown [104.135.182.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hq5Dd6v2vz1XM4Sx;
	Tue, 22 Sep 2026 16:30:25 +0000 (UTC)
Message-ID: <df31eb82-7211-415a-9ec1-53ecbc3e39b0@acm.org>
Date: Tue, 22 Sep 2026 09:30:24 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] scsi: ufs: core: Decouple CQ sweep from request
 iterator in MCQ
To: Peter Wang <peter.wang@mediatek.com>, Stanley Jhu <stanleyjhu@google.com>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <mkp@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman
 <avri.altman@sandisk.com>, Bean Huo <beanhuo@micron.com>,
 "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 Can Guo <can.guo@oss.qualcomm.com>, Manivannan Sadhasivam <mani@kernel.org>,
 linux-kernel@vger.kernel.org
References: <CAE14pdek6ynze+muDZrK+yNX-3ioe3vprxOA4W22qokg352tJQ@mail.gmail.com>
 <20260918143809.3034592-1-stanleyjhu@google.com>
 <20260918143809.3034592-3-stanleyjhu@google.com>
 <1ddc5181-f547-465c-bfbe-dbf14a91493e@acm.org>
 <20260920135014.3528082-1-stanleyjhu@google.com>
 <e3538f10-fb9e-48ce-b48f-bca25c8f3d6c@acm.org>
 <bab059b9a2dfed258db23993b5a6b4aceca2da49.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <bab059b9a2dfed258db23993b5a6b4aceca2da49.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/22/26 12:37 AM, Peter Wang wrote:
> On Mon, 2026-09-21 at 10:13 -0700, Bart Van Assche wrote:
>> In SDB mode, clearing UTRLDBR will cause all pending commands to be
>> requeued because the OCS member is initialized to
>> OCS_INVALID_COMMAND_STATUS and because ufshcd_transfer_rsp_status()
>> translates this status value into DID_REQUEUE << 16. I'm concerned
>> that this approach may cause the deadlines for SCSI commands to be
>> exceeded. Hence my proposal for MCQ mode not to requeue pending SCSI
>> commands but instead to let the SCSI error handler decide what to do
>> with these commands.
> 
> The current MCQ flow is similar to SDB. We discussed this two years
> ago.
> Aborted commands will be requeued immediately, just like in SDB mode
A SCSI host controller reset must abort all pending commands. Requeuing
SCSI commands during a host controller reset violates the API contract
between the SCSI error handler and SCSI LLDs. I'm not aware of any other
SCSI LLD than the UFS host controller driver that requeues pending
commands upon a host controller reset instead of aborting these.

.eh_host_reset_handler() is expected to reset all logical units and the
host controller. The SCSI architecture manual (SAM) mentions explicitly
that resetting logical units involves aborting all commands.

Thanks,

Bart.
