Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2509014EC73
	for <linux-scsi@vger.kernel.org>; Fri, 23 Jan 2026 19:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769196108; cv=none; b=PwMOePgWXmi5degaURqjw1Ckhb+LX66+1rjfFIEhMwrsZWi2wUNX4Mc1RGs/OlZoSwuAzDExAlOcbyEBarNx6tth4clTSqIBw+6vMr476EilvPz+/B9A7CZBWB1LaJv8AQnxTScTpyskOHiTgh1jPWmhj7oioZAL0Xk4kqNNoW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769196108; c=relaxed/simple;
	bh=3ih25kkrbzzOIKV5SfFyuGNMM9BXQ24vJh42IpI2S7o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sj1oxgjrcY7SoYPNrFS0EWaxuDtZdTosWwPWn3Jtc+M3aaL3pYqpckCkLYcllTytfMJewdQze4AfmI66qQRb9Qe8UIy3MP5niCZszN/U8RWlOcnYObZRSR7Qsism3r0D5q/XtaIQvMqndQ17IMGLjZ1p2BnN6a5yp9WjUZx6nIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=N7BHBAu+; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=jVB92avJ; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="N7BHBAu+";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="jVB92avJ"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60NGnQlw3650164
	for <linux-scsi@vger.kernel.org>; Fri, 23 Jan 2026 19:21:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=+N5DapHNEE3mGIGkjplP4cJj
	1SZDYlh4Lmk+xa+z4L8=; b=N7BHBAu+8hsCETRgaa45xIHsqdpRloFSKYmrwiqP
	aaxeGRKzWDvPoysW7QVaqo82uKqzIO6EfaY2/m7kdF9gneyabzdG0Zy8AfhcmuZw
	8JHdc3jDPE2r69uYkmBugE2H0Z6ys8xzzp0uik+RxF4bM8T5xMMfbJD4QweylX+S
	Ti/a5PZgIIMotbQqi+zJdBodHw2BnpUYvDy62NyehBsCfnH+4oWjQII1yOTu/LMo
	UQ5CCjeHDC1zFLMZmAINYWOcDPgau0nFON6oQKMna8zlV7yrsZNvTWWrmZLD7dUq
	4qwvnDUwKn89EHG+VDw5xRdg/iVsegDo/kJPtki45Y/g9w==
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com [209.85.217.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4buy4nuhbw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 23 Jan 2026 19:21:45 +0000 (GMT)
Received: by mail-vs1-f72.google.com with SMTP id ada2fe7eead31-5f55092e3fdso2728664137.0
        for <linux-scsi@vger.kernel.org>; Fri, 23 Jan 2026 11:21:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1769196104; x=1769800904; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+N5DapHNEE3mGIGkjplP4cJj1SZDYlh4Lmk+xa+z4L8=;
        b=jVB92avJt9hMIMUqhfCAzUVqknc0GASreG3dplnQWkrWYzcFeJLFZKxP/J+x1uKm1z
         RP/P6HYVEo+KFg/x3EaaOzW9OI3JY62nHcZ7GOTAiYavPuTa9BP0dGz+4EGZ+1F3FINg
         T4zomSIRtHrD64T5kLoZVDLZiYWZn9I7pmQOxUJyikKbv/MpeBlKwk+H9FKXiKie/Sk5
         5CO/9i9CVUk4Xvcmc/9nc+R54P6ji1MsWB1cshVFIQ8yRgDawJDMXfQFgeYk8u+CfZud
         Htd6dL5Gc1Bpn0SaJBYTh28xWr1HhLFOl2ot/5niSlOtdnnH/Gcuxeo47Z7Dnmg7HcQy
         l1Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769196104; x=1769800904;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+N5DapHNEE3mGIGkjplP4cJj1SZDYlh4Lmk+xa+z4L8=;
        b=JwzthpzgxCQQJ2KEcOYu+MdR6j5aJD3L9oT7A5suEezv6Fa1Y22BnljFvPOXKHV08d
         hnQ+ovmuL+jK+ghHlQ5n48lvli+loA8XRbiSHE7K1k29ZMVVP4GsyReCTQs4D+66w5Wy
         1r5HtlJCsMuMgTaH3qMrY0DtvfCEWw45ct7gHxs/nxo4182JJdc39hq4PcM6v6LW9JnA
         +5goKAlWJMgSaZQYFxh49xoNJQ3uFcAnFd09z2lgIlqenM1NdStgoh8KjxkQLM552hWo
         pgS9oxUKA9SbLiUHxFd1f1YXp3Mi2MDZ9l1X3fiC/ICNy1akjSwSJfXczR+A7eDKup5l
         X+GQ==
X-Forwarded-Encrypted: i=1; AJvYcCWhYMH99iSnjHdBY1R3rCkmIRUbxH7X6Ld4rnazKKqQGGileHT30yw2ScjZGAc5+BhD2GNI4HpZVx/b@vger.kernel.org
X-Gm-Message-State: AOJu0YzIv2omT4rq69GHErjPlxeSsGx89bxMQdyP8xDX9MsgLCciaolR
	3UoPwW+YBC0Rh4B8iBfXoW4jcPzk7lXXXsaFK3VOvxgGSQLeyTvSMK5Ca06K6DZQ5kMMcctA5O6
	nhXWgwNr+MRUXDXqJmk0zZIj0v8L4IlayQxzTepDRSOzA5gmCh8f9Uwe5JKYb7zALzsuYWCri
X-Gm-Gg: AZuq6aKvd9w9QqiH8Hit+LPjVoFBhLsb2JeiyrldZYKBb1g12vZ7eSwFKMQGC4s83m5
	WuGJGcKHxD1InU7wOMW+EsMxnpfxJGPuwXChH1g9bMBU16CKWStYJan24SuVAVasdkMyq9M4gcG
	cZ81RuzCib0R6wFsN9pMVwZ/1P4aTluOutOrdY/gy41w9KedobW1Y00HuPNIo/5WiMI4tjMsyUK
	s6L/xr9M7KKg0xyiVxs2yLYqXFHGZr221VzHZ1iSe35Ql2NuBi9oakTXjGOnCaS2wA1Xoeus+Xp
	zui2/NO+SZbOLchwXaKbjhv8uwvfuzD+l4DNyShMOtU3llP7iYAq7imjOsL3uPSRuGh2ITL7nYc
	AkiUyT9/SZT/bkFV7eBWO3kgOf/zzfFMSuaqYjnoY4IKArAAptXBeoCuuQrEt00TZFjjsjOwtut
	3ZqrRKjohGZPhSFaCRVnmKEXI=
X-Received: by 2002:a05:6102:162a:b0:5f1:b59d:a824 with SMTP id ada2fe7eead31-5f532e913f2mr2426496137.10.1769196104295;
        Fri, 23 Jan 2026 11:21:44 -0800 (PST)
X-Received: by 2002:a05:6102:162a:b0:5f1:b59d:a824 with SMTP id ada2fe7eead31-5f532e913f2mr2426484137.10.1769196103867;
        Fri, 23 Jan 2026 11:21:43 -0800 (PST)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59de491f9besm843579e87.73.2026.01.23.11.21.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jan 2026 11:21:43 -0800 (PST)
Date: Fri, 23 Jan 2026 21:21:40 +0200
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 1/3] soc: qcom: ice: Add OPP-based clock scaling
 support for ICE
