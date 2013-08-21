From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 9/9] tcm_qla2xxx: Add special case for COMPARE_AND_WRITE
 data_direction
Date: Wed, 21 Aug 2013 09:04:50 -0700
Message-ID: <20130821160450.GA30848@infradead.org>
References: <1377029280-19144-1-git-send-email-nab@daterainc.com>
 <1377029280-19144-10-git-send-email-nab@daterainc.com>
 <20130821063702.GI25506@infradead.org>
 <1377070267.32763.26.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1377070267.32763.26.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@infradead.org>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Martin Petersen <martin.petersen@oracle.com>, Chris Mason <chris.mason@fusionio.com>, James Bottomley <JBottomley@Parallels.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Aug 21, 2013 at 12:31:07AM -0700, Nicholas A. Bellinger wrote:
> Is it really worth having two se_cmd_flags for COMPARE_AND_WRITE..?

Not leaking the abstraction into the driver is always worth the effort.

But looking at the other patches I haven't reviewed yet I think the
issue is more severe anyway, see my next reply.

> > Also it might make sense to lift this helper to get a dma direction from
> > a command into common code.
> > 
> 
> Mmm, perhaps.  I don't recall of the top of my head why tcm_qla2xxx
> actually needed to reverse it's dma direction (I'm sure that Roland
> knows, CC'ed), but IIRC it was a tcm_qla2xxx specific thing..?

It's the same issue for any hardware driver that directly maps a
se_cmd - the direction the target expects is reversed to what the
driver expects, in addition any BIDI or other special meanings will
need handling.
