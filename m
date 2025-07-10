Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F3A24DD0E
	for <linux-scsi@vger.kernel.org>; Thu, 10 Jul 2025 12:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752150425; cv=none; b=BfTA8qvV8+cUf23r9cwhKMW+KQrPmqu81mx8UWOULHC6lwcmwZAh8PY4f7h0zPoHlCRAUZZAU4VlriopkTLDUT9OZyIlSysmC4BzNdoxQiq1EmDOOWGkGBSVVnpAbKiCNriufwnQUr78TtWGwd1xaNxco8G3ZqIDPq/qZUVA6jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752150425; c=relaxed/simple;
	bh=FGr+3z81ddvrH7/BffsfT9dYxkrFwM2vo7onaWUo//A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PjwMCPNaNVDoB0GJbM7rZmaXNwJfjr5zQpNq8CTmajt9SecfvcWDl/m+kew3e1qRjqa+5GaHgDc3A3OccQ7t7mFZ2N3BifmKMfnDbpGQw3U0r/G3IKCSYMRvtlLkrbgykuoY1xTmj3ye+Zu05oC1tob8A58l17Pw+PEOhT84IQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=eFUKIqib; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="eFUKIqib"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56A9Fxob009948
	for <linux-scsi@vger.kernel.org>; Thu, 10 Jul 2025 12:27:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/gsxZzuhHs1VQ8fIJ0Ja60LkQTuMCXNEcv0jiU2RnU4=; b=eFUKIqibmHQa/Oc3
	mOZ2IxHO79ev8iFx0rwsLYPmj+8LOzK0repIcZlCB8QJgMk8vRmxkSSArFLaTJ06
	gFk55narTCvPdmatYCLJ+/j3cL4LMUQymNWrmUaWcqAZaAekUMu7GjT7MTM6ZghI
	O4eds/ndX6NGGFjFml5pD/q9v1MEjuDurRdcvVJpZuB97tWWsIhbkKQjwxN5ziai
	bor7NTv/pwNpcug5Kmg3Spn/IU7ao8sZfAujPC2QRgrpeNB9h4MCB10FjNhWXNEh
	JVac2Mkru0gpcPtzqa59/UCnxYd0LGWTwvX/30xqeNTEnJeqj1MXRMRr3g2RVW7h
	/yrB5A==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 47sm9dvwk9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 10 Jul 2025 12:27:02 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7d097083cc3so23884185a.3
        for <linux-scsi@vger.kernel.org>; Thu, 10 Jul 2025 05:27:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752150422; x=1752755222;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/gsxZzuhHs1VQ8fIJ0Ja60LkQTuMCXNEcv0jiU2RnU4=;
        b=WGMvNqKiBCzMCKxeKX+oVljDmEgjCPvpMU+s+4HSje3uU9MgBomfT6ZtpJzTVEunZJ
         0MhT+Af1ovkKtdVdnBRnpnk0MtGzG3XMaB42V2UZGliXhry+7rCzvGotgyMzwHqAyiVo
         rgJ6rhXQjIFSJ2nEM9ZRdqusbsvBixOkGjNCDTpZME9s2vxMYMJq4QMSjA0OD4MuDPEB
         gm3yanr1yY6aJXQDUBbDoYxnNgjdg84WV2f3FZ97zth+T207YRAIc3iJYX/6JZvP9yZQ
         26PlG3BCl2skwy4qQ7alLgVzY/bHE8x1l+jg1KaqfseD1xXvzqfBuVCg+pebu0J/4FEX
         xirQ==
X-Forwarded-Encrypted: i=1; AJvYcCVkJU9M+F/C9wKlusPSpfLWp4ZVn6qRuyyJoayfZ/dKsbfpR4WZqhIA9ifgAibTzND+fW5taDFs2Wj+@vger.kernel.org
X-Gm-Message-State: AOJu0YydzLhXnYTtZ39rD+OjP8K30J0Arzv+1jYfmnGO3Sb3vv3UhNT1
	/SngXuWCJLX69w8dLFTLyl6bPpNgilL+WIcWMiHaOjGYkE7Jal/jq7oPPqOaaosaaCKhkU1/Ggg
	9CzNGtdP8QDbpSQzmt+FhWbDC3984Da1wf6RUhMrN9BDw2G2/ZyHkRoMhwBsNxq02
