Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808FE265630
	for <linux-scsi@vger.kernel.org>; Thu, 18 Sep 2025 06:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758177117; cv=none; b=S8tMgiyQf3MytkNG1QJNMZGRWg24sbN0F17cqABbICGdw/Jgza+A9T2hYN4BYRLLnfOi/Snu+ZR12UHf4y2SNbkbW7RpDa6OpjgGMcXDlG68yMKU31xQbyIEKEWhsFOlrsBR/f2oA/MaOMgA+YZskoMZiHqPLir13xydwYBMmpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758177117; c=relaxed/simple;
	bh=tqjjPOdw1Jg62QI2picFjWMRENrxDQK4lLxM1I25rxM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=T2y1BbiKE+qzI2wFfzDUE83kfizRFNu0/91HA50plrTORBrl6Fpa9CYGZnvS/zuhnVu+dIazJz2y4M4XkgjngqyuwTZCqDRmQgo81sin9ztFTqRfKlkYf0Za5TLWrwWOTf8egcXimL8OLmOP0JFEiU25xLMrMFfxqmoiNYUFlCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aOA0K2pu; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aOA0K2pu"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b07e081d852so103443566b.2
        for <linux-scsi@vger.kernel.org>; Wed, 17 Sep 2025 23:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1758177114; x=1758781914; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wuZHOs6t/YVWP7jmWbtVeLQEg1XFgW/8IGgnj2m3170=;
        b=aOA0K2pupLo2ZfWQpd0VHrWNjfCrGpl1TocNbM7sdiHGl8onbm+/rkkWtWrW4Kl3gK
         YCDgmtEGMZrmZx3efr4tDu3Q37SuA775UBiSP7zpoer9G+jFW0ylE4o8bDHzymiPGNUL
         tvEADN6NSgFNQ4bq/EJYX08LuLtbnQcOcTKmg862i2qc9DzlkPXVfyd+z+RQCBvwUcot
         XVKdg8RUhg5JOoy+/3JnnqJenlh+HAomS5p01+pd1bEzNesCo6dzpaY7Eh/mPc53DW7k
         axoSn5aG7MaHbiBHVczgBGR3jWqlXv8eMsEOLP2qGCA43US4E76C8XusnVOxRS8tFjgy
         dxEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758177114; x=1758781914;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wuZHOs6t/YVWP7jmWbtVeLQEg1XFgW/8IGgnj2m3170=;
        b=nsRA+sEA6K94LucQnNaN4vrYj8F6Lky9mzXKCG98+XDIO3NGSaxohlXIOsnYeF0m0Q
         eZMKKgIM43ZRYkRk7QXCsZjcZI+2s9yk40DJXyD3y1TiHndYiptY5WgiyuRlJXqJD4/7
         ZmQaYozrhQQBeHdPem9o9q/zGtyl+jvKGUActrEx3QKkDD0TxSU5cGaDhS3VNSAesJjM
         ++4uAI+2pd/d/RpBfgpyQ7ge25FTR/8qSz7Yxn195GG0wJqioL4JD2GntT8emfUD33Cx
         PKOXbKZ0emO8Ktq9axiDUUuqZy0nrGPf10e09hQhFUsTBAwwBQfz6QHYu9wqC/VzWtpH
         brsA==
X-Forwarded-Encrypted: i=1; AJvYcCUlMV/Pw0lY6A8vFoOU5NYU0Q8980AZ3iX9Qfn7dR0LyZiszWkBnWTzO6KFLleydz9CR09NaMDrJg/D@vger.kernel.org
X-Gm-Message-State: AOJu0YwKsZHF6JWoNpjib4ByMNu/N32x6kmkT6TUxkb3sbV11nqu60nJ
	2ofqUkIJJKd59w2Ac/gvKfJIXDPcOcIGLs1S+pQJwgi58vSjNDOIx40BDafFlrQdX14=
