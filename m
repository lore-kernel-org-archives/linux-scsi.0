Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACAD27A925
	for <linux-scsi@vger.kernel.org>; Fri,  9 May 2025 12:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746792383; cv=none; b=sTABViU+HoAtJwitOfZ4B4sDA/ubKc4inTSvP562OE3lDG/eIxrCgcf4nIYZk+tEBodaWlsyu2/B1y2Z56izakdEU5uXuA3FTiC8L119pDmGc0sAVRpi4T6PXZExh/A+CRyT4KGGby/KQGIro+JTFNE63vB7Xio+uRgIXUuZ+J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746792383; c=relaxed/simple;
	bh=96Tg58Lc+vMRWzL00RdF0preMK39zEFWmb1QusjV0vw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uzu10AVhPGzb7KlN52GMOgUzqHSjh5HoI24vbLfmHBOKPTOI60fG5apF59NmC/9578dKMNiMIDXnH5ap0mSNykkloPhhvYQgPVMDhJ8uviovq0nchqBUj+oyV6bn0TYm5wdelssBwU4PtQnUHGXnQkgKFS8MefT+yZxchTzKQVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=JUuXKYHL; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="JUuXKYHL"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 549BwV4N010240
	for <linux-scsi@vger.kernel.org>; Fri, 9 May 2025 12:06:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	VFG5Da+YfOlVw9RRbBfTzV9AWaQl9DWU8KlZRXqpzfA=; b=JUuXKYHLxyincbcH
	3IGZUI6NarqsJFKHAkE9EDmhzizZVQ2IR08pkiGbNr2KAFQNrnEXgmYTNlmb3Bnx
	L0/eaE/pzf+yeN1QyIp2dRsDa7fhhIBi0g+E8VSFhoYifYX9l2KSfw45QUMk/+3C
	zZiVoKL42bV7C5S2m2RezcPr+Dr/MyQ6FNW7XFEQoq2svb13zA4bGAjnZmPdu2ll
	tmi0asOc6LfdH7cwiThVAfoKhfFMtz+aZDp9y6OOf2q3pSvipJWwmM3lqrsFw/w0
	YvrcOQzoVvoxkQV79s+WyyltceWdfBZpLjishapJBDeHIxHK5E1pzKxnCsl2pESl
	U1Vl9A==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 46gnp7cnjp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 09 May 2025 12:06:21 +0000 (GMT)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6f6e71d6787so1907926d6.0
        for <linux-scsi@vger.kernel.org>; Fri, 09 May 2025 05:06:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746792380; x=1747397180;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VFG5Da+YfOlVw9RRbBfTzV9AWaQl9DWU8KlZRXqpzfA=;
        b=vDH2MBMD9U/z9ZvC5aLTriZviyQB1OKpd7tbsvQkV2f8CiihwdLfF+f+W8TsyS30fi
         pt/HjPiL82lSnjJ9EncjDOgfu6l+dK9aYScerzZzm75j1neSH9rnTxU1+wFdbzcMDkv+
         VxBthycH6sF2YHu3JXFzKcJzvKz5eUk82pMvOdYWpB10NuF6zo0x4MMpGSMuiTXvsxDT
         +CxJwMbSpVin71de5FLGea00SEKyU5n95G2axPolNRVzLOnOYDWxq+VcBN+kHYWIlWBQ
         hWuTSv6doC4LMjEvpqm42E28AwzlyHraeIqbaw5WFw3eJ7cuc/YIKZqeSrDT+gHsMx2J
         ViAA==
X-Forwarded-Encrypted: i=1; AJvYcCWbCCCSCJjSQ6tHIMY0NI/lDrAgJxmua7+6BIPccgYHb3bXPJ2KLBBuRD/uldqwWTIpg4Y6EQ1fTRj8@vger.kernel.org
X-Gm-Message-State: AOJu0YyKfDYLT2893d5SjjHz/N2V9sgZ59UqZZvlU9RCz+CsizeMM0Fo
	C7peWVpcIBVRwlLyXDAvpIqTbJTwtJgRMV7Kmwxc78zuD8c+hfMfYYyHSC63LQTFrtFWXFUAT0s
	Y1BjzgdJj7lQcM62eoIk0RnxkBq0ufWpY6CgkoAvoQsy1Q4WQ064vsZLzilbU
