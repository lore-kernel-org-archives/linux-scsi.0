From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 5/5 v2]scsi:hosts.c Fix warning: variable 'rval' set
 but not used
Date: Sat, 19 Jun 2010 14:32:51 -0500
Message-ID: <1276975971.4416.19.camel@mulgrave.site>
References: <1276892167-24161-1-git-send-email-justinmattock@gmail.com>
	 <20100618204730.GL9298@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:38716 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607Ab0FSTc5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Jun 2010 15:32:57 -0400
In-Reply-To: <20100618204730.GL9298@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>, linux-scsi@vger.kernel.org

On Fri, 2010-06-18 at 14:47 -0600, Matthew Wilcox wrote:
> On Fri, Jun 18, 2010 at 01:16:07PM -0700, Justin P. Mattock wrote:
> > @@ -420,7 +419,8 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
> >  	shost->ehandler = kthread_run(scsi_error_handler, shost,
> >  			"scsi_eh_%d", shost->host_no);
> >  	if (IS_ERR(shost->ehandler)) {
> > -		rval = PTR_ERR(shost->ehandler);
> > +		printk(KERN_WARNING "scsi%d: error handler thread failed to spawn, error = %ld\n", 
> > +			shost->host_no, PTR_ERR(shost->ehandler));
> 
> Surely this should simply be:
> 
> 		shost_printk(KERN_WARNING, shost, "error handler thread failed"
> 				"to spawn (%ld)\n", PTR_ERR(shost->ehandler));

Actually, I'm wary of doing this: the device isn't fully initialised
(it's unparented and not added to the system) so that could cause
problems down the road for intelligent error gathering.  It's why we
tend to do the printk scsi%d (or dev_printk on the parent) thing up
until scsi_host_add().

James


