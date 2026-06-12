Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE75337F731
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 12:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781269014; cv=none; b=mX9P213mIPW+1Vk6Pgt3y+SpS36O67Z9gIwW4IZ6an/xrNmwtFco8U1gKYRNGfyzptgghcTlvgun3NOaE7EYcefAskW3itnkbCwXX9PQM4La+hmdYW2xyeANIOulFRmlE7w7Eb8h2l12azbQQVv5pdDwpQg+P6h3oszXAT8vUzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781269014; c=relaxed/simple;
	bh=p6MZaQVoMCOlF9DHVLiMhqz3C2cM2eHoH6K3pu+HVpI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TByNOD/I8ttOKs/YGEO835aFnEWMOdL5aoMfsEIih3VIt1H+KmSkQg50hxKlLfhINy6NNxTeaVPRzW5r5czQHSSy8X6P3Ik3FEFzH3YkE9mBWbADb5sXkfB5ZLwXY5IDmNOoFiiHM3QKO4CozG8IntdKD36fdRY/oOZAHmNx0Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HvvQCH8Y; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HvvQCH8Y"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-490be03d47bso9552615e9.0
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 05:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781269011; x=1781873811; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=053yS8S7D3FF8cPnmW11N8g75yc1X8qUz6kw2oQPsTw=;
        b=HvvQCH8Y6THrLkcJ825r32O4puAuMo1IbOQXEOrzlOyP8dlw49QoBELBHxOlOQAOb/
         H4/luVm+tWEnbRA6OHyBBe2XOf5g+xYoFgV84kNbNML9OmNxwwW/T8DszkXVB8LOaxkv
         UL77WMOUfZxPfxjJ2h2a7y0cQ4tJNOGtoQpetp1yAPtgww+cSEw6afbH/Nii3tlzy74m
         Ixc3fsZomPkYwC0NFFIvEkzJ1yDjuKCcdY+S+KqSCM0ke+Di+i9XSZgf7U+dfWekWJcl
         4yR6TYgQhmTfZ7Ko+bu5ghDIfWp35HJOvKgOBh4XcJF+vRUhOAUhJ1lTJbwQxXjQkmpm
         M3tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781269011; x=1781873811;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=053yS8S7D3FF8cPnmW11N8g75yc1X8qUz6kw2oQPsTw=;
        b=iu+bcK1MLPHg0B4Zh5JBUaVNVWuO2xTG6EvzWlOIFLMKDU7ZtpVwv8ED9PZvD9adRd
         sAVSeum1/bMWOlv9mULkR5NM5UqYXq4pNtgiW8vRoSLSQFskzk0KTHQjrjPs9z0/v6Qk
         16z29Uo1igaO82UsOln0SQxFH3b1lx1idRmeJbxz0lkC2joZi1gKR3nbkEIJvAj3bXc5
         Dfqu1Zj0GcXSBdpmeX/q9Ie8fm37ILwJ/jYu+FyTrOGA40X/Z0nIlZiibccdQO9n155A
         wFbUaaySqKjtPfnPGjJKJpZ3fTkEUTR2JHWZxQhjfhCQK2/0nRu/VtXmv3m42u9P82O+
         Z18g==
X-Gm-Message-State: AOJu0YxHbbB4yR5geM6MY1H2YVagcDyRs3YXJ5BvWkBQG33rDrGPvF2/
	sd/nbBsc2Et2sk48+oSPnj+r6NmYlfNo5Pjw84MxpvFWTtOT8aTiz8xe1L1v3872wu0=
X-Gm-Gg: Acq92OG5AATr1zNwOXn/50sMQWBNA7DA50Iv7SQcNLwhHlWypnfXBGvgMb0a6Dw4rPv
	+SGiBQx9yqxL0hH11NoSUzl7u8R1QTAv72fX2TmCrUwPD724TPaqGKEDT4qgpwV9sVpz5/fLBmr
	2lLZtPO8G0xfDTUbhk96wc4uCCnfyFQVy6kaKVxIejHLN7b/Xet9FOG+pYMKld0TB4FNJT+OX99
	MMkymHrVKBmmJUC9K3wIOYeS+LLsYrECW1jScZQ/Vv4jRWgaRnqDN0AQlG33ZGNAJa1bCpkc06+
	xH9T8nfZ0TPTbUYkmNScpa3s03PQO2pm3FcvOkb3hgbM0ylKBZIMmOQ8pISlTmXZcx6THxsRofO
	oKhWzfnHjuP7A7ZU3CLs+OiratgS44tDzMBrG95WeYl2l/r5IuG7tJc8P3iLhz15laAAtTezU2D
	CimTJ0EU02DoQjw9LRGn1Q7UGM0qGLysNHm+8/ecLtsJqocTnY9OFEXePJ
X-Received: by 2002:a05:600c:214e:b0:490:e180:2ed with SMTP id 5b1f17b1804b1-490ec4bfe4cmr21490535e9.4.1781269011200;
        Fri, 12 Jun 2026 05:56:51 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490e2cf5542sm145132275e9.11.2026.06.12.05.56.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 05:56:50 -0700 (PDT)
Message-ID: <3b951376-851c-4ec8-bbb7-ef5fa289abb5@suse.com>
Date: Fri, 12 Jun 2026 14:56:50 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 45/60] scsi: qla2xxx: Fix queue teardown NULL dma_free
 and bitmap locking
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-FC-Storage-Upstream@marvell.com,
 agurumurthy@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
References: <20260612095333.1666592-1-njavali@marvell.com>
 <20260612095333.1666592-46-njavali@marvell.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260612095333.1666592-46-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/26 11:53, Nilesh Javali wrote:
> qla25xx_free_req_que() and qla25xx_free_rsp_que() have two pre-existing
> bugs exposed on the error path of qla25xx_create_{req,rsp}_que():
> 
> 1. When dma_alloc_coherent() fails during queue creation, the error path
>     calls the free function with req->ring / rsp->ring still NULL (from
>     kzalloc).  The unconditional dma_free_coherent() with a NULL cpu_addr
>     is undefined behavior and can panic.
> 
> 2. The free functions clear req_qid_map / rsp_qid_map under vport_lock,
>     but the create functions protect the same bitmaps with mq_lock.  This
>     provides no mutual exclusion.  Additionally, the create error path
>     clears the bit and releases mq_lock before calling the free function,
>     creating a window where another thread can allocate the same que_id
>     and have its ha->req_q_map entry clobbered by the subsequent lockless
>     NULL assignment in the free function.
> 
> Fix by:
>   - Guarding dma_free_coherent() with a NULL check on the ring pointer.
>   - Using mq_lock (the lock held by all creators) in the free functions
>     to atomically NULL the map entry and clear the bitmap bit.
>   - Removing the now-redundant clear_bit blocks from the create error
>     paths since the free functions handle it atomically.
> 
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_mid.c | 28 ++++++++++++----------------
>   1 file changed, 12 insertions(+), 16 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
