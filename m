From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] sg: remove unreachable code in SET_FORCE_LOW_DMA
Date: Wed, 1 Feb 2017 14:03:42 +0100
Message-ID: <20170201130341.GA5351@lst.de>
References: <1485948399-83339-1-git-send-email-hare@suse.de> <20170201130048.GA5125@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:35167 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751140AbdBANDn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 1 Feb 2017 08:03:43 -0500
Content-Disposition: inline
In-Reply-To: <20170201130048.GA5125@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Wed, Feb 01, 2017 at 02:00:48PM +0100, Christoph Hellwig wrote:
> I think the proper fix is to check sfp->low_dma for 0 before updating
> it, at least that seems to be the intent here.

Looking at this code a bit more I think the actual, real proper fix
is to remove the SET_FORCE_LOW_DMA entirely (except maybe the flag
for SG_GET_LOW_DMA and procfs output).  The block layer already does
bounce buffering if the DMA addressing constraints are not met,
so all this should just go away.

Btw, any rason Doug isn't on Cc on these sg.c patches?
