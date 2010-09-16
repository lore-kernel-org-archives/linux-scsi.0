From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] scsi, mptsas : drop scsi_host lock when calling
 mptsas_qcmd
Date: Thu, 16 Sep 2010 18:16:56 -0400
Message-ID: <1284675416.26423.47.camel@mulgrave.site>
References: <1284666254.7280.54.camel@schen9-DESK>
	 <1284670136.13344.93.camel@haakon2.linux-iscsi.org>
	 <20100916212530.GA22051@gargoyle.ger.corp.intel.com>
	 <4C929368.4040903@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33549 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756682Ab0IPWRC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Sep 2010 18:17:02 -0400
In-Reply-To: <4C929368.4040903@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Eykholt <jeykholt@cisco.com>
Cc: Andi Kleen <ak@linux.intel.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Tim Chen <tim.c.chen@linux.intel.com>, Eric Moore <Eric.Moore@lsi.com>, linux-scsi@vger.kernel.org, vasu.dev@intel.com, willy@linux.intel.com

On Thu, 2010-09-16 at 15:00 -0700, Joe Eykholt wrote:
> On 9/16/10 2:25 PM, Andi Kleen wrote:
> >> I asked James about getting Vasu's unlocked_qcmds=1 patch merged, but he
> >> convinced me that doing conditional locking while is very simple, is not
> >> the proper way for getting this resolved in mainline code.  I think in
> >> the end this will require a longer sit down to do a wholesale conversion
> >> of all existing SCSI LLD drivers, and identifing the broken ones that
> >> still need a struct Scsi_Host->host_lock'ed SHT->queuecommand() for
> >> whatever strange & legacy reasons.
> > 
> > The standard way to do that would be to first move the lock down
> > into the drivers (similar to how it has been done with the BKL).
> > This would be a fairly mechanic mindless patch. Lots of typing,
> > but not really a lot of real code review needed.
> > 
> > Then next step the drivers who know they don't want it can remove it.
> > 
> > -Andi
> 
> I see problems with this, but maybe I'm missing something.
> 
> It seems to me we can't completely move the host lock down into the
> drivers since its a shared lock between SCSI and the drivers now.

Not really ... look at the code path (in scsi.c:scsi_dispatch_cmd()).
We take the lock, then get the serial number (that would likley have to
be replaced with an atomic), check the state, call trace, call
queuecommand and drop the lock.  That should be replaceable with a no
lock sequence.

For some of our lower latency drivers, we're also going to have to start
looking at the queue lock->host lock shuffle we do for I/O accounting.

James


