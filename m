Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF572BCFB
	for <linux-scsi@vger.kernel.org>; Mon,  2 Mar 2026 00:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772412736; cv=none; b=ENBlTeNtm5KsBVHal6YUikD/m3VtyuaKNj+Mm00xJaoqkOiA7KNG/a3cxnDx04hq+EVZtCvQt6ZFVjHF6N4OE7ajUteK9q6hcdfWqNVE1F7N1U7crn/EKpBUatDUibaZZQNJ4dRAibD3GjUpYQFYtfI9KtVNfXGuKCNEBtDytXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772412736; c=relaxed/simple;
	bh=rPZKyCmWEkOOignIKtTtpVzMsgteP4OwOw0W+4UKWPE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qfh+Z5y87i5sNHgU1Nqj8xEDh/Gi7VeHg86Aj8kR8uxuRwPPwyve+JizzAVz2pGZY0/SSt4xRfbGl2x4QncXfuVW+uKmq/Ws98yOyJY5IfFBAo/ktrhsis3O02rA9tshE1B3GuAO06ddARC3ruz9gMc68w6wzr81Sd+S0TMMrPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=KTnalncA; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=LMqNwB8D; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="KTnalncA";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="LMqNwB8D"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 621JHksb2358125
	for <linux-scsi@vger.kernel.org>; Mon, 2 Mar 2026 00:52:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	2DRIiigrcgQRf+E/zj5M8crqP7PpZrcnZl+qbkcV6lQ=; b=KTnalncAIDBNehXN
	uypKMoflbP4NMBYbfGOKlh+7puLoe+78R9+zeL6//2usA+DD3rrUWFGHx1BWXu8T
	5jMc0KVBmaDwuVfn9uV816Ifbfdqvnaob2MDdqNTW4xzB1spTQPahpDgFwJqs7AH
	XBtHzR5sh/b1GLOkdp+yg3L4r0+VBEXBH3dEvwoawMpq4pR4gxUpcs1BRo4VkKV/
	ERhZizlbnP6RhCdo+FYxx9XARA2UWxuS7DFgZyE1cVGPN7xmpHH7akvV28NJ3rLC
	F/bcOoH1T5osuCloOUQe2kYsdLokSB5jc0rRIT5FAu9QCydDwynjPM3gHOnQ89lH
	d54/2Q==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cmgbas6y9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 02 Mar 2026 00:52:14 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c6e18b8fe1eso2864965a12.1
        for <linux-scsi@vger.kernel.org>; Sun, 01 Mar 2026 16:52:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772412733; x=1773017533; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2DRIiigrcgQRf+E/zj5M8crqP7PpZrcnZl+qbkcV6lQ=;
        b=LMqNwB8DGu4oNQ50ERUhZKDgzQ7d73rOGXI/gwBWeZeRHVzItPDBTDVtksXFP3ddD4
         eEbDtPKvXag3Z2IFYWjULfZuNMSQO4CL9/EhMPj2tslJSfEcd9L3d2RcDUz1oesy2fOc
         UTurVGvWoow19kpKhRmMXcNrqbAN6HAcOVGaXyCtV4YxN9UJBOxancZd632UqLsTNVkB
         LAP+0jgixuEJEAq7hwyCJlHYHAdFMAPHzLfC07aICpaiWekfcPlIYRJPTsuhvCIymV/p
         Xd76+Xq9qPSxkZvmmuol9H25sLw2V1nqOUs5Bn2akPiXSQCdGmIUbDgn2jXCJT4qlyKO
         bmMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772412733; x=1773017533;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2DRIiigrcgQRf+E/zj5M8crqP7PpZrcnZl+qbkcV6lQ=;
        b=MmfV+QQeKlGciwL25Ap60Q4I05CrWAbRsclUkzy548PB/p0HrFuNqD6+D/4Yu51g3S
         Wc00REy7S/4+e1T5x1wWbplBcQN5X7YeYSYAWyJM3nvZ2Mo+MOR7xaTcjYENEcBGnO92
         79QVeeWQ5Niy83vcSsXcsbg0aPeF/GfOU6a0dIgv6/csJmjf2H1BYvXWXMme1CI2smMw
         ayb/bexb+Ko/+TyaLc5k8JKyYlwLZp6i40MUW8TU7kvJpdBPcYI3XFDqnNuHJk3lGd71
         l8PDnXJqA5T4zhiOt7o981l+d/IOPeEBJF+rs1RjhJClSSBaf5L7IVEzx8ZRDbGGMsR/
         asFQ==
X-Gm-Message-State: AOJu0Yx0gdSnXknlQIKsI+efSlA8heUtvN/dc6CPoaczLVGfkMzkGFm4
	HxAwjFdGp2VUNXhYuGDpBjdv+CLZSVB0xi4DJ8HNFYvVUZT7bBRN62WdEiM6Rvjnfw85H+ymtEn
	ffY6K4c/LsK4mOrWnyePTOTOuPzSZ34uw5PTFaGACbK8IAz5dQ7oZN7OH0XAouDkK
