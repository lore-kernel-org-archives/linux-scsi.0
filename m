From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [RFC] block integrity: Fix write after checksum calculation problem
Date: Mon, 11 Apr 2011 13:41:16 -0400
Message-ID: <1302543595-sup-4352@think>
References: <20110224182732.GV27190@tux1.beaverton.ibm.com> <1298897186-sup-9394@think> <20110304210724.GF27190@tux1.beaverton.ibm.com> <20110308045626.GD1956@dastard> <20110319000755.GD1110@tux1.beaverton.ibm.com> <20110321140451.GA7153@quack.suse.cz> <1300716666-sup-2087@think> <20110321164305.GC7153@quack.suse.cz> <20110406232938.GF1110@tux1.beaverton.ibm.com> <20110407165700.GB7363@quack.suse.cz> <20110408203135.GH1110@tux1.beaverton.ibm.com> <20110411124229.47bc28f6@corrin.poochiereds.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20110411124229.47bc28f6@corrin.poochiereds.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Layton <jlayton@redhat.com>
Cc: djwong <djwong@us.ibm.com>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Joel Becker <jlbec@evilplan.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Mingming Cao <mcao@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Excerpts from Jeff Layton's message of 2011-04-11 12:42:29 -0400:
> > @@ -5839,6 +5844,15 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
> >      if (ret < 0)
> >          goto out_unlock;
> >      ret = 0;
> > +
> > +    /*
> > +     * write_begin/end might have created a dirty page and someone
> > +     * could wander in and start the IO.  Make sure that hasn't
> > +     * happened.
> > +     */
> > +    lock_page(page);
> > +    wait_on_page_writeback(page);
> > +    unlock_page(page);
> 
> nit:
> 
> The callers of page_mkwrite always lock the page afterward if you
> return from page_mkwrite with it unlocked. If you plan to take page
> lock anyway, it's probably slightly more efficient not to unlock it and
> instead return VM_FAULT_LOCKED.
> 

Actually this isn't a nit.  Keeping the page locked closes an important
hole where it can become writeback again.  It might fix the last
remaining problem.

-chris
