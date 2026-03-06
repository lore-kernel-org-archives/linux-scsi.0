Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B192A288C2D
	for <linux-scsi@vger.kernel.org>; Fri,  6 Mar 2026 12:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772800881; cv=none; b=spMnMrWiw8RMQ8/8NEh5vvhZ9g/2QYZmMA30jDlj1zduhm4dRfrC5FSSI1Qh7YTKkqkIAUw7WnrEH1l7+T3O6EtoxPzU0q0U9yAX5xHrx1lGilbwCOU7wpbYtLdTG/xObILjAdPr01FFBYE+lgXOfSnaEtQblsbIsvqEyE1Un7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772800881; c=relaxed/simple;
	bh=uF7FeyQrYMijCgWbj69YdKgeI/mux8GE7Fl7Q+vaG4A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o9aNYg9ieTd8Q0YxgE3QJs9XTEabr6J3E2YBBcltYL46AbzOCKvQsJF4o4+H7pw52XLFMQwmQqKOEGkpR11D4Q0tQMEX469Ivhq3saISH+jxs71JHZxRS+SOIa+85qln3sdYoXHkALFbFJWC1Jefe8DSRcxXCRXBcghdPGUtyNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=g0mRvaQH; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=V5Mw/wv5; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="g0mRvaQH";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="V5Mw/wv5"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 626BbK1A3257115
	for <linux-scsi@vger.kernel.org>; Fri, 6 Mar 2026 12:41:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	th1itqMbs74IRL2O00rpVuDnvWp8kNZ4S6kCMjIQqT0=; b=g0mRvaQH2xLIkVxe
	O9x4vc6XXRUqObKh92tHzLbIrRL2E7QmZrfqFRVVCF6aCKy5AIRWaVa9y1qwFI7z
	GA5SQrKqhbVR+6jNNhdz9XD8+bCNye8mZOtHi56gxhf5211y6EX5AUQM5ysKhdKG
	bdHfyKIkeHQxi4PJ53kzbKSgGp3XXJivm19ShidNUgzBWysgISHh6exBlCvMdnL+
	bMyNjB3EjgtOkw0GB1okKC00l7yF9E83K0bDRhn4uDLq2KGuewZ2UIcV2K4Ka86w
	lVW2wsJFCzMEYcshQZp5P6bE8VHqrdIpwgckSrY7KTDFVt9D6R83db9lfR5UDN4Y
	xsfJ8A==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cqg09u3aa-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 06 Mar 2026 12:41:19 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-c503d6be76fso33942328a12.0
        for <linux-scsi@vger.kernel.org>; Fri, 06 Mar 2026 04:41:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772800878; x=1773405678; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=th1itqMbs74IRL2O00rpVuDnvWp8kNZ4S6kCMjIQqT0=;
        b=V5Mw/wv5dVHiI2YmR3NnC4ADnHryC+44ZF2ecXt2u86iD2nDLWM3+BtPmFMzKNeBZp
         QXHyv75hxn4pViTaezct0yUyA/Lzn/A6FHCmXW3v+9zuJrybjk3bIo4N6/JUPxovbN5l
         eeDZpBwsgzlQ3FzehlWFLl2NQLgdTnGPsEbA+u1jM8a9QHg2HomemUHViUCSs0zHeuX6
         PkiKVkyjHBDWIjsM8LbztW7Y6hYlYcMVoCQnvO9/Es4Tv8J6A+OIx8grwt4Mmn5UkPAH
         CSFMFJTUeiqwgBwF32I/19UPoN6Py8E5PSHtsglb9iO3Z1+ix1nKsUAbw8jGKVCvFyHf
         P61w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772800878; x=1773405678;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=th1itqMbs74IRL2O00rpVuDnvWp8kNZ4S6kCMjIQqT0=;
        b=F83e1O9EbOCLCehnyLP1AunljYFFoBYMiYgbk5lQM7G7z9uDZBdDBoIQHbeMwkCHwx
         y+Bq+GLXMYCTlq2FhJnzofg4Y8Y+4d4Z5ObkzwGe8BOg3M5BtRfZKO5DTl+5Y2OQDmTa
         FpMfohgw8/X1kcIpupmAd86kaxXBOER2DG149hr0U6tzm6dc5VVbNcy4Ah0xu188opJ3
         Wcgy/XVHlmwENgUHQkVtOIw6dFfrG8XPNUDMHcvJDJQI6DV5BVUK/TT8x3roO7ylZxGY
         rhzYgpMARcEpN17ZwdMqbwC2fBuDN0z9OZvWNNmZHFtt0CGQP2jl19IcYVL34fBkm90K
         NZJA==
