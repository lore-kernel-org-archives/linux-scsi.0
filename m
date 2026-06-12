Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22AD35E1A0
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 10:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781261193; cv=none; b=lCkGtnPknxYjjSD59X999AIrEZYgtcKEOizjqLu5xjDnB1J92CJLGtd32oWpKqz+BmfrOBRizz7B/OpYVGDOYgoiWgfUcwBZpNB+S55BxEaqq3cAaYjL2CVW3iAiIE+mRBIxuao0rlPAtTslKwN+FKJgcBe7aK2IUxEjdHPUQDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781261193; c=relaxed/simple;
	bh=cch43TDK/gRPbuvcGJW2N/+2DrtINzTgxFLNisjO8dk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jLy2RibCWaiIHiq6gFINKbT23Y7ycDSgEMqUt3g/F8wDUqOglKm0nxHOhnp/pjuMHS7XFAzZkPr9X3gkCKotCPPkXlej07DRPRztudCFgGj9Ehis3OFV9C0YxgO0UosSNLqF8mWq4TolTSOck5DbBsF3ep+EpE35jprwQTonjpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UUb04Fx/; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UUb04Fx/"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-45e9f4a3510so483329f8f.1
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 03:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781261189; x=1781865989; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dJuwPgn39WvXfBqGWNFtCAtWKz0BUlj2yS+2d732RtY=;
        b=UUb04Fx/vVW8uCYK3+6rDVYyJzxIul2aOBg5j8Q5hBSQHKoRwKi8NzxMBjYjYhu0lN
         IlppkaiBsPbqXd6wwmzMVZXK6mn6bjod4K4uW2J7BqGunuami3l+NjQRdBxQxt7o4Rm3
         J4ma+pOp0LHR26RcGISnO6fCBBw9lt1nycOEaiH7/6knLg1HQG4+kp6s+pxOKRLqkD/a
         hnUwjMGjtQeF7VJMmVAa6HtBoKjayUhuTo4cgC2D6m2uhu+fgb+wzojwgNUPx8hRm5gF
         IFWbElVsladq9TDPVkj+HdHlHOKIfEnPrmjGOx+DTNfwuDX+2+pSbl28PapJtYezUlaj
         nVnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781261189; x=1781865989;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dJuwPgn39WvXfBqGWNFtCAtWKz0BUlj2yS+2d732RtY=;
        b=UkzEUdyiVS8gInliQUmmGm5hz5wh5OB/gLuItIqXbzGLvSbyanURQLZdbm8iQLcmcT
         jjo7QVkNNfjkqnq5hLRJltmpIphNgYCEfasieiFb8sxyyGooyFcEJjefAjcWVQWJOA7U
         W/n4vlCCQeXFviGR7K1E5dSR+SFQkiXAKosTnq8eP+FMA+1d8+Qy3ZM7a4vm4SDa3Gik
         3PLsxoOCb39gPRwEp/Gjb8UWDOuehYfqH1w4plmI6MHK3bj/ktX6Mbi7TWqtLCoPKQq7
         sD8PQ7lBEVU7VERKyGbYcULxzkQycg8yGhowytDnMeCBhrpE3b9QUSW+CV1FWc2bBpId
         2oPQ==
X-Gm-Message-State: AOJu0YziH62RbGneUUt4AFJD4+iHs3zgJfPqa3z0oWXS+OoUpT+Uwaxb
	XlPfLGUFiSTAGwHTtFlGFgNLipVN83fQq/UAgHZZMPSXo/gkUfhsovmaUE1tW+Zm1soTqDqF9vd
	j1Za6
X-Gm-Gg: Acq92OHBh0dpokKuL93+P244BZDbd7lqF9Q8nqj0hRRtRTmi4gcFYPL2WQofI3I64Dw
	8qwNvBJwFl+FW4AtWwM+oRsqdg3+f/tpw+3vkG0PdX/mXZY7LXvhuefDuxHfZWf2Dy1LUnnwx1X
	SZdgn5g1IHbQBYpcFQPH/Bmm7TqDX+g8Q7YQLOGwkGAqDCpvnQ8Y06MpQRnHoJSlMdXncOKJVXb
	C+oq8ysc9D52jiEkH981WkXSWepecVh5aY+T3tjxbbP0FyQfavbWB6keAV2ss6EBSODvNLNRiwr
	FLwwrsB77UNNwOM22H/WWYKFcnHJ8JJPnt6lG63lL5JVelgrWyj7KlBQiPUvioZzu/+9VC23Nhf
	DZE8SO/oGE4VaTTufpK6zuLPNlct+tv5fSxf4wFvWG5zr8XGzBOUOnHIjm2FZmdh8W+9cOaesfr
	Fcn+vqWbV6RHtGPiJYY4c9kQ9EbFFBy5gplApQTwJ59eb9VlUX0Amvpm66
X-Received: by 2002:a05:6000:430b:b0:45e:f073:d2fd with SMTP id ffacd0b85a97d-4606da5a66amr3263433f8f.9.1781261188943;
        Fri, 12 Jun 2026 03:46:28 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f263923sm4741627f8f.2.2026.06.12.03.46.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 03:46:28 -0700 (PDT)
Message-ID: <cf57818e-56d9-46a3-bfba-afe2ec37fd1c@suse.com>
Date: Fri, 12 Jun 2026 12:46:27 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/60] scsi: qla2xxx: Add NVRAM config support for 29xx
 adapters
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-FC-Storage-Upstream@marvell.com,
 agurumurthy@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
References: <20260612095333.1666592-1-njavali@marvell.com>
 <20260612095333.1666592-4-njavali@marvell.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260612095333.1666592-4-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/26 11:52, Nilesh Javali wrote:
> From: Manish Rangankar <mrangankar@marvell.com>
> 
> Extend the NVRAM read and configuration-apply paths to handle the
> 29xx series.  The 29xx NVRAM layout is similar to the 81xx family,
> so reuse the existing nvram_81xx parsing while adding
> 29xx-specific fields and init-sequence integration.
> 
> Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_def.h  |   1 +
>   drivers/scsi/qla2xxx/qla_fw.h   |  42 ++++++++++-
>   drivers/scsi/qla2xxx/qla_init.c | 123 +++++++++++++++++++++++++-------
>   drivers/scsi/qla2xxx/qla_os.c   |   2 +
>   4 files changed, 141 insertions(+), 27 deletions(-)
> 
[ .. ]
> @@ -9386,7 +9449,10 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
>   		nv->login_timeout = cpu_to_le16(0);
>   		nv->firmware_options_1 =
>   		    cpu_to_le32(BIT_14|BIT_13|BIT_2|BIT_1);
> -		nv->firmware_options_2 = cpu_to_le32(2 << 4);
> +		if (IS_QLA29XX(ha))
> +			nv->firmware_options_2 = cpu_to_le32(1 << 4);
> +		else
> +			nv->firmware_options_2 = cpu_to_le32(2 << 4);

Please use 'BIT()' notation to be consistent with the previous lines.

Otherwise looks okay.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
