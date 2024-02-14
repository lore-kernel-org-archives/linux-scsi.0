Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D66118E06
	for <linux-scsi@vger.kernel.org>; Wed, 14 Feb 2024 11:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707908521; cv=none; b=nP1edUpgkmskx2bdFME/7vnIF+LQKcIADPcbnnWMSXvmP+Z3woczNM0Oq6MkYcJdtvmCoFCOwveuGhjptv7FzCxGDQuiHn66IoO0ypW5EjF8MpPpUv2/1kPGcHahcrcsIwgUCLSPsF5dc6FqWDo7zSLFN/AA4OFLU2keDM+j+yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707908521; c=relaxed/simple;
	bh=1gjYGCuhJesJVchATCEpRGkap4bUYT4wxu6IGwz0inc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HmwW8qY2n/z3iuP7OSFo0umO+TriqGt6ZddbLk0LuqUcsTU5vP+Rm+bHnu0KqVpqLeAUaZRzcFk+kJ35UUwmtt5xXTwtOdlljwehLDkWeUKmApj5r5Q/4PaGNZ/qlyPVxM9PhVKPdr0ndf21K1dzJ9kB1uUUoaAhjHU+wKcpX2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bOZMZRit; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bOZMZRit"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707908518;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ej1/wNFVwzSicN4lDJDfw+4pBNgxNvs7M0rU1TbrOPQ=;
	b=bOZMZRitH8Q3/brkwi80AFxqYXcstumoZ3xEXrJcxlQY/6jppHbPcNAfPVcwS+EiPF6QPl
	bflLZUMbZJjOEmJYjloKKys76hpAw9i1hiA152nRFB0YmVoFs4I01s8u6qx7+tIk15b6Uc
	CCwR0qgX6tADTack9aMLGGnfEB17ong=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-350-b032-mnfO72kV-SrpN8tzw-1; Wed, 14 Feb 2024 06:01:57 -0500
X-MC-Unique: b032-mnfO72kV-SrpN8tzw-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2d0cb64437dso44511341fa.2
        for <linux-scsi@vger.kernel.org>; Wed, 14 Feb 2024 03:01:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707908516; x=1708513316;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ej1/wNFVwzSicN4lDJDfw+4pBNgxNvs7M0rU1TbrOPQ=;
        b=K7UdHBeXc9SO0FdLpp/QrPUgbvTNHSiCtKL9fQ/Ct/1gl6NrB/sSFVjZ+oD4l0Xm2p
         oI/OIYDCd5DkTK1cfHf67NRiXqPZdVfV59jtUkqOhBRa6Ep3DkHEWl37TOLfyt2N5NB7
         AsuD0YM3DoqsDVBzn+l3KxWG6MseKgwPxxxfbjoNCk6j48kthQwDu3PbScBxKceJ5lX9
         +ptF9BMtczZyGscVWdPh9j9K8TH8B9fISpRJtEFN7pox+KWkiyfrKW+Mv5ljbWAuZ8MG
         1ytgH0Xp88J6sgSg3jFO97TRPhYNjAV0mVtQr4PI0euX554sJYCubSewuhkh1zyuB+xJ
         ImZg==
X-Gm-Message-State: AOJu0Yxfsz5D7fq08kQsntlZnMC/XEGRK1Pmx4ve7ndzaJpPUrm5LMb/
	zpVoGVcsde8EUHyEO+L2qcUJ7ycOVnakEen7LPzB7RPszlSzzEFCvSshx4M/dL1nIwPMpJ+WIhf
	TjnPSql4ijXogKeLyZMR4J5jBFve5O9aCwgb8+bIKaUmSORpGcIJZYzIqiw0=
X-Received: by 2002:a05:6512:243:b0:511:5352:649f with SMTP id b3-20020a056512024300b005115352649fmr1424301lfo.19.1707908515810;
        Wed, 14 Feb 2024 03:01:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG2uAG3XBeib55xP/ZuOMd6IFSo0N4WTaycgU8jIVAsDJgZZGCE2RuTbHKu3J3b6lQnWzjuOA==
X-Received: by 2002:a05:6512:243:b0:511:5352:649f with SMTP id b3-20020a056512024300b005115352649fmr1424282lfo.19.1707908515428;
        Wed, 14 Feb 2024 03:01:55 -0800 (PST)
Received: from [192.168.0.106] (ip4-83-240-118-160.cust.nbox.cz. [83.240.118.160])
        by smtp.gmail.com with ESMTPSA id z11-20020a7bc7cb000000b00411b7c91470sm1579845wmk.12.2024.02.14.03.01.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Feb 2024 03:01:54 -0800 (PST)
Message-ID: <ab1ac37c-0dd6-4c7b-9c09-832c2bbc6a36@redhat.com>
Date: Wed, 14 Feb 2024 12:01:53 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smartpqi: fix disable_managed_interrupts
To: Don Brace <don.brace@microchip.com>, Kevin.Barnett@microchip.com,
 scott.teel@microchip.com, Justin.Lindley@microchip.com,
 scott.benesh@microchip.com, gerry.morong@microchip.com,
 mahesh.rajashekhara@microchip.com, mike.mcgowen@microchip.com,
 murthy.bhat@microchip.com, kumar.meiyappan@microchip.com,
 jeremy.reeves@microchip.com, david.strahan@microchip.com, hch@infradead.org,
 jejb@linux.vnet.ibm.com, joseph.szczypek@hpe.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org
References: <20240213162200.1875970-1-don.brace@microchip.com>
 <20240213162200.1875970-2-don.brace@microchip.com>
