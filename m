From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCHv5 0/9] New EH command timeout handler
Date: Mon, 2 Sep 2013 02:31:29 -0700
Message-ID: <20130902093129.GA17201@infradead.org>
References: <1378105985-79686-1-git-send-email-hare@suse.de>
 <20130902082728.GA15554@infradead.org>
 <52245235.9020408@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33273 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932150Ab3IBJbh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Sep 2013 05:31:37 -0400
Content-Disposition: inline
In-Reply-To: <52245235.9020408@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>, Bart Van Assche <bvanassche@acm.org>, Roland Dreier <roland@purestorage.com>

On Mon, Sep 02, 2013 at 10:54:13AM +0200, Hannes Reinecke wrote:
> I don't mind. Having talked to the various SCSI folks everyone
> agreed that calling abort asynchronously shouldn't do any harm.
> At least as far as the SCSI spec goes.
> 
> As for documentation: I didn't document it it currently as with my
> implementation it's pretty much an optional thing.
> But if we were to enable it globally it surely should be documented.
> 
> So if there is a consensus I surely can enable it globally and
> update the documentation.

I would defintively love enabling it globally.  As a fallback we should
probably keep the old code for a while and prepare a way to disable
the async code by a flag in the host template.  If no reason to enable
it shows up after a year ore two we can remove the old code entirely.

I.e change the tail of scsi_times_out into something like:


	if (rtn == BLK_EH_NOT_HANDLED && !shost->hostt->no_async_abort) {
		if (scsi_abort_command(scmd))
			return BLK_EH_NOT_HANDLED;
	}

	scmd->result |= DID_TIME_OUT << 16;
	...

That way we don't even need the new BLK_EH_SCHEDULED return value and
have all the handling in scsi_error.c
