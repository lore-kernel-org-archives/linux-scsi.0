Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F3BB352017
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 12:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781268554; cv=none; b=G1jksLuXJJzVCCrBKgPZJwME6T91pjumaEJrRKhYOSIWoIzrdpXIsKspmRe117FmB+1IyBanC/51gRMVhxlTmjD7jIFCRmB4LyBZBC2Mk9CUBu0rO80DcPfuhKsQAFAYt8iNW2MVxibio4SRVxYY0HFwqq0zBijjDCnmMiruRMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781268554; c=relaxed/simple;
	bh=5GDPhN/8/jUvnryEPuQNpqwbElXRKCiS/7kY1X/Mpfo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VSaJsQUMpZ5mgXKGz+CzHEfHkRlIOefckQOwJD1osMJ5f9VzWuNE9ob30oOiXjeKPwhMpc4u5zq65NlBh9yXqFVYQup7mbAW/eLFb97hBMDIcnOCHeQRNRfwv1lWR6JLUbe9/Y0Ypwm3YvXlwUVqA7ASxMP65DKIIeX21ajHmQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fwvW/0Lg; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fwvW/0Lg"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-490acbb0f89so6247115e9.0
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 05:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781268552; x=1781873352; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TOssDXdtDW68k3PgEHlw1sT2KObgRcuuo4ygiNGqLwA=;
        b=fwvW/0Lg7xuP2QUqyzI1MV+dEl64+yaTC6wRssmHKjWjoRHV2n3ymMuXOJ2Xpq/CFQ
         tdDVJRe7TsIkulQMbzpbFN83w0Y/qSQOZMZSFLV+H4uLg7nQexz+/iHNCqB0UumuokZp
         RghHPU0rzmgnm8XP6NUhR5y9IjV+5Mx0ZonvGe/hNXzyhyr01v5XzKqQ8qFsPjBRgRqh
         kvCxMGJWatLF33T5ttzcyjcQKM1uVG1OF9AsfQ/B4tFaDasE0nun4+/HiQ0/dUoJ5kCu
         bEaYjbAaFE97Y2HHYLZCcDHF0/8z78wCwKD4z4Pc8YezSzZy8Uma5hyCoPHWpATtkSTd
         Mf2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781268552; x=1781873352;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TOssDXdtDW68k3PgEHlw1sT2KObgRcuuo4ygiNGqLwA=;
        b=bj2qG/ykrc5DqRnJR1uLhNPaY5AZPsX8xjF/MJrT0m14HvCFV8tWNxBE/wf+QkznuJ
         IfTWFS+9xwuftLVTX21kDXb/AQokqGqcLss6ewAGs1DO+2rqipYYK7tA4KWNRkSLgkeg
         K6cX6gB3uoh29mY6bA7SkF/PqJmtEPC2kI2ATFaXcM2g8wjwTSY+tQ4NZE1mzgBgvJ2l
         LnZ2/Ow+cxFXMazKL82qWQI2nu4NShH1LBWQQ6B9hQko9Hr0ynYs+Kn3nAZhIu+zPAXL
         ot//Uael5Q3SA1e+I9G0fym7ZHbeKcpOS2orlSd+mcoWqXMPLO8DR4TBR8f/SL74vmuC
         v9kw==
X-Gm-Message-State: AOJu0YxL92xP3Agr4mY4MpJu0a2ux90wdlmfmL9cSugwtUmwFnFx+8cG
	+t0pD6xDkff/b05KM26zyAlEGK7Fgh45gJv+fpEJ/PLLwiWTemmhlicjUoV7MD5RMI0=
X-Gm-Gg: Acq92OHjDRjHbJ46qh5cEn76sO2V6aXWtGaBBVhrnr1M4sE0vgeLQyLnHgylujryUrr
	TS9pg1PezB7BLDmGkoWuUcWOdLYFV3dw1aCUZCGrKZZtStUqHVatQJ4sHgcSiJTA9PST0Zgnux4
	IGrb9pmXzxuesDWo2NhmWaSv9qE2TKm1h3bPEv1fhrRHpGKrIYj/TwtdYZCsjFX7u8iePKRT/7K
	h1AghbY7UORB3JVN0HUpMRPjnirtLMNVCM03QFDcdsmef68UVJ8oiMDnKQV7QehCy8Iq7DIJh2f
	NMwbLtP+i/Do87SSVXii57dy4+mwD3c+XvekHV2JNQrC9Rx9wjT0lwLgLWIBKofPCoN3Lm8kufo
	lWL3+kmCs/BUCM++XcjHsIrW7lfD7VgDhekgajDklFRvNkHTDsSk6Z12CHY/4R+pB0QIT68po7/
	ZzZGCpyq1n72VxYrEn9hRDu1YPv5T+xP+jZuHmoPP2l1YBFV4DPaNNv2D+kONoaVF2adA=
X-Received: by 2002:a05:600c:8b2e:b0:490:a964:14f8 with SMTP id 5b1f17b1804b1-490ec48f9ecmr34675795e9.8.1781268551676;
        Fri, 12 Jun 2026 05:49:11 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490e2c7ea21sm153007105e9.1.2026.06.12.05.49.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 05:49:11 -0700 (PDT)
Message-ID: <88f6ac2f-0e9b-4d3f-8652-c43b6c00d102@suse.com>
Date: Fri, 12 Jun 2026 14:49:10 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 41/60] scsi: qla2xxx: Unify NVMe IOCB build path for
 29xx and legacy adapters
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-FC-Storage-Upstream@marvell.com,
 agurumurthy@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
References: <20260612095333.1666592-1-njavali@marvell.com>
 <20260612095333.1666592-42-njavali@marvell.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260612095333.1666592-42-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/26 11:53, Nilesh Javali wrote:
> The cmd_nvme and cmd_nvme_ext structs share an identical header layout
> through byte_count, so the IOCB build code in qla2x00_start_nvme_mq()
> need not duplicate all common-field writes in separate IS_QLA29XX(ha)
> and legacy blocks.
> 
> Initialize the cmd_pkt and cmd_pkt_ext pointers to NULL, then write
> common header fields through a single cmd_pkt (struct cmd_nvme *) view,
> branching on IS_QLA29XX(ha) only where the layouts genuinely diverge:
> 
>    - port_id[] vs __le16 vp_index
>    - single inline DSD vs NUM_NVME_DSDS DSD array
> 
> Add BUILD_BUG_ON checks that enforce the layout contract at compile
> time so any future struct change that breaks the common-header overlap
> fails the build rather than silently corrupting IOCBs.
> 
> Also add a BUILD_BUG_ON size check for struct cmd_nvme_ext during
> module initialization and a reserved_end field to
> vp_rpt_id_entry_24xx_ext to ensure proper memory allocation and data
> integrity for 29xx series adapters.
> 
> No functional change.
> 
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_nvme.c | 58 ++++++++++++++++++++++++---------
>   drivers/scsi/qla2xxx/qla_os.c   |  1 +
>   2 files changed, 43 insertions(+), 16 deletions(-)
> 
Please merge it with the patch introducing the change.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
