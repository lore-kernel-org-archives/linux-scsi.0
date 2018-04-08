From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: 4.15.14 crash with iscsi target and dvd
Date: Sun, 8 Apr 2018 12:02:54 -0400
Message-ID: <20180408160254.GA22869@animx.eu.org>
References: <b68bf187c9cde1c36489fc5ab2187ca8750a1292.camel@wdc.com>
 <20180401113721.GA8471@animx.eu.org>
 <20180401163604.GB25011@animx.eu.org>
 <20180401182723.GA31755@animx.eu.org>
 <595a10cfb387e6b2ab4d2053b84fed9b3da9e079.camel@wdc.com>
 <20180406014644.GA16112@animx.eu.org>
 <20180406020651.GB16112@animx.eu.org>
 <fb0640c203409a84ab1bfbbc41078a5416138ad2.camel@wdc.com>
 <20180407165335.GA2515@animx.eu.org>
 <1ff8d234cc565ba9701ce31899fca5faa597e050.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1ff8d234cc565ba9701ce31899fca5faa597e050.camel@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "richard.weinberger@gmail.com" <richard.weinberger@gmail.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Bart Van Assche wrote:
> On Sat, 2018-04-07 at 12:53 -0400, Wakko Warner wrote:
> > Bart Van Assche wrote:
> > > On Thu, 2018-04-05 at 22:06 -0400, Wakko Warner wrote:
> > > > I know now why scsi_print_command isn't doing anything.  cmd->cmnd is null.
> > > > I added a dev_printk in scsi_print_command where the 2 if statements return.
> > > > Logs:
> > > > [  29.866415] sr 3:0:0:0: cmd->cmnd is NULL
> > > 
> > > That's something that should never happen. As one can see in
> > > scsi_setup_scsi_cmnd() and scsi_setup_fs_cmnd() both functions initialize
> > > that pointer. Since I have not yet been able to reproduce myself what you
> > > reported, would it be possible for you to bisect this issue? You will need
> > > to follow something like the following procedure (see also
> > > https://git-scm.com/docs/git-bisect):
> > 
> > After doing 3 successful compiles with good/bad, I got this error and was
> > not able to compile any more kernels:
> >   CC      scripts/mod/devicetable-offsets.s
> > scripts/mod/empty.c:1:0: error: code model kernel does not support PIC mode
> >  /* empty file to figure out endianness / word size */
> >  
> > scripts/mod/devicetable-offsets.c:1:0: error: code model kernel does not support PIC mode
> >  #include <linux/kbuild.h>
> >  
> > scripts/Makefile.build:153: recipe for target 'scripts/mod/devicetable-offsets.s' failed
> > 
> > I don't think it found the bad commit.
> 
> Have you tried to modify the kernel Makefile as indicated in the following
> e-mail? This should make the kernel build:
> 
> https://lists.ubuntu.com/archives/kernel-team/2016-May/077178.html

Thanks.  That helped.

I finished with git bisect.  Here's the output:
84c8590646d5b35804bac60eb58b145839b5893e is the first bad commit
commit 84c8590646d5b35804bac60eb58b145839b5893e
Author: Ming Lei <tom.leiming@gmail.com>
Date:   Fri Nov 11 20:05:32 2016 +0800

    target: avoid accessing .bi_vcnt directly
    
    When the bio is full, bio_add_pc_page() will return zero,
    so use this information tell when the bio is full.
    
    Also replace access to .bi_vcnt for pr_debug() with bio_segments().
    
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Ming Lei <tom.leiming@gmail.com>
    Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
    Signed-off-by: Jens Axboe <axboe@fb.com>

:040000 040000 a3ebbb71c52ee4eb8c3be4d033b81179211bf704 de39a328dbd1b18519946b3ad46d9302886e0dd0 M      drivers

I did a diff between HEAD^ and HEAD and manually patched the file from
4.15.14.  It's not an exact revert.  I'm running it now and it's working.
I'll do a better test later on.  Here's the patch:

--- a/drivers/target/target_core_pscsi.c	2018-02-04 14:31:31.077316617 -0500
+++ b/drivers/target/target_core_pscsi.c	2018-04-08 11:43:49.588641374 -0400
@@ -915,7 +915,9 @@
 					bio, page, bytes, off);
 			pr_debug("PSCSI: bio->bi_vcnt: %d nr_vecs: %d\n",
 				bio_segments(bio), nr_vecs);
-			if (rc != bytes) {
+			if (rc != bytes)
+				goto fail;
+			if (bio->bi_vcnt > nr_vecs) {
 				pr_debug("PSCSI: Reached bio->bi_vcnt max:"
 					" %d i: %d bio: %p, allocating another"
 					" bio\n", bio->bi_vcnt, i, bio);

I really appreciate your time and assistance with this.

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
