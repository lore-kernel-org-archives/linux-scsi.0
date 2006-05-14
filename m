From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH 01/22] SCSI: Introduce scsi_req_abort_cmd (REPOST)
Date: Sat, 13 May 2006 19:00:44 -0700 (PDT)
Message-ID: <20060514020044.14268.qmail@web31801.mail.mud.yahoo.com>
References: <44664DED.4000501@pobox.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31801.mail.mud.yahoo.com ([68.142.207.64]:8583 "HELO
	web31801.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S964794AbWENCAo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 May 2006 22:00:44 -0400
In-Reply-To: <44664DED.4000501@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>
Cc: alan@lxorguk.ukuu.org.uk, axboe@suse.de, albertcc@tw.ibm.com, forrest.zhao@intel.com, efalk@google.com, linux-ide@vger.kernel.org, Luben Tuikov <ltuikov@yahoo.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

--- Jeff Garzik <jgarzik@pobox.com> wrote:

> Tejun Heo wrote:
> > Introduce scsi_req_abort_cmd(struct scsi_cmnd *).
> > This function requests that SCSI Core start recovery for the
> > command by deleting the timer and adding the command to the eh
> > queue.  It can be called by either LLDDs or SCSI Core.  LLDDs who
> > implement their own error recovery MAY ignore the timeout event if
> > they generated scsi_req_abort_cmd.
> 
> ACK...
> 
> 
> > 2dcc69f8559ce963d637e881ca168afd91ee2478
> > diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> > index 73994e2..dae4f08 100644
> > --- a/drivers/scsi/scsi.c
> > +++ b/drivers/scsi/scsi.c
> > @@ -720,6 +720,24 @@ void scsi_init_cmd_from_req(struct scsi_
> >  static DEFINE_PER_CPU(struct list_head, scsi_done_q);
> >  
> >  /**
> > + * scsi_req_abort_cmd -- Request command recovery for the specified command
> > + * cmd: pointer to the SCSI command of interest
> > + *
> > + * This function requests that SCSI Core start recovery for the
> > + * command by deleting the timer and adding the command to the eh
> > + * queue.  It can be called by either LLDDs or SCSI Core.  LLDDs who
> > + * implement their own error recovery MAY ignore the timeout event if
> > + * they generated scsi_req_abort_cmd.
> > + */
> > +void scsi_req_abort_cmd(struct scsi_cmnd *cmd)
> > +{
> > +	if (!scsi_delete_timer(cmd))
> > +		return;
> > +	scsi_times_out(cmd);
> > +}
> > +EXPORT_SYMBOL(scsi_req_abort_cmd);
> > +
> > +/**
> >   * scsi_done - Enqueue the finished SCSI command into the done queue.
> >   * @cmd: The SCSI Command for which a low-level device driver (LLDD) gives
> >   * ownership back to SCSI Core -- i.e. the LLDD has finished with it.
> > diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> > index 1ace1b9..88c6c4d 100644
> > --- a/include/scsi/scsi_cmnd.h
> > +++ b/include/scsi/scsi_cmnd.h
> > @@ -151,5 +151,6 @@ extern struct scsi_cmnd *scsi_get_comman
> >  extern void scsi_put_command(struct scsi_cmnd *);
> >  extern void scsi_io_completion(struct scsi_cmnd *, unsigned int, unsigned int);
> >  extern void scsi_finish_command(struct scsi_cmnd *cmd);
> > +extern void scsi_req_abort_cmd(struct scsi_cmnd *cmd);
> >  
> >  #endif /* _SCSI_SCSI_CMND_H */
> 
> Patch quoted in its entirety, since this copy wasn't CC'd to linux-scsi.

No, the patch isn't quoted in its entirety.  You deleted a bunch of lines.
See my next email where I simply CC lsml, and don't delete any lines.

Good luck,
      Luben


