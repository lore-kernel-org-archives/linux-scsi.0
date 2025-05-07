Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3654E217F40
	for <linux-scsi@vger.kernel.org>; Wed,  7 May 2025 08:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746606468; cv=none; b=JivnGxj8wLb5xW6V9lx7uopJEyj4qKV42QDN50zNnn1+ecM9/VNG08K2fAzsLnAdV5Yp94RuEG/dBmY2G2WB0qmT9HiQJS7r05oD0+pBPAhxXib40zEniwIFx3wPw2R5HuzNZs9uDahLg26bFvSnDbe/3stBAOdUwY6z4z9qVqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746606468; c=relaxed/simple;
	bh=ZQ6pPahqX49L4FoIRBhZ0n9rPl6wHTixR5GsHVSUubk=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=EK5kE2feOWyZIDBA/zv89iCDgb+gadDdDLSrc88Ok/JnTYHRovxYtwefDpFmPSX9NNlc881+ciXYpUx30bHowvClXyP9OnSMKIcdbAgdAXSudkhfIMnS17M/4eOWWyDhyTHUbW2pUhMU4cJYrID0Ag1VOcP2RR9PJiaUq9RiBzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=JAIGVEbo; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="JAIGVEbo"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-ace98258d4dso977800466b.2
        for <linux-scsi@vger.kernel.org>; Wed, 07 May 2025 01:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1746606464; x=1747211264; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tCYViyp5kWLfzXdJOLLht1vSVoT9lkOIaKumywG/AIc=;
        b=JAIGVEbob9+FV/NFODJBl3mxVj1WGC05bu20pUQl30dx5mtlyc3cOvB6GE+zTy+1KO
         aTUwPpOEtQi7Hw9fz7dIAd6wVDy29K9JK1NuzSPBMJItTVdW1R5VhnGAONOW81L86glK
         HlblZS4CjHFEHNMv6mqj74x6Ln6AHMCY4pkNm3wwSc75siMoW20zUIhFGF6noP4jRGj3
         Am67JbbSU0x8vQYflOn2XC7pzVBtiMWwh7hlJlP3aaF+AnvLD8ewB2532k2x/kRYjb8d
         OweG6QL5pm1e/SdqjEGGpbSga6gJdycD6LAM8fXyZ/qcmQpqcWWw5YqH7iO6l8BcoU9+
         9IcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746606464; x=1747211264;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tCYViyp5kWLfzXdJOLLht1vSVoT9lkOIaKumywG/AIc=;
        b=F4si3oZR6H6Jv18XxqLUEOsC0IdjRUlcWls6jknvN2C/Ulls9rMxpFapGmh7kqbGEP
         SaoxTLN+XDYQDDFJBy7zP7apyc7x80pVc1nYHup5DBCrhpY9CEL8Hgo2/cH4izuMHAKB
         mQuPjkkcZJYSAqRVMIlnbzGVcpJ0hBzTBNPqY44jB8cSwACifL5VDaccOCBFRpeZEBgU
         XfLyvhFas7Xki0vYTdBd03ymrw5PtMFj6Tv+EuGSAsadXrYpoKYXZzSjygsGmN6lFgzj
         +gak5AUOtkQNq3aX2+0nOi37NB5lgOtr9m+3GbCCi7aYUb3qPYPgOfLoeiCO81PvcWr3
         zojg==
X-Forwarded-Encrypted: i=1; AJvYcCWkHrvQ95b8Hescyay2QIETakDC3bJFYhoq7j/fneK1lCGlgPbc+2DQvNzElx6AgYmvfQJh5u6Jk+NW@vger.kernel.org
X-Gm-Message-State: AOJu0YzedmodyQyuWY7LcwCw8JUV7DNDtNCaNCzrSoA2G9kW/WxPj7mD
	VUVQnXgAUkuJ8P+Cmv6NvGmixpGlP1XPBnpfhz90R4vP4DBoeA+QeookYLsPr8s=
X-Gm-Gg: ASbGncuD9hSTOn8qet0XiiRAU3TebSHk+v8VHviPpvGovcEvKU7GMv4KEZEUgCiDHIB
	ELhcFde1BNyXTluZZRAF9fPtPLmpEfXDa00Th0WzgDnQSM8tRunxRYP9xc+2/6MxuSyUUpynz1R
	cSEcETiuXDUAX/8EcZB/5cbRhycZBdnnkHQZ8vqcCbu4FVJMx2izZ4RMHXX41z4pGCwGlmdvL+Z
	/7Z2o8DzrP6v1aM1m2DUileNOf3eQnVF2YyOkOxGWqO0ksXnmCPzrhzgpBXqCXqTYHfWqyLlBw6
	On/hA+tVNTbiH5KKW2VctYpFy/C3haRAHYQ3BPi9bB2cDpr+GelinCd6/u/qm/4umNeS4sUP4V6
	wFZm590Yg50qzUBzU1i/m
