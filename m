From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi_debug: call resp_*() function after setting host_scribble
Date: Thu, 15 Feb 2018 18:41:24 -0500
Message-ID: <yq1k1vdlt23.fsf@oracle.com>
References: <20180214100557.30717-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:43468 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1164340AbeBOXlg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Feb 2018 18:41:36 -0500
In-Reply-To: <20180214100557.30717-1-mwilck@suse.com> (Martin Wilck's message
        of "Wed, 14 Feb 2018 11:05:57 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Wilck <mwilck@suse.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>, Hannes Reinecke <hare@suse.de>, James Bottomley <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org


Martin,

Applied to 4.17/scsi-queue.

Minor patch submission nits below (for next time, I fixed them up).

> Error injection in scsi_debug (e.g. opts=16, SDEBUG_OPT_TRANSPORT_ERR)
> currently doesn't work correctly because the test for sqcp in
> resp_read_dt0() and similar resp_*() functions always fails.  sqcp is
> set from cmnd->host_scribble, which is set in schedule_resp(), which
> is called from scsi_debug_queuecommand() after calling the resp_*
> function.
>
> Defer calling resp_*() until after cmnd->host_scribble is
> set in schedule_resp().
>
> Fixes: c483739430f1 "scsi_debug: add multiple queue support"

Your Signed-off-by: needs to go here. And then you need a "---"
separator before the change log.

> Changes in v2: Adapted to code changes after 80c49563e250
> 	"scsi: scsi_debug: implement IMMED bit"
>
> Notes about this adaptation:
>
> The "flags &= ~F_LONG_DELAY" statement in scsi_debug_queuecommand()
> from 80c49563e250 had no effect. Dropped it.
> Because we call the resp_*() function later now, the code flow in
> schedule_resp() is slightly different now for the IMMED case - instead of
> falling through to the "respond_in_thread" label immediately, the command will
> be put in the work queue with zero delay.
>
> Signed-off-by: Martin Wilck <mwilck@suse.com>

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
