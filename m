Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8C32E2852
	for <linux-scsi@vger.kernel.org>; Tue, 27 Jan 2026 09:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769506767; cv=none; b=XoxFScTuGpIRK+5BNT19DgV22DjCFpMky/B43XpqPBbxBEpz0CJNzZ48cF3yYGlyhgyIsFQdAAPd7Vh5BGMwJC0THPjY0JQ7NQGr0Z40N0P/vwoAJuFy4gQUOSkcv1+CUJCCf3NyZKMy/T3S4u80McplVC7jBcNOqivmKGuNvP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769506767; c=relaxed/simple;
	bh=I3s8D0ZU91T52VwzCxt8vLcmvK3I40yU4xTgHFtzys0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ulz8AbzyYjMJM700wnHadbes3kFntUieRqyY7LSxlWXAJYIgvGhAd39xtutvogG+Ep/tVOP2ZiomSxCGiphinEo6xHatsAzDo0QmvGYYMx1Ruhtr4vyC3XFEccJ4AF5oZpfqV8LxzpKurYvIxpVP83n2bYIq7gpzUxazQoBdxDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=KUqhSAIA; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Ju8wnL8u; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="KUqhSAIA";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Ju8wnL8u"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60R4UIJ9700158
	for <linux-scsi@vger.kernel.org>; Tue, 27 Jan 2026 09:39:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=lovvu2GU251dCX9r+xMYucJV
	cTWVctZ/NYUkFjYRq1M=; b=KUqhSAIAxUBNkToxY1XnlQNHTFgwlV3Pvk8UcxLO
	b/LckxauVRVfL1XUOiHjOkFHtdDeccCyxzvim8RQ1rhZdTFOuzn7wkJmcmvt7EZC
	kOwUmobdM2MrIf77igTUORceFzHj03VTour8eHselj20AzBgbBxcthqaCQpWoqiD
	tjD5xVnFKAyg05ZMP3ndzVW3zibJqnv0fzjR1/FQ9BN6K7Jm13XzX4xFaBwPakwT
	QyP9hpY7kbh95GR9oNWFsIUCPbSHmiDDTvIk/fbdh8KOI1J5+vb1XBqeTQKqNKFU
	4wczteMj78g7tan9SsbOMZkIA20INHzKf7ny8gEZ2S/cVg==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bxew3t7q1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 27 Jan 2026 09:39:25 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-29f1f69eec6so51987725ad.1
        for <linux-scsi@vger.kernel.org>; Tue, 27 Jan 2026 01:39:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1769506764; x=1770111564; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lovvu2GU251dCX9r+xMYucJVcTWVctZ/NYUkFjYRq1M=;
        b=Ju8wnL8ugmM5S8TgTt0IhEh0Bg572TgZotM1R56piYlcCaq8GmtUnegnJS+TcUUK8b
         HP/7PFCoT6bi7PgpTyg40vyvJWdSlzr5iv3W47glUnhs3pPGE6RgwkpT1IFPhRc8EL2C
         I0rxkYMUlQIjQpkBREGJe8ysUQvdsdG6RsqNpm48ep/0hacikkuEYnxguZSGdRBhz3YQ
         p4cGHYaCLIA8+RqoQAWOMWivZko9tY4BAGP1QdiIdHrqhiuPeniFn/D5+59HfAVqPM9p
         oojKFNKtzfGqQGdgt2sJXixOH08tHcG5K9nKsnPX2IVSA/AwIYchXbBCJdOLMh8oY7i6
         b/CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769506764; x=1770111564;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lovvu2GU251dCX9r+xMYucJVcTWVctZ/NYUkFjYRq1M=;
        b=HWN1LZwU40ubpMhFxzGimhC7kIPKWx01qIFfw1FWSA/oxJmXaPm9M9QVRNEZbG3YJ0
         ZupPC4dOLHiSKfzQN6XgqITnk+0ZJM+aIbtwknVzEvCUg6wKIILcNJefVCXAu5BX5QOt
         YP8x5iR13N4ZUmmA+ITzYbPOsGj03Fz7dodxQF/LbXqQrYu0HXdauSpA+Tvf+SEwrrQ/
         tIdnvYoMmKWi8tOa3ot6iZ9hlMJm4s5FVbIsyz7pMgKX39HCmVXbaSVhpEEijaqMSSA8
         7zTHs0dVz6R88UukXofqxCE/Uu8uQkn1ur+/ZkF8gFDjwNFyUNjpfLw4NWXGsaH55u52
         AQ2w==
X-Forwarded-Encrypted: i=1; AJvYcCVDOZRZi5gB7JozEGKlAJhFJKarf062JkluGh15jHg54MCNCtDPTdK07k1mpII6po878SN+ZCAJyog9@vger.kernel.org
X-Gm-Message-State: AOJu0YxuGyQKZGyN5nqGBQInqk4rVwDLj92+6PdeEjCzuD3KJDAhnW+u
	QYFe+P9pdygwIaIPKs2jWMtXq95cimsI7jWVnO74tKVBzpKue7JMqwnIhNSfLTeytuXlfJ3OsFE
	fGMMyiGTgIxIKLRTo7jETHXI2OyeAk/z7Bxq9EmphCvm9XVofWo1sYD1OZ7ZI3ZUO
