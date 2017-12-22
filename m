From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/3] ses: make initial allocation size configurable
Date: Fri, 22 Dec 2017 09:14:33 -0800
Message-ID: <1513962873.3163.12.camel@HansenPartnership.com>
References: <1513855354-86603-1-git-send-email-hare@suse.de>
         <1513855354-86603-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39110 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755826AbdLVROf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Dec 2017 12:14:35 -0500
In-Reply-To: <1513855354-86603-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Thu, 2017-12-21 at 12:22 +0100, Hannes Reinecke wrote:
> Some storage arrays have an incorrect SES implementation which will
> always return the allocation length of the CDB instead of the true
> length of the requested page.

That's a pretty gross standards violation, is this common?  When the
buffer is > than the data to return, does it get set then?  Because if
not, we're going to be processing bogus data and no module parameter
can fix this because the returned length depends on the number of
elements in the enclosure making this parameter really unsafe unless
you get it exactly right.

> With this patch one can modify the initial allocation size to
> get the full output of those arrays.

This really doesn't look like the right way to do it.  Shouldn't we
rather have a blacklist for these devices and simply do a page for each
allocation for them (assuming they return the correct length when over
subscribed).

James
