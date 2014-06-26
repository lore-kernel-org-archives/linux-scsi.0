From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: SCSI eats error from flush failure during hot plug
Date: Thu, 26 Jun 2014 11:04:56 -0400
Message-ID: <1403795096.3572.8.camel@dabdike>
References: <CAPK7rjcrBuQgoiAxZ9ZASAGugtyHTsHB3ssZegKtuzRdo9TMNQ@mail.gmail.com>
	 <1402169384.2236.18.camel@dabdike.int.hansenpartnership.com>
	 <CAPK7rjeG2nJMD3j9qEuJ0LdsCYaUoK+ABMuWdYZG3xaRgEJoYQ@mail.gmail.com>
	 <1402334946.2197.17.camel@dabdike.int.hansenpartnership.com>
	 <20140611133736.GA12240@infradead.org>
	 <1403201159.17294.13.camel@dabdike.int.hansenpartnership.com>
	 <20140625131344.GA13094@infradead.org> <1403791367.3572.1.camel@dabdike>
	 <20140626150055.GB11199@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50010 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751765AbaFZPE7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jun 2014 11:04:59 -0400
In-Reply-To: <20140626150055.GB11199@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Steven Haber <steven@qumulo.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>

On Thu, 2014-06-26 at 08:00 -0700, Christoph Hellwig wrote:
> On Thu, Jun 26, 2014 at 10:02:47AM -0400, James Bottomley wrote:
> > Yes, but think what you're proposing.  Every block command with a
> > special setup goes via scsi_setup_blk_pc_cmnd() because they usually
> > have to translate to something special.
> 
> That logic is backwards.  The "special" commands use
> scsi_setup_blk_pc_cmnd because that seemed the easiest we to do it
> when they were introduce.  Looking back they should have just called
> scsi_init_io directly instead of doing enough setup to pretend to be
> BLOCK_PC enough to use scsi_setup_blk_pc_cmnd().
> 
> > If we did what you propose,
> > every time we add one, we'd have to modify these five places in the code
> > plus the setup ... it's a bit insane plus a maintenance nightmare.
> 
> It's not.  They need to be treated special because they _are_ special.

If there's a problem outside the normal processing then it needs to be
solved once, not once for every new special block command type.

> If you look at the command types there's a pretty clear difference
> between BLOCK_PC and everything else:
> 
> 			BLOCK_PC	read/write	discard/flush/write_same
> need to generate CDB	no		yes		yes
> calls into the ULD	no		yes		yes
> needs error handling	no		yes		yes
> passes sense data up	yes		no		no

Right, but look what we do for the specials.  The only difference is the
ULD has a hook to generate the CDB.  For everything else we follow the
BLOCK_PC path, including error handling and sense data processing.

> so they surely aren;t like BLOCK_PC, and treating them like BLOCK_PC
> would require major changes to our architecture.  Not that I'm overly
> happy with them being _FS requests either - they probably should have
> a cmd_type assigned for each of them and come down from the block
> layer set up that way.  I'll look into that once I get a little bit of
> time.

OK, we'll us this as a fix for the bug.  If you come up with something
more elegant we can replace it.

James