X-Gm-Gg: ASbGncvTempXe/Otn8dFDPQdIeJ8OYbZ8oBJ11i9X0c6OxwiVcR0HHqks5U7nyLJQQA
	Se32/lq7mSYl0KouXZ/r8rZr6mAQlg5nf9cZv7SJA02XbO0s39LiEyk8gu0OnISrBSL/tdpuhAc
	33j6rZ0Bf0t5S/4H3tgVwvO3skzcsoNrEuhqIPdIEU/B3N38P+7jj5xgV8+pSD4kfAroabrxuRr
	baDwNyvVIA+eqZIb6BqNWhQDigJ4ieGqczoEtm0Weiiu97IwqGhdT5xBX4N7fLwO0XWO4yacqw3
	xQvdgSwg5F5Uaa5B1n9205bMlTXzKjIpqxzq54ABLw8TYRMeeQ5bS9drggOH9ITmjk/6lj2HqGK
	LFPQ=
X-Received: by 2002:ac8:7f54:0:b0:472:1d00:1fc3 with SMTP id d75a77b69052e-4a9dec6ff93mr34751321cf.8.1752150422097;
        Thu, 10 Jul 2025 05:27:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG9Y+86PvXbITAApB2WEa/o9aQTNYOeca3v+/D1E7vOqMYvryP/+xVmZMto4EEa3ckQLg37Yg==
X-Received: by 2002:ac8:7f54:0:b0:472:1d00:1fc3 with SMTP id d75a77b69052e-4a9dec6ff93mr34751011cf.8.1752150421567;
        Thu, 10 Jul 2025 05:27:01 -0700 (PDT)
Received: from [192.168.143.225] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae6e7e91b08sm124778866b.8.2025.07.10.05.26.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jul 2025 05:27:01 -0700 (PDT)
Message-ID: <cc6e8ae1-d63a-4f90-8752-07251b3bff04@oss.qualcomm.com>
Date: Thu, 10 Jul 2025 14:26:59 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 2/3] scsi: ufs: core: Add ufshcd_dme_rmw to modify DME
 attributes
To: Nitin Rawat <quic_nitirawa@quicinc.com>, mani@kernel.org,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        bvanassche@acm.org, avri.altman@wdc.com, ebiggers@google.com,
        neil.armstrong@linaro.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, kernel test robot <lkp@intel.com>
References: <20250709205635.3395-1-quic_nitirawa@quicinc.com>
 <20250709205635.3395-3-quic_nitirawa@quicinc.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20250709205635.3395-3-quic_nitirawa@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: hj-x5xul4GQ8XxytPLnrC_kJBf8G2HBM
X-Authority-Analysis: v=2.4 cv=W7k4VQWk c=1 sm=1 tr=0 ts=686fb196 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=QyXUC8HyAAAA:8 a=B7Yj2uzDBv06dT-is-cA:9
 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-ORIG-GUID: hj-x5xul4GQ8XxytPLnrC_kJBf8G2HBM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzEwMDEwNiBTYWx0ZWRfX5c62fIfbAfBx
 WajAhlXNbdUJ6f5i5L/t3y+x5O6xyaWjJC8gbPUWmQvCjvTIAMZI8OAwqR9VkQtA+iS8DxW8WVT
 iyfZobrHC5460fDHU0FobDUHqvdyEYWvr4UuIAR+BwfK3L7EJDjkXLgacEGNGmXyGqq9vyu5abI
 YmiDsEBWo7Oq5s7d4Zc+k30cGvTwTCZq74z5/zUpkMJTcsHKxIwYnoSwotjl1dmhtWiyQv9aYrH
 jiccrY/j29+a2b9ps5btN/XK/Q2O7dw3hKiGBlr2b6kGV4BaHdt8mLGvPT5Y4FWI2904e1uzrXT
 +e3GxMrNwQLq423/pvIkXNn0LEbCuPlfXN2p4w7Nu28skDD3Cc9HmEBF+MOAfGLbdGtCTePhFFQ
 J2tcCtnM84HvbOW0TrRhQX7xjB5Rgssoa4e2DAnZteJIDze83HfYFWXp6lqbZoaofu+qNkFE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-10_02,2025-07-09_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 clxscore=1015 suspectscore=0 phishscore=0
 mlxlogscore=843 priorityscore=1501 impostorscore=0 malwarescore=0 mlxscore=0
 adultscore=0 bulkscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507100106

On 7/9/25 10:56 PM, Nitin Rawat wrote:
> Introduce `ufshcd_dme_rmw` API to read, modify, and write DME
> attributes in UFS host controllers using a mask and value.
> 
> Reported-by: kernel test robot <lkp@intel.com>

This tag makes sense if your patch is merged into the tree
but happens to contain a build warning/error. Using it here
makes it look like the kernel test robot suggested
introducing this wrapper

Konrad
