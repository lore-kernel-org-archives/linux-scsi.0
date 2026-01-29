Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CDCE346792;
	Thu, 29 Jan 2026 17:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769707426; cv=none; b=mZI6zlpmVpExkfOyT/UdpnWwlW1IKFEIYgAee5EHB8Qj8jI0ufCm8f+yqrJXSEghUJFbx47uVjOoDy2kxTTIdXBQauAAJyuArlRt8PZOTPQGrBoklMXLGozu0f/eGiVkgUGthQiHZPaenm7/XJb0EuHHzMjxWIHJzBbFbJWcfuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769707426; c=relaxed/simple;
	bh=57mubkYOjL0YT99aXiVT6Kv0/eMXNPu+wKezKOeLSMY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UE6WhnBaO3J4qN9k0hVuRb2q/FPNYBruUVrkXbcYdnenet+pZGj1HAUh0bViyHKSvTVkCZ+DTtcg2CHZ6cuWBXCz2bGuSDZ9ghWMi4hzaj7o8zT0Mlm7P/QOjNAXQxaXRMyOpaFurpZiB8v4BTcLYoSh3cW5K83Xs+oIubhuBpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=w1i5luCi; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="w1i5luCi"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4f25b419gwzlh1Vh;
	Thu, 29 Jan 2026 17:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1769707421; x=1772299422; bh=57mubkYOjL0YT99aXiVT6Kv0
	/eMXNPu+wKezKOeLSMY=; b=w1i5luCiz+5zSOMO0CkER2adw97unUSc6ft9/EQf
	ELl3DCp8c+YpczJzUM21UyE1doa142hL/GFO3u7Z0wh8qMKe6DR/TZfnnpwgE4MO
	P7TDX7iRM2Rw+jqMis7n8vIAnleuupjpRLrWMn8WsZCMFkV+AY5TVwXrrFaFjDZa
	55SopTFXnKTOQjrRUL2/KtQYruv/v9sOFThBxCnt1no+BaK5O1yQfDfaBjDaiRMb
	uW0MwAFGMVJFfgLxFlTbCe9MrozhTyMYWWJ07y1qLtL0F5HxKorxyAq7b0fxkAjl
	7aFiyx2D3jSaqSuauCieoi4H7UutvH7Ouqni2XXwzyZdLw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id QtJog1USLxj9; Thu, 29 Jan 2026 17:23:41 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4f25Zz1SVxzlgqsP;
	Thu, 29 Jan 2026 17:23:38 +0000 (UTC)
Message-ID: <076fe171-6fd3-4dbc-9876-242905379594@acm.org>
Date: Thu, 29 Jan 2026 09:23:38 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/1] scsi: ufs: core: Flush exception handling work
 when RPM level is zero
To: Thomas Yen <thomasyen@google.com>
Cc: Stable Tree <stable@vger.kernel.org>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Peter Wang <peter.wang@mediatek.com>, Bean Huo <beanhuo@micron.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 "open list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER"
 <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
References: <20260129070657.678532-1-thomasyen@google.com>
 <491d53b9-a110-431b-9a5e-3b46d833fdbb@acm.org>
 <CALw5pqG735L-6-umZspQOKB9DfRHf7D0AfpkRD_=xwX0LtZ2Vg@mail.gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CALw5pqG735L-6-umZspQOKB9DfRHf7D0AfpkRD_=xwX0LtZ2Vg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/29/26 9:19 AM, Thomas Yen wrote:
> I had just sent v4 (to add the missing Fixes tag) before seeing this
> message. Since the code logic in v4 is identical to v3, I hope that is
> acceptable.
It seems like our emails crossed each other. This is something that can
happen.

When reposting a patch, Reviewed-by tags should be included. I don't see
any Reviewed-by tags in v4 of this patch although Peter Wang had posted
a Reviewed-by?

Thanks,

Bart.
