Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA8E33555B
	for <linux-scsi@vger.kernel.org>; Tue,  3 Mar 2026 06:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772520773; cv=none; b=Pa0i84s6zWU4XrO9XylHx3oKC1vCh7W3K5Z9NlqjJdkNA95VazsKGJESQiN8AYvpr24Jy1dJ7byPwwWAaT8kix2I9xmaFByKcFAhTOcLpZFAlfTBq5Gf5TqqhCF/0iSHye0CMguh/FxsoJJMknyi3MwR3b2Xu2DaAdysXKgmAq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772520773; c=relaxed/simple;
	bh=9pJJVTZZM3QCn+oui6V6Hn0OTNpM5sMorAYDGGh6gjc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=doQbJainOkbbaUwS8UmwQy/Q3obG0p54lZCNOCRfV/atmo4Rm+Wj+yJnSjoxGMcXdv484N7202eN1p/mwpT8eaaJOZqDpYsSjsE9kJJI+PeYUK/2IcjHj9Uv8K2vkrRVthUh71UiduzzL7mRTsWd5ZS+MO9jzH9a83vatoINbJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UMYmIObU; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UMYmIObU"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4833115090dso54436165e9.3
        for <linux-scsi@vger.kernel.org>; Mon, 02 Mar 2026 22:52:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772520769; x=1773125569; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a2Ju36mr4bvkPwgZixZd3t2ngeaxuwiZ8lFBXsrk3Fg=;
        b=UMYmIObUN4/oM4vfYXnZUXRM3s9LASnYhiZNzk49OfX5dCqqH9jwwCByprsDUaQM26
         aQNtwWG08Pybai5dyO19tVIhW1UXZkfH5VGKkYOYGUteVFvX2KnCaZtaLmTK82EYhAUs
         mxNezfuR24MWB0ZylFIe/SajiNPDmKaSMybl46jeVLV4P+H4Fm/E+Y4p5RVhZ2qod2hG
         c0haasIIZq8edFaHW6MW3d7mP6tX0ZEx4DHvu8V1mQT+OEmQG58UHK6DZN/7a9Fw9Yzy
         puYatkbMBYXURzMXbZUYq5JSbMHXJLB9m6y9HkuZ5MHgwfPsX1o7FaXcL6xSO680KlAW
         YU4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772520769; x=1773125569;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a2Ju36mr4bvkPwgZixZd3t2ngeaxuwiZ8lFBXsrk3Fg=;
        b=l+0yNG/cAweMm2V6w0n8GbAxWM4OTBIXlVUsGtErmysYU5Nhqk+ScEd+Iqbujy9SnT
         LxVOJCZ2EbRmp62fh0x0mPkrtZ4BOiFKWUecP4B1a9P0parCB21b1LRzG7cHZ9b3nlG2
         f8qLt+l6JxaPAWnJ8AapjEbrEXBMhTupk45Mo/C7oXmZaPuHOrIesUSfG9Xioges+v92
         YcnsK4rgFyqb4/nF18QorpO8dAQZGHH9kDa4yeX/6tsP5SiZD2P2eEEL1ya2rn8dPgGm
         N2fuLDoWZWQIO8unxidbMdAXf5xHBjRka8ZRcaTpmy0WHGMTB5rip+1tI7qc6XrjEdP4
         AjnQ==
X-Forwarded-Encrypted: i=1; AJvYcCVTXvSqVqKQNyqEezajDyjf+NjFVZpjjQmX+5r7KO03vzTeSYAYAkIIfPj1EoeybSdw+rQasWfTTYL5@vger.kernel.org
X-Gm-Message-State: AOJu0YxwpFq6xUbM07myJDArytlhrDvHcxPIZRXvth6ySWSBkjveArj1
	FHCQ+PDigBOjXsZQjNLVJ6ALbXrs8KtB4hIWxbGgvUAszMUb2UrtIp6+ImoI3LKX8ds=
X-Gm-Gg: ATEYQzxnjajWG4BhHQYgSfEFfbZupljMaMJpcMEJ1o8MGVj8P25VsggYVpt9vVj9Bin
	Rk3nwS9mlK6we9wEPfCWn7wdX8rT14F90hHJW6JVhCU/Y3SDIpEteTaY02CugnVprkYlD45XxVY
	hovprWFFVc1iyVxnMsREI92flCNNHxdvF+OVRWemTaPS9aJXSquzz5q7J5V1DLvUmZHghbSdNvS
	LCHHIrZ4TYJXbMutZMkHC45BAZV8cnhr4tuVyHNQTCEZpYApipeTwo6UOkMnPa+VjpfFBjBRj8T
	9I0w9JcMpXmbAZdxOtdIpEI1GJddTjtKOkV0dOznvXF5T1ANIq8iNaaz4j5ljExGtGqld61SS+e
	Aiq1Ed6rlARPZKsuOlPm7GPJx4YeRUK3RXQJtiym4IjGsBjDP90vGaCWtjPYR8tr1h71lNKaHb1
	u6ORgjucrjAuV998PNNC7xir8sY02zT/nZ2w8PG7thEi7WUtpIM/Jyk3k/XSnWzFWCb5F4MKEAm
	lQF
X-Received: by 2002:a05:600c:3108:b0:483:887:59b0 with SMTP id 5b1f17b1804b1-483c9c1cd2bmr282993795e9.35.1772520769194;
        Mon, 02 Mar 2026 22:52:49 -0800 (PST)
Received: from [192.168.178.47] (aftr-82-135-83-117.dynamic.mnet-online.de. [82.135.83.117])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483c3b3ce8fsm329359945e9.4.2026.03.02.22.52.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2026 22:52:48 -0800 (PST)
Message-ID: <d79cb9d5-8935-45ac-b2f0-f86f0728bd8d@suse.com>
Date: Tue, 3 Mar 2026 07:52:47 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/24] scsi: core: add SCSI_MAX_QUEUE_DEPTH
To: John Garry <john.g.garry@oracle.com>, hch@lst.de, kbusch@kernel.org,
 sagi@grimberg.me, axboe@fb.com, martin.petersen@oracle.com,
 james.bottomley@hansenpartnership.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
 linux-scsi@vger.kernel.org, michael.christie@oracle.com, snitzer@kernel.org,
 bmarzins@redhat.com, dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
 <20260225153627.1032500-2-john.g.garry@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260225153627.1032500-2-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/25/26 16:36, John Garry wrote:
> Add a macro for the max queue depth which is supported.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>   drivers/scsi/scsi.c      | 2 +-
>   drivers/scsi/scsi_priv.h | 2 ++
>   2 files changed, 3 insertions(+), 1 deletion(-)
> 
Maybe: 'Add a macro for the supported queue depth'?

Anyway:
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
