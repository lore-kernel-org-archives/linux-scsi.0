Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355193DB84
	for <linux-scsi@vger.kernel.org>; Tue,  9 Jan 2024 21:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-3bba50cd318so3749783b6e.0
        for <linux-scsi@vger.kernel.org>; Tue, 09 Jan 2024 13:39:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704836355; x=1705441155;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lAOoMafluleKVEuXmIEHxXi2fzZ2EbWXVvt2++4Z07k=;
        b=SPqibwdTHkluSAAoVSuQn2DHiBjLLG2xsVcngp8lYkNULoCK2XF65HOcnR+CNfz4wE
         UdeqBgK54sYeTlwNuifScm5umcUo/a5mmBBoI3OOL5Xt7rTHKYjqEPATEZ/SjssdhnO3
         d/lyScvLzlqx/k8VIef4Ix07cNwXNHb01DfctUDmwrPKsYfCNzS++181wOdlUXDZaZdd
         CTqP553UPo/a2cZtqHqGwseHRzhO/BpCVjTNDYP1YwHEZrvN4sHYJkaLhSrIXqtrTgPY
         sjwazRVozLd47ZGAzZPCmIU7ANrbrsxenUdjJkuG3pZBN8d4pfAqCupIZiWiONINUO5u
         0FqQ==
X-Gm-Message-State: AOJu0YyOn6313mSFTtSQ8BdIv2Dzh0C2fAJr0c8+t6Foin8WK1MfEWVp
	zToLjNqqtUwjmpoaLzpXCys=
X-Google-Smtp-Source: AGHT+IE8yJIYk9ze4T7Aq5Y9GakcgVgv3X8mnoKGL/FypBLl8onlImjvI5vtOKePmEsruvpUt374DA==
X-Received: by 2002:a05:6358:914d:b0:175:9466:12eb with SMTP id r13-20020a056358914d00b00175946612ebmr21468rwr.0.1704836354971;
        Tue, 09 Jan 2024 13:39:14 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:b76f:b657:4602:d182? ([2620:0:1000:8411:b76f:b657:4602:d182])
        by smtp.gmail.com with ESMTPSA id u12-20020a17090ac88c00b0028aecd6b29fsm8976530pjt.3.2024.01.09.13.39.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jan 2024 13:39:14 -0800 (PST)
Message-ID: <8bbbd233-69c6-4f20-904c-332bb838cc42@acm.org>
Date: Tue, 9 Jan 2024 13:39:13 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Regression] Hang deleting ATA HDD device for undocking
Content-Language: en-US
To: Kevin Locke <kevin@kevinlocke.name>, linux-scsi@vger.kernel.org,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
 Niklas Cassel <niklas.cassel@wdc.com>
References: <ZZw3Th70wUUvCiCY@kevinlocke.name>
 <c7c4769c-5999-4373-90df-f2203ecfc423@acm.org>
 <ZZxvPtrf5hLeZNY5@kevinlocke.name>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ZZxvPtrf5hLeZNY5@kevinlocke.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/8/24 13:55, Kevin Locke wrote:
> -8<------------------------------------------------------------------
> sd 1:0:0:0: [sdb] Synchronizing SCSI cache
> ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> ata2.00: ACPI cmd f5/00:00:00:00:00:a0(SECURITY FREEZE LOCK) filtered out
> ata2.00: ACPI cmd ef/10:03:00:00:00:a0(SET FEATURES) filtered out
> ata2.00: ACPI cmd f5/00:00:00:00:00:a0(SECURITY FREEZE LOCK) filtered out
> ata2.00: ACPI cmd ef/10:03:00:00:00:a0(SET FEATURES) filtered out
> ata2.00: configured for UDMA/133
> ata2.00: retrying FLUSH 0xea Emask 0x0
> sysrq: Show Blocked State
> task:ultrabay_eject  state:D stack:0     pid:2630  tgid:2630  ppid:2629   flags:0x00004002
> Call Trace:
>   <TASK>
>   __schedule+0x2c1/0x8a0
>   schedule+0x32/0xb0
>   schedule_timeout+0x151/0x160
>   io_schedule_timeout+0x50/0x80
>   wait_for_completion_io+0x86/0x170
>   blk_execute_rq+0x11e/0x1f0
>   scsi_execute_cmd+0xf6/0x250 [scsi_mod]
>   sd_sync_cache+0xe6/0x1f0 [sd_mod]
>   sd_shutdown+0x68/0x100 [sd_mod]
>   sd_remove+0x55/0x60 [sd_mod]
>   device_release_driver_internal+0x19f/0x200
>   bus_remove_device+0xc6/0x130
>   device_del+0x15e/0x3f0
>   ? mutex_lock+0x12/0x30
>   ? __pfx_ata_tdev_match+0x10/0x10 [libata]
>   __scsi_remove_device+0x131/0x190 [scsi_mod]
>   sdev_store_delete+0x6a/0xd0 [scsi_mod]
>   kernfs_fop_write_iter+0x13d/0x1d0
>   vfs_write+0x23d/0x400
>   ksys_write+0x6f/0xf0
>   do_syscall_64+0x64/0x120
>   ? exc_page_fault+0x70/0x150
>   entry_SYSCALL_64_after_hwframe+0x6e/0x76

I think this means that the block layer is waiting for the completion of
the SYNCHRONIZE CACHE command. Can you please also share the SCSI host and
device states after the hang has been reproduced, e.g. by sharing the output
of the following commands (these commands require the bash shell)?

(cd /sys/class/scsi_host && grep -aH . */state)
(cd /sys/class/scsi_device && grep -aH . */device/{device_{blocked,busy},state})

Thanks,

Bart.
