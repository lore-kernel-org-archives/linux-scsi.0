Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814B2C15C
	for <linux-scsi@vger.kernel.org>; Fri, 19 Jun 2026 02:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781836238; cv=none; b=mygzaeIX9V9I6IOv8Mc/ozFJZplU15PWOAqv3fD9mUP19AV8Y7DScsMAL+MvIAnECFKbCwoqXS3xwR5M4STX+CW8soxDEYP2ht/lTCks4wlzSbtwKmaTLWS14KJDAWuWdNpchQ3jBHJRdEiTdhJnLjONlUkhLrLMXtXuIjeAANI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781836238; c=relaxed/simple;
	bh=hzzDKg8D/eWtuukadeudzxtQLfPsFzWFYfc7KtnK090=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rcf51OVH+lIa/cUBeyODLwnxZsRyRcjxEjbz/oEuQAeP0aD73QU/PY6ciZ0htop2xDEO7Ntz4rtyiXF4iYcfc4YyDLqW0o94K7DQq1vTG/hxaoTkHpYhcikDNoNMSUUJpPuXunxivdEFONQk6pPAJnkdkRmBZhhdTcSOh25TnmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=RwAVZijL; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Y0iKb7SI; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="RwAVZijL";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Y0iKb7SI"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65ILs9OC3060107
	for <linux-scsi@vger.kernel.org>; Fri, 19 Jun 2026 02:30:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	rvKvnxQYSohEoeYt3Cgy8DUpe1X/VcVG3995iHk0UiI=; b=RwAVZijLZ+dhxXOm
	MeRyqdbOwdmbMtq5/1eXRdknBEkDh/VP86knWB1XyJ4R3o5bd3qYN7dXUOxKKo7c
	EGy7XwkqtxjL96ea8bA6VB/6K3HtvBaoISlsYnZ+P/Qyb567+6D3s07hg3c3dMkn
	YFZP3qQSuuKU5WA+VkLQ03mas3xakMP4jvfhgNF9A38XGWcmX9vS6pE04KHLOTIl
	J8OcsYz7RJ/qWHnM2ZFHIqWHOtk3ET999pyAO8/vKkTBGmccHw746KAtT8xPtSz1
	NnrWqZVcaOdZjnaVWQFrZYR+Ux6zqsCM7gIODMCG3xla0P7qrtmXBEyZ3v7cS6Pk
	MYyrCQ==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4evmtj9yjq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 19 Jun 2026 02:30:36 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-37c5dfb67b7so1890645a91.1
        for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2026 19:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781836235; x=1782441035; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rvKvnxQYSohEoeYt3Cgy8DUpe1X/VcVG3995iHk0UiI=;
        b=Y0iKb7SImyAm4p4wegoNLpQ0vmTB6xLc+sQRtOOccUzliK4DjqzAyDcBXy0lfgqynW
         JBj7OZSbWf8Xt/pd6AblAXRnDc20RhshIMDEa8zsckfgSqU6G2WYaqIgwgzwprZhBBIS
         3B4/Cf05Ykgi2/HOdFXlALzb/0nWEAmAz3pwsh3QVHjV2n/PcyCKxcdxaZ0aI8XFxzYd
         Y7CWmzOs56Uu3L9nWOtcOHPsT3Toi4B07YYXb2N66aRtVD6vjCI7EgHSkIG8gGSDSbgY
         ckNEwsTRGRCqYIg/T5otXXyifJvBzIktN2u/R6Mixs3oqylNdrUiyqd4QFbVO9xnzoK7
         +hSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781836235; x=1782441035;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rvKvnxQYSohEoeYt3Cgy8DUpe1X/VcVG3995iHk0UiI=;
        b=bRjdcIJqjgn4bq2CKY7QVPfVBfiOxM9qSTiRjNKHhalv7n/LMnw6fV978DoLGIJ5yU
         n4ZcJRKbarYXMizzmaEDDn93UOuBQqrC3g4GRvxMFhzsNfxzCXiS0jQkhw1yuPbVQ1b/
         8XdVHvWvkoIq0IIDkwJqDTxJb7bTybSJUN51oKKvU8Fy6SEOk+fm72YViCeb3WUNKxC2
         a3ETYflEZXKTlBifcPsR++ClaeWQrW1paOGcrwbqfsN3PprMdNfAVB47/GvmN+4Y2mY+
         sO/yuku1BpKNIAMizJtncqMokAW04dD5bCULIdvYbC4m/y2pW77jPTUxu35avbRqLY1i
         qyeA==
