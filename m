From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 00/13] st: remove scsi_execute_async usage (the second
 half)
Date: Thu, 18 Dec 2008 15:08:43 +0900
Message-ID: <20081218150648P.fujita.tomonori@lab.ntt.co.jp>
References: <alpine.LNX.2.00.0812162222110.6348@kai.makisara.local>
	<20081217202122D.fujita.tomonori@lab.ntt.co.jp>
	<alpine.LNX.2.00.0812172137350.6290@kai.makisara.local>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:33165 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751203AbYLRGM5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Dec 2008 01:12:57 -0500
In-Reply-To: <alpine.LNX.2.00.0812172137350.6290@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, jens.axboe@oracle.com

On Wed, 17 Dec 2008 22:56:47 +0200 (EET)
Kai Makisara <Kai.Makisara@kolumbus.fi> wrote:

> On Wed, 17 Dec 2008, FUJITA Tomonori wrote:
> 
> ...
> > > However, one thing 
> > > puzzles me: today trying block size above 6144 kB returns EBUSY whereas 
> > > yesterday I could use 16000 kB (although with data corruption but this 
> > > should be fixed by your new patch that increments the offset between 
> > > bios)?
> > 
> > Can you check where the error happened?
> > 
> > If the error happened in ll_back_merge_fn via blk_rq_append_bio
> > (EINVAL), it might be due to the following fix (which I put in the
> > patch) :
> > 
> > http://marc.info/?l=linux-scsi&m=122927795113939&w=2
> > 
> > This patch should do the right thing but this leads to more
> > segments. But if your scsi host enables use_clustering, the error
> > should not happen there.
> > 
> > 
> > BTW, st driver in 2.6.27 can handle 16000 kB?
> > 
> I tested 2.6.27.7 and it also maxed out at 6144 kB. The previous version 
> where I successfully tested this was 2.6.15. I remembered that I had to 
> tune some parameters to enable very large transfers. These are summarized 
> in http://marc.info/?l=linux-scsi&m=114147793010513&w=2
> 
> My SCSI HBA is sym53c1010. The driver limits number of s/g segments to 96. 
> Multiplying 64 kB * 96 = 6144 kB. This explains the limit.
> 
> Next I added call
> blk_queue_max_segment_size(sdev->request_queue, 256 * 1024);
> to sym53c8xx_slave_configure(). Now I can read and write 16000 kB records.

I see, thanks.


> > > I will do some more tests tomorrow but your code looks really good.
> > 
> I have done more tests and found only one minor problem. You patch fixes 
> the order in page frames. If one writes first smallish blocks (e.g., 
> label) and then large blocks, allocation may not reach the goal because 
> the order is too small.
> 
> The patch at the end fixes this by retrying allocation from the beginning 
> if the order is too small. The patch also fixes two very old bugs. The 
> maximum order should have been 6. It enables maximum block size allowed by 
> WRITE(6) with 64 segments. The patch also makes enlarge_buffer() return 
> error if the maximum order together with maximum number of s/g segments.
> 
> The patch applies on top of my previous patch removing 
> st_scsi_kern_execute(). Feel free to include these changes into one of 
> your own patches if you wish.

Thanks a lot!

I put both patches to the second version of the patchset.


About the second patch, it might be cleaner to start with MAX_ORDER
and decrease the order like osst? Anyway, it should be a different
cleanup though.
