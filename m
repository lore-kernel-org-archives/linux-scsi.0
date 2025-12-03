Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E282D5922
	for <linux-scsi@vger.kernel.org>; Wed,  3 Dec 2025 08:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764751363; cv=none; b=kH4EstdvdZCAO/vsLwz4KU9VL4oZzp1GSl2ck88NjHRDZPSZUMIIO33IDiIw4k7lMWAm1vXfe2pkWGEU8BOwKd9gIm/ToAqqZQRemgl4JMlnx4XWNokVTT5ZkQvuAg3Z56NetPBNfCyjYuxsxRNhkMVEs7M2zTR5MCY0zX4uyMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764751363; c=relaxed/simple;
	bh=ICxFLuck9SfnNnFsg4cG8X6+FFRE723qkDDin+aWOhM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y24mqS1co8Q6eS5XiZoR8jWqtvyp/LMa8REVvUrCGI/78KWbRvp/yEz+9dW3dUg2Kho0MAO79/5D7Z/hrjWORrei5GKqK6VU4NS/gMt8GRU4vIx9bogknIHXVEDd3P+l/ftGpbMamXb9AsOlY9cjjMs1yaC+LdTVOJ+nnFTjc5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TzILvVHG; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TzILvVHG"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-477632d9326so41174345e9.1
        for <linux-scsi@vger.kernel.org>; Wed, 03 Dec 2025 00:42:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1764751359; x=1765356159; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4z48MR0puKx1M1rfqil+sFsUuYO/yJFNjmgNnDwCbIg=;
        b=TzILvVHGOA1w/3Vrm6e88IsbKuzc5NCBQ1cerG4574yZadH9QN6mJ9V6qm02wu7EMr
         fj+VYa3KBKXD5BDx7VKix6FWib0m/4nQPwhkKCTsOAf/qeIS4us7/0ETWCOluSpl8R3v
         E9Jd8nTJh57fmK8/tu3EEREEBsoVuhGQY2DWiAavZ4pydNAPJbiAl5NMlkQxSXUE4hLK
         NRvmrngFCGA94t1VkVuUmsJh9i72Q98UFv0bTtnvXuJBkWV/Wuz76ij1ryCukEu3P9u0
         za1FwlV+aixd+3Nvmc26YK0I1elslHnHZx1H/T3tHWFVANtfoOZPY/W2qxN/OGRvkgYY
         ci7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764751359; x=1765356159;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4z48MR0puKx1M1rfqil+sFsUuYO/yJFNjmgNnDwCbIg=;
        b=LBjCqKoIFy8stYsqVDgtcanyRNsk1Y7c8yA1O/KdX0NqGvigSSnidkSLKkqID5SYBS
         rEdSa3TIwVLfY1gJWu4bti/o6mf8exXkCXzMoaBDKR5P30sLoKMd9TGqmzA44ITN5qtk
         vNCHOFTQ6HQd72D3oww1fsbUErp+rG1N5qnJ8bImY3FO1l4yjD9o98YJbUmIT17JF/4j
         z4ExDEF+iyjg8PR51ilD+ZQrxhupA3yWo4FLZ41PmXXv2MwdDU2jCmu0fMuj3OA+bF78
         SB4ZRYxEk1CWtIlI9zaTT8zSPzd6ZPKjEGrAbmNaHtm5hR5e6tuvTMyfA6Iyx/sHbqSr
         t0Cg==
X-Forwarded-Encrypted: i=1; AJvYcCWBfnzuRzUb9d4T1d3uoUfuhOdS+j6OX8etYEmp/dvHCcVyt2r+FzKZKkA9ZABNvM8RXt/lNwH777u9@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1Xz8NO5F3wIQSJkmVawB1KDhNM04FmK1pUEXRC1565g2A20Z5
	iwm9ulijT3vqdrpF0LFQfWSXLpIna9fxTAlXJ24r3CiwMswRF17eRrX35t86a6Xmg0RsQYdlfIT
	0qq48
X-Gm-Gg: ASbGnct9FtJVdaP1Of6dEr2W8Q1TpRIVzQI0JMJ1wXMfUcrWyr4VN5dW7BnW748bUPl
	yHvBaEzkoKUHlGAuCx5JvTApxvmhmO8Q7BZpr5B9+EG5R/Ko1HfiynrbuIU3qllhxIwj1GCCxUe
	maHteWec9u60mmMiU2GKsA59SEMggQtuTItm9TxyyYqCkSU/IRKW+R11hx++ufLqqWzyU1v/zzl
	zfB+4cp6Ky07pp4/zacQPLwJiy3VTh08WIHOR/XnltrC/nuAgbXK5TMu2Z21i+ExUlMHLTczVdF
	3sx3oVrtxaRG14XPLn3wSGTP4/YKOVzyzJykIdg3CU2yBl9Ot0IAJfVvLkXX6VopgK2MuJ7F2Lc
	BoItFj6GTDOQH936sUnQbTKwzb2LXpCJMDqZbBCpB+cjIZLEnrbpMZg2fANzCIc60qzyfCVT4cq
	wDpQPovqkIyCb0XdDgiLZ7mRHH+CVUPbH31MsFG/ywVf0lERGe
X-Google-Smtp-Source: AGHT+IEy36ArV9McU30R8H12wfKSN4iaRTsluRsIPsdGl5bOondsDWhwEKL9yAl9sToY1SSYh7kLpQ==
X-Received: by 2002:a05:6000:1849:b0:42b:323b:f138 with SMTP id ffacd0b85a97d-42f731c2b7dmr1313815f8f.41.1764751359294;
        Wed, 03 Dec 2025 00:42:39 -0800 (PST)
Received: from ?IPV6:2001:a61:2b8d:fd01:a55e:1753:c605:d34f? ([2001:a61:2b8d:fd01:a55e:1753:c605:d34f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42e1ca9aea3sm37237413f8f.35.2025.12.03.00.42.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Dec 2025 00:42:38 -0800 (PST)
Message-ID: <34848777-b370-4a63-8b08-c3246d214167@suse.com>
Date: Wed, 3 Dec 2025 09:42:38 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] scsi: core: Fix error handler encryption support
To: Christoph Hellwig <hch@infradead.org>, Po-Wen Kao <powenkao@google.com>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>
References: <20251203073310.2248956-1-powenkao@google.com>
 <aS_pE4nf7wQ031Y8@infradead.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <aS_pE4nf7wQ031Y8@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/3/25 08:38, Christoph Hellwig wrote:
> On Wed, Dec 03, 2025 at 07:33:08AM +0000, Po-Wen Kao wrote:
>> From: Brian Kao <powenkao@google.com>
>>
>> Some low-level drivers (LLD) access block layer crypto fields, such as
>> rq->crypt_keyslot and rq->crypt_ctx within `struct request`, to
>> configure hardware for inline encryption.
> 
> So don't do that except for commands that can actually be encrypted,
> i.e. those that have non-zero payload size.  I think you really want
> to fix this in the driver.
> 
> And we really need to stop passing scsi_cmnds to the error handler.
> 
> Hannes, any chance you could send another batch of your decades old
> series?
> 
There had been an intersection with the reserved command stuff, but
now that Bart has dusted things off there I guess I should give it
another go.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
