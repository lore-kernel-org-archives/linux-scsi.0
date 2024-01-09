Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEAF43DB8F
	for <linux-scsi@vger.kernel.org>; Tue,  9 Jan 2024 22:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-36091f4d8easo9820655ab.2
        for <linux-scsi@vger.kernel.org>; Tue, 09 Jan 2024 14:47:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704840419; x=1705445219;
        h=content-transfer-encoding:in-reply-to:cc:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9BupsUTlR2wLBScCi1v3R7g/2RvnOLSXn5gnLLglLuk=;
        b=j1Arecz6wDp4A1yjS8pcps6qQ8bbdj6EeJpwWBvxry2rXHtmr9c6AWNBdoERNNxitI
         MrVb8KEYu3nHtQkhYjGFBoJa/36x2w6KglWIi6a6EoxsAkSORGNdp6yuntGef+JuYt4c
         SczbMQHC11eNgmiwfyNZ/DS5AZt7aFPmPtPr2UNcu467A9SJEsbItXieOyobJzq8K6Ly
         VKrBTfwEPRtmxtc2QRpvw7WwPm4aJwYw+kx//JSp47BnVwIdKlzVSP7MKQb2UeiVqgCi
         uX+yizVDjl8irHQCvg6PhlFXX6NRak/A+zOVi2gSaJ8ovvwnZWXH433XWItbywAxkMrJ
         t5Xw==
X-Gm-Message-State: AOJu0YzWgCopNzSAj/FrKO1kNogMMb5cy/CmqyhqxO8qQ5YL0auhS4Va
	GqPi2+aKAPyeqftrrNT3SkQ=
X-Google-Smtp-Source: AGHT+IFtS8HpEcekbOEbh29uPZhdaos9eYKZYKt7OMAxV7pQIYqbzwGWlT1nf4IilOYDwzH3C45DBA==
X-Received: by 2002:a05:6e02:1a46:b0:35f:ef06:637 with SMTP id u6-20020a056e021a4600b0035fef060637mr188365ilv.36.1704840419557;
        Tue, 09 Jan 2024 14:46:59 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:b76f:b657:4602:d182? ([2620:0:1000:8411:b76f:b657:4602:d182])
        by smtp.gmail.com with ESMTPSA id r11-20020a63e50b000000b0059d6f5196fasm2163206pgh.78.2024.01.09.14.46.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jan 2024 14:46:59 -0800 (PST)
Message-ID: <d585753a-b5f3-410f-a949-8b52252307ab@acm.org>
Date: Tue, 9 Jan 2024 14:46:58 -0800
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
 <8bbbd233-69c6-4f20-904c-332bb838cc42@acm.org>
 <ZZ2-hMYVJlF4ayqk@kevinlocke.name>
From: Bart Van Assche <bvanassche@acm.org>
Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
In-Reply-To: <ZZ2-hMYVJlF4ayqk@kevinlocke.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/9/24 13:45, Kevin Locke wrote:
> On Tue, 2024-01-09 at 13:39 -0800, Bart Van Assche wrote:
>> (cd /sys/class/scsi_host && grep -aH . */state)
>> (cd /sys/class/scsi_device && grep -aH . */device/{device_{blocked,busy},state})
> 
> Sure thing.  Running the above commands produced the following output:
> 
> host0/state:running
> host1/state:running
> host2/state:running
> host3/state:running
> host4/state:running
> host5/state:running
> 0:0:0:0/device/device_blocked:0
> 0:0:0:0/device/device_busy:1
> 0:0:0:0/device/state:running

So the SCSI host state (host1) is fine but the information about the SCSI
devices associated with host1 is missing, most likely because sysfs
information of SCSI devices is removed before a SYNCHRONIZE CACHE command
is submitted. The device_del(dev) call in __scsi_remove_device() happens
after scsi_device_set_state(sdev, SDEV_CANCEL) so the SCSI device should
be in the SDEV_CANCEL state. scsi_device_state_check() should translate
SDEV_CANCEL into BLK_STS_OFFLINE.

There are several tests in the blktests suite that trigger SCSI device
deletion, e.g. block/001. All blktests tests pass on my test setup.
Additionally, I haven't seen any blktests failure reports recently that
are related to device deletion. If I try to delete an ATA device in a VM,
that works fine (kernel v6.7):

# dmesg -c >/dev/null
# echo 1 > /sys/class/scsi_device/3:0:0:0/device/delete
# dmesg -c
[  215.533228] sd 3:0:0:0: [sdb] Synchronizing SCSI cache
[  215.543932] ata3.00: Entering standby power mode

Running rescan-scsi-bus.sh -a brings this device back.

I'm not sure what I'm missing but I think that it's something ATA-specific.
Since I'm not an ATA expert, I hope that an ATA expert can help. There are
at least two ATA experts on the Cc-list of this email.

Thanks,

Bart.
