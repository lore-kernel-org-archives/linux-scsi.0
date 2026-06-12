Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA6D37C92B
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 12:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781267625; cv=none; b=EWoHWHfjQj+UvaU2OkVOmKkx6PuxWLQHu7fdP9L5QIFdhU0fp8zp81e4fPMvplPkZONuLFS8NQYy16MNCq45vKiN60ag46sqQDBTJcHWVdoe1uDQkZKv25pLQlN0ofpL5Dj7CT5wDXZ/fOJks0fq5NnEZlVaIH1Hzfh7bF9jJSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781267625; c=relaxed/simple;
	bh=O+Pdzsp7lwG1027eygfqe/S+VmqNdNsX5ER3w35p3yU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VTFb20f6BkhZxwPs2l92Murk77xDVdfAUC8o07StMlF+RQd88U9kBJBUbB/vUVd1YlvghpOTAXxBu5A9QYlU1+4ucBDgT0TuNROROFJ/zOUtga81ags0oRVdvGgLPAiAny8JlTlziAhctSVZMU04DWBGx1ve8s00LGNPt1Wj2tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dE9QxkET; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dE9QxkET"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-490b12270b3so5595115e9.1
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 05:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781267622; x=1781872422; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=s3gW5fIYo5sg2wSRtJdzcaibH2sUml9g21oJd7eumFc=;
        b=dE9QxkETzGdsH8Fswr2UYZhP2Eq8J/IUuh0Uz7+6JHPyHpuYy8de2SI8lj8ffmSnJx
         YIbjwvra5dp1qPDJMjucnQHOkpbejmgdbhN+Yk5vUMqGMUun6hmLJ3XVBQmOUEcuml84
         b+VSLfLDq+TumhBXZ/E7leqqm/mJjL036Joh2NtL11ERj8vVHo440CG3ri41vthrYmUG
         aj7OuM7HEj4Qi/jyVJlrunNAnBRJf55uR9FobAW7Tl9vzwPkvVz9NWNhT1Zv4mg/wGrP
         nmCDpcdoMi8IWvP36ll8/VGdPcdkI1mAizD0BSCDfQYpx7asZLLhzomMUl2K+8tnCRfS
         ccAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781267622; x=1781872422;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s3gW5fIYo5sg2wSRtJdzcaibH2sUml9g21oJd7eumFc=;
        b=IEt99rH37ycfe7wdG13HJQOV9NxtbzMAZsmQS5sATLyAkbMBh681nXdzBJZPFzvrOS
         A7GBhPOsxnTwk3uOk9sLQM58zM90otZQUTAZGFKIQXmhi047Ttw0MHDW48fUfrmBIktI
         hZOYmDjE6RGAYXeuYhiyOsTOI9Ovozdjeu1GnClqfZgGSduKSgqszhxF7bGsJ/WLQ3H3
         kGk6RJV6aPuUyeJ7OnJRnO8NcE0Xw4hJUaCCRk6/qU+Pme46MN21ltXPXLKPJ4cITfN8
         Bfc94xMg9CC9WwJX3Nd8w/7xFN3nUY50Yn5q3IG0/9baUY9z0oXPf/or/FTsL4DoNcqh
         FevA==
X-Gm-Message-State: AOJu0Ywj0JQTVKDn7MlZqXKqlysGk8uP3me7sHXNPadILR1Ben6hZBpl
	Vp/3yJSyueyQpBPa0v+glHfHDK7KlEUJ8HapVlofxk4yS439usbFOMJWpJejB9venD8=
X-Gm-Gg: Acq92OFDmNNSMtSaxXyR5sX+/4A4bnYAmvgQ3pHcz5eDkfDo6RW5Ti7Gmg1i9LOEwsr
	OYm+TsC2WTSGSLZ6RA+4wWLMM7FGUNB6kdYpng/gM8gF2I6g8qCXMku8erarP25F7/fXDyF+thg
	fiYJhar2s6D1WbN42qcIJeAjkpEfc87VeILLGpbcG+vXclR24GSjD/fBjB0gNqeAUuP8w5rUb5M
	0l3TWX/ATJ6t4Rugnx9DL26wpIX0MzBVkXCtgGJBMpHaLj32Xz+kDNSbsfEDi8r9ZHIU9HOzNWE
	d5FVbeSYwDNwC1VRAIklq2xR09JIDzEjCzapmABcVBDa5AQtVPrbZJQ5tKNR3CX4cFMI3um00/E
	ZucALPonAYkDtVjzsWTuURtKPxRcLuzJePeKT62B2jK8hqFyzL27wD33voTZM+DCfO0+jKrlrXA
	ZFYBuIVlKczWHR8cDyqoa1RRcvHLooPQivHrDDVfJO2tq5Oxx7kphgOz3Y
X-Received: by 2002:a05:600c:3556:b0:490:b92f:ef5b with SMTP id 5b1f17b1804b1-490ec4d4f30mr34105155e9.13.1781267622486;
        Fri, 12 Jun 2026 05:33:42 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f26f1cdsm5714032f8f.11.2026.06.12.05.33.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 05:33:42 -0700 (PDT)
Message-ID: <ff0f0806-15c1-49e6-a29a-1dccc4c64141@suse.com>
Date: Fri, 12 Jun 2026 14:33:41 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 32/60] scsi: qla2xxx: Update handling of ELS IOCBs for
 29xx series
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-FC-Storage-Upstream@marvell.com,
 agurumurthy@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
References: <20260612095333.1666592-1-njavali@marvell.com>
 <20260612095333.1666592-33-njavali@marvell.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260612095333.1666592-33-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/26 11:53, Nilesh Javali wrote:
> Update ELS IOCB handling to support the extended 128-byte
> els_entry_24xx_ext structure used by 29xx series adapters.
> 
> Change the signatures of qla24xx_els_logo_iocb(), qla_els_pt_iocb(),
> and qla24xx_els_iocb() to accept a generic void pointer, enabling
> differentiation between standard and extended ELS structures at
> runtime.
> 
> Introduce a static inline helper qla_els_set_vp_sof() in qla_inline.h
> that centralises the 24xx-vs-29xx vp_index/sof_type encoding: the 24xx
> layout uses separate u8 vp_index + u8 sof_type (EST_SOFI3), while
> 29xx uses a __le16 with bitfields (vp_index:9 / sof_type:4 /
> ELS_EXT_EST_SOFI3).  All ELS issue paths now call this helper instead
> of open-coding the branch, including the RDP response path in qla_os.c.
> 
> In qla2x00_start_sp(), collapse the IS_QLA29XX() branch for the
> handle assignment in SRB_ELS_CMD_HST_NOLOGIN: els_entry_24xx::handle
> and els_entry_24xx_ext::handle are both u32 at offset 4, so a single
> 24xx-view write is layout-compatible with both strides.
> 
> DMA allocations in qla24xx_process_abts() and
> qla24xx_process_purex_rdp() are updated to use the correct size for
> the adapter type.  A BUILD_BUG_ON is added to verify the extended
> structure size.
> 
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_gbl.h    |  2 +-
>   drivers/scsi/qla2xxx/qla_inline.h | 28 ++++++++++++++++++++++++++++
>   drivers/scsi/qla2xxx/qla_iocb.c   | 28 ++++++++++++++++++----------
>   drivers/scsi/qla2xxx/qla_isr.c    | 26 ++++++++++++++++++--------
>   drivers/scsi/qla2xxx/qla_os.c     | 31 ++++++++++++++++++++-----------
>   5 files changed, 85 insertions(+), 30 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
