From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/5] scsi: improved eh timeout handler
Date: Tue, 11 Feb 2014 23:45:24 -0800
Message-ID: <20140212074524.GA4529@infradead.org>
References: <1384173897-103836-1-git-send-email-hare@suse.de>
 <1384173897-103836-3-git-send-email-hare@suse.de>
 <20140211140148.GA1897@infradead.org>
 <52FA33B6.9010501@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53672 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaBLHpb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Feb 2014 02:45:31 -0500
Content-Disposition: inline
In-Reply-To: <52FA33B6.9010501@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>

On Tue, Feb 11, 2014 at 03:29:10PM +0100, Hannes Reinecke wrote:
> Well, _actually_ the cancel_delayed_work should be pointless; I've
> just added it as a terminal measure here.
> (It'd actually be an idea to insert a BUG_ON() here ...)
> 
> Thing is whenever the eh_timeout thingie kicks in we most definitely
> know there's a command in flight, and hence scsi_command_put()
> should _never_ be called.
> Only after eh_abort has finished the command will be returned via
> scsi_command_put(), but then eh_abort is done for, too, and no item
> should remain in the workqueue.

The issue I saw actually was with a different workqueue, sorry for the
noise.  I have to say I really hate the generic workqueue workers which
make it almost impossible to debug issues before they hit the actual
worker function..

