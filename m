From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] 2.5.x use list_head to handle scsi starved request queues
Date: Fri, 21 Mar 2003 16:50:50 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030321165050.B9578@beaverton.ibm.com>
References: <20030319182755.A9535@beaverton.ibm.com> <3E7A1EF5.3050501@splentec.com> <20030320203912.A18471@beaverton.ibm.com> <3E7B7A9A.6030007@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E7B7A9A.6030007@splentec.com>; from luben@splentec.com on Fri, Mar 21, 2003 at 03:48:26PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Fri, Mar 21, 2003 at 03:48:26PM -0500, Luben Tuikov wrote:
> Patrick Mansfield wrote:
> > 
> > Okay, the comments are not clear, and don't match the code, I'll remove
> > them rather than try to get something terse and meaningful.
> 
> No, please -- you don't have to go from one extreme to the other.

> Comments are good, please put some, just make sure that they don't tell
> things which can already be determined like int a; /* integer counter */,
> but something like int a; /* number of customers served */, i.e. portray
> the meaning.

The comments (just the two in the host.h and scsi.h) are close to trivial,
and the code is not tricky. So I'll remove them.

> Ok, then go over the list of starved scsi devices FIRST, hit their queues,
> and THEN after this, get the lock for the queue and hit it.
> 
> I.e. keep the queue lock for the shortest amount of time.

The lock has to be held while checking shost->host_busy and then when
removing the starved entry, we can have multiple cpu's in the function for
the same adapter at the same time. Plus the lock has to be acquired prior
to any __blk_run_queue call.

I am still working patches for the lock split up in this area.

-- Patrick Mansfield
