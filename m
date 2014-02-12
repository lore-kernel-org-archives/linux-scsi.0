From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/6] scsi: do not manipulate device reference counts in
 scsi_get/put_command
Date: Wed, 12 Feb 2014 07:58:07 -0800
Message-ID: <20140212155807.GB7587@infradead.org>
References: <20140206184306.997538898@bombadil.infradead.org>
 <20140206184417.692440766@bombadil.infradead.org>
 <52FB5CF6.5010501@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56273 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbaBLP6H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Feb 2014 10:58:07 -0500
Content-Disposition: inline
In-Reply-To: <52FB5CF6.5010501@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

On Wed, Feb 12, 2014 at 12:37:26PM +0100, Hannes Reinecke wrote:
> But this decouples the scsi_device refcount from the number of
> outstanding commands, right?

We still take a reference for each command in scsi_get_cmd_from_req,
which is helper used in each prep_fn, so we still have a reference
for each command.  The big simplication is that we avoid useless
roundtrips on the reference count during I/O completion by not hiding
them in unrelated functions.

> While I'm sure you've audited all call sites, it's now up to the
> callers to provide proper reference counting.
> Shouldn't we document it somewhere?

Not sure what'd we would want to document.  We grab a reference when
first getting the command from the block layer, and drop it when
finishing the command.  We could write this setence down somewhere if it
really helps people, but I'm not sure where a good place for that would
be.