Message-ID: <gfqpfzulzptkrbcrc2zcnqv6kmtdgwwxqc2rxnbq3rlh7azilj@srzlycd7wv4d>
References: <20260123-enable-ufs-ice-clock-scaling-v3-0-d0d8532abd98@oss.qualcomm.com>
 <20260123-enable-ufs-ice-clock-scaling-v3-1-d0d8532abd98@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123-enable-ufs-ice-clock-scaling-v3-1-d0d8532abd98@oss.qualcomm.com>
X-Proofpoint-GUID: 6EVJh59acuPMwGM5TWpLiP61zaqphKvN
X-Authority-Analysis: v=2.4 cv=I5lohdgg c=1 sm=1 tr=0 ts=6973ca49 cx=c_pps
 a=DUEm7b3gzWu7BqY5nP7+9g==:117 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=EUspDBNiAAAA:8 a=5EJMvZCbbiZMwH2kwcIA:9 a=CjuIK1q_8ugA:10
 a=-aSRE8QhW-JAV6biHavz:22
X-Proofpoint-ORIG-GUID: 6EVJh59acuPMwGM5TWpLiP61zaqphKvN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDE0OCBTYWx0ZWRfX/YOihQ/YaomX
 IzaGTlSoWixE56BgqXr+lD9XBKZcfw5P9RdVcLhZaTuMSPPcVkO+KxgRuqR4yCDt+oJ6OD8h8pf
 CzcjOuTvsajCJ04V4CyZLJijcOVp1pT++wE9mBJpbOD7wxnl4pBIpk7sAW8ZrjwZkUvLWPBoI9r
 2+0CVxcIBK6Em0O15OHLra2wuQkRKpdeUM3exjLul0uyB85mVxtNP8eqUOfd7q2N0SfXaWCmh3a
 urK4lV6rOGEWyIlPXFdQGYzn7rLEjyFMxvZVFl6N2bQkOQogE5fZbu27PUWiHAIiOTnkFexh/Sx
 ik1EbHTBtq85nAjhKQ+sjXD6AtpHQir9QsFr7YH4Zqb+D7+1cedS0ngezTh+ho4GIZkx9+Jj4Lv
 Ua3HZCyBQ6mzug8QBm1Bg+A6iRuL7QqqxNp4DuAZ8Bg2ce8SYLzFte1pX0lxNWHbDsBOpVx9DIV
 2OnHCGmRUponxxpEExQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-23_03,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 malwarescore=0 lowpriorityscore=0 phishscore=0
 spamscore=0 bulkscore=0 suspectscore=0 adultscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2601230148

