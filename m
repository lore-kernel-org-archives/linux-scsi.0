From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RESEND PATCH] scsi: fix ata_port_wait_eh() hang caused by
 missing to wake up eh thread
Date: Sun, 9 Oct 2016 08:24:59 -0700
Message-ID: <20161009152459.GA29818@infradead.org>
References: <1476022905-17234-1-git-send-email-fangwei1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60532 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751609AbcJIPZI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Oct 2016 11:25:08 -0400
Content-Disposition: inline
In-Reply-To: <1476022905-17234-1-git-send-email-fangwei1@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wei Fang <fangwei1@huawei.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org

On Sun, Oct 09, 2016 at 10:21:45PM +0800, Wei Fang wrote:
> ->host_eh_schedule and ->shost_state may be accessed simultaneously as
> below:

But we can't simply take shost_lock in every completion handler, as
that would kill peformance.

>From a quick look the most sensible options seems to be to remove the
host_eh_scheduled field and replace it with another host state.
