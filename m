From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHv2 09/11] mpt3sas: lockless command submission for
        scsi-mq
Date: Fri, 17 Feb 2017 10:09:22 +0100
Message-ID: <20170217090922.GA19345@lst.de>
References: <1487319790-97340-1-git-send-email-hare@suse.de> <1487319790-97340-10-git-send-email-hare@suse.de> <20170217085410.GD18443@lst.de> <660deb29-26ee-685a-3c48-613c60d35a29@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:41292 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755684AbdBQJJY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Feb 2017 04:09:24 -0500
Content-Disposition: inline
In-Reply-To: <660deb29-26ee-685a-3c48-613c60d35a29@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Fri, Feb 17, 2017 at 10:03:03AM +0100, Hannes Reinecke wrote:
> Yes, true; it will fail.
> 
> It will be fixed up by using reserved commands in patch 11.

Patches should be fully bisectable.  If that is too much work they
need to be merged with a good explanation on why it is done.

> > You can't rely on blk-mq being used, and we'd really want to avoid
> > layering violations like this anyway.
> > 
> Well, I _did_ enable blk-mq later on, so from that perspective,
> yes, I can.

No you can't.  Drivers can not enable blk-mq, it's a global policy
setting.

> But if that's a layering violation, how am I supposed to check this?
> Would be a wrapper in the scsi midlayer be acceptable?
> Or is using blk_mq_tagset_busy_iter considered internal to the block layer?

I think the right answer is to figure out what you're actually doing,
and if it's a) nessecary at all, b) if it's already implemented in common
code and c) if it should be implemented in common code.
