Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180941799F
	for <linux-scsi@vger.kernel.org>; Sun, 10 May 2026 22:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778450597; cv=none; b=nw/IjaBC7u4heYnsIyKdFmT/8Bo9bd+wQVJy65mbe9cv/04dR2SQhRZX7HWDiA/OGn9IO6Kvepke5fiv0k6nHTJNwcERLGnt8LkcJJuEh2etV7mbxu7cPLBDxjzRYyMN25c2yJMtDisXWzuFGVNo52z19ZO9rcfOteTgIdZR4w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778450597; c=relaxed/simple;
	bh=fCqlht/qE5LYYm9uvUbmL1f49xyJZVdgsxDC1qfEkYI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o7mOQTBSHL5uHSgwJ48MyHpqWK5SW0mJKWRExUaK4zd3p5Cy1WoQysU9byF0G9MSPMjnhlYpxpgJlEaw2WWunVjx+oIQrbuZeyRUfB0B5iIAG0sy082mVnxb9YFq+SGO7Iar6ESnGnhMdAqgRlDr6dawIIiEKEYdDqrUJomWKus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4890d945eb4so27536505e9.0
        for <linux-scsi@vger.kernel.org>; Sun, 10 May 2026 15:03:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778450594; x=1779055394;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7TT88Obqx1AJAzXu0jcEZD6MoC4AHPr3xtkjAGFDve0=;
        b=UDfBI+z7OhvBRW4y68AWmZvxnXCE6qWyXdxrXpL67yA0Y4iSQheju7ZkTpuwNE9IrA
         N7QyAIGYY9F7z5Eb0HbxiCrHu/cv6oq8Blykytv+hb+1fEFwE6pNdVHcjNDfBEdMKDAN
         retjzgErYigpgYGDMFbIpVTiC6i75Z/eOg6Ms+Dt3k/o8nCe7m2A9mG4yn19lHXff11K
         9kILdIyQNHtpe+naCJjU3JB96PTOzRGnsfr2nZ7PxN2wiDGWvCCDpRKbUUSq5EF9334J
         ITFndhYp0s1OuJ2luprosIjKnBMHem7oXhXje2RADGpAkRLUSpCK95Tzw8mfBM2RuJ2U
         vw0Q==
X-Forwarded-Encrypted: i=1; AFNElJ86KZaK80Auy9SehTk/COivwqAWzDhQrl5nGWIals0OnbpFu4HuxOqZReZEVx8EKRRCKPOLidlR/KYJ@vger.kernel.org
X-Gm-Message-State: AOJu0YyWwLgnjNu34Zfxb4iEj0FOLayOswkZOX7n2PehcBCKUCCR2k+A
	TJ/p/G3gNkE7wM5xSETnT4rT/QDTym3MGUkpYRiCsD8UDTVy41ALsxGf
X-Gm-Gg: Acq92OFXT478/wiJTkBFG26VYUY8th/7Kl9M0HQDxL2lIF5zSh1LnF9oo2wsTOw+Qh7
	l5DHz8VETv1VGRTPzH64DPx5kJJO4MgQeKLSZaK2emqcBOlAkvaPYp1Oz954qfvvY3aX8FKzR/j
	60vDZ5qYDOd8SBCzmgTBMooBjkOy8cPakBz56/Bsjrmv3kiZe+NXNedXm6Mz7C8/v2awhuLgA9r
	9yVIHDkXJx48he3o1nUsYmJ6k7/vAFSpudc2VXiSJA89qQVDMVTZGudAvZ4xn3FtGaZCiEf/hcp
	serlw5fQq5O0/wKrc9YOoXNyANfM/XzSr25/laPt8uPv7GXcsL/cDerOAZRqOhTLvFNc9iubWTc
	MK3daOQs7yyxXw2BqjFqsIUSvzJxGVqCygaKjf8+0NovI/Mod0sPGfaCYKp5fsSOwot7+yv0xOw
	jkAi+anY3LgGpoHXKcBAY=
X-Received: by 2002:a05:600c:570d:b0:48a:5236:7f38 with SMTP id 5b1f17b1804b1-48e5dfffademr189351075e9.14.1778450594444;
        Sun, 10 May 2026 15:03:14 -0700 (PDT)
Received: from [10.100.102.74] ([89.138.75.0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45491304505sm21071533f8f.22.2026.05.10.15.03.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 May 2026 15:03:13 -0700 (PDT)
Message-ID: <ad0a1191-4928-4700-8c55-4c844a7058e3@grimberg.me>
Date: Mon, 11 May 2026 01:03:11 +0300
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/13] libmultipath: a generic multipath lib for block
 drivers
To: John Garry <john.g.garry@oracle.com>, hch@lst.de, kbusch@kernel.org,
 axboe@fb.com, martin.petersen@oracle.com,
 james.bottomley@hansenpartnership.com, hare@suse.com, bmarzins@redhat.com,
 nilay@linux.ibm.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
 linux-scsi@vger.kernel.org, michael.christie@oracle.com, snitzer@kernel.org,
 dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260428111105.1778008-1-john.g.garry@oracle.com>
Content-Language: en-US
From: Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20260428111105.1778008-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 28/04/2026 14:10, John Garry wrote:
> libmultipath: a generic multipath lib for block drivers

This is very nice John.

>
> This series introduces libmultipath. It is essentially a refactoring of
> NVME multipath support, so we can have a common library to also support
> native SCSI multipath.
>
> Much of the code is taken directly from the NVMe multipath code. However,
> NVMe specifics are removed. A template structure is provided so the driver
> may provide callbacks for driver specifics, like ANA support for NVMe.
>
> Important new structures introduced include:
>
> - mpath_head
> These contain much of the multipath-specific functionality from
> nvme_ns_head, including a pointer to the gendisk structure and
> a path SRCU-based array.

I think it should be placed first in its parent struct as it holds the 
hot-path
head->srcu and head->list.

>
> - mpath_device
> This is the per-path structure, and contains much the same
> multipath-specific functionality in nvme_ns
>
> libmultipath provides functionality for path management, path selection,
> data path, and failover handling.
>
> Since the NVMe driver has some code in the sysfs and ioctl handling
> which iterate all multipath NSes, functions like mpath_call_for_device()
> are added to do the same per-path iteration.

very nice, overall seems fairly straight forward.
