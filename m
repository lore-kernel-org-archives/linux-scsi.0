From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 4/6] qla2xxx: Add multiple queue pair functionality.
Date: Mon, 5 Dec 2016 04:59:08 -0800
Message-ID: <20161205125908.GC23221@infradead.org>
References: <1480715097-13611-1-git-send-email-himanshu.madhani@cavium.com>
 <1480715097-13611-5-git-send-email-himanshu.madhani@cavium.com>
 <64bf8c12-c086-2531-8510-27a95f8f0ef1@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60931 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751086AbcLEM7K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Dec 2016 07:59:10 -0500
Content-Disposition: inline
In-Reply-To: <64bf8c12-c086-2531-8510-27a95f8f0ef1@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Himanshu Madhani <himanshu.madhani@cavium.com>, martin.petersen@oracle.com, linux-scsi@vger.kernel.org

[Hannes, can you please stop the damn full quotes?  reading your answers
is a major pain]

> Have you modified the irq affinity for this?
> Typically the irq-affinity changes will treat all vectors identically,
> and spread them out across the available CPUS.
> But with this layout vector '0' apparently is the MB irq vector, and as
> such should _not_ be treated like the others wrt irq affinity, but
> rather left alone.
> Christoph put in some changes for that, but they'll be coming in via the
> tip tree, so not sure if Martin has already taken them in.
> But in either way, you should be using them to get the irq affinity
> layout correctly.

The changes are here:

https://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/log/?h=irq/for-block

I don't think they are in the SCSI tree yet as I haven't gotten a reply
to the lpfc conversion yet.  But that conversion is here for reference:

http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/lpfc-msix

qla2xxx would need to use pre_vectors instead of post_vectors, though.