Content-Language: en-US
From: Tomas Henzl <thenzl@redhat.com>
In-Reply-To: <20240213162200.1875970-2-don.brace@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/13/24 17:22, Don Brace wrote:
> Correct blk-mq registration issue with module parameter
> disable_managed_interrupts enabled.
> 
> When we turn off the default PCI_IRQ_AFFINITY flag, the driver needs to
> register with blk-mq using blk_mq_map_queues(). The driver is currently
> calling blk_mq_pci_map_queues() which results in a stack trace and
> possibly undefined behavior.
> 
> Stack Trace:
> [    7.860089] scsi host2: smartpqi
> [    7.871934] WARNING: CPU: 0 PID: 238 at block/blk-mq-pci.c:52 blk_mq_pci_map_queues+0xca/0xd0
> [    7.889231] Modules linked in: sd_mod t10_pi sg uas smartpqi(+) crc32c_intel scsi_transport_sas usb_storage dm_mirror dm_region_hash dm_log dm_mod ipmi_devintf ipmi_msghandler fuse
> [    7.924755] CPU: 0 PID: 238 Comm: kworker/0:3 Not tainted 4.18.0-372.88.1.el8_6_smartpqi_test.x86_64 #1
> [    7.944336] Hardware name: HPE ProLiant DL380 Gen10/ProLiant DL380 Gen10, BIOS U30 03/08/2022
> [    7.963026] Workqueue: events work_for_cpu_fn
> [    7.978275] RIP: 0010:blk_mq_pci_map_queues+0xca/0xd0
> [    7.978278] Code: 48 89 de 89 c7 e8 f6 0f 4f 00 3b 05 c4 b7 8e 01 72 e1 5b 31 c0 5d 41 5c 41 5d 41 5e 41 5f e9 7d df 73 00 31 c0 e9 76 df 73 00 <0f> 0b eb bc 90 90 0f 1f 44 00 00 41 57 49 89 ff 41 56 41 55 41 54
> [    7.978280] RSP: 0018:ffffa95fc3707d50 EFLAGS: 00010216
> [    7.978283] RAX: 00000000ffffffff RBX: 0000000000000000 RCX: 0000000000000010
> [    7.978284] RDX: 0000000000000004 RSI: 0000000000000000 RDI: ffff9190c32d4310
> [    7.978286] RBP: 0000000000000000 R08: ffffa95fc3707d38 R09: ffff91929b81ac00
> [    7.978287] R10: 0000000000000001 R11: ffffa95fc3707ac0 R12: 0000000000000000
> [    7.978288] R13: ffff9190c32d4000 R14: 00000000ffffffff R15: ffff9190c4c950a8
> [    7.978290] FS:  0000000000000000(0000) GS:ffff9193efc00000(0000) knlGS:0000000000000000
> [    7.978292] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    8.172814] CR2: 000055d11166c000 CR3: 00000002dae10002 CR4: 00000000007706f0
> [    8.172816] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [    8.172817] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [    8.172818] PKRU: 55555554
> [    8.172819] Call Trace:
> [    8.172823]  blk_mq_alloc_tag_set+0x12e/0x310
> [    8.264339]  scsi_add_host_with_dma.cold.9+0x30/0x245
> [    8.279302]  pqi_ctrl_init+0xacf/0xc8e [smartpqi]
> [    8.294085]  ? pqi_pci_probe+0x480/0x4c8 [smartpqi]
> [    8.309015]  pqi_pci_probe+0x480/0x4c8 [smartpqi]
> [    8.323286]  local_pci_probe+0x42/0x80
> [    8.337855]  work_for_cpu_fn+0x16/0x20
> [    8.351193]  process_one_work+0x1a7/0x360
> [    8.364462]  ? create_worker+0x1a0/0x1a0
> [    8.379252]  worker_thread+0x1ce/0x390
> [    8.392623]  ? create_worker+0x1a0/0x1a0
> [    8.406295]  kthread+0x10a/0x120
> [    8.418428]  ? set_kthread_struct+0x50/0x50
> [    8.431532]  ret_from_fork+0x1f/0x40
> [    8.444137] ---[ end trace 1bf0173d39354506 ]---

This patch fixes the issue on my machine.

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

> 
> Fixes: ("cf15c3e734e8 scsi: smartpqi: Add module param to disable managed ints")
> 
> Tested-by: Yogesh Chandra Pandey <YogeshChandra.Pandey@microchip.com>
> Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
> Reviewed-by: Scott Teel <scott.teel@microchip.com>
> Reviewed-by: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>
> Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
> Signed-off-by: Don Brace <don.brace@microchip.com>
> ---
>  drivers/scsi/smartpqi/smartpqi_init.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
> index ceff1ec13f9e..385180c98be4 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -6533,8 +6533,11 @@ static void pqi_map_queues(struct Scsi_Host *shost)
>  {
>  	struct pqi_ctrl_info *ctrl_info = shost_to_hba(shost);
>  
> -	blk_mq_pci_map_queues(&shost->tag_set.map[HCTX_TYPE_DEFAULT],
> +	if (!ctrl_info->disable_managed_interrupts)
> +		return blk_mq_pci_map_queues(&shost->tag_set.map[HCTX_TYPE_DEFAULT],
>  			      ctrl_info->pci_dev, 0);
> +	else
> +		return blk_mq_map_queues(&shost->tag_set.map[HCTX_TYPE_DEFAULT]);
>  }
>  
>  static inline bool pqi_is_tape_changer_device(struct pqi_scsi_dev *device)

