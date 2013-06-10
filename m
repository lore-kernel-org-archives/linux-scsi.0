From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/9] scsi: improved eh timeout handler
Date: Mon, 10 Jun 2013 01:20:01 -0700
Message-ID: <20130610082001.GB7816@infradead.org>
References: <1370850058-27613-1-git-send-email-hare@suse.de>
 <1370850058-27613-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36901 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab3FJI6P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Jun 2013 04:58:15 -0400
Content-Disposition: inline
In-Reply-To: <1370850058-27613-4-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Joern Engel <joern@logfs.org>, Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Roland Dreier <roland@purestorage.com>, Bryn Reeves <bmr@redhat.com>, Christoph Hellwig <hch@infradead.org>

On Mon, Jun 10, 2013 at 09:40:52AM +0200, Hannes Reinecke wrote:
> When a command runs into a timeout we need to send an 'ABORT TASK'
> TMF. This is typically done by the 'eh_abort_handler' LLDD callback.
> 
> Conceptually, however, this function is a normal SCSI command, so
> there is no need to enter the error handler.
> 
> This patch implements a new scsi_abort_command() function which
> invokes an asynchronous function scsi_eh_abort_handler() to
> abort the commands via 'eh_abort_handler'.
> 
> If the 'eh_abort_handler' returns SUCCESS or FAST_IO_FAIL the
> command will be retried if possible. If no retries are allowed
> the command will be returned immediately, as we have to assume
> the TMF succeeded and the command is completed with the LLDD.
> If the TMF fails the command will be pushed back onto the
> list of failed commands and the SCSI EH handler will be
> called immediately for all timed-out commands.

Why can't we use a work item per command?  Linking things into a list
just to queue it up to workqueues missed half of the point of the
workqueue infrastructure.

