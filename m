From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Getting TRIM working
Date: Fri, 6 Mar 2009 12:16:20 -0700
Message-ID: <20090306191620.GA25995@parisc-linux.org>
References: <20090303190700.GD20511@parisc-linux.org> <49AE47DB.4030200@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:43200 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516AbZCFTQY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Mar 2009 14:16:24 -0500
Content-Disposition: inline
In-Reply-To: <49AE47DB.4030200@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Mar 04, 2009 at 11:20:27AM +0200, Boaz Harrosh wrote:
> Matthew Wilcox wrote:
> >         size = ALIGN(i * 8, 512);
> >         memset(buffer + i * 8, 0, size - i * 8);
> >         old_size = bio_iovec(bio)->bv_len;
> > printk("before: bi_size %d, data_len %d, bv_len %d\n", bio->bi_size,
> >                 req->data_len, old_size);
> >         if (size > old_size) {
> >                 bio_add_pc_page(req->q, bio, bio_page(bio),
> >                                         size - old_size, old_size);
> >                 req->data_len = size;
> >         }
> > printk("after: bi_size %d, data_len %d, bv_len %d\n", bio->bi_size,
> >                 req->data_len, bio_iovec(bio)->bv_len);
> > 
> > Now req->data_len, bio->bi_size and bio_iovec(bio)->bv_len are all 512.
> > Yet the AHCI driver still spits out 24 bytes and then stops (which hangs
> > the drive).  What am I missing?
> 
> What about the length embedded in the CDB, which is usually derived from
> scsi_bufflen(), or other places that look at scsi_bufflen() and not at
> request && it's bios. The later might be bigger then scsi's in split commands
> but the drivers should only consume scsi_bufflen() bytes.

A fine idea, completely true ... I fixed it like this:

+       old_size = bio_iovec(bio)->bv_len;
+printk("before: bi_size %d, data_len %d, bv_len %d sdb length %d\n",
+               bio->bi_size, req->data_len, old_size, scmd->sdb.length);
+       if (size > old_size) {
+               bio_add_pc_page(req->q, bio, bio_page(bio),
+                                       size - old_size, old_size);
+       }
+       scmd->sdb.length = req->data_len = size;
+printk("after: bi_size %d, data_len %d, bv_len %d sdb length %d\n",
+               bio->bi_size, req->data_len, bio_iovec(bio)->bv_len,
+               scmd->sdb.length);

and it howed sdb.length being 24 before, and 512 after.

And the damn thing still spit out 24 bytes onto the bus and stopped.

To prove where the bug is, I lied to SCSI.  I changed this:

-       if (bio_add_pc_page(q, bio, page, 24, 0) < 24) {
+       if (bio_add_pc_page(q, bio, page, 512, 0) < 512) {

and we spat out a 512 byte sector to the disc, which accepted it and
erased the trimmed sector.  Yay.

So we can go back to looking for a *fifth* place where we store the
length of the data we're transferring.  I'm not convinced this says good
things about our storage stack that we have so many places where we
store the length.  There's more than this of course, because there's
ATA's qc->nbytes, and tf->nsect+hob_nsect, but I already set those
correctly.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
