From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: scsi error handling thread and REQUEST SENSE
Date: Mon, 19 May 2014 13:40:39 +0200
Message-ID: <5379EDB7.3030803@acm.org>
References: <94D0CD8314A33A4D9D801C0FE68B402956F17E1F@G4W3202.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from andre.telenet-ops.be ([195.130.132.53]:58604 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbaESLkk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 May 2014 07:40:40 -0400
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402956F17E1F@G4W3202.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "James Bottomley (jbottomley@parallels.com)" <jbottomley@parallels.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>, "scameron@beardog.cce.hp.com" <scameron@beardog.cce.hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 05/16/14 21:02, Elliott, Robert (Server Storage) wrote:
> The command is still outstanding; data transfers might still occur, 
> and a completion using its tag could still appear at any time. 
> However, the error handler declares that the command is done, 
> so all the buffers are freed and the tag is reused.
> 
> The SCSI error handler needs to escalate this to a reset that 
> ensures that the command is no longer outstanding: ABORT
> TASK (which already didn't work), ABORT TASK SET, LOGICAL 
> UNIT RESET, I_T NEXUS RESET, or hard reset.

If my interpretation of the SCSI mid-layer source code is correct then
even with the patch "improved eh timeout handler" applied the SCSI
mid-layer still guarantees for each SCSI host that at most one
eh_abort_handler() call is active at any given time (since tmf_work_q is
created with max_active = 1) and also that at least one of the eh_*
functions is invoked before the SCSI mid-layer finishes a command. Does
your comment mean that you have found a scenario in which none of the
LLD eh_* callback functions was invoked before the SCSI mid-layer
finished a SCSI command ?

Thanks,

Bart.
