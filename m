From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] fixup some tagged queuing mess
Date: 25 Aug 2003 11:00:41 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1061827243.2044.107.camel@mulgrave>
References: <20030825122751.GF15506@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:29190 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262027AbTHYQA6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2003 12:00:58 -0400
In-Reply-To: <20030825122751.GF15506@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: dledford@redhat.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2003-08-25 at 07:27, Christoph Hellwig wrote:
> James, can you review the code in 53c700.c?  Calling scsi_activate_tcq
> in ->queuecommand rather than ->slave_configure looks rather strange to
> me..

There is a reason why it works this way (apart from history): Just
because a device says it supports TCQ in its inquiry data doesn't mean
that it actually does, so 53c700 goes through a state machine
interaction where it first tries a single tagged command, and if that
succeeds it turns on TCQ permanently.

The problem with doing this from slave_configure is that the flags
represent a state machine of the commands, so they can't be set from
there (because we passively wait for commands to come down before
changing states).

The patch:

-       if(SCp->device->tagged_supported && !SCp->device->tagged_queue
+       if(SCp->device->tagged_supported && !SCp->device->simple_tags &&

Looks wrong.  Shouldn't it be

if(SCp->device->tagged_supported && !(SCp->device->simple_tags ||
SCp->device->ordered_tags) &&

to pick up the two types of tag we may turn on?

Since there's also a currently unused third type of tag (head of queue)
perhaps you would be better off introducing a scsi_tag_enabled() macro
that encapsulates the logic.

James


