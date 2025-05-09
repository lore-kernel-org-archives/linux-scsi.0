Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7442D2153D3
	for <linux-scsi@vger.kernel.org>; Fri,  9 May 2025 12:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746792056; cv=none; b=IuBkYe98eiw+wFuykp6I0Z7kstvKeBwHcqsA+Ik5eGbUpt6zWh5BSDXsgZe/RaUW3/4m8wt+VQJREQgEumcUZiE0eqJviTG2kKaB0r1fI9SH1YsCqz1nLkxr9+1gKr7l4EXSV2HEKPR+oGG9DlmU/khYkuvHkycxvoEJ+dcfes8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746792056; c=relaxed/simple;
	bh=CTpdoO5TbmQ/J6WOyrtODpc6JRorFNNAbqWDwZwQxTY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OTshd8ZzoRh8Dp9UNTHoZU+duluOpb3bLTRnmRd3H944KsdX0AeVRw5EP6e9Ly5w53oM6R4tGuhJeqZwkTI+jiIV1Lva0xjzQKoKlGacBTsC37Fk9TUHPd+wI6n5liSJXM5wECCMJgErwuKkP/bJHYvQCGKIYcF/m15CjHK0IRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=IUxxbiCG; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="IUxxbiCG"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5493u22w016151
	for <linux-scsi@vger.kernel.org>; Fri, 9 May 2025 12:00:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	uhmvCJtCideJcLgLP8CeF1xAYGZD1D5hleQo38GBvLk=; b=IUxxbiCG03PZNCJV
	YaI7VA8I79XU4D5JqXf9xXZR+JZvDEk4qrIOFgr953VYWX/7GkFjO3kLn2Kbgayw
	ufbdGPXSgXMATpkvqmB2jnqxwdXTpybUpNr5y8uqhYa+h+RZsIX/1WKOhyhGQz3M
	EVvLrgtUKsPtCZv6QZeAiK32h8JLR87RpVfobQjPce8euclRhJBBBVky6jfHQ3ST
	bx0ZYp73OzleD5jporkniOYUPlqEDWJMeBs0wsMW/XjDik5Au0J+3qcBKfVCB9gv
	LDUtHbHHX/tE3kYj1pimJtNSWLuhqW6h3n6JY9ikzOTSSJMjW9vCKXwXNUyhUKB7
	3oYkNA==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 46gnp8vhf3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 09 May 2025 12:00:53 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7c5841ae28eso47755485a.1
        for <linux-scsi@vger.kernel.org>; Fri, 09 May 2025 05:00:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746792052; x=1747396852;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uhmvCJtCideJcLgLP8CeF1xAYGZD1D5hleQo38GBvLk=;
        b=OVGB9vUa5WlWe7SerQ1fpOhYxhykj1bwC44GWEYGYPi817B5GfwpB3Awp5pw/nHX+K
         eBQ/pq1Aa/2QSUmHZ5OJyxneSVeZtCaMNDIV5QgJBCzFTlP6hH/joEQZJO5wSQxcuAsD
         x5TG/R15Dkev3Cr5vLx5P4UexLg3BdNGwuNsIH/vjImWAt6pswIwffFMlDFbwj5mKN70
         fZ3/pLDNoWvx96cUpXLlOf3ZKXNqrNp+1Yk096ExMjkNG3+lpyv+qoHhLl9Vl1kl2FcA
         SuAxmBs33/z+b8na3+kzDoHGWil0Md/9E8fGI1uWdCbYVyVMReK8mpj212hPayIKSC2E
         BEiw==
X-Forwarded-Encrypted: i=1; AJvYcCWBTiz5LFVQ2ZljvR0YgRRMfhypiMs9iB/Zn7ysCtZWcteVdW5+Z8/wk2PfKFiL7/bEOd4W+bshaeyz@vger.kernel.org
X-Gm-Message-State: AOJu0YwXoKqlueUx9oI5GgUcwT/IeWqGzak/sXdNRRqmO47rKjnNfBGU
	h3FFyuCzHR83OshxVEZFxOnE5DQJhNIJrP4fbwKOl0xNkilF/22SD/RkxkjlR9A3MJ2KU085ePj
	IDNGcrzlrcXrW9kYyon7RoA08AdbgldWyenX4OY7nvW99eSQ5Mik/XWULTTIq
X-Gm-Gg: ASbGncuVeCC+xaZO7eq+H7TsSsZz1mU1MbYKrFL57gwSUvvhvjLydxGwc/RjuzJyzYa
	mIn10JXFMEA35OkCd/mAwABxVsnVUopGJZ69K2OqLY8Mb6z4+MjuXdv17PSGq0oBMkjBdAq+pxE
	CNjPXUEB4vjOeFYnZSAHKLJCQ1w7aBovuR5KKI+sFolRmOFgXcu151eoRnJoz3t+Bf35elfOgWX
	v+Zp+FoGs5vWUB6LBrAQsPpqgrGZl7l4b/ZH4dI/7HFFbeDd5orRSZ2rP+sJLdLT12F9ZOd/r4y
	ZmhuDKBpwcRhnCWk+x+4PCBJhjbX72uAWhOljmU1X2Da09a2B3mO91NvZ3ZuirrNLnQ=
X-Received: by 2002:a05:622a:30d:b0:475:6af:9fc4 with SMTP id d75a77b69052e-494527b6a6amr17803881cf.12.1746792052255;
        Fri, 09 May 2025 05:00:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGA8qG9PHS4hQuDEdHbS+SHA5v9z70KPJj7sce2vVbNBZDeYH7Q99+EdTOoVi9pAiRgZujDlw==
