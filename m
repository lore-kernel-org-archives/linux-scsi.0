Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB3A3EDE73
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 07:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784013114; cv=none; b=r+muXLv0mAJwZ+cM0GA9HaOJKZ5PtJIASkhddYsxj1Jtg3YCYIfX8p3+ENt6tfCd8iQLsfnUuWk3gCNVnyZG1z+okaEIVtpPJKV9oaqAkJ2+JiIGX5t14CEYJ+5JMLmoya110eklqd/fJrc43PkSzWLavkoCPu7jxrxsb9HdpX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784013114; c=relaxed/simple;
	bh=GZxTtPz5TUEBSGcSfR44kX4y/zG6hmSgBYYPvrBj7wg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F76eP+Lyrkne2u1zVW8RR4jqITPvRq5kBJbBWc7eRL8cbs1bljphiJOZ87Bf50O7O+IZwL4Akfbod8PXDpdoXZAz/WwfWpXAzdH/okX0tYnVaVulvuAzOZaAnVJD4sBCsEawqZcAk3Nc9DAPV2hLJfmgHSxYTH0n7bVLQpdTtv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=muZTeiI2; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Z0b/YwiC; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="muZTeiI2";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Z0b/YwiC"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66E6SboA4005305
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 07:11:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ugGwcyZt6s9qQj3EvTILPzJ9fhhPURDJsFNxoqUpz/o=; b=muZTeiI2OCdnb1eh
	QIocly0MiU+FAjx3PvUvU4kZ2xGNPUHR1C/iReky1XAZsbtQkKsPPMp3tJYIGhh+
	bHUzGdOOtd53JNN16VDLG5DiFSroCihfiq4hyIk5eoVw9s/51dkbC239QQDbLY2H
	XI9pyHuKl2Poy0eUarcBKoEEy29naxpVY06h6WHgSt7rhByRWOstra4dNO+wEGli
	9gLFz8qD52ltEqKdxZjYs+M1QAV3YTT5OPv9j95cpTjEbxjFZwpOAhFeWvqRr6/J
	u5y9qrUI8NhbLt6tgSxZI2C4kZq8QHO4GXqE620bSrBHaGJjx374yrvEZGgsBG0b
	XZj1vg==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fd44cthsp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 07:11:37 +0000 (GMT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-51c1e777a15so8057471cf.2
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 00:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784013096; x=1784617896; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ugGwcyZt6s9qQj3EvTILPzJ9fhhPURDJsFNxoqUpz/o=;
        b=Z0b/YwiCHHanEMCgI9V2lh5jao25v/rNXxgkJSmsPNhARj+7Swy5Vq824NqUbx6oLV
         mNcwAsWGWte4seFm6Tuh95UEjjdZ9vr6c2dr+npwnfvld4bBx6yLR8NtrlVlqVaU2uud
         cgKDlINXUnPa9sIBp92hEWD6gmVbdlUZ8AEylf8u44GEmSTYSolkVgQDzlmp6MeUOfF5
         4Y/V5VJBrudjQfOeDsPje4CXvwqA0dMnhRNyHK6gNo29OcBymg+D9lXEQJHpCLN+ldzQ
         K77BcpuD6RgtScc+BRujXA3CLoZ0crrjD0EdnIvRtch4fewBGk2T6E5UH2fvDaui4/l6
         J+gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784013096; x=1784617896;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ugGwcyZt6s9qQj3EvTILPzJ9fhhPURDJsFNxoqUpz/o=;
        b=Kv1DGaabiVxZ7Jt9+nhPEk3zy+PQ1jdibRhl3T5ozBa5gJ3fQzsl+e1SHUtxaytiTr
         Kw5jCFplGpAPy1sFgchGD4xKdawyF5MqFKyw+alUdf2SrQuwD7P4biMopnXHLz/JueGQ
         YkjJ/7EqqVdi8Uii5DTgZXcGofctxedx/6yJiCW7OyYU0zKEgVR+rrcqj3BLHlTkyGzA
         8xk5RGlM+3RusYKZjEL54Y+x5wRuDoQx37uUGmzy48rJK9THM6HubZm8cPvX2+ySmDzi
         qPDRqaAZ+Yj9BhjdAlE8lFilY6DKflBSPiystam0hijn6X7ZRo8/Tcz+w/0u/xDDFxX6
         AOwg==
X-Gm-Message-State: AOJu0YwOxRYIIczKJ2p4ii973sM8AftL/xz4vydKoskN7YWNXceq+ZuM
	2bhufrSxoA5j0kwDExSGT+piQPF39DHAG5FpK4SQwzyeM/yXzgehb5PZ7H2rcNb24qB0PdXuoGn
	UHLhsV8/QHtTWq/hzVzafndRo4wCEslcHuOJ9slRVq712fLndXLbPHUjAvW2jWXtA
X-Gm-Gg: AfdE7cnTy9mHLPBQqx0F3up9sAguTlHXD2fe4VtjDEUxSplnami40aARfyNYR/FqvTk
	9hsrZhhwq25fj1VCHfhIKYsawuM6aA1TT2iWpAsyLczsR+/D3MqYYr65FRGM6DjV33UIqnhWmQ0
	Y+Y7/rhBrV8+iax1gMrbgPxRVxvjimhMql4bnONeKjjZclDUSqxbsR+SEpPoqZgqB9ts0Nn6WPr
	oN0t4U5y+yepq6JJhR3Akmezrjhir+meyqKQfGBdTpma8fZcHbkPoy9/gqhrJDgWthQy2wPrAI5
	byts4wvJcX1odp49OHZWNmqCDF9Qtmj8P8VBoQBqesSjrljJmm4dtra7WxWC93eMq556UMsCIOF
	T28n/tnrsUnZb+Qiw5fY3vRFZ0iCNdkat4Xg=
X-Received: by 2002:a05:622a:64a:b0:51c:223:3c57 with SMTP id d75a77b69052e-51cbf3ae021mr90122541cf.10.1784013096536;
        Tue, 14 Jul 2026 00:11:36 -0700 (PDT)
X-Received: by 2002:a05:622a:64a:b0:51c:223:3c57 with SMTP id d75a77b69052e-51cbf3ae021mr90122371cf.10.1784013096074;
        Tue, 14 Jul 2026 00:11:36 -0700 (PDT)
Received: from [192.168.120.193] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-69cd292452bsm935204a12.14.2026.07.14.00.11.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jul 2026 00:11:35 -0700 (PDT)
Message-ID: <f9abba69-7b0a-49f3-bd83-b38a7a451cd8@oss.qualcomm.com>
Date: Tue, 14 Jul 2026 09:11:31 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V1] scsi: ufs: ufs-qcom: Enable only lane clocks in lane
 clock APIs
