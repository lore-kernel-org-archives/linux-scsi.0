From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] scsi, mptsas : drop scsi_host lock when calling
 mptsas_qcmd
Date: Fri, 17 Sep 2010 08:19:46 -0400
Message-ID: <1284725986.26423.64.camel@mulgrave.site>
References: <1284666254.7280.54.camel@schen9-DESK>
	 <1284670136.13344.93.camel@haakon2.linux-iscsi.org>
	 <20100916212530.GA22051@gargoyle.ger.corp.intel.com>
	 <4C929368.4040903@cisco.com> <1284675416.26423.47.camel@mulgrave.site>
	 <20100917071656.GA2644@gargoyle.ger.corp.intel.com>
	 <AANLkTikDSbzqJHLToz9L7VhOtifzUANomYBBbbbEHBwt@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55108 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752800Ab0IQMTx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Sep 2010 08:19:53 -0400
In-Reply-To: <AANLkTikDSbzqJHLToz9L7VhOtifzUANomYBBbbbEHBwt@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Andi Kleen <ak@linux.intel.com>, Joe Eykholt <jeykholt@cisco.com>, Tim Chen <tim.c.chen@linux.intel.com>, Eric Moore <Eric.Moore@lsi.com>, linux-scsi@vger.kernel.org, vasu.dev@intel.com, willy@linux.intel.com

On Fri, 2010-09-17 at 12:32 +0200, Bart Van Assche wrote:
> On Fri, Sep 17, 2010 at 9:16 AM, Andi Kleen <ak@linux.intel.com> wrote:
> >
> > > Not really ... look at the code path (in scsi.c:scsi_dispatch_cmd()).
> > > We take the lock, then get the serial number (that would likley have to
> > > be replaced with an atomic), check the state, call trace, call
> >
> > An atomic unfortunately usually doesn't scale much better than a spinlock.
> > I suspect serials would need to be made optional, e.g.
> > computing them lazily if really needed.
> 
> We should be careful that the command processing order for commands
> issued by different threads is not altered by removing the host lock,
> at least for those SCSI commands where in-order processing matters.
> There might be better solutions than a serial number though.

We don't actually make any ordering guarantees at the top of the stack.
The block layer originally did need internal ordering guarantees for
barriers, but they were automatically preserved by the fact that the
exit from the ioscheduler is single threaded.

However, the barrier redo means that we no longer even need the single
threaded guarantee ... and I suspect Jens is already thinking about
multi threading the ioscheduler exit, which is also another good reason
for reducing the locking footprint.

James


