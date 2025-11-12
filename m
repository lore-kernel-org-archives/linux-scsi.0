Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B21A2D7813
	for <linux-scsi@vger.kernel.org>; Wed, 12 Nov 2025 06:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762928747; cv=none; b=FC1JSY5L0G9YPXjJ8/Q5Ph3VGAqNBU1HLIRLRmCA54YCHQiUBK+N2Of/MD8PaT7Jsf3Mo8qfycILXt3xMvGzDatpxwEam3y7kuRMs8YCcFpY1DMZddNQi1vx6d8yLV8jimu0vg8/Wy8YV7efHGG/deUwjLsM02Ya7LpWUpWtiRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762928747; c=relaxed/simple;
	bh=RDA4LzPk3maSgQAGPSWxx/Jhm7JGlhcxeaMTKnnn3x8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VXoX/AHI2IjLIyykCR0uhYYLyTfnNTt83lvqC/ilxhJ0/HzyF4XcFvzaKDJC7wVRlcW3Z11R6TAaODUlmMTLqI9cjTbFx5TgIuUYc2JdfQ4QLl7XPlR8hnyQAztZbtAN3cd+YGy5jC+PXeFrBKZ2VkPdAGzNFt3A/ps3Q9uZwtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=D8Qus7B1; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=SAhR7Q3t; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="D8Qus7B1";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="SAhR7Q3t"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5ABNbBkO2540381
	for <linux-scsi@vger.kernel.org>; Wed, 12 Nov 2025 06:25:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=ZwTrPuuqQ5kUNPyeNuPlDMBg
	Z7FIia6QmEgvCuHsG9w=; b=D8Qus7B1RGEYvtVDlN2VKOXHMyXBYbUmEvK/aNEp
	XaVXd/NooKZiSJavgJZqlLReiotKGBekBbbvtwnNyX7JORN2XAMOm4Un2LRJzbtH
	8tj4kLy8He4AMBMvseb4C2dBvVEgABuvenGs6q9Kfb2udv15rfCetOWArWQ0JEmn
	dF2RZhcESxkQxQ8vJE9oAvE571wAHmJjlKBG4g+lFGvhlZm8SIAv7ewbOGO9PQBn
	1fC6Kof9VrbOBOhW9KZQYzfh6sgWuJi8hsf3l/VUWSCFdqJcCsah/2ZHzlBpq1Yk
	UgfEcpqujR7IMDzkpYzNlRvfdZHyTM2941tIYr+D1pPNnA==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ac5fgjnju-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 12 Nov 2025 06:25:43 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-b9d73d57328so488938a12.1
        for <linux-scsi@vger.kernel.org>; Tue, 11 Nov 2025 22:25:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1762928742; x=1763533542; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZwTrPuuqQ5kUNPyeNuPlDMBgZ7FIia6QmEgvCuHsG9w=;
        b=SAhR7Q3tIY7xydQXJYTLHyFIcDLeqWxUBWcw9MpCNCBgjYSzDn/CIJHeyiMLoXZyjz
         1odmV5bsqloakuJreNJUjuMBbPQOgABY7yEr/t+69XGyLYiHnFTXfh0FAymskRg5EI9/
         AgemSoZZVQwQJzClNay0ZRybEg+wBBPTgf+hPkBzYabD+7KUZnzBzxgo56rQ6RftQ1/r
         HG+iJfyosLt3IBTSRY2W7SaHdynhssWkwhcTjxJYcm2sEL2/y8wnIIJ0kznaoB2bgqr9
         yFmgahdabwD218/Tbhpg5qfRVU9cyI0KElFPsCeL5tM+/9OkfOUn5zRTjVukowZGo2Sy
         b4aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762928742; x=1763533542;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZwTrPuuqQ5kUNPyeNuPlDMBgZ7FIia6QmEgvCuHsG9w=;
        b=wrUa1inwX/8N37oR24gYIZfUz0FptsnlE/jDftkcmv+L5VnJgWi1BJwavuL7/as41/
         xtd+iG3kkdLwunrfBtnCrEStLtYfrUJXNRE4hyLouthZbUx6t5EtWI3dGdEpyPs+TG+a
         DRYavTzgdlK+DoZGUdvN21UorgMO1gr6+qxR1alNnIuM7Q14me1Z+Ooe5Q5XC0QaFFo3
         2hGR3AolrbawojwcGp+JzpW9kECadoYWJ1Fth59qwFevpj8ZZYUb+C96m2JTzxxqBgOF
         t+Mm/VcY4tpcrysiHg8iQ7Ep4kKBQNwzwFiUzbRVYSDPM3I3VbYlemoA95wPj3muTuzR
         Kdgg==