X-Gm-Message-State: AOJu0Yz5EHLeuc7W47KvpxDPRVeT6Kiv/1uS/22mzGwgfh0u2KTh/TqK
	xrF77VPEGWTHgjlb3goyU7LYSxNSzkj88YYU7sdevGDmyGTZHOmt/sRoyUuJSDr0VSGkPi7Cefq
	axJx7Co+tbM6+caIiNCViDe6ycnj6KgH74pFlQRkQaRkM3QlPivuMv6jd27BcXZnwlSNBVIVK
X-Gm-Gg: AfdE7ck/h58f3EsinU4Tt3yfyQAPD/teSf3jxEVrfReul25wlxMgep/Ar5dVn/klqsD
	7Jn+ylv9Azvp4TsTBddMlm80tUTZ+iHsC7RbqbnrG8vDPZAfkMRP2WXtZMjEc/+oV1zDJDezeH7
	8UmF5h/qp9NGjORNLjFuliS1D3/OMQ7YtVDqyE7PT7QpemOeULPZ+BU/s2eDq3ka/rv9PhmjDjG
	5WRejMMjR86BxZZbYz9KE+GpLbOIhrhb98b5AA76A0H2ULitU1IaNXeu2UJvwFuxWZL/lCJcKmC
	WhT3nNPUB/Q5pzGY1sfsapFbPgZBHyWt56n6lBtFz4S2Aqrf9Nynv4qnl0D1OqAOEanoajrClzY
	bEpif4Tjkj/CWR75DmKGjQ3j16G3wa7jO8CXOe0c529d5mAlv7yjnzDPq6VnSkr7DyFD94whbTP
	o=
X-Received: by 2002:a17:90b:3b47:b0:36b:bec8:94cf with SMTP id 98e67ed59e1d1-37d15dd8eedmr2113731a91.9.1781836235364;
        Thu, 18 Jun 2026 19:30:35 -0700 (PDT)
X-Received: by 2002:a17:90b:3b47:b0:36b:bec8:94cf with SMTP id 98e67ed59e1d1-37d15dd8eedmr2113644a91.9.1781836234461;
        Thu, 18 Jun 2026 19:30:34 -0700 (PDT)
Received: from [10.133.33.52] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37d15de501asm1049045a91.11.2026.06.18.19.30.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2026 19:30:33 -0700 (PDT)
Message-ID: <c71af930-c7b4-4480-b125-f35cbe35a16f@oss.qualcomm.com>
Date: Fri, 19 Jun 2026 10:30:31 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: ufs: core: Avoid possible memory reclaim
 deadlock in TX EQTR context
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260618140941.902000-1-can.guo@oss.qualcomm.com>
 <20260618142114.B61281F000E9@smtp.kernel.org>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <20260618142114.B61281F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE5MDAyMCBTYWx0ZWRfX6n4AcPAu3vDO
 /L2/1+MkpleB1r699FLjb74xsQtuRYgwzp+i42ffQeI7mVXfIiocEYmwYbIjkSl3H7MoESUWdz2
 V68HFJprQ+qaOh00Qxv6zPzalES5uBs=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE5MDAyMCBTYWx0ZWRfX4HVZnJNEduDq
 HKfwD2RUtW1rPbYuxsI5v+tznwIY1QkrurMV3iztc59dlLrmOpg96yPp2afd/RPnABQiDskqs2a
 gbpDqsPlMIURLp8Z2RlBdi+donGt/TuhUSs0Q06bgfiYtb+2DJnWUzdY3TKiHUH2MybFxToXPV3
 jCiaFPigc/dlDIJxT3ilOfIzL4Lf8tRNOcbyv5JgjvmtGhn/qHm7Kes90RPGzERZJcIwXzWIsx5
 /xji6w67Yr5rIRVyJ6IOP1PB8PAZxJOGHajMFJsWALDVJZptlZm+iKS0xIlR1gfPb16/GUrA0aY
 QrL6HCkxeM5o6cgk7Xxr9f6YZJedWTLaozRj0VhkMPPshtxeVsodc1VvCT9VHH8fzb5EuZ4uwZl
 cuZ+uaXf23NaXcKbtFemzMgqiDHZn/3BR0+UCnjedxUM7Je8py/sie8Te/8fjXBXNhGxseHWBFV
 xTrv7jMtrNO1JTx43lQ==
X-Proofpoint-GUID: R1H4dOc_xLwD_oI2wcrL82Idban64vh_
X-Proofpoint-ORIG-GUID: R1H4dOc_xLwD_oI2wcrL82Idban64vh_
X-Authority-Analysis: v=2.4 cv=OM8XGyaB c=1 sm=1 tr=0 ts=6a34a9cc cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=c92rfblmAAAA:8 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=eKUtWX0Il2Luia58cFIA:9
 a=QEXdDO2ut3YA:10 a=mQ_c8vxmzFEMiUWkPHU9:22 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-18_04,2026-06-18_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 adultscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 bulkscore=0 suspectscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606190020



