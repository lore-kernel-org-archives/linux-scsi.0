From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH]: Flexible timeout infrastructure
Date: Wed, 16 Jun 2004 08:27:58 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040616152758.GB4288@us.ibm.com>
References: <40CF0F9F.4050902@adaptec.com> <1087313492.1796.37.camel@mulgrave> <40CF4A15.9060005@adaptec.com> <1087329285.2048.94.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:19619 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S263174AbUFPP2G
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jun 2004 11:28:06 -0400
Content-Disposition: inline
In-Reply-To: <1087329285.2048.94.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley [James.Bottomley@steeleye.com] wrote:
> In the ensuing discussion there have been various changes to this
> suggested, which seem to provide a framework for the solution:
> 
> 1. Timer handling would still all be done in the mid-layer
> 
> 2. Any driver supplying the notify function would have it called on
> timer expiry.
> 
> 3. The LLD communicates what action it wishes to be taken based on the
> return value from the notify.  I suggest 3 possible return actions:
> 
> a. Do nothing and continue with error handling
> 
> b. I fixed the problem, complete the command immediately and proceed as
> though nothing went wrong.

Does this mean scsi_times_out will complete the command by calling a
SCSI mid layer internal form of the scsi_done function (less the
scsi_delete_timer call) or that the LLDD will call scsi_done and we will
need to modify scsi_done to accept these no timer running cases.

> 
> c. I need more time, reset the timer and notify me again when it fails.
> 
> For (c), I propose that we use the same timeout period, but increment
> the retry count (and do this up to allowed retries plus one [so that
> no-retry commands have one crack at being recovered by the LLD]) when
> retries are exhausted, normal error handling would proceed on timer
> expiry leading to certain failure of the command since it would be
> ineligible to be retried.

The comment on the no-retry commands appears counter to the intent of
FASTFAIL. On a multi-ported device if there really is a port / controller
issue we have increased the failover time 2x the timeout value which
IIRC was one case that FASTFAIL wished to address.

> 
> what additional features do you need beyond this proposal?
> 


-andmike
--
Michael Anderson
andmike@us.ibm.com

