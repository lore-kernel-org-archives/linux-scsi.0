From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/7] megaraid_sas: Send SYNCHRONIZE_CACHE command to
 firmware
Date: Mon, 17 Oct 2016 08:55:06 -0700
Message-ID: <20161017155506.GA25521@infradead.org>
References: <1476699850-25083-1-git-send-email-sumit.saxena@broadcom.com>
 <1476699850-25083-5-git-send-email-sumit.saxena@broadcom.com>
 <d9e79049-b4ce-588f-263d-dad015b3368d@suse.de>
 <9e5fbcef-bd72-71be-76f6-f41e26b5cb3c@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59106 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933642AbcJQPzL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Oct 2016 11:55:11 -0400
Content-Disposition: inline
In-Reply-To: <9e5fbcef-bd72-71be-76f6-f41e26b5cb3c@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, Sumit Saxena <sumit.saxena@broadcom.com>, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <mkp@mkp.net>, Jeff Moyer <jmoyer@redhat.com>, Gris Ge <fge@redhat.com>, Ewan Milne <emilne@redhat.com>, Jens Axboe <axboe@kernel.dk>

On Mon, Oct 17, 2016 at 09:01:29AM -0400, Ric Wheeler wrote:
> This must go in - without this fix, there is no data integrity for any file system.

megaraid always had odd ideas on cache flushing, and this might be
a opportunity to write down all the assumptions and document them.

> In effect, this driver by default has been throwing away SYNCHRONIZE_CACHE
> commands even when acting in JBOD/non-RAID mode.

That would explain some issues we've seen with megaraid hardware, but
it seems a bit too shocking to be true.

Looking over the patch I disagree with the module option - we must do
the right thing by default, which is sending SYNCHRONIZE_CACHE commands
if the WCE bit is set.  If there are controllers where this is harmful
for RAID mode and we can't fix the firmware in time we'll need to make
special exceptions for this case in the driver based on the PCI ID
and knowing what we talk to instead of leaving it to the user.

> * having T10 & T13 report the existence of a volatile write cache - this is
> different than WCE set, some devices have a write cache and are
> battery/flash backed.

T10 is pretty clear now the WCE should only be set for a non-voltile
cache.  For a while they had odd NV bits to allow flushing a
non-volatile cache, but in the latest revisions all that is gone.
