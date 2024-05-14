Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F47344C6E
	for <linux-scsi@vger.kernel.org>; Tue, 14 May 2024 12:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715690502; cv=none; b=Y1lRJypZsPpcMYgssxhsx0n9fsLAv7oj0XSJi/qiOGK2lGzZuJ9Z/g34jMc/Yh7OtDeQpUVL76PoyFkmYDHc9YSvrK0OnZmKpVuHEfUVy4tIFCEp7E1gPpVa4u8WcoDrtHHQXTox5zykPHtjF3Ht40cN/WJgsVpG9/W+Em4B/SA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715690502; c=relaxed/simple;
	bh=Vk1sJm+IFt3Vzx6bi2+gU/4QXC6O7IucMEWcSDsN/rk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=WXLpJrLr4oj0VN90nwmXHihhcUYgRnr9cJKp40a6ZgCzsCoRTbjEwsmPmAfW2aATrptHJijImBe6UTJ3qKBd6/iW/RlKEMP9Gz4NPLgXpIvc4wkTGTH9eSWVyX7wu2n6h/UIG+8gux2R0F9svSblz97lnoiAYYR9dZ3pgbcVvUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a59ad12efe3so1434866b.3
        for <linux-scsi@vger.kernel.org>; Tue, 14 May 2024 05:41:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715690499; x=1716295299;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i1rmCqK89cLnVjjDfY6cyRwUdTlSpYy4cgj6v1ERPd4=;
        b=j0BxdVxq9BIv5pTu99x5/uhG5MG/ReuHZsbQR0vYauTJI5onowaHw/LnNTN+l29jTs
         vzjFFGY0l+u+biSd2QlQsdAV/gSPxqFT7RoegLQ7dCZIFG+f0lhPqE3aBVrCccx2lWq5
         G1w53PZCrgG3fv/ZCRvGlJnIYpTSb5ZCJL7v55cAfqAVzKrwgc6s4c7o7aLWCXs2vgVe
         xgCgwbpIgkLwtKZVVg+yoO+MUlNf8nERtuoH0vzlljdnaLeSB6N7po4hvyMW9Yu+zZxD
         eX7fR+SJ0mZonftAb3WH0Ah2vxj6RZ93laICk5vG+zc6sDJc1D0Q0Ii9xxfTfpKMjxq4
         Vp7A==
X-Forwarded-Encrypted: i=1; AJvYcCXlfTbUUDYcGxdRBF9+0AmJtAPMD5rMu6kkSjkd9UWWntcl+Hbmh3hLybZCpDP/Z7s1a+lHm/g2wD3B2/l8V4nmLSPnF3NvsmRxTQ==
X-Gm-Message-State: AOJu0YxnFsL39AszlQDoqwdVl7DrNSflIcF7cEL/SbwWyHjr/9M2G5uA
	pUYACpDQaTCYdUKlCJ5J1NTrpAQhX1ZSXzpp7f/wHcpcO8p9pXqDKYtchMxb
X-Google-Smtp-Source: AGHT+IENruH0Re6MBONcOiWPbxwZj9gBeOyQgQB5UYsv0/8IMGLVigbIOnFj9FuAUH/i8svYhm5zdw==
X-Received: by 2002:a50:8e59:0:b0:56e:10d3:85e3 with SMTP id 4fb4d7f45d1cf-5734d5c0f52mr10585521a12.13.1715690498617;
        Tue, 14 May 2024 05:41:38 -0700 (PDT)
