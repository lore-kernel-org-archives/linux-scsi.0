From: Meelis Roos <mroos@linux.ee>
Subject: Re: bisected regression: qla2xxx endianness on sparc64
Date: Mon, 3 Nov 2014 23:32:14 +0200 (EET)
Message-ID: <alpine.LRH.2.11.1411032330370.19361@siim2.ut.ee>
References: <alpine.DEB.2.03.1411022004230.3979@cyber.ee> <alpine.OSX.2.00.1411031508560.1960@administrators-macbook-pro.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:37169 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591AbaKCVas (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Nov 2014 16:30:48 -0500
In-Reply-To: <alpine.OSX.2.00.1411031508560.1960@administrators-macbook-pro.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: Joe Carnuccio <joe.carnuccio@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Christoph Hellwig <hch@lst.de>, qla2xxx-upstream@qlogic.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

> > Between 3.17 and 3.18-rc2, qla2xxx is broken on my sparc64 machines. It
> > fails to boot (hangs in firmware rings init).
> >
> > This is the result of bisect:
> >
> > 98aee70d19a7e3203649fa2078464e4f402a0ad8 is the first bad commit
> > commit 98aee70d19a7e3203649fa2078464e4f402a0ad8
> > Author: Joe Carnuccio <joe.carnuccio@qlogic.com>
> > Date:   Thu Sep 25 05:16:38 2014 -0400
> >
> >    qla2xxx: Add endianizer to max_payload_size modifier.
> >
> >    Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
> >    Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
> >    Signed-off-by: Christoph Hellwig <hch@lst.de>
> >
> > :040000 040000 041c1a26dc2a7988900acc982e3bd65d3cf7e751 
> > 9700d09c3226fc352d44352f22b84f1be632d324 M  s
> >
> > This may not be the only problem - when bisecting, I also came to commits
> > that got past this step but hang after about 165 seconds of uptime while
> > running userspace startup scripts. But let that be another issue at the
> > moment.
> >
> 
> We should revert that change. What were some of the other failures you were
> seeing?

Yes. I took the same 3.18.0-rc1-00422-g2cc9188-dirty kernel that had 
just this patch reverted, it started the controller fine, detected disk, 
mounted root, started multiple tasks and then some time after startin 
exim it just hangs. This is consisten with what I saw during bisection.

-- 
Meelis Roos (mroos@linux.ee)
