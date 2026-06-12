Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD6923D7DF
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 11:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781263062; cv=none; b=TwoHTMZfVV1Te82FGtIdJK5ZfeZjuQRuGsappoI1A9CIN6aSxx10RXZ1mGD1tZN4VqS2VfHiXeTiKioY5j8i/D8mKjOfVRQ4ngKsq4QbGs0B6VBs42Mfi3goi90i4Jcn/fWYMxiyokJwLaArs32XFBoIRcGsJ8fCofL8Q9QCcbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781263062; c=relaxed/simple;
	bh=vbio1aIEooSV1c4nOQfSTetKrWnRhFIf2InSRI34bKo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IOiLDFujhPtYCkpRwcMur7mzNCd3XNZHjaxDnJLr+2cFRoEAiR5f/iy7iGKFeuxLWFakrU5nrR1McnvGbgFSl7/Ct/SQZiJcDaEg3sVtWDaqJx34i1seA5G9ibT3BN35qsT8cT8BxQQE0r40O0ICSoLhU5IxQPvaZDLPxa5HjY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZvuXg/v5; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZvuXg/v5"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-490ae94a89eso7106325e9.1
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 04:17:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781263060; x=1781867860; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rCcS25RMhCQ8MJM/xm3XrBSOJggeggzd8W7jT/Abclo=;
        b=ZvuXg/v5Aj/OSafXaoXVMevGn6HubGe3z43PD2hlnVMFrgZ+SkjJGZFGJ/C/Ze+OJ7
         0ZPH1fV3dfjyD0wlGYQ2TTIriKrG33lEg9ITDVt68oZL+MOXRY3hctTASL7FJm1ZA/bS
         JeqBriOpGrVmBxulJ9LUwGDRoCTy2xnBbzOEtp85N2ChXT0AZK7P8gYa1iE+5GmtMnyz
         b/Van2YbGEUGMabRAXnFJCUDlM0dH9b8USuFwvnhOZSNG1F8kYGCUFOtMv2DYN+5C3Fx
         lqqFXDXrZchrKzvH5n6gX/XyzKiXjtcc1iuY+knro974EqUDmn8RTgC/ssw36kJX0fQl
         IYAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781263060; x=1781867860;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rCcS25RMhCQ8MJM/xm3XrBSOJggeggzd8W7jT/Abclo=;
        b=N05H+JaHOAa/gV/HogvKkcBwtQcWtXa7O/nMfHA7xNjWW9372X8YuJ1Dxty7Y1Lcsu
         vXd+6jjkCFEmvH3Dl2Jn3UJOn3cD7Sq+XFQrM1plSNjV+2lBcD23oBiOt/0g38g4Oi7q
         0vcdOx69W8ZBSnMHY4N6t8/Wk1KZSYYL+w2OX23Y2mZTwjHOKhHqGmonV49Lz4kF+IE/
         rXDWzC1GamWVmKfdU/uapJc6Gi1hj6/F5IeuPgMRCVXK4CkC5Nhq5zG7shV5rcWwy3Eh
         jRWbOtX5dyvV5s5H9yKiwWO3uvRkS9px3GRm5ENTC1CcODIQYbw4ykYoetPIIXLYwRCS
         NpYA==
X-Gm-Message-State: AOJu0Yypa9bwD1YICqCmMMbEMREISyPf1K56QZdzgGJCmi4NI+GDRJPJ
	MGu8G13Q6qr/mgcXbRcn9rVr/7NMIqjbdNM0G8m6EMoidMwAOYKuxBLyUWOF5w5SK48=
X-Gm-Gg: Acq92OHWC1+jiYwuxEKlC26uc7iLp0ugLeDR84iu6HPxRMQM+81tOv9PpFxoFzSqgZJ
	F/mgpcFl8fxc9O633Pp20oizkLpAxm+z7nbskzchrYjndAtVrGdYpeV5KRAmOrjxeWwaeOoUTDX
	WW+8/rL7jxi/kEzSrefGNUcAc4UmycDZkYzYzHZOWSA12txzoXV+mqZBieD+F1crRqxLHyuqoSb
	cXr+/w1JiHeJHfCkiTsk0L3DAIx1GI3oWnOW5r7UljIHu4iBfzKlU3zbcBMi1Ho2C5wEXqOf+ci
	MjB+IkhMLYSNGmxW6UoPFsF7Dk0WlJdpA+4vvEvn21z+mK+SxJ6RXRcSuKg8SEuIZLYxbDXACuJ
	2Tl/NM5852Kk/ytSdaRxmvU80JFmC5yiKTthaARLfZ5vbnj+F2B4KaKluID5oNRIIfS6OObEOg+
	UQ4Q2c5YDNJ16X5LibVu6RdTkxKKEhbbrgzYFdqZmVMX/zYzaYF5z+DQKt
X-Received: by 2002:a05:600c:3153:b0:490:b8e6:be40 with SMTP id 5b1f17b1804b1-490ec4fed29mr31283145e9.21.1781263059814;
        Fri, 12 Jun 2026 04:17:39 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490ea7c871dsm66191995e9.5.2026.06.12.04.17.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 04:17:39 -0700 (PDT)
Message-ID: <ae08ee47-e01b-4ffb-82e4-8a62ecc7f093@suse.com>
Date: Fri, 12 Jun 2026 13:17:39 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 17/60] scsi: qla2xxx: Extend execute_fw mailbox to
 include 29xx
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-FC-Storage-Upstream@marvell.com,
 agurumurthy@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
References: <20260612095333.1666592-1-njavali@marvell.com>
 <20260612095333.1666592-18-njavali@marvell.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260612095333.1666592-18-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/26 11:52, Nilesh Javali wrote:
> Add IS_QLA29XX() to the BPM capability macros and to the
> execute-firmware mailbox command so that NVMe enable, minimum
> speed negotiation, 128 Gbps speed reporting, EDIF hardware
> detection, and FW-semaphore retry logic all apply to 29xx
> adapters.
> 
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_attr.c | 12 ++++++++++--
>   drivers/scsi/qla2xxx/qla_def.h  |  5 +++--
>   drivers/scsi/qla2xxx/qla_gs.c   | 14 +++++++++++---
>   drivers/scsi/qla2xxx/qla_mbx.c  | 23 +++++++++++++----------
>   4 files changed, 37 insertions(+), 17 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
