Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F3B430EF91
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2026 13:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782220991; cv=none; b=LKftCA6nPgA8o/DdMFU7PTysZJOoCLIWd3PShhn/gT7IMFCuxl/k68rs8NtRDg5oXYYxbHfdJnHDeejSP2tDK7D59efIDTg8shA9HQVrN/qU8YytrZCsS3ZuMeZqUMUmND3JpnA53AQyTX1KaTDzjOKw9j7LXOA0UEzmAJf8dYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782220991; c=relaxed/simple;
	bh=KHsbF2q5YwBbi3WT6ofbIrfPK5Aoj098duTHqUgcKl4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M+IfBPKgohQKWpjU60KpAC6EDkFtWNC++w1yTtLx3LVD3K4BvNj9d78zUQ1H77cEEtvWX25frjq+DEoMgxTwmEG8mMhUlXD4yBSauvUBePBFo0MOyzIOl/+jeZNRPSvERqSnYDBHU4gJUOIpBJjj+767IwHD0CT9HLRiyfkeDSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=QY1/d0Ue; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Yy0W6jRz; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="QY1/d0Ue";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Yy0W6jRz"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65NBZZxo134186
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2026 13:23:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	wWICyA4OjvwivGmi36NJ951DnPj0i8yHE05ZwVHeGmk=; b=QY1/d0Ue4iXDjNIg
	o42Gu2gjzPSiZZqkcb1eQBSY+kKFJhFSpxjwMX30FOLrZ89QCBViVxlPBVDVvAlG
	21sQhXwFvtC0/gq2jTKwjf8OfFxk6awKlu1+VKmh3ikueB5lz0I8OEbpp2/XEz2d
	z2vqPNkkVuiW+nlLJJ1EZjQG+dQwVgjDVF6bP5qXPuj4AUQ+r1TRMbslBVF90YrC
	YfZb6KGnjsGnyrDA1Pmzw7y1ZILRYNC+JHR9I3r28DFS4emZ3wqw1Hmvh0JfOAU/
	YgGw3gpELMrW2WcUyOsHGauVPqVB/ZXov6/yqV8t0sxVgI2nqg04Cr95hLM6f0rR
	HizbNg==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eyr320pbu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2026 13:23:08 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c891ed872ddso3813993a12.2
        for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2026 06:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782220988; x=1782825788; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wWICyA4OjvwivGmi36NJ951DnPj0i8yHE05ZwVHeGmk=;
        b=Yy0W6jRzQTGLnqRddJqDzE6/JNQuv1PS1ypF+7hFxTtaEwYwDRgK0R3TzGgRk+zcn0
         bjQqehKtiggJjFDOdl2pUa91rxEvsTN02LZ3h2uoS/646HrTAO/cGapYtSrLMJudCTaM
         fgLhDr+PiTQqKj9/fWGUjI/XuWa1SG5GJA1sREXzUXblEdu7rWg5DWgT3Nln2WcMbdFZ
         YYgxeh0v6ggJ9ueial4SLyy1+tfNBqC2L4xczUhwPisf6031dsitvAhRRM38MS1jRmfP
         lXIM8M9CsQNkHgP6o68Au+1wYhf97wY/E0r6i/ai1dVML/Q6UK4CVSd22N32h54rFtw9
         FHeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782220988; x=1782825788;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wWICyA4OjvwivGmi36NJ951DnPj0i8yHE05ZwVHeGmk=;
        b=n5GY6b6SCZFS+5AZ3i0zioZPPs1DujaI4Gr3lks9as7oy9CW5RstmxJEBD+kl+4TUN
         INjCHzBiRm5evRxc6fni+nY9BYTSByGYgOoZCvDWSVIcep4A82Ga2ECjYaEQ0Qfr6zB7
         VeDIKUeWmBu/T2Db4msBOES4mpt23+5foz2fYAlGTXTuzWpoeBZFl1meNQV6SGI8SUQH
         LeBhnumyYgZawoY3je550zvN0Kb1iEtivkTd3ICJvB1rU+2LQ/6QJTpt0ye551g7WVMu
         0fB6SJFUSoVKXc0t80xLR/RXbj9hFFcBVQQbzZiS1xvL0KIsTXWHPXjlfGVcrdVIbSJJ
         yVBQ==
