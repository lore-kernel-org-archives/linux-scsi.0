Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DAE0286419
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 11:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781263085; cv=none; b=TE6/pGQq4qxYMQlpkGfZ1Mx8BkHywSwaCcU18E3ONFQ4Ef12wxNntA3NxQbdw1SBayUgM2zuGI5akoA71JpW7TauKXZbkyZ50DP72cSqTe0uUerFdWQKqaoQD6se7VLuQS/+eTQz5sW2Q0/YfA/KJjwSxpSYMvw/WF0rtZgnVaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781263085; c=relaxed/simple;
	bh=DIZ1X4rjGP46BdumMwuJidvV7OKPpcC9wAG62c8gp+w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J41tmU/Cljb/kmloiIod3nhQvqBwdwJL8a6UBAmv2udG8gdbyzUDRQ/cbdt9MAL8Xlza+H5wz8zTLpw6QaEH8yccT6V35vXVWclDyk03CbP8ZU03O+eTAoVnFq8G9gKWg8HT9478rFxXlyaOLa9nMul31CtVAQKj8SXLIxKXt/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=cHbfRLsK; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="cHbfRLsK"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-490ac357c55so7682915e9.1
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 04:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781263083; x=1781867883; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yNVbYk0CQ9OCDeyJrw/CRuD1Z25W5TRcZVi153kOIQ4=;
        b=cHbfRLsKGCu4UgL+0nYEH8Tlw2N/T4hv9+ueiII2O2mZhbUXgOc9rHQ167aT67iYD5
         yeQ91LKRXXIr4MXetapAnZzQ5lt2uCNmUNt0xsqUBBSgObIG0LNn6tth8WSTylEY5jZW
         07I+ATFMen7PeIhxemOspO+l8tVCLLA/ISBKAmPKpN8NxDRp9mCvDNprrusRmtNB6/C5
         7Qq6GVGsxhUQGapDy3iekgcN4FvO9X6GuutrZEr+yGEAS63JLyVt2197bGJEFkQjA9Ye
         9zRw9yBAATkptdcjQlS1I3PWpDuNmqxNb5GacIubVxORNITfwAAQzIBAZ/onVGEUInXB
         sSLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781263083; x=1781867883;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yNVbYk0CQ9OCDeyJrw/CRuD1Z25W5TRcZVi153kOIQ4=;
        b=BMgQcDg9z+mDHPVSmKCxGT/eKab3ziQ5uJUqsxf9EXXu7rMFdiF9jqBYwTkGgJctVS
         uTLgVbrKC5mXmw4NGBNzTbwSNArBcYhUIfDhAUxFvfnDPLKPlp/I68pmBR4gxk/Ov4fH
         R2GWCRl6mmPTvmQbb5oLoOGLcDgU3A15bygXbMeN2vmGSfuo/Tx+YFMfgKZcqZAC7lnd
         EQu2L9s5TKBgfn8iySZSACqrHtJkBSjOxf+dbW5zweHlY4FWuaidHcbVLGODLNvLrEFu
         4dBmZz15j+zidYeIMfcGKpTUOMf8DB+PAf+lL3UZrf/hQB2OSPu7qIsOY0l2/NPQKQDZ
         pmrQ==
X-Gm-Message-State: AOJu0Yy8C2rvxEc720ClXphcIDaXr6nkynJYrl2qzH0oT0kCazrnyzD9
	H0LckTE50/cQdMWPbBzBiQDfpeHwn0frzlq03+sQlXo4Gq4VhYaHhliHwxJNsUjy8Q4=
X-Gm-Gg: Acq92OGnosaoTEiLITrAZL//LYjb0+nvIhYS8gu4zfHA4JfMxmd4JQu49dtm/prB/B0
	30sDanblMwY54A/xk/PKhdYYfSA80ndA0o2VMSgG6inW1DZVawOtitPm6KJuAGZ0Wn5mFjhxuV7
	J7gRVkS/v4uS+RbiBepZKKLJuRYkBJrsYLpWWi+Xjgex/l7XLyxL9MP12MXisZWNRh5oFCqZZtI
	v5n4RXpHo+40IKcAbSLWHrxQeop1UnfR0vd4UFWauwXwYiUMrDR8xdzyYDaYH8J/mjVKUKQ7Nv4
	Dqw754w0da1yYaMIoG61N5YIVsoQM42YxhMtz2IdhDE20Fu+BD45XAX1xgKsSfHLqL3coTGzoxn
	ImxEPIGAoWQoepP0dMZZE2VWxB23kr4goWQwEd1mY0rO4kVtX3cdLgOU/VDI3tMbuh+jHq/UtY9
	h5VN9nn0vZ4vadL5weRGyYA2hHmjFWp2RiZ7Dz7ptsyY16gMujF1H5aGctTubbw8qYIds=
X-Received: by 2002:a05:600c:a215:b0:490:e89a:b221 with SMTP id 5b1f17b1804b1-490ec5071dfmr18416305e9.35.1781263082862;
        Fri, 12 Jun 2026 04:18:02 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490ea843d63sm59167805e9.12.2026.06.12.04.18.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 04:18:02 -0700 (PDT)
Message-ID: <9573616f-15e9-48e9-b17c-f86d4d2b7230@suse.com>
Date: Fri, 12 Jun 2026 13:18:02 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 18/60] scsi: qla2xxx: Enable get_adapter_id mailbox for
 29xx
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-FC-Storage-Upstream@marvell.com,
 agurumurthy@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
References: <20260612095333.1666592-1-njavali@marvell.com>
 <20260612095333.1666592-19-njavali@marvell.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260612095333.1666592-19-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/26 11:52, Nilesh Javali wrote:
> Add IS_QLA29XX() alongside the existing 27xx/28xx checks in
> qla2x00_get_adapter_id() so that the additional mailbox
> registers (buffer-to-buffer credit, SCM/EDC status) are read
> on 29xx adapters.
> 
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_mbx.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
> index 52d70b61654c..3fc08120fdf1 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -1772,7 +1772,7 @@ qla2x00_get_adapter_id(scsi_qla_host_t *vha, uint16_t *id, uint8_t *al_pa,
>   		mcp->in_mb |= MBX_13|MBX_12|MBX_11|MBX_10;
>   	if (IS_FWI2_CAPABLE(vha->hw))
>   		mcp->in_mb |= MBX_19|MBX_18|MBX_17|MBX_16;
> -	if (IS_QLA27XX(vha->hw) || IS_QLA28XX(vha->hw))
> +	if (IS_QLA27XX(vha->hw) || IS_QLA28XX(vha->hw) || IS_QLA29XX(vha->hw))
>   		mcp->in_mb |= MBX_15|MBX_21|MBX_22|MBX_23;
>   
>   	mcp->tov = MBX_TOV_SECONDS;
> @@ -1827,7 +1827,7 @@ qla2x00_get_adapter_id(scsi_qla_host_t *vha, uint16_t *id, uint8_t *al_pa,
>   			}
>   		}
>   
> -		if (IS_QLA27XX(vha->hw) || IS_QLA28XX(vha->hw)) {
> +		if (IS_QLA27XX(vha->hw) || IS_QLA28XX(vha->hw) || IS_QLA29XX(vha->hw)) {
>   			vha->bbcr = mcp->mb[15];
>   			if (mcp->mb[7] & SCM_EDC_ACC_RECEIVED) {
>   				ql_log(ql_log_info, vha, 0x11a4,

Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
