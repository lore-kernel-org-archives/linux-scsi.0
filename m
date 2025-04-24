Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4257C1F16B
	for <linux-scsi@vger.kernel.org>; Thu, 24 Apr 2025 06:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745475436; cv=none; b=jpZGpNC/LFWW/X1oAq/5YqDKX28P13mGXbbc52K9JMPyGAlDZRp+fC2iZQAZb54egp3heXhNlSxmbctlaB7SWdhTDrjP77rzrpFy9mF95F1EqzWeiEeD0G8ZPWwcTX928MJ9m2mZsETfOzwB5YUQ45Azd3eThMj4sfKKatdl3Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745475436; c=relaxed/simple;
	bh=fyGmp8mGzUbcqCq/5J3RhxcTRbewBgpZEWixJJFfYjA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=DWlxmRCuC+9hLfjYepPZUfP8H+Vgp7jYZym4Kz17dwShKtgH1V26o0193i6SDql3sOItzBhrCVS4QBRKKgXl118LEQuJtE9LFXyhY9g3EeMASoMQq4ng1DnmA5tASiEsh6G6Yx+cJano68AqG7TZyHXmLblOu7ML6/z4taxohIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gE066K8T; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gE066K8T"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-43d0618746bso3835605e9.2
        for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 23:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1745475431; x=1746080231; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KsAAZRuX/xSl4WRwZczRb8M+rDuVwpPHg90UTTqeBKk=;
        b=gE066K8TMw6JmVyUyGvZGgO5u5PhVQD6dZ4WNqkJVwx3fVfY5QN8n24ZrTfw38K2dh
         EsIhDXWMxpS6iOtnUad4V8cYDflYSgpgw0BAWG4RU1bw3CYCCo6Lua15PH2Z7hQeci20
         rgSnhRKO/zVyMuQH/cPc3dS8zXL4ubQFr8cTU+g5R0CymUoCX+y2zZxGBiN1ccSerhOU
         PrXRAMjFP/8efV6lU4rdBeAS+xCGhPUQfTSCTx0JJxu8FdzyaBY/mcuG28PpxfWLAvgu
         HI9IdGnudY//Evna/aa43FtIBc3ar0LiZMpWnMmlIajKYDruPUjxSLFJVlq7pzzpSTUJ
         l3GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745475431; x=1746080231;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KsAAZRuX/xSl4WRwZczRb8M+rDuVwpPHg90UTTqeBKk=;
        b=AWRW1Mwmv64JdyLE33QE/pETkVZRl6mPFvzNoEm8KXVvC4yJYAomFV0BceKQpwOoWy
         7pmqpja/QzU1R4JrxDpCli1fAXcJ7EirZonVxEK+STvSaHJ0YHRL/8dHPXTNGPJhMoYt
         K+v3ehPCO5OPbVd4mFyMiqDcU2o+sE624dCJyclFBFE4egMYxMYjEoDUGZile2cxk8fH
         J4LEWvRsJ9kW4GG3Xu/ICxoAOG9u1xPmgMI8DctAx/dP2SoTjpOm1JL/Y57pefJfJP9m
         jKG4OyWq2GXpdSdlS4q2JmqGMd1rfV7cprjGXYY82slkbO603bB4gDwrgapuAM6bAQ/1
         h1jQ==
X-Forwarded-Encrypted: i=1; AJvYcCVhcjorYJbx301fWDh/tq4qNJvU8TmyTmwXDqeZqFZmk4U6H7Yo/vjeXTIUPRnBduESJRfuUvwwNOKU@vger.kernel.org
X-Gm-Message-State: AOJu0YyW4pk+aB0qMMBhPh1k+GkcerSrHMJU2MDSAwaprLLk3kyucOsE
	foRYm30yamWgonBDtsOPuJxHOPeuKY1YhRaduTj2iG2kDYbgmkjBc2N23bFZIpk=
X-Gm-Gg: ASbGncuf9vpFnaNKAyml7Zn7pMbrFz5nH7yabaH0MPgstEoiVIPKQBh6fOfbQq6u7yC
	uIRJk4SlN7xV2RXa4DEp3Bb05FPPKlvDsWw3sYCVJquBmvp/INY6YOrHBUm8hZQZ0FsvQbRW3bg
	kzHWJG6sYfxa/4CmmDhZb9M5dNbm9lEDZZ+xbOYcbH5YHxeau7Kg9o4NEuFfe363jroMjqtE9eq
	7jsbw100Kz2d+6BgBFxw0krq1AfCXcwq8WfwzHdra+fquNbo+ud11UsNHFwb/W6XzA3J621Bw49
	zjJI+fMYGCM9XMmvKC8zUYYx8CQfXfnsajSTdtMEaARS7jY5luFb3FEi+B9I1QUKYOS/eK5qUzx
	F
X-Google-Smtp-Source: AGHT+IEQiIx1mu/Fp9b3blvKEGL/FHgnqvfDL6p9gG6QA8S0KeIMIYqZ4U9XW8AVEmjlFfJH8oZB7A==
X-Received: by 2002:a05:600c:5009:b0:43c:efed:732c with SMTP id 5b1f17b1804b1-4409bda8768mr5916465e9.28.1745475431527;
        Wed, 23 Apr 2025 23:17:11 -0700 (PDT)
Received: from ?IPV6:2001:a61:2b7f:8f01:ed13:8888:df70:a3b? ([2001:a61:2b7f:8f01:ed13:8888:df70:a3b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4409d2a35f0sm7119535e9.15.2025.04.23.23.17.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Apr 2025 23:17:11 -0700 (PDT)
Message-ID: <c8a5f40f-9c8e-430f-ad86-291a8af39b46@suse.com>
Date: Thu, 24 Apr 2025 08:17:10 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] target: Move delayed/ordered tracking to per cpu
To: Mike Christie <michael.christie@oracle.com>, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20250424032741.16216-1-michael.christie@oracle.com>
 <20250424032741.16216-3-michael.christie@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20250424032741.16216-3-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/24/25 05:26, Mike Christie wrote:
> The atomic use from the delayed/ordered tracking is causing perf
> issues when using higher perf backend devices and multiple queues.
> This moves the values to a per cpu counter. Combined with the per cpu
> stats patch, this improves IOPS by up to 33% for 8K IOS when using 4
> or more queues from the initiator.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/target/target_core_device.c    |  20 +++++
>   drivers/target/target_core_transport.c | 119 +++++++++++++------------
>   include/target/target_core_base.h      |   4 +-
>   3 files changed, 83 insertions(+), 60 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
