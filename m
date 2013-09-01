From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 7/7] Micro-optimize scsi_next_command()
Date: Sun, 1 Sep 2013 10:06:13 -0700
Message-ID: <20130901170613.GF4344@infradead.org>
References: <52135B99.2000102@acm.org>
 <52135CC1.3000901@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59164 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab3IARGV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Sep 2013 13:06:21 -0400
Content-Disposition: inline
In-Reply-To: <52135CC1.3000901@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, David Milburn <dmilburn@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, Aug 20, 2013 at 02:10:41PM +0200, Bart Van Assche wrote:
> Eliminate a get_device() / put_device() pair from scsi_next_command().
> Both are atomic operations hence removing these slightly improves
> performance.

The same should also be applied to scsi_requeue_command, while it might
not matter for performance it'll make the code a lot more readable,
especially when also merging scsi_unprep_request into
scsi_requeue_command.  See the patch I'll send out for this ASAP.

I'm also not sure if there's a point in keeping the
get/_put_command_and_dev variants.  There's very few callers left and
just opencoding the device reference manipulation might be cleaner.
