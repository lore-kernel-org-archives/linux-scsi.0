From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] scsi: make scsi_eh_scmd_add() always succeed
Date: Tue, 4 Nov 2014 10:36:48 -0800
Message-ID: <20141104183648.GA29621@infradead.org>
References: <1415103073-90276-1-git-send-email-hare@suse.de>
 <1415103073-90276-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57119 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbaKDSgy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Nov 2014 13:36:54 -0500
Content-Disposition: inline
In-Reply-To: <1415103073-90276-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, Robert Elliott <elliott@hp.com>, linux-scsi@vger.kernel.org

On Tue, Nov 04, 2014 at 01:11:11PM +0100, Hannes Reinecke wrote:
> BLK_EH_HANDLED does not work with scsi commands, as we need
> to release the associated buffers correctly.

Which particular error do you see?  The ->eh_timed_out routines can
return BLK_EH_HANDLED, and libata, iscsi and fc actually do, so we'll
need to fix these issues either way.

> And scsi_eh_scmd_add() currently only will fail if no
> error handler thread is started (which will never be the
> case) 

Yes.

> or if the state machine encounters an illegal transition.
> As state machine transitions don't have any real meaning
> we can also force setting of the new state and
> make scsi_dh_scmd_add() a void function.
> With that we'll never have to resort to return
> BLK_EH_HANDLED.

Which kind of transition did you see rejected?  Neither a CREATED or
DEL_(RECOVERY) state should be possible when invoking the error handler,
so I'd rather see asserts here than overriding the state machine.
te RECOVERY state from a RUNNING or existing RECOVERY state, which
leaves CREATED, CANCEL, DEL, CANCEL_RECOVERY or DEL_RECOVERY.

