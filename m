Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D4E39732F
	for <linux-scsi@vger.kernel.org>; Tue, 26 May 2026 06:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779777753; cv=none; b=aCa21xfYJmJenz/8hIzm6rroAr5Ulbqf/wmztUxYOG8en43pdq9KLvnlr3z3SAn+AnXKdGwEd8cv6yzxYEHNYPFQh4rAaRpiqu1+y5ZX5f14R0eAb51MhanIgZzeuhXoz8GVBthALB/mdj9CinYQln/pPY744+QvHNwDPr4TDSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779777753; c=relaxed/simple;
	bh=1XZvQh24NMPzJFxBym8WhWMNSuBuj21mEK2ZC6wKrQA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hl8AvVJTf9CG1oRgGAPFm77wEF0FhfMS+6ExO84HitUK2LnKSCKFKzQRn6PMJpkRkoGd9MxVs6YfyY31i3MFmiVDw4fst4GwKai2fHkYoF2NQBEvxgWYfnGpu+EEYfpljhXPPbqQIDp2HJ1nD/HjtqOsPdCaL8gLCpO/Q1J3Cso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=jo62S63T; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=a2KfJhbo; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="jo62S63T";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="a2KfJhbo"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64Q60mi43263545
	for <linux-scsi@vger.kernel.org>; Tue, 26 May 2026 06:42:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ajId4scyCctYxikVukDiATz7SBoip+pax0baHtsGRgo=; b=jo62S63TfzA59Gga
	fdBZsD/JMANgFMRtQyub5nVQnIxJuG33kzJJzmOnSx29MQmIYUJgzmQ42LawU8Oj
	xrQKCy0LU/3JvR+zVJ4rSoaVjnOB2V5DZKyrxfxPX6INP5KCxH7zdPAd+bxdLHKv
	v+ZhMFN0eF2IyBkCyavoenIC+t+FHuFo9QugkJixpyQa9htLUQ72S5MTOMGj2QWC
	s3lMBPqJhUu+jHyMzsKFLltxYxP7Ry+xvLh85RgBZxsGmWsdoSv5xLyouNLcyHDB
	DpJOkp27Nt7IyVvcTcjbqRgy5LEJtA717gHRW9fxaeokbUqU+4EMa5TC4twrxyRJ
	3901ig==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ecnhs30pv-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 26 May 2026 06:42:31 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-366ded3bed0so7242638a91.0
        for <linux-scsi@vger.kernel.org>; Mon, 25 May 2026 23:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779777750; x=1780382550; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ajId4scyCctYxikVukDiATz7SBoip+pax0baHtsGRgo=;
        b=a2KfJhboPpoAZaI4ls03SVr8gL8gR1S/18nhQ08QTysxnzkVQqGSVWDKQsKJlKiSTu
         rl21hDlG+tTDRkuliKGBB3bfJQf/tEm8lUKUb/gW6WKkwzi91qnbf5SkcAVbXffkIQbL
         bUoboMKlglruLC9L0AUcx5iWSUCYqFPEXywx0djpz66XLIiutAlAsShgGgBuwMqB0Z3I
         qpifJIfFQ5afwH76JwF/JGY4UDvyvTAyC1ZWOiDFWaRTZH4dMOCTj++Hdkg/N4czRQvN
         xXb1Gzd3aJZ9nT7RZ1rtSseTxgro8lXMzoffNlpnRLEhyvDckino/46+DwCo5A3DiA+c
         4+Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779777750; x=1780382550;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ajId4scyCctYxikVukDiATz7SBoip+pax0baHtsGRgo=;
        b=VN29p/p+59AUffk1aoUaaVp+m3KVjan3vfsjZ91LNGYO2Z1aZbyY1Cnar08pe/n5Tk
         u1/N+8B0sJCX9akm9+nMCs7AdFtjvJJyh4g5ipIeYt8ItzNefJEu16Wpz0/fQWJQw7hx
         5TFURyld48ZeujMKeiCjLTyZgpUC904QuAXWINtBrR4Qn2aCFm0K99pYBFEvh6lt1vkT
         8z00DawhucwSVhG5t/+P+zSy/YSZEy4WFwcspDGuyDugrvl7ReClsu31iDSFn3H+2I+H
         GSJVJedx3YMZ9DrM+bAfV9KAl3u4o77AS92ng72rlh6QDKSD+yNGjwWCdMhDmJu/iwUt
         2PGA==
X-Forwarded-Encrypted: i=1; AFNElJ9DqPPKouuVRDcmpJEv1nohx2yC3itK8SQG+cNF/QyRr+hvw4dP8A6j7Hb0bifb56C8E4yJayiqvyfe@vger.kernel.org
X-Gm-Message-State: AOJu0Yxl9D+J5Hz0bAUUqc/jBWoX/F+bkK/TD0FCnpv6qjnzUUexAjTV
	IkpUyvP6rEz0o5pJsJE64dUfrH1KZniS1ubOr8na2WewWuJ9HUoVF6mbLK1o+dHbInNm9cqlATu
	3i471H9Q4EabSZtQFcgLxXZo3B3hSlO6oyS47jm9tiCT4Rh0vurz5IBmxOAjK/47o
