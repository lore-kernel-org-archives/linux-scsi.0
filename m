From: "Or Gerlitz" <or.gerlitz@gmail.com>
Subject: Re: [BUG 2.6.17-git] kmem_cache_create: duplicate cache scsi_cmd_cache
Date: Fri, 12 May 2006 06:53:27 +0200
Message-ID: <15ddcffd0605112153q57f139a1k7068e204a3eeaf1f@mail.gmail.com>
References: <20060511151456.GD3755@harddisk-recovery.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nz-out-0102.google.com ([64.233.162.204]:40013 "EHLO
	nz-out-0102.google.com") by vger.kernel.org with ESMTP
	id S1750895AbWELEx2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 May 2006 00:53:28 -0400
Received: by nz-out-0102.google.com with SMTP id 13so384684nzn
        for <linux-scsi@vger.kernel.org>; Thu, 11 May 2006 21:53:27 -0700 (PDT)
In-Reply-To: <20060511151456.GD3755@harddisk-recovery.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Erik Mouw <erik@harddisk-recovery.com>
Cc: linux-scsi@vger.kernel.org

On 5/11/06, Erik Mouw <erik@harddisk-recovery.com> wrote:
> Hi,
>
> While playing with libata in 2.6.17-git from today, I got this bug:
>
> SCSI subsystem initialized
> libata version 1.20 loaded.
> sata_promise 0000:02:05.0: version 1.04
> kmem_cache_create: duplicate cache scsi_cmd_cache
>  <c0159591> kmem_cache_create+0x331/0x390
>  <e0924371> scsi_setup_command_freelist+0x71/0xf0 [scsi_mod]
>  <e092588e> scsi_host_alloc+0x17e/0x270 [scsi_mod]
>  <e08fd061> ata_host_add+0x41/0xc0 [libata]
>  <c0148c9f> __kzalloc+0x1f/0x50
>  <e08fd190> ata_device_add+0xb0/0x240 [libata]
>  <e0839baf> pdc_ata_init_one+0x27f/0x330 [sata_promise]
>  <c01dd1a9> pci_call_probe+0x19/0x20
>  <c01dd20e> __pci_device_probe+0x5e/0x70
>  <c01dd24f> pci_device_probe+0x2f/0x50
>  <c0220977> driver_probe_device+0xb7/0xe0
>  <c02b338a> klist_dec_and_del+0x1a/0x20
>  <c0220a30> __driver_attach+0x0/0x90
>  <c0220aa1>__driver_attach+0x71/0x90
>  <c021fd49> bus_for_each_dev+0x69/0x80
>  <c0220ae6> driver_attach+0x26/0x30
>  <c0220a30> __driver_attach+0x0/0x90
>  <c02202a3> bus_add_driver+0x83/0xc0
>  <c01dd4ed> __pci_register_driver+0x4d/0x70
>  <e0880017> pdc_ata_init+0x17/0x1b [sata_promise]
>  <c013a1a0> sys_init_module+0x120/0x1b0
>  <c0102f27> syscall_call+0x7/0xb
>
> How to recreate:

Hi,

I was pointing on 2.6.17 kmem_cache related  issues while back to LKML
and it turns out that you can reproduce them easily with standalone
trivial module, see
http://openib.org/pipermail/openib-general/2006-April/020582.html

So far no one picked the issue anb i was adviced to use bisection...

Or.
