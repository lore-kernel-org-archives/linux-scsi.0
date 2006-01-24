From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH 07/13] SCSI: export scsi_eh_finish_cmd() and scsi_eh_flush_done_q()
Date: Tue, 24 Jan 2006 09:11:17 -0800 (PST)
Message-ID: <20060124171117.61067.qmail@web31809.mail.mud.yahoo.com>
References: <43D4AA87.9080408@gmail.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <43D4AA87.9080408@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>, Christoph Hellwig <hch@infradead.org>
Cc: Arjan van de Ven <arjan@infradead.org>, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, albertcc@tw.ibm.com, linux-ide@vger.kernel.org, jgarzik@pobox.com
List-Id: linux-scsi@vger.kernel.org

--- Tejun Heo <htejun@gmail.com> wrote:
> Christoph Hellwig wrote:
> > On Mon, Jan 23, 2006 at 05:20:42PM +0900, Tejun Heo wrote:
> > 
> >>Arjan van de Ven wrote:
> >>
> >>>On Mon, 2006-01-23 at 13:09 +0900, Tejun Heo wrote:
> >>>
> >>>
> >>>>Export two SCSI EH command handling functions.  To be used by libata EH.
> >>>
> >>>since these are pretty much internal, can we make these _GPL exports?
> >>>
> >>
> >>It's SCSI developers' decision.  I chose EXPORT_SYMBOL because all other
> >>exported symbols in scsi_error.c were using it.  James?
> > 
> > 
> > These are internal functions.  If we're going to export them at all then
> > as _GPL (which is grossly misnamed and should be _INTERNAL)
> 
> And from the other thread created by my mistake.
> 
>  > What do you need it for?  Please send the whole patch series (and
>  > generally anything in libata that interacts with the scsi midlayer) to
>  > linux-scsi, please.
> 
> It's rather large patchset consisting of 13 libata-eh related patches. 
> Only two of the patches are relevant to SCSI.  I'm not sure whether 
> cross-posting the whole thing is appropriate.
> 
> The first one exports two scsi_eh functions (this thread) and the second 
> one uses these two to implement ata_eh_retry/complete helpers.
> 
> http://marc.theaimsgroup.com/?l=linux-ide&m=113798939719926&w=2
> http://marc.theaimsgroup.com/?l=linux-ide&m=113798939627887&w=2
> 
> These are used because libata implements shost->eh_strategy_handler for 
> error handling.  libata's ->eh_strategy_handler should do everything 
> scsi_unjam_host() does and one chunk is to retry or complete failed SCSI 
> commands during or after EH completes.  libata used to do this by 
> calling scsi_finish_command() directly, which is an internal interface 
> too.  Directly calling scsi_finish_command() also used to have deadlock 
> problem when libata shared SCSI's host lock.
> 
> As what has to be done is identical, above two patches make libata share 
> that part of code with scsi_unjam_host().  And, as Jeff commented, once 
> these are settled scsi_fini_command() can be unexported.

Let me understand:

So when scsi_finish_command() is unexported, then _all_ EH strategies
would have to define local done_q, and splice eh_cmd_q into local work_q,
then from local work_q into local done_q and then that is passed
to SCSI Core, via scsi_eh_flush_done_q().

Is it possible that this is done asynchrounously?  Since EH recovery is
per host, but you may have only a single device which is misbehaving?

I.e. is it possible, in a such and such EH strategy, not necessarily
SCSI Cores's or libata's, to _not_ have a local done_q?  So that,
we have only local work_q (after splicing eh_cmd_q) and after each
command is looked at, we "return" that command back to SCSI Core, so
that SCSI Core can "finish" it. (In effect "per-command", as opposed to
"per-queue-of-commands".)

Alternatively, simulating this using one-command-per-local-done_q and
calling scsi_eh_flush_done_q() each time a single command is added
to local done_q would seem rather inefficient.

    Luben

