Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E8A2586DA
	for <linux-scsi@vger.kernel.org>; Fri, 11 Jul 2025 09:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752226974; cv=none; b=EzZDcK3M7LW1LeHLubiLZycbEBkQNwu0n7l1CLBCN0ZZulP1SJsqQo4LV224Sf6XlHSLwA2ehqOYyKu54pWEbtsLGc5P9mbumZRg4jmITvtK6r7YlemIjkEZ0IeCh+jKPdUhyIDvFR+ISUKt5wfVWOaIUiQlq+1MuxFzp+GzYG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752226974; c=relaxed/simple;
	bh=I9O0Un5tipiTE7BJl67zpVH9ZgKv1v+KjtEj27h/I0I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m40u8TZWOBXhA3SurSEnXG4fyabFezstxGd1Y5kBbchYAfgEG+HngQgJy9Kvbmw5Uc58sf5qvYNnCo+PQGE1miznAvlw3nfnv8ptlkJ2JRSrpwz08nXEa1INbW2+344ek0XJiJEgW5hgJYrMRzTsNDWO4KpwasCWeuxDWwoHGnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=T0wswsHu; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="T0wswsHu"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7490cb9a892so1209672b3a.0
        for <linux-scsi@vger.kernel.org>; Fri, 11 Jul 2025 02:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1752226972; x=1752831772; darn=vger.kernel.org;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=VfxM2URcquJpqnvb3+mANnD+/ukwwGYDl4TruoTMXok=;
        b=T0wswsHuqubcrnQ7oa200sFf5QVarcnbKsfKQwRWqj5MqNM6FNtDdn4kdDq55f3NZC
         OznxdbG+AMKCNe6mnDCKSjdNZviN/EqYe7tBswHBYph6cF734Le6XZHWaczUuXrBdAAd
         EIUgJFeKu2A/gFdHmSPvbVQXrpKgk+ZM8h8IQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752226972; x=1752831772;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VfxM2URcquJpqnvb3+mANnD+/ukwwGYDl4TruoTMXok=;
        b=O3jRDt5sTkQRj0Ey71GRfNPgL1sYILnWiicBHEmXL5V7FSE/52iZOZResKMxG2VJt0
         fz6yAgOdJye5jh4rzkpYztqMx9aqJ8Soi/yv8+ktsg+9uud+WK1olnTj3Ps7yN67YCgU
         3M2QckYY/tsZ9b8S0lHYQcGlINU4ysCNNulkzPW0jqQdWSV62H6O6zoTtSuOUuY43Ft0
         tahwuLmns6KWt4y+687z2oWuBV+ovlqK7VZTCqCOej3jGEhayEV+5dB/0BzjUXBGTKZg
         UXGbF+9iCA/+upPm/G2zWOqwi+I6u4t014uefCrPq4tc3cdn1y+Mi8Oi43vkCZ4jerVz
         bNUA==
X-Forwarded-Encrypted: i=1; AJvYcCUn2GhfDhUvOKGUDeRhzXLuoMkPBLw4hWTtvpWLWhlTOOHFPQByEov9zj+y5VGx3Q2sBG55hFij+O1Q@vger.kernel.org
X-Gm-Message-State: AOJu0YzPABDpuK8YCA/9h1AI9TdzMM6A70lyFeTlJ84pTYrcJUI0UF+W
	ulKdO+fUt0cbRnRKhZ4dTnz9i7LW0kXjU4Tid07LCTlN6ndw2bDWrJKU3tAC3/pgdGtQtZZ5CpY
	/t3Af+8rjJlmADB34c00dGnRlDIgCNcKeQUgDKiawM8TagmYZ/dBj
X-Gm-Gg: ASbGncv68ABcCFMsd094QR9tuR8YOuNW604BDhuVV8S4Z2u7FHwFrCL3VNqBB3SsDZ5
	DKKUj+LewAlvVR8lDikPVgettmiZA45YFt96QBeZkUF44+IidYFttCevjJEJjYdgeLmstEsOcoJ
	mHRFCsiqDC4kCye2BIRXAvA3DH3Te21SHVYPJ3BDEreoa4GNAiuZ9vLtJWm8UUHdpP8QlsEDMrV
	ZXdR0/jTpzOzUabyINa+OEKt/8k195Vvy93UE6J+2/uRHVvVHvKguVEgHWi4RgV7qPMQn9YJUeY
	Je1Y3N2iCc/Q2X5eSbafT8FZeWPPtJLXZpQgKRQMS93fpDH/zvC4RT/cYipaXHy6KID4PZE80Wb
	v/k9y5jEQo6zuvJHPfHNQDPLVG5t37nffeD1sZFGI5UsVEW1irevTrYGGcnC6BQyTuuUS8Mm0oc
	aAHnfu
