From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] 2.5.x use list_head to handle scsi starved request queues
Date: Mon, 24 Mar 2003 11:29:40 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030324112940.A11000@beaverton.ibm.com>
References: <20030319182755.A9535@beaverton.ibm.com> <3E7A1EF5.3050501@splentec.com> <20030320203912.A18471@beaverton.ibm.com> <3E7B7A9A.6030007@splentec.com> <20030321165050.B9578@beaverton.ibm.com> <3E7F3C67.5010704@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E7F3C67.5010704@splentec.com>; from luben@splentec.com on Mon, Mar 24, 2003 at 12:12:07PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Mon, Mar 24, 2003 at 12:12:07PM -0500, Luben Tuikov wrote:
> Patrick Mansfield wrote:
> > 
> > The lock has to be held while checking shost->host_busy and then when
> > removing the starved entry, we can have multiple cpu's in the function for
> > the same adapter at the same time. Plus the lock has to be acquired prior
> > to any __blk_run_queue call.
> 
> If scsi_queue_next_request(q, cmd) is running on more than one CPU
> and q != q1 then you have a problem with the starved devices list.

Not with the current locking: we lock queue_lock (equal to host_lock)
at the start of scsi_queue_next_request, and unlock at the end of
scsi_queue_next_request.

I was not addressing any locking issues with this patch, the queue_lock
(or host_lock) is protecting the starved list.

-- Patrick Mansfield
