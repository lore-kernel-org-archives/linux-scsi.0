From: Don Brace <brace77070@gmail.com>
Subject: Re: hpsa failure with 4.3.0-rc1
Date: Wed, 30 Sep 2015 09:32:50 -0500
Message-ID: <560BF292.6090209@pmcs.com>
References: <560B9202.9080703@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:34363 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbbI3Ocw (ORCPT
	<rfc822;Linux-scsi@vger.kernel.org>); Wed, 30 Sep 2015 10:32:52 -0400
Received: by obbda8 with SMTP id da8so32885052obb.1
        for <Linux-scsi@vger.kernel.org>; Wed, 30 Sep 2015 07:32:51 -0700 (PDT)
In-Reply-To: <560B9202.9080703@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>
Cc: Joerg Roedel <jroedel@suse.de>, Borislav Petkov <bp@suse.de>

I reported this a little while ago:
http://marc.info/?l=linux-kernel&m=144284810906949&w=2

It did clear up between rc1 and rc3.

Not sure what changes were applied in-between.


On 09/30/2015 02:40 AM, Hannes Reinecke wrote:
> Hi all,
>
> trying to boot 4.3.0-rc1 on a system with hpsa results in a swiotlb
> failure:
>
> hpsa 0000:22:00.0: Logical aborts not supported
> hpsa 0000:22:00.0: HP SSD Smart Path aborts not supported
> hpsa 0000:22:00.0: swiotlb buffer is full (sz: 786432 bytes)
> swiotlb: coherent allocation failed for device 0000:22:00.0 size=
> 786432
> CPU: 43 PID: 566 Comm: systemd-udevd Not tainted 4.3.0-rc1-default+ #358
> Hardware name: HP ProLiant BL660c Gen8, BIOS I32 08/20/2012
>   ffff88181c314098 ffff8810194cba40 ffffffff8138fad2 00000000000c0
>   ffff8810194cba80 ffffffff813ba3d9 ffff881000000008 0000000000000
> 220
>   ffff88181c314098 00000000000c0000 ffff8810184101e8 ffff881018410
> 000
> Call Trace:
>   [<ffffffff8138fad2>] dump_stack+0x4b/0x69
>   [<ffffffff813ba3d9>] swiotlb_alloc_coherent+0x149/0x160
>   [<ffffffff8104b7ae>] x86_swiotlb_alloc_coherent+0x3e/0x50
>   [<ffffffffa030ef45>] hpsa_init_one+0x915/0x1c90 [hpsa]
>   [<ffffffff810d694c>] ? rcu_read_lock_sched_held+0x8c/0xa0
>   [<ffffffff813d8550>] local_pci_probe+0x40/0xa0
>   [<ffffffff813d951b>] ? pci_match_device+0xdb/0x100
>
> 4.2.0-rc3 worked fine here.
> Needless to say, enabling IOMMU makes the problem go away :-)
>
> Cheers,
>
> Hannes

