From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: [RFC][PATCH] scsi-misc-2.5 software enqueue when can_queue reached
Date: Mon, 3 Mar 2003 07:52:18 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030303075218.79c0fcf8.rddunlap@osdl.org>
References: <20030228111924.A32018@beaverton.ibm.com>
	<20030302085728.A11407@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030302085728.A11407@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: patmans@us.ibm.com, linux-scsi@vger.kernel.org

On Sun, 2 Mar 2003 08:57:28 +0000
Christoph Hellwig <hch@infradead.org> wrote:

| The patch looks fine to me in principle, a few nitpicks are below.
| (btw, any chance you could post a current scsi midlayer multipathing
| patch?  I see there is BK activity.. :))
| 
| > +++ edited/drivers/scsi/hosts.c	Thu Feb 27 16:21:09 2003
| > @@ -383,6 +383,7 @@
| >  	scsi_assign_lock(shost, &shost->default_lock);
| >  	INIT_LIST_HEAD(&shost->my_devices);
| >  	INIT_LIST_HEAD(&shost->eh_cmd_q);
| > +	INIT_LIST_HEAD(&shost->pending_queue);
| 
| This isn't consistant, either ew use _q in all new code or _queue.
| (peronally I prefer the latter)

I agree; looks/reads better, easier to remember.

| > +void scsi_host_send_pending (struct Scsi_Host *shost)
| 
| codingstyle issue:  no space between function name and opening brace.

It's much more readable with the space there IMO.

| > +{
| > +	struct scsi_cmnd *scmd;
| > +	unsigned long flags;
| > +
| > +	spin_lock_irqsave(shost->host_lock, flags);
| > +	while (!shost->host_self_blocked
| > +	       && !list_empty(&shost->pending_queue)) {
| 
| Linux codingstyle sais the && should be before the line break.

While I also prefer the && at the end of the line, I don't see that as
a requirement anywhere... and not in Documentation/CodingStyle (and I'm
not saying that you said it's in there).

--
~Randy
