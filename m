From: Christoph Hellwig <hch@infradead.org>
Subject: making the queue_type attribute read only, was: Re: tag handling
 refactor V2
Date: Wed, 12 Nov 2014 09:41:42 -0800
Message-ID: <20141112174142.GA14359@infradead.org>
References: <1415634990-3023-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58800 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbaKLRlp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Nov 2014 12:41:45 -0500
Content-Disposition: inline
In-Reply-To: <1415634990-3023-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bvanassche@acm.org>, Mike Christie <michaelc@cs.wisc.edu>

>  - how is the change_queue_type API supposed to be used for most drivers?  It
>    only changes the tag type from none to simple or back, but except for the
>    special implementation in the 53c700 driver doesn't change the queue depth,
>    which might cause it to issue multiple non-tagged command.  Fortunately
>    most drivers never look at this information, but then again changing the
>    queue type is useless to start with.
>  - for those drivers looking at the command tagged information we'd need
>    to quiesce the LUN.  No driver but the 53c700 driver does that, and the
>    53c700 does it at a target-level, which despite a comment claiming it's
>    needed doesn't seem to make sense given the code.  If we can make sure
>    to quience all LUNs we could avoid the per-command flag for tagged commands
>    and always look at the scsi_device flag.

I've not merged the series, but ondering the above two issues I've
become convinved that we should make the queue_type sysfs attribute read
only.

Switching off tagging isn't really something we should leave to users,
as the hardware knows much better.  Changing the tag type might have
made sense during the times of the ordered tags for barriers insanity,
but now that it's just tagged vs untagged it's pretty pointless.
Especially given that only a single driver ever got the implementation
right.

Does anyone have objections to removing the change_queue_type method?