X-Gm-Message-State: AOJu0Yyd4csHETON6lhrVrk1dJw6oDBKlPyPZQEdY9LtmTgpDUWKj/zL
	xkUb3IaZxhfD/rdtPQS4fUSvSQiJqP5d+0/7miqf3kDiPWdJ++prKHQxz+XvcL2zvPBpqz82780
	JR66FCSCL3jq+xKP/FFzzetoOvom7F+CRf3+VMZgJ0efa2cfLSmDX7VXEdNA4/GtM
X-Gm-Gg: ATEYQzzw87ZP3C0TIqzVFre3tTE+YaF2Ri/aYsUp7McUoCWxddRslpJjS/wdl5PP0dB
	qLydsQte0d2v3eH9ngvj2zWcWRjgwq35GBF7fsWqZ2Ofv+w+I7jH/8+olORSdMNRtv+MsN+Q+Tn
	aU1+rOhPPv0Mlpcy61Wv++FreE+aw3qmylifXhyi/Ap3U4swlmq4Ylc8Voa+gly6UfJCql8mU02
	EN1QZ0rFRpNlE36vgAhV13vQpStkBYgCnzWPesAovEu9oAHcCpyi+7Cd5cpSA5FN/ScGdNMOYlu
	1zAhgUtQoaEzJLwQlN2hLFwUxA43fZvX7l7zMqdBoS0IkawvhGX/4tsXdP80iUf4HP89zXZwoRW
	aNuHbMUaDFnEA+nMZ+WGnI1A4AYm0sHsXAdD4o8wAZ6TZANHNjUZbp+ljb2PwZp6C6+1pnHZMWm
	2LcV//njoBKME=
X-Received: by 2002:a05:6a21:498:b0:366:14ac:e1df with SMTP id adf61e73a8af0-398590e0f3dmr2322258637.69.1772800878400;
        Fri, 06 Mar 2026 04:41:18 -0800 (PST)
X-Received: by 2002:a05:6a21:498:b0:366:14ac:e1df with SMTP id adf61e73a8af0-398590e0f3dmr2322211637.69.1772800877795;
        Fri, 06 Mar 2026 04:41:17 -0800 (PST)
Received: from [10.133.33.226] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c739e0f15f5sm1673727a12.15.2026.03.06.04.41.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Mar 2026 04:41:17 -0800 (PST)
Message-ID: <1609ae14-888f-46b5-9e8c-1aaa50b803c2@oss.qualcomm.com>
Date: Fri, 6 Mar 2026 20:41:06 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/11] scsi: ufs: core: Introduce a new ufshcd vops
 negotiate_pwr_mode()
To: Bean Huo <beanhuo@iokpp.de>, avri.altman@wdc.com, bvanassche@acm.org,
        beanhuo@micron.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
        Ajay Neeli <ajay.neeli@amd.com>,
        Peter Griffin <peter.griffin@linaro.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Peter Wang <peter.wang@mediatek.com>,
        Chaotian Jing <chaotian.jing@mediatek.com>,
        Stanley Jhu <chu.stanley@gmail.com>,
        Manivannan Sadhasivam
 <mani@kernel.org>,
        Orson Zhai <orsonzhai@gmail.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Archana Patni <archana.patni@intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER..."
 <linux-samsung-soc@vger.kernel.org>,
        "moderated list:ARM/SAMSUNG S3C, S5P AND EXYNOS ARM ARCHITECTURES"
 <linux-arm-kernel@lists.infradead.org>,
        "moderated list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER..."
 <linux-mediatek@lists.infradead.org>,
        "open list:ARM/QUALCOMM MAILING LIST" <linux-arm-msm@vger.kernel.org>
References: <20260304135313.413688-1-can.guo@oss.qualcomm.com>
 <20260304135313.413688-2-can.guo@oss.qualcomm.com>
 <15d49cfb52990dea46596c2eb0cbdc7db9c44ab1.camel@iokpp.de>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <15d49cfb52990dea46596c2eb0cbdc7db9c44ab1.camel@iokpp.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: DHIBaF0plQlbo12OJtxXR0-8soPW2JX1
