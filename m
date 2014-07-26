From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] hpsa: work in progress "lockless monster" patches
Date: Sat, 26 Jul 2014 08:32:32 -0700
Message-ID: <20140726153232.GE1854@infradead.org>
References: <20140725192859.GU14599@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43390 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbaGZPce (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 26 Jul 2014 11:32:34 -0400
Content-Disposition: inline
In-Reply-To: <20140725192859.GU14599@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scameron@beardog.cce.hp.com
Cc: linux-scsi@vger.kernel.org, jbottomley@parallels.com, martin.petersen@oracle.com, thenzl@redhat.com, hare@suse.de, hch@infradead.org, bvanassche@acm.org, axboe@kernel.dk, elliott@hp.com, scott.teel@hp.com, webbnh@hp.com, joseph.t.handzik@hp.com, justin.lindley@hp.com

> Christoph Hellwig (1):
>   reserve block tags in scsi host

So you found this one useful.  This begs the question how we should
move forward with it, as it will only work with the blk-mq path in
it's current form.

I can see three ways:

 - we implement equivalent functionality in the old block tagging code
   and make it available for any driver
 - we require drivers specific workarounds for the !mq path
 - we allow drivers to force the use of the blk-mq path if they want
   to use advanced features like this.  This might become nessecary
   anyway when we expose actual multiqueue support to LLDDs.

