Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838F0D26A
	for <linux-scsi@vger.kernel.org>; Sun,  7 Jul 2024 03:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720322663; cv=none; b=s1wfDpbV+PuQY0a+2cuRTalqnxYOghX5hVJdHBJO3TYxSJ9SLNo3RDJmTDfNmxLgSw5QSiYscpDlA6M8AmQFoAkIclnQ3wZap+tQBW9qorkLfIIJ41xe1i5hq3r5CeVGL2DP6RCNr+2WD6kG78p8blIv0Sddz0D1+wE8z9H3UAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720322663; c=relaxed/simple;
	bh=BAR6OK18SO+A7/0iMmmDtVyUgHgSYQm/6nzWj0EXtoY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rDNR+hN82w629yEve5EaTXad1uBLsAHUJhGXLcyyZcUYa/5ONAZPXlosVaZey6DP2nwctMcAw/L7pzhxiJdxuwJuNzq8cK0SeypSqetKFaAjdeOuTnw0Euz37x85SXlfVIjxzpzaV1RRVTp4LoISsmpvEiTApOsjGlBEBZolJR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Ee+GQ1Ht; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Ee+GQ1Ht"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WGszy6ZNsz6Cnk9J;
	Sun,  7 Jul 2024 03:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1720322649; x=1722914650; bh=SCy0GoDLjn336ErvFyKyRRgX
	snH3EUJR9wKA1RSs/mg=; b=Ee+GQ1Ht/CZbB9nQE6XcGWw40R59LgiAGD1SKxsb
	FkvKlyusvvif42EnlU4jQ9wJ0I2HYVvUnx8+E45ewew3njekeJ3UYMa66EGKP8be
	UJTwsn+NnCeWoKOZM3XdyDHvqsJACdb4UtsX1W/pnm2rYCSY8RnGEbwolBV/24WL
	ZNHpWGrpNbelWAmDBvnGTv5nTDZQJDJyFudG4fwU7Aaa1LjQBNsQlglPcsBdMC03
	IPriDnm7LZyqM21XbJKeybUIKmANMGDAjRKhpl219i3IdTyTcq1OEXeWNEScYeXr
	AO20j2DtVpwVkQhJwzVvS+mFhJCr6PBABWh+UtIBZAoCbA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Uzi5ooGeqNG2; Sun,  7 Jul 2024 03:24:09 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WGszq1Qw3z6Cnk9G;
	Sun,  7 Jul 2024 03:24:06 +0000 (UTC)
Message-ID: <8544aa91-1044-41df-8650-2a3fa3d58016@acm.org>
Date: Sat, 6 Jul 2024 20:24:06 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 9/9] scsi: ufs: Make .get_hba_mac() optional
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Peter Wang <peter.wang@mediatek.com>, Minwoo Im <minwoo.im@samsung.com>,
 Stanley Jhu <chu.stanley@gmail.com>, ChanWoo Lee <cw9316.lee@samsung.com>,
 Yang Li <yang.lee@linux.alibaba.com>,
 "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, Avri Altman
 <avri.altman@wdc.com>, Andrew Halaney <ahalaney@redhat.com>,
 Bean Huo <beanhuo@micron.com>, Maramaina Naresh <quic_mnaresh@quicinc.com>,
 Akinobu Mita <akinobu.mita@gmail.com>
References: <20240702204020.2489324-1-bvanassche@acm.org>
 <20240702204020.2489324-10-bvanassche@acm.org>
 <20240703132202.GE3498@thinkpad>
 <0bf21926-574a-46fc-82e4-86527ea59b3b@acm.org>
 <20240706163321.GA3980@thinkpad>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240706163321.GA3980@thinkpad>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/6/24 9:33 AM, Manivannan Sadhasivam wrote:
> On Wed, Jul 03, 2024 at 01:36:46PM -0700, Bart Van Assche wrote:
>> If an UFSHCI controller is reset, the controller is reset from MCQ mode
>> to SDB mode and it is derived from the hba->mcq_enabled structure member
>> that MCQ was enabled before the reset. In other words, moving all
>> hba->mcq_enabled assignments into ufshcd_mcq_{enable/disable}() would
>> break the code that resets the UFSHCI controller.
> 
> Hmm, could you please point me to the code that does this? I tried looking for
> it but couldn't spot.

* There is no "hba->mcq_enabled = false;" statement anywhere in the UFS
   driver core. This shows that the reset code does not reset
   hba->mcq_enabled.
* From the UFSHCI specification, offset 300h, global config register:
   in the "reset" column I see 0h for the queue type (QT) bit. In other
   words, if a UFS host controller is reset, if MCQ is enabled (QT=1),
   it must be disabled (QT=0) until the application processor enables it
   again.

Bart.
