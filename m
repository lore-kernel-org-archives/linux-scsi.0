Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD39F358D27
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 10:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781261847; cv=none; b=czIYCnflCBUp8Q6BjYGXK/TZOE+ye3EbKR1FXUamlMSYsoVF5eb1pKNen0CF/FNV90fKFiccYXHjg5lVPgy/JLgX5kX/aD2X3/qM/WmdE/R0ho99VhzFKgwVh8cdpfoqXFq821/p22kPfLBfOOCg7YRyz6xULMY7i/2TL3nCDTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781261847; c=relaxed/simple;
	bh=69r9XVRL70vBXl7Zb2fvdjVhvL7VuKGBVd3W0kBlybc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PJlbYHLOH/XDWovdhJwVdGHfLaLudvSs3Ey6JfO9+kOElm0SOHkrB/hVJQgCjVUARRkEbkLGO+knMwwqYntdQhLvGx/Ot1NVkgpDc82WfP1tqnZ3dA6TaWKrniGESf6Ojw0BoPHR816B8WQoQnHZz5qK9yt+d4uObXOcMum+XNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aIEqvc6B; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aIEqvc6B"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-460662fcb4eso548381f8f.0
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 03:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781261844; x=1781866644; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=REPz1Lmd4J4WSXCDRxfdEq407BLL4iFwl6hyKi4NHTU=;
        b=aIEqvc6BTFVj+IvrlvA7bcgau8kTpDQgZ1y29/ereiJPt8HYgkIkr4xj6RThOmR+rB
         /pXJw1cOd0kPUDD2EIQlZOwbHPXDQxQYEyB8Ri25sRygvTEJdHcxY0PcM/rhlgDsti6H
         bmnFJMnyU5sIJKqbHS/lU8SFrp7JIk/Vq1ZUYozyyG/4iQ8muM9D7UhaJiLilBrW9E+L
         Wf4NNTbq9WOWWp+tiV0rbvRcJD5hrRsWZ2H4ALnpu5YIFwaMV/GGTjfuPgkr29F/bFI1
         xHM1gnl+TaGT2Q9UeayA0RHzXIBvUEkgW8RNykRUBotdrM/6gtzUc6PRDbOdu7QfOFbp
         8bYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781261844; x=1781866644;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=REPz1Lmd4J4WSXCDRxfdEq407BLL4iFwl6hyKi4NHTU=;
        b=rxfxUWKXX7X+vryIIK4lvPy3Tc0VU0TFmhU/YwSC68NfGCPRX/hY8vMrdE1+j+TOkR
         DI4mgL6ktoKx8iVRUyt4PMZSi5blmUqpL7Gk3L4Jte6wqP8pRA0DOvIuKQKh233LLoag
         MI0IwQgV1iVRn7NeP+GxgvY31kAC5Gu+ANBfdFghfkz3ooDp2TAd6rGATyY9gTBMJodT
         uxiKW9afNxU6sKqGsGv6FfZ/vrC5bAQgsuIq925CiTn8rz7O+x1m+Yr1gSUFEB3Zl0sl
         80/F8musWrdPXMcXzcjVmClHYewtQiA2iPp+bkNvs8vC9Vrrl+kGqyNjgCBnTkN+TXI+
         FhGw==
X-Gm-Message-State: AOJu0YwvieB7mEQkct7jOuFzuPicAI8ZFNqDIWw7xNeRon0N0u9YCZHn
	ckiEHcr13wcRrB26i5nMysfJ2X5k05MEBQ4++Y4vvyFhu65TG4hYRizS6rIC2WWzvfo=
X-Gm-Gg: Acq92OFOcN87G5AjFxrIh0W5lj6hgq8PB7430Oxyj4FxZic8ZSAIJ+OwwM7GniRysjt
	Tz/Y7h+wKbWlyihvn8GvRIQ1vJSGdQL+WKOUSS7DbPmGrmfNWo2FJQENrA34hcF4geJNWaybeYB
	Ear1gVVnrB0Bc7K069EPRWOJhIFza/5VkOEMnJ9Qw2DE8wKtHo4dAcLFYdAWhIp+eWm305ZAy42
	7oVEImmE1GQgl5vQnFms/v0eP+fgx+10ykQpoNZNe8KxoRvoKK3wpqZpAU/ZPRQQay2qUyGzPC7
	8UIIrHAUHlc0UGsZgkqAGvPdcc64N21Ka5sPq/m4g9rwuTnPYc+94XG5fyduuU9nTUq/zN2NF/s
	pv2RClgmrQII4YvqYhey7EeaUODM8a2bYIdQ0cfRlr8/RKP4PfgopgQbcMo/mJov1evGH0DCzz0
	p9SBlSfKXoFTO9MNKEv6c/g+pLzK+LZmxFSO3upA1DidZrx/teblswbKUD
X-Received: by 2002:a5d:5f49:0:b0:45e:ed7e:f8fd with SMTP id ffacd0b85a97d-4606da8c984mr3611108f8f.2.1781261843990;
        Fri, 12 Jun 2026 03:57:23 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2dbfb1sm4940469f8f.35.2026.06.12.03.57.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 03:57:23 -0700 (PDT)
Message-ID: <05bb840b-f8b0-429c-82fb-9ffde3ce3f5a@suse.com>
Date: Fri, 12 Jun 2026 12:57:23 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/60] scsi: qla2xxx: Add BSG MPI firmware load/dump
 for 29xx
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-FC-Storage-Upstream@marvell.com,
 agurumurthy@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
References: <20260612095333.1666592-1-njavali@marvell.com>
 <20260612095333.1666592-9-njavali@marvell.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260612095333.1666592-9-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/26 11:52, Nilesh Javali wrote:
> From: Manish Rangankar <mrangankar@marvell.com>
> 
> Add BSG vendor commands for loading and dumping MPI firmware on
> 29xx adapters.  This extends the existing BSG infrastructure with
> the necessary mailbox wrappers and flash helpers for MPI
> operations.
> 
> Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_bsg.c | 153 +++++++++++++++++++++++++++++++++
>   drivers/scsi/qla2xxx/qla_bsg.h |  18 ++++
>   drivers/scsi/qla2xxx/qla_def.h |   5 ++
>   drivers/scsi/qla2xxx/qla_gbl.h |   5 ++
>   drivers/scsi/qla2xxx/qla_mbx.c |  45 ++++++++++
>   drivers/scsi/qla2xxx/qla_sup.c | 117 +++++++++++++++++++++++++
>   6 files changed, 343 insertions(+)
> 
One wonders what 'MPI' stands for in this context...
But anyway.

Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