X-Gm-Gg: ASbGncvSVAColgBSBlQ27BhroGW02gngDfK6pys+WYd9nr+gcA+oyIUx8oer9a2VL98
	wIH94pNVtb6bWY6ACo1YK+x5B4BJrEws3KBYTgZrk6t6DLbvqL5142GLzFx8zNZfxrmpFDaaZ6w
	/ReRN9ggkirDFgl8WRl4qElB5ATY0vZ+y4+xVERHbq6heeoJ9ZnSCcjiO2isF+rtahM8LrOxCfN
	yAMXQ0PhOlEKgp1CJJ67HroOhAEe4WfTJAwLJcZm2XHZA4t4hR4g0VCwwmJlBalkN8xbOHq4sVq
	NEewuaMwl59IXhkEYH7laWPoICHJVfn2RLUxi2lMB6EV3uVxLbHOJx+uPShu3v10prQ=
X-Received: by 2002:a05:620a:290b:b0:7c5:e283:7d0f with SMTP id af79cd13be357-7cd01108cb6mr190529085a.8.1746792379814;
        Fri, 09 May 2025 05:06:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEKcBKsJkKgfMZZzUCoL4UmLzaEErHDasd9ek1N9pmcMcSpwfQinc55ChB7fmY4ymnXRybyaA==
X-Received: by 2002:a05:620a:290b:b0:7c5:e283:7d0f with SMTP id af79cd13be357-7cd01108cb6mr190526685a.8.1746792379449;
        Fri, 09 May 2025 05:06:19 -0700 (PDT)
Received: from [192.168.65.105] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad2192cc449sm140992266b.20.2025.05.09.05.06.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 May 2025 05:06:18 -0700 (PDT)
Message-ID: <7695636a-e6c8-476d-ba8e-51185a7ae2cb@oss.qualcomm.com>
Date: Fri, 9 May 2025 14:06:16 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 01/11] scsi: ufs: qcom: add a new phy calibrate API
 call
To: Nitin Rawat <quic_nitirawa@quicinc.com>, vkoul@kernel.org,
        kishon@kernel.org, manivannan.sadhasivam@linaro.org,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        bvanassche@acm.org, andersson@kernel.org, neil.armstrong@linaro.org
Cc: quic_rdwivedi@quicinc.com, quic_cang@quicinc.com,
        linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20250503162440.2954-1-quic_nitirawa@quicinc.com>
 <20250503162440.2954-2-quic_nitirawa@quicinc.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20250503162440.2954-2-quic_nitirawa@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA5MDExNyBTYWx0ZWRfXwxZ9Sf6EkaUW
 wIdWFus1PTPyo46PNWwYG91bHR8SVUlPfTiLfg0tu9dXDAKZgJrGd9mTtHwJ7lls33ILIefZck9
 1DhGLV73JMTg12sLQ4I3pOqOi7KenzVLN1icNmLovEezKQpkrx5mQ7C6jeyUeAvMK8w9sXpSHQS
 YUgwLjZH46QTGwcpTuHl6KZnGiT00AaH/mP0FKeVzLWxFGyf5p5V03ZUg5ele/TsfqasPkb+iCq
 T4UR59MOWHBTv5ZyruEEKdzlSuCmSCsDgauIVFYu7ooKSmiGjIx33uWhLOuLEZFHWHL+5mPEEnk
 4pQt6XxarfMatK8+Ovtu6Jnzc8/SGLGz9DbPDFHcxGP7NarfSg5COdv/1fdUsi8j37eGJmzyDaO
 jUhV58jqqaz4P80CMdzRoaSASM/wcApDM1YgV/XsquD4lFqFhCPJUgJoexXGM0+6OvAI83qm
X-Proofpoint-GUID: If9syuK2T4V5doVBEveYovcYMgp0v8LK
X-Authority-Analysis: v=2.4 cv=B/G50PtM c=1 sm=1 tr=0 ts=681defbd cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=COk6AnOGAAAA:8 a=Z92jOV8uMcrVojWvk68A:9
 a=QEXdDO2ut3YA:10 a=iYH6xdkBrDN1Jqds4HTS:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-ORIG-GUID: If9syuK2T4V5doVBEveYovcYMgp0v8LK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-09_04,2025-05-08_04,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 spamscore=0
 suspectscore=0 phishscore=0 priorityscore=1501 bulkscore=0 adultscore=0
 mlxlogscore=819 malwarescore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2504070000
 definitions=main-2505090117

On 5/3/25 6:24 PM, Nitin Rawat wrote:
> Introduce a new phy calibrate API call in the UFS Qualcomm driver to
> separate phy calibration from phy power-on. This change is a precursor
> to the next patchset in this series, which requires these two operations
> to be distinct.
> 
> Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
> ---

I would imagine this would all go through a single tree - be it phy or
ufs, up to the maintainers - unless you want to merge it right now,
Bart/Martin?

Konrad