To: Nitin Rawat <nitin.rawat@oss.qualcomm.com>, mani@kernel.org,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
References: <20260713173434.883386-1-nitin.rawat@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260713173434.883386-1-nitin.rawat@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: 5Oifqoz6d5oaq5MO3HcEQJdFxfA_rl2j
X-Proofpoint-ORIG-GUID: 5Oifqoz6d5oaq5MO3HcEQJdFxfA_rl2j
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE0MDA3MyBTYWx0ZWRfX8wGgP6u2/Te1
 rL1eU7KtJzQkRx+vLR4etuKFsXMFG54d/QzS29hzsNbqpcFzLmEd3XMgkZsMwzlz2CNP+SeOyEj
 J3VB0CiMPQj0wJE3pOtccdEnfTSavE8=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE0MDA3MyBTYWx0ZWRfX815v2rxjuTLy
 VBgWJe8bzd4dv3hZcSnzwM+c6vuPhPxSgR7bsNVG4/Fv7ZpX72QC0Xzv0nyM+9j82RsG3O45xxD
 sGC79GBPTiwomKyqSU3+I/i/6v22NBmDR74XeMqLIeW/hgOjkl3kgEgwAe76k6YOSwWUPhHoe9c
 6pd8Z5lXc6gpkl0nWcBnSEx7VmHZ82F6HZVrt+MR6uXQH426sy3LVK2JKUAa0p64rmjSRGIOe3b
 h07djoF6gqdRxZlo/fgUpk/OzftDmvpdvqVYpQz4Ug6PaHoP5MMaGA52XsgwtNIjmFhBbusSTlo
 temQRDdnFr75IydDzDzud7lMV4pHNFetLf9dr/xF8R5KfRwg81kKNIFMQ9V52IjIXevCKD0ER5Y
 oyBcM+7VeUldG9Qww0/R0zx5/YLlPsVjSgBtX0m2I3A608eBZnnuVWNpAKDQuGzRv5lab3hQs+S
 KNNzwBbIU4PII0O8M8w==
X-Authority-Analysis: v=2.4 cv=P84KQCAu c=1 sm=1 tr=0 ts=6a55e129 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=EUspDBNiAAAA:8 a=uefoKjtKnMR8LWLuYnIA:9 a=QEXdDO2ut3YA:10
 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-14_02,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 impostorscore=0 malwarescore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 suspectscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607140073

