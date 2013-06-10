From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/9] scsi: move initialization of scmd->eh_entry
Date: Mon, 10 Jun 2013 01:17:07 -0700
Message-ID: <20130610081707.GA7816@infradead.org>
References: <1370850058-27613-1-git-send-email-hare@suse.de>
 <1370850058-27613-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36903 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab3FJI7O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Jun 2013 04:59:14 -0400
Content-Disposition: inline
In-Reply-To: <1370850058-27613-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Joern Engel <joern@logfs.org>, Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Roland Dreier <roland@purestorage.com>, Bryn Reeves <bmr@redhat.com>, Christoph Hellwig <hch@infradead.org>

On Mon, Jun 10, 2013 at 09:40:50AM +0200, Hannes Reinecke wrote:
> The 'eh_entry' list might be used even before scsi_softirq_done()
> is called. Hence we should rather initialize it together with
> the other eh-related variables.

As mentioned earlier I don't think moving the initialization from one
random point in the middle of the lifetime of the command to another
is a good idea.  If we initialize it it should be when it is allocated.

But looking at the code I can't see why it needs to be initialized at
all.  eh_entry is not used as the head of a list but just as the list
link, and it's never tested for emptyness either, which shouldn't
require it to be initialized at all.

