From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 00/13] st: remove scsi_execute_async usage (the second
 half)
Date: Wed, 17 Dec 2008 20:20:33 +0900
Message-ID: <20081217202122D.fujita.tomonori@lab.ntt.co.jp>
References: <alpine.LNX.2.00.0812152138090.6315@kai.makisara.local>
	<20081217025655O.fujita.tomonori@lab.ntt.co.jp>
	<alpine.LNX.2.00.0812162222110.6348@kai.makisara.local>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:32783 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbYLQLUv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Dec 2008 06:20:51 -0500
In-Reply-To: <alpine.LNX.2.00.0812162222110.6348@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, jens.axboe@oracle.com

On Tue, 16 Dec 2008 22:35:07 +0200 (EET)
Kai Makisara <Kai.Makisara@kolumbus.fi> wrote:

> > Can you replace the first and second patches in the patchset with the
> > following patch (that is, scsi-misc and this patch + #3-13 patches in
> > the patchset)?
> > 
> 
> I did this and have done both the basic tests and tests with big block 
> sizes. No problems and data corruption seen so far.

Thanks for testing!


> However, one thing 
> puzzles me: today trying block size above 6144 kB returns EBUSY whereas 
> yesterday I could use 16000 kB (although with data corruption but this 
> should be fixed by your new patch that increments the offset between 
> bios)?

Can you check where the error happened?

If the error happened in ll_back_merge_fn via blk_rq_append_bio
(EINVAL), it might be due to the following fix (which I put in the
patch) :

http://marc.info/?l=linux-scsi&m=122927795113939&w=2

This patch should do the right thing but this leads to more
segments. But if your scsi host enables use_clustering, the error
should not happen there.


BTW, st driver in 2.6.27 can handle 16000 kB?


> I will do some more tests tomorrow but your code looks really good.

Thanks a lot!
