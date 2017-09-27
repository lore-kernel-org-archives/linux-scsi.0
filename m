From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH V6 0/6] block/scsi: safe SCSI quiescing
Date: Wed, 27 Sep 2017 16:52:41 +0800
Message-ID: <20170927085235.GA14921@ming.t460p>
References: <20170927054853.6647-1-ming.lei@redhat.com>
 <2609507.GN6GkCGlmM@merkaba>
 <20170927082751.GA7464@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45012 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751730AbdI0Iw5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Sep 2017 04:52:57 -0400
Content-Disposition: inline
In-Reply-To: <20170927082751.GA7464@ming.t460p>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Johannes Thumshirn <jthumshirn@suse.de>, Cathy Avery <cavery@redhat.com>

On Wed, Sep 27, 2017 at 04:27:51PM +0800, Ming Lei wrote:
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
> > > 	  implementation(patch 5/patch 6)
> > > 	- needn't any external driver's dependency, such as MD's
> > > 	change
> > 
> > Do you want me to test with v6 of the patch set? If so, it would be nice if 
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

Also follows the branch against V4.13:

https://github.com/ming1/linux/tree/v4.13-safe-scsi-quiesce_V6_for_test

https://github.com/ming1/linux.git #v4.13-safe-scsi-quiesce_V6_for_test

-- 
Ming
