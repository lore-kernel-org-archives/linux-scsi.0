Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1591C1B9853
	for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2024 21:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726175999; cv=none; b=G6hRicUTp0D1VRIbZafl2PnDJ1Cb9szkvu5F6CdobkNoM5aXDbQ6JZlS/Md5Y6jDvTpkXcE8kzqb2zMLfY8rmsMI/CWRNTntdz/VGLfYS2A9jHAERVDLIMhXtOD9FxPwvzv01jsVAHArQmnpAxTRkQ3e785eERlAptKukEBqdXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726175999; c=relaxed/simple;
	bh=MmNlS5gHnbbaqWEWMo2iY+SD25KjXvj0W6hJ7E7PXpQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GJ8agSfKKJIKw/MddnY25Q7S5ozn0OJl5Nq+vQ9SCqtvjsHKmDjDHvZJa7KJefPgjbW8WMmvlrkX721juw2IzND/ZH+6Lu0OHYZ94GTF7aWMWvdDo1QMD5tCRwLLF5KGuG1nzvuOIivlUWwNiZn1m8LYi4498QKERGcljmbK3co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=LkaPHSj9; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="LkaPHSj9"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4X4VhF3NKvzlgMVW;
	Thu, 12 Sep 2024 21:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1726175995; x=1728767996; bh=ATLtqliSlQL0jJo/ERCFinDo
	ai0FvKFWK4aopOVJK5s=; b=LkaPHSj9heNkRUnHvOlRvigXXnS3i6wJeHpy7VPv
	dXcmYSAZcT1e239Tx/J2L+hcVmXyrbB8Pi+DiQnpqrf86trqFDIRUzfSatbYQNHf
	XuRD1DfYNe+zdOFfmIm47wT2mBjUOTWT3Q3lq47bt53YqKDQG4tswfURwoH7vF6C
	5ZS/er/xfLH4mDech+FR87Bldjx0pVaa5pG7BtUSramiMVLMou8LjVJ+oxmp2vyo
	cIE2Tk5vyR8cWywY4DeBtAVh+GFdeH+VCpURJ/TB9c5/7j6BNTy/8JQpEyK++e9g
	AHoiy0xUwyY4Qhq7yF4RhgYgGoGFk2D/YbR1ReMUUe8Usw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 52gO6k0rTKob; Thu, 12 Sep 2024 21:19:55 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4X4Vh66QFKzlgMVN;
	Thu, 12 Sep 2024 21:19:50 +0000 (UTC)
Message-ID: <5bc3f6e9-5ed2-47ff-a442-4495fc8ae8b4@acm.org>
Date: Thu, 12 Sep 2024 14:19:50 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/4] scsi: ufs: core: Make ufshcd_uic_cmd_compl()
 easier to analyze
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "ahalaney@redhat.com" <ahalaney@redhat.com>,
 "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
 "manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
 "beanhuo@micron.com" <beanhuo@micron.com>
References: <20240912003102.3110110-1-bvanassche@acm.org>
 <20240912003102.3110110-4-bvanassche@acm.org>
 <d9827ee4adf5049ba27e857de0815b0006044147.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <d9827ee4adf5049ba27e857de0815b0006044147.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 9/12/24 6:27 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> On Wed, 2024-09-11 at 17:30 -0700, Bart Van Assche wrote:
>> @@ -5462,10 +5462,13 @@ static irqreturn_t
>> ufshcd_uic_cmd_compl(struct ufs_hba *hba, u32 intr_status)
>>  =20
>>   	spin_lock(hba->host->host_lock);
>>   	cmd =3D hba->active_uic_cmd;
>> +	if (!cmd)
>> +		goto unlock;
>> +
>=20
> Could add a warning line in this case? =09
> WARN_ON(!cmd);
> I'm worried that if this situation occurs, we won't have
> enough information to debug.

I will do that.

Thanks,

Bart.

