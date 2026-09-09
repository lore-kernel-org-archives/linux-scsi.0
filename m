Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39AC51397
	for <linux-scsi@vger.kernel.org>; Wed,  9 Sep 2026 02:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788922081; cv=none; b=gRaiAvYPFZQ+bAzesyMBesa3kFDWBpQXk4JWe+Qh/ocioJpK7I+U8UpEtdpYsiIpd4yuO90zSI9V/YMjULM/rrT7gVilfU0Se2tS5OKZtHWOm5vtg2+NtzzxHr+DUMoS/sUkLL2CkuKbxN36eqekb7d/2Vjm4THZcKhjY+gS1u0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788922081; c=relaxed/simple;
	bh=9NyIx4dDN/n8SR7fgjVO6DYWyHiKLhy9HgV2Hm+621Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pA6GcFymIUer+L7Hb3v5Vo+uk1GjKUve64lqjlAeT8jSr7M/BJSL97eALDAcq5zCDukAOZf2nU1MGZcFORWCprVT2i/DekzsFe0tZGtfe1PfoAbfVFhPxfmzIbQN6j57vS0zu6k9a8db6Uvj7TXjrrz+ZcLvBbFxMUXerQgzzr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=pBHm0GR+; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Zwww++Jp; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="pBHm0GR+";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Zwww++Jp"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 688MgGjJ045467
	for <linux-scsi@vger.kernel.org>; Wed, 9 Sep 2026 02:47:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Rjawb3C4arzargqScoKB4y4HXxny+HjzJB7ieKfMXLw=; b=pBHm0GR+622PlG7b
	FbCGqFHORCQwXcFHadDDYpB3bXSwHTrcEWARIaGtNfW/+sqcsEvt8KE4CViI/Axl
	xzsRN/a714PJOPUckdwHfObcuRgUzTq6Jc82NfVZK0fWHL1bXPJDUJadoaGcJRXL
	0fRWARHsqKMDmB2wn3Hp2R/g+Kyp1sXLeN8I7q1AIhlcfKVS03/1v7LqWT0LhrVz
	oeU9Cpzfqkkxi497nKjZfXM0H4h3QhLX8HH3NRPSwHBnUWNN9VaQ9k6LTMfxuJuh
	LRrGge5NFCUPC7c3r7QC0FNpjiPLNc3b4CkqUvFJz/i714zTBKbhkCfAqyZLK/3T
	zE8XuQ==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gjqewhrcs-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 09 Sep 2026 02:47:58 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38e8e864ef0so9070876a91.0
        for <linux-scsi@vger.kernel.org>; Tue, 08 Sep 2026 19:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788922078; x=1789526878; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Rjawb3C4arzargqScoKB4y4HXxny+HjzJB7ieKfMXLw=;
        b=Zwww++JpVSq+/3rqg3uymq32l+D4ANau8fFKksJL+E06924Huxa3OUE5Sb0dvJelsR
         EV+8gtjVeAyrDfxc9fAjOsGbCCEw109jQSPcJ3HGaUr1ZFu8F9m17ptbEtoKv6g6ViHo
         3t7Lh/2mUQKZOeD8J6s/tdNDxNHDqllJQ1mkx++8qVNUf/ojROnHS/jkaJXxeP28F4/F
         7n0/oRG+3VHxj+0gVHAYkiRp3HYgB4LcW4aXk8f8YuuxqNFz0RQeSKsLA7gVAMIPw3Vp
         NwSqWWp4lG1xXYQ+mDW0siqIik7asHCrGUFKqHvYUVL2Lend4abAxTLm6dLUxBKDjVgD
         1zdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788922078; x=1789526878;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Rjawb3C4arzargqScoKB4y4HXxny+HjzJB7ieKfMXLw=;
        b=aupSDQRWfnRO0v6TBoFOc/XWQmX1QlGciYwKA9zFBnFJuFVGbkTdEX774Wwvl/H5qm
         OdCoF0NoRh77NIwiPBpwNCFa0WhF5bxqZmKhgwcFQ8zsSW/w72kRICrCvF8M0rJIegSh
         pp+THP/06/wxHjozlDHfbi9UDvSkk/GPBZ35lW/bccG9weNBxvdc63fKEiPX3Cjp0NnB
         adWnk1QAsS7pBnnLe7rmWh9Om45OJEjTEa20BMF5NzP0b5N93vqMQfYQpECL7Uc92OxC
         DEBLKc8bTOz1KWasmOH1OYn0tTTP0rx3+Ibp4kkyBYE6g6zqCGkjsu424smntfu3OWvd
         f0lw==
X-Gm-Message-State: AFuF++nc3rruzHjJCp7GZv14m6IV34R7zEp0mdZu7O7lMkGOJ+BbKSNe
	GMTBMuIK8rH0siK5uyirb/qtwlVWTYZzvkyxKsex8hWUxiRYuGvwhrECp1pxDg8CzsH+P8KWRnq
	hK4P609dRfefrY/H/1OIDt9fTS5Zrm/bhgNSWiErheXKysYgFWd8XvWZZeDULaeQU
