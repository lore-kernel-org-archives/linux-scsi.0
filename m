Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE443C1F52
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 11:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781263279; cv=none; b=bqpk1B+/o6Yvvg/Wj1d1kStCInwr7o99alGUtrIeBx2fR79KUuoNYYOqi6yhWr6ddevRsfANf7M17Uw3IR8PPknYrQnY44BmsKExqodRhq703iBRwHHrPRDRvakZoW+b5SeJ/G0WkmVousYZPDRH2JzkBDTEfaj1wqSaUGUkwas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781263279; c=relaxed/simple;
	bh=QBhwo0ArxmSkgdHGLr17lwJgYkcbKv1IkD0BsObd0r8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W3xEIDTPxT2qHwaVNXajyTQAyWwimDCOGceSUv59edezyoHsPOszl8BuO0WayskfANRP6iFwzAL1xuUzFgP/LiVXcO0RBiTnQ8sPvPxLMWCZNKCGhUhmtSjDMA429O73jn6HwW3euMAJHwlU3R/pxXiHen4GssRZ2gGFnwiveQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gZuIk+GQ; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gZuIk+GQ"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-490b915ded5so8260085e9.3
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 04:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781263273; x=1781868073; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HeDq9BVW6or5uobz0Q6zX1w+/2G+0WopH50PwPxKM4o=;
        b=gZuIk+GQheEb5qNmzoq2aQKCeJh4NxAJGylMO6Tm3aIZL0zfMcww3VudFcO4fvrurS
         t6MU8BZ/j3cOfdN6B2kmKZaf/w1EowdF/5nvR8NCTRtb671Wq1Ykn+QzmH5uGeoX54af
         zUJ/JG4ep/ByrzdnAxCoFqcoks2VDmZKE1m+0YmkgYEC3REoT5MqLrQy48MUady/GUhf
         2+dwGPmjr3AaQo/MN+7VCpeinmCFKhVkHO9K3Si/89e+5nh+hi/9BJ59ToaFKSth97aT
         YH+7+9fP7ZJbRUe0v+ZHeHplZRd4E9iq/c0LOqXowYzDZdDz3KkOxz5FZn/Ne6mvSmgl
         GmaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781263273; x=1781868073;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HeDq9BVW6or5uobz0Q6zX1w+/2G+0WopH50PwPxKM4o=;
        b=OXlbfQrk7ECDTW/QKhxHFHjEKW++IJgEwFzUur9Ihk1zVPDVtrgEFzSGPA9G56Vref
         EkDgjA3q+thcwGTYBWbtUD0823d0D2G5tKABnVgzCwqpWNrA/ideM8S1yBV9EEruZ3tr
         9MfKrvNJ1b6pc9+PSYFNAuiA9ryvgRG7I1PgjtICAmH57szD1VqiL32dDAy6BOAx0D6t
         ieyWOHqSWuFKQ4msp8+THFM0FFV+026NY6Ep6zhqxh6yPWTNT6M+p3H6jWWcP2xQSwJy
         5zgyC/uyJO+8gGnV9oKkSCxvsQ/EQGM7EicfeBF+WbgtNUjnzO/xlxDFM4ZAzEnWxZo/
         43fA==
X-Gm-Message-State: AOJu0YwtOf7xyTNBl5RPtzddn3eP+2BFEi7by4YWLiavYCl1Pd7ej8XK
	AOz3HTe5AzvkDroQnZzemFpQ2C7GU08mFx0Z1pfmQlmdhpVff2UbFaTu2SJoyy0VUSU=
X-Gm-Gg: Acq92OFIlF4qhPDiNUxQ9wyIQjJYE5G7frRI9bb65zrzNvwVyg8FOfRlS4HmXMbQg5o
	vE3/X7hVMgRL6h4+nNNmAxQwUmx1AMVgD3Cwd/pXrW5XvpCa08Etkfjw465fdGQwZAacK90D0XA
	CKFLYhEk/P4FXrneJsGsHVC1dpiUzTuotkWWFPqgKBn9fDdPNC4IoeBpZcXKXDTrPZMOQZkL/uX
	8LPzb/K8H49eF3iXd/ruSGHdsS4cldQALLHqQM9YPzPg0esAk78tCQNd2Pzb5bcnIk0H3qvt2yP
	geYSV2KDsi/IEoTPDbfX7k+8hY1rADNuSEU/8hMwDAhEThf0M350otB+JldgLK7wl6ep/iMrGBR
	ONxYfRJ13Ef3iQZN52g3ZPQpvJ6lxtgrDhvMeRZxN62BU7hzixyz4Ss2jPYRFuvSb0JULi8ZQsh
	/l1FKU6XfgbIa4mFjzGcp1TWT79hOAHRs2yMfaiuy7BYPHFc9IZyPjtjWd
X-Received: by 2002:a05:600c:8b86:b0:491:91cc:d12d with SMTP id 5b1f17b1804b1-49191ccd322mr16679725e9.25.1781263273406;
        Fri, 12 Jun 2026 04:21:13 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490ea83d8f9sm65452515e9.9.2026.06.12.04.21.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 04:21:13 -0700 (PDT)
Message-ID: <fcaed5bb-5a9c-46f9-b8b9-2870588fa788@suse.com>
Date: Fri, 12 Jun 2026 13:21:12 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 24/60] scsi: qla2xxx: Enable qla2x00_shutdown for 29xx
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-FC-Storage-Upstream@marvell.com,
 agurumurthy@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
References: <20260612095333.1666592-1-njavali@marvell.com>
 <20260612095333.1666592-25-njavali@marvell.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260612095333.1666592-25-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/26 11:52, Nilesh Javali wrote:
> Enable qla2x00_shutdown for 29xx adapter by adding IS_QLA29XX check
> to the shutdown path that performs firmware abort cleanup.
> 
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_os.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index ef105ae6af41..a3e2c0a95a99 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -3840,7 +3840,7 @@ qla2x00_shutdown(struct pci_dev *pdev)
>   		qla2x00_disable_eft_trace(vha);
>   
>   	if (IS_QLA25XX(ha) ||  IS_QLA2031(ha) || IS_QLA27XX(ha) ||
> -	    IS_QLA28XX(ha)) {
> +	    IS_QLA28XX(ha) || IS_QLA29XX(ha)) {
>   		if (ha->flags.fw_started)
>   			qla2x00_abort_isp_cleanup(vha);
>   	} else {
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
