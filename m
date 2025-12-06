Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D4725B1DA
	for <linux-scsi@vger.kernel.org>; Sat,  6 Dec 2025 15:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765033594; cv=none; b=CfyE50f3+SRTXyrNfGl6PqOnrsRrEW8162TDFaJDvJ5YN+pCljyDbaTnxfPxMV3EfqPEF0mx0HMQtIFFWupi8GO2x57kXSF7Ox5e3vZaWTalOm6AgD/hW/H2mNFzmIEEDT335sQDQ1TDul4R3aBav8ZQQKIRK/m8lIyiYOiYT+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765033594; c=relaxed/simple;
	bh=O/VDjfLd0tML2jG89w3/aPu8bvNrL6ObQXCAi8w9874=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z+W8J328Gt7WJsOM5XQqyY2u9/6wdOMLNwYkp9+jg8Y7vxl3cwaDyhARq1GLJv9o2FNnBxZLkRg2zzSlVJnWljtbuQoRtI4s0JT022QQfV6hnjKlBdKESkeHNEY7YKNxpyKg12leHfXaHjoNr49qM8fe9ZhJFjS5VS5LyIN9Hnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=pjC3WCGT; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=gAgbHB7K; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="pjC3WCGT";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="gAgbHB7K"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B65Z0bm2641569
	for <linux-scsi@vger.kernel.org>; Sat, 6 Dec 2025 15:06:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	yKKJhcW5VWibGwFyGC8/WJ9Xwg5VRUIM5X7pLsOLSjk=; b=pjC3WCGTetqD379k
	Vtp9hPxArUk+m1Q2X0dxYsdkPp6zTDTJqVHmLfPkrLt2CTqb8337NvlEJJS+zPyD
	h7gLdrOC2JMNUwFzYplBTf55r4dhXsjQfdmFlX/iTU4TgG3HHidX0dCPh61/jKJK
	GKMBbnGuj0sdWA1Nl922nWbavcY1EjMbzF8MTNLMhuK/1imFklhI2o0ijRhZ0ymj
	8HE6Oln2N/xSMLiyEl5Y5+rVJ3mSzGoogrxeDjE2PN6lsi5g1Pl5CivSFnKSluZd
	5CSCElFpNRell638b2b++OzVtbdsfvNvPcSgey1GBn0A8TEERRnCWZrqFC2PiCif
	KnizWg==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4avcndrw5k-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Sat, 06 Dec 2025 15:06:30 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3437f0760daso5882070a91.1
        for <linux-scsi@vger.kernel.org>; Sat, 06 Dec 2025 07:06:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1765033589; x=1765638389; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yKKJhcW5VWibGwFyGC8/WJ9Xwg5VRUIM5X7pLsOLSjk=;
        b=gAgbHB7KZ35gbgt9GdeC5qd45EKw3Qu4TuLyh97n4X+m0hxoCKDwxpFNytmgqiZD/0
         +w1yi2vHwxSxZsMTm4l2ig7D2IU9hKqfNoDofGDPPJYa6kxMWb148/C8Ole+ODJh3aEl
         Pdixytv2C59ApL07LJpZ4C4yPeM119XVHVpgKiU/DXqqPE0ZCAwE+RvL+4kXkp7R1UCW
         1GLzP3SVsm6//Ku4or9+ObLJ6lTtUzuyH9UL4DMppBvH//ICTShno4YZQcNBU64yv1XQ
         r241Z4Mv+D0w/XYpqVKhc0EkbAXPg1ER+TfMT3iagUUoIey4AC9/tD7XI49Ofg3pwLpT
         SHRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765033589; x=1765638389;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yKKJhcW5VWibGwFyGC8/WJ9Xwg5VRUIM5X7pLsOLSjk=;
        b=sgd5Sl9jYg7T8XqLowdUjIofVq1nZDj7nrX6LNMl38qty2uK/JNuamsg80VacaFU/K
         mDzdjGh8U/VOy6YZUh5ASWsIK0jDijXtsNsKALeMzLlHQo2KI3I97BGZujFFrGK4liZS
         q7EWT5v/vxaO2SRA0S/1fKwbP/OjmPgK9RCGdQxasixbWw5TkRjt930givLYJugoEfb5
         vifdeREWGscA8kRNDVwU7jp4UShyKg8dXcdP3B6AllyjlJYlbxJgusbT2ztVmq+jllnk
         2uf/GubOIy5Ce00Z6vAmqKwI1gw3OGgy4GckrGxjaO7/d1TcOFaadCDVVWmsOet5Pvhk
         ungg==
X-Gm-Message-State: AOJu0Yzxj9kjb+MllZ9Jqw50QXBX7epKUjdy9TxPwDqsT7cTMUYB2s1m
	BR3BMLRNysU1RjIH3BpCzw2dFhWz5FB6CJXRi95cyqrh8b+vi4Nd//TgjAAY/ycPxNmZptUn0OB
	Hsu4Jf7JpMwIDAJNDsPC1swn8xw53JQ+3v9ArVnHZxyRmHwBuNi6mFezGWwnFcMpk
