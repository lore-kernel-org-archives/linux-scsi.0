Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623D3154C10;
	Tue, 20 Aug 2024 21:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724190795; cv=none; b=D9WPVgFDwKSG5QDfQZ11nuCLOpKe8h+/Ok8CHsSvFfB8yAMp3HWFANgi5uwlQZ0nmRADxLrBSZEt1PQM29voGfnSM6M2uwOH+YqEm0DmxuM6rzskICVJZ1Mxfbjdk9mUFBcZv9fItsKoMf3y+ckJKJRoWEoGDHyPSMTB8ngXA9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724190795; c=relaxed/simple;
	bh=zFFbXPWHS8E2Ezu8Rn5t+ePYv0aowCIytFxqaVt6GpU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n4QqSrbxMXappP0wZmaDOTtT6wEvAl8K/NCXDsvSmBgbjJJYyRvVJ3uPB/eVcQ+fp6NQXvQ05qK6de5xmoVcIs+0TXnksV1XH58bnA0F8wE7NQ8Mgtd4pjAZv/x7QIcfVrDsrerSmW7qpwyCiLyIWGudMNHp7Xl0+XfRe4O7tak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Qe+tl4Vj; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Qe+tl4Vj"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WpNWF617Dz6ClY99;
	Tue, 20 Aug 2024 21:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1724190790; x=1726782791; bh=S1ZtWpcyOYQRmSU7/wyc6UD+
	b4EXl2U3vRPTY7cs4RI=; b=Qe+tl4VjT/LwLu76sGZBUTL58Xcit1Z+CScXSs8Q
	K4ZvQcdPQvAgGpwr46gWnFjFrMGRHe1CUBiXbWHhthRdZl/7APWfK0eXqN0Ri6Xr
	EaTCjbRaCkdBPlBBJQQ0FdTLFcUsJM0wtYQQlotMhyVjvCEaZsTvAz37FCOZmcRl
	k+gRu28oMVAR4sdWKHvXtqatiQTeem/Uf872GZrh4EZbxCo6FdIBimIh8cW3hqec
	R7aHrYjQP2/cFPnqnj5K5pz14bBlIjNcw/DTzxMatUdrYBsjrTOaPiLFxFfMLXiN
	eRcSB+d8awoBzD1TGf/lYbi1ehgTFuEkJRa/uOd4p6Tdqw==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 91RVa769WTKk; Tue, 20 Aug 2024 21:53:10 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WpNW72YJ0z6ClY98;
	Tue, 20 Aug 2024 21:53:07 +0000 (UTC)
Message-ID: <ef580b2b-af06-4b5c-a0e2-09d6374434fb@acm.org>
Date: Tue, 20 Aug 2024 14:53:05 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] scsi: sd: Ignore command SYNC CACHE error if format in
 progress
To: Damien Le Moal <dlemoal@kernel.org>, Yihang Li <liyihang9@huawei.com>,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linuxarm@huawei.com, prime.zeng@huawei.com, stable@vger.kernel.org
References: <20240819090934.2130592-1-liyihang9@huawei.com>
 <bfce098e-a070-40b1-95fc-951e2b3c1c22@acm.org>
 <c8a990c3-4b47-4e22-a378-8714c697748a@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <c8a990c3-4b47-4e22-a378-8714c697748a@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/19/24 4:19 PM, Damien Le Moal wrote:
> On 8/20/24 01:59, Bart Van Assche wrote:
>> On 8/19/24 2:09 AM, Yihang Li wrote:
>>> +			if ((sshdr.asc == 0x04 && sshdr.ascq == 0x04) ||
>>
>> Shouldn't symbolic names be introduced for these numeric constants?
>> Although there is more code in the SCSI core that compares ASC / ASCQ
>> values with numeric constants, I think we need symbolic names for these
>> constants to make code like the above easier to read. There is already
>> a header file for definitions that come directly from the SCSI standard
>> and that is used by both SCSI initiator and SCSI target code:
>> <scsi/scsi_proto.h>.
> 
> That would be *a lot* to define...

I meant introducing symbolic names only for the numerical constants that
occur in this patch. Anyway, I'm fine with a descriptive comment too.

Bart.
