Return-Path: <SRS0=tebG=45=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44273C1975A
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 15:07:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07D0020716
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 15:07:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="jY+CxiAl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbgCLPHW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Mar 2020 11:07:22 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:38456 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727133AbgCLPHW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Mar 2020 11:07:22 -0400
Received: by mail-io1-f67.google.com with SMTP id c25so5384814ioi.5
        for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2020 08:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HeDZ4xpsH4ojKjdPYAFKFs4XK1v01d56EDF8j+URbwo=;
        b=jY+CxiAle1JRHNXQn4k1tScC/ncCuBvrrKGC/Va6IKPBck9zsLzWhw6l7vll7k1mTT
         mOsYqTR2Yx+5LcjpAxbk8ixA1OOyLO8dgl7eF1ZM7e/rNpBkyZYRlAK2hiSvTLzXWJnA
         diskQ5bDvo0ApZI4VJmq0lKHEsn/Jr4/LhUDS7PaLtlVQMwUi1IBvGIGFLZb9UZu2b7T
         HwlCLpT+HpO5Qzgdtk7BhVjKqWFoOZ106PNv3X/69HqnuzQzVq/tc80m/r2eTi/VU4wT
         f0mnQ1VgoOdCWkMQNzBZAVzon9Rk2aqE6qmW7jV/LyTdxfun8LZZtHf1whQi36CVqCMZ
         qs9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HeDZ4xpsH4ojKjdPYAFKFs4XK1v01d56EDF8j+URbwo=;
        b=gK2g7olH6uGqhJqNTkG/WXzkRwpezLaVlQkhOEINDOHiQCzARFWMWJHPGmKZ3uBMlB
         dMSkePCAJ2YZ4v2aUu5dgSj0gHxQIa92IBQZWkUHaGeJW3k0ZtEwXpSN8fZMX2EGE+i/
         KDEshPM2x+0kY7MaFW2nX3rLw8LAHDSD23yvAAmE0JFxj+76r75pPBgLLHaaSa+IB6bb
         SmtGtBF3yAcJ04P0dr/6mSNFBOwJOwuWK/8OpPFzizfIN3tV5emhYDNkvKq0PhlVgOws
         kx7TbyNBnoUBKFvu5a3lgg7oOw0KroV9dwpUYayp6IB3A214S+nDTwfHzFZznaG+IKnJ
         /DkA==
X-Gm-Message-State: ANhLgQ0sPCH/TbDswbZwoYTf54Ks+c0fmpomTulgNw38/6SedDDFTbb9
        MQAXIxJ1gaPjhcvqt6zgwYBL9g==
X-Google-Smtp-Source: ADFU+vsXRIWqmC8cnz2kYKXojWZrQWFl/y2mDPLPWUsH+6cG1+ak18R22jCgen/thm94qeSCZH1+uQ==
X-Received: by 2002:a05:6638:bd1:: with SMTP id g17mr7992946jad.124.1584025633431;
        Thu, 12 Mar 2020 08:07:13 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id p14sm7346596ios.38.2020.03.12.08.07.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Mar 2020 08:07:12 -0700 (PDT)
Subject: Re: [PATCH] libata: Remove extra scsi_host_put() in
 ata_scsi_add_hosts()
