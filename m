From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH] 2.5.x use list_head to handle scsi starved request queues
Date: Mon, 24 Mar 2003 12:12:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E7F3C67.5010704@splentec.com>
References: <20030319182755.A9535@beaverton.ibm.com> <3E7A1EF5.3050501@splentec.com> <20030320203912.A18471@beaverton.ibm.com> <3E7B7A9A.6030007@splentec.com> <20030321165050.B9578@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
> 
> The lock has to be held while checking shost->host_busy and then when
> removing the starved entry, we can have multiple cpu's in the function for
> the same adapter at the same time. Plus the lock has to be acquired prior
> to any __blk_run_queue call.

If scsi_queue_next_request(q, cmd) is running on more than one CPU
and q != q1 then you have a problem with the starved devices list.

I.e. the lock for an object should NOT depend on the circumstances --
an object (or set of objects) should _always_ use the same lock, if
any.

For this reason, when you obtain the q->queue_lock, just use it
around your critical section and __blk_run_queue(), in a minimalistic
approach, then release it.

Then have a starved_list_lock, or use the host->lock (extreme and I do NOT
recommend it) to lock your starved_list.

So, obtain the starved_list_lock, go over the devices, get their request
queues's lock and call __blk_run_queue(sdev->request_queue), then release
the sdev->request_queue->queue_lock and loop over again if needed,
when done, release the starved_list_lock.

Remember that, someone else might want to *rearrange* the order of
devices in the starved list for, say, _prioritization_, at some other
time when there is no queue in context! (thus a starved_list_lock would
make most sense)

> I am still working patches for the lock split up in this area.

Good!

-- 
Luben


