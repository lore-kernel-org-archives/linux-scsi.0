Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0192E191F8A
	for <linux-scsi@vger.kernel.org>; Mon, 21 Oct 2024 17:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729531980; cv=none; b=QduWbZrEkIQcB2n4BNF6nlXz1JmPhO8ymSUDDeRGcl8WXInMRMfGrCX193rV7k+Kdk6rPhva02PXrZFrRegxoEAV7EzYV8H+2BsYi06mIu0wyQzI+mkgR2Z8CVI06og38aNMK7qOvKYOU8kgsK8BAdbRsn67kiinoYpVp0vpwUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729531980; c=relaxed/simple;
	bh=ckkedSpg8AEdZSPutfkkNxnrUX9Eevo1xjjCmdTUyvo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k8OEkPaNviN9GbBSW1NiuiXrkkcqETgx8IxzonDBrBfPJ8hQX1ojKCIRldE+1Uym7T0cvUUhsHjUB7aq6ijewbEc3YYtAApFK27pvsuubzOmOWFRov/zIdEH60nzc5nEQ3ZKSKoaGgRQCYbn/ooyPlIWZ7MXaxsE4e9xGhZAnKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=vNx+3HPp; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="vNx+3HPp"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XXMpL0xwfzlgMVg;
	Mon, 21 Oct 2024 17:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1729531975; x=1732123976; bh=ckkedSpg8AEdZSPutfkkNxnr
	UX9Eevo1xjjCmdTUyvo=; b=vNx+3HPpv/tt+Ec5aOYTKZbMXjwXwFxdtSO2kEhf
	CQeHpgHwm6iJOSbJQEzglUOGofuCLHRlyeiVl8P4qVUsUu1AKhDidcYn9Y+O08e+
	SSCgXOtsOFRtR8b3c0Cim8o1iInzbarGADM4NJz2JTG5KJN5cj2WgUBwFRmmkaxk
	o/nlauodeNkNQlDs0xczZJdklNYTktZh1xxSB3dNSTReCEqjCvjXk3Gaun7uOkSs
	+uRYfOExf0+bNcWE43gGCWB1LV/lSemC0Ug1Y0Ry/01z+A5mhtyhHNE2iahwrB+4
	X+YDXdbuDQzAjDcuackQjZ2bY+Z3E4ACZy8tMW+PlqPD1w==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id zyx4HElTWhc7; Mon, 21 Oct 2024 17:32:55 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XXMpF3GfLzlgTsK;
	Mon, 21 Oct 2024 17:32:53 +0000 (UTC)
Message-ID: <7080147f-19cd-4268-9c8b-06d6625a6604@acm.org>
Date: Mon, 21 Oct 2024 10:32:52 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/7] scsi: ufs: core: Simplify ufshcd_try_to_abort_task()
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "ahalaney@redhat.com" <ahalaney@redhat.com>,
 "quic_mnaresh@quicinc.com" <quic_mnaresh@quicinc.com>,
 "manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
 "beanhuo@micron.com" <beanhuo@micron.com>
References: <20241016211154.2425403-1-bvanassche@acm.org>
 <20241016211154.2425403-4-bvanassche@acm.org>
 <a0749a3e946971eb50ed803f7fb3ec6ae50a33cf.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <a0749a3e946971eb50ed803f7fb3ec6ae50a33cf.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 10/21/24 1:58 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> As the DBR clear event occurs before !ufshcd_cmd_inflight,
> this could potentially cause an additional usleep_range wait.
> If an additional wait of 100~200 us is not a concern, then
> I think it should be fine.

Hi Peter,

ufshcd_try_to_abort_task() is typically called if no completion will be
received from the UFS device. I think that the potential additional loop
iteration is acceptable since it is rare that a UFS device reports a
completion while ufshcd_try_to_abort_task() is in progress and since
this is an error path and not the hot path.

Thanks,

Bart.