Received: from gmail.com (fwdproxy-lla-005.fbsv.net. [2a03:2880:30ff:5::face:b00c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a5a17b017b1sm715776266b.181.2024.05.14.05.41.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 May 2024 05:41:38 -0700 (PDT)
Date: Tue, 14 May 2024 05:41:36 -0700
From: Breno Leitao <leitao@debian.org>
To: sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
	suganath-prabu.subramani@broadcom.com
Cc: MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: mpt3sas: BUG: KASAN: slab-out-of-bounds in _scsih_add_device
Message-ID: <ZkNcALr3W3KGYYJG@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

I am running 6.9 kernel in one of my machines, and it shows the
following KASAN issue. I've tested in linux-next also, and the problem
is there also. In fact, the snippet below is from linux-next
(a17ef9e6c2c1cf0fc6cd6ca6a9ce525c67d1da7f)

Is this a known problem?

	[  416.135509] BUG: KASAN: slab-out-of-bounds in _scsih_add_device.constprop.0 (./arch/x86/include/asm/bitops.h:60 ./include/asm-generic/bitops/instrumented-atomic.h:29 drivers/scsi/mpt3sas/mpt3sas_scsih.c:7331) mpt3sas

	[  416.203247] Write of size 8 at addr ffff8881d26e3c60 by task kworker/u1536:2/2965
	[  416.203259]
	[  416.203269] Hardware name: ...
	[  416.203276] Workqueue: fw_event_mpt3sas0 _firmware_event_work [mpt3sas]
	[  416.243752]
	[  416.243758] Call Trace:
	[  416.243761]  <TASK>
	[  416.243767] dump_stack_lvl (lib/dump_stack.c:117) 
	[  416.274876] print_report (mm/kasan/report.c:378 mm/kasan/report.c:488) 
	[  416.274891] ? __virt_addr_valid (./arch/x86/include/asm/preempt.h:103 ./include/linux/rcupdate.h:896 ./include/linux/mmzone.h:2029 arch/x86/mm/physaddr.c:65) 
	[  416.274901] ? _scsih_add_device.constprop.0 (./arch/x86/include/asm/bitops.h:60 ./include/asm-generic/bitops/instrumented-atomic.h:29 drivers/scsi/mpt3sas/mpt3sas_scsih.c:7331) mpt3sas
	[  416.309307] kasan_report (mm/kasan/report.c:603) 
	[  416.309321] ? _scsih_add_device.constprop.0 (./arch/x86/include/asm/bitops.h:60 ./include/asm-generic/bitops/instrumented-atomic.h:29 drivers/scsi/mpt3sas/mpt3sas_scsih.c:7331) mpt3sas
	[  416.336976] kasan_check_range (mm/kasan/generic.c:183 mm/kasan/generic.c:189) 
	[  416.336990] _scsih_add_device.constprop.0 (./arch/x86/include/asm/bitops.h:60 ./include/asm-generic/bitops/instrumented-atomic.h:29 drivers/scsi/mpt3sas/mpt3sas_scsih.c:7331) mpt3sas
	[  416.376791] ? mpt3sas_transport_update_links (drivers/scsi/mpt3sas/mpt3sas_transport.c:1187) mpt3sas
	[  416.376845] ? _scsih_check_device.constprop.0 (drivers/scsi/mpt3sas/mpt3sas_scsih.c:7299) mpt3sas
	[  416.376884] ? mark_held_locks (kernel/locking/lockdep.c:4274) 
	[  416.376897] ? mpt3sas_transport_update_links (drivers/scsi/mpt3sas/mpt3sas_transport.c:1199) mpt3sas
	[  416.402989] ? _raw_spin_unlock_irqrestore (./include/linux/spinlock_api_smp.h:151 kernel/locking/spinlock.c:194) 
	[  416.403002] _firmware_event_work (drivers/scsi/mpt3sas/mpt3sas_scsih.c:7688 drivers/scsi/mpt3sas/mpt3sas_scsih.c:10762 drivers/scsi/mpt3sas/mpt3sas_scsih.c:10825) mpt3sas
	[  416.413092] ? mpt3sas_scsih_issue_tm (drivers/scsi/mpt3sas/mpt3sas_scsih.c:10821) mpt3sas
	[  416.445569] ? lockdep_hardirqs_on_prepare (kernel/locking/lockdep.c:4993) 
	[  416.445588] ? lock_downgrade (kernel/locking/lockdep.c:5762) 
	[  416.445594] ? find_held_lock (kernel/locking/lockdep.c:5244) 
	[  416.445604] ? lock_sync (kernel/locking/lockdep.c:5722) 
	[  416.445609] ? lock_downgrade (kernel/locking/lockdep.c:5762) 
	[  416.501157] process_one_work (kernel/workqueue.c:3272) 
	[  416.501177] ? lock_sync (kernel/locking/lockdep.c:5722) 
	[  416.523022] ? pwq_dec_nr_in_flight (kernel/workqueue.c:3169) 
	[  416.523041] ? assign_work (kernel/workqueue.c:1209) 
	[  416.523047] worker_thread (kernel/workqueue.c:3342 kernel/workqueue.c:3429) 
	[  416.523055] ? rescuer_thread (kernel/workqueue.c:3375) 
	[  416.556072] kthread (kernel/kthread.c:388) 
	[  416.556086] ? _raw_spin_unlock_irq (./arch/x86/include/asm/irqflags.h:42 ./arch/x86/include/asm/irqflags.h:77 ./include/linux/spinlock_api_smp.h:159 kernel/locking/spinlock.c:202) 
	[  416.556095] ? kthread_complete_and_exit (kernel/kthread.c:341) 
	[  416.587199] ret_from_fork (arch/x86/kernel/process.c:153) 
	[  416.587213] ? kthread_complete_and_exit (kernel/kthread.c:341) 
	[  416.587218] ret_from_fork_asm (arch/x86/entry/entry_64.S:257) 
	[  416.587230]  </TASK>
	[  416.587233]
	[  416.587234] Allocated by task 2949:
	[  416.587238] kasan_save_stack (mm/kasan/common.c:48) 
	[  416.587247] kasan_save_track (./arch/x86/include/asm/current.h:49 mm/kasan/common.c:60 mm/kasan/common.c:69) 
	[  416.587250] __kasan_kmalloc (mm/kasan/common.c:391) 
	[  416.587253] __kmalloc (mm/slub.c:3967 mm/slub.c:3979) 
	[  416.615271] mpt3sas_base_attach (drivers/scsi/mpt3sas/mpt3sas_base.c:8532) mpt3sas
	[  416.637921] _scsih_probe (drivers/scsi/mpt3sas/mpt3sas_scsih.c:12330) mpt3sas
	[  416.662117] local_pci_probe (drivers/pci/pci-driver.c:326) 
	[  416.662128] work_for_cpu_fn (kernel/workqueue.c:6558) 
	[  416.662134] process_one_work (kernel/workqueue.c:3272) 
	[  416.692274] worker_thread (kernel/workqueue.c:3342 kernel/workqueue.c:3429) 
	[  416.692287] kthread (kernel/kthread.c:388) 
	[  416.692291] ret_from_fork (arch/x86/kernel/process.c:153) 
	[  416.692297] ret_from_fork_asm (arch/x86/entry/entry_64.S:257) 
	[  416.692302]
	[  416.692306] The buggy address belongs to the object at ffff8881d26e3c60
	[  416.692306]  which belongs to the cache kmalloc-8 of size 8
	[  416.692310] The buggy address is located 0 bytes inside of
	[  416.692310]  allocated 1-byte region [ffff8881d26e3c60, ffff8881d26e3c61)
	[  416.692314]
	[  416.692316] The buggy address belongs to the physical page:
	[  416.692318] page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1d26e3
	[  416.692324] flags: 0x5ffff0000000800(slab|node=0|zone=2|lastcpupid=0x1ffff)
	[  416.692330] page_type: 0xffffffff()
	[  416.692336] raw: 05ffff0000000800 ffff88810004c280 dead000000000122 0000000000000000
	[  416.692341] raw: 0000000000000000 0000000000800080 00000001ffffffff 0000000000000000
	[  416.717271] page dumped because: kasan: bad access detected
	[  416.717277]
	[  416.717279] Memory state around the buggy address:
	[  416.717282]  ffff8881d26e3b00: fa fc fc fc fa fc fc fc 06 fc fc fc 06 fc fc fc
	[  416.717285]  ffff8881d26e3b80: 06 fc fc fc 06 fc fc fc 06 fc fc fc fa fc fc fc
	[  416.717288] >ffff8881d26e3c00: fa fc fc fc 01 fc fc fc 01 fc fc fc 01 fc fc fc
	[  416.717289]                                                        ^
	[  416.717292]  ffff8881d26e3c80: 01 fc fc fc fa fc fc fc fa fc fc fc fa fc fc fc
	[  416.717294]  ffff8881d26e3d00: fa fc fc fc 06 fc fc fc 03 fc fc fc 05 fc fc fc
	[  416.717296] ==================================================================
	[  416.717404] Disabling lock debugging due to kernel taint