X-Google-Smtp-Source: AGHT+IGm3ziFKwBeSmcyN3il/RxWPJpQ9gQIeSWurGWOmKmZGOROcHUyFJ9hAmY9m8N1Q0l6qqjWLg==
X-Received: by 2002:a17:90b:48c1:b0:311:afd1:745b with SMTP id 98e67ed59e1d1-31c4ccbc409mr4086739a91.11.1752226972506;
        Fri, 11 Jul 2025 02:42:52 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23de43411c8sm43605745ad.184.2025.07.11.02.42.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jul 2025 02:42:51 -0700 (PDT)
From: Muneendra Kumar <muneendra.kumar@broadcom.com>
To: bgurney@redhat.com
Cc: axboe@kernel.dk,
	dick.kennedy@broadcom.com,
	hare@suse.de,
	hch@lst.de,
	james.smart@broadcom.com,
	jmeneghi@redhat.com,
	kbusch@kernel.org,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	njavali@marvell.com,
	sagi@grimberg.me,
	muneendra737@gmail.com
Subject: RE: [PATCH v8 8/8] nvme-multipath: queue-depth support for marginal paths
Date: Thu, 10 Jul 2025 19:59:25 -0700
Message-Id: <20250711025925.1831977-1-muneendra.kumar@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250624202020.42612-1-bgurney@redhat.com>
References: <20250624202020.42612-1-bgurney@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"

Correct me if iam wrong.
>>. In the case where 
>> all paths are marginal and no optimized or non-optimized path is 
>> found, we fall back to __nvme_find_path which selects the best marginal path

With the current patch __nvme_find_path will allways picks the path from non-optimized path ?

Regards,
Muneendra


>On 7/10/25 00:03, John Meneghini wrote:
>> Hannes, this patch fixes the queue-depth scheduler.  Please take a look.
>> 
>> On 7/9/25 5:26 PM, Bryan Gurney wrote:
>>> From: John Meneghini <jmeneghi@redhat.com>
>>>
>>> Exclude marginal paths from queue-depth io policy. In the case where 
>>> all paths are marginal and no optimized or non-optimized path is 
>>> found, we fall back to __nvme_find_path which selects the best marginal path.
>>>
>>> Tested-by: Bryan Gurney <bgurney@redhat.com>
>>> Signed-off-by: John Meneghini <jmeneghi@redhat.com>
>>> ---
>>>   drivers/nvme/host/multipath.c | 7 ++++++-
>>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/ 
>>> multipath.c index 8d4e54bb4261..767583e8454b 100644
>>> --- a/drivers/nvme/host/multipath.c
>>> +++ b/drivers/nvme/host/multipath.c
>>> @@ -420,6 +420,9 @@ static struct nvme_ns 
>>> *nvme_queue_depth_path(struct nvme_ns_head *head)
>>>           if (nvme_path_is_disabled(ns))
>>>               continue;
>>> +        if (nvme_ctrl_is_marginal(ns->ctrl))
>>> +            continue;
>>> +
>>>           depth = atomic_read(&ns->ctrl->nr_active);
>>>           switch (ns->ana_state) {
>>> @@ -443,7 +446,9 @@ static struct nvme_ns 
>>> *nvme_queue_depth_path(struct nvme_ns_head *head)
>>>               return best_opt;
>>>       }
>>> -    return best_opt ? best_opt : best_nonopt;
>>> +    best_opt = (best_opt) ? best_opt : best_nonopt;
>>> +
>>> +    return best_opt ? best_opt : __nvme_find_path(head, 
>>> +numa_node_id());
>>>   }
>>>   static inline bool nvme_path_is_optimized(struct nvme_ns *ns)
>> 
>
>Hmm. Not convinced. I would expect a 'marginal' path to behave different
>(performance-wise) than unaffected paths. And the queue-depth scheduler should be able to handle paths with different performance characteristics just fine.
>(Is is possible that your results are test artifacts? I guess your tool just injects FPIN messages with no performance impact, resulting in this behaviour...)
>
>But if you want to exclude marginal paths from queue depth:
>by all means, go for it.
>



-- 
This electronic communication and the information and any files transmitted 
with it, or attached to it, are confidential and are intended solely for 
the use of the individual or entity to whom it is addressed and may contain 
information that is confidential, legally privileged, protected by privacy 
laws, or otherwise restricted from disclosure to anyone else. If you are 
not the intended recipient or the person responsible for delivering the 
e-mail to the intended recipient, you are hereby notified that any use, 
copying, distributing, dissemination, forwarding, printing, or copying of 
this e-mail is strictly prohibited. If you received this e-mail in error, 
please return the e-mail to the sender, delete it from your computer, and 
destroy any printed copy of it.
