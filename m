From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Getting TRIM working
Date: Sun, 08 Mar 2009 16:24:40 -0500
Message-ID: <1236547480.4861.12.camel@localhost.localdomain>
References: <20090303190700.GD20511@parisc-linux.org>
	 <49AE47DB.4030200@panasas.com> <20090306191620.GA25995@parisc-linux.org>
	 <49B39DCB.3040203@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <49B39DCB.3040203@panasas.com>
Sender: linux-ide-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2009-03-08 at 12:28 +0200, Boaz Harrosh wrote:
> Matthew Wilcox wrote:
> > On Wed, Mar 04, 2009 at 11:20:27AM +0200, Boaz Harrosh wrote:
> >> Matthew Wilcox wrote:
> >>>         size = ALIGN(i * 8, 512);
> >>>         memset(buffer + i * 8, 0, size - i * 8);
> >>>         old_size = bio_iovec(bio)->bv_len;
> >>> printk("before: bi_size %d, data_len %d, bv_len %d\n", bio->bi_size,
> >>>                 req->data_len, old_size);
> >>>         if (size > old_size) {
> >>>                 bio_add_pc_page(req->q, bio, bio_page(bio),
> >>>                                         size - old_size, old_size);
> >>>                 req->data_len = size;
> >>>         }
> >>> printk("after: bi_size %d, data_len %d, bv_len %d\n", bio->bi_size,
> >>>                 req->data_len, bio_iovec(bio)->bv_len);
> >>>
> >>> Now req->data_len, bio->bi_size and bio_iovec(bio)->bv_len are all 512.
> >>> Yet the AHCI driver still spits out 24 bytes and then stops (which hangs
> >>> the drive).  What am I missing?
> >> What about the length embedded in the CDB, which is usually derived from
> >> scsi_bufflen(), or other places that look at scsi_bufflen() and not at
> >> request && it's bios. The later might be bigger then scsi's in split commands
> >> but the drivers should only consume scsi_bufflen() bytes.
> > 
> > A fine idea, completely true ... I fixed it like this:
> > 
> > +       old_size = bio_iovec(bio)->bv_len;
> > +printk("before: bi_size %d, data_len %d, bv_len %d sdb length %d\n",
> > +               bio->bi_size, req->data_len, old_size, scmd->sdb.length);
> > +       if (size > old_size) {
> > +               bio_add_pc_page(req->q, bio, bio_page(bio),
> > +                                       size - old_size, old_size);
> > +       }
> > +       scmd->sdb.length = req->data_len = size;
> > +printk("after: bi_size %d, data_len %d, bv_len %d sdb length %d\n",
> > +               bio->bi_size, req->data_len, bio_iovec(bio)->bv_len,
> > +               scmd->sdb.length);
> > 
> > and it howed sdb.length being 24 before, and 512 after.
> > 
> > And the damn thing still spit out 24 bytes onto the bus and stopped.
> > 
> > To prove where the bug is, I lied to SCSI.  I changed this:
> > 
> > -       if (bio_add_pc_page(q, bio, page, 24, 0) < 24) {
> > +       if (bio_add_pc_page(q, bio, page, 512, 0) < 512) {
> > 
> > and we spat out a 512 byte sector to the disc, which accepted it and
> > erased the trimmed sector.  Yay.
> > 
> > So we can go back to looking for a *fifth* place where we store the
> > length of the data we're transferring.  I'm not convinced this says good
> > things about our storage stack that we have so many places where we
> > store the length.  There's more than this of course, because there's
> > ATA's qc->nbytes, and tf->nsect+hob_nsect, but I already set those
> > correctly.
> > 
> 
> That's because you are doing it at the wrong level at the wrong stage.
> 1. block-level submits a request
> 2. sd/sr or what ever ULD prepares a scsi_cmnd out of request.
>    Request's sizes are only a recommendation. ULD or scsi-ml may
>    prepare a smaller command then request. Once command is prepared
>    request is disregarded, you can bang on it all you want code will
>    not care about it one bit.
> 3. LLD executes the scsi-command (Not the block-request)
> 4. scsi-ml completes command's bytes, at this stage the request might
>    not be over and, and a reminder is re-prepared so the request can
>    be complete.
> 
> The code above scmd->sdb.length = req->data_len = size; is not allowed
> and can cause data leaks.
> 
> You should ping Tejun, block-layer(1) and ATA-LLD(3) has a way to communicate
> alignments and drain buffers that expose some other possible lenght's to ata.
> 
> And to your question the missing length above is probably encoded inside the
> submitted CDB. (scsi_cmnd->cmnd). When you change the length before
> stage (2) it works.
> 
> I think you should be using the drain mechanisms built into ata 

OK, so I think you correctly identified the problem;  I don't quite
think you've identified the solution because draining is all about
disposing of excess data, in particular we only tend to have one drain
area per queue (and there could be multiple outstanding discards).

The problem in the prepare is you need to set up a command with data.
What I'm not quite clear on is why blk_rq_map_kern() on a kmalloc'd
buffer can't be used.  You'd end up with a dual bio request (one for the
discard, one for the data), but they should tear down correctly using
the separate bio teardowns and pass correctly into blk_rq_map_sg() which
was the original point.

James


