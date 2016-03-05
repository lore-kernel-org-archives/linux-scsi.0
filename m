From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2 2/2] target/iblock: Use -EAGAIN/-ENOMEM to propigate
 SAM BUSY/TASK_SET_FULL
Date: Sat, 05 Mar 2016 14:51:27 -0800
Message-ID: <1457218287.28660.70.camel@haakon3.risingtidesystems.com>
References: <1457161634-15756-1-git-send-email-nab@daterainc.com>
	 <1457161634-15756-2-git-send-email-nab@daterainc.com>
	 <20160305210108.GA16337@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20160305210108.GA16337@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Sagi Grimberg <sagig@dev.mellanox.co.il>, Andy Grover <agrover@redhat.com>, Sagi Grimberg <sagig@mellanox.com>, Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2016-03-05 at 22:01 +0100, Christoph Hellwig wrote:
> > -	if (atomic_read(&ibr->ib_bio_err_cnt))
> > -		status = SAM_STAT_CHECK_CONDITION;
> > -	else
> > +	/*
> > +	 * Propigate use these two bio completion values from raw block
> > +	 * drivers to signal up BUSY and TASK_SET_FULL status to the
> > +	 * host side initiator.  The latter for Linux/iSCSI initiators
> > +	 * means the Linux/SCSI LLD will begin to reduce it's internal
> > +	 * per session queue_depth.
> > +	 */
> > +	if (atomic_read(&ibr->ib_bio_err_cnt)) {
> > +		switch (ibr->ib_bio_retry) {
> > +		case -EAGAIN:
> > +			status = SAM_STAT_BUSY;
> > +			break;
> > +		case -ENOMEM:
> > +			status = SAM_STAT_TASK_SET_FULL;
> > +			break;
> > +		default:
> > +			status = SAM_STAT_CHECK_CONDITION;
> > +			break;
> > +		}
> > +	} else {
> >  		status = SAM_STAT_GOOD;
> > +	}
> 
> I think you;d be much better off killing ib_bio_err_cnt and having
> an ib_error that gets set to the last / most server error.

That's what I was originally thinking too..

However, that means if one bio completed successfully and another got
-EAGAIN / -ENOMEM for the same se_cmd, IBLOCK would still complete
se_cmd with GOOD status.

I don't see how completing se_cmd with GOOD status, when one bio in the
set requested retry depending on completion order is a good idea.
