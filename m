From: James Bottomley <jejb@steeleye.com>
Subject: RE: [PATCH] kill aac_io_done
Date: 11 Oct 2004 11:55:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1097513750.2029.152.camel@mulgrave>
References: <60807403EABEB443939A5A7AA8A7458B2FC33F@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:18585 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S269177AbUJKQ4Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Oct 2004 12:56:16 -0400
In-Reply-To: <60807403EABEB443939A5A7AA8A7458B2FC33F@otce2k01.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Mark Haverkamp <markh@osdl.org>, Christoph Hellwig <hch@lst.de>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2004-10-11 at 11:07, Salyzyn, Mark wrote:
> The host lock around scsi_done() was there *before* I started
> maintaining this driver. I believe the reasoning could be as simple as
> `we had an io_request_lock there, so we should need a host_lock for the
> same reasons'. I believe this locking is a legacy of code prior to
> 2.1.95 though...

I think it was a 2.2 requirement; the then "new" SCSI code in 2.4 moved
to completing requests in the bottom half handler which queue was
protected by the scsi_bhqueue_lock in the scsi_done() routine and no
longer needed the io_request lock.

In 2.6 the BH handler became a softirq thanks to Mattew Wilcox.

James


