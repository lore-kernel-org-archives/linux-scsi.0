Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2284F34EF09
	for <linux-scsi@vger.kernel.org>; Thu,  4 Dec 2025 17:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764869915; cv=none; b=QDzuOAjvzFiyRWUTqmiAIba46zxQxLrAcChe029go984kKrAI+EF20mgQqWb0Ll93WaRDDPGAKSFXXVxcKF/c3cc/cg+57ilh8PDQrwcPTxbsAdqjJYjH06a2GtqDG4sttnhhQ23UnAKlGRCs8rvkR+qpzqouMA83Wsi0fopRmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764869915; c=relaxed/simple;
	bh=JV1vvE82GIsAgB9psmMe4VTiJDDN3xJkL513DA7rWmw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rw/4s7AWKVuSOGphjNLm4adKopX1aRzQU+1st3u7LP4V6a2byuIhlesITeNZW/FRIoZ3gskS79J49ywgVSjYZm/RFJgmUJ69nQnNmygXFR/sR5cc8GDRCShMHIzebcxy1ngA28AnbRU2i7nCvGUVZ+1bdvq/LJk2ThPLQpdFOiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=YwKLpFz6; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=UAX8HMRq; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="YwKLpFz6";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="UAX8HMRq"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B4AErSb1130941
	for <linux-scsi@vger.kernel.org>; Thu, 4 Dec 2025 17:38:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	SH8WPhTr82kVgMlLp3hoCOdUADKDgfifYkrjZL3bb64=; b=YwKLpFz6L9NtS6Pi
	4Bxnwvh+j+8sAn64AdCSL4GZd+m8rUKQtN/VTWstLb/nSG9wgdJdTFXrprTTvRiL
	/I5136yguR6rhAo7cEHjI5/IZ1bGLeWKfnMNrcs24H43b51gVV95mr6rjGW5mG81
	9Z/+hkIUKSS5JyATtbjzs0O/3u5lIIgOh9aegpUeJXTphsVeHOtiJlPWFdjGA+C3
	mHV/ZY+zzuIixyEzov8RfrTmQ6BdsuYQKLxPKdM8w6622wV27SvRU08YeMsw7iTy
	n+KrtA3+76YSd+RPQAJsqoQXq6y610MvxHAMSuhx50Qv9GEBohf5VV7NBdErSQF4
	/yZmyQ==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4au1f02mg6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 04 Dec 2025 17:38:30 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-7b8973c4608so3143785b3a.3
        for <linux-scsi@vger.kernel.org>; Thu, 04 Dec 2025 09:38:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1764869909; x=1765474709; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SH8WPhTr82kVgMlLp3hoCOdUADKDgfifYkrjZL3bb64=;
        b=UAX8HMRqAACgFehpFIBzX3atX9EEfyR6+fOu7ZLPALEL5EYcqoKZxPFnA7OmV0TYUY
         i73LhA3zecnu2ANTitzc1nSQY5lGLAwztTJyvVRz7PVBOLfTNDDFf4+7JWFcIm+NI+FT
         dnf9fAOGEDwc+sQ1iZ3jLtbstmS07uR1GGgqQn7F3mx2bDOA4vlew0/3XfDs1KJ1fsGR
         CL3YX0NeT7OpvkyN1Jn6GL1iHvnbgorP7LD1UNFKtH3Dh1xvYxamT/9kclPx9njWXuAY
         D+b4G/eM7uHrH3EK4dm2OpyZ/eL804dsDAvwVGAvjB4b7qN7Bs3r+7d3Gvwf86uIeoz0
         sFfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764869909; x=1765474709;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SH8WPhTr82kVgMlLp3hoCOdUADKDgfifYkrjZL3bb64=;
        b=KUG4CV+TxvHfcx4bin4qvGbFyOX0uKEHBEJuwsb+nkZjYF6efRmFJmfnHrdFCN9jmI
         ggcDGt6ng+mGStfrfRfcypGg2mffLKQ82vu3s4JHZl7iH4FAPTxhw/TsJnGG82vPK7BY
         Jge0ocLoAV6IBSID4JAaUU04t4+WXCFpyAN9p1SvwQuMN47ZMfICAPQWMFlR52L6EfNR
         ufpeetDYWg0h7BK3wez0ErpIGe6ADkMYXs5uM3oJY7AeacEh3tmRODXeakUBoezDjcEn
         O3ZMhj+XEsAlBGjRZXaB+Xx1ELVXk8wwd0lH9ogPEqvMoxfNh/lu73ge23AZ2XCcVLGo
         LSNA==
