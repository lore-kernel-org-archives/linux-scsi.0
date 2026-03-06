Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB15439A7FA
	for <linux-scsi@vger.kernel.org>; Fri,  6 Mar 2026 13:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772803587; cv=none; b=JNoK18gbTeQHrVV+30gRH4Z2BmYqv9Tti3/RY3JJ5bojliDkPUgZKjeIV89lPauZNnHSaEZVe3ADIZrrRw9iQKKWroFZx9HLK4jkiCb6l9nqMHZa4cm9r5fHIWZjN526JUH+VKM4rwuPoCBxD2NzE+NWWosXwyq5Z/V4E3rpKwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772803587; c=relaxed/simple;
	bh=IjQw2NEfPe1VYtn2E9bLDkEO5z8iMLJ/XlD4JGbswOA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XGSEtB2HNQiW5nLdLSHAkmQHLrrW+sxhvQf+6pJycidbWH0zI1VHZsXmIzuLxkNBtZVgA/L1Xq6J5hsyapNb9+PEuKHf2rWjOaTaKh49u6wVUDr97+849mh6b89SWpXgxIKcZtBQn3daNIV0/UloYhZp2H7CmS0l7NQKtrwZMZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Ic8XUl9m; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ArmRkcj6; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Ic8XUl9m";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ArmRkcj6"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 626Bas8h1451723
	for <linux-scsi@vger.kernel.org>; Fri, 6 Mar 2026 13:26:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	+l58TFoI/df0sAbuXToTnFESMoAYPgOFL8ISsage4FI=; b=Ic8XUl9m14D6s+BZ
	iBgWYLCR3p3cl/TEd09r0c5Abss0+TReHhESrUL/5n0ORiBMKwBH5dRRzAPvak/U
	2DRx61DEM5iQaD0m/gTfx2DSCmVuSY3trhIew27T+pCjX0Rxg/3/jsuN4AbGE+BQ
	UDBvkeDYa6OmCLtXRrgGw03gFrH0WyT9HxxpogIKCi4cfZKUG7POClpa59hKKa+d
	E1zdSb0VSkppH7YLfgETDhwk9CIIeIJacIBMRttKh0IwfIQdsNGdHD+i+XGP9VfC
	p2U81cE4kmyPwrxDNIsFA+x1i5lh/AWnFy/X1GCNEopuTU5/q9MLxgKX6tqgm8lr
	q8ERKw==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cqv9agq0x-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 06 Mar 2026 13:26:24 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2adef9d486bso82414725ad.2
        for <linux-scsi@vger.kernel.org>; Fri, 06 Mar 2026 05:26:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772803584; x=1773408384; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+l58TFoI/df0sAbuXToTnFESMoAYPgOFL8ISsage4FI=;
        b=ArmRkcj6YnifPeos2Cz9ZDYvOAvHherWeLsO4UE/SjeY8eCQnvOvRX30uwDcayGd1q
         0QMOfgiQNBhQKJTEnq3/OIfQ5GQHGWv1xOAniQP8Yy8MSOpGiTpxn0iT3hK2Dx01/g5N
         K90dgT+qcEshwbutXEJDbAKUNaHzxdHL6z2bEUnGBxdzYQsy99Pd0T4TzLaYmT2MT4xQ
         P7469uIDBOc6Bx2H8PUmerPq+PqPCKi+N761sfPXNkE6OjbXagg99a81CKgnre4OP4dM
         7MWFkwJc119yF0U6OIlT30MACBKHQv7YrL2EbHUhLqfF9mD6H07W2e6dn/toN6B4NbxE
         279A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772803584; x=1773408384;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+l58TFoI/df0sAbuXToTnFESMoAYPgOFL8ISsage4FI=;
        b=NKDQuXRfR118E8js9LoGNtKzMMfLbdLdE2iONYc/6Kz64xupqurwDXEn6Y4r6mtxLr
         V+sQQ3SZrE3w7XafqkpbPQUpAg+jJB4rPUOTeDG3xH/sFJvrTYjiuLYeNpwFOwmKMXbm
         MpUkjQ5vAoKrkll8sZnyKBEEJ0tqsVkipClzJoq9cUmlZHX3FVx5Bfbhcx0TFIdcEsGY
         4jCNOA4qgFkE43yGli30lyLaWBFIDA6Qr/dBMRddP1hE115NUrZTF2dkRHz+AaQ4o9Q5
         nFNYapZimNE+9BvJeCt5EZx1F3eIsSrnoBLnA3p+9cPehgMdWzFdWhe6+Q95J7q/2W2G
         nyIw==
X-Gm-Message-State: AOJu0YzKZLPPTaBTJZAPK1jKRsc8K8TmZx5CmzdpwRJnR4Q2/K7Zh3cO
	Ne8D3c2RMpgkJqwXEfv5mPzoq7HnZ7YYk3sIfA152oUQpqCr6+KMP8YFX8Vyr+D0vF5+TkHP0S1
	M7BMwxUWsGb5neq3mPOxosN8ze2/QoZL9CfN3+zKPBEWzyH/XGiQPdj2LCjEBHshd
