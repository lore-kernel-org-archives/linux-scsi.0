Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E296223DFB
	for <linux-scsi@vger.kernel.org>; Mon,  6 Oct 2025 10:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759745703; cv=none; b=RLGW0WuMweDfnra6einSgneMZ2nhuo7/+hQ3Xbtkkmkhsm/gLMd3YnVrBfMs5JwCAPgIeC7AAPFNXYho3cvMgtuT3J09jh22lxncJdvX1ztcYa5wB8QZbBeEjWx2zN5YzwQSH1TNKac9SI+tYJqsYt5mbNaEYpLWpMhsoDCZQRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759745703; c=relaxed/simple;
	bh=+lCoSswREYBVYg7PAwHQiojcdE4ZRJ/ZZspRoClzGlA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z4oJ0YgdUQIQKZitpqDmKYiSGdsr2qecutOkzrNII3lMnOOAWBYvcJnd0xCPCv+LqenzCGtbQfwGfsy3qQQ3dNf9fds1dQGegoBL9+ZB8dqMQMPIZt99Kj6P+ENHRnQpYZ6mLxl6X8Yxn9/0dlGKUY2Z7wD7IZQIo6NTJaqVqrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=TS8QOqeg; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="TS8QOqeg"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5960G584006260
	for <linux-scsi@vger.kernel.org>; Mon, 6 Oct 2025 10:15:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	aIDY01NnRK3ZSR2DKX1nbVIhaDa8uzVxxaZaHb2mwZs=; b=TS8QOqeguDZh9Glg
	J+LrqbpRc7WdvzTGHd2wDv3yc0JIh33yU1K6pDcMUhgBdIwB91FQFcRtzlwjMUoj
	TZtRT0+MPqkwGVvmNAGEWayNV7Ajibq7K+BqxMpIkpKElDvqu18gwLdUf8c9QxMN
	M0hMBCGtcltvUsiAe01UKg7TSxl+HOAy/qESqIcgUs1gIRyNsL1wIYauPl6LuOrx
	gOq/8Yh7Avk+/JrRqHTXcQ6ylj9/66sVEekNWYZKJxF2pC6InubI6XUXfcasUrkL
	/qLeG73Dq1uI117JWtR20D3njYckp2OI2lQFqJIeoQ9WNkxic8lCH/KKoaPw81JO
	lQHnPg==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 49junu3k4r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 06 Oct 2025 10:15:01 +0000 (GMT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4ddf2a2d95fso17379051cf.3
        for <linux-scsi@vger.kernel.org>; Mon, 06 Oct 2025 03:15:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759745700; x=1760350500;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aIDY01NnRK3ZSR2DKX1nbVIhaDa8uzVxxaZaHb2mwZs=;
        b=ntRoCK36gwbXqWCblcb/PYng6gs8vteLBuCJqjpUcC9RKOduJEbsAKio4/p/NVKUfm
         yAfLITeyoe141EgAHwZ2DvtcK9rf+g3Jo4CszoIJNYnHuyZQHobYzY/XmxyDnkUbPMCR
         uGnm3WXLMSD9JrAH0CFeZm55SmPNAwoikYY1DaiZRVVoTjRzupe6jxurIRpDxOvJ+sAR
         xCQCJI1H/Qbh/+JDvWFgaZ6/17eGtER7dbwb3BXhgDJMMJIziL1qhMbxog/RST2h1N16
         kjop8i9sHPTM/cMnxdxke3uUrj1MjnbHoWqiWGECK95Ln/Dl/pMRZbEpUbFDK/7ADEk5
         ua5w==
X-Forwarded-Encrypted: i=1; AJvYcCVoklEnM7uA86uEjWwzKns/Xmp5ykmNImQIUOD9Z4RNiPOrdthPvi0Ak1FST/h9AVXb9YljQpxI/gvp@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/1Y5HyiAg/V85Eddm6C2fzFO08FNbhcgns5mTDNmvkztbvuL3
	cjysojgqSXSBP6Y5IkeBDlG/5HGP7GxlhIctuK0ttvFiJEEUTe03CuHZHITmrR3GTwoXPgETlSh
	1wlui/gLg1vBCc6C6hQAzxYpGBH1mX0VGLVnA0u0CHL6mwf1j3BHigzLMgRStxDhNZL/lafct
X-Gm-Gg: ASbGncsRFnkOQoHsaZeLD1zj/OS0aaHZ1cWESxT3oadDeUfIxJPwBrdiPhdcCz27GA2
	nxQp7OwNKd3dcDMf6dZjKzHzTk4wtL8ln+pMAPrzISN/4z0PhWmV3pYccxmYo5zxim6hZWyqght
	Ve0i/hfunuWZReZyVu9oQ6Fgxol4O447dTQdDSg5W9fI+fzDtoRfJP2jJzYt9tDaMSo8Rck3/Cg
	AuCsnImKipwVvjmHN5apZGN3swiete4HPUAWjNdJCfv1/9bA0Qw6dWTMCt3e1CPr91rdSkyqaq5
	ZBB0QgQ54AJs7F9riavO250bpNKo68eJ2ytRZtg7Ba0iCIBbQs4BNcDm3e7NN4G0DYvbb9tCuie
	gukx7CVYc8CV1Wf7tBqNTEfrP+mA=
X-Received: by 2002:ac8:7f55:0:b0:4b5:e9b6:c96 with SMTP id d75a77b69052e-4e576a6332amr88117921cf.7.1759745700015;
        Mon, 06 Oct 2025 03:15:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGBeef8DRHG2bi/HP7Cc1oF7kqYny/jUEdyQyquytu8JqFxYlckOVY1l/33cLCYd16NUFWYmw==
X-Received: by 2002:ac8:7f55:0:b0:4b5:e9b6:c96 with SMTP id d75a77b69052e-4e576a6332amr88117651cf.7.1759745699533;
        Mon, 06 Oct 2025 03:14:59 -0700 (PDT)
Received: from [192.168.149.223] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b486a177c62sm1096835866b.91.2025.10.06.03.14.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Oct 2025 03:14:59 -0700 (PDT)
Message-ID: <a2c3eeec-b3ae-466e-b289-991b8658aaf1@oss.qualcomm.com>
Date: Mon, 6 Oct 2025 12:14:57 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] soc: qcom: ice: enable ICE clock scaling API
To: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20251001-enable-ufs-ice-clock-scaling-v1-0-ec956160b696@oss.qualcomm.com>
 <20251001-enable-ufs-ice-clock-scaling-v1-1-ec956160b696@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20251001-enable-ufs-ice-clock-scaling-v1-1-ec956160b696@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: 2tYbOt2k63uW5LIIIarnlOOeeCIrwkwh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA0MDAyMyBTYWx0ZWRfX0GvE86iGg61Y
 BAq4zgu4gxru07bSt6N83kUnX9Hb1KMV4AQPA2SnidHeNpDNXNLI4lIq1tOb/GTRU7+GLYozvFS
 aOZKCvSuQwesveAIJG5xGWpdPBwbTP5wqhFwyql0c9/5Lri/j+B6M6Z2thz3RdZMr1xpu22YTWg
 rHui3tN801jLP0s8yIa+mBS4uCK7PB023XdCD6lLAze/SaR/tBbqqNFKJoEkUleAbSaUBK+J7Ty
 e4AtM9NGNaB3E29FlU6t3rTMi5QAOx7KrdRByaHXZqR+PrrrUxgsIett0IiAFXl0LiyG4Ae2Rs5
 n7ko3IwWDBYm8GT6TxzeGgC+Z8BuyVkxnXG/ohR5+UfobGiXp46V/HXK03G8NYgOLxSwiCrnbOZ
 aynfh3BnsgNQB8V8fQIcDeGjHZRGbg==