X-Forwarded-Encrypted: i=1; AFNElJ+oF0Fut2DNSNimG/x27C4PkNdiEO7oIT5dnx/kisWHw8QiNUylVA462LNFnD2A6H23Dm64c4+I7TH2@vger.kernel.org
X-Gm-Message-State: AOJu0YwvXvlSuMLTcRtEk6LKUIjw0H0wKeBA0aFfoKKOm7J2h4w3WpxJ
	NX23n8zbGWGnjgmy9sWDrE6eaI+FiAypeimLI5JNSEzItn/jfCbjHlinhThMnTL15jW5UFRGF1u
	dPTFMlWj/vD47fAU6/xbhZmR/46gY2Olkp8uCPoXm4QrRHmnkaxMydCeQw5ziGLZo
X-Gm-Gg: AfdE7clftSrsIc+I2ZaUW2HActit2cL9TIfNiugnEIb9//0WPJCvn38FPF5CyfPjLYf
	QU0KXNqm3pVR7n+B1cyIudwYou6PqJhAGsI9bgqHfRvtxbLM75N9ZsQgHQYlmwRosnSxsNe/29r
	QWphyP3gl2bl//Oyc30u0dbW3aqyU9UUlkjdny3imSbUubyLi5ceXVVlo9yiqAwJCr9qONj9tbl
	++S0dF3IkvlaW/I2hQEInY13R5P0ge9Dh58uLC/qzBALZPomsx3/qP85ec6EsVLrmCY1Rd31zS5
	wGZQO3jUJSZpAEcPTgcNCXCi5eOw8tDptXuMlP96FHTHnKRkoq0Vfcn+W/z51Eose7A2ydB9Dsy
	5EiIpI3FAjGSqhPhI1hofswyHonQP3juiAHo5Tm3ntiN/8X63aknCSQ7cJ8VdlXq2/1LB/SlEcq
	j1
X-Received: by 2002:a05:6a21:32a1:b0:398:bda8:d8cd with SMTP id adf61e73a8af0-3bc5181970dmr18275357637.7.1782220987976;
        Tue, 23 Jun 2026 06:23:07 -0700 (PDT)
X-Received: by 2002:a05:6a21:32a1:b0:398:bda8:d8cd with SMTP id adf61e73a8af0-3bc5181970dmr18275282637.7.1782220987253;
        Tue, 23 Jun 2026 06:23:07 -0700 (PDT)
Received: from [10.133.33.180] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c8bc5d04858sm10135881a12.28.2026.06.23.06.23.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jun 2026 06:23:06 -0700 (PDT)
Message-ID: <ab578742-005f-46b5-a865-1e7065807c41@oss.qualcomm.com>
Date: Tue, 23 Jun 2026 21:23:02 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] scsi: ufs: ufs-qcom: Restore TX Equalization settings
 on FOM failure
To: Manivannan Sadhasivam <mani@kernel.org>
Cc: bvanassche@acm.org, beanhuo@micron.com, peter.wang@mediatek.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "open list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER..."
 <linux-arm-msm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20260620080322.3765210-1-can.guo@oss.qualcomm.com>
 <20260620080322.3765210-2-can.guo@oss.qualcomm.com>
 <3e6codiksnngi442bitbvzgs222hl5poqi7o7chtt4ulnq7na3@4otqpolqzhbs>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <3e6codiksnngi442bitbvzgs222hl5poqi7o7chtt4ulnq7na3@4otqpolqzhbs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIzMDEwOSBTYWx0ZWRfX7ouS5flGKEon
 WuKqYfaXe1NQtS94XpmeWAljPjsoxufN4iNeiae4kzEmhXDWMOYydcLHsYMn3nwVUMzlF+aaKD6
 30Ql1DCNvqn+wRJFZXJU/0HsamlOMF8=
X-Proofpoint-ORIG-GUID: DasoZ6fjxxWKRTKj1Veu9Wk2VwZeWLyS
X-Authority-Analysis: v=2.4 cv=HrxG3UTS c=1 sm=1 tr=0 ts=6a3a88bc cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=Dm8MaZoDgxkqV7ZbULYA:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIzMDEwOSBTYWx0ZWRfX2Gd4FxGahxq9
 9MXukOhm0mYxRupxGRA3RVz+uWdPKJ4NdUzzwzCDAc2krilCKrHYD7iU+uREfD85yxET72MRy3U
 e0lcsWm6YVDsEGG5U5sE6wYH2HailFJJ82J4CsWaHDPJpVIhP5XNRBfSjYKvrausUdeZd8Cmdwu
 hfn9ZEubBizP0y52rYYj8keoVxN92RCYXYthKVjXgRxfgx2Gfzy5/Mt1mW1ieAtYoRNs5Ue3pxZ
 AUOIP9YIjOAMkAhR+zbpt47dzMKs7RNgktwOecWxT6yt4aWuKsDzJpHd+zxQUVrfJ7M5IwaYoER
 F477H22tqzTTiNqxrqLeTnNlacFltipJAp5hUhqByGgLX2tuejpVCFsx8o0CSfBnXtzq3nA6Y3O
 w5Ej5hcHFoG0r1C41HJn2q7ZKgcSiCmAkA+QO0AvfkYr+vQNb8ht67nWWGG59Cumn+yXUF/r1Hi
 HObiQNwVCOF1YSf5lYg==
