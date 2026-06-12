Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726513DD857
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 12:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781268078; cv=none; b=V3ddk9M+qNuFzShzlXPJsJb7iWSDthue4IhQi3IcKD/pFAKzZdQBfvSbW5u6mPmWXmJ/RP0YKX27sb1GWeX9+ZfIv5e+wHVLQBrTsXjGjYvNDMh30aCDwnv8JDdWbuBo6SctnnRchJHmozEnE8a1jftCOwGb8gtqK+0D7OuVOYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781268078; c=relaxed/simple;
	bh=Y/+RQZB3nO6ILxXfo0zFxXsZ9YmPFfaeYpFn2nZetnc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WIuVJgPlwBkaIAgRH5rwc4xxscHrIw1ZDvluFSLm56HnO+ZizoNbvjYmTexfUzpkwa8RrxyhOoarwy7jDfEqyainFIeBx3Qvobxx+YxD7CLJjXTqB3ZmeETqaJRcAMolPZ/p2G8Iu2u4hIidhxu8ongsme/Qy6tslKiRd5L6+8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=akVJZ4Wg; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="akVJZ4Wg"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-45ef4223be7so505520f8f.2
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 05:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781268076; x=1781872876; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lyPn50lw2YOuOWX40mPIG0NFBbkWIGL8Yk7Wj+dufIY=;
        b=akVJZ4Wge/t3+NSaUMGiC+va6cYU4/VOk8IJYEYJxL5QOmzHWHcs7osihpGbOeQ66k
         KfUfJbFaqmxRrKvBWLNbV9OnpUOHIgiFeV+f+5oah/gJDLWisoOhI8vluLcM7J/cc3OX
         faoGryAz3dgrbs52X9Ec7M0kv2raUeK+Ud9smIuR2yLzTBCPVEOncGIi4VXEBlSzNgTC
         a6nG7tmcSzPx1g9glclS7cNDC2tT+DALFaHf2JSAXy+7Terc6BR6D50HF20Gxyc7gc2P
         U5c1C3DH0MP5fhfXlochAbkb5E0hQw+iYf7PTicFhYZJEGG7YIUsuXpkZRj1inAjMn9l
         h02A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781268076; x=1781872876;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lyPn50lw2YOuOWX40mPIG0NFBbkWIGL8Yk7Wj+dufIY=;
        b=FKt6KzjMo2AU14ALwwigB5gnUFti0L7Mc8I/203BQ1YhOtcLEC/CBnFrdhZ133fTUC
         Y99yrFIxNvvVDJE1QIgDHjXO5L9BE7gxynFztxTmJpsmWb4eBBquKMHQ+Bx5JkCk5BEN
         tLGksuJ3KulRjuhOBrYp4O9Dl5RWR71xkQAf+jbq2empfQc7bJvTzuAD7jjZyioZ71Wz
         Tu/yUXG0T/MtO4eJaZNmeQZLCqFJL2/a/v6kqq5oJWA2tZPNn2Oa+bB/6VrHqtuXe4j4
         5KBHm6hKtXBixeGufbGmmYjjlDFBoFTqQoYFBMVnauSo1KpNMdhatt6vH5OP6CMXuOAx
         HyKA==
X-Gm-Message-State: AOJu0Yw2+XuvN2Af2d4WegjdaMTGzUDhW6EUfkFICH1bpQhPvBH10S3D
	oxm4cuvhDNa8YYwTyzr/Hemhtbq4IBVwsemiL2aU6yXPJk7dhxs6Fj4TdgZQ/be35pM=
X-Gm-Gg: Acq92OFcLmL8u9e4jwHvD1z3FR2nIM0I3xJ8nRfEr40M7K3r7oa3jpIuE9Mj6+99zts
	gEXKXobYmaN6pqLHkcD4S3wlIZtVt/176MPcdrN7bwECZrj8fj8xmQevWa6hgyN+6FwRnelv/wO
	7iarKBpkDTtcCSOuhhYbgU3unQj2ObeqHbhuJJRbINn/8IVMKqEgVv5EcWXuBgSW2tiUSjcTtEL
	6liWufJFc+27LiE3tuj4zH5TG/8ZHbyrmDPH00ssXBLtc4fOYHiTDiOLgMx0UwO7dDjo6KrN+Nb
	WfiWv63tX5XDZvwDMIustvKLYl/xUM7eemtWyxZ8gcOjCPRjeixOeeVmvS2iY5++bsnutO82cyT
	KWRG3j+AoY3Q9xhcAp6tTKXsW2Rs4qG9VQfMq3Bjbm+iu5PfR4fQ8/OSdmrOHebe9vO/bd+7BBs
	tcQ24shmRPpmfNbPn1kv1kEUgL295N2/s+sePshztXr1Ge1+KREpoC/SMa
X-Received: by 2002:a05:6000:46da:b0:460:1a57:dd7c with SMTP id ffacd0b85a97d-4606db9743cmr2757842f8f.23.1781268075718;
        Fri, 12 Jun 2026 05:41:15 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f26f3basm5276875f8f.12.2026.06.12.05.41.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 05:41:15 -0700 (PDT)
Message-ID: <4c7a952f-e35f-45a4-9d4a-5ce040064c89@suse.com>
Date: Fri, 12 Jun 2026 14:41:14 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 37/60] scsi: qla2xxx: Enhance ABTS processing for 29xx
 series
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-FC-Storage-Upstream@marvell.com,
 agurumurthy@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
References: <20260612095333.1666592-1-njavali@marvell.com>
 <20260612095333.1666592-38-njavali@marvell.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260612095333.1666592-38-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/26 11:53, Nilesh Javali wrote:
> Use extended ABTS entry structures (abts_entry_24xx_ext) for 29xx
> series adapters to properly handle the larger 128-byte IOCB format.
> 
> Introduce type-generic macros (QLA_LOG_ABTS_RCV, QLA_BUILD_ABTS_BA_ACC,
> QLA_LOG_ISSUE_ABTS_RSP) that leverage the shared field names between
> abts_entry_24xx and abts_entry_24xx_ext to avoid code duplication.
> Branch on IS_QLA29XX() for receive logging, exchange termination, and
> BA_ACC response construction, with each path passing the correctly
> typed pointer to the shared macros. The sof_type handling difference
> (direct for 29xx bitfield vs & 0xf0 mask for legacy) is parameterized
> through the sof_val macro argument.
> 
> Add BUILD_BUG_ON size check for struct abts_entry_24xx_ext.
> 
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_isr.c | 167 ++++++++++++++++++++-------------
>   drivers/scsi/qla2xxx/qla_os.c  |   1 +
>   2 files changed, 104 insertions(+), 64 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
