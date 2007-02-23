From: Bernhard Walle <bwalle@suse.de>
Subject: GFP_DMA in sd_revalidate_disk
Date: Fri, 23 Feb 2007 17:51:14 +0100
Message-ID: <20070223165114.GA29468@strauss.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:59359 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933147AbXBWQvQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Feb 2007 11:51:16 -0500
Received: from Relay2.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id 6019D12294
	for <linux-scsi@vger.kernel.org>; Fri, 23 Feb 2007 17:51:15 +0100 (CET)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

is GFP_DMA really needed in sd_revalidate_disk() in every circumstances?
That's the code:

    buffer = kmalloc(SD_BUF_SIZE, GFP_KERNEL | __GFP_DMA);
    if (!buffer) {
        printk(KERN_WARNING "(sd_revalidate_disk:) Memory allocation "
               "failure.\n");
        goto out;
    }

Or should could the check (sdp->host->unchecked_isa_dma ? __GFP_DMA : 0)
applied here, too?

Thanks!


Regards,
Bernhard
