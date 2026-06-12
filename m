Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBEAE379C4A
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 11:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781262734; cv=none; b=QwutZdQHg1BMx4LgxQSipYsezwUYQGf0Dge9u7XhHNr+aSjjauiv4YFwXGvfAhDwkvgvKhL8c7TDSsvonNLShlmreZXCUyyN4oOkNx6CsBalAhDQRW47j4QVGUF2R3GqyPmYsjvXC65hz/VkphMwAGA8sbT4BBz2w3AQZg7yTDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781262734; c=relaxed/simple;
	bh=cjFqE5ch5ZRb5l5fvEiPogdtJ9jT5y1a5IeFOKB6wfk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o2LCauATuX0HH09NqhnNEsONh3J8wrk3ixdICvJLaCJHTdjR6bPA5HNA7bQeVI3oohhU06vz0BCC3Os5IePpITMA6D9U4oGW+bzFnWfOOcI3aRmLyIOz0ciLROe3vdn0CySr7D2KSZ1CqZl9ZstmynRDP/glI4frDN7yg2eEYNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FBIkfXPc; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FBIkfXPc"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-490b64c8311so8879375e9.3
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 04:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781262731; x=1781867531; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dlvae6sIXcIijD22gUnYl9QbVcarkzy0pbtSZbWuPM0=;
        b=FBIkfXPcXjmyVM1WwelVHJNv5URz++dlc3uYuSsjvfGxyhzVDWyghSXRaZVF+YoXF5
         QbrrZhyC96T5f7YPbV+Fu1RD29o2d/pm0BGUmn+ew4xbAzqBETp3bb8nRKL5ta6bLL28
         g+4YN2UK3BvtvmqvTGApwXM6tpVEFSmtquZqHp60FlTSE8sN6ztUKwIH03cYIIUpaQfe
         B+4DBcF+yQy4hChOomWv/ooGdPlO6yV9NzkPInnjSre0kSS+Tc13+VJqhh7N0PiS7bdB
         qZhO01PJRUMo2uMJ7eNoQOYXAdBVuBVAdsaYHqZNafjW6vMYEeHqzPQ5NeoSOrwXmanq
         CM6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781262731; x=1781867531;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dlvae6sIXcIijD22gUnYl9QbVcarkzy0pbtSZbWuPM0=;
        b=ngyqCEv//f8WKHUL524vVng9MVkO69XlGLGPeFuNExM8tiEkQ1KJnWeuJnP2DPuG+U
         TwKD7dJf2SHJvI3VgTktpY6v34lsEHFXjp7QVAV4v3JsgDNvXYV/2cjCYec3HgsPtIde
         S8QqbU5S3STl8j4pt2gNJ6szA4qDEQJne6f1lXfoVZV4grOpydJUVWsF1t4kOqVbtn3b
         PNc+VoOOHk61ZbzwyHZ6g9D+BiyqgtFo9Wac6Qh7ixRZRTzGEKN2vZyK7T1FnUoIAXvh
         +gEsF8GweCXGR1xuvz/ODC6VAh2HCt+KKo3EadPaJezQcKHhJTDUF+b8Jnkw1MaU0hPq
         +gHQ==
X-Gm-Message-State: AOJu0YyLzXX0F13U50LmBD+aW/H2GjwqHB668gNI544gvEV7yTHTLH20
	dVaU9fVN8Geu/VCxvDeefQR8olNB/UCmUoCtDpDwmMZ3/J0Ov1Q+o/VHRtmNB7TqXtg=
X-Gm-Gg: Acq92OEorbVMxQBHSFTxBaQKBuSgaG8pVXEFigjH5DjUaIn/zWhhkJa2gEmjwnOAE/D
	bEzjbcRFf5clhUPkv1pWs1Eo8iPjEKe1sePn7tcWh+19BIm8NVhxyZWCBpOJOpQJGG2HKtiLM6t
	a0Tec66auiwt3e4OoFKyKWK/7xa4dTUI7icjEguImxQchPj008ujwR79GKOq8XThANJolYZFLlQ
	kBRIt788dJuWCAbUS4TkX7JFscA2/BmWHvu/uy/JfZQKYWQ7AswkAYi+CyTPUS5xk1PcWJ5h/VN
	8FSvK+9yrMhytLA1RitipTmxgdFj6jJnbOHICyYX4cVWtdwlFVEy6Z/++WtLgMaYLFsmP/d6IiH
	mzRQ55/hsHQpfWH/rm7qEOSpLdJ0m84yHyAu06fm7JClRtsFx0eNb3HUtn2bswCpn4D7JlHISgP
	/bO/y9q8/gnsSBkAvK/vIPj4lRIzayT65hiwHR0a4zKgA7rV9b+HYYpFgs
X-Received: by 2002:a05:600c:c4ab:b0:48f:f64c:c2fe with SMTP id 5b1f17b1804b1-490ec4f8090mr35179585e9.22.1781262731257;
        Fri, 12 Jun 2026 04:12:11 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490ea7db9c6sm59230645e9.8.2026.06.12.04.12.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 04:12:10 -0700 (PDT)
Message-ID: <7e173b1d-301c-4065-8350-a63c0a404daf@suse.com>
Date: Fri, 12 Jun 2026 13:12:10 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/60] scsi: qla2xxx: Update IO path to use 128-byte
 IOCBs for 29xx
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-FC-Storage-Upstream@marvell.com,
 agurumurthy@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
References: <20260612095333.1666592-1-njavali@marvell.com>
 <20260612095333.1666592-13-njavali@marvell.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260612095333.1666592-13-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/26 11:52, Nilesh Javali wrote:
> From: Anil Gurumurthy <agurumurthy@marvell.com>
> 
> Wire the 128-byte extended IOCB structures into the IO submission,
> completion, and queue-management paths.  On 29xx adapters the driver
> now builds cmd_type_6_ext / cmd_type_7_ext command IOCBs and processes
> the corresponding extended status entries, while falling back to the
> existing 64-byte IOCBs for earlier adapters.
> 
> Ring entry-size selection uses the qla_req_entry_size() /
> qla_rsp_entry_size() helpers and ring slot advancement uses
> qla_req_ring_advance() rather than open-coding IS_QLA29XX() branches
> at every call site.
> 
> Signed-off-by: Anil Gurumurthy <agurumurthy@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_dbg.c    |  31 +-
>   drivers/scsi/qla2xxx/qla_def.h    |  24 +
>   drivers/scsi/qla2xxx/qla_edif.c   |  18 +-
>   drivers/scsi/qla2xxx/qla_fw29.h   |  77 +++
>   drivers/scsi/qla2xxx/qla_gbl.h    |   4 +-
>   drivers/scsi/qla2xxx/qla_init.c   |  59 +-
>   drivers/scsi/qla2xxx/qla_inline.h | 174 +++++-
>   drivers/scsi/qla2xxx/qla_iocb.c   | 940 +++++++++++++++++++++++++-----
>   drivers/scsi/qla2xxx/qla_isr.c    |  48 +-
>   drivers/scsi/qla2xxx/qla_mid.c    |  31 +-
>   drivers/scsi/qla2xxx/qla_nvme.c   | 123 ++--
>   drivers/scsi/qla2xxx/qla_os.c     |  33 +-
>   drivers/scsi/qla2xxx/qla_target.c |  17 +-
>   13 files changed, 1323 insertions(+), 256 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
