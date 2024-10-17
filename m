Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CEAE13D298
	for <linux-scsi@vger.kernel.org>; Thu, 17 Oct 2024 17:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729186239; cv=none; b=XxDEeavRfa2p/2ep/5ltt1jy3DHC2aOyx9aLCzsGqSn/oQdIDeJ5wHYRdHX+EFU7iXc8FglN+rVDd+ZAagBrkcsMynnee1hAXiRVI/EGNzuCZU7R8dzSheGPx5Jr7VVaI+5fSwbAr0S8ML9Kdvox8ws4xrGOPDYK8Z8omedf1ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729186239; c=relaxed/simple;
	bh=WPpbwgnsN7h7lU6MJyl4iVjTDF1GqFum6jwDYbECsvU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fHwnHbt+9J+y81SxVKsQIeAqq9t/LqadcyD96XdXVbeMG7lg3it3d3v2MPF7c6jLdJs3aVyw0C0xAtaqL73RnkdmCgwL1xs9+B+QTBHz3lzneAvzI7SyvrvnOa/Y9j0xI/KrazsJ5uvR8qv3MpXIKk3DqmxPCb+L5dB/Z8LOoYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=o5tau2H8; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="o5tau2H8"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XTvxT33NLz6ClSq5;
	Thu, 17 Oct 2024 17:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1729186232; x=1731778233; bh=RRxRRycG6phxsxXp5fgS+9MM
	+/XFviAfzzmJ2vOTiK0=; b=o5tau2H844DS+BOOQ+7bOT2v8YFMdVrD2nPNHiZY
	Q2QrcHsdGmDavvuHh2MP3822GEVCMOIVp/Aq/s3x3rcYuPGn0v7R+n5SuQ/nEXeh
	waTAFPRq5LBzFbl0EfWPsOy+aM+FQq3GKsjU7N4ineLChZLJDao6sggYgJA1UAx5
	amcMd4roZ//Hilz8v5By4/Fk9MmDH8orS7vWflMsU7UGW3Mu9p6VJTFbHbepcZn8
	jjR2p54RIDtK9/g99+keZhHQDr92EXts8fhit6JziEJd6i5yWqsORkrLbhA9Aeng
	KkBXIN6q3LicSJ+s5GBno5RdyS6MIZvZjjnP3IH4mFk8oA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id gK57ScR8LUiJ; Thu, 17 Oct 2024 17:30:32 +0000 (UTC)
Received: from [IPV6:2620:0:1000:2514:f052:5dba:b913:ed45] (unknown [104.132.0.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XTvxK6dg3z6ClV8V;
	Thu, 17 Oct 2024 17:30:29 +0000 (UTC)
Message-ID: <d97543f4-f394-423d-9ea0-819ddaeb7749@acm.org>
Date: Thu, 17 Oct 2024 10:30:24 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/7] scsi: ufs: core: Fix ufshcd_mcq_sq_cleanup()
To: Avri Altman <Avri.Altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Peter Wang <peter.wang@mediatek.com>, Minwoo Im <minwoo.im@samsung.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Chanwoo Lee <cw9316.lee@samsung.com>, Rohit Ner <rohitner@google.com>,
 Stanley Jhu <chu.stanley@gmail.com>, Can Guo <quic_cang@quicinc.com>
References: <20241016211154.2425403-1-bvanassche@acm.org>
 <20241016211154.2425403-7-bvanassche@acm.org>
 <DM6PR04MB65756D0B96314EF126162948FC472@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB65756D0B96314EF126162948FC472@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 10/16/24 11:55 PM, Avri Altman wrote:
>  =20
>> -       /* Poll SQRTSy.CUS =3D 1. Return result from SQRTSy.RTC */
>> -       reg =3D opr_sqd_base + REG_SQRTS;
>> -       err =3D read_poll_timeout(readl, val, val & SQ_CUS, 20,
>> -                               MCQ_POLL_US, false, reg);
>> +       /* Wait until SQRTSy.CUS =3D 1. */
>> +       err =3D read_poll_timeout(readl, val, val & SQ_CUS, 20, MCQ_PO=
LL_US,
>> +                               false, opr_sqd_base + REG_SQRTS);
>>          if (err)
> Can remove the if (err)
>=20
>> -               dev_err(hba->dev, "%s: failed. hwq=3D%d, tag=3D%d err=3D=
%ld\n",
>> -                       __func__, id, task_tag,
>> -                       FIELD_GET(SQ_ICU_ERR_CODE_MASK, readl(reg)));
>> +               dev_err(hba->dev, "%s: failed. hwq=3D%d, tag=3D%d err=3D=
%d\n",
>> +                       __func__, id, task_tag, err);
> And report RTC on success or err otherwise:
> +                       __func__, id, task_tag, err ? : FIELD_GET(SQ_IC=
U_ERR_CODE_MASK, readl(opr_sqd_base + REG_SQRTS));

Hi Avri,

 From the UFSCHI standard about RTC:

0 : Success
1 : Fail =E2=80=93 Task Not found
2 : Fail =E2=80=93 SQ not stopped
3 : Fail =E2=80=93 SQ is disabled
Others : Reserved

Do you agree with changing ufshcd_mcq_sq_cleanup() such that it fails if
RTC is not zero?

Thanks,

Bart.