X-Gm-Message-State: AOJu0YyRwK+f5/VyZAlj8Q2zaORs6TfzkkE7yX58JN2CUr0+1cayxy7K
	pvx9leNVjYi0BvIlhWtfXQt+lFvpaVXNsZhJ9pdQMzcl5HqISQ1jN/Qikn0VNUOj1l1k6/srv0P
	2y616gf62nlJfeBh4zdI9LrR0oB0//PibbepJWDcBIOVMtuwLtNSfAkT5eB2F0ifn
X-Gm-Gg: ASbGncu/eVuk+rCrVU1GY4cKTUBG1U5UEvXJCbXmxzI6lH7mSjF1IbOJzp0SYAEm41e
	SdPlDBNIJ0F0HfoK7FZ1nazPhDn0LDoK68kBhA/AZP1nY/wqAOUKqQv/J0BCoJygv58xr17wrm+
	yc+bQ8RkE3f34gRpH0S4EzRARgIsVNcKKDvfWY0rXge2Frl0RXUThrm4ilPTzz3l3QVjTXcFUzA
	YV5wmtAMmIFY9UutxeLmBMWe4C9CrhwAOM/J5UxQn+fYU1SGAQDt6WllAXObk6sBf00N7CeEPT1
	VbvPvSJGjNjGKrCIjM0i7m0rbcWWi4bXSlBmPrZQ3mIVWFMrwFuyBxMJCIx3ex7r4De0xsVbMTp
	t2AiI38U0Pc78Cn9AV0hYN04=
X-Received: by 2002:a05:6a20:3943:b0:35e:da63:4e7f with SMTP id adf61e73a8af0-3640384ed2dmr4742394637.39.1764869909032;
        Thu, 04 Dec 2025 09:38:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGcWJC9lqkiGOgqZeeqHP9ixZvniwKsW4bcLqNobBGMSQtfMdSDIljg0KuPuyWqQ5jRS0L7Bg==
X-Received: by 2002:a05:6a20:3943:b0:35e:da63:4e7f with SMTP id adf61e73a8af0-3640384ed2dmr4742371637.39.1764869908606;
        Thu, 04 Dec 2025 09:38:28 -0800 (PST)
Received: from [10.216.3.38] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bf68155047asm2417608a12.7.2025.12.04.09.38.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Dec 2025 09:38:28 -0800 (PST)
Message-ID: <5bf4b4f0-4e76-43b9-a27c-e2f87f0de5a6@oss.qualcomm.com>
Date: Thu, 4 Dec 2025 23:08:22 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ufs: core: Fix an error handler crash
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Peter Wang <peter.wang@mediatek.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
        Avri Altman <avri.altman@sandisk.com>, Bean Huo <beanhuo@micron.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
References: <20251204170457.994851-1-bvanassche@acm.org>
Content-Language: en-US
From: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
In-Reply-To: <20251204170457.994851-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: 2m9-_yBWHTpYtERgnVOEwtEyxHIs7G_G
X-Proofpoint-ORIG-GUID: 2m9-_yBWHTpYtERgnVOEwtEyxHIs7G_G
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA0MDE0MiBTYWx0ZWRfXyFKGaB9B7zPc
 jaEjBXRVUw9H9ZdxJ+/jirwNDc1AIJmlyCPF2bG7wdtmCNs2DsUhYPBwW61fZ/5hCgVaPvLoNDR
 idwf+Bnm0uCKkZaJVoFUCbCRPYDh9sDD6f5wvKcHaHyRiK03a8EscDZRVZdDOle2+vkZa4JP3Cp
 DKtPnEL1IliFRZ2a9aIRb1CpFZUndLuFwWr4UB1jLPlYCNK/2NE8vaFIKqVP1stG2K36Ci1NCWy
 fsFqsee3B8YXCSNCTdX895DcazLmhyk/gLbgkDVm4HdJSTnWEzEai6lYKCJ0K0M9P/lS0WIpYLo
 ak4SFO+ez4HbYKaevb235hRdWqM5vnQqf1XJAW/atovPGCO35wSlcQZqcuGCDnIoYCTi7rWEEn9
 v+5RnU1fChARRMfWUVVxfVgrwSIlBg==