X-Forwarded-Encrypted: i=1; AJvYcCX593ZjqQnc/NFdIzP+zTw2AKuKIfZioUSCGs9UWYfpmqAP0BKlVCbWpbcryObpxAgJdQdeCIDPWOxt@vger.kernel.org
X-Gm-Message-State: AOJu0YzeIEOOYpjHnHpVLvqZwJOjb4hdxunqRpELEkpgwGN9dNToOjkK
	hxJeXTRA3dyhBde91p0K8C3ie1h55A8YzZFH66aVL/WfgP67bRIo7jNXO74QwuIDQN4/3cCwtQs
	+7M/sNu01xAUBVYJ08fOUFBYBPDpNB6Iqv5zpIKR8j/Vuj+V4CFIFtBbP5IyqNWI8
X-Gm-Gg: ASbGnctzETC2Iycj0rw/10SpHPCec4hzOBU9ORdUyeeRvdiu6tp68DMvZMxWcMsUAo/
	FXZCLQVWLNDcZZ2hbfVCzqkpeXxRZ8GuHurofTMPz1W24PsSLOaLIanszTEycweKgowIjVJzJyf
	gNzWiD2Dt3f18/nScu8FslGkMji8dgd25p2zzc1nHKf3XkKqXIj942h/MAHCBLYilDTuzPTpD2h
	Wp7/Ye4Y4I3motHHCRC/caNpMgjoCLNz6RKvw0ej/U0axFnHvf8Bj7OB9vxBTGq6647CdQ71VZw
	M0RyxpG1zl2fUnCUSIhmqfL2mMdFFFAbFun1SiVpL/eSY0epcmvUlddsakdELawN3oUhEiNW6Ph
	g/77nUMuL3O3w8r783ZOFoKSTvLtw6wkLqTR1
X-Received: by 2002:a05:6a21:3384:b0:355:1add:c291 with SMTP id adf61e73a8af0-35909095f95mr2684096637.10.1762928742240;
        Tue, 11 Nov 2025 22:25:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF7S/HbpcFUy6Id6iVkQsaUPl6jWNJy4+2pSyvWNLTMUPGF56hhKNHEj1W+hDgz/gITQ8wsjA==
X-Received: by 2002:a05:6a21:3384:b0:355:1add:c291 with SMTP id adf61e73a8af0-35909095f95mr2684069637.10.1762928741682;
        Tue, 11 Nov 2025 22:25:41 -0800 (PST)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b0cc769e59sm17159899b3a.50.2025.11.11.22.25.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Nov 2025 22:25:41 -0800 (PST)
Date: Wed, 12 Nov 2025 11:55:36 +0530
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
To: Bryan O'Donoghue <bod.linux@nxsw.ie>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 2/2] ufs: host: scale ICE clock
Message-ID: <aRQoYHsOuCNhBmzD@hu-arakshit-hyd.qualcomm.com>
References: <20251001-enable-ufs-ice-clock-scaling-v1-0-ec956160b696@oss.qualcomm.com>
 <20251001-enable-ufs-ice-clock-scaling-v1-2-ec956160b696@oss.qualcomm.com>
 <d31e4bba-5438-480b-8d3f-229ac5b4ddf4@nxsw.ie>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d31e4bba-5438-480b-8d3f-229ac5b4ddf4@nxsw.ie>
