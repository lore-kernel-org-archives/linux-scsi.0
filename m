From: Christoph Hellwig <hch@lst.de>
Subject: Re: SCSI regression in 4.11
Date: Thu, 2 Mar 2017 01:56:15 +0100
Message-ID: <20170302005615.GA23687@lst.de>
References: <c1949de0-8b95-e254-1bec-bcdae762890f@kernel.dk> <1488301573.3046.9.camel@linux.vnet.ibm.com> <20170228105741.6253bb8a@xeon-e3> <1488325732.11610.9.camel@linux.vnet.ibm.com> <20170228172532.280811ed@xeon-e3> <1488349258.20321.11.camel@linux.vnet.ibm.com> <20170228224845.1da358ee@xeon-e3> <20170301155057.GA13167@lst.de> <20170301075412.2e5f1e98@xeon-e3> <20170302000135.GA22886@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:53917 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753735AbdCBA4u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 1 Mar 2017 19:56:50 -0500
Content-Disposition: inline
In-Reply-To: <20170302000135.GA22886@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, Jens Axboe <axboe@kernel.dk>, Linus Torvalds <torvalds@linux-foundation.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, Josh Poulson <jopoulso@microsoft.com>, v-adsuho@microsoft.com, linux-scsi@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>

On Thu, Mar 02, 2017 at 01:01:35AM +0100, Christoph Hellwig wrote:
> On Wed, Mar 01, 2017 at 07:54:12AM -0800, Stephen Hemminger wrote:
> > > 	http://git.infradead.org/users/hch/block.git/commitdiff/148cff67b401e2229c076c0ea418712654be77e4
> > 
> > It appears that is already in the code I am testing in linux-next...
> 
> It's in -next now, but it wasn't at the time you reported the bug.
> 
> And it would sortof explain the bug if the INQUIRY data is correct
> in the scatterlist, but we ignore it, given that scsi_probe_lun
> ignores the result based on sense data.
> 
> Can you check what happens with the horrible hack below:

Strike that - we're checking result later, so this can't be the case.

Now the other interesting thing is the memset in __scsi_exectute,
which looks very suspicious.  Try the following please:

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 3e32dc954c3c..22f4fb550561 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -253,7 +253,8 @@ static int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 	 * and prevent security leaks by zeroing out the excess data.
 	 */
 	if (unlikely(rq->resid_len > 0 && rq->resid_len <= bufflen))
-		memset(buffer + (bufflen - rq->resid_len), 0, rq->resid_len);
+//		memset(buffer + (bufflen - rq->resid_len), 0, rq->resid_len);
+		printk_ratelimited("%s: got resid %d\n", __func__, rq->resid_len);
 
 	if (resid)
 		*resid = rq->resid_len;