On 7/13/26 7:34 PM, Nitin Rawat wrote:
> ufs_qcom_enable_lane_clks() and ufs_qcom_disable_lane_clks() currently
> use clk_bulk_prepare_enable()/clk_bulk_disable_unprepare() on the
> entire host->clks array obtained from devm_clk_bulk_get_all(). This
> array contains all device clocks, not just lane symbol clocks.
> 
> Since the UFS core framework already manages the non-lane clocks via
> the setup_clocks callback, the bulk enable/disable in the lane clock
> APIs resulted in duplicate reference count increments on those shared
> clocks. The extra enable counts were never balanced by a corresponding
> disable from the framework's clock gating path, preventing the clock
> reference counts from reaching zero and ultimately blocking CXO
> shutdown during low-power states.
> 
> Fix this by restricting the lane clock APIs to only prepare/enable
> and disable/unprepare the three lane symbol clocks (tx_lane0_sync_clk,
> rx_lane0_sync_clk, rx_lane1_sync_clk), leaving the handling of all
> other clocks to the UFS core framewore.
> 
> Signed-off-by: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
> ---
>  drivers/ufs/host/ufs-qcom.c | 41 ++++++++++++++++++++++++++++++++-----
>  drivers/ufs/host/ufs-qcom.h |  3 +++
>  2 files changed, 39 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 291c43448764..7ec1626704c6 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -347,7 +347,9 @@ static void ufs_qcom_disable_lane_clks(struct ufs_qcom_host *host)
>  	if (!host->is_lane_clks_enabled)
>  		return;
> 
> -	clk_bulk_disable_unprepare(host->num_clks, host->clks);
> +	clk_disable_unprepare(host->rx_lane1_sync_clk);
> +	clk_disable_unprepare(host->rx_lane0_sync_clk);
> +	clk_disable_unprepare(host->tx_lane0_sync_clk);

I don't know if this matters (probably not since IIUC the controller
would be suspended already), but downstream disables them in the
following order:

TX_L1
TX_L0
RX_L1
RX_L0

> 
>  	host->is_lane_clks_enabled = false;
>  }
> @@ -356,18 +358,35 @@ static int ufs_qcom_enable_lane_clks(struct ufs_qcom_host *host)
>  {
>  	int err;
> 
> -	err = clk_bulk_prepare_enable(host->num_clks, host->clks);
> +	if (host->is_lane_clks_enabled)
> +		return 0;
> +
> +	err = clk_prepare_enable(host->tx_lane0_sync_clk);
>  	if (err)
> -		return err;
> +		goto out;
> 
> -	host->is_lane_clks_enabled = true;
> +	err = clk_prepare_enable(host->rx_lane0_sync_clk);
> +	if (err)
> +		goto out_disable_tx_lane0;
> +
> +	err = clk_prepare_enable(host->rx_lane1_sync_clk);
> +	if (err)
> +		goto out_disable_rx_lane0;
> 
> +	host->is_lane_clks_enabled = true;
>  	return 0;

Let's keep the \n above return

> +
> +out_disable_rx_lane0:
> +	clk_disable_unprepare(host->rx_lane0_sync_clk);
> +out_disable_tx_lane0:
> +	clk_disable_unprepare(host->tx_lane0_sync_clk);
> +out:
> +	return err;
>  }
> 
>  static int ufs_qcom_init_lane_clks(struct ufs_qcom_host *host)
>  {
> -	int err;
> +	int err, i;
>  	struct device *dev = host->hba->dev;
> 
>  	if (has_acpi_companion(dev))
> @@ -379,6 +398,18 @@ static int ufs_qcom_init_lane_clks(struct ufs_qcom_host *host)
> 
>  	host->num_clks = err;
> 
> +	for (i = 0; i < host->num_clks; i++) {
> +		if (!host->clks[i].id)
> +			continue;
> +		if (!strcmp(host->clks[i].id, "tx_lane0_sync_clk"))
> +			host->tx_lane0_sync_clk = host->clks[i].clk;
> +		else if (!strcmp(host->clks[i].id, "rx_lane0_sync_clk"))
> +			host->rx_lane0_sync_clk = host->clks[i].clk;
> +		else if (!strcmp(host->clks[i].id, "rx_lane1_sync_clk"))
> +			if (host->hba->lanes_per_direction > 1)
> +				host->rx_lane1_sync_clk = host->clks[i].clk;
> +	}

This is technically probably a little faster than calling
clk_get() again, but please do that instead

Konrad
