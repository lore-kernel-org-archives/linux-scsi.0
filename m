From: Mike Anderson <andmike@us.ibm.com>
Subject: Clarification - export of scsi_finish_command and scsi_times_out
Date: Tue, 8 Jun 2004 16:18:05 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040608231805.GE1360@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:24805 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S265399AbUFHXS6
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Jun 2004 19:18:58 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: hch@infradead.org, jgarzik@pobox.com

On a previous thread to resolve a libata issue scsi_finish_command was
exported. The thread can be reference at the url below.

http://marc.theaimsgroup.com/?t=107799572900002&r=1&w=2

My question is why did we export scsi_finish_command and not a wrapper
that included scsi_decide_disposition. If a LLDD did not have a
eh_strategy routine it is possible post recovery the io would be
retried. Is it because it was believed that these timed out commands
handled by the libata eh_strategy_handler would most likely not succeed
on retry?

Also there was a previous patch posted by Christoph to allow a LLDD to
handle timeouts directly instead of waiting for the host_failed count to
be reached where they could then be handled in a eh_strategy_handler.
http://marc.theaimsgroup.com/?l=linux-scsi&m=107460498631200&w=2

What is the current thought on this patch.

-andmike
--
Michael Anderson
andmike@us.ibm.com

