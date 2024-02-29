Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0924F16062E
	for <linux-scsi@vger.kernel.org>; Thu, 29 Feb 2024 17:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709228066; cv=none; b=Zmsu6PRfczto9Dxn7usSwM0MMlBUwQo0SxHGn/8l/1exCRgixrIFtpewLp4cIkYgYjB4ojG0/tTWdqqm8TwsK+X5zia6W+a06Wr3qeAX1Aq+Hyd8E8N7y2BZU0z2Sy91sYOKi/F9CL+rTs7/qA0MNji4sI1M9MAh7oGqm4RWB4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709228066; c=relaxed/simple;
	bh=m6z0ceGyKJbqZPMc3YbqCQObSjuHGsjFNEt18dSF3hs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZwxLxzguwGtxZ0nvRbjeQdG4Y2gyI7ntITdM5fXT9SjImzSap+SCo/VWxaAXXklUiladB4WnrYKnrXth2IzbELgH2pFkGpdKY+88m9l0Nb4C+9tli/EcmATMS1uXkz+5uiVlKsXo9XtQ+93DRQb6Y5xfRfDutnq5nnYtdm+j/ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1dc29f1956cso10618085ad.0
        for <linux-scsi@vger.kernel.org>; Thu, 29 Feb 2024 09:34:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709228064; x=1709832864;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UL4qhpa34dKKFK7vGsY+DXYatKx1Zwm0pH68CEYVls4=;
        b=s+4W3JN6dgs+9BHPou1x4QoDr0S7Gqhm0mDed9EtY8wtuVaF8qs9rmQEo4FWy/dj3e
         gwQqeWQl5+8S0+ZCrQY/FejuxrDEjwT7/YpwkTI9mg/8NBV4yiJv8s3b8twehY2uK68X
         n7dy8FQxBf+s4bYtylM0tNjMgvMQDQT+J32Sj8SlSEvx8+CTOg8ACVOAYMmjCiJnKnIC
         f4Lo5R1PHpQ3ghlEGLp5jWdjVwmA3+qDHnqDFRI9kq2uGduYoJs39JPPTBrWltJdbkaS
         WGs3Yuv9YMhSPx0wgM2JUlbfXCyHHOi8qgc3rx7pa9iIQ/rKzxo9rOv4BB7V8XA2l22Z
         Ih5g==
X-Forwarded-Encrypted: i=1; AJvYcCVPJs9IErBqKIyA/Wq/voURHMIxEd4zIEDcJsxRFZo5ApJ9gNiJYhrXv8ZwYI2EwkXABy8vLZIiJUiuJR1NliA1WKuML055Y3KRbA==
X-Gm-Message-State: AOJu0Yyb16JrsOfEbMomlVSWnA9ENDtuzqc9d/HUsxK+lli5LFwE27fG
	OBR6zbno6HuQ5POddQi930K++jHsoaGls3jsLWD2Ndq5SNCThZ1k
X-Google-Smtp-Source: AGHT+IFUpG8cCKn+DDgjM2fikgIdNmwvI4jMpFpIkLCCQ77nMbqQOKfRg4eReqr5IcYXgSrGr2dbMg==
X-Received: by 2002:a17:902:c40c:b0:1dc:177b:1d85 with SMTP id k12-20020a170902c40c00b001dc177b1d85mr3592151plk.27.1709228064254;
        Thu, 29 Feb 2024 09:34:24 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:3174:8fc0:11f9:afc8? ([2620:0:1000:8411:3174:8fc0:11f9:afc8])
        by smtp.gmail.com with ESMTPSA id t5-20020a170902dcc500b001d949393c50sm1762291pll.187.2024.02.29.09.34.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Feb 2024 09:34:23 -0800 (PST)
Message-ID: <140b6a69-eb38-4ce1-b8bd-0dd404800f65@acm.org>
Date: Thu, 29 Feb 2024 09:34:21 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ufs: core: add config_scsi_dev vops comment
Content-Language: en-US
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com,
 jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com, powen.kao@mediatek.com,
 qilin.tan@mediatek.com, lin.gui@mediatek.com, tun-yu.yu@mediatek.com,
 eddie.huang@mediatek.com, naomi.chu@mediatek.com, chu.stanley@gmail.com
References: <20240229080435.6563-1-peter.wang@mediatek.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240229080435.6563-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/29/24 00:04, peter.wang@mediatek.com wrote:
> From: Peter Wang <peter.wang@mediatek.com>
> 
> Add config_scis_dev vops comment.
              ^^^^
              scsi

> ---
>   include/ufs/ufshcd.h | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> index 7f0b2c5599cd..a19d87e7980f 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -327,6 +327,7 @@ struct ufs_pwr_mode_info {
>    * @op_runtime_config: called to config Operation and runtime regs Pointers
>    * @get_outstanding_cqs: called to get outstanding completion queues
>    * @config_esi: called to config Event Specific Interrupt
> + * @config_scsi_dev: called to configure scsi device parameters
>    */
>   struct ufs_hba_variant_ops {
>   	const char *name;

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
