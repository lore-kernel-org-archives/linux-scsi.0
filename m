From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCHSET v3.1 0/7] data integrity: Stabilize pages during
 writeback for various fses
Date: Tue, 10 May 2011 18:22:37 +0200
Message-ID: <20110510162237.GM4402@quack.suse.cz>
References: <20110509230318.19566.66202.stgit@elm3c44.beaverton.ibm.com>
 <87tyd31fkc.fsf@devron.myhome.or.jp>
 <20110510123819.GB4402@quack.suse.cz>
 <87hb924s2x.fsf@devron.myhome.or.jp>
 <20110510132953.GE4402@quack.suse.cz>
 <878vue4qjb.fsf@devron.myhome.or.jp>
 <87zkmu3b2i.fsf@devron.myhome.or.jp>
 <20110510145421.GJ4402@quack.suse.cz>
 <87zkmupmaq.fsf@devron.myhome.or.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87zkmupmaq.fsf@devron.myhome.or.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Jan Kara <jack@suse.cz>, "Darrick J. Wong" <djwong@us.ibm.com>, Theodore Tso <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jeff Layton <jlayton@redhat.com>, Dave Chinner <david@fromorbit.com>, linux-kernel <linux-kernel@vger.kernel.org>, Dave Hansen <dave@linux.vnet.ibm.com>, Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, Chris Mason <chris.mason@oracle.com>, Joel Becker <jlbec@evilplan.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4@vger.kernel.org, Mingming Cao <mcao@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Wed 11-05-11 01:12:13, OGAWA Hirofumi wrote:
> Jan Kara <jack@suse.cz> writes:
> 
> >> Did you already consider, to copy only if page was writeback (like
> >> copy-on-write)? I.e. if page is on I/O, copy, then switch the page for
> >> writing new data.
> >   Yes, that was considered as well. We'd have to essentially migrate the
> > page that is under writeback and should be written to. You are going to pay
> > the cost of page allocation, copy, increased memory & cache pressure.
> > Depending on your backing storage and workload this may or may not be better
> > than waiting for IO...
> 
> Maybe possible, but you really think on usual case just blocking is
> better?
  Define usual case... As Christoph noted, we don't currently have a real
practical case where blocking would matter (since frequent rewrites are
rather rare). So defining what is usual when we don't have a single real
case is kind of tough ;)

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
