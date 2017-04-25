From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [RESEND][PATCH 07/10][SCSI]mpt2sas: Added Reply Descriptor Post
 Queue (RDPQ) Array support
Date: Tue, 25 Apr 2017 17:21:07 +0530
Message-ID: <CAK=zhgq=DfOZGjLcid4qJA+L_Vs4UjOHAmJza5Zh-V7u=LxcsQ@mail.gmail.com>
References: <20140625103445.GA12943@avagotech.com> <yq1zjg2m6lu.fsf@sermon.lab.mkp.net>
 <CAK=zhgoQt5J=jh4jShAy5rBXNz34sN-tqf=uZDkY4zQJ9XhM5g@mail.gmail.com>
 <yq18unklvda.fsf@sermon.lab.mkp.net> <CAK=zhgpDWJLBMBB1mV-7u+o_UC86PiOCAp4vi4-UAn_hXHtF2A@mail.gmail.com>
 <yq1r41bkgdp.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f52.google.com ([74.125.83.52]:33060 "EHLO
        mail-pg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1947181AbdDYLvJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Apr 2017 07:51:09 -0400
Received: by mail-pg0-f52.google.com with SMTP id 63so27485017pgh.0
        for <linux-scsi@vger.kernel.org>; Tue, 25 Apr 2017 04:51:08 -0700 (PDT)
In-Reply-To: <yq1r41bkgdp.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "jejb@kernel.org" <jejb@kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

On Thu, Jul 24, 2014 at 1:16 AM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:
>
> Sreekanth,
>
> Sreekanth> 2. As per MPI Spec, each set of 8 reply descriptor post
> Sreekanth> queues must have the same value for the upper 32-bits of
> Sreekanth> their memory address. So allocated set of eight queues in a
> Sreekanth> single pool and added a new function is_MSB_are_same() to
> Sreekanth> check whether higher 32 bits of this pool memory address are
> Sreekanth> same or not. If this functions returns zero then we are
> Sreekanth> saving these pools in the bad_reply_post_pool list. then
> Sreekanth> releasing these pools once we get the required memory pools.
>
> Why don't you just set pci_set_consistent_dma_mask() to DMA_BIT_MASK(32)
> before you allocate the queue entries?

Martin,

I am taking out this old mail to find out is their any other better
way to make sure that allocated DMA pool doesn't cross particular
boundary line (in our case all upper 32 bits of this pool should be
same, i.e. all the buffer from the pool should be within the 4GB
boundary).

We need to satisfy this condition on those system where 32 bit dma
consistent mask is not supported and it only supports 64 bit dma
consistent mask. So on these system we can't set
pci_set_consistent_dma_mask() to DMA_BIT_MASK(32).

Thanks,
Sreekanth

>
> --
> Martin K. Petersen      Oracle Linux Engineering
