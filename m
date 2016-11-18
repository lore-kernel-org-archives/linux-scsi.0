From: James Smart <james.smart@broadcom.com>
Subject: Re: use PCI layer IRQ affinity in lpfc
Date: Fri, 18 Nov 2016 08:21:35 -0800
Message-ID: <96e879ef-3152-f133-b89d-ae3f2661a85e@broadcom.com>
References: <1479395693-5781-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f49.google.com ([74.125.83.49]:35386 "EHLO
        mail-pg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932255AbcKRQVh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Nov 2016 11:21:37 -0500
Received: by mail-pg0-f49.google.com with SMTP id p66so104435688pga.2
        for <linux-scsi@vger.kernel.org>; Fri, 18 Nov 2016 08:21:37 -0800 (PST)
In-Reply-To: <1479395693-5781-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: hare@suse.de, linux-scsi@vger.kernel.org

Hi Christoph,

We had already done this work in the larger lpfc patch that had been 
posted for nvme work.

I'll look at separating out just the irq part and post a reply.

-- james


On 11/17/2016 7:14 AM, Christoph Hellwig wrote:
> This series has two patches: the first is a simple conversion of
> lpfc to use pci_alloc_irq_vectors.  The second is more interesting,
> and makes use of the PCI_IRQ_AFFINITY option to use the core interrupt
> affinity assignment that takes nodes into account and can be easily
> queried.  It also ensures we propagate this information to blk-mq
> to make sure the block layer queues are properly aligned to the
> interrupt vectors.
>
> Note that these patches require core IRQ changes from a stable
> branch in the tip tree to be pulled in first:
>
> 	git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq/for-block
>
> Also be aware that I don't have any lpfc hardware to actually test these.

