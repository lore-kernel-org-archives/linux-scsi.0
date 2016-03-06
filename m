From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH-v2 2/2] target/iblock: Use -EAGAIN/-ENOMEM to propigate
 SAM BUSY/TASK_SET_FULL
Date: Sat, 5 Mar 2016 22:19:10 -0800
Message-ID: <20160306061910.GA1116@infradead.org>
References: <1457161634-15756-1-git-send-email-nab@daterainc.com>
 <1457161634-15756-2-git-send-email-nab@daterainc.com>
 <20160305210108.GA16337@lst.de>
 <1457218287.28660.70.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1457218287.28660.70.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Sagi Grimberg <sagig@dev.mellanox.co.il>, Andy Grover <agrover@redhat.com>, Sagi Grimberg <sagig@mellanox.com>, Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, Mar 05, 2016 at 02:51:27PM -0800, Nicholas A. Bellinger wrote:
> > I think you;d be much better off killing ib_bio_err_cnt and having
> > an ib_error that gets set to the last / most server error.
> 
> That's what I was originally thinking too..
> 
> However, that means if one bio completed successfully and another got
> -EAGAIN / -ENOMEM for the same se_cmd, IBLOCK would still complete
> se_cmd with GOOD status.
> 
> I don't see how completing se_cmd with GOOD status, when one bio in the
> set requested retry depending on completion order is a good idea.

Oh, I took a look at the patch again and it looks bogus - block drivers
should never return EAGAIN or ENOMEM from ->bi_end_io.  Those are errors
that should happen before submission if at all.  Which driver ever returns
these?