X-Authority-Analysis: v=2.4 cv=CbIFJbrl c=1 sm=1 tr=0 ts=68e396a5 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=EUspDBNiAAAA:8 a=7E7N79Lt4lT18EohOwQA:9
 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-GUID: 2tYbOt2k63uW5LIIIarnlOOeeCIrwkwh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-06_03,2025-10-02_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 adultscore=0 suspectscore=0
 spamscore=0 priorityscore=1501 phishscore=0 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2510040023

On 10/1/25 1:38 PM, Abhinaba Rakshit wrote:
> Add ICE clock scaling API based on the parsed clk supported
> frequencies from dt entry.
> 
> Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> ---

[...]

> +	prop = of_get_property(dev->of_node, "freq-table-hz", &len);
> +	if (!prop || len < 2 * sizeof(uint32_t)) {
> +		dev_err(dev, "Freq-hz property not found or invalid length\n");
> +	} else {
> +		engine->min_freq = be32_to_cpu(prop[0]);
> +		engine->max_freq = be32_to_cpu(prop[1]);
> +	}

As I suggested in <fca8355e-9b34-4df1-a7e6-459bdad8b1ff@oss.qualcomm.com>,
you should really use an OPP table if you want to do any sort of clock
scaling here.

There are then nice APIs associated with that construct that won't make
you pull your hair out..

Konrad
