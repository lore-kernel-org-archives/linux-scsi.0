From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/3] SCSI: rearrange code in scsi_io_completion
Date: Tue, 30 Sep 2008 09:41:45 -0500
Message-ID: <1222785705.3232.18.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0809291710390.4420-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:37736 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752624AbYI3OmO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Sep 2008 10:42:14 -0400
In-Reply-To: <Pine.LNX.4.44L0.0809291710390.4420-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 2008-09-29 at 17:11 -0400, Alan Stern wrote:
> This patch (as1142) consolidates some repetitious code in
> scsi_io_completion().  Multiple calls to scsi_end_request() and to
> scsi_requeue_command() are combined together and moved to the end of
> the function.
> 
> This is simple mechanical code motion, with no change in behavior.

I don't really think this is the right approach, since the retry case
needs to be split apart again.

The only time scsi_requeue_command() needs to be called is if the
request completes successfully but has leftovers.  The reason is that
the command will be different next time around, so it has to be
re-prepared.  In all the other cases, the same command can be reused.
This will have the knock on effect of not resetting the timers or the
counters, so it has to be done carefully.

Of the three requeue cases:

UNIT_ATTENTION needs immediate retry
NOT_READY needs delayed retry
ILLEGAL_REQUEST with cmd switch (assuming we still do it) needs
immediate retry
DID_RESET is arguable either way, but probably needs delayed.

immediate requeue is done by:

scsi_queue_insert(cmd, SCSI_MLQUEUE_EH_RETRY);

And delayed by

scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY);

James


