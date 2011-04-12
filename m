From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] block integrity: Fix write after checksum calculation
 problem
Date: Mon, 11 Apr 2011 20:57:19 -0400
Message-ID: <20110412005719.GA23077@infradead.org>
References: <20110319000755.GD1110@tux1.beaverton.ibm.com>
 <20110321140451.GA7153@quack.suse.cz>
 <1300716666-sup-2087@think>
 <20110321164305.GC7153@quack.suse.cz>
 <20110406232938.GF1110@tux1.beaverton.ibm.com>
 <20110407165700.GB7363@quack.suse.cz>
 <20110408203135.GH1110@tux1.beaverton.ibm.com>
 <20110411124229.47bc28f6@corrin.poochiereds.net>
 <1302543595-sup-4352@think>
 <1302569212.2580.13.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1302569212.2580.13.camel@mingming-laptop>
Sender: linux-kernel-owner@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Cc: Chris Mason <chris.mason@oracle.com>, Jeff Layton <jlayton@redhat.com>, djwong <djwong@us.ibm.com>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Joel Becker <jlbec@evilplan.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Mingming Cao <mcao@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Apr 11, 2011 at 05:46:52PM -0700, Mingming Cao wrote:
> Oh, right. Currently ext4_page_mkwrite drops the page lock before
> calling it's dirty the page (by write_begin() and write_end().  I
> suspect regrab the lock() after write_end() (with your proposed change)
> and returning with locked still leave the dirty by ext4_page_mkwrite
> unlocked.  We probably should to keep the page locked the page during
> the entire ext4_page_mkwrite() call. Any reason to drop the page lock()
> before calling aops->write_begin()?

write_begin takes the page lock by itself.  That's one of the reasons why
block_page_mkwrite doesn't use plain ->write_begin / write_end, the
other beeing that we already get a page passed to use, so there's no
need to do the pagecache lookup or allocation done by
grab_cache_page_write_begin.

The best thing would be to completely drop ext4's current version
of page_mkwrite and start out with a copy of block_page_mkwrite which
has the journalling calls added back into it.
