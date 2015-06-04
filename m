From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: Re: [PATCH v3] fusion: remove dead MTRR code
Date: Thu, 4 Jun 2015 10:20:23 +0530
Message-ID: <CAK=zhgqU7+Dm1ZUhVpGF_QMPAPnnaSbdh18GLajDvJBAXrGCQg@mail.gmail.com>
References: <1429649166-18294-1-git-send-email-mcgrof@do-not-panic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:36720 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbbFDEuZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Jun 2015 00:50:25 -0400
Received: by wgbgq6 with SMTP id gq6so24205079wgb.3
        for <linux-scsi@vger.kernel.org>; Wed, 03 Jun 2015 21:50:23 -0700 (PDT)
In-Reply-To: <1429649166-18294-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, MPT-FusionLinux.pdl@avagotech.com, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, luto@amacapital.net, mst@redhat.com, "Luis R. Rodriguez" <mcgrof@suse.com>, Toshi Kani <toshi.kani@hp.com>, Christoph Hellwig <hch@infradead.org>, Suresh Siddha <sbsiddha@gmail.com>, Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>, Juergen Gross <jgross@suse.com>, Daniel Vetter <daniel.vetter@ffwll.ch>, Dave Airlie <airlied@redhat.com>, Antonino Daplas <adaplas@gmail.com>, Tomi Valkeinen <tomi.valkeinen@ti.com>, =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <syrjala@sci.fi>, Mel Gorman <mgorman@suse.de>, Vlastimil Babka <vbabka@suse.cz>, Borislav Petkov <bp@suse.de>, Davidlohr Bueso <dbueso@suse.de>

Hi Luis,

Sorry for delay in response. Actually I was looking for the history of
this section of code but I couldn't find it. Anyway this is dead code
and we are fine with removing this dead code.

James,

Please consider this patch as Acked-by: "Sreekanth Reddy"
<Sreekanth.reddy@avagotech.com>

Regards,
Sreekanth


On Wed, Apr 22, 2015 at 2:16 AM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> From: "Luis R. Rodriguez" <mcgrof@suse.com>
>
> If and when this gets enabled the driver could should split
> up IO memory space properly and that is quite a bit of work.
> Just remove the uncommented dead MTRR code then.
>
> There are a few motivations for this:
>
> a) Take advantage of PAT when available
>
> b) Help bury MTRR code away, MTRR is architecture specific and on
>    x86 its replaced by PAT
>
> c) Help with the goal of eventually using _PAGE_CACHE_UC over
>    _PAGE_CACHE_UC_MINUS on x86 on ioremap_nocache() (see commit
>    de33c442e titled "x86 PAT: fix performance drop for glx,
>    use UC minus for ioremap(), ioremap_nocache() and
>    pci_mmap_page_range()")
>
> Cc: Toshi Kani <toshi.kani@hp.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>
> Cc: Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>
> Cc: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
> Cc: Abhijit Mahajan <abhijit.mahajan@avagotech.com>
> Cc: linux-scsi@vger.kernel.org
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Suresh Siddha <sbsiddha@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Juergen Gross <jgross@suse.com>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Juergen Gross <jgross@suse.com>
> Cc: Dave Airlie <airlied@redhat.com>
> Cc: Antonino Daplas <adaplas@gmail.com>
> Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Cc: Ville Syrj=C3=A4l=C3=A4 <syrjala@sci.fi>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Davidlohr Bueso <dbueso@suse.de>
> Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
> Cc: MPT-FusionLinux.pdl@avagotech.com
> Cc: linux-scsi@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
> ---
>  drivers/message/fusion/mptbase.c | 24 ------------------------
>  drivers/message/fusion/mptbase.h |  1 -
>  2 files changed, 25 deletions(-)
>
> diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusio=
n/mptbase.c
> index 187f836..5dcc031 100644
> --- a/drivers/message/fusion/mptbase.c
> +++ b/drivers/message/fusion/mptbase.c
> @@ -59,10 +59,6 @@
>  #include <linux/delay.h>
>  #include <linux/interrupt.h>           /* needed for in_interrupt() =
proto */
>  #include <linux/dma-mapping.h>
> -#include <asm/io.h>
> -#ifdef CONFIG_MTRR
> -#include <asm/mtrr.h>
> -#endif
>  #include <linux/kthread.h>
>  #include <scsi/scsi_host.h>
>
> @@ -2820,13 +2816,6 @@ mpt_adapter_dispose(MPT_ADAPTER *ioc)
>         pci_disable_device(ioc->pcidev);
>         pci_release_selected_regions(ioc->pcidev, ioc->bars);
>
> -#if defined(CONFIG_MTRR) && 0
> -       if (ioc->mtrr_reg > 0) {
> -               mtrr_del(ioc->mtrr_reg, 0, 0);
> -               dprintk(ioc, printk(MYIOC_s_INFO_FMT "MTRR region de-=
registered\n", ioc->name));
> -       }
> -#endif
> -
>         /*  Zap the adapter lookup ptr!  */
>         list_del(&ioc->list);
>
> @@ -4512,19 +4501,6 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
>
>                 ioc->req_frames_low_dma =3D (u32) (alloc_dma & 0xFFFF=
=46FFF);
>
> -#if defined(CONFIG_MTRR) && 0
> -               /*
> -                *  Enable Write Combining MTRR for IOC's memory regi=
on.
> -                *  (at least as much as we can; "size and base must =
be
> -                *  multiples of 4 kiB"
> -                */
> -               ioc->mtrr_reg =3D mtrr_add(ioc->req_frames_dma,
> -                                        sz,
> -                                        MTRR_TYPE_WRCOMB, 1);
> -               dprintk(ioc, printk(MYIOC_s_DEBUG_FMT "MTRR region re=
gistered (base:size=3D%08x:%x)\n",
> -                               ioc->name, ioc->req_frames_dma, sz));
> -#endif
> -
>                 for (i =3D 0; i < ioc->req_depth; i++) {
>                         alloc_dma +=3D ioc->req_sz;
>                         mem +=3D ioc->req_sz;
> diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusio=
n/mptbase.h
> index 8f14090..813d463 100644
> --- a/drivers/message/fusion/mptbase.h
> +++ b/drivers/message/fusion/mptbase.h
> @@ -671,7 +671,6 @@ typedef struct _MPT_ADAPTER
>         u8                      *HostPageBuffer; /* SAS - host page b=
uffer support */
>         u32                     HostPageBuffer_sz;
>         dma_addr_t              HostPageBuffer_dma;
> -       int                      mtrr_reg;
>         struct pci_dev          *pcidev;        /* struct pci_dev poi=
nter */
>         int                     bars;           /* bitmask of BAR's t=
hat must be configured */
>         int                     msi_enable;
> --
> 2.3.2.209.gd67f9d5.dirty
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
