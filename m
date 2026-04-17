Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149A93822B1
	for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2026 13:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776432383; cv=none; b=qji+d+lVyRtNhAgIbxczYWoIo16NVoPSBzEk4HxX4hOPozeLZDcxpYA9wfQv2ZHBxrwk1NZ9mItJQ0/mprZcdD3C2ZA/ed2HBj8NqtUEomZQ/TiH/ERVkJ8t+5cGotCRgVLWFOqBoMlpYH/+lnpD707ygPY6U+OwVoBl6z/JSu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776432383; c=relaxed/simple;
	bh=nvWhLmAQi51tXuJddhdJovPsNujCVheloktZiyA7yz8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=etRXk9j2OUK6nTp3EuYKz/NzFHbUUh3I1cFe6rBNZKdcVgyQt7Fw/wCGmkTEqM09dHPYgnHC74rxi/iVi9bOLA4r3NPztoPUp5yDIEvbUPV9DGHq1fibC/nFB9Ws+FgsBjvk4vK8ESfOzjZViSVm2Ff+BhGVguTD/eXqhcuSd+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=itKE060T; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=PjkMn3y8; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="itKE060T";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="PjkMn3y8"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63H7wclk667660
	for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2026 13:26:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	P48LtR2etTVmogsXtNHlRsIqcgXE6975LXlWnojI4Os=; b=itKE060TqrdIj+Vj
	o/EajHoxmHICIh8hy5y60TML+uBCi2qQrxujM9lNnRqLKEVgD3tloLNw6IWAbsAK
	ObNDLG8H6pfeyj5RmCeCDeY5CP+X/Qq/EGYY+SqIuxVOpQRq1KDanhxUNYP1V/f+
	SbuTth8Rhmj47JOpJaIEHKcQLXhJyFhq+X8nVciQjWhJEOYka8qEXov2vDSB0Ick
	Z/S/lYvJPOfBviQzL1Nguo9o5lLugzCI0SMTA1loU0wdR7rWlnQUjB1B0QCeLv1p
	I3TtRGyeZl1Ybos7qhw3VusHHqId+LGiAZEhY5hWQBlKBWXg+6rgkkrY1LvGJZF9
	gxym7Q==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dkaxctcb3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2026 13:26:20 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-35d9f68d00fso1607632a91.2
        for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2026 06:26:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776432380; x=1777037180; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P48LtR2etTVmogsXtNHlRsIqcgXE6975LXlWnojI4Os=;
        b=PjkMn3y8EiVs9A6KALpaHVQieGnL0CNqsGki3lz9SKGuYKmBW1RocD+87VDmpjeE9o
         Y+kSPmG2c7wMB3nvzfKb3ODktj5sGqAO+90dyPSGJ1kZS/wgu14OZ/+eeXANR4HB/Cz2
         vZ9qBojbSqUkw5lcZ5jDWKaEd2bIoP4plVNJ8UDAvEo5lJTXqOQ4VP4UOFMSYtiknA1N
         Y+sUBsRBnFI0g7tDgu9ermYRUbbgSRsKVJhUiuCyvn80ThpqwXIkku4ROkuiprBQwnnL
         4ai8ChZ0cmEi3oSTmB6rh9Io9PUpPoHKc9TpJdAVXwi3l3uge7RKjZLCDAvfkvwppzXk
         V7hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776432380; x=1777037180;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P48LtR2etTVmogsXtNHlRsIqcgXE6975LXlWnojI4Os=;
        b=pNuEdk6xF1M3X2L0TSwCnTmCtOMw7YmiwRde8q/GsMc/Xx9DBl0+hPn4TwDxa5SIf6
         mW7xh7CB+SeiSH65ORAk1L/M8hfkhFgEN81Hz79g2fvm7YeV1uLsC/l9Aqk0vLJ8/DtZ
         hTT36QVMBPOUIeZYjwFPubu2FIwZz4AYtSEL8Ugo0hepeSUOFoUpHHbQtSFUTVNHp0/K
         9z3GsLOSWh7SLhPbkv5qqgcAXQDq97FTD2WAUWtyKuoly3xlP5f0p5ge+AEWbtwGlbmc
         UIBlafh2BKzyqe0NREDbKzrYC9XDqSlrpD7a+eCLaQwOwIiNnIbLQdH69zemoVJCARBm
         7grw==
X-Forwarded-Encrypted: i=1; AFNElJ9YMk8RSfknYXT7l1JWpPN+OgaUCNt1RugkH2P13C3s1M3EttBcds5TzWxDaIgSt453Suqa7VrCgvhR@vger.kernel.org
X-Gm-Message-State: AOJu0YxfBIWeZW1yyyhip0D62Bphb26bAhV1wq1gs6sdsCBhl+wnjzCj
	6e59kQAzylZW8+tVTC0RwHo6941PEI9oos2VpSYEql+3zFKXU8vZZgKwO3ubHY1Wv7+92tH3aDF
	tAEk97uo+JkHHeS/eew7IVjYdfQQtFn1Neog7XEqCdqhVHB50Lvw8yC/KXwB3JEDs