X-Gm-Gg: AYBFou1LQ1WWphSadmhfaKi57JLF2vVvS//b5B4UmWq8rAKuBdA/eW5DKHsFD0ojs8w
	k+gSmNJRBv7eBdruCvDURv85kSuUEk+NrSRXq6T/cenHyh86iX/OuiveoHTHAKIK8HXEUoLduyV
	B/JayUfZGucNvjF+OfHjymI82SeBuI43+M/JEJ54uNSHbD5yrHkjV4IpPYhhocAYck09Cds62MP
	dO5l2PczB+6pxhm/nwzKIbh+/nBHrGJ50eMHMrgUkkSAIVh8COnveJUgmygsKnWcyyCPGf156n9
	U1B+64CLJptFsuY8XwceMbe/G1tpC3IiqAgMQG0EDONnikWONnKXgbtGE9P0zzzwo0i18H5dEPB
	aO5z7zxdFMTZewIXPeWMkEVf+Lqlh
X-Received: by 2002:a17:90b:2d83:b0:381:6c5:3f63 with SMTP id 98e67ed59e1d1-39bac1976camr4182191a91.6.1788922077940;
        Tue, 08 Sep 2026 19:47:57 -0700 (PDT)
X-Received: by 2002:a17:90b:2d83:b0:381:6c5:3f63 with SMTP id 98e67ed59e1d1-39bac1976camr4182167a91.6.1788922077384;
        Tue, 08 Sep 2026 19:47:57 -0700 (PDT)
Received: from [192.168.29.58] ([49.37.154.50])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-143243bfbe3sm37033346c88.11.2026.09.08.19.47.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2026 19:47:56 -0700 (PDT)
Message-ID: <0f910397-f38c-4f14-894f-6b0f579a4d9a@oss.qualcomm.com>
Date: Wed, 9 Sep 2026 08:17:51 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V1] scsi: ufs: ufs-qcom: Enable only lane clocks in lane
 clock APIs
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>, mani@kernel.org,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
References: <20260713173434.883386-1-nitin.rawat@oss.qualcomm.com>
 <f9abba69-7b0a-49f3-bd83-b38a7a451cd8@oss.qualcomm.com>
Content-Language: en-US
From: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
In-Reply-To: <f9abba69-7b0a-49f3-bd83-b38a7a451cd8@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=cpirVV4i c=1 sm=1 tr=0 ts=6aa0c8df cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=FrNG0DaaYUTAIW4lgu81OA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=ZbYmq58Ac-c8yyNXGIYA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-GUID: ZG-5H9bHWTdMpdxXmSALuP1n0y0D3Rl_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA5MDAzMCBTYWx0ZWRfX5gbAAEl+V4iC
 59ciYN1Nvkg1MZLHAvu1YHYaSPPHLyQHjLDYSNuXdK3uaCg0sXvfMjDQ795coVKvCGYkF3hLw3W
 0GP0R05KEOVcDKmrzbcXADsa9yPBi7XDWi/Wm0mt+hfX22rN4eo+1mA/WyupbykK3qt78gxeiqj
 wVVIxd84INWXZiqXPoqJBXtFxBCLr96rcHvkWyGvqqBUoBPHfMwPYTZOvUwx1GQLp/GM+iugyje
 s0lksxdt+KaBXKDUHWZaDRxSA38pLvZW20nEghD5D1iEVpvoMvrST9meE690K0uxLLIFx+S/ZFI
 fw6hXklyorvbzr25MtTvdEwkyS09+Stkpu9SjLa9DgTIi1xuu7SBUhsn5tNf2v7U+FsIrXxDf1B
 sknhMnwr41VDmRhihaXwZKCJ7WcfMfE2F6hrc9SgzeHt073icYJi+Fohz9X61lCpSi3wtiJ8yte
 FlQeYC0Wgc8tIjWM3ew==
X-Proofpoint-ORIG-GUID: ZG-5H9bHWTdMpdxXmSALuP1n0y0D3Rl_
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA5MDAzMCBTYWx0ZWRfX1mnDtiH0ZwK7
 msAAUE04DCpoISRO8kYGYEdAusTn2enL919bpKRTwNNLd2y8zDKB/qEh37E5bgi7Hm0JP7CutRM
 okCbq/P9uYupUG5zbu87Oi8XbeMCLFc=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-08_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 phishscore=0 clxscore=1015 priorityscore=1501 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609090030



