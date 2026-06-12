Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F16BC3DCD89
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 12:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781268725; cv=none; b=UK125ZUU/L76Ld7kmLkst3gWDUXXiwxX0fDuqeyWj3ZyunQ/pBO3d7KliOimKqoMAORmwns+h2jVo1CjUEIBwu/PivYIsFdeoIOUgXV0j5rCTeuBwqzYO+X+N+2bIVIb+J691JWTPUIOxYPYNcDDZa6EdUXiplCqqfXc8Lc6970=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781268725; c=relaxed/simple;
	bh=l0GoUch9VN3HL480bMi9Vm9FRyZ9/qdagO0AACClT14=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kVq5yYDr8q4cfXNx8F3pl97/0u06/0rKavSdOXqMDJeH74HXAdCD1TgfBqB6C6C7JUCqUENE6gRUTu54zWxLDvkNmTYyt+p/P2rnufmuAxijOKNmfEDmy/let812BtYL6c/lYmUp2/7el9dGA4q2O+rmVZfU8IwQ4TuTGMk5zno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=c6v/ECOG; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="c6v/ECOG"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-490b7866869so9133855e9.2
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 05:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781268721; x=1781873521; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8hWuwOscRIFjWH0fFJCpmwtGVKj7sNYmTjPQOfN5uPY=;
        b=c6v/ECOGdl6baLe3G4FIVim9Kqq7462dZEB4jVWzwvHabFIZHv0e3ZOY5JfUCmrZN0
         E1uPxcbxQ1YkzUczmlW3hqWXll2/xoWtq+VJ2Xg1glKkHJRuvcSltqNq0Lk4iGyyCHNs
         Y9D4UjqwAT19V2M90VNwVv59jP9Bj2KA4UWBO6kcFzNfdWGnjZcc5je2QQjVXCEL2ukz
         8YVW2yY9A9k4x+qwoWVDQXZxQeDcVRW3EppFSXoaQXhhJVUbhSojySUsyGaWnvZyaw+v
         8KY5hdQdspKsY0G4YQUKvZb+SnBOHko4nFKOLmGjYunGLodDrKGyeZYPQtslohtilZEb
         CKfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781268721; x=1781873521;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8hWuwOscRIFjWH0fFJCpmwtGVKj7sNYmTjPQOfN5uPY=;
        b=ESJc4gs+cmEhNn/J3z26JmkXVLTNCD7AWWOCdsw0COKske5C40GrA6CAr3jUPWLVTH
         ZBbLYrW3vqGiCVdbt4gY1MuSHG59clbILaYb7J4DKALzQo12qbUIysk2C2dn7ywbsFfk
         ITuNCkX+B500BytLB+k29kTcCjxhc1KW6wLBuSjwvFZtRYTIQ33zEwizZXIw3KGjgic5
         Dpl7Kfr8Y4HIzE63o7ie1T8W/WJH0cfRYWLY4zfqIXOJZqw+J+7UekJ2mZ38DbvqaxW3
         BzPwK5mhTyJDrMjsxxCzNaU2A9ms+vw7+kqjcgwxYS15AZuZ+Gmp3BOzjeQeoHRr6ZP7
         ReIQ==
X-Gm-Message-State: AOJu0YwADFaLYR/qu75ZVIJ098gtlp+QtgXQsIld6XdGKRr2+uSMIHuZ
	j0MtkiCwtAtzrB3LeVfJ9J68BbnUcKO7cJ2O5ZRuv95NN/W+F30gmqERBPTbphDsxAQ=
X-Gm-Gg: Acq92OFxAatSOBTu8Llp3LbBn75Fl/7N5rLklEsTKHxCfb8LfHN6CRONSauBddFmazE
	KyUPwYuBSlRW+MoLBpSJJ+tfKBhaqXxhC7fH0Pg4AEom16Az9IPWQJcPkSNi9QINW3orpc8IByA
	64zljrKU5cBuDdiVSg3upGChaqyT92I+v+2WNPaJN8HvrPK9uH6f8l9WnP/PkHtlz6G6fdS2KYV
	GdIHCI13AYyYw+ttm62L2WgdP5Q00Hjkm44+sOmg/g6zc1cDUutVsCk9b5BOGoqSil+afzN/Ux/
	dLt0+R7WttFpAFxnrIi/Twe1pvkl7e+rOTZirACtYaRY3eKvU5UohlRiHuXvFpzBJtEJrQppfiK
	mdOXWAOsIcC1i/IKFsdaYfhmSut1REQfK1Knjs2F2CiC4ZMZTQKjCpWAloDxr2m1/CGUdtOqos2
	9LDWdIorCnGG8pdXu5D2G7yXAHLojq/lDd54oyraibXlslU0TG2iRFojJ8AY1yKg6S2Qc=
X-Received: by 2002:a05:600c:e547:20b0:490:b58b:a8ca with SMTP id 5b1f17b1804b1-490ec50c366mr24302085e9.27.1781268721089;
        Fri, 12 Jun 2026 05:52:01 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490ea843d63sm65784515e9.12.2026.06.12.05.52.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 05:52:00 -0700 (PDT)
Message-ID: <ddd81a11-e437-406f-b355-ad49c8565762@suse.com>
Date: Fri, 12 Jun 2026 14:52:00 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 43/60] scsi: qla2xxx: Convert NVMe ring advance to use
 qla_req_ring_advance()
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-FC-Storage-Upstream@marvell.com,
 agurumurthy@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
References: <20260612095333.1666592-1-njavali@marvell.com>
 <20260612095333.1666592-44-njavali@marvell.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260612095333.1666592-44-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/26 11:53, Nilesh Javali wrote:
> Replace the open-coded IS_QLA29XX() ring_ext_ptr/ring_ptr advancement
> in qla2x00_start_nvme_mq() with the qla_req_ring_advance() helper,
> removing 16 lines of duplicated logic.
> 
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_nvme.c | 17 +----------------
>   1 file changed, 1 insertion(+), 16 deletions(-)
> 
???

Why didn't you do that initially?

Please merge with the patch introducing the change.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