X-Gm-Gg: AeBDiev6GOjIsQ8lfMhTT4kZITDJ2J53L6OlwKhcc8Gr7y+CX9rKA1ze51AGJ4/5kLU
	TgkX7ZRJEvXo9gSBSB3s+e6ObaIief6pf9d3659XIoo3kMhhGPMloD7sXE+fimM2efMfYkmVbom
	aYMm/YNqqyVeibDGVqXGIDj+t/v0293rGbGfPzbiWMN0HIe29aW3bybe9eONnNWbXcLOzQr8M5Y
	NauEezAvv3hIq6nMDbtUNXPsRPVF8ipBezKRfMyYf43LCJ/M4AdEKKUsXufEwToCUPP/wQA65pl
	mP7QNuaWIZHP06BaWcTK30QfDWIBPKVcoODn2wo9rn1A7q9GVDqoyS2oi+CMxzbQBY99nFi8Zhv
	wGEoNFHID/lrAGPyeB+NCA6Kma14mnU4NIkIoEq+QhjvWFPkoDKOinPW1ptzvdw==
X-Received: by 2002:a05:6a20:94cb:b0:398:a1ca:7a2a with SMTP id adf61e73a8af0-3a08d934591mr3536955637.48.1776432379822;
        Fri, 17 Apr 2026 06:26:19 -0700 (PDT)
X-Received: by 2002:a05:6a20:94cb:b0:398:a1ca:7a2a with SMTP id adf61e73a8af0-3a08d934591mr3536923637.48.1776432379243;
        Fri, 17 Apr 2026 06:26:19 -0700 (PDT)
Received: from [10.217.223.121] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c7976f9da4esm1482503a12.11.2026.04.17.06.26.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Apr 2026 06:26:18 -0700 (PDT)
Message-ID: <73928b30-a0e9-4e94-9273-9d21c6045079@oss.qualcomm.com>
Date: Fri, 17 Apr 2026 18:56:12 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/3] ufs: host: Add ICE clock scaling during UFS clock
 changes
To: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20260302-enable-ufs-ice-clock-scaling-v7-0-669b96ecadd8@oss.qualcomm.com>
 <20260302-enable-ufs-ice-clock-scaling-v7-2-669b96ecadd8@oss.qualcomm.com>
Content-Language: en-US
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
In-Reply-To: <20260302-enable-ufs-ice-clock-scaling-v7-2-669b96ecadd8@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=JcqMa0KV c=1 sm=1 tr=0 ts=69e234fc cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=moC-RjrLiBHrLYWkWSAA:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE3MDEzNSBTYWx0ZWRfX7eMoCBjQaDCh
 9MbvfOv65Q/N7cW7Cyzwe5YjAI2F40lB/IdsalKUBQ36+1kMkwxJ2+tKas7iKsrkc6116bgDl21
 IGOXVTSg3V+aHYwWdzi7Dcjz0oimqyvHlctE635KA1cP6RyMO90CbgcOS2qitoV7gmkt716Lody
 js7jAwmFpkUg4BH/s+ji/SJxsheeFoI0lsLtyygsWlNFP1F1YZlQ1GyFQh5RjKf9qoko5DRjNWt
 orrRFfCJ3xkAljuXrs5xPx1cAUkKlUELiX4YqATKOB9u+/hBxQD7Sjb0bDYCfjvv8DhW+10odou
 y57AwJnJqLWV2IAcp89hgAjape9Z33DSIHjhv/wTam81YnDVjg4zNDA9n8ViSzLZUh01ujgPS1N
 M/NiZ6ryD08gUxbmL0Fb0LlUI/Evwuuj9du/wtkN2vn8qVmX2VzmEvuUtvBNrpI+BgnYSBU/Ed7
 MbqbOaFEWJtZaZzsicQ==
X-Proofpoint-GUID: a3qfB4YHVGQSCkzLGgQ9qChRaj4PGsS3
X-Proofpoint-ORIG-GUID: a3qfB4YHVGQSCkzLGgQ9qChRaj4PGsS3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-17_01,2026-04-17_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 clxscore=1015 malwarescore=0 phishscore=0
 suspectscore=0 priorityscore=1501 impostorscore=0 lowpriorityscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2604070000
 definitions=main-2604170135



On 3/2/2026 4:19 PM, Abhinaba Rakshit wrote:
> Implement ICE (Inline Crypto Engine) clock scaling in sync with
> UFS controller clock scaling. This ensures that the ICE operates at
> an appropriate frequency when the UFS clocks are scaled up or down,
> improving performance and maintaining stability for crypto operations.
> 
> For scale_up operation ensure to pass ~round_ceil (round_floor)
> and vice-versa for scale_down operations.
> 
> Incase of OPP scaling is not supported by ICE, ensure to not prevent
> devfreq for UFS, as ICE OPP-table is optional.
> 
> Acked-by: Manivannan Sadhasivam <mani@kernel.org>
> Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> ---

Reviewed-by: Harshal Dev <harshal.dev@oss.qualcomm.com>

Regards,
Harshal

