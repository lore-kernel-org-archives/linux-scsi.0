From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [GIT PULL] final round of SCSI updates for the 5.2+ merge window
Date: Sat, 20 Jul 2019 10:29:40 +0800
Message-ID: <CACVXFVNOPhiUhrgw07sna0dt5Jy2zckbNXDWPPRAGadXQAS_mQ@mail.gmail.com>
References: <1563579201.1602.7.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1563579201.1602.7.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, Jul 20, 2019 at 8:38 AM James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> This is the final round of mostly small fixes in our initial
> submit.  It's mostly minor fixes and driver updates.  The only change
> of note is adding a virt_boundary_mask to the SCSI host and host
> template to parametrise this for NVMe devices instead of having them do
> a call in slave_alloc.  It's a fairly straightforward conversion except
> in the two NVMe handling drivers that didn't set it who now have a
> virtual infinity parameter added.
>
> The patch is available here:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
>
> The short changelog is:
>
> Arnd Bergmann (1):
>       scsi: lpfc: reduce stack size with CONFIG_GCC_PLUGIN_STRUCTLEAK_VERBOSE
>
> Benjamin Block (3):
>       scsi: zfcp: fix GCC compiler warning emitted with -Wmaybe-uninitialized
>       scsi: zfcp: fix request object use-after-free in send path causing wrong traces
>       scsi: zfcp: fix request object use-after-free in send path causing seqno errors
>
> Christoph Hellwig (8):
>       scsi: megaraid_sas: set an unlimited max_segment_size
>       scsi: mpt3sas: set an unlimited max_segment_size for SAS 3.0 HBAs
>       scsi: IB/srp: set virt_boundary_mask in the scsi host
>       scsi: IB/iser: set virt_boundary_mask in the scsi host
>       scsi: storvsc: set virt_boundary_mask in the scsi host template
>       scsi: ufshcd: set max_segment_size in the scsi host template
>       scsi: core: take the DMA max mapping size into account

It has been observed on NVMe the above approach("take the DMA max
mapping size into account") causes performance regression, so I'd
suggest to fix dma_max_mapping_size() first.

Christoph has posted fix already, but looks not merged yet:

      https://lkml.org/lkml/2019/7/17/62


Thanks,
Ming Lei
