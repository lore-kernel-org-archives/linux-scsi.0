From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH / RFC] scsi_error handler update. (3/4)
Date: Wed, 12 Feb 2003 09:26:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E4A597F.20301@splentec.com>
References: <20030211081351.GA1368@beaverton.ibm.com> <20030211081536.GB1368@beaverton.ibm.com> <20030211081744.GC1368@beaverton.ibm.com> <1045003141.4253.22.camel@mulgrave> <20030212071630.GB1453@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030212071630.GB1453@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Mike Anderson wrote:
>>
>>I have some qualms about the locking: you protect the eh_cmd_list with
>>the host_lock when adding, but not when traversing in the eh_thread.  I
>>know this is because the eh_thread has quiesced the host before
>>beginning, thus there should theoretically be no returning commmands to
>>tamper with the list while the eh_thread is using it.  However, I think
>>it might be worthwhile pointing this out in a comment over the
>>list_for_each_entry().
> 
> 
> How about instead of a comment I change to something like this so that
> scsi_unjam_host has its own queue to work off of.
> 
> static void scsi_unjam_host(struct Scsi_Host *shost)
> {
> 	unsigned long flags;
> 
> 	LIST_HEAD(eh_work_q);
> 	LIST_HEAD(eh_done_q);
> 
> 	spin_lock_irqsave(shost->host_lock, flags);
> 	list_splice(&shost->eh_cmd_list, &eh_work_q);
> 	INIT_LIST_HEAD(&shost->eh_cmd_list);
> 	spin_unlock_irqrestore(shost->host_lock, flags);
> 
> 	...
> 
> }

So much better.  This is the right principle: if you need a lock to access
a list in one place, then you *always* need the lock to access the list.

When doing locking and synchronization, doing things out of principle
*will* avoid lockups, but (ab)using circumstantial facts will *definitely*
lead to a lock up.

This also leads to the same effect, and it's a common idiom in the kernel:

	LIST_HEAD(local_q);

	spin_lock_irqsave(shost->host_lock, flags);
	list_add(&local_q, shost->eh_cmd_q);
	list_del_init(shost->eh_cmd_q);
	spin_unlock_irqrestore(shost->host_lock, flags);

	/* Now we work with local_q */

 
> I would also change eh_cmd_list eh_cmd_q.

That sounds great.  While you're at it, how about calling
``eh_cmd_q'' something like ``failed_cmd_q' or something which
represents *what* kind commands are in this queue, rather
than the name representing *who* will work with this queue.

Remember, the whole point with queues are to represent
the *state* of the command...  And this is what the ``eh_cmd_q''
does.

Also don't forget cmd::eh_list --> not suggesting a list...
or just using the list member.

The whole point is that when a SCSI Command gets instantiated
and enters SCSI Core, it traverses the queues as it evolves,
depending on its state.  (Borrowing from my own mini-scsi-core... :-P )

(I have to say something on scsi_put/get_command() but later today.)

-- 
Luben