X-Gm-Gg: ASbGncvW7VSAGZ4wBqLLcN1nrOdYO8HPODhC2oAG7PWHlOeLCUJ4S4p0iD97bm7+1Hc
	EE5xPhUDVSVaMwnT/qGGf6Qkmtk1GVZU+p3VpZnR+IjmGBi3oeT2gygBAcq4rVRFQagPXiP/4K4
	ml2SDE8YqLClsojem5dYHBLoqcqkTddfIecIjyO/6qr+z25xtlI8fNr/3Aqn9v6TBwNL+u/8dmT
	W/3GcRB+23y0g+9h6vgUZ5DX4CdJlmlubwxlYPjRfk0kg0gjbpRI0mgrK/R5Y4n1SRT6oiGZw8U
	56NwIvAsT7LIPVYyOoJOpvpP8xnkGChiKw5WbbwPz/xAwCsGRT7oifHgPOhlICRLKEqj9E3yZIw
	indvzYz+KsaVfBrjAVI1UHJyqBQJucGl++f2qqvPeREGuxkmsKuwpXUF2HQpqCTNUgq+rke/PI9
	mIIoY=
X-Google-Smtp-Source: AGHT+IHe3Y3NhYECl5dqTv+1NobzXta1+PjMpav0U21h4SQ5zBX4MEYc5XAYJUXjiV8ukv2wn6JZ5Q==
X-Received: by 2002:a17:906:c146:b0:b04:6bb6:c91d with SMTP id a640c23a62f3a-b1baf5089f1mr466145266b.1.1758177113777;
        Wed, 17 Sep 2025 23:31:53 -0700 (PDT)
Received: from ?IPV6:2001:a61:2a86:6301:7dfe:e974:37b1:d013? ([2001:a61:2a86:6301:7dfe:e974:37b1:d013])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b1fd262953csm125387066b.99.2025.09.17.23.31.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Sep 2025 23:31:53 -0700 (PDT)
Message-ID: <03e53a96-d94e-4608-b52e-bbd87b8a90af@suse.com>
Date: Thu, 18 Sep 2025 08:31:52 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] scsi: target: Move LUN stats to per CPU
To: Mike Christie <michael.christie@oracle.com>, mlombard@redhat.com,
 martin.petersen@oracle.com, d.bogdanov@yadro.com, bvanassche@acm.org,
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20250917221338.14813-1-michael.christie@oracle.com>
 <20250917221338.14813-4-michael.christie@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20250917221338.14813-4-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/18/25 00:12, Mike Christie wrote:
> The atomic use in the main I/O path is causing perf issues when using
> higher performance backend devices and multiple queues (more than
> 10 when using vhost-scsi) like with this fio workload:
> 
> [global]
> bs=4K
> iodepth=128
> direct=1
> ioengine=libaio
> group_reporting
> time_based
> runtime=120
> name=standard-iops
> rw=randread
> numjobs=16
> cpus_allowed=0-15
> 
> To fix this issue, this moves the LUN stats to per CPU.
> 
> Note: I forgot to include this patch with the delayed/ordered per CPU
> tracking and per device/device entry per CPU stats. With this patch you
> get the full 33% improvements when using fast backends, multiple queues
> and multiple IO submiters.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
> ---
>   drivers/target/target_core_device.c          |  1 +
>   drivers/target/target_core_fabric_configfs.c |  2 +-
>   drivers/target/target_core_internal.h        |  1 +
>   drivers/target/target_core_stat.c            | 67 +++++++-------------
>   drivers/target/target_core_tpg.c             | 23 ++++++-
>   drivers/target/target_core_transport.c       | 22 +++++--
>   include/target/target_core_base.h            |  8 +--
>   7 files changed, 65 insertions(+), 59 deletions(-)
> 
Ho-hum.

That only works if both submission and completion paths do run on the
_same_ cpu. Are we sure that they do?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