X-Gm-Gg: ASbGncuhBRz2WHZcAy7/+HBXv28UzC3BxOokyuOL6s4oQx/yjXoyqhCmu1Whs7u1cKI
	6LJ5toaC6tDURlC/yNvGnERYJozgkHeJQg0ouJ9Wl/5UlmCPrNv9y2eLE0TFxVmtoirA9tcz6lL
	AkHdAdGO7R9ApuT6BqvFTgEP+pc2GeDOXpEKdHU9sb/t5EpklAOe2eNf0bWO7eZitm47rAmYasB
	+5sLEhi5T7o5C15ttoXQCXkgo+i8XCwtDhRJKmicTyFvOa5ZlWR1Zt55D5RUrgZ7uGtcjreWMv4
	hI1G97fviXzxPpV8uYGK1hzNKT42D2Cr9HqUD4IfK3Hh824cIozze/F9Wlk4S1Drm5u9/xqYN7G
	yPJNPQDKFOZTC4Kff5Zib/jER
X-Received: by 2002:a17:90b:1d47:b0:32e:7bbc:bf13 with SMTP id 98e67ed59e1d1-349a25e5551mr1869688a91.34.1765033589486;
        Sat, 06 Dec 2025 07:06:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFuuD9KT/Nr6ijTs9gXIxBZcDQim7hvLX8VC+m7oZ0xk9TKnyzMihgpQRZcHWLa3cx6WvHTXg==
X-Received: by 2002:a17:90b:1d47:b0:32e:7bbc:bf13 with SMTP id 98e67ed59e1d1-349a25e5551mr1869657a91.34.1765033588938;
        Sat, 06 Dec 2025 07:06:28 -0800 (PST)
Received: from [10.216.13.19] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3494f38a263sm7477177a91.3.2025.12.06.07.06.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Dec 2025 07:06:28 -0800 (PST)
Message-ID: <8769c248-aa8c-4944-825c-83622e71833f@oss.qualcomm.com>
Date: Sat, 6 Dec 2025 20:36:22 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ufs: core: Fix an error handler crash
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Peter Wang <peter.wang@mediatek.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
        Avri Altman <avri.altman@sandisk.com>, Bean Huo <beanhuo@micron.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
References: <20251204170457.994851-1-bvanassche@acm.org>
Content-Language: en-US
From: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
In-Reply-To: <20251204170457.994851-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: bpYAhh-SVkoYXdH0beMPt1h2rV1SzOAG
X-Authority-Analysis: v=2.4 cv=baJmkePB c=1 sm=1 tr=0 ts=69344676 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=mpaa-ttXAAAA:8 a=EUspDBNiAAAA:8 a=N54-gffFAAAA:8
 a=DVOKioj5YA4sKL_OXx0A:9 a=QEXdDO2ut3YA:10 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-GUID: bpYAhh-SVkoYXdH0beMPt1h2rV1SzOAG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA2MDEyMyBTYWx0ZWRfXzW0c3lJI2h79
 HZVnD2Ja8VMrDI/K0n/95xEnoo5mUT9YCYUsZF/qus6uhbLhFfzKyvddLqOJH51uOBoOh4gDwJ9
 Fe+Zqup0kqO1Og1biUJGAGVJ99WVaqY7Ss/ZwMpI+sonNCXIwmPb47jZdwxlSqWHVGOopSd/btj
 Yueb3YMwVpLNXv4esgRbCW+PCksmNLhz/Y9T/4Ta29eXOJ75oZtjwdySAuDIqd2EzkQhRCU1nSU
 QdmST+T/qGt/JK9lDavDItMBTwCXRMD0BldjUZcZRhI4eKe+Vk2+a5rsz38Co8NT3xNQqdAA31/
 t5VNS+oB9DxQ9JdvCXGxA4dKdn8KJNRubrKOuBm8G4s+bdbgvcclOS47nAIkEeaks6QD+dyYYOY
 ZPImf0SPrkVpPiV3kK5NZflvAbmeag==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-06_02,2025-12-04_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 phishscore=0 malwarescore=0 priorityscore=1501
 impostorscore=0 spamscore=0 bulkscore=0 suspectscore=0 clxscore=1015
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2510240001
 definitions=main-2512060123



On 12/4/2025 10:34 PM, Bart Van Assche wrote:
> The UFS error handler may be activated before SCSI scanning has started and
> hence before hba->ufs_device_wlun has been set. Check the
> hba->ufs_device_wlun pointer before using it.
> 
> Cc: Peter Wang <peter.wang@mediatek.com>
> Cc: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
> Fixes: e23ef4f22db3 ("scsi: ufs: core: Fix error handler host_sem issue")
> Fixes: f966e02ae521 ("scsi: ufs: core: Fix runtime suspend error deadlock")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Nitin Rawat <nitin.rawat@oss.qualcomm.com>

Tested-by: Nitin Rawat <nitin.rawat@oss.qualcomm.com> #SM8750



