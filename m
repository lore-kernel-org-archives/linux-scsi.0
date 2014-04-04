From: Christoph Hellwig <hch@infradead.org>
Subject: EH method APIs
Date: Fri, 4 Apr 2014 00:04:08 -0700
Message-ID: <20140404070408.GA30326@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37799 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbaDDHEI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Apr 2014 03:04:08 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.de>

One think I noticed when doing the SCSI MQ work is that our EH method
signature are starting to really get into the way by passing a scsi_cmnd
as the only argument.  While we'll obviously need the command we want
to abort for eh_abort the resets aren't command specific at all and
passing the command doesn't seem too helpful in general.

There's two specific reasons why it's getting in it's way:

 - With the cmd_size field in the host template we can now allocate
   driver specific data as part of the scsi_cmnd, but we'll usually
   still need driver specific data to do the actual error handling.
   The virtio_scsi driver conversion I posted is a good example of that.
 - The scsi_reset_provider situation is getting worse: this fakes up
   a request on stack, then allocates a scsi_command which doesn't get
   fully set up and points to it and calls the eh_reset* methods on it.
   For now we can keep doing that even with blk-mq, but if we eventually
   want to remove the old code we need a way to fake up the request/cmnd
   combo.  Even until then drivers get a command that subtly different
   from normal ones from scsi_reset_provider in the old code case, and
   even more subtly different for scsi-mq.

I wonder if we should start adding new methods that pass a tmf context
soon.  I think Hannes was looking into EH methods that match the SAM
error handling concepts better anyway, so this might be a good synergy.