X-Authority-Analysis: v=2.4 cv=Scz6t/Ru c=1 sm=1 tr=0 ts=6931c716 cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=mpaa-ttXAAAA:8 a=EUspDBNiAAAA:8 a=N54-gffFAAAA:8
 a=sA4y0wbjmcINiiBxjmsA:9 a=QEXdDO2ut3YA:10 a=OpyuDcXvxspvyRM73sMx:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-04_04,2025-12-04_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015 impostorscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2510240001 definitions=main-2512040142



On 12/4/2025 10:34 PM, Bart Van Assche wrote:
> The UFS error handler may be activated before SCSI scanning has started and
> hence before hba->ufs_device_wlun has been set. Check the
> hba->ufs_device_wlun pointer before using it.
> 
> Cc: Peter Wang <peter.wang@mediatek.com>
> Cc: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
> Fixes: e23ef4f22db3 ("scsi: ufs: core: Fix error handler host_sem issue")
> Fixes: f966e02ae521 ("scsi: ufs: core: Fix runtime suspend error deadlock")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/ufs/core/ufshcd.c | 25 ++++++++++++++-----------
>   1 file changed, 14 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index b834b9635062..80c0b49f30b0 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -6698,19 +6698,22 @@ static void ufshcd_err_handler(struct work_struct *work)
>   		 hba->saved_uic_err, hba->force_reset,
>   		 ufshcd_is_link_broken(hba) ? "; link is broken" : "");
>   
> -	/*
> -	 * Use ufshcd_rpm_get_noresume() here to safely perform link recovery
> -	 * even if an error occurs during runtime suspend or runtime resume.
> -	 * This avoids potential deadlocks that could happen if we tried to
> -	 * resume the device while a PM operation is already in progress.
> -	 */
> -	ufshcd_rpm_get_noresume(hba);
> -	if (hba->pm_op_in_progress) {
> -		ufshcd_link_recovery(hba);
> +	if (hba->ufs_device_wlun) {
> +		/*
> +		 * Use ufshcd_rpm_get_noresume() here to safely perform link
> +		 * recovery even if an error occurs during runtime suspend or
> +		 * runtime resume. This avoids potential deadlocks that could
> +		 * happen if we tried to resume the device while a PM operation
> +		 * is already in progress.
> +		 */
> +		ufshcd_rpm_get_noresume(hba);
> +		if (hba->pm_op_in_progress) {
> +			ufshcd_link_recovery(hba);
> +			ufshcd_rpm_put(hba);
> +			return;
> +		}
>   		ufshcd_rpm_put(hba);
> -		return;
>   	}
> -	ufshcd_rpm_put(hba);
>   
>   	down(&hba->host_sem);
>   	spin_lock_irqsave(hba->host->host_lock, flags);


Hi Bart,

It seems you missed sending the below patch. Both patches are required 
to address the issue (hang and clock scaling errors), except for the UIC 
error, which still needs to be root-caused


 > diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
 > index 1b3fe1d8655e..fd0b6b620b53 100644
 > --- a/drivers/ufs/core/ufshcd.c
 > +++ b/drivers/ufs/core/ufshcd.c
 > @@ -1455,15 +1455,14 @@ static int ufshcd_clock_scaling_prepare(struct
 > ufs_hba *hba, u64 timeout_us)
 >   static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, int 
err)
 >   {
 >         up_write(&hba->clk_scaling_lock);
 > -
 > +       mutex_unlock(&hba->wb_mutex);
 > +       blk_mq_unquiesce_tagset(&hba->host->tag_set);
 > +       mutex_unlock(&hba->host->scan_mutex);
 > +
 >         /* Enable Write Booster if current gear requires it else 
disable it */
 >         if (ufshcd_enable_wb_if_scaling_up(hba) && !err)
 >                 ufshcd_wb_toggle(hba, hba->pwr_info.gear_rx >=
 > hba->clk_scaling.wb_gear);
 >
 > -       mutex_unlock(&hba->wb_mutex);
 > -
 > -       blk_mq_unquiesce_tagset(&hba->host->tag_set);
 > -       mutex_unlock(&hba->host->scan_mutex);
 >         ufshcd_release(hba);
 >   }


Thanks,
Nitin

