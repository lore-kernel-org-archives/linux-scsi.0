From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [BUG] 2.6.29-rc6-2450cf in scsi_lib.c (was: Large amount of
	scsi-sgpool)objects
Date: Wed, 04 Mar 2009 12:55:06 -0600
Message-ID: <1236192906.18999.5.camel@localhost.localdomain>
References: <alpine.LSU.2.00.0903030220050.2438@fbirervta.pbzchgretzou.qr>
	 <49ACF8FE.2020904@panasas.com>
	 <1236093718.3263.3.camel@localhost.localdomain>
	 <alpine.LSU.2.00.0903031703270.855@fbirervta.pbzchgretzou.qr>
	 <1236097526.3263.17.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0903031818230.29264@localhost.localdomain>
	 <alpine.LFD.2.00.0903032247170.29264@localhost.localdomain>
	 <1236119195.24019.24.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0903040249460.29264@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0903040249460.29264@localhost.localdomain>
Sender: linux-ide-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jan Engelhardt <jengelh@medozas.de>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2009-03-04 at 03:01 +0100, Thomas Gleixner wrote: 
> On Tue, 3 Mar 2009, James Bottomley wrote:
> 
> > On Tue, 2009-03-03 at 23:07 +0100, Thomas Gleixner wrote:
> > > On Tue, 3 Mar 2009, Thomas Gleixner wrote:
> > > > My bad. I was playing with that to get rid of the aic7xxx wreckage on
> > > > one of my test boxen and forgot to remove it.
> > > 
> > > While the one below is definitey not my fault. It's on Linus latest:
> > > 
> > >  commit 2450cf51a1bdba7037e91b1bcc494b01c58aaf66
> > > 
> > > While compiling a kernel I triggerred the BUG below. Not so nice as it
> > > took a whole filesystem with it. fsck took more than 20 min to recover
> > > the leftovers :(
> > > 
> > > Thanks,
> > > 
> > > 	tglx
> > > 
> > > 
> > > ------------[ cut here ]------------
> > > kernel BUG at /home/tglx/work/kernel/git/linux-2.6/drivers/scsi/scsi_lib.c:1141!
> > 
> > This is BUG_ON(count > sdb->table.nents);
> > 
> > It looks like the sg list got split and grew in size ... I suspect this
> > might be libata related, so cc'ing the ide list.  I suspect either the
> > block layer initially parametrised this wrongly (tomo bug) or a sg list
> > got split then requeued (something in libata?).
> 
> FYI, after I've lost a full day of work including the results of four
> "iozone -a -g 4G" runs I tried to reproduce the problem on that
> machine - the leftovers of the filesystem are pretty useless anyway.
> 
> It took about 2hrs to trigger the bug again. Same back trace.
> 
> Anything I can do what might help to decode the problem ?

I discussed this with Fujita Tomonori ... we think it's probably in the
generic block merging code. 

Could you run with this debugging code added until the fault triggers so
we can get an exact view of what the layout of the request is and why
we're getting an extra segment on mapping?

Thanks,

James

P.S. I think if you take the BUG() statement out, as long as it's only
one segment over, the machine should stay up long enough for a clean
shutdown.

---

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 940dc32..5219153 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1139,7 +1139,33 @@ static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb,
 	 * each segment.
 	 */
 	count = blk_rq_map_sg(req->q, req, sdb->table.sgl);
-	BUG_ON(count > sdb->table.nents);
+	if (unlikely(count > sdb->table.nents)) {
+		struct bio_vec *bvec;
+		struct req_iterator iter;
+		struct scatterlist *sg;
+		int i=0;
+
+		printk(KERN_ERR "MAPPING miscount %d phys maps to %d\n",
+		       sdb->table.nents, count);
+		blk_dump_rq_flags(req, "Request Flags");
+		
+		printk("DUMPING REQUEST LIST:\n");
+		rq_for_each_segment(bvec, req, iter) {
+			printk("[%d]: phys 0x%lx len 0x%x\n", i,
+			       (unsigned long)page_to_phys(bvec->bv_page) + bvec->bv_offset,
+			       bvec->bv_len);
+			i++;
+		}
+		printk("DUMPING MAPPED LIST:\n");
+		for_each_sg(sdb->table.sgl, sg, count, i) {
+			printk("[%d]: phys 0x%lx len 0x%x\n", i,
+			       (unsigned long)page_to_phys(sg_page(sg)) + sg->offset,
+			       sg->length);
+		}
+		BUG();
+	}
+			
+
 	sdb->table.nents = count;
 	if (blk_pc_request(req))
 		sdb->length = req->data_len;


