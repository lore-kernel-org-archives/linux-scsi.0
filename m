From: Vasu Dev <vasu.dev@linux.intel.com>
Subject: Re: [PATCH] scsi, mptsas : drop scsi_host lock when calling
 mptsas_qcmd
Date: Thu, 16 Sep 2010 14:31:31 -0700
Message-ID: <1284672691.30345.53.camel@vi2.jf.intel.com>
References: <1284666254.7280.54.camel@schen9-DESK>
	 <1284670136.13344.93.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:31613 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601Ab0IPVbd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Sep 2010 17:31:33 -0400
In-Reply-To: <1284670136.13344.93.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, Eric Moore <Eric.Moore@lsi.com>, linux-scsi@vger.kernel.org, vasu.dev@intel.com, ak@linux.intel.com, willy@linux.intel.com, devel@open-fcoe.org

On Thu, 2010-09-16 at 13:48 -0700, Nicholas A. Bellinger wrote:
> On Thu, 2010-09-16 at 12:44 -0700, Tim Chen wrote:
> > During testing of FFSB benchmark (configured with 
> > 128 threaded write to 128 files on 16 SSD), scsi_host lock was 
> > heavily contended, accounting for 23.7% of cpu cycles.  There
> > are 64 cores in our test system and the JBOD
> > is connected with a mptsas HBA.  Taking a similar approach
> > as the patch by Vasu (http://permalink.gmane.org/gmane.linux.scsi.open-fcoe.devel/10110)
> > for Fiber Channel adapter, the following patch on 2.6.35 kernel 
> > avoids taking the scsi host lock when queueing mptsas scsi command. We see
> > a big drop in the cpu cycles contending for the lock (from 23.7% to 1.8%).  
> > The number of IO per sec increase by 10.6% from 62.9K per sec to 69.6K per sec.
> > 
> > If there is no good reason to prevent mptsas_qcmd from being 
> > executed in parallel, we should remove this lock from the queue 
> > command code path.  Other adapters probably can
> > benefit in a similar manner.
> > 
> > 
> >                         %cpu cycles contending host lock
> >                         2.6.35		2.6.35+patch
> > -----------------------------------------------------
> > scsi_dispatch_cmd       5.5%		0.44%
> > scsi_device_unbusy      6.1%		0.66%
> > scsi_request_fn         6.6%		0.35%
> > scsi_run_queue          5.5%		0.35%
> > 
> > 
> 
> Hi Tim and Co,
> 
> Many Thanks for posting these very interesting numbers with
> unlocked_qcmds=1 + mpt-fusion SCSI LLD on a 64-core system..  Wow.. 8-)
> 

I echo same, thanks Tim for these detailed numbers.

> I asked James about getting Vasu's unlocked_qcmds=1 patch merged, but he
> convinced me that doing conditional locking while is very simple, is not
> the proper way for getting this resolved in mainline code.  I think in
> the end this will require a longer sit down to do a wholesale conversion
> of all existing SCSI LLD drivers, and identifing the broken ones that
> still need a struct Scsi_Host->host_lock'ed SHT->queuecommand() for
> whatever strange & legacy reasons.
> 

I think doing few LLDs first and resolving any new issues caused by no
host_lock in those LLD would have helped with wholesale conv, beside if
a simple change helps perf now then should be good to have till
wholesale change done. However I'm also fine jumping to wholesale
approach directly.

> While there are still some outstanding TCM items that need to be
> resolved in the next days, I am very interested to help make the
> wholesale host_lock + ->queuecomamnd() conversion happen.  I will get a
> lio-core-2.6.git branch setup for this purpose on .36-rc4 soon and start
> working on the main SCSI Mid-layer conversion pieces sometime next week.
> I am very eager to accept patches on a per LLD basis for this work, and
> will be starting with the open-fcoe initiator, TCM_Loop, mpt2sas, and
> open-iscsi.
> 
> I think the wholesole conversion is going to be pretty straight-forward,
> and at least with the main SCSI LLDs (that we really care about ;) there
> appear to be no immediate issues with a full conversion.
> 

Sounds good, I wish I could help with that now but won't be able to till
Dec since heading for sabbatical this week.

	Thanks 
	Vasu