X-Received: by 2002:a05:622a:30d:b0:475:6af:9fc4 with SMTP id d75a77b69052e-494527b6a6amr17803571cf.12.1746792051608;
        Fri, 09 May 2025 05:00:51 -0700 (PDT)
Received: from [192.168.65.105] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5fc9cbe5133sm1277192a12.11.2025.05.09.05.00.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 May 2025 05:00:51 -0700 (PDT)
Message-ID: <4a72ea06-22a8-4f8c-92ad-b5b3afa25b70@oss.qualcomm.com>
Date: Fri, 9 May 2025 14:00:48 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 10/11] scsi: ufs: qcom : Introduce phy_power_on/off
 wrapper function
To: Nitin Rawat <quic_nitirawa@quicinc.com>, vkoul@kernel.org,
        kishon@kernel.org, manivannan.sadhasivam@linaro.org,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        bvanassche@acm.org, andersson@kernel.org, neil.armstrong@linaro.org
Cc: quic_rdwivedi@quicinc.com, quic_cang@quicinc.com,
        linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20250503162440.2954-1-quic_nitirawa@quicinc.com>
 <20250503162440.2954-11-quic_nitirawa@quicinc.com>
 <58d913b8-0715-41b0-883a-423f29cb5a8c@oss.qualcomm.com>
 <be69cd1e-c04c-4976-9be1-390631316d3f@quicinc.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <be69cd1e-c04c-4976-9be1-390631316d3f@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: cIkSg9y1Z9GhGSrnbaJoWqvYL3yppF53
X-Proofpoint-ORIG-GUID: cIkSg9y1Z9GhGSrnbaJoWqvYL3yppF53
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA5MDExNSBTYWx0ZWRfX+z8jA26Q0ZNb
 wsZc89MmNUUcg1CuoarnqAMplIBdU+iM3cUummfIhhTD3VIww+cWnibHAljY7ge6TzmX4bSYKDa
 FixL1nR8GXuAFG5qbNsKlNphuZ2QEWu9kzREj61mRsexxrDCHMA604+PibVZIbBZnpV4i6sZA/A
 /tWKFtOAMOWa16QFHsMJthLrSYT7Z0gsmn7ug8fqWMjbzLRHr3sce1lFKfc/Ihgj6ykQUs6FTr0
 gP1ls/8G6J5ZZ/mNitp3pp/OEH52omBEw9dRTVFHLefFGivJraQHLlwY1bblWuX9EPrYFFBWWau
 dOSJgVR31pC8xuATcdqt+tV3JBHXW6wq0DI1TVrbns8AadXViAZkmyZ8YNkBw+4/+eppCuVY19n
 nO9FdadzY1c1YCNYTkSwlvS0A35pIJt7Zp+5k/M56JpUrfiW20z1YJgn6xakoN3fgVT5LpKD
X-Authority-Analysis: v=2.4 cv=e/4GSbp/ c=1 sm=1 tr=0 ts=681dee75 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=COk6AnOGAAAA:8 a=ZEsPLPZzlgAfrG_QwPwA:9
 a=QEXdDO2ut3YA:10 a=PEH46H7Ffwr30OY-TuGO:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-09_04,2025-05-08_04,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 adultscore=0 phishscore=0 clxscore=1015
 mlxlogscore=850 spamscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0
 mlxscore=0 malwarescore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2504070000
 definitions=main-2505090115

On 5/9/25 1:49 PM, Nitin Rawat wrote:
> 
> 
> On 5/9/2025 5:07 PM, Konrad Dybcio wrote:
>> On 5/3/25 6:24 PM, Nitin Rawat wrote:
>>> Introduce ufs_qcom_phy_power_on and ufs_qcom_phy_power_off wrapper
>>> functions with mutex protection to ensure safe usage of is_phy_pwr_on
>>> and prevent possible race conditions.
>>>
>>> Co-developed-by: Can Guo <quic_cang@quicinc.com>
>>> Signed-off-by: Can Guo <quic_cang@quicinc.com>
>>> Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
>>> ---
>>
>> The PHY framework does the same thing internally already, this seems
>> unnecessary
> 
> Hi Konrad,
> 
> Thanks for the review. There are scenarios where ufshcd_link_startup() can call ufshcd_vops_link_startup_notify() multiple times during retries. This leads to the PHY reference count increasing continuously, preventing proper re-initialization of the PHY.

I'm assuming you're talking about the scenario where it jumps into
ufs_qcom_power_up_sequence() - you have a label in there called
`out_disable_phy` - add a phy_power_off() after phy_calibrate if
things fail and you should be good to go if I'm reading things right.

Please include something resembling a call stack in the commit message,
as currently everyone reviewing this has to make guesses about why this
needs to be done


> Recently, this issue was addressed with patch 7bac65687510 ("scsi: ufs:
> qcom: Power off the PHY if it was already powered on in ufs_qcom_power_up_sequence()"). However, I still want to maintain a reference count (ref_cnt) to safeguard against similar conditions in the code. Additionally, this approach helps avoid unnecessary phy_power_on and phy_power_off calls. Please let me know your thoughts.

These unnecessary calls only amount to a couple of jumps and compares,
just like your wrappers, as the framework keeps track of the enable
count as well

Konrad
