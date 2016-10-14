From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [GIT PULL] final round of SCSI updates for the 4.8+ merge
 window
Date: Sat, 15 Oct 2016 09:51:58 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1610150938510.27214@nippy.intranet>
References: <1476426828.22309.34.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:36738 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752103AbcJNXxx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Oct 2016 19:53:53 -0400
In-Reply-To: <1476426828.22309.34.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>


On Fri, 14 Oct 2016, James Bottomley wrote:

> This is just a set of minor updates and fixes which weren't quite ready
> in time for the first pull request.  The only real thing of note is
> Mike Christie is stepping down as Maintainer of iscsi to be replaced by
> Lee Duncan and Chris Leech.
> 
> The patch is available here:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc
> 
> The short changelog is:
> 
> Baoyou Xie (1):
>       scsi: be2iscsi: mark symbols static where possible
> 
> Joao Pinto (1):
>       scsi: ufs: Kconfig fix
> 
> Kyuho Choi (1):
>       scsi: ufs: Enable no vccq quirk for skhynix device
> 
> Lee Duncan (1):
>       MAINTAINERS: Update open-iscsi maintainers
> 
> Ondrej Zary (3):
>       scsi: g_NCR5380: Stop using scsi_module.c

I believe that patch introduces an .init.text section mismatch, that I 
failed to notice when I reviewed it. So you may want Arnd Bergmann's fix 
which is commit 8f087c089dae5 ("scsi: NCR5380: no longer mark irq probing 
as __init") in mkp-scsi/4.10/scsi-queue.

-- 

>       scsi: g_NCR5380: Reduce overrides[] from array to struct
>       scsi: g_NCR5380: Remove deprecated __setup
> 
> Varun Prakash (1):
>       scsi: cxgb4i: Set completion bit in work request
> 
> Wei Yongjun (1):
>       scsi: ufs: Fix error return code in ufshcd_init()
> 
> Zang Leigang (1):
>       scsi: ufs: Data Segment only needed for WRITE DESCRIPTOR
> 
> And the diffstat:
> 
> 
>  Documentation/scsi/g_NCR5380.txt   |  34 +-
>  MAINTAINERS                        |   6 +-
>  drivers/scsi/be2iscsi/be_main.c    |  12 +-
>  drivers/scsi/cxgbi/cxgb4i/cxgb4i.c |   5 +
>  drivers/scsi/g_NCR5380.c           | 699 ++++++++++++++++---------------------
>  drivers/scsi/g_NCR5380.h           |   8 -
>  drivers/scsi/ufs/Kconfig           |   2 +-
>  drivers/scsi/ufs/ufs_quirks.h      |   2 +
>  drivers/scsi/ufs/ufshcd.c          |  10 +-
>  9 files changed, 345 insertions(+), 433 deletions(-)
> 
> James
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
