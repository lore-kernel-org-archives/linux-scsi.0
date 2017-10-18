From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi: Always retry internal target error
Date: Wed, 18 Oct 2017 08:34:39 +0200
Message-ID: <20171018063439.GA11109@lst.de>
References: <1508224263-130302-1-git-send-email-hare@suse.de> <yq18tg9upqf.fsf@oracle.com> <51f905cd-6907-438e-396f-a6efe610370f@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:35666 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933230AbdJRGek (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Oct 2017 02:34:40 -0400
Content-Disposition: inline
In-Reply-To: <51f905cd-6907-438e-396f-a6efe610370f@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On Wed, Oct 18, 2017 at 08:15:46AM +0200, Hannes Reinecke wrote:
> > It's decidedly awful to have vendor/model-specific triggers in
> > scsi_error.
> > 
> > What are the drawbacks of just always refiring on AC/0x44/ITF?
> > 
> Hmm. 'Internal target failure' is not very descriptive, so it could mean
> anything. Hence the rather awkward approach.
> But I just checked with the qemu code, and that returns 0x44/0x00 only
> if some (internal) call returned with -ENOMEM.
> So I guess we're safe to always retry here.

And even if not we should add a quirk so that we can just check a
bit instead of doing two string compares in the I/O completion path..
