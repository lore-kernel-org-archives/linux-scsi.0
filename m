Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 006F5265626
	for <linux-scsi@vger.kernel.org>; Wed,  9 Apr 2025 16:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744216694; cv=none; b=NxoW+iZS7Yc81tTGWVl7XlPl7gsaktp2PTgKV0UyHBgwXKYxUmAJ1abUsPSChE583eo9ofkdlbjTPFWXA405idVJ2EKbvorD1wglMT6h1QeqJ+T2tSXZAj2iqTh2bFbkqSdXU5e8RMWk5ObyRrsjVa/gQtmYuASyUkeUXRwVa+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744216694; c=relaxed/simple;
	bh=4CEhm7aHjlp3CcFWytJPCpnyAD4MEdxQ4Jz7Sn2NcJo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VIDMN5Ks5WvK0EpJtO2eQgG4rdY4z05+gKe+CT+ePHCTbCbWqyP+2NuBsN7JrIBdSY81/Jn4EI1WgYGvx6qRL9PwB57gk/YY/rOWQ3U4NMltyJ4a2pRfnkJtbbjPmIlsGHiTxh98Wa3yNfT/gqLgR+9begY5fMqzcScV3w7/d/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Vp54RpMS; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Vp54RpMS"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4ZXpXY67z7zlw2vj;
	Wed,  9 Apr 2025 16:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1744216684; x=1746808685; bh=/rGuTT6VFZQFI5k7qAIdE8xu
	Axxnam+j4NWW4DIaVP4=; b=Vp54RpMSM6/RuSO6cEOwlvt5ODqFl/Z/M1/btBac
	xjFayk8nxkiKZC4mwv9rOjM/D37wL6gzreBHtEA+DLN3z9P8k3Yz6iC9bSGFsY7Y
	fIyKufqYjo+mo2nYVnjgMkmerraUYOa7uP1VWufYwbcrqFnyy0aK0TGgxbD1Y+iJ
	3Q5Hyhgf8f3opKI5agkv6pVJSFUAqtZcGUWDrA0qd8qfx/GVzQ7eJugOZMXbc78b
	9zoo30jNx0FYluUbgDo78n0aufvL6xW+HcdOte7Bxfk2TVDZjIgU1vqB3TKtotrq
	yT/MUILud0Q136tGMwMdb1PeAa7kdFc8SA8oEycqOplNhw==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id l1TjfHMbsllV; Wed,  9 Apr 2025 16:38:04 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4ZXpXQ1y5hzlngRW;
	Wed,  9 Apr 2025 16:37:57 +0000 (UTC)
Message-ID: <a5a49c38-2cda-4c3a-9843-465bb4535402@acm.org>
Date: Wed, 9 Apr 2025 09:37:56 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/24] scsi: ufs: core: Change the type of one
 ufshcd_add_command_trace() argument
To: Avri Altman <Avri.Altman@sandisk.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Peter Wang <peter.wang@mediatek.com>, Avri Altman <avri.altman@wdc.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
References: <20250403211937.2225615-1-bvanassche@acm.org>
 <20250403211937.2225615-9-bvanassche@acm.org>
 <PH7PR16MB6196BC1DF13A4270EAF98251E5B42@PH7PR16MB6196.namprd16.prod.outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <PH7PR16MB6196BC1DF13A4270EAF98251E5B42@PH7PR16MB6196.namprd16.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/8/25 11:32 PM, Avri Altman wrote:
>   
>> Change the 'tag' argument into a SCSI command pointer. This patch prepares for
>> the removal of the hba->lrb[] array.
>>
> Why cmd and not lrbp? Seems like a step backwards.

Hi Avri,

It is not clear to me why this is considered a step backwards? A later
patch makes struct scsi_cmnd and struct ufshcd_lrb adjacent. This means
that converting one pointer into the other involves adding or
subtracting an integer offset. Using struct scsi_cmnd everywhere to
refer to both struct scsi_cmnd and struct ufshcd_lrb has the advantage
that only SCSI command pointers have to be converted into LRB pointers
and that the opposite conversion is never necessary.

Thanks,

Bart.