On 6/18/2026 10:21 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
>
> Pre-existing issues:
> - [High] The POST_CHANGE notification is skipped on error paths in ufshcd_tx_eqtr(), leaving variant-specific hardware state unbalanced.
> - [High] Missing cleanup of TX Equalization settings and Power Mode on error paths in ufs_qcom_get_rx_fom().
> --
>
> commit 8d8593416ad1701fbb78203bd1a0efec4ccc4895
> Author: Can Guo <can.guo@oss.qualcomm.com>
>
> scsi: ufs: core: Avoid possible memory reclaim deadlock in TX EQTR context
>      
> This patch uses memalloc_noio_save() and memalloc_noio_restore() in
> ufshcd_tx_eqtr() to prevent potential memory reclaim deadlocks. TX EQTR
> allocations in a quiesced UFS tagset context could trigger direct reclaim
> depending on UFS I/O, leading to deadlocks.
>
> Closes: https://sashiko.dev/#/patchset/20260615132834.2985346-1-can.guo@oss.qualcomm.com?part=2
>
>>      Use memalloc_noio_save/restore() in ufshcd_tx_eqtr() to cover all
>>      allocations in the TX EQTR call tree, including:
>>      - params->eqtr_record in ufshcd_tx_eqtr()
>>      - eqtr_data in __ufshcd_tx_eqtr()
>>      - params in ufs_qcom_get_rx_fom()
> [Severity: High]
> This is a pre-existing issue, but does ufs_qcom_get_rx_fom() skip cleanup
> on error paths?
>
> The function overrides TX Equalization settings via
> ufshcd_apply_tx_eq_settings() and then alters the power mode to test the FOM.
>
> If ufshcd_change_power_mode() or ufs_qcom_host_sw_rx_fom() fails, it
> returns the error directly:
>
> drivers/ufs/host/ufs-qcom.c:ufs_qcom_get_rx_fom() {
>      ...
>      ret = ufs_qcom_host_sw_rx_fom(hba, pwr_mode->lane_rx, fom);
>      if (ret) {
>          dev_err(...);
>          return ret;
>      }
>      ...
> }
>
> Does this direct return bypass the restoration of the original TX
> Equalization settings, permanently leaking the test PHY equalization
> settings into the hardware configuration?
In the initial patch series, error handling was not the key 
consideration. Later on,
this has been considered and addressed. After proper (error injection) 
test, the
fixes shall be submitted.
>
>> diff --git a/drivers/ufs/core/ufs-txeq.c b/drivers/ufs/core/ufs-txeq.c
>> index aa64f2bf4f1ef..d20c478659157 100644
>> --- a/drivers/ufs/core/ufs-txeq.c
>> +++ b/drivers/ufs/core/ufs-txeq.c
> [ ... ]
>> @@ -1248,6 +1260,9 @@ static int ufshcd_tx_eqtr(struct ufs_hba *hba,
>>   	if (ret)
>>   		ufshcd_tx_eqtr_unprepare(hba, &old_pwr_info);
>>   
>> +out_noio_restore:
>> +	memalloc_noio_restore(noio_flag);
>> +
>>   	return ret;
>>   }
> [Severity: High]
> This isn't a bug introduced by this patch, but does the error path in
> ufshcd_tx_eqtr() skip restoring the hardware state?
>
> When ufshcd_vops_tx_eqtr_notify() is called with PRE_CHANGE, it saves
> critical PHY settings. If __ufshcd_tx_eqtr() fails, the code jumps to out
> and skips the POST_CHANGE notification:
>
> drivers/ufs/core/ufs-txeq.c:ufshcd_tx_eqtr() {
>      ...
>      ret = ufshcd_vops_tx_eqtr_notify(hba, PRE_CHANGE, pwr_mode);
>      if (ret)
>          goto out;
>
>      ret = __ufshcd_tx_eqtr(hba, params, pwr_mode);
>      if (ret)
>          goto out;
>
>      ret = ufshcd_vops_tx_eqtr_notify(hba, POST_CHANGE, pwr_mode);
>      ...
> }
>
> Since POST_CHANGE is exclusively responsible for restoring the saved
> hardware state, could skipping this permanently leave the PHY tuning
> registers corrupted and prevent UFS link recovery?
It depends on what is implemented in POST_CHANGE. But this is a good point,
I am considering to mandate the call to POST_CHANGE. If there is a 
change for
this, the change will come along with the one mentioned above.

Thanks,
Can Guo.
>