X-Gm-Gg: AZuq6aLkQsv34V3+WvKwfafGJ5fAFcvKNsi2dbPPQAqfDj6Ax93LOuQHgp1dPHZA58O
	ZBej2HwS0HDyf9S5awejs+6mrcko1FY8qJZ9J1sWzGVttw/QwDvpSzk2wQOm35gq2PToYmqhXmX
	DssDhgJFvi4gyiBZ9ZW7vzsKGZWkxHEQHmxf9A7tD5IEsumfYMdLpermjCqt3gFjfW4vnyRs8QJ
	lIWLHW2SEIUbDQCUEBDYo1rv7kCkx0/EUXQSgoAg6XO+k5cMUijDOeczhzxW2wjx5ILbY0mp/X8
	1H7h4czEbJWe+xtOyq0U4ZZkadBNrwxr0k2YpBLyZk/utQgWKo4ne/aIxOorFjSziMz9ajQ3t4w
	2V3QT6Cw8LOYC9Nl0GYbS/WrpZWbZ4SAgp6Ul8Cy4PQoH7Fc=
X-Received: by 2002:a17:902:ce8c:b0:2a7:d5c0:c661 with SMTP id d9443c01a7336-2a870d4cc31mr11874025ad.15.1769506764239;
        Tue, 27 Jan 2026 01:39:24 -0800 (PST)
X-Received: by 2002:a17:902:ce8c:b0:2a7:d5c0:c661 with SMTP id d9443c01a7336-2a870d4cc31mr11873755ad.15.1769506763710;
        Tue, 27 Jan 2026 01:39:23 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a802fae223sm112148625ad.77.2026.01.27.01.39.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jan 2026 01:39:23 -0800 (PST)
Date: Tue, 27 Jan 2026 15:09:17 +0530
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Cc: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 1/3] soc: qcom: ice: Add OPP-based clock scaling
 support for ICE
Message-ID: <aXiHxepQdqT6IrKM@hu-arakshit-hyd.qualcomm.com>
References: <20260123-enable-ufs-ice-clock-scaling-v3-0-d0d8532abd98@oss.qualcomm.com>
 <20260123-enable-ufs-ice-clock-scaling-v3-1-d0d8532abd98@oss.qualcomm.com>
 <gfqpfzulzptkrbcrc2zcnqv6kmtdgwwxqc2rxnbq3rlh7azilj@srzlycd7wv4d>
 <cc89a22c-ec9d-4660-ae78-7d0323c99d4a@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc89a22c-ec9d-4660-ae78-7d0323c99d4a@oss.qualcomm.com>
X-Proofpoint-ORIG-GUID: l2R4jOL1BTXxX9wvzz1DtAxEMD2WKd8U
X-Proofpoint-GUID: l2R4jOL1BTXxX9wvzz1DtAxEMD2WKd8U
X-Authority-Analysis: v=2.4 cv=J8CnLQnS c=1 sm=1 tr=0 ts=697887cd cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=kj9zAlcOel0A:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=8kCUroivCZrBtzWfW0sA:9
 a=CjuIK1q_8ugA:10 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI3MDA3OCBTYWx0ZWRfX8Ap5Rq7K8nKJ
 SbAIl7FYDxDIDdNfHHntB2MU00Hc0lPoCqyEqR8e0q8wuTCgeasNuJHTggyYqifXlVx7xD0PUjq
 kNSFQsYmkFOsMQHbbyBmSs40QU5rRyX7BG5sBUBtawEsK+GS1z9tEr1uwtUnHF6EAFpEdKDXXI+
 x//LpmSa95+PKEy4Ljxin4iy70pTp3Mr3gIxMZd/VTT8XurmommVDJx6kTDGhAtqs4dU2iSzegG
 7r1lFcbQJJ26Y+Qu0i7AYV9EDrAj0zS1J9D8F7aFClL9PLtz4QYpN+Jc2UWmw9qc9Q63ZlzPoQe
 qJuwPuLZwQIkheHx7bk0ayb7epo5KqD0BquZLh0LCl6vLBk0mXmC1kv8zJS5Gipnu8xgE7I96Nn
 w33FRiCmLGUeNdy7RgFlWQvw/9WTiowLayi1PadyIj1bkPFFgMw8wsFspj3Jltu6d2y8sXIDD97
 zKi4tASdamvFYToJpnw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-27_01,2026-01-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 spamscore=0 clxscore=1015 bulkscore=0
 priorityscore=1501 adultscore=0 impostorscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2601270078

On Mon, Jan 26, 2026 at 11:23:51AM +0100, Konrad Dybcio wrote:
> On 1/23/26 8:21 PM, Dmitry Baryshkov wrote:
> > On Fri, Jan 23, 2026 at 12:42:12PM +0530, Abhinaba Rakshit wrote:
> >> Register optional operation-points-v2 table for ICE device
> >> and aquire its minimum and maximum frequency during ICE
> >> device probe.
> >>
> >> Introduce clock scaling API qcom_ice_scale_clk which scale ICE
> >> core clock if valid (non-zero) frequencies are obtained from
> >> OPP-table. Disable clock scaling if OPP-table is not registered.
> >>
> >> When an ICE-device specific OPP table is available, use the PM OPP
> >> framework to manage frequency scaling and maintain proper power-domain
> >> constraints.
> >>
> >> Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> >> ---
> 
> [...]
> 
> >> +int qcom_ice_scale_clk(struct qcom_ice *ice, bool scale_up)
> >> +{
> >> +	int ret = 0;
> >> +
> >> +	if (!ice->has_opp)
> >> +		return ret;
> >> +
> >> +	if (scale_up && ice->max_freq)
> >> +		ret = dev_pm_opp_set_rate(ice->dev, ice->max_freq);
> >> +	else if (!scale_up && ice->min_freq)
> >> +		ret = dev_pm_opp_set_rate(ice->dev, ice->min_freq);
> > 
> > Do we expect that there allways will be only two entries in the OPP?
> > If so, it should be a part of the bindings. If not, please design the
> > API with more flexibility in mind.
> 
> hamoa:
> 
> LOW_SVS: 100 MHz
> SVS: 201.5 MHz
> NOM: 403 MHz
> 

Understood, will update the patch-series with multiple-frequency
clock scaling support.
