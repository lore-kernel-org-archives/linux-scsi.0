Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C78E382379
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 12:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781269185; cv=none; b=FkgAtQYFDfq2t0M1L7TqNeVZdGOWFOunGnc5cQLD4ZHQx2q6LtpJROeHhqD+aKnYURyckQn7a6fK1ml2Xi82aNIXvpmjyPdk93QYYeS5V89jlhKL/TlN/AKP1glzZU9zBtopIpQsUUS6O3hlDh5CoxfFD0Hr34vQa3M4ulwDMqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781269185; c=relaxed/simple;
	bh=4lq+SfMCSnX2KBce2B+KcFX+2kY/pbiASebZQ/IbI1A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DMpfkSOFBiSvYoq5q1hDJYlO5MSxBk/pdX6gVTH725u9ScM3UyeHSgLLgHJIatAb10Oz2SmAL0cfgsEMDSh28O4ulJMed4IBe4WQwPWe8906xFC63ioXnVUFqpsoE/8/7rDoQUKIcoq+OGrAKXtqg6VMuUuJ1CLfcikPk9RBnu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=H1VcScNE; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="H1VcScNE"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-45eecb8bf67so702384f8f.2
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 05:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781269183; x=1781873983; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4OdpWLGIyZAUUrXChKdRMSNDrmSTkQAwZBD2AaBJOmY=;
        b=H1VcScNEiIa7WohTL0SJezdxpmRlkrUSnNYW4j7tqI4hYcy8odwUgGwiaPwK185/qa
         a5Sa8RNf9qowQAF3smCPl+ZOUvLkjkroTG2gf8rs1gY/Pz7ornhA7bMm5wnZWV+Sd5PT
         oH8PLzoswWJPQXdxuaIQFqLoHBtKgHSctGVezfFCPjCpurL9CLUvr6MIkrKeTaOkn41a
         CpODRiSF2iNBcmlOyTTkaK857C70Z+v0HBTsMjOQ2F0fSLAV8akk1pxEjpvdfdHI5Mp0
         1Yva/sytDolMxXIlSdSwvNLvahD7K+ySI6dDdrQqO4ZVKSPwvTcNYYy7xnoESHvfK//G
         Fnsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781269183; x=1781873983;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4OdpWLGIyZAUUrXChKdRMSNDrmSTkQAwZBD2AaBJOmY=;
        b=e05JdEq7YnvfzZ1riCzqfxfDitkNowdkauTY5kXhjVqIfuyPXa8V8kewm2pyATa2UF
         WFGLt+cEevUzZDiJMbxGL6U0kSRnrVHVrbZ4zzvvNTyC8oDaRVbMdRNQtdF4acwxfaXQ
         7EO0jabIA3PYldMfG6GPcN3+d69UOwnSwI7Smpg438yvp3uYW8mEc6OMPu78pJIYGrKL
         EnlH0fzu/oOA2G/sFqjCiiA6fPRsBeXoPXlSOpOLQy5Eh1RvR4PmSPgnvGGzYWvWGCZW
         c7GCpUNCtxvJZzATPu1UOYXPpQ1fHGp2f9eGZfoM61lhxSL+2tz6PQ8XGABV57DlWtOa
         y0OA==
X-Gm-Message-State: AOJu0Yw83tZySGTf3hJaTyze4srNCuhTYDPrH1wX/o1SoIqFy0Dkcfsu
	vOAzxpvy1LLvYOOH3PsREq4scwnOqQuAGMBuhg2A+6xYpHkBAvTeqWbRpxlSKAvftp8=
X-Gm-Gg: Acq92OEN+85u0B1jzVRa3Zj5DK0Uwl94y7lzEzgihsJ4f/oqcgs2WAQSE0quhpqZZv1
	SdvdSBZfCq+hsROZEmJwF4vsocxLz0d+qOVtkLG0bLLEJhhv72vW7FJFZyZE/APCasJHgtzjb2r
	i7q1U4H6k9NszrDzh1rI46RV/MF7zfuxWDcd+CP8UCoF5jweacwDhbGeyB+IdZa5eH2ZZErabf5
	AUOP7v50Gg1POPb4cy4u2NlYDBRDaQZHUIPja/2bTUx+fuM5IDeIl6EQZT6lAOuSBsQq8VmqxDd
	hQOZQpWC135zln+u2EAj4DxjYqcBMt+mr3V1g1uEYhAkgjic8a/uy/Y4X4eFmf4HEk2SQgTz2Jl
	q4+JVkJ050ogsSzPoNiAsx/Xh8Ga57my4kOFyovTvikYHf96uV/TRT8hRSEnccmNEybxvTTU+Jh
	6Gn1vK+Eb5d0xlVFgCap2btpr9l+37i2e/yZ32c8UNKsdhVk9pGB4pbq+s
X-Received: by 2002:a05:6000:41e5:b0:460:2477:2284 with SMTP id ffacd0b85a97d-4606dbcc0a8mr3894521f8f.39.1781269182633;
        Fri, 12 Jun 2026 05:59:42 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2b1056sm5675952f8f.18.2026.06.12.05.59.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 05:59:42 -0700 (PDT)
Message-ID: <bb5bc0ea-685f-4814-a9cf-6eab0dccdc5c@suse.com>
Date: Fri, 12 Jun 2026 14:59:41 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 47/60] scsi: qla2xxx: Fix endianness annotations in
 vp_rpt_id_entry structures
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-FC-Storage-Upstream@marvell.com,
 agurumurthy@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
References: <20260612095333.1666592-1-njavali@marvell.com>
 <20260612095333.1666592-48-njavali@marvell.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260612095333.1666592-48-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/26 11:53, Nilesh Javali wrote:
> The vp_rpt_id_entry_24xx and vp_rpt_id_entry_24xx_ext DMA structures
> use plain uint16_t for fip_flags and bbcr fields that the firmware
> writes in little-endian format.  On big-endian hosts, reading bbcr
> without le16_to_cpu() produces an incorrect value, breaking the
> buffer-to-buffer credit enable detection.
> 
> Additionally, the 29xx ext struct uses __le16 bitfields for
> vp_idx:9/vp_status:7 which suffer from architecture-dependent
> bit packing order (same class of bug fixed in the ELS/ABTS
> extended IOCBs).
> 
> Fix by:
>    - Changing uint16_t fip_flags/bbcr to __le16 in both qla_fw.h
>      and qla_fw29.h (enables Sparse endianness checking)
>    - Replacing the __le16 bitfields with a scalar __le16 vp_idx_status
>      and defined shift/mask constants
>    - Adding le16_to_cpu() at the bbcr and vp_idx_status access sites
>      in qla_mbx.c
> 
> Fixes: 1b923fdfaeb5 ("scsi: qla2xxx: Add 128-byte IOCB definitions for 29xx")
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_fw.h   |  8 ++++----
>   drivers/scsi/qla2xxx/qla_fw29.h | 20 ++++++++++++++------
>   drivers/scsi/qla2xxx/qla_mbx.c  |  9 ++++++---
>   3 files changed, 24 insertions(+), 13 deletions(-)
> 

Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
