From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PREEMPT-RT] [REEEEPOST] bnx2i + bnx2fc: convert to generic
 workqueue (#3)
Date: Wed, 17 May 2017 19:18:34 +0200
Message-ID: <20170517171834.v6fwbz6rh4slmqc5@linutronix.de>
References: <20170410171254.30367-1-bigeasy@linutronix.de>
 <20170504174427.6hebbnqwfgems6dg@linutronix.de>
 <yq1inlass3y.fsf@oracle.com>
 <alpine.OSX.2.00.1705091015070.1067@administrators-MacBook-Pro.local>
 <1494343100.2688.34.camel@linux.vnet.ibm.com>
 <alpine.OSX.2.00.1705121149580.1329@n6024mn55p0yw1.qlogic.org>
 <20170517150153.2eamcjtc4frx2cae@linutronix.de>
 <20170517150734.dkfghfgd4v4ucttf@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:47281 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754290AbdEQRSn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 May 2017 13:18:43 -0400
Content-Disposition: inline
In-Reply-To: <20170517150734.dkfghfgd4v4ucttf@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@cavium.com>
Cc: Chris Leech <cleech@redhat.com>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Chad Dupuis <chad.dupuis@qlogic.com>, rt@linutronix.de, Lee Duncan <lduncan@suse.com>, QLogic-Storage-Upstream@qlogic.com, Andrew Morton <akpm@linux-foundation.org>, Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>

On 2017-05-17 17:07:34 [+0200], To Chad Dupuis wrote:
> > > Sebastian, can you add this change to your patch set?
> > 
> > Are sure that you can reliably reproduce the issue and fix it with the
> > patch above? Because this patch:
> 
> oh. Okay. Now it clicked. It can fix the issue but it is still possible,
> that CPU0 goes down between your check for it and schedule_work_on()
> returning. Let my think of something…

Oh wait. I already thought about this: it may take bnx2fc_percpu from
CPU7 and run the worker on CPU3. The job isn't lost, because the worker
does:

| static void bnx2fc_percpu_io_work(struct work_struct *work_s)
| {
|         struct bnx2fc_percpu_s *p;
 …
|         p = container_of(work_s, struct bnx2fc_percpu_s, work);
| 
|         spin_lock_bh(&p->fp_work_lock);

and so will access bnx2fc_percpu of CPU7 running on CPU3. So I *think*
that your patch should make no difference and there should be no leak if
schedule_work_on() is invoked on an offline CPU.
 
Sebastian