X-Gm-Gg: ATEYQzwp/DSGAeAXZZUqiN4lKiJPNlqgFfBUlayGwOvz+fv3WZR0jClnN1DjuFywniG
	MeXY8J2Yw8w64EACv7J8Ompet8tNkJ6Y6UGYMo3b3OPKMiY+tlNxJnP/ocZUI9zjpaP68gNfq9A
	Z+pw+s60X4KLBO+dt7q1euiglnlwMX/LIl2oI+/rpalCy7DpSTlP8zpLoxqxEiULWdwVhJFuJFK
	wu67cDJqCpAUIGf43+wScyszD+f1UaKLzJh/10C5Ua8jV0joAs+4XAxpXmETR3uk3SlQf5Hbrw+
	2zyXwBhOJ8KRAp3Bi1rRgxcGh6QPyfsemd1GxjUqaR3ncwoiKgIJq7AUyV8Br6yFWCNFoPmBm+Z
	W0pJd85s2Eh5SxPKWfWdgQJ+9I4AzslNT5u/TfBGIiIUUwYixmoVm8r7hCxCsUbJbZoIybQJ4Va
	0lmPj1SCkNW8Y=
X-Received: by 2002:a17:903:1b64:b0:2ae:62c8:773a with SMTP id d9443c01a7336-2ae8241dc79mr25679405ad.1.1772803583511;
        Fri, 06 Mar 2026 05:26:23 -0800 (PST)
X-Received: by 2002:a17:903:1b64:b0:2ae:62c8:773a with SMTP id d9443c01a7336-2ae8241dc79mr25679095ad.1.1772803582961;
        Fri, 06 Mar 2026 05:26:22 -0800 (PST)
Received: from [10.133.33.226] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ae83f783cfsm20810685ad.56.2026.03.06.05.26.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Mar 2026 05:26:22 -0800 (PST)
Message-ID: <e16ad0db-92b3-4eb5-82d4-78cee5ded219@oss.qualcomm.com>
Date: Fri, 6 Mar 2026 21:26:14 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/11] scsi: ufs: core: Add support to retrain TX
 Equalization via debugfs
To: Bean Huo <beanhuo@iokpp.de>, avri.altman@wdc.com, bvanassche@acm.org,
        beanhuo@micron.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Peter Wang <peter.wang@mediatek.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20260304135313.413688-1-can.guo@oss.qualcomm.com>
 <20260304135313.413688-7-can.guo@oss.qualcomm.com>
 <44a6132c569d477c0e4809a91ee30064ddd725e5.camel@iokpp.de>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <44a6132c569d477c0e4809a91ee30064ddd725e5.camel@iokpp.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: uFFbB0nEk1a9HYapXBdlQWSlnOlBSUu2
X-Proofpoint-ORIG-GUID: uFFbB0nEk1a9HYapXBdlQWSlnOlBSUu2
X-Authority-Analysis: v=2.4 cv=G4wR0tk5 c=1 sm=1 tr=0 ts=69aad600 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=Y0wFfrtxwSY2IZqUjCEA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA2MDEyOSBTYWx0ZWRfX8GWYfa6dOW44
 NKNcXo3S19lQ8OtSpy1MewKdTHTi0pCAvAXh4cCTRmjnlz5sYpDnGs2Pa04eR4eskwoy7m/elD0
 sO40xZp0tA4QN/Mzi6q4qMHgRkY+O/i3LvHyNikN+HqMvomh27tpQLInOR/qScrGDwbS1ZSzsi/
 RdAB5u1neOVTSnZwu7q3tpCxYw52V1f6jyLZLKn1iFrbOAjV36wWt3DLJrn/HsmOYpua/brfzK4
 349kGRdcNdzVkCGZMXH7NX+eJbV4nBtxJ9SW/KDy0dD9LJpGCOoQiBOUxMeV70nJhArl7pkky84
 ZyuC6EZ6nK0YDhJhW6CqEvTSLk4WiqAj+UP9bJoGjQV/N55WDDhhET0qR5WOGIP+UV5qOCAxaR/
 L7wXjQJfA2y9+5xserbb95PjRFZAU+FWyCaTIqiA6u3hBJ9FMUg31ahRTjIySt+eXjpymmzMdvR
 ImiQ2CnMsOeiW78CZ/w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-06_04,2026-03-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 phishscore=0 bulkscore=0 impostorscore=0
 adultscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603060129

Hi Bean,

On 3/6/2026 5:25 AM, Bean Huo wrote:
> On Wed, 2026-03-04 at 05:53 -0800, Can Guo wrote:
>>   
>> +int ufshcd_pause_command_processing(struct ufs_hba *hba, u64 timeout_us)
>
> timeout_us is not used function always waits 1 * USEC_PER_SEC.
Oh... I missed it... I will use timeout_us in next version.

Thanks,
Can Guo.
>
>
>> +{
>> +       int ret = 0;
>> +
>> +       mutex_lock(&hba->host->scan_mutex);
>> +       blk_mq_quiesce_tagset(&hba->host->tag_set);
>> +       down_write(&hba->clk_scaling_lock);
>> +
>> +       if (ufshcd_wait_for_pending_cmds(hba, 1 * USEC_PER_SEC)) {
>> +               ret = -EBUSY;
>> +               up_write(&hba->clk_scaling_lock);
>> +               blk_mq_unquiesce_tagset(&hba->host->tag_set);
>> +               mutex_unlock(&hba->host->scan_mutex);
>> +       }
>> +
>> +       return ret;
>> +}
>> +

