From: Christoph Hellwig <hch@infradead.org>
Subject: Re: SCSI eats error from flush failure during hot plug
Date: Thu, 26 Jun 2014 08:00:55 -0700
Message-ID: <20140626150055.GB11199@infradead.org>
References: <CAPK7rjcrBuQgoiAxZ9ZASAGugtyHTsHB3ssZegKtuzRdo9TMNQ@mail.gmail.com>
 <1402169384.2236.18.camel@dabdike.int.hansenpartnership.com>
 <CAPK7rjeG2nJMD3j9qEuJ0LdsCYaUoK+ABMuWdYZG3xaRgEJoYQ@mail.gmail.com>
 <1402334946.2197.17.camel@dabdike.int.hansenpartnership.com>
 <20140611133736.GA12240@infradead.org>
 <1403201159.17294.13.camel@dabdike.int.hansenpartnership.com>
 <20140625131344.GA13094@infradead.org>
 <1403791367.3572.1.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60045 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430AbaFZPA4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jun 2014 11:00:56 -0400
Content-Disposition: inline
In-Reply-To: <1403791367.3572.1.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>, Steven Haber <steven@qumulo.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>

On Thu, Jun 26, 2014 at 10:02:47AM -0400, James Bottomley wrote:
> Yes, but think what you're proposing.  Every block command with a
> special setup goes via scsi_setup_blk_pc_cmnd() because they usually
> have to translate to something special.

That logic is backwards.  The "special" commands use
scsi_setup_blk_pc_cmnd because that seemed the easiest we to do it
when they were introduce.  Looking back they should have just called
scsi_init_io directly instead of doing enough setup to pretend to be
BLOCK_PC enough to use scsi_setup_blk_pc_cmnd().

> If we did what you propose,
> every time we add one, we'd have to modify these five places in the code
> plus the setup ... it's a bit insane plus a maintenance nightmare.

It's not.  They need to be treated special because they _are_ special.

If you look at the command types there's a pretty clear difference
between BLOCK_PC and everything else:

			BLOCK_PC	read/write	discard/flush/write_same
need to generate CDB	no		yes		yes
calls into the ULD	no		yes		yes
needs error handling	no		yes		yes
passes sense data up	yes		no		no

so they surely aren;t like BLOCK_PC, and treating them like BLOCK_PC
would require major changes to our architecture.  Not that I'm overly
happy with them being _FS requests either - they probably should have
a cmd_type assigned for each of them and come down from the block
layer set up that way.  I'll look into that once I get a little bit of
time.


> Since block gave us the command to set up as we please, we're entitled
> to change the fields including cmd_type.

The block layer doesn't care, but that doesn't make it right inside the
SCSI code.