X-Gm-Gg: ATEYQzzYk4gKiZPPrRE2kSp18rZHu/wFyi8jW3oR9l6Qyjb43JmD3Ig+TgD+bT/Rshz
	ZXYC5BmIbd8iAF0dFqph43ImrD4NrVPB2AmnYKatleeefdR5bPatExH6mx1GxmarftuShYy+bFv
	f7baGXYIm+brR+b5S0dZLqtbMkLagF9fttiDr0Q026Opy+T1cwYQX7FmzUPec6s3o2glt6Rekq7
	RfFu8A6P9NB58tobgLMajrUWpSjGsFjIA+3fmUw59K5TQl/pvta5OXnQZ+QqUb+veau9/OWx55Y
	XFOWSqaWke8QMybKqIyKQ8F3XuVuNUii89YnKyUvbdTAvL42NTq1+22RLKZtiCFN9D4A2lhFM8w
	V/Y9q6QQDSMpTpcI40QtMKnz7gp2uaGpRUqfAAmew2OnM1Aw=
X-Received: by 2002:a17:902:d489:b0:2a7:c188:bd1b with SMTP id d9443c01a7336-2ae2bbddf43mr90575655ad.25.1772412733079;
        Sun, 01 Mar 2026 16:52:13 -0800 (PST)
X-Received: by 2002:a17:902:d489:b0:2a7:c188:bd1b with SMTP id d9443c01a7336-2ae2bbddf43mr90575515ad.25.1772412732585;
        Sun, 01 Mar 2026 16:52:12 -0800 (PST)
Received: from [192.168.0.102] ([183.193.18.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb6a041asm124649995ad.57.2026.03.01.16.52.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Mar 2026 16:52:12 -0800 (PST)
Message-ID: <8c1dd977-966f-4463-9bc5-adda7ebdaf84@oss.qualcomm.com>
Date: Mon, 2 Mar 2026 08:52:08 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/11] scsi: ufs: core: Pass force_pmc to
 ufshcd_config_pwr_mode() as a parameter
To: Bart Van Assche <bvanassche@acm.org>, avri.altman@wdc.com,
        beanhuo@micron.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Adrian Hunter
 <adrian.hunter@intel.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Archana Patni <archana.patni@intel.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20260227160809.2620598-1-can.guo@oss.qualcomm.com>
 <20260227160809.2620598-3-can.guo@oss.qualcomm.com>
 <7a90c4ec-7638-4840-bebd-f38cead6435e@acm.org>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <7a90c4ec-7638-4840-bebd-f38cead6435e@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDAwNCBTYWx0ZWRfX6/OCFA0kqMvt
 v6iAkIv/PHJ55npjsDA/uaXngzdBhxj8WXWNKjW6UeoEe1GCOXxXXIqzkx9j8ufh88XWO8eyEoa
 lQ6R5Uc8yXFYHfrx3g4gPio9fSXvV2B25N2vogmfsLIONYtSb0om4zi3k1rxArKdqw6JFziW4Nc
 d9nT6/167loP8oeTqByJMRL8rvMIDtphto0708sJRLV2/CWmc2eetcszNMdiFOt+/+WVTSlMTpF
 KiAqE44nult19FVTJU9ix3KLW2aVT9W5p/6w06wi4hf6TmCWbe8kicvxUONiwEgsDFj92IIXjsg
 Nhl53JwMfk/6dNsCPFTGSvUfy3bFiRcfYTF61mAWd+LreMYxBnwHzU2vDUEVYS1FnsaXxsSbtmw
 7JzdX9T/+LXFI4zJ35qOir3t3665jd3AtYdSpPizgKtpVZx3vWa9qXnI9MoU0aOple0e5ABKfz9
 /NTP8RxFsGVwURucaqg==
X-Authority-Analysis: v=2.4 cv=QfVrf8bv c=1 sm=1 tr=0 ts=69a4df3e cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=4/OApUm1v7sVY8kc7hZvWg==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=i7b9DVKwuiEtFV1sOI0A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-ORIG-GUID: dmG0ya20YzinI4U9rgMhxsARirmGr-MH
X-Proofpoint-GUID: dmG0ya20YzinI4U9rgMhxsARirmGr-MH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-01_05,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 priorityscore=1501 spamscore=0 bulkscore=0 clxscore=1015
 adultscore=0 lowpriorityscore=0 phishscore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603020004

Hi Bart,

On 2/28/2026 4:46 AM, Bart Van Assche wrote:
> On 2/27/26 8:07 AM, Can Guo wrote:
>> -    ret = ufshcd_config_pwr_mode(hba, &new_pwr_info);
>> +    ret = ufshcd_config_pwr_mode(hba, &new_pwr_info, 
>> /*force_pmc=*/false);
> Comments like "/*force_pmc=*/" are uncommon in the Linux kernel. Please
> consider introducing an enumeration type for the new argument, e.g.
> enum ufshcd_power_mode_change_policy { DONT_FORCE_PMC, FORCE_PMC }.
> While comments like "/*force_pmc=*/" are not verified at compile time
> (the Clang option -Wdocumentation is disabled as far as I know), the
> type of enumeration labels is checked at compile time.
Thanks for the suggestions, I will make such change in next version.

Best Regards,
Can Guo.
>
> Thanks,
>
> Bart.
>

