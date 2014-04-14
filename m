From: "Darius D." <darius.ski@gmail.com>
Subject: Re: HPSA related kernel panic on boot in 3.15 rc1 on Proliant with P420i
Date: Mon, 14 Apr 2014 16:29:18 +0300
Message-ID: <CAKt3ReJgBJ7fYkF94X-sRx9k1gcQ4WGcdPe3LxmzQFXEMLwbaA@mail.gmail.com>
References: <20140414130331.GA21686@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:53392 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbaDNN3S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Apr 2014 09:29:18 -0400
Received: by mail-pd0-f169.google.com with SMTP id fp1so8133087pdb.28
        for <linux-scsi@vger.kernel.org>; Mon, 14 Apr 2014 06:29:18 -0700 (PDT)
In-Reply-To: <20140414130331.GA21686@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

Hi,

i've found that patch, but somehow relevant thread was showing only on
http://www.spinics.net/lists/linux-scsi/msg73770.html but not on
marc.info

Anyway, after applying patch, my system passes HPSA initialization,
...but goes boom with unknown FS on block 0,0 error, but it is
probably not related, as somehow i see initrd generated, even if
config was copied from 3.14 where there was non.

http://tinypic.com/r/311qvc3/8

Looking into this problem, but probably not HPSA related, sorry for
repeat bug report.

Thanks for help,

Darius.


On Mon, Apr 14, 2014 at 4:03 PM,  <scameron@beardog.cce.hp.com> wrote:
> On Mon, Apr 14, 2014 at 2:33 PM, Darius D. <darius.ski@gmail.com> wrote:
>> Hi,
>>
>> on P420i (2GB FBWC) with latest(5.22?) FW, and 2 SSD smart path
>> enabled RAID0 arrays (1 and 3 SSD), i get panic on initialization.
>> What is sad, i can't capture complete stack trace and it is deep in
>> kernel worker, but top items are:
>>
>> SA5_performant_intr_mask+0x30/0x30
>> spin_unlock_irqrestore
>> hpsa_unit_one
>> local_pci_probe
>> ... kthread worker stuff
>>
>>
>> RIP is calc_bucket_map+0x30/0x3a.
>>
>>
>> Anyone got idea what is going on? 3.14 was working fine with exact
>> config, so i suspect it could be HPSA smart path code related.
>
> Try the patch below, and see also: http://marc.info/?t=139701135500001&r=1&w=2
>
> -- steve
>
>
> From f6b44f25c451d32cca5cf2e9825e0636132e69cf Mon Sep 17 00:00:00 2001
> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> Date: Thu, 10 Apr 2014 16:44:59 -0500
> Subject: [PATCH] hpsa: fix uninitialized variable in hpsa_put_ctlr_into_performant_mode()
>
> Without this, you'll see a null pointer dereference in
> hpsa_enter_performant_mode().
>
> Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> ---
>  drivers/scsi/hpsa.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 8cf4a0c..ef4dfdd 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -7463,6 +7463,10 @@ static void hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h)
>         if (hpsa_simple_mode)
>                 return;
>
> +       trans_support = readl(&(h->cfgtable->TransportSupport));
> +       if (!(trans_support & PERFORMANT_MODE))
> +               return;
> +
>         /* Check for I/O accelerator mode support */
>         if (trans_support & CFGTBL_Trans_io_accel1) {
>                 transMethod |= CFGTBL_Trans_io_accel1 |
> --
> 1.7.1
>