On 7/14/2026 12:41 PM, Konrad Dybcio wrote:
> On 7/13/26 7:34 PM, Nitin Rawat wrote:
>> ufs_qcom_enable_lane_clks() and ufs_qcom_disable_lane_clks() currently
>> use clk_bulk_prepare_enable()/clk_bulk_disable_unprepare() on the
>> entire host->clks array obtained from devm_clk_bulk_get_all(). This
>> array contains all device clocks, not just lane symbol clocks.
>>
>> Since the UFS core framework already manages the non-lane clocks via
>> the setup_clocks callback, the bulk enable/disable in the lane clock
>> APIs resulted in duplicate reference count increments on those shared
>> clocks. The extra enable counts were never balanced by a corresponding
>> disable from the framework's clock gating path, preventing the clock
>> reference counts from reaching zero and ultimately blocking CXO
>> shutdown during low-power states.
>>
>> Fix this by restricting the lane clock APIs to only prepare/enable
>> and disable/unprepare the three lane symbol clocks (tx_lane0_sync_clk,
>> rx_lane0_sync_clk, rx_lane1_sync_clk), leaving the handling of all
>> other clocks to the UFS core framewore.

Apologies for the delayed response. Reviving this thread.


>>
>> Signed-off-by: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
>> ---
>>   drivers/ufs/host/ufs-qcom.c | 41 ++++++++++++++++++++++++++++++++-----
>>   drivers/ufs/host/ufs-qcom.h |  3 +++
>>   2 files changed, 39 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
>> index 291c43448764..7ec1626704c6 100644
>> --- a/drivers/ufs/host/ufs-qcom.c
>> +++ b/drivers/ufs/host/ufs-qcom.c
>> @@ -347,7 +347,9 @@ static void ufs_qcom_disable_lane_clks(struct ufs_qcom_host *host)
>>   	if (!host->is_lane_clks_enabled)
>>   		return;
>>
>> -	clk_bulk_disable_unprepare(host->num_clks, host->clks);
>> +	clk_disable_unprepare(host->rx_lane1_sync_clk);
>> +	clk_disable_unprepare(host->rx_lane0_sync_clk);
>> +	clk_disable_unprepare(host->tx_lane0_sync_clk);
> 
> I don't know if this matters (probably not since IIUC the controller
> would be suspended already), but downstream disables them in the
> following order:
> 
> TX_L1
> TX_L0
> RX_L1
> RX_L0

Yes, order shouldn't matter as controller is in suspend state.

> 
>>
>>   	host->is_lane_clks_enabled = false;
>>   }
>> @@ -356,18 +358,35 @@ static int ufs_qcom_enable_lane_clks(struct ufs_qcom_host *host)
>>   {
>>   	int err;
>>
>> -	err = clk_bulk_prepare_enable(host->num_clks, host->clks);
>> +	if (host->is_lane_clks_enabled)
>> +		return 0;
>> +
>> +	err = clk_prepare_enable(host->tx_lane0_sync_clk);
>>   	if (err)
>> -		return err;
>> +		goto out;
>>
>> -	host->is_lane_clks_enabled = true;
>> +	err = clk_prepare_enable(host->rx_lane0_sync_clk);
>> +	if (err)
>> +		goto out_disable_tx_lane0;
>> +
>> +	err = clk_prepare_enable(host->rx_lane1_sync_clk);
>> +	if (err)
>> +		goto out_disable_rx_lane0;
>>
>> +	host->is_lane_clks_enabled = true;
>>   	return 0;
> 
> Let's keep the \n above return
Sure, will take care in next patchset.
> 
>> +
>> +out_disable_rx_lane0:
>> +	clk_disable_unprepare(host->rx_lane0_sync_clk);
>> +out_disable_tx_lane0:
>> +	clk_disable_unprepare(host->tx_lane0_sync_clk);
>> +out:
>> +	return err;
>>   }
>>
>>   static int ufs_qcom_init_lane_clks(struct ufs_qcom_host *host)
>>   {
>> -	int err;
>> +	int err, i;
>>   	struct device *dev = host->hba->dev;
>>
>>   	if (has_acpi_companion(dev))
>> @@ -379,6 +398,18 @@ static int ufs_qcom_init_lane_clks(struct ufs_qcom_host *host)
>>
>>   	host->num_clks = err;
>>
>> +	for (i = 0; i < host->num_clks; i++) {
>> +		if (!host->clks[i].id)
>> +			continue;
>> +		if (!strcmp(host->clks[i].id, "tx_lane0_sync_clk"))
>> +			host->tx_lane0_sync_clk = host->clks[i].clk;
>> +		else if (!strcmp(host->clks[i].id, "rx_lane0_sync_clk"))
>> +			host->rx_lane0_sync_clk = host->clks[i].clk;
>> +		else if (!strcmp(host->clks[i].id, "rx_lane1_sync_clk"))
>> +			if (host->hba->lanes_per_direction > 1)
>> +				host->rx_lane1_sync_clk = host->clks[i].clk;
>> +	}
> 
> This is technically probably a little faster than calling
> clk_get() again, but please do that instead

Sure, will take care in next patchset.

> 
> Konrad

