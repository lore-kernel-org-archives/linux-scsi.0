From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH / RFC] scsi_error handler update. (3/4)
Date: Tue, 11 Feb 2003 23:16:31 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030212071630.GB1453@beaverton.ibm.com>
References: <20030211081351.GA1368@beaverton.ibm.com> <20030211081536.GB1368@beaverton.ibm.com> <20030211081744.GC1368@beaverton.ibm.com> <1045003141.4253.22.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1045003141.4253.22.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley [James.Bottomley@steeleye.com] wrote:
> On Tue, 2003-02-11 at 02:17, Mike Anderson wrote:
> > This patch series is against scsi-misc-2.5.
> > 
> > 02_serror-hndlr-1.diff:
> > 	- Change to using eh_cmd_list.
> > 	- Change scsi_unjam_host to get sense, abort cmds, ready
> > 	  devices, and disposition cmds for retry or finish.
> > 	- Moved retries outside of eh.
> > 
> > -andmike
> 
> I have some qualms about the locking: you protect the eh_cmd_list with
> the host_lock when adding, but not when traversing in the eh_thread.  I
> know this is because the eh_thread has quiesced the host before
> beginning, thus there should theoretically be no returning commmands to
> tamper with the list while the eh_thread is using it.  However, I think
> it might be worthwhile pointing this out in a comment over the
> list_for_each_entry().

How about instead of a comment I change to something like this so that
scsi_unjam_host has its own queue to work off of.

static void scsi_unjam_host(struct Scsi_Host *shost)
{
	unsigned long flags;

	LIST_HEAD(eh_work_q);
	LIST_HEAD(eh_done_q);

	spin_lock_irqsave(shost->host_lock, flags);
	list_splice(&shost->eh_cmd_list, &eh_work_q);
	INIT_LIST_HEAD(&shost->eh_cmd_list);
	spin_unlock_irqrestore(shost->host_lock, flags);

	...

}

I would also change eh_cmd_list eh_cmd_q.

-andmike
--
Michael Anderson
andmike@us.ibm.com