On Fri, Jan 23, 2026 at 12:42:12PM +0530, Abhinaba Rakshit wrote:
> Register optional operation-points-v2 table for ICE device
> and aquire its minimum and maximum frequency during ICE
> device probe.
> 
> Introduce clock scaling API qcom_ice_scale_clk which scale ICE
> core clock if valid (non-zero) frequencies are obtained from
> OPP-table. Disable clock scaling if OPP-table is not registered.
> 
> When an ICE-device specific OPP table is available, use the PM OPP
> framework to manage frequency scaling and maintain proper power-domain
> constraints.
> 
> Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> ---
>  drivers/soc/qcom/ice.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/soc/qcom/ice.h |  1 +
>  2 files changed, 64 insertions(+)
> 
> diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
> index b203bc685cadd21d6f96eb1799963a13db4b2b72..ca6a7df7a6827378af1f013c7e62a835d1b80cc5 100644
> --- a/drivers/soc/qcom/ice.c
> +++ b/drivers/soc/qcom/ice.c
> @@ -16,6 +16,7 @@
>  #include <linux/of.h>
>  #include <linux/of_platform.h>
>  #include <linux/platform_device.h>
> +#include <linux/pm_opp.h>
>  
>  #include <linux/firmware/qcom/qcom_scm.h>
>  
> @@ -111,6 +112,9 @@ struct qcom_ice {
>  	bool use_hwkm;
>  	bool hwkm_init_complete;
>  	u8 hwkm_version;
> +	unsigned long max_freq;
> +	unsigned long min_freq;
> +	bool has_opp;
>  };
>  
>  static bool qcom_ice_check_supported(struct qcom_ice *ice)
> @@ -549,10 +553,29 @@ int qcom_ice_import_key(struct qcom_ice *ice,
>  }
>  EXPORT_SYMBOL_GPL(qcom_ice_import_key);
>  
> +int qcom_ice_scale_clk(struct qcom_ice *ice, bool scale_up)
> +{
> +	int ret = 0;
> +
> +	if (!ice->has_opp)
> +		return ret;
> +
> +	if (scale_up && ice->max_freq)
> +		ret = dev_pm_opp_set_rate(ice->dev, ice->max_freq);
> +	else if (!scale_up && ice->min_freq)
> +		ret = dev_pm_opp_set_rate(ice->dev, ice->min_freq);

Do we expect that there allways will be only two entries in the OPP?
If so, it should be a part of the bindings. If not, please design the
API with more flexibility in mind.

> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(qcom_ice_scale_clk);
> +

-- 
With best wishes
Dmitry
