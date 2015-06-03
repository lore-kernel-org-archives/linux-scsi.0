From: "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [PATCH v3] fusion: remove dead MTRR code
Date: Wed, 3 Jun 2015 16:02:28 -0700
Message-ID: <CAB=NE6WzAepHROyU3AEbUOTFV2JzwxQR59B9fkgr18Ca8pEaeg@mail.gmail.com>
References: <1429649166-18294-1-git-send-email-mcgrof@do-not-panic.com>
 <CAB=NE6V8bVPofvcaGhUebqZckvEAvbYrSdv1EJU52M-4vrFQ8g@mail.gmail.com> <CAB=NE6VVcaZ2v8VbSThcT3Kv_FkcB3nqbQLTjrhNPYyLvfd2PQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:36831 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452AbbFCXCt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jun 2015 19:02:49 -0400
In-Reply-To: <CAB=NE6VVcaZ2v8VbSThcT3Kv_FkcB3nqbQLTjrhNPYyLvfd2PQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>, "mpt-fusionlinux.pdl" <MPT-FusionLinux.pdl@avagotech.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Sumit.Saxena@avagotech.com, kashyap.desai@avagotech.com, JBottomley@odin.com
Cc: Andy Lutomirski <luto@amacapital.net>, "Michael S. Tsirkin" <mst@redhat.com>, "Luis R. Rodriguez" <mcgrof@suse.com>, Toshi Kani <toshi.kani@hp.com>, Christoph Hellwig <hch@infradead.org>, Suresh Siddha <sbsiddha@gmail.com>, Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>, Juergen Gross <jgross@suse.com>, Daniel Vetter <daniel.vetter@ffwll.ch>, Dave Airlie <airlied@redhat.com>, Antonino Daplas <adaplas@gmail.com>, Tomi Valkeinen <tomi.valkeinen@ti.com>, =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <syrjala@sci.fi>, Mel Gorman <mgorman@suse.de>, Vlastimil Babka <vbabka@suse.cz>, Borislav Petkov <bp@suse.de>, Davidlohr Bueso <dbueso@suse.de>, Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Fri, May 29, 2015 at 1:23 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> On Wed, Apr 29, 2015 at 12:50 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
>> On Tue, Apr 21, 2015 at 1:46 PM, Luis R. Rodriguez
>> <mcgrof@do-not-panic.com> wrote:
>>> From: "Luis R. Rodriguez" <mcgrof@suse.com>
>>>
>>> If and when this gets enabled the driver could should split
>>> up IO memory space properly and that is quite a bit of work.
>>> Just remove the uncommented dead MTRR code then.
>>>
>>> There are a few motivations for this:
>>>
>>> a) Take advantage of PAT when available
>>>
>>> b) Help bury MTRR code away, MTRR is architecture specific and on
>>>    x86 its replaced by PAT
>>>
>>> c) Help with the goal of eventually using _PAGE_CACHE_UC over
>>>    _PAGE_CACHE_UC_MINUS on x86 on ioremap_nocache() (see commit
>>>    de33c442e titled "x86 PAT: fix performance drop for glx,
>>>    use UC minus for ioremap(), ioremap_nocache() and
>>>    pci_mmap_page_range()")
>>
>> Hey folks, who's tree should this go through if agreeable?
>
> OK its been over 1 month without any replies on this patch which just
> removes commented out code.
>
> All the maintainers below bounce and the only e-mail not bouncing is
> for Sreekanth Reddy <sreekanth.reddy@avagotech.com>, he hasn't been
> seen active on linux-next since Jan 12 2015 when he did a driver bump
> for mpt2sas to 20.100.00.00.
>
> What's going on folks? And can this patch go in?
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index aca2886..73dbc02 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6205,10 +6205,7 @@ S:       Maintained
>  F:     arch/arm/mach-lpc32xx/
>
>  LSILOGIC MPT FUSION DRIVERS (FC/SAS/SPI)
> -M:     Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>
> -M:     Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>
>  M:     Sreekanth Reddy <sreekanth.reddy@avagotech.com>
> -M:     Abhijit Mahajan <abhijit.mahajan@avagotech.com>
>  L:     MPT-FusionLinux.pdl@avagotech.com
>  L:     linux-scsi@vger.kernel.org
>  W:     http://www.lsilogic.com/support

OK so Avago bought Broadcom.

Does that impact how Avago will contribute to the Linux kernel? It has
been well over 1 month and I haven't seen any reply from Avago folks.

Andrew, is the silence sufficient enough reason for this patch to go
instead through your tree?

 Luis
