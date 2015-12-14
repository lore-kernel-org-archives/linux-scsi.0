From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/20] qla2xxx: Fix interaction issue between qla2xxx and
 Target Core Module
Date: Mon, 14 Dec 2015 02:34:49 -0800
Message-ID: <20151214103449.GA8095@infradead.org>
References: <1449535747-2850-1-git-send-email-himanshu.madhani@qlogic.com>
 <1449535747-2850-11-git-send-email-himanshu.madhani@qlogic.com>
 <20151208023700.GB9088@infradead.org>
 <D28DCE82.1B0CE%quinn.tran@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <D28DCE82.1B0CE%quinn.tran@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: Quinn Tran <quinn.tran@qlogic.com>
Cc: Christoph Hellwig <hch@infradead.org>, Himanshu Madhani <himanshu.madhani@qlogic.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, Giridhar Malavali <giridhar.malavali@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Dec 09, 2015 at 10:07:32PM +0000, Quinn Tran wrote:
> >Err, no.  Looking into the refcount inside a kref is never the
> >right thing to do.
> 
> QT> even for debug purpose??

No.  Please treat struct kref as opaque.

> QT> These bits provide indication as to where the command has traversed in
> the QLA code.  Each bit is set one time. Due to the async nature of the
> TMR code, it triggers QLA driver to repeat this specific free path in the
> double free case.  This BUG_ON allows us trap it early on.
> 
> In one of the corner case (below), I need to overloaded it + lock for the
> cleanup process.

Setting bits fundamentaly is a read/modify/write cycle.  You either
need to use {set,clear,test}_bit or lock around these manipulations.

> QT> The cmd->aborted flag is used to track the CMD_T_ABORT flag at TCM
> level.  If the command have been requested to be aborted by TCM or already
> aborted, we advance it to the ?free" state because our hardware have
> already started freeing up resources associated to this command/exchange.
> In this specific case(above), a XFER RDY was aborted by the TMR.
> Returning the cmd to TCM to generate SCSI Status would generate erroneous
> HW error due to freed resource.

I really think this nees to be updated on top of Bat's changes as a
start and re-reviewed.  The amoutn of special casing and second guessing
here is simply not sustainable in the long run.
