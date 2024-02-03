Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358ABF51F
	for <linux-scsi@vger.kernel.org>; Sat,  3 Feb 2024 03:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706932291; cv=none; b=OVCvbbphG0BQXQDMa4TDDwd6MTPe8yz29Hiu/D9JVx12K+QbAIlstaIrh2Djg4EUYWVmKg0MUgKKBkELier4KmF/lSb3aTrcaU+WNzLx0fZfCU3FNH1nYPm4kkHDktBliGJJDHPaBRzDX1WjwfMS69kmlsbL8y8GCbAqN8CPKps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706932291; c=relaxed/simple;
	bh=ZWCmf/5DIDBznX7a2OGcu2nGKFNT/U9ZzBAPRx1V7uE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H6TNcJj+pgkxZrdC9wzXQMJQCkqkEOlG5ydv3ONCyvZDDHlNU9y2efL5g74nla3ESnr0IKVnntT6hglMaZocTfVPAgzh9xAK9s65JY9oe2QSIZ/UOneKWyuqaQWKlxJh6fvNflZUKd5DZMrMTY/GkaH0UrjMgcPq8fmuZyn9n/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-3bd884146e9so2047339b6e.0
        for <linux-scsi@vger.kernel.org>; Fri, 02 Feb 2024 19:51:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706932289; x=1707537089;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TMWdnLLkDbbweyd+nLHDo1Daf1E+806HjTcfqQPG/q8=;
        b=d7IDrzmaQ/XLy6PzRrv8JVY+x6TDOvfRpIrzhGelAlYPvD0EN6pj02M9U6PpjLeX+H
         c04WKyjtmHmilPsEP0fp9+96aXUYqx3uTc70hgV9cxkVNLswqblrK8y3Rh6416wVesXo
         /MKwFR8stFqB2Q5MqbgKD3qJFSNdqWUZ5Tx47SDUD8/SYfUUqy8wl5t/cXpCr1GV36r9
         vug3s2Kv+tlyvJuWBTnu1wt9OpKOlPB5A9LMxoqudJMGLCGD0NIjoY1mgn16ONkyD1u8
         ddAiaMKCB49Rw/EPyPyMjK0imKSVF+uz9bI86xEIJvRls9DzF4ZMbJRS36512oIPIZ3F
         lUFw==
X-Gm-Message-State: AOJu0Yy6i2yAGJWYmH6j93wDQf684M2QTY0YyY9w8e5az2SQVNyNi1Cq
	nnRYtZbkMuAUeFI/liiAcjSdF30aWvU3yDWCZf9s169IoXxUZx7p
X-Google-Smtp-Source: AGHT+IFnqWJZt7aIVp3hoj9BgslkO5NSC/GTd6wkSZqOA39RIwZSGEdqUG3DFrmnKS+OHsi63JGx+Q==
X-Received: by 2002:a05:6808:38c9:b0:3bf:bb09:50ac with SMTP id el9-20020a05680838c900b003bfbb0950acmr6016604oib.10.1706932288909;
        Fri, 02 Feb 2024 19:51:28 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCU1rADq0eTp18gQKEZN+IiBWMMQ//QzrfEkB89ZQilGtl5tToIMcJ3JVGKKPRx52Mmnc/jxePLe8fUKJVFf7h4RddPv/FL2tDrM093ItipzDNYTy/W4c7b0AuucYxQqky3DOToIFr8KlIoGWmTp8OYGYnZ+94qtHTr9
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net. [73.231.117.72])
        by smtp.gmail.com with ESMTPSA id g3-20020a62e303000000b006d9a6a9992dsm2395937pfh.123.2024.02.02.19.51.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Feb 2024 19:51:28 -0800 (PST)
Message-ID: <8f796f59-9a1d-4105-b313-650edf41c147@acm.org>
Date: Fri, 2 Feb 2024 19:51:24 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: move scsi_host_busy() out of host lock if it
 is for per-command
Content-Language: en-US
To: Ming Lei <ming.lei@redhat.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org
Cc: Sathya Prakash Veerichetty <safhya.prakash@broadcom.com>,
 "Ewan D . Milne" <emilne@redhat.com>
References: <20240203024521.2006455-1-ming.lei@redhat.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240203024521.2006455-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/2/24 18:45, Ming Lei wrote:
> Commit 4373534a9850 ("scsi: core: Move scsi_host_busy() out of host lock for
> waking up EH handler") is for fixing hard lockup issue triggered by EH.
> 
> The core idea is to move scsi_host_busy() out of host lock if it is
> called for per-command. However, the patch is merged as wrong and
                                                 ^^^^^^^^^^^^^^^
I'm not sure what this means?

> doesn't move scsi_host_busy() out of host lock, so fix it.

Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
