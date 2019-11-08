Return-Path: <SRS0=OHhN=ZA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2125AFC6196
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 22:40:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2826214DA
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 22:39:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TEdy2UUy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730118AbfKHWj7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Nov 2019 17:39:59 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37340 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727798AbfKHWj7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Nov 2019 17:39:59 -0500
Received: by mail-wr1-f65.google.com with SMTP id t1so8759273wrv.4
        for <linux-scsi@vger.kernel.org>; Fri, 08 Nov 2019 14:39:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=269gIcjuCBCxaL9KbYb9ARonGWvtFaWcTN0cfE+Arag=;
        b=TEdy2UUyL6sjRX9EvFhCCi5tYCSyfIQAOuhrSsIis7IZkstLuFgciXvs56ky3+d+sy
         3cOdYE6L9Us1o1ARjHvEgpxF8njoQ41tzIPA513V8fdLrjnaUAATt0tJHSEz8mF8iBn3
         xXkF9+exn5q3th2Y4scJVigmg3dO20fvgdOTXpkRTl6kJBkDBe1LoLVF9IpER/ubc43p
         48RahfD1TnYsdCv2uH1aEUWHN1Udc53i5RRL/OabOQ/VuGfG1FEC48MIhEogcDC/ngso
         xa/XnvCEX6TQcUhW4MGk+7xTVn2eWAByhb524ibekjN1KpjxQbZARBOepnTBJ/98rG4W
         2osw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=269gIcjuCBCxaL9KbYb9ARonGWvtFaWcTN0cfE+Arag=;
        b=Jac+esewfkBHFo5mpysovXRTYgmHood1H7pCIVl1sIY+7uLTTSZvq0AovM9+tREroK
         e9jA52Ofn0qNiue70LllgfBwnZEuD5rJEMpva3OC6xKyKJxLUr3Lflgozt7Ux5/WbC3c
         ABcoKOSkcecZYNAqX14W6WlhrIUft9kk/3mGXC2qzyMmVajtd6W2GW+dICPe/Abp+PjT
         1BahQ+6kys8M6GkIuG5X4M/mdtGHAC/o+tdMzgAfCOJ/nI+QH/1BqZTSRURxYtn3mN4z
         G1dwmk/Li0LJz63kDZpmt5CwUUu+ACis/7UTNlkdoOHQ+cC8bmH94owEPjNbPRikep5f
         yPpQ==
X-Gm-Message-State: APjAAAV9PSYq2TkFXYYm0WW/npBLQYKfsafzzaG2vRzfJXxiEjNuGual
        7hnLqix1bGgZEUyuwA0DQLMDfCA4
X-Google-Smtp-Source: APXvYqzSJZOpEHUg7mKVmCR1guz/yFW5ypkRSoANm/z00TkLRYSssJHfnJV6xi/L1KmZsYyvA+vS1A==
X-Received: by 2002:adf:a51c:: with SMTP id i28mr5819552wrb.147.1573252795948;
        Fri, 08 Nov 2019 14:39:55 -0800 (PST)
Received: from [10.230.29.90] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v184sm9660168wme.31.2019.11.08.14.39.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Nov 2019 14:39:55 -0800 (PST)
Subject: Re: [PATCH 2/3] lpfc: Fix a kernel warning triggered by
 lpfc_sli4_enable_intr()
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org
References: <20191107052158.25788-1-bvanassche@acm.org>
 <20191107052158.25788-4-bvanassche@acm.org>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <b5c7d0b4-06a7-926a-0bde-3589a4b4a41d@gmail.com>
Date:   Fri, 8 Nov 2019 14:39:53 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191107052158.25788-4-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/6/2019 9:21 PM, Bart Van Assche wrote:
> Fix the following lockdep warning:
> 
> ============================================
> WARNING: possible recursive locking detected
> 5.4.0-rc6-dbg+ #2 Not tainted
> --------------------------------------------
> systemd-udevd/130 is trying to acquire lock:
> ffffffff826b05d0 (cpu_hotplug_lock.rw_sem){++++}, at: irq_calc_affinity_vectors+0x63/0x90
> 
> but task is already holding lock:
> 
> ffffffff826b05d0 (cpu_hotplug_lock.rw_sem){++++}, at: lpfc_sli4_enable_intr+0x422/0xd50 [lpfc]
> 
> other info that might help us debug this:
> 
>   Possible unsafe locking scenario:
>         CPU0
>         ----
>    lock(cpu_hotplug_lock.rw_sem);
>    lock(cpu_hotplug_lock.rw_sem);
> 
> *** DEADLOCK ***
>   May be due to missing lock nesting notation
> 2 locks held by systemd-udevd/130:
>   #0: ffff8880d53fe210 (&dev->mutex){....}, at: __device_driver_lock+0x4a/0x70
>   #1: ffffffff826b05d0 (cpu_hotplug_lock.rw_sem){++++}, at: lpfc_sli4_enable_intr+0x422/0xd50 [lpfc]
> 
> stack backtrace:
> CPU: 1 PID: 130 Comm: systemd-udevd Not tainted 5.4.0-rc6-dbg+ #2
> Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> Call Trace:
>   dump_stack+0xa5/0xe6
>   __lock_acquire.cold+0xf7/0x23a
>   lock_acquire+0x106/0x240
>   cpus_read_lock+0x41/0xe0
>   irq_calc_affinity_vectors+0x63/0x90
>   __pci_enable_msix_range+0x10a/0x950
>   pci_alloc_irq_vectors_affinity+0x144/0x210
>   lpfc_sli4_enable_intr+0x4b2/0xd50 [lpfc]
>   lpfc_pci_probe_one+0x1411/0x22b0 [lpfc]
>   local_pci_probe+0x7c/0xc0
>   pci_device_probe+0x25d/0x390
>   really_probe+0x170/0x510
>   driver_probe_device+0x127/0x190
>   device_driver_attach+0x98/0xa0
>   __driver_attach+0xb6/0x1a0
>   bus_for_each_dev+0x100/0x150
>   driver_attach+0x31/0x40
>   bus_add_driver+0x246/0x300
>   driver_register+0xe0/0x170
>   __pci_register_driver+0xde/0xf0
>   lpfc_init+0x134/0x1000 [lpfc]
>   do_one_initcall+0xda/0x47e
>   do_init_module+0x10a/0x3b0
>   load_module+0x4318/0x47c0
>   __do_sys_finit_module+0x134/0x1d0
>   __x64_sys_finit_module+0x47/0x50
>   do_syscall_64+0x6f/0x2e0
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> Fixes: dcaa21367938 ("scsi: lpfc: Change default IRQ model on AMD architectures")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Looks good. Thank You Bart.

Reviewed-by: James Smart <jsmart2021@gmail.com>

-- jsmart
