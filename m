Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8837A56440
	for <linux-scsi@vger.kernel.org>; Mon,  8 Jan 2024 21:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1d4ca2fd2fbso8437835ad.2
        for <linux-scsi@vger.kernel.org>; Mon, 08 Jan 2024 13:33:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704749638; x=1705354438;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lENAuYCpJCCLcBXq/6HG9fKOC4bWrbgWn/zrs639J4c=;
        b=l522wTISQIEqzK90toZPyhoKRQC0mrbSkU/B1LC4lE6ZWC82ZfeOrWgLTqD+xLHvZY
         wUPmGUY2vpweyhkQUrhsye1xWgkK4JtYz3AVHaQGLuzqG18ubkMqJqoZuc0yHgl2b4yu
         q+t50m+tJHa6xxW0mFNM/sdb8gs2iv3YkIns9D9to5QyFO0tvU6stZJrjcTXZPmCuORv
         g7ItrkobYYQHZyeF8Iwmt7vdOvhj+1s5OoOcbh4VblOGKeTElfLCylNIjhmm0N2p8b5N
         FIbAebWyw9SpsuSZTRkHXtZ/HNBz7OT9IZQjVl4NbN2PY1pGrYwfmecxxxM0+ukvKr77
         kfZQ==
X-Gm-Message-State: AOJu0YxbNJzzhXRsVMvELuCBlnewIHiBjOF8IJLqzXdxARNKD4BcB7Gr
	9wEnqTuDQHtSFz3NLSCcJNM=
X-Google-Smtp-Source: AGHT+IFMpUEYTMf+mPSWA4+VbteWN8b1OzpCEBXqJy3LLCuRJayQ8QyO4sht/Uh2fphnHMZ4XGqSjA==
X-Received: by 2002:a17:902:cec3:b0:1d5:8cf:110e with SMTP id d3-20020a170902cec300b001d508cf110emr1864408plg.88.1704749637466;
        Mon, 08 Jan 2024 13:33:57 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:fe53:b285:ad53:95e0? ([2620:0:1000:8411:fe53:b285:ad53:95e0])
        by smtp.gmail.com with ESMTPSA id m11-20020a170902db0b00b001d4b17161dbsm337678plx.217.2024.01.08.13.33.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jan 2024 13:33:57 -0800 (PST)
Message-ID: <c7c4769c-5999-4373-90df-f2203ecfc423@acm.org>
Date: Mon, 8 Jan 2024 13:33:55 -0800
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
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ZZw3Th70wUUvCiCY@kevinlocke.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/8/24 09:56, Kevin Locke wrote:
> Hi all,
> 
> On a ThinkPad T430 running Linux 6.7, when I attempt to delete the ATA
> device for a hard drive in the Ultrabay slot (to hotswap/undock it[1])
> the process freezes in an unterruptible sleep.  Specifically, if I run
> 
>      echo 1 >/sys/devices/pci0000:00/0000:00:1f.2/ata2/host1/target1:0:0/1:0:0:0/delete
> 
> The shell process hangs in the write(2) syscall.  The last dmesg
> entries post hang are:
> 
>      sd 1:0:0:0: [sda] Synchronizing SCSI cache
>      ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
>      ata2.00: ACPI cmd f5/00:00:00:00:00:a0(SECURITY FREEZE LOCK) filtered out
>      ata2.00: ACPI cmd ef/10:03:00:00:00:a0(SET FEATURES) filtered out
>      ata2.00: ACPI cmd f5/00:00:00:00:00:a0(SECURITY FREEZE LOCK) filtered out
>      ata2.00: ACPI cmd ef/10:03:00:00:00:a0(SET FEATURES) filtered out
>      ata2.00: configured for UDMA/133
>      ata2.00: retrying FLUSH 0xea Emask 0x0
> 
> On kernel versions prior to 6.5-rc1, dmesg would subsequently contain:
> 
>      sd 1:0:0:0: [sda] Stopping disk
>      ata2.00: disable device
> 
> Note that the hang only occurs when deleting a hard disk drive.  It
> does not occur when deleting an optical disk drive.
> 
> I bisected the regression to 8b566edbdbfb5cde31a322c57932694ff48125ed.
> 
> I know very little about the SCSI/ATA subsystems or the internals of
> ATA hotswapping/undocking.  I'd appreciate any help investigating the
> issue, or properly undocking.
> 
> Thanks,
> Kevin
> 
> [1]: https://www.thinkwiki.org/wiki/How_to_hotswap_Ultrabay_devices

Hi Kevin,

Thank you for having bisected this issue.

The "Synchronizing SCSI cache" message probably comes from sd_shutdown().
sd_shutdown() is called by sd_remove(). sd_remove() is called by
__scsi_remove_device(). __scsi_remove_device() is called by
sdev_store_delete(). It's not clear to me how commit 8b566edbdbfb
("scsi: core: Only kick the requeue list if necessary") can affect that
call path.

It would help if more information about the hang could be provided by
running the following command after having reproduced the hang and by
sharing the dmesg output triggered by this command:

     echo w > /proc/sysrq-trigger

Thank you,

Bart.
