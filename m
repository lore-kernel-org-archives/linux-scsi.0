From: Martin Steigerwald <martin@lichtvoll.de>
Subject: Re: [PATCH V6 0/6] block/scsi: safe SCSI quiescing
Date: Fri, 29 Sep 2017 20:47:39 +0200
Message-ID: <1804911.p91Gr6EUMj@merkaba>
References: <20170927054853.6647-1-ming.lei@redhat.com> <2609507.GN6GkCGlmM@merkaba> <20170927082751.GA7464@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:38119 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751920AbdI2Srl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Sep 2017 14:47:41 -0400
In-Reply-To: <20170927082751.GA7464@ming.t460p>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Johannes Thumshirn <jthumshirn@suse.de>, Cathy Avery <cavery@redhat.com>

Ming Lei - 27.09.17, 16:27:
> On Wed, Sep 27, 2017 at 09:57:37AM +0200, Martin Steigerwald wrote:
> > Hi Ming.
> > 
> > Ming Lei - 27.09.17, 13:48:
> > > Hi,
> > > 
> > > The current SCSI quiesce isn't safe and easy to trigger I/O deadlock.
> > > 
> > > Once SCSI device is put into QUIESCE, no new request except for
> > > RQF_PREEMPT can be dispatched to SCSI successfully, and
> > > scsi_device_quiesce() just simply waits for completion of I/Os
> > > dispatched to SCSI stack. It isn't enough at all.
> > > 
> > > Because new request still can be comming, but all the allocated
> > > requests can't be dispatched successfully, so request pool can be
> > > consumed up easily.
> > > 
> > > Then request with RQF_PREEMPT can't be allocated and wait forever,
> > > meantime scsi_device_resume() waits for completion of RQF_PREEMPT,
> > > then system hangs forever, such as during system suspend or
> > > sending SCSI domain alidation.
> > > 
> > > Both IO hang inside system suspend[1] or SCSI domain validation
> > > were reported before.
> > > 
> > > This patch introduces preempt only mode, and solves the issue
> > > by allowing RQF_PREEMP only during SCSI quiesce.
> > > 
> > > Both SCSI and SCSI_MQ have this IO deadlock issue, this patch fixes
> > > them all.
> > > 
> > > V6:
> > > 	- borrow Bart's idea of preempt only, with clean
> > > 	
> > > 	  implementation(patch 5/patch 6)
> > > 	
> > > 	- needn't any external driver's dependency, such as MD's
> > > 	change
> > 
> > Do you want me to test with v6 of the patch set? If so, it would be nice
> > if
> > you´d make a v6 branch in your git repo.
> 
> Hi Martin,
> 
> I appreciate much if you may run V6 and provide your test result,
> follows the branch:
> 
> https://github.com/ming1/linux/tree/blk_safe_scsi_quiesce_V6
> 
> https://github.com/ming1/linux.git #blk_safe_scsi_quiesce_V6
> 
> > After an uptime of almost 6 days I am pretty confident that the V5 one
> > fixes the issue for me. So
> > 
> > Tested-by: Martin Steigerwald <martin@lichtvoll.de>
> > 
> > for V5.
> 
> Thanks for your test!

Two days and almost 6 hours, no hang yet. I bet the whole thing works. 
(3e45474d7df3bfdabe4801b5638d197df9810a79)

Tested-By: Martin Steigerwald <martin@lichtvoll.de>

(It could still hang after three days, but usually I got the first hang within 
the first two days.)

Thanks,
-- 
Martin
