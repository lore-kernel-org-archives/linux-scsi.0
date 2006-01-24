From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH 07/13] SCSI: export scsi_eh_finish_cmd() and scsi_eh_flush_done_q()
Date: Tue, 24 Jan 2006 10:53:43 -0800 (PST)
Message-ID: <20060124185343.39546.qmail@web31805.mail.mud.yahoo.com>
References: <20060124173021.GF23269@havoc.gtf.org>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20060124173021.GF23269@havoc.gtf.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Tejun Heo <htejun@gmail.com>, Christoph Hellwig <hch@infradead.org>, Arjan van de Ven <arjan@infradead.org>, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, albertcc@tw.ibm.com, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--- Jeff Garzik <jgarzik@pobox.com> wrote:
> On Tue, Jan 24, 2006 at 09:11:17AM -0800, Luben Tuikov wrote:
> > So when scsi_finish_command() is unexported, then _all_ EH strategies
> > would have to define local done_q, and splice eh_cmd_q into local work_q,
> > then from local work_q into local done_q and then that is passed
> > to SCSI Core, via scsi_eh_flush_done_q().
> > 
> > Is it possible that this is done asynchrounously?  Since EH recovery is
> > per host, but you may have only a single device which is misbehaving?
> 
> No, because the host is stopped during EH, and only restarted after your
> EH code completes its run.

Look at my sentence above, I just said "Since EH recovery is per host". You're
repeating  what I had just said.

Maybe I was too subtle saying "Since EH recovery is per host, but you may
have only a single device which is misbehaving":  the whole point is not to have
to stop the "host" in order to do error recovery.  Finer grained recovery would
be better, obviously for many reasons, both technologically and logistically.
 
> > I.e. is it possible, in a such and such EH strategy, not necessarily
> > SCSI Cores's or libata's, to _not_ have a local done_q?  So that,
> > we have only local work_q (after splicing eh_cmd_q) and after each
> > command is looked at, we "return" that command back to SCSI Core, so
> > that SCSI Core can "finish" it. (In effect "per-command", as opposed to
> > "per-queue-of-commands".)
> 
> done_q is simply a method for returning one or more commands back to the
> SCSI Core, so that the SCSI Core can finish it.

Thank you for pointing the obvious.

> Per-command is irrelevant during EH, because queue processing is not
> restarted until your EH handler ends completely.

Which would not be the case if finer grained recovery is to be attained.

> One alternative strategy for EH is to override the ->eh_timed_out()
> function.  Its ugly, but you may effectively eliminate EH handling via
> ->eh_strategy_handler(), by moving the error handling completely within
> (a) the interrupt handler or (b) ->eh_timed_out().

Neither.  There's per protocol recovery EHs which override both
eh_timed_out() _and_ eh_strategy_handler(), in order to implement
protocol recovery.

     Luben


