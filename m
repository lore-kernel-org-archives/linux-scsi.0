Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39FB3F0AAC
	for <linux-scsi@vger.kernel.org>; Tue,  9 Jun 2026 09:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780996219; cv=none; b=sKmMhmXKXOATW6o9Z68ji9qmXS6foHfDhGm4vonV5Er2+nQw2iASRTZ2/CbZlQs2JJPb1jXSfaf60w9yRlciYB48Zr2y7D/3+s1cZkSsqinZAr2xXk0X0XOMa80gfiAHK5r0p3+CWHz3unXu++huX614d44KEozazqIHd3JJ9Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780996219; c=relaxed/simple;
	bh=FsAgKQLTqqBsaH8gJxz6UunUN+XMU8p/s3pmuCBnLdc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JJ++ekrjQs2gx6puZA4VNnzBwOuTRlUBW5vEswyQefd5SeXB0REYvrTwrRFa8Uuq/LTh88QRhzuEOAynl+I0uTUAmy7DOSliW8YfSQBCBlaU7C/bCHebTU+ip4vot0/AcdBdb1uCvpRyjp020SlDAsfQL7t3dnV7IMJeAVLnreo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=jYvHar5W; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=NvbzE57h; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="jYvHar5W";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="NvbzE57h"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6597rMf01584107
	for <linux-scsi@vger.kernel.org>; Tue, 9 Jun 2026 09:10:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	FsAgKQLTqqBsaH8gJxz6UunUN+XMU8p/s3pmuCBnLdc=; b=jYvHar5WxGNuOfDH
	aRKrJA7I/I4F1R6q99UP41suPPlymT8UHMSKOoWBlYAx2eUJRtm13uPMEI2kmmWl
	XfrQN1lQJ/MpA7r5occZ0EhWYp1IAnXJc2xh4DTfxFPjk/pibv96THd+qBIPlEfx
	Qk58Qb74lWhVWHHjRr3Q0gS6AR5W1n9fI0h/MAIWdkXILgMgtA/Srk32VyAZHHjC
	edYMIo+wrDA8aM/7PRzAdaAYBnkNevWNNbxJqkrBOveRiEmDRzdo/5OBt0vwBTjL
	S7Agtv5Hfh1WPr+ie0D15naBJUwJISxwXHJLQHlBoCKiy0HtDrnx6luuFsCSpcEF
	v8AZ7Q==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4epdeerq56-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 09 Jun 2026 09:10:17 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-36e09ec696aso9074502a91.0
        for <linux-scsi@vger.kernel.org>; Tue, 09 Jun 2026 02:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1780996217; x=1781601017; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FsAgKQLTqqBsaH8gJxz6UunUN+XMU8p/s3pmuCBnLdc=;
        b=NvbzE57hHV1K4LH277CGHKeoa3iKeHkITWyfBbU89REewaPKops0FLi6qw20Ec18Jz
         o6qk9JemvaEmwMWvUicvcnNzQF3eXuKYAxBEQTnkue03KUQQ/ZoKRJmVWX7Y9zu2iF5X
         oQDgvdPiLoeku2FHndhP53aNnKOgv+AKgRkJqHaM/hfeathiv2rPr83lnayvp4qoCJHk
         8pbBAy9piTtyv7/5r/vjrO+s3slXd0O3jJECgR+7mhdv0o300B5u1MwGK7wtKrde8cOf
         mElxWDCRbVPtDH1ZRQgAcG/nYM8J/+BhnBooHaYberxLQbLSKS6+kCeLKQmFA3MO66TI
         ENEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780996217; x=1781601017;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FsAgKQLTqqBsaH8gJxz6UunUN+XMU8p/s3pmuCBnLdc=;
        b=LAPiSeT28Jr0t1ejlTBJqiQsZqnIGzMbl4wzCkyNi6QwZjNb83UPthb9NEus0/dcnn
         1F/EWOYkWzm+cAbQ532Foq4keGDs705iaFcgMNhv2K/1Er1YNKhiH8Svs9LKpHn3D0DC
         SLG29gWaiUZQLuVyTeYl0Q0IPVqUsF/Ui3QE4g02PfTWswaRY52tPIKOhPutYEiNTxzc
         6N1KF8rJ4WqBvUEZ+AnTnNPAKo4LXGYlZnxG/tqmBFvwtg/Mzr0IBafKYm8IaiHjuJUF
         kgsJbg4kYkYJ1p8j9aWTSh9blM2Ws/sZZ8HcQ9ujhGzLK0M3naEMZYOkffvOxh7R5eoU
         aCZA==
X-Forwarded-Encrypted: i=1; AFNElJ9/vQArarKpqbhIgXr20asjnv7ZtVJuZTQJTOA7tw6Rtriua74GiR/U5nvL1bUVI6dYyyYGl0YiKZqR@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/8nqsxq+W6MfNPOGpQ3kpM294QKF8Azw1bYjEFI/NfZcG/41x
	V12nJWC5S3MkdHhkA9dthPuxZrBhBnaMW4xuASvpnXqRQMpvbxebVBu38EcyKPtbajcOjHGtv5Y
	EHyqBStXTwgw01aiVRywEyNqc8FjbfEWMy4s79ODIMmXnsLZzRsZAbQZ2HfKaa/N1