X-Proofpoint-ORIG-GUID: ZQRmkSousHrsSJeAkCBWyYiNHufVoIdC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEyMDA0OSBTYWx0ZWRfX5NmPds51u7Lf
 cEPwjF0hUqPJutxc45tJnp0ByYFEYqWgaZJpMNyc+Rr2LZpsPT+5n1kIl2hYh9Tcp6PH/F9G6Yw
 IWt8mfAUPJIy0+uUN7N5KcI88WQUyhmien01sXPwDPizNLtirS9MXkpv9fWgovTawLwmIhtpT8m
 Z1P56uVdpdpsXwRO8W4ATKV8ms9usBznsSClL2FJkcU9xsoH3niGPg3lzA2xhL7nnH0UtE8Bc/y
 h9bzlbjsaPP80dT4wmHWI49J4LV1GOb9OZgMJMJgJGz2zBbKZ0eMf1yiyAjCCJvHwB1OFwgzW0o
 qJrUT3uQyLB+0Zf4XyCuOB6hX/NItE3oA5q09Z47xGYF+EjrJdSucTJS2ot23UoKOLaADmLP8Fm
 c/RO2fd9NBw7tgDUU+0f0Kbjt5iABQ==
X-Authority-Analysis: v=2.4 cv=B5u0EetM c=1 sm=1 tr=0 ts=69142867 cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=kj9zAlcOel0A:10 a=6UeiqGixMTsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=KKAkSRfTAAAA:8
 a=0fylSbPx36-Mud_k70YA:9 a=CjuIK1q_8ugA:10 a=_Vgx9l1VpLgwpw_dHYaR:22
 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-GUID: ZQRmkSousHrsSJeAkCBWyYiNHufVoIdC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-12_02,2025-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 bulkscore=0 spamscore=0 impostorscore=0 malwarescore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2510240001
 definitions=main-2511120049

On Thu, Oct 02, 2025 at 12:23:37AM +0000, Bryan O'Donoghue wrote:
> On 01/10/2025 12:38, Abhinaba Rakshit wrote:
> > Scale ICE clock from ufs controller.
> 
> UFS

Sure, will take car of it in patchset v2.

> 
> > 
> > Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> > ---
> >   drivers/ufs/host/ufs-qcom.c | 14 ++++++++++++++
> >   1 file changed, 14 insertions(+)
> > 
> > diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> > index 3e83dc51d53857d5a855df4e4dfa837747559dad..2964b95a4423e887c0414ed9399cc02d37b5229a 100644
> > --- a/drivers/ufs/host/ufs-qcom.c
> > +++ b/drivers/ufs/host/ufs-qcom.c
> > @@ -305,6 +305,13 @@ static int ufs_qcom_ice_prepare_key(struct blk_crypto_profile *profile,
> >   	return qcom_ice_prepare_key(host->ice, lt_key, lt_key_size, eph_key);
> >   }
> > 
> > +static int ufs_qcom_ice_scale_clk(struct ufs_qcom_host *host, bool scale_up)
> > +{
> > +	if (host->hba->caps & UFSHCD_CAP_CRYPTO)
> > +		return qcom_ice_scale_clk(host->ice, scale_up);
> > +	return 0;
> > +}
> > +
> >   static const struct blk_crypto_ll_ops ufs_qcom_crypto_ops = {
> >   	.keyslot_program	= ufs_qcom_ice_keyslot_program,
> >   	.keyslot_evict		= ufs_qcom_ice_keyslot_evict,
> > @@ -339,6 +346,11 @@ static void ufs_qcom_config_ice_allocator(struct ufs_qcom_host *host)
> >   {
> >   }
> > 
> > +static inline int ufs_qcom_ice_scale_clk(struct ufs_qcom_host *host, bool scale_up)
> > +{
> > +	return 0;
> > +}
> > +
> >   #endif
> > 
> >   static void ufs_qcom_disable_lane_clks(struct ufs_qcom_host *host)
> > @@ -1636,6 +1648,8 @@ static int ufs_qcom_clk_scale_notify(struct ufs_hba *hba, bool scale_up,
> >   		else
> >   			err = ufs_qcom_clk_scale_down_post_change(hba, target_freq);
> > 
> > +		if (!err)
> > +			err = ufs_qcom_ice_scale_clk(host, scale_up);
> > 
> >   		if (err) {
> >   			ufshcd_uic_hibern8_exit(hba);
> > 
> > --
> > 2.34.1
> > 
> > 
> 
> Once fixed.

Sure, we can bubble up the error log here. Will update in patchset v2.

> 
> Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
> 
