From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH / RFC] scsi_error handler update. (3/4)
Date: 12 Feb 2003 08:37:57 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1045060685.1738.3.camel@mulgrave>
References: <20030211081351.GA1368@beaverton.ibm.com>
	<20030211081536.GB1368@beaverton.ibm.com>
	<20030211081744.GC1368@beaverton.ibm.com>
	<1045003141.4253.22.camel@mulgrave>
	<20030212071630.GB1453@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id GAA06364
	for <linux-scsi@vger.kernel.org>; Wed, 12 Feb 2003 06:38:12 -0800
In-Reply-To: <20030212071630.GB1453@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2003-02-12 at 01:16, Mike Anderson wrote:
> How about instead of a comment I change to something like this so that
> scsi_unjam_host has its own queue to work off of.

Absolutely perfect!  Just in case anyone gets around to an error handler
that doesn't have to entirely quiesce the host, this infrastructure will
come in handy.

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

list_splice_init() does both of these operations

> 	spin_unlock_irqrestore(shost->host_lock, flags);

James


