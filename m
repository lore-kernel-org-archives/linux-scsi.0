From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] scsi, mptsas : drop scsi_host lock when calling
	mptsas_qcmd
Date: Thu, 16 Sep 2010 17:13:45 -0700
Message-ID: <1284682425.13344.130.camel@haakon2.linux-iscsi.org>
References: <1284666254.7280.54.camel@schen9-DESK>
	 <1284670136.13344.93.camel@haakon2.linux-iscsi.org>
	 <20100916212530.GA22051@gargoyle.ger.corp.intel.com>
	 <1284672287.26423.41.camel@mulgrave.site>
	 <20100916232506.GA19476@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp101.sbc.mail.re3.yahoo.com ([66.196.96.84]:43073 "HELO
	smtp101.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753745Ab0IQARz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Sep 2010 20:17:55 -0400
In-Reply-To: <20100916232506.GA19476@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@suse.de>, Andi Kleen <ak@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Eric Moore <Eric.Moore@lsi.com>, linux-scsi@vger.kernel.org, vasu.dev@intel.com, willy@linux.intel.com

On Thu, 2010-09-16 at 19:25 -0400, Christoph Hellwig wrote:
> On Thu, Sep 16, 2010 at 05:24:47PM -0400, James Bottomley wrote:
> > > into the drivers (similar to how it has been done with the BKL).
> > > This would be a fairly mechanic mindless patch. Lots of typing,
> > > but not really a lot of real code review needed.
> > > 
> > > Then next step the drivers who know they don't want it can remove it.
> > 
> > Yes, that's basically what Christoph did when he moved the lock out of
> > the eh path.
> 
> And it is what we should do here as well.  I'm just wondering if we rely
> on the fact that we hold the lock over the check for the device beeing
> deleted and the queuecommand call.
> 

Ugh, I completely forgot the about the (host->shost_state == SHOST_DEL)
check in scsi_dispatch_cmd() in patch #1, and just fixed this in
lio-core-2.6.git/drop-host_lock here:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=commitdiff;h=e222907d9baac56425f87c602acdd757dc5fde08

Here is what the updated scsi_dispatch_cmd() now looks like:

	<SNIP>

        spin_lock_irqsave(host->host_lock, flags);
        /*
         * AK: unlikely race here: for some reason the timer could
         * expire before the serial number is set up below.
         *
         * TODO: kill serial or move to blk layer
         */
        scsi_cmd_get_serial(host, cmd);

        if (unlikely(host->shost_state == SHOST_DEL)) {
                spin_unlock_irqrestore(host->host_lock, flags);
                cmd->result = (DID_NO_CONNECT << 16);
                scsi_done(cmd);
        } else {
                spin_unlock_irqrestore(host->host_lock, flags);
                trace_scsi_dispatch_cmd_start(cmd);
                rtn = host->hostt->queuecommand(cmd, scsi_done);
        }

	<SNIP>

Thanks!

--nab


