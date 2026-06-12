Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF4834B1B4
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 11:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781262095; cv=none; b=qHa+InMIRB1VgcZkwiNG7mpZnVufKGn0VqyhehORLJKS56ODWt3eN4GzWYZfr2BgAAnF+TgmRG16O//sV6RznSQPTfSlv49tdWe9fVjdeXML7e2ePmSyz36OCECg3zxuEdXt96Wu18zldd3C2j4CDL5jjx+AO617ibYbjxcl1t0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781262095; c=relaxed/simple;
	bh=X+x7lycZ+7am6mTQMJBxrg+nz5Mr2HCqr0PYx1Xk7jw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O+kGYLZHEysqNEKbDaN73uDYk4W3FVvsnjcFWE+OfNxeW0m6U0brjQsIxEvtN8OHaBkey4ddK1ISc8sL7TC8xiSHPREZmLkVGO86JAz7c9D7QmxoB9Yb1Fxgx40mReaczQ2dmKIYIdp5lfz6Yw4Ccv90Z8wf0ZNqFEwY56om2YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TCFxkz+d; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TCFxkz+d"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-490e1904089so7095295e9.0
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 04:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781262092; x=1781866892; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JPI8Swg4BVlNlLtrKwTLNcPmshlCU2C5FR0QuKXvDAE=;
        b=TCFxkz+d3rbojGSDx+D0mFuvoMxGt7wyAKRH5VReSHI8UmCyt5G3F8dXvTUPvJdeNI
         ZL3+Oc5i8xXgGMs5+AkJBGhDn9mnHRFgR6vr38TMrIFXE5omfGX13/nFh3b+BGmPE0z6
         4D+oQC43DKzmCTSCsEzhVlnZ/EPOxxaVVADnBjzJb1AWqJUGgILProKZ41dT2GiNiNgh
         +9AQOtyIXfBEpbtrGyOzCc1UDI2F/JIv6fzZ8TJsTcaBnmofCfKn458+6XxQHqUXNhqO
         ZkKHRgQAJwyhiGHkIu1iBeOqg7F6M2wDLinmP65CxTabjsMKqIJB1xmYryWemB7ZIYuB
         83bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781262092; x=1781866892;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JPI8Swg4BVlNlLtrKwTLNcPmshlCU2C5FR0QuKXvDAE=;
        b=nPZghW5tIM878gVKd45MJZKqyS7A3tPrxeAG9M+wnm6CCUtkzemoWw7HhFY3Wh+cRF
         0fW+c93UCbRjJVcS2ae7I9aWZsKeUOKnBFBPEU8kPQx98mP0ZtAd4/b0Ly/ihIiu9QtI
         z5vzKFfqikrhyTCSeFn/adYoDZC3y9UzMJtmm+OwCDbPIKyg0PKIJkxZSDu0pFqK4F/F
         JQNXJkQmWV354EoliwFkKV7vZ8SCQldWGaMhVbg1WXJM0MgQZYgC8a9ViA8HSGvynNbd
         ZOdUfhVpSHwif5WKCwJkQmlLuJDt9t7RvHOGwqgSIvl3YEkCwtD3F8yaLZscHfTK/kZs
         5vaQ==
X-Gm-Message-State: AOJu0YyIhuagZAOWRBCZb4O1LcgFmiP1Im09OefVxwaiKW9u2IHNVwJR
	+ZlySaRKzZSqXJ69Qb57gfjSD+N4GyTqKacDWQO/1SkYzhsx2cM7OlZ8O76JiKAIG74=
X-Gm-Gg: Acq92OHgoNQWSzpEbGD4fd6oH5Zvb/GmwgywAxRNwpBMu5Jv2kyMI4B1rdvSOWIRbv2
	GCtwRh4zqoApWffezb2YKmWwgjAvU9xgJz77hYXUDtJ5njcLFXZcFxO1SsLqq/BCQIeZ5pNAUF+
	ipy31eEq8G75J1JwBuCeFoubqDf0CrA75WBENMg+sukvbdIz1EcqbhccqjLCBaH9rlGAsLqQ3Cd
	H2SfKYd/b9hpxDxWBc06Fc8BYYPUNgEGdXTTm7OFYSizz7On6nfuvGafh72vaR4UoK4Jt8gbl1T
	5pUxQypJTEfej57hFTqxi/pTjWbNKydZnn4Pr+vjZRFZZVTRoB3ClS65yOcNsDDlyE6cjdfT44a
	AHntdd80ERRyYjY0zTKhjs7vok+BFT/pAbmnvbI3il7RlbzbbIZLt/ADExFFM34nyb+brxUcei7
	MmS36DWWS3F9xAceq9+FsrpXvF+nM9AhBMXMDJ8qtq3yOH7WkjhfYuFgBLqNkdq8DLvV8=
X-Received: by 2002:a05:600d:6454:10b0:490:be78:1861 with SMTP id 5b1f17b1804b1-490ec4c61e6mr21545405e9.4.1781262091597;
        Fri, 12 Jun 2026 04:01:31 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490ea83da91sm63844285e9.10.2026.06.12.04.01.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 04:01:31 -0700 (PDT)
Message-ID: <71db787e-26ce-48e1-89e2-e52c02b0adab@suse.com>
Date: Fri, 12 Jun 2026 13:01:30 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/60] scsi: qla2xxx: Add 128-byte IOCB definitions for
 29xx
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-FC-Storage-Upstream@marvell.com,
 agurumurthy@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
References: <20260612095333.1666592-1-njavali@marvell.com>
 <20260612095333.1666592-10-njavali@marvell.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260612095333.1666592-10-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/26 11:52, Nilesh Javali wrote:
> From: Anil Gurumurthy <agurumurthy@marvell.com>
> 
> The 29xx series uses 128-byte IOCBs instead of the 64-byte IOCBs
> used by earlier adapters.  Add a new header (qla_fw29.h) with the
> extended IOCB structure definitions that match the 29xx firmware
> interface.
> 
> Signed-off-by: Anil Gurumurthy <agurumurthy@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_fw29.h | 725 ++++++++++++++++++++++++++++++++
>   1 file changed, 725 insertions(+)
>   create mode 100644 drivers/scsi/qla2xxx/qla_fw29.h
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
