From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/5] tcm: Unify UNMAP and WRITE_SAME w/ UNMAP=1 subsystem plugin handling
Date: Thu, 14 Oct 2010 02:03:41 +0200
Message-ID: <20101014000341.GA15583@lst.de>
References: <1286959700-3489-1-git-send-email-nab@linux-iscsi.org> <20101013111920.GB26366@lst.de> <1287003368.7334.64.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:45809 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888Ab0JNAEI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Oct 2010 20:04:08 -0400
Content-Disposition: inline
In-Reply-To: <1287003368.7334.64.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Boaz Harrosh <bharrosh@panasas.com>, Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>, Richard Sharpe <realrichardsharpe@gmail.com>

On Wed, Oct 13, 2010 at 01:56:08PM -0700, Nicholas A. Bellinger wrote:
> > The parsing of the WRITE SAME and UNMAP CDBs is something the generic
> > CDB parsing code should do,
> 
> Ok, so you are thinking about a seperate transport_emulate_write_same()
> and transport_emulate_unmap() called from
> transport_emulate_control_cdb(), right..?

More or less yes.

> >  and just give a range of lists of lba/len
> > pairs to the ->discard method in the backed.
> 
> Yes, these are already available from the passed struct
> se_task->task_lba and ->task_size values.

Not for UNMAP.  WRITE SAME in it's various incarnations uses the
standard LBA/LEN encoding and you seem to parse it nicely.  But for
UNMAP the lba/len pairs are in the command payload.  To support things
genericly you'd need a standard way to pass them.  If you want to
limit yourself to one lba/len pair for one the scheme could work,
though.

> Yes, so the problem of trying to make this code generic (eg: outside of
> TCM subsystem plugins) is that blk_issue_discard() takes struct
> block_device, which means we the subsystem plugin has to locate struct
> block_device inside of non generic cide.

blk_issue_discard is in no way generic.  It's 100% iblock code and
really doesn't belong into any other backend.  And btw,
blk_issue_discard is rather suboptimal even in iblock - it's a
synchronous function that will stall progress of the thread handling it.
If you want better performance you'll need to opencode the content of
it to allow an asynchronous completion handler.  But given that discard
isn't really a critical feature at this point this could easily be
left for later with a comment.

> So, then the main issue becomes FILEIO + block level discard and how to
> issue an blk_issue_discard() from struct fileio in the most sane way.
> If there is no sane way then I will just drop this bit, or just do the
> file level 'hole punch' that you are speaking about.

Right now there is no good way to do a block device discard or file
hole punch at the level where the file backend operates.