X-Gm-Gg: Acq92OG1l4zhVNG1srqRVl/oy3RQt6ndm9uPyY6nGJHqlTv8zcPg63nJSUQHjtGRQA8
	7Y0dMTR/wbXHnnOR+UQFsAH72c0C51NwNaUfVWg40xcroKbcKGjjqrTnQDiB6IW5GRvgSLgGdAk
	XlAYX6Etj7VBvokZ+OMyIGOAX9KLFlEmrU+VBzPLx5o3/e/kJzMqvJpO2aFsotxXP3H7PkCL8bQ
	D8HdqiRHpKjNwlE62tjgxP1W5Iq5HXL5JTMoEOHH2KzhJOIoTuzQ3k8oqgSfg817NbFy1Cx6TL5
	HkkcIMvnWRXOFXIWN173eGh63dKGaUhkkSVoFHcjtcGpzT3sINiiT1H6dbor4E9yMAHML+6xByB
	tFpXCsASwXamwLDz1z57okbz3iN349jfhuq4hXQNVzSNJPSxNrA==
X-Received: by 2002:a17:90b:3f85:b0:368:b92d:df93 with SMTP id 98e67ed59e1d1-36a4797cc8emr17399633a91.9.1779777750174;
        Mon, 25 May 2026 23:42:30 -0700 (PDT)
X-Received: by 2002:a17:90b:3f85:b0:368:b92d:df93 with SMTP id 98e67ed59e1d1-36a4797cc8emr17399608a91.9.1779777749732;
        Mon, 25 May 2026 23:42:29 -0700 (PDT)
Received: from [10.92.181.2] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36afbc766d2sm1987905a91.14.2026.05.25.23.42.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 May 2026 23:42:29 -0700 (PDT)
Message-ID: <c36e0241-08d6-4866-8b3f-3a7e2bfde547@oss.qualcomm.com>
Date: Tue, 26 May 2026 12:12:23 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 2/3] scsi: ufs: qcom :dt-bindings: Document the Hawi
 UFS controller
To: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Cc: vkoul@kernel.org, neil.armstrong@linaro.org, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org, mani@kernel.org,
        alim.akhtar@samsung.com, bvanassche@acm.org, andersson@kernel.org,
        abel.vesa@oss.qualcomm.com, luca.weiss@fairphone.com,
        linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20260522172716.820490-1-palash.kambar@oss.qualcomm.com>
 <20260522172716.820490-3-palash.kambar@oss.qualcomm.com>
 <fhdronmweor6vb4yu3ggickvvzj7ls7w4eqb6tsvp4amjpg7ae@xfr4up3iesjh>
Content-Language: en-US
From: Palash Kambar <palash.kambar@oss.qualcomm.com>
In-Reply-To: <fhdronmweor6vb4yu3ggickvvzj7ls7w4eqb6tsvp4amjpg7ae@xfr4up3iesjh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=Vd3H+lp9 c=1 sm=1 tr=0 ts=6a1540d7 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=EUspDBNiAAAA:8 a=sKss_wxwHuIV23YTwXMA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-GUID: 1LhrLvtQQpM0aDNA2-OFHYmBhP41wEue
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI2MDA1NiBTYWx0ZWRfX4+jVniX5A2Ut
 /5DN81EoEg21zhGcO21qk8552udvurgVJN8dRrOwS2x42OXy7BPBrHpUNSRnzJN8NMKdip8J9cY
 vMPZHliIEh5asFt0fdAM2NNYGjrtdrens8bN0FRykyTb+o0Hl78gpr7qgNTDOmhRyaFzaMQpr3g
 PoZdSt5Pqprue4fJWoLRWKYD1XjT6LQQAbn/03Hr0kMpHjmi7rlb+2s6cMjlZpdHJNSA2IQZ0ec
 4sXBqW++ZCb7AExMTiN7c0LepmHgV2wjsjgXP7nekrv6jsKUrr0p8lyA16iu3bdJJ6jRZlEmJjc
 ISQjKAwm8wnidLrnJz+Xt3azHW8TnBVTUusCJnSUWadqDsPuT7CWit/vZbgd5yeh/eeSUM/waj4
 fIBOTCKILv9hIjwQVEWfU+af0jtay8dvBBCDRy0IGn7xaEixCa4s3MzNPGP4AbxVtJ6ekKXChPR
 7B5Gt1GHEbddbWrSeEA==
X-Proofpoint-ORIG-GUID: 1LhrLvtQQpM0aDNA2-OFHYmBhP41wEue
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-26_01,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 malwarescore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 phishscore=0 adultscore=0 priorityscore=1501 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605260056



On 5/25/2026 2:16 PM, Dmitry Baryshkov wrote:
> On Fri, May 22, 2026 at 10:57:15PM +0530, palash.kambar@oss.qualcomm.com wrote:
>> From: Palash Kambar <palash.kambar@oss.qualcomm.com>
>>
>> Document the UFS Controller on the Hawi Platform.
> 
> Please fix whitespace order in the subject.

Will fix and update thanks.

> 
>>
>> Signed-off-by: Palash Kambar <palash.kambar@oss.qualcomm.com>
>> ---
>>  Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml b/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
>> index f28641c6e68f..3de00affa4c6 100644
>> --- a/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
>> +++ b/Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml
>> @@ -16,6 +16,7 @@ select:
>>        contains:
>>          enum:
>>            - qcom,eliza-ufshc
>> +          - qcom,hawi-ufshc
>>            - qcom,kaanapali-ufshc
>>            - qcom,sm8650-ufshc
>>            - qcom,sm8750-ufshc
>> @@ -27,6 +28,7 @@ properties:
>>      items:
>>        - enum:
>>            - qcom,eliza-ufshc
>> +          - qcom,hawi-ufshc
>>            - qcom,kaanapali-ufshc
>>            - qcom,sm8650-ufshc
>>            - qcom,sm8750-ufshc
>> -- 
>> 2.34.1
>>
> 