X-Proofpoint-GUID: DasoZ6fjxxWKRTKj1Veu9Wk2VwZeWLyS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-23_03,2026-06-23_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 spamscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 adultscore=0 bulkscore=0 impostorscore=0 clxscore=1015 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606230109



On 6/23/2026 2:33 PM, Manivannan Sadhasivam wrote:
> On Sat, Jun 20, 2026 at 01:03:20AM -0700, Can Guo wrote:
>> ufs_qcom_get_rx_fom() applies temporary device TX Equalization values
>> before forcing HS mode and running the EOM-based SW FOM scan.
>>
>> When one of these steps fails, the function can bypass the shared
>> cleanup path and leave temporary TX Equalization settings programmed.
>>
>> Route those failures through the cleanup label so the original TX EQ
>> settings are restored and link recovery runs before exit.
>>
>> This path also reuses ret for cleanup, so it may overwrite the original
>> error. Keep that on purpose: if cleanup succeeds, the caller can proceed
>> with the FOM result for the current iteration.
>>
>> Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
>> ---
>>   drivers/ufs/host/ufs-qcom.c | 9 ++++-----
>>   1 file changed, 4 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
>> index c084ccc72523..7d7c001435bf 100644
>> --- a/drivers/ufs/host/ufs-qcom.c
>> +++ b/drivers/ufs/host/ufs-qcom.c
>> @@ -2791,7 +2791,7 @@ static int ufs_qcom_get_rx_fom(struct ufs_hba *hba,
>>   	if (ret) {
>>   		dev_err(hba->dev, "%s: Failed to apply TX EQ settings for HS-G%u: %d\n",
>>   			__func__, gear, ret);
>> -		return ret;
>> +		goto link_recover_and_restore;
> IIUC, if ufshcd_apply_tx_eq_settings() fails, then it means the TX EQ settings
> were not applied. So do we really need to restore the original TQ EQ here?
Hi Mani,

Thanks for the review.

In many cases yes, but not always. `ufshcd_apply_tx_eq_settings()` 
writes multiple
DME attributes, so a failure may happen after partial programming. 
Routing all failure
cases through a single cleanup path makes us always attempt restore and 
link recovery,
instead of exiting early with possibly transient settings.
>
>>   	}
>>   
>>   	/* Force PMC to target HS Gear to use new TX Equalization settings. */
>> @@ -2799,16 +2799,15 @@ static int ufs_qcom_get_rx_fom(struct ufs_hba *hba,
>>   	if (ret) {
>>   		dev_err(hba->dev, "%s: Failed to change power mode to HS-G%u, Rate-%s: %d\n",
>>   			__func__, gear, ufs_hs_rate_to_str(rate), ret);
>> -		return ret;
>> +		goto link_recover_and_restore;
>>   	}
>>   
>>   	ret = ufs_qcom_host_sw_rx_fom(hba, pwr_mode->lane_rx, fom);
>> -	if (ret) {
>> +	if (ret)
>>   		dev_err(hba->dev, "Failed to get SW FOM of TX (PreShoot: %u, DeEmphasis: %u): %d\n",
>>   			d_iter->preshoot, d_iter->deemphasis, ret);
>> -		return ret;
>> -	}
>>   
>> +link_recover_and_restore:
>>   	/* Restore Device's TX Equalization settings. */
>>   	ret = ufshcd_apply_tx_eq_settings(hba, &hba->tx_eq_params[gear - 1], gear);
>>   	if (ret) {
> 'ret' will be overridden here and '0' might be returned to the caller.
Correct, this is intentional for the TX EQTR sweep. This helper runs 
per-iteration, and I want a
failed sample to be treated as FOM=0 so the sweep can continue to the 
next point, rather than
aborting the full procedure. We only stop/abort TX EQTR sweep when 
cleanup/recovery itself fails.

Thanks,
Can Guo.
>
> - Mani
>

