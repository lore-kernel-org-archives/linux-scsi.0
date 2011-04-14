From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [RFC] block integrity: Fix write after checksum calculation
 problem
Date: Wed, 13 Apr 2011 17:48:48 -0700
Message-ID: <1302742128.2586.274.camel@mingming-laptop>
References: <20110319000755.GD1110@tux1.beaverton.ibm.com>
	 <20110321140451.GA7153@quack.suse.cz> <1300716666-sup-2087@think>
	 <20110321164305.GC7153@quack.suse.cz>
	 <20110406232938.GF1110@tux1.beaverton.ibm.com>
	 <20110407165700.GB7363@quack.suse.cz>
	 <20110408203135.GH1110@tux1.beaverton.ibm.com>
	 <20110411124229.47bc28f6@corrin.poochiereds.net>
	 <1302543595-sup-4352@think> <1302569212.2580.13.camel@mingming-laptop>
	 <20110412005719.GA23077@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:58554 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756907Ab1DNAs6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Apr 2011 20:48:58 -0400
In-Reply-To: <20110412005719.GA23077@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Chris Mason <chris.mason@oracle.com>, Jeff Layton <jlayton@redhat.com>, djwong <djwong@us.ibm.com>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Joel Becker <jlbec@evilplan.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Mingming Cao <mcao@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2011-04-11 at 20:57 -0400, Christoph Hellwig wrote:
> On Mon, Apr 11, 2011 at 05:46:52PM -0700, Mingming Cao wrote:
> > Oh, right. Currently ext4_page_mkwrite drops the page lock before
> > calling it's dirty the page (by write_begin() and write_end().  I
> > suspect regrab the lock() after write_end() (with your proposed change)
> > and returning with locked still leave the dirty by ext4_page_mkwrite
> > unlocked.  We probably should to keep the page locked the page during
> > the entire ext4_page_mkwrite() call. Any reason to drop the page lock()
> > before calling aops->write_begin()?
> 
> write_begin takes the page lock by itself.  That's one of the reasons why
> block_page_mkwrite doesn't use plain ->write_begin / write_end, the
> other beeing that we already get a page passed to use, so there's no
> need to do the pagecache lookup or allocation done by
> grab_cache_page_write_begin.
> 
> The best thing would be to completely drop ext4's current version
> of page_mkwrite and start out with a copy of block_page_mkwrite which
> has the journalling calls added back into it.

The problem is the locking order, we can't hold page lock then start the
journal lock. Kjournald will need to hold the journal lock first, then
commit, commit may need to callback writepages, which need to hold the
page lock.


I looked at ext3, in that case, ext3 even don't have ext3_page_mkwrite()
to do the stable page yet. It requires some block reservation/delayed
allocation for filling holes in mmaped IO case. Jan tried that before I
don't think the proposal get far.


Now looking back ext4_page_mkwrite(), it calls write_begin(), as long as
we do wait in write_begin() things would be fine, right? It seems
Darrick already did that wait per Dave Chinner's suggestion when grab
the page and lock that page. But still a puzzle to me why that's not
sufficient.


Mingming
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


