Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B21286419
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 10:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781261556; cv=none; b=Z3QVLCmQYJYLD4u9mS8qWzUEuNzf/3rzc3+a7t2TFe3UO1fvY1FxbpjwCzTNTeBPJLLgfJshELb2WYgAe2xrJoqfBPqZgF+cMyZkA+KDZUbujCNSTPIkFfhRe/NwOWZLg1+BG4h+FVJ53A9z0QaUhNo4z92lu7keX3UdDwSYujc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781261556; c=relaxed/simple;
	bh=91yesqFxCqUe3DXyiipvrEoZ/30hf4/Co4tSe7i0zIk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DR9aGPjhKaXLp4XLMLnyrjVaEPqSzhM8rbDszkAXQ5ARPpHaAplJTjtI/2p+pTJfLBcEUdtFTPdcjkTFWZcevVaMR9fdUWMBBpFhjTKY42tNjPEf+G5oE9kt9bfR617YvUKBpvhTHiSjr2CpeITscrtHtI53jUQAQb7ZvVktix0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JU9VkwHt; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JU9VkwHt"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-46019b190b6so643731f8f.3
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 03:52:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781261554; x=1781866354; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=d5tyo6PjD2KnREoJmwCt1MOmM4Im1SC1ezFIqIgMkdw=;
        b=JU9VkwHto0mohhySm1mhalE95C1hA+r6sTMdLq62z1nCByimmAjoj3f4hkKF2TDxxo
         TfZtQmzXHyy9GP0Ecu1+ghgfEtquE6pHiLsEahSUPU3oxEzY3yY1TYfzrzR0oQQUqcqP
         uf4XTuT3hvGJ0i31wFlcbnsuGhhzQAUyVCViDAhMF6MongzHAxHiUrIr6B5H91AQuwFV
         eXoOJzdqbfWubb9dPKpDn3kSVhbShayyO+wslw2TMdSAyrttFq6dQzqMlTU3fkKL2W85
         /LrYYAD4X4M0s031OcxZ+YaSbD9c4+LayxcSvu9Do4mWhdTsAT70ycbxmWB8++IEPLNq
         pobA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781261554; x=1781866354;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d5tyo6PjD2KnREoJmwCt1MOmM4Im1SC1ezFIqIgMkdw=;
        b=VyqXzBcVzAgWkPaI6G/FED2+y/TL35NrZOSEv8Hl1rzfOmKtqQbjo+x93RW4E3il8l
         eSZEHxVro2b32nmHmSk/F2izuv4J5MinLQWFdxYVYU6T1IZBZQVCsZjynvsOcWGDw0l4
         Ev9Tgm2p2M/5T3eEcEkxTTuzygxxoNjBWvtrjTiBI6HQH1URk1qJ7+/ZIOxhc3PNalZr
         fpKF2oQQnAsk+PSp9VHEuDIuKKs+MVZRQdWQUtGlNfP1E6/3PZcbgqdtEwRz6hqHMG6S
         L09c37M05pCvm3C9Nl3MBjo0WRm5PXdlWNC/sNS1oCZYRhCq/zQgZpsWW9oFGRXRK36R
         Cw4w==
X-Gm-Message-State: AOJu0Yz+ycF86TcTBBjovy7EHdCwP3dbA11cSlTUge/mvKdFCrYTBCmY
	EVIAdxzMk1XiGgLf1t+m+TE0/HVGnbzSQT+QohW+K+TaDcZbxDP9r7s/0dfLU99QlYM=
X-Gm-Gg: Acq92OF3A72bGE5T6g9g7dXme6L5ns+SqXCT0AOaCuEbHGCCEaV3oSEcLuN6XtVRqVs
	OGPpWJgzMu731X4VsyTqfKyTMkqIgNvMEOMdhQYnCucZmYLC/dZ4DLkYlIfY4PGqK5f/ubz0QGT
	Zl3QGT6BK/7Q1z96ySnlUTs8cM8TnnfyUZrkbmPwhK9MBn5jxzdIoJKGqLq3bOcCxFrRq67voPa
	CABjHZJnXRV0N3BhTvg+qCeV3FmOlCG7hF2ZvWIZPAlVIbp+uEmdUcoKoBVqxrPr2dxR7hAAkvL
	547TMY3mLgr0bbUeGPOgxt2ABWVrsdflvLYCvifY4Len24VPPOx4neN+Pq7kYG/7CTlwaKBxoOZ
	riQ2VoKJkpxDteyj9B8PxbS7Y+L/lgyhjgp5bCPvH6nM5nCvD4koSEoSfnhvDDmXW6amgINyrBX
	qE0Erilktbss1nWmV+HhJXiTQpXt0ebwvKghE0IJhyLitHkXtaJAkaYhDx
X-Received: by 2002:a05:6000:1868:b0:460:70ae:f1a4 with SMTP id ffacd0b85a97d-46070aef259mr2985559f8f.13.1781261553834;
        Fri, 12 Jun 2026 03:52:33 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2b0bbfsm4668214f8f.23.2026.06.12.03.52.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 03:52:33 -0700 (PDT)
Message-ID: <ba68e669-928e-4196-80e1-aaec2ff16043@suse.com>
Date: Fri, 12 Jun 2026 12:52:32 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/60] scsi: qla2xxx: Add FC operational firmware load
 for 29xx
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-FC-Storage-Upstream@marvell.com,
 agurumurthy@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
References: <20260612095333.1666592-1-njavali@marvell.com>
 <20260612095333.1666592-7-njavali@marvell.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260612095333.1666592-7-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/26 11:52, Nilesh Javali wrote:
> From: Manish Rangankar <mrangankar@marvell.com>
> 
> Add support to load the 29xx FC operational firmware from the
> filesystem and to set up the corresponding firmware dump
> template.  This follows the same request_firmware / segment-load
> pattern used by earlier adapters.
> 
> Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_fw.h   |  36 +++
>   drivers/scsi/qla2xxx/qla_gbl.h  |   3 +-
>   drivers/scsi/qla2xxx/qla_init.c | 512 +++++++++++++++++++++++++++++++-
>   drivers/scsi/qla2xxx/qla_mbx.c  |  19 +-
>   drivers/scsi/qla2xxx/qla_nx.c   |   2 +-
>   drivers/scsi/qla2xxx/qla_os.c   |  47 ++-
>   drivers/scsi/qla2xxx/qla_sup.c  |   4 +-
>   7 files changed, 611 insertions(+), 12 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
