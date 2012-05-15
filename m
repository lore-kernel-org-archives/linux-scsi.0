From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [RFC PATCH 2/3] block: add queue runtime pm callback
Date: Tue, 15 May 2012 23:36:28 +0800
Message-ID: <1337096188.3515.3.camel@chief-river-32>
References: <Pine.LNX.4.44L0.1205151036510.1796-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:3815 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965242Ab2EOPg0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 May 2012 11:36:26 -0400
In-Reply-To: <Pine.LNX.4.44L0.1205151036510.1796-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, 2012-05-15 at 10:37 -0400, Alan Stern wrote:
> On Tue, 15 May 2012, Lin Ming wrote:
> 
> > Add ->runtime_pm callback and ->pm_status to request queue.
> > As an example, implement a simple queue runtime_pm callback
> > in sd driver.
> 
> > +static int sd_runtime_pm_fn(struct request_queue *q, pm_message_t mesg)
> > +{
> > +	struct scsi_device *sdp = q->queuedata;
> > +
> > +	if (mesg.event == PM_EVENT_SUSPEND) {
> > +		q->pm_status = RPM_SUSPENDING;
> > +		pm_runtime_put(&sdp->sdev_gendev);
> > +	}
> > +	else if (mesg.event == PM_EVENT_RESUME) {
> > +		q->pm_status = RPM_RESUMING;
> > +		pm_runtime_get(&sdp->sdev_gendev);
> > +	}
> 
> Don't use pm_message_t arguments for runtime PM.  Implement separate 
> routines for suspend and resume.

OK, I'll add 2 callbacks to request_queue.

runtime_pm_fn runtime_suspend;
runtime_pm_fn runtime_resume;

> 
> Alan Stern
> 