To:     John Garry <john.garry@huawei.com>
Cc:     linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, takondra@cisco.com, tj@kernel.org
References: <1582889615-146214-1-git-send-email-john.garry@huawei.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <240d477b-f3f2-5461-fcd3-b7b239462a24@kernel.dk>
Date:   Thu, 12 Mar 2020 09:07:11 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <1582889615-146214-1-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/28/20 4:33 AM, John Garry wrote:
> If the call to scsi_add_host_with_dma() in ata_scsi_add_hosts() fails,
> then we may get use-after-free KASAN warns:
> 
> ==================================================================
> BUG: KASAN: use-after-free in kobject_put+0x24/0x180
> Read of size 1 at addr ffff0026b8c80364 by task swapper/0/1
> CPU: 1 PID: 1 Comm: swapper/0 Tainted: G        W         5.6.0-rc3-00004-g5a71b206ea82-dirty #1765
> Hardware name: Huawei TaiShan 200 (Model 2280)/BC82AMDD, BIOS 2280-V2 CS V3.B160.01 02/24/2020
> Call trace:
> dump_backtrace+0x0/0x298
> show_stack+0x14/0x20
> dump_stack+0x118/0x190
> print_address_description.isra.9+0x6c/0x3b8
> __kasan_report+0x134/0x23c
> kasan_report+0xc/0x18
> __asan_load1+0x5c/0x68
> kobject_put+0x24/0x180
> put_device+0x10/0x20
> scsi_host_put+0x10/0x18
> ata_devres_release+0x74/0xb0
> release_nodes+0x2d0/0x470
> devres_release_all+0x50/0x78
> really_probe+0x2d4/0x560
> driver_probe_device+0x7c/0x148
> device_driver_attach+0x94/0xa0
> __driver_attach+0xa8/0x110
> bus_for_each_dev+0xe8/0x158
> driver_attach+0x30/0x40
> bus_add_driver+0x220/0x2e0
> driver_register+0xbc/0x1d0
> __pci_register_driver+0xbc/0xd0
> ahci_pci_driver_init+0x20/0x28
> do_one_initcall+0xf0/0x608
> kernel_init_freeable+0x31c/0x384
> kernel_init+0x10/0x118
> ret_from_fork+0x10/0x18
> 
> Allocated by task 5:
> save_stack+0x28/0xc8
> __kasan_kmalloc.isra.8+0xbc/0xd8
> kasan_kmalloc+0xc/0x18
> __kmalloc+0x1a8/0x280
> scsi_host_alloc+0x44/0x678
> ata_scsi_add_hosts+0x74/0x268
> ata_host_register+0x228/0x488
> ahci_host_activate+0x1c4/0x2a8
> ahci_init_one+0xd18/0x1298
> local_pci_probe+0x74/0xf0
> work_for_cpu_fn+0x2c/0x48
> process_one_work+0x488/0xc08
> worker_thread+0x330/0x5d0
> kthread+0x1c8/0x1d0
> ret_from_fork+0x10/0x18
> 
> Freed by task 5:
> save_stack+0x28/0xc8
> __kasan_slab_free+0x118/0x180
> kasan_slab_free+0x10/0x18
> slab_free_freelist_hook+0xa4/0x1a0
> kfree+0xd4/0x3a0
> scsi_host_dev_release+0x100/0x148
> device_release+0x7c/0xe0
> kobject_put+0xb0/0x180
> put_device+0x10/0x20
> scsi_host_put+0x10/0x18
> ata_scsi_add_hosts+0x210/0x268
> ata_host_register+0x228/0x488
> ahci_host_activate+0x1c4/0x2a8
> ahci_init_one+0xd18/0x1298
> local_pci_probe+0x74/0xf0
> work_for_cpu_fn+0x2c/0x48
> process_one_work+0x488/0xc08
> worker_thread+0x330/0x5d0
> kthread+0x1c8/0x1d0
> ret_from_fork+0x10/0x18
> 
> There is also refcount issue, as well:
> WARNING: CPU: 1 PID: 1 at lib/refcount.c:28 refcount_warn_saturate+0xf8/0x170
> 
> The issue is that we make an erroneous extra call to scsi_host_put()
> for that host:
> 
> So in ahci_init_one()->ata_host_alloc_pinfo()->ata_host_alloc(), we setup
> a device release method - ata_devres_release() - which intends to release
> the SCSI hosts:
> 
> static void ata_devres_release(struct device *gendev, void *res)
> {
> 	...
> 	for (i = 0; i < host->n_ports; i++) {
> 		struct ata_port *ap = host->ports[i];
> 
> 		if (!ap)
> 			continue;
> 
> 		if (ap->scsi_host)
> 			scsi_host_put(ap->scsi_host);
> 
> 	}
> 	...
> }
> 
> However in the ata_scsi_add_hosts() error path, we also call
> scsi_host_put() for the SCSI hosts.
> 
> Fix by removing the the scsi_host_put() calls in ata_scsi_add_hosts() and
> leave this to ata_devres_release().

Applied for 5.7, thanks.

-- 
Jens Axboe

