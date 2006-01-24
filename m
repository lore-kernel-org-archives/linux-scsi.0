From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 07/13] SCSI: export scsi_eh_finish_cmd() and scsi_eh_flush_done_q()
Date: Tue, 24 Jan 2006 12:30:21 -0500
Message-ID: <20060124173021.GF23269@havoc.gtf.org>
References: <43D4AA87.9080408@gmail.com> <20060124171117.61067.qmail@web31809.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:22166 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S1030471AbWAXRaX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jan 2006 12:30:23 -0500
Content-Disposition: inline
In-Reply-To: <20060124171117.61067.qmail@web31809.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: Tejun Heo <htejun@gmail.com>, Christoph Hellwig <hch@infradead.org>, Arjan van de Ven <arjan@infradead.org>, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, albertcc@tw.ibm.com, linux-ide@vger.kernel.org

On Tue, Jan 24, 2006 at 09:11:17AM -0800, Luben Tuikov wrote:
> So when scsi_finish_command() is unexported, then _all_ EH strategies
> would have to define local done_q, and splice eh_cmd_q into local work_q,
> then from local work_q into local done_q and then that is passed
> to SCSI Core, via scsi_eh_flush_done_q().
> 
> Is it possible that this is done asynchrounously?  Since EH recovery is
> per host, but you may have only a single device which is misbehaving?

No, because the host is stopped during EH, and only restarted after your
EH code completes its run.


> I.e. is it possible, in a such and such EH strategy, not necessarily
> SCSI Cores's or libata's, to _not_ have a local done_q?  So that,
> we have only local work_q (after splicing eh_cmd_q) and after each
> command is looked at, we "return" that command back to SCSI Core, so
> that SCSI Core can "finish" it. (In effect "per-command", as opposed to
> "per-queue-of-commands".)

done_q is simply a method for returning one or more commands back to the
SCSI Core, so that the SCSI Core can finish it.

Per-command is irrelevant during EH, because queue processing is not
restarted until your EH handler ends completely.

One alternative strategy for EH is to override the ->eh_timed_out()
function.  Its ugly, but you may effectively eliminate EH handling via
->eh_strategy_handler(), by moving the error handling completely within
(a) the interrupt handler or (b) ->eh_timed_out().

	Jeff



