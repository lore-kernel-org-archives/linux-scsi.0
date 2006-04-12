From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH 1/2] SCSI: implement scsi_eh_schedule_cmd()
Date: Wed, 12 Apr 2006 01:24:42 -0700 (PDT)
Message-ID: <20060412082442.49921.qmail@web31809.mail.mud.yahoo.com>
References: <443C642E.5090106@gmail.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <443C642E.5090106@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>, Patrick Mansfield <patmans@us.ibm.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, hch@lst.de, James.Bottomley@SteelEye.com, alan@lxorguk.ukuu.org.uk, albertcc@tw.ibm.com, arjan@infradead.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--- Tejun Heo <htejun@gmail.com> wrote:
> Patrick Mansfield wrote:
> > On Tue, Apr 11, 2006 at 01:41:57PM -0400, Jeff Garzik wrote:
> >> Tejun Heo wrote:
> >>> + * scsi_eh_schedule_cmd - schedule scsi cmd for error handling.
> >>> + * @scmd:	scmd to run eh on.
> >>> + *
> >>> + * Description:
> >>> + *	This function is used by LLDDs which don't use standard SCSI
> >>> + *	EH to schedule scmd for EH.
> >>> + *
> >>> + * Return value:
> >>> + *	0 on failure.
> >>> + **/
> >>> +int scsi_eh_schedule_cmd(struct scsi_cmnd *scmd)
> [--snip--]
> >>
> >> ACK, though this patch makes me think that there are some non-libata 
> >> pieces of code that could use this function.
> >>
> >> Unfortunately for libata, we are stuck waiting on linux-scsi people to 
> >> return and give their opinion.  If nobody complains, I'll apply it, if 
> >> it doesn't appear in scsi-misc-2.6 sometime vaguely soon.
> > 
> > Per other email it should be called scsi_req_abort_cmd() or such, as that
> > is the only reason to call it, correct?
> 
> Well, it's named this way is to keep it consistent with 
> scsi_eh_schedule_host().  Either name is okay with me but driver which 
> use this function probably have interest in schedule_host() but not in 
> other SCSI EH functions.  So, considering that, I think the current 
> naming is okay.

Tejun, note that scsi_req_abort_cmd() absolves your patch.
I think this is what Pat is trying to say.  I.e. it is much
more general and thus applies to more applications (as in uses).
Plus it is shorter, simpler (3 lines) and more straightforward.

So, scsi_eh_reschedule_host() is equivalent to simply scsi_req_abort_cmd(cmd)
xor scsi_req_dev_reset(dev), the latter in case you want to notify without
piggybacking on a command.

Also, your routine calls more specific eh routines and you should try
to be more general.

> > Any other handling can be completed by calling the ->done function.
> > 
> > Even the abort/cancel could be done in the driver without this, I assume
> > it is avaiable so the driver can use the eh process and existing code
> > paths rather than duplicate similar code.
> 
> Yeap, as I noted earlier, passing scmds to EH is possible without this 
> function but it has to be done in a quite hackish way.  My earlier 

Indeed.

> libata EH implementation did this by completing the scmd with CHECK 
> CONDITION but without sense data which makes SCSI midlayer invoke EH to 
> acquire sense data, at which point libata EH can take over and do EH. 

Ouch!

Good thing you rewrought your solution:
1. you naturally arive at a better solution,
2. you are trying to bring some sense into "libata" and indirectly SCSI.

> It's just ugly.  Again, I'm okay with whatever that works, but things 
> are much simpler this way.

Or maybe even simpler this way:

void scsi_req_abort_cmd(struct scsi_cmnd *cmd)
{
	if (!scsi_delete_timer(cmd))
		return;
	scsi_times_out(cmd);
}
EXPORT_SYMBOL(scsi_req_abort_cmd);
as posted here: http://marc.theaimsgroup.com/?l=linux-scsi&m=113833937421677&w=2

(Had one page on error recovery discussion here, but deleted it
as it wasn't relevant.)

Good luck!
      Luben