X-Google-Smtp-Source: AGHT+IFWVHMkGbVmG1uAPmLK3vq0y13EMcQN92l07tgAXfsVhbprvVYbhymi8zGzYG2gLtYTRHhcDg==
X-Received: by 2002:a17:907:7d91:b0:acb:1078:9f79 with SMTP id a640c23a62f3a-ad1e8befd21mr271452466b.18.1746606464495;
        Wed, 07 May 2025 01:27:44 -0700 (PDT)
Received: from localhost (144-178-202-138.static.ef-service.nl. [144.178.202.138])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad1894c033asm873440066b.91.2025.05.07.01.27.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 May 2025 01:27:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 07 May 2025 10:27:43 +0200
Message-Id: <D9PSBGJ3COBM.2ZFBUDFGL4AJC@fairphone.com>
Cc: <linux-arm-msm@vger.kernel.org>, <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] Bug fixes for UFS multi-frequency scaling on
 Qcom platform
From: "Luca Weiss" <luca.weiss@fairphone.com>
To: "Ziqi Chen" <quic_ziqichen@quicinc.com>, <quic_cang@quicinc.com>,
 <bvanassche@acm.org>, <mani@kernel.org>, <beanhuo@micron.com>,
 <avri.altman@wdc.com>, <junwoo80.lee@samsung.com>,
 <martin.petersen@oracle.com>, <quic_nguyenb@quicinc.com>,
 <quic_nitirawa@quicinc.com>, <quic_rampraka@quicinc.com>,
 <neil.armstrong@linaro.org>, <konrad.dybcio@oss.qualcomm.com>
X-Mailer: aerc 0.20.1-0-g2ecb8770224a
References: <20250507074415.2451940-1-quic_ziqichen@quicinc.com>
In-Reply-To: <20250507074415.2451940-1-quic_ziqichen@quicinc.com>

Hi Ziqi,

On Wed May 7, 2025 at 9:44 AM CEST, Ziqi Chen wrote:
> This series fixes a few corner cases introduced by multi-frequency scalin=
g feature
> on some old Qcom platforms design.
>
> 1. On some platforms, the frequency tables for unipro clock and the core =
clock are different,
>    which has led to errors when handling the unipro clock.
>
> 2. On some platforms, the maximum gear supported by the host may exceed t=
he maximum gear
>    supported by connected UFS device. Therefore, this should be taken int=
o account when
>    find mapped gear for frequency.
>
> This series has been tested on below platforms -
> sm8550 mtp + UFS3.1
> SM8650 MTP + UFS3.1
> QCS6490 BR3GEN2 + UFS2.2
>
> For change "scsi: ufs: qcom: Check gear against max gear in vop freq_to_g=
ear()"
> Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on RB3GEN2
>
> For change "scsi: ufs: qcom: Map devfreq OPP freq to UniPro Core Clock fr=
eq"
>            "scsi: ufs: qcom: Call ufs_qcom_cfg_timers() in clock scaling =
path"
> The original pathes of these two changes are tested by: Luca Weiss <luca.=
weiss@fairphone.com> on
> SM6350, but we have reworked the code logic later.

How about adding these tags to the patches?

Reported-by: Luca Weiss <luca.weiss@fairphone.com>
Closes: https://lore.kernel.org/linux-arm-msm/D9FZ9U3AEXW4.1I12FX3YQ3JPW@fa=
irphone.com/

And despite the print in patch 2 where I've replied separately:

Tested-by: Luca Weiss <luca.weiss@fairphone.com> # sm7225-fairphone-fp4

You should probably also add some "Fixes:" metadata to your patches.

Regards
Luca

>
> v1 - > v2:
> For change "scsi: ufs: qcom: Check gear against max gear in vop freq_to_g=
ear()":
> 1. Instead of return 'gear', return '0' directly if didn't find mapped
>    gear
> 2. Derectly return min_t(gear,max_gear) instead assign to 'gear' then
>    return it.
>
> Can Guo (2):
>   scsi: ufs: qcom: Map devfreq OPP freq to UniPro Core Clock freq
>   scsi: ufs: qcom: Call ufs_qcom_cfg_timers() in clock scaling path
>
> Ziqi Chen (1):
>   scsi: ufs: qcom: Check gear against max gear in vop freq_to_gear()
>
>  drivers/ufs/host/ufs-qcom.c | 134 +++++++++++++++++++++++++++---------
>  1 file changed, 102 insertions(+), 32 deletions(-)

