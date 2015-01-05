From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 90601] panic on write to 3ware raid array
Date: Mon, 05 Jan 2015 09:17:03 +0000
Message-ID: <bug-90601-11613-2xPWZsajkH@https.bugzilla.kernel.org/>
References: <bug-90601-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:33954 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227AbbAEJRH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Jan 2015 04:17:07 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A7DBE20117
	for <linux-scsi@vger.kernel.org>; Mon,  5 Jan 2015 09:17:05 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 493A420165
	for <linux-scsi@vger.kernel.org>; Mon,  5 Jan 2015 09:17:04 +0000 (UTC)
In-Reply-To: <bug-90601-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=90601

kashyap <kashyap.desai@lsi.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |kashyap.desai@lsi.com

--- Comment #3 from kashyap <kashyap.desai@lsi.com> ---
Merlin, 

1.) 
Can you enable CONFIG_DMA_API_DEBUG in your kernel conf and send complete
/var/log/messages along with back trace.

2.)
>From existing logs I can figure out that crash happened at below place.

static void intel_unmap_sg(struct device *dev, struct scatterlist *sglist,
                           int nelems, enum dma_data_direction dir,
                           struct dma_attrs *attrs)
{
        intel_unmap(dev, sglist[0].dma_address);
}

sglist[0] is NULL and while accessing dma_address (which is 0x10th index as per
below definition)

struct scatterlist {
#ifdef CONFIG_DEBUG_SG
        unsigned long   sg_magic;
#endif
        unsigned long   page_link;
        unsigned int    offset;
        unsigned int    length;
        dma_addr_t      dma_address;   < -- 0x10th index
#ifdef CONFIG_NEED_SG_DMA_LENGTH
        unsigned int    dma_length;
#endif  
};

Crash detail -
[ 1005.899543] Hardware name: Supermicro X9DR7/E-(J)LN4F/X9DR7/E-(J)LN4F, BIOS
3.0a 09/10/2013
[ 1005.899971] task: ffffffff8160a460 ti: ffffffff815f4000 task.ti:
ffffffff815f4000
[ 1005.900401] RIP: 0010:[<ffffffff813db181>]  [<ffffffff813db181>]
intel_unmap_sg+0x1/0x10


~ kashyap

-- 
You are receiving this mail because:
You are the assignee for the bug.
