From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Clarification - export of scsi_finish_command and scsi_times_out
Date: 09 Jun 2004 10:11:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1086790314.2184.72.camel@mulgrave>
References: <20040608231805.GE1360@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:6869 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266006AbUFIOMH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Jun 2004 10:12:07 -0400
In-Reply-To: <20040608231805.GE1360@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, hch@infradead.org, Jeff Garzik <jgarzik@pobox.com>

On Tue, 2004-06-08 at 19:18, Mike Anderson wrote:
> On a previous thread to resolve a libata issue scsi_finish_command was
> exported. The thread can be reference at the url below.
> 
> http://marc.theaimsgroup.com/?t=107799572900002&r=1&w=2
> 
> My question is why did we export scsi_finish_command and not a wrapper
> that included scsi_decide_disposition. If a LLDD did not have a
> eh_strategy routine it is possible post recovery the io would be
> retried. Is it because it was believed that these timed out commands
> handled by the libata eh_strategy_handler would most likely not succeed
> on retry?

This was just a quick hack to get libata working.  The particular
problem had no need of decide_disposition, it just wanted an error
return if there was a problem.  We probably would need to export decide
disposition for a proper user of eh_strategy_handler.  On the other
hand, I was wondering if we couldn't deprecate eh_strategy_handler and
go with error handling within transport classes instead as a future
direction.

> Also there was a previous patch posted by Christoph to allow a LLDD to
> handle timeouts directly instead of waiting for the host_failed count to
> be reached where they could then be handled in a eh_strategy_handler.
> http://marc.theaimsgroup.com/?l=linux-scsi&m=107460498631200&w=2
> 
> What is the current thought on this patch.

Looks fine as a proposal.  However, it's only a first draft patch and we
have no putative users to hone it into a finished API.

James


