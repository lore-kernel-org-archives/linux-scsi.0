From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v6 0/4] block layer runtime pm
Date: Mon, 14 Jan 2013 11:14:23 +0800
Message-ID: <20130114031422.GB15280@aaronlu.sh.intel.com>
References: <50EBCBC3.4070606@intel.com>
 <Pine.LNX.4.44L0.1301081024300.1535-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1301081024300.1535-100000@iolanthe.rowland.org>
Sender: linux-pm-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 08, 2013 at 10:27:54AM -0500, Alan Stern wrote:
> On Tue, 8 Jan 2013, Aaron Lu wrote:
> 
> > So this also reminds me that as long as CONFIG_PM_RUNTIME is selected,
> > the blk_pm_add/put/peek_request functions will be in the block IO path.
> > Shall we introduce a new config option to selectively build block
> > runtime PM functionality? something like CONFIG_BLK_PM_RUNTIME perhaps?
> > 
> > Just some condition checks in those functions, not sure if it is worth a
> > new config though. Please suggest, thanks.
> 
> I don't think it is needed.  The new routines will be very quick when 
> blk_pm_runtime_init() hasn't been called, once you add back the checks 
> for the queue's device.

Is it necessary to also add the q->dev check in the following case?

static void blk_pm_requeue_request(struct request *rq)
{
	if (rq->q->dev && !(rq->cmd_flags & REQ_PM))
		rq->q->nr_pending--;
}

So that we do not have a meanlingless value of nr_pending for those
drivers that don't use block runtime PM, and this also has the benefit
of making those drivers return early.

Thanks,
Aaron

