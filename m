From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/6] scsi: avoid taking host_lock in scsi_run_queue
 unless nessecary
Date: Wed, 12 Feb 2014 07:52:33 -0800
Message-ID: <20140212155233.GA7587@infradead.org>
References: <20140206184306.997538898@bombadil.infradead.org>
 <20140206184417.536140873@bombadil.infradead.org>
 <52FB5633.3050904@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56244 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbaBLPwf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Feb 2014 10:52:35 -0500
Content-Disposition: inline
In-Reply-To: <52FB5633.3050904@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

On Wed, Feb 12, 2014 at 12:08:35PM +0100, Hannes Reinecke wrote:
> What happens when another CPU is just modifying the starved list
> at this point?
> We probably won't be seeing the update until when the next command
> completed.

That's correct if the last was emptry previous.  list_empty won't
return true when adding an additional command.

> Which probably doesn't matter if the HBA has run out of resources
> (which means there are plenty of other commands outstanding),
> but it'll surely influence the load balancing when using several
> devices, won't it?

Only when first adding an item to the starved list.  Load balancing
isn't that important when just dealing with two commands but more
for a long lasting overload.