X-Gm-Gg: Acq92OHjrJbYYpUQd77jy2ZlIGxAU3TrxYTQ3IQ/FLCQ6OxA6so2YyOrOsCO+giVeYl
	8iHIeA6M92glNvyJLqecYe713O81pF11CRmKV4URhRHYNeUw6A/IaFkUD7ZGFipp67DYwZTG/yg
	SKfVLDmbeOco/MSjOkv5RjQ1WrzRfvBFKspsSHnPjgDYNVHVOIsZPlY3wHYMgUyNZ42Hv5iV0RO
	R5wcColq/P63TWG07ipI6KJS939jLycFFhXz8Cw17C9doOaSzklbpadTW36j3TFWIrM41emV3R6
	FnFvwn+uh2XDfOGmZLQgPZ0P9wYAkrQ8LnkrFWRbIyjMGSAYK9+bZU6xDb2fxMQJnSasSD7jR/0
	oGXh8eKqwoabrZHroONWoYfaQ3cg4NoxGa/54p/A4RFdPYvph+RdRVcOKRrcpN0BLYsk9ZPUwQk
	Qu4snROQ2vriskY1oGMTgY7w==
X-Received: by 2002:a17:90b:3d8f:b0:36d:70c8:3a3 with SMTP id 98e67ed59e1d1-370f0772dc6mr20194883a91.15.1780996217258;
        Tue, 09 Jun 2026 02:10:17 -0700 (PDT)
X-Received: by 2002:a17:90b:3d8f:b0:36d:70c8:3a3 with SMTP id 98e67ed59e1d1-370f0772dc6mr20194847a91.15.1780996216828;
        Tue, 09 Jun 2026 02:10:16 -0700 (PDT)
Received: from [10.133.33.202] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36f6d109dcdsm20890722a91.9.2026.06.09.02.10.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jun 2026 02:10:16 -0700 (PDT)
Message-ID: <5f74ad99-87ee-4d21-ae26-80dd462d98f2@oss.qualcomm.com>
Date: Tue, 9 Jun 2026 17:10:09 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/2] dt-bindings: ufs: Document static TX Equalization
 settings properties
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: bvanassche@acm.org, beanhuo@micron.com, peter.wang@mediatek.com,
        martin.petersen@oracle.com, mani@kernel.org,
        linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Matthias Brugger
 <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
        Zhaoming Luo <zhml@posteo.com>,
        Ram Kumar Dwivedi
 <quic_rdwivedi@quicinc.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
 <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support:Keyword:mediatek"
 <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support:Keyword:mediatek"
 <linux-mediatek@lists.infradead.org>
References: <20260529113338.984301-1-can.guo@oss.qualcomm.com>
 <20260529113338.984301-2-can.guo@oss.qualcomm.com>
 <20260529-neat-bright-shellfish-eab5e8@quoll>
 <ada65ce2-6736-44fe-9396-d3ed632274ce@oss.qualcomm.com>
 <b445e9e3-dfda-45d6-bafb-a2deb3357144@kernel.org>
 <7d49742a-7602-4f58-8dce-7e02664b783c@oss.qualcomm.com>
 <64bd6272-6111-4ffa-8a4a-366d0c287693@oss.qualcomm.com>
 <87c9f8cf-1300-4dae-82cd-fe6427649cea@kernel.org>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <87c9f8cf-1300-4dae-82cd-fe6427649cea@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=H+DrBeYi c=1 sm=1 tr=0 ts=6a27d879 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=uOah4UoORehCN5dyJioA:9 a=QEXdDO2ut3YA:10 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA5MDA4NCBTYWx0ZWRfX19v9VEVwSwzr
 IRTBU0t/7sGRqekrG4MNN+6po5yOqzKQyrb6p/wZKlF/IdpWcyt6R/Cqf8wx0Ac6brYokWTT5Ck
 BAPthtgcE3zFKu+tG5JppRLLkfGDIxF8d3nuLJcf2q7kcEe7if4crV5wB6HDP3LrGA42SNZWcY9
 anh2/L8SMjQf1sEfUk73liOdi0deLdk5RAKp2COJa5eQLEl0tmy1MlnpcHoXRGLEMoALKTkpBhI
 TojOL4UKRW0FDjCa7QOsCMJgxqa5UDoUjJrm82hRiuRBFhcQ4kKsozFa7FsIZzmhzOS8MNbZB7q
 S9+dB9X4Fe7dMJGIJF+IPioD099TePrGYBeERK4A4AipjaqvdqLaHc5zLmP24ivyJV2fb7CdASP
 i7Uk3d6Jr1scdEnsPdRtdxxa2NS2BmZrieuWz1BqMx9SNG/TVGVgFUXbpHKV+gkiyAgwnMrm8KS
 YhzjqpH3INYAxHZqIqQ==
X-Proofpoint-ORIG-GUID: 5B5XpKQ8azZj4er9nK7AJjgOhU067hq0
X-Proofpoint-GUID: 5B5XpKQ8azZj4er9nK7AJjgOhU067hq0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-09_02,2026-06-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 bulkscore=0 clxscore=1015 adultscore=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 priorityscore=1501 impostorscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605210000
 definitions=main-2606090084


On 6/9/2026 3:08 PM, Krzysztof Kozlowski wrote:
> On 31/05/2026 06:48, Can Guo wrote:
>>>>> is the minimal encoding that covers both.
>>>> Again, why do you need to encode '0'?
>>> The tuple is still needed because Precoding is configured per
>>> transmitter-receiver pair,
>>> so each lane has two independent states:
>>> - Host_TX -> Device_RX
>>> - Device_TX -> Host_RX
>>> A lane-only enabled list cannot represent directional combinations
>>> like lane0 =
>>> (on, off) vs (off, on).
>> How about we split into two properties, something like below?
>> tx-precode-enable-g6-host-lanes = <0 1>
>> tx-precode-enable-g6-device-lanes = <1>
>>
>> Only listed lanes are enabled; unlisted lanes are disabled by default.
>>
>> Are you OK with this approach?
> Yes, I do prefer this, because we don't have empty entries (<0, 0>, <0,
> 1> ....).
Thank you for coming back. Sure, I will use this format in next version.

Best Regards,
Can Guo.
>
> Best regards,
> Krzysztof

