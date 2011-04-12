From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [RFC] block integrity: Fix write after checksum calculation
 problem
Date: Mon, 11 Apr 2011 17:46:52 -0700
Message-ID: <1302569212.2580.13.camel@mingming-laptop>
References: <20110224182732.GV27190@tux1.beaverton.ibm.com>
	 <1298897186-sup-9394@think> <20110304210724.GF27190@tux1.beaverton.ibm.com>
	 <20110308045626.GD1956@dastard>
	 <20110319000755.GD1110@tux1.beaverton.ibm.com>
	 <20110321140451.GA7153@quack.suse.cz> <1300716666-sup-2087@think>
	 <20110321164305.GC7153@quack.suse.cz>
	 <20110406232938.GF1110@tux1.beaverton.ibm.com>
	 <20110407165700.GB7363@quack.suse.cz>
	 <20110408203135.GH1110@tux1.beaverton.ibm.com>
	 <20110411124229.47bc28f6@corrin.poochiereds.net>
	 <1302543595-sup-4352@think>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1302543595-sup-4352@think>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Cc: Jeff Layton <jlayton@redhat.com>, djwong <djwong@us.ibm.com>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Joel Becker <jlbec@evilplan.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Mingming Cao <mcao@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2011-04-11 at 13:41 -0400, Chris Mason wrote:
> Excerpts from Jeff Layton's message of 2011-04-11 12:42:29 -0400:
> > > @@ -5839,6 +5844,15 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
> > >      if (ret < 0)
> > >          goto out_unlock;
> > >      ret = 0;
> > > +
> > > +    /*
> > > +     * write_begin/end might have created a dirty page and someone
> > > +     * could wander in and start the IO.  Make sure that hasn't
> > > +     * happened.
> > > +     */
> > > +    lock_page(page);
> > > +    wait_on_page_writeback(page);
> > > +    unlock_page(page);
> > 

I am little puzzled here. if someone wander in and start the IO, the
page is up-to-date (dirtied by this page_mkwrite). We shouldn't see the
checksum inconsistancy, right?

> > nit:
> > 
> > The callers of page_mkwrite always lock the page afterward if you
> > return from page_mkwrite with it unlocked. If you plan to take page
> > lock anyway, it's probably slightly more efficient not to unlock it and
> > instead return VM_FAULT_LOCKED.
> > 
> 
> Actually this isn't a nit.  Keeping the page locked closes an important
> hole where it can become writeback again.  It might fix the last
> remaining problem.
> 

Oh, right. Currently ext4_page_mkwrite drops the page lock before
calling it's dirty the page (by write_begin() and write_end().  I
suspect regrab the lock() after write_end() (with your proposed change)
and returning with locked still leave the dirty by ext4_page_mkwrite
unlocked.  We probably should to keep the page locked the page during
the entire ext4_page_mkwrite() call. Any reason to drop the page lock()
before calling aops->write_begin()?

Mingming

