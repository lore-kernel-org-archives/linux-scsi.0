From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: scsi_block_requests() and retries
Date: Thu, 8 Jan 2004 08:00:46 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040108160045.GA9321@beaverton.ibm.com>
References: <200401081331.21824.heiko.carstens@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:48085 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S263946AbUAHP4E
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jan 2004 10:56:04 -0500
Received: from westrelay01.boulder.ibm.com (westrelay01.boulder.ibm.com [9.17.195.10])
	by e33.co.us.ibm.com (8.12.10/8.12.2) with ESMTP id i08Fu3Jh306346
	for <linux-scsi@vger.kernel.org>; Thu, 8 Jan 2004 10:56:03 -0500
Content-Disposition: inline
In-Reply-To: <200401081331.21824.heiko.carstens@de.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-scsi@vger.kernel.org

Heiko Carstens [heiko.carstens@de.ibm.com] wrote:
> Hi,
> 
> I'm wondering if the behaviour of the scsi mid layer is correct: if an LLD
> calls scsi_block_requests() and _afterwards_ returns outstanding requests
> with DID_ERROR, these requests will be retried. Of course these requests
> will be returned with DID_ERROR as well since the LLD is not expecting /
> accepting any requests. This will be continued until the maximum retry count
> will be reached. The final result will be an I/O error.
> Actually I think that requests shouldn't be retried if
> host_self_blocked == 1 is given for a host adapter.
> Or am I wrong here?
> 

This seems correct that if you are blocked you should not send any
commands to the LLDD (error handler sending commands during blocked was
mentioned a few weeks ago).

It looks like we could have scsi_retry_command replace the call
to scsi_dispatch_cmd(cmd) with a call to scsi_queue_insert(scmd,
SCSI_MLQUEUE_EH_RETRY). This looks like the only side effect would be a
slight delay in calling scsi_dispatch_cmd in the ok to send case.

As a side result since we reduced the callers of scsi_dispatch to
only scsi_request_fn it would seem like we could collapse some
operations into scsi_request_fn.

-andmike
--
Michael Anderson
andmike@us.ibm.com