X-Authority-Analysis: v=2.4 cv=b/u/I9Gx c=1 sm=1 tr=0 ts=69aacb6f cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=o_XSaaT3ieLpCecdYGcA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-GUID: DHIBaF0plQlbo12OJtxXR0-8soPW2JX1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA2MDEyMSBTYWx0ZWRfX+NoYD8aopLWf
 vOwyrB6GJnU5qVW0jnSxnRd0pCqw1f7ffu+6xTiI6ji9Tok92nSc8NM1+r+XqedTaoT0xy97X0q
 MkRpEQ8GG2cUZeJJaw7LWAEym8PHMu1U820w4+Mpua1++1nqp093KSVyu4c9L1TTeR6/RJdfElu
 4yQ+Z3WZ1fA3gufG2/iubkiGuvU6ez/WYtNo3iU+PysY/CNs0nOt7VW+CvzrIiyvcEGMA1G5xXe
 fzMFqHOEIodopXqACcMzrY+Tq/cjisHMQewz/Prb5aq768j6zMMlOij3KWiIakfH0HF9i8SPBfg
 dOA3rDcehh0FG8GIfA5I4NbBVbFFcaRrBMq4I7S8iUxDgXCI6aTNIag6W7mvKWlvQ+WweOYdADP
 gWyxVdShsNFjepraz7AWvCkdP+gHgz5FIeb3Y/HgR/zpUIR/1E0nGgQYSYIe1Nfo282EHVJGW8E
 TPMGsvrADoN2I6aNnxg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-06_04,2026-03-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0
 adultscore=0 clxscore=1015 phishscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603060121

Hi Bean,

On 3/6/2026 5:03 AM, Bean Huo wrote:
> On Wed, 2026-03-04 at 05:53 -0800, Can Guo wrote:
>> @@ -4747,6 +4745,22 @@ static int ufshcd_change_power_mode(struct ufs_hba
>> *hba,
>>          return ret;
>>   }
>>   
>> +int ufshcd_change_power_mode(struct ufs_hba *hba,
>> +                            struct ufs_pa_layer_attr *pwr_mode)
>> +{
>> +       int ret;
>> +
>> +       ufshcd_vops_pwr_change_notify(hba, PRE_CHANGE, pwr_mode);
>
> ufshcd_change_power_mode() calls pwr_change_notify(PRE_CHANGE) but ignores its
> return, this can continue with invalid vendor prep? I saw there is checkup
> before, do you think adding check result?
pwr_change_notify(PRE_CHANGE) was used by most vendor-specific 
implementations
to negotiate Power Mode negotiation, if pwr_change_notify(PRE_CHANGE) is not
implemented (returns -ENOTSUPP) or Power Mode negotiation returns error, 
the error
check was there in order to call the memcpy() to copy the desired Power 
Mode as the
final power mode, that is, an error return from 
pwr_change_notify(PRE_CHANGE) won't
lead to skipping the ufshcd_change_power_mode().

So, to introduce the new vops negotiate_pwr_mode() and keep the logic 
same as before,
in this patch, the error check and its error handling are kept and 
coming after the call to
ufshcd_vops_negotiate_pwr_mode():

int ufshcd_config_pwr_mode(struct ufs_hba *hba,
                 struct ufs_pa_layer_attr *desired_pwr_mode)
{
         struct ufs_pa_layer_attr final_params = { 0 };
         int ret;

         ret = ufshcd_vops_negotiate_pwr_mode(hba, desired_pwr_mode,
                                              &final_params);
         if (ret)
                 memcpy(&final_params, desired_pwr_mode, 
sizeof(final_params));

         return ufshcd_change_power_mode(hba, &final_params);
}

I hope your question is answered.

Thanks,
Can Guo.
>
>> +
>> +       ret = ufshcd_dme_change_power_mode(hba, pwr_mode);
>> +
>> +       if (!ret)
>> +               ufshcd_vops_pwr_change_notify(hba, POST_CHANGE, pwr_mode);
>> +
>> +       return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(ufshcd_change_power_mode);
>
> Kind regards,
> Bean

