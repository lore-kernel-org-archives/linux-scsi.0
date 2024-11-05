Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1798A13C918
	for <linux-scsi@vger.kernel.org>; Tue,  5 Nov 2024 22:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730844074; cv=none; b=Fd7dRJCtfeqyzd3Z2sp3kO1Ut5NqlqMM4jmOPIRwW/Zc50cF2WQwBbYzv6mucPsOTVwqagIrcs77py2IfgxdbYAcLhrxtNGHvHSracZPfbRw14CfonCXYveXfvA7GrS7Y/bX3Sx9bQeTYmlNPzweYm7hN9+BvLARXGuTzI3xv4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730844074; c=relaxed/simple;
	bh=d/A0HUFbj/lv+s0R+c95urSKGpZC0n/Ki6oIXbrOp2w=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=E6l8SMe7Kw6KiHfizrxObaNJ+bKR+pZTN0xP0oMMYGcHGZfQ7e9E2x+tvcrii2MMmBmcXqbTm+M1cIuqpRuKG/c7PBtBbsCotpYJFnSLJNTkhbfxNeC2fK0+9ZorkIVZtt3P7Kzb1fX0hefU+yJL2M6FPU5r6QpVSohBgQIIM5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=tt2UBlfR; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="tt2UBlfR"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Xjj2w2S2mz6CmM5x;
	Tue,  5 Nov 2024 22:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:content-language:references:from:from:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1730844069; x=1733436070; bh=W7i07u2ItHQ2ZHx6Nml2o8L4
	CEsceojq3/NMrP1/1Dg=; b=tt2UBlfRyu0u3eeki7/2Tsbhp81APvy3ciegTxBe
	Tvdy3V72qBrQcmeVVwqcrJeU1FesHuWq0tlcrCCrKLvAPT1c/eeJBmXf2a0J3bUG
	lrG+BMjlA+CGfaPrygKpCaLsVUJ+DJ3WT/SrrSznkQb5VYpI/bypTZLR/f+s8Np+
	MlHrWWhWEZn730lZBJ30RHzJ4js1KyaRn/w/GHpuludVC15J/JABzn3Ju0gTXnZh
	xNhb8EyWHbEJz7lc56poBI0JnsIsxUmdQWcnbEFe4AjGaTUBdkEai6lg/dUWG4k+
	MtgEsahhwaoOQLLMyLVrpINfk24dyHx4WNFqe5zKj1Kt2Q==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id rMGfnYLNOJQe; Tue,  5 Nov 2024 22:01:09 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Xjj2r0YC7z6CmQwP;
	Tue,  5 Nov 2024 22:01:07 +0000 (UTC)
Message-ID: <1c9acc01-7b1d-41ac-a0da-4e50dc8f0319@acm.org>
Date: Tue, 5 Nov 2024 14:01:05 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 11/11] scsi: ufs: core: Move code out of an
 if-statement
From: Bart Van Assche <bvanassche@acm.org>
To: Neil Armstrong <neil.armstrong@linaro.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
References: <20241016201249.2256266-1-bvanassche@acm.org>
 <20241016201249.2256266-12-bvanassche@acm.org>
 <0c0bc528-fdc2-4106-bc99-f23ae377f6f5@linaro.org>
 <afaca557-6b7f-4f48-a38a-19eca725282f@acm.org>
 <19b75e1d-bc36-494d-a33a-d36a1646bcc7@linaro.org>
 <6b20595d-c7f6-42aa-922e-3671abd7917c@acm.org>
Content-Language: en-US
In-Reply-To: <6b20595d-c7f6-42aa-922e-3671abd7917c@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 10/31/24 2:15 PM, Bart Van Assche wrote:
> On 10/31/24 12:55 PM, Neil Armstrong wrote:
>> Le 31/10/2024 =C3=A0 18:51, Bart Van Assche a =C3=A9crit=C2=A0:
>>> Is the patch below sufficient to fix both issues?
>>
>> Yes it does!
>=20
> Thank you for having tested this patch quickly. Would it be possible
> to test whether the patch below also fixes the reported boot failure?
> I think the patch below is a better fix.
>=20
> Thanks,
>=20
> Bart.
>=20
>=20
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index a5a0646bb80a..3b592492e152 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -874,7 +874,8 @@ static void ufs_qcom_advertise_quirks(struct ufs_hb=
a=20
> *hba)
>  =C2=A0=C2=A0=C2=A0=C2=A0 if (host->hw_ver.major > 0x3)
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hba->quirks |=3D UFSH=
CD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH;
>=20
> -=C2=A0=C2=A0=C2=A0 if (of_device_is_compatible(hba->dev->of_node, "qco=
m,sm8550-ufshc"))
> +=C2=A0=C2=A0=C2=A0 if (of_device_is_compatible(hba->dev->of_node, "qco=
m,sm8550-ufshc") ||
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 of_device_is_compatible(hba=
->dev->of_node, "qcom,sm8650-ufshc"))
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hba->quirks |=3D UFSH=
CD_QUIRK_BROKEN_LSDBS_CAP;
>  =C2=A0}

(replying to my own email)

Can anyone who has access to a Qualcomm SM8650 Platform please help with
testing the above patch on top of linux-next?

Thanks,

Bart.
