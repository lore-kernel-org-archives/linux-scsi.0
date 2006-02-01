From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] SCSI: Introduce scsi_req_abort_cmd
Date: Tue, 31 Jan 2006 19:39:06 -0800 (PST)
Message-ID: <20060201033906.30216.qmail@web31811.mail.mud.yahoo.com>
References: <1138750263.3307.40.camel@mulgrave>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31811.mail.mud.yahoo.com ([68.142.207.74]:2713 "HELO
	web31811.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1030235AbWBADjJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Jan 2006 22:39:09 -0500
In-Reply-To: <1138750263.3307.40.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

--- James Bottomley <James.Bottomley@SteelEye.com> wrote:
> On Thu, 2006-01-26 at 21:22 -0800, Luben Tuikov wrote:
> > Introduce scsi_req_abort_cmd(struct scsi_cmnd *).
> > This function requests that SCSI Core start recovery for the
> > command by deleting the timer and adding the command to the eh
> > queue.  It can be called by either LLDDs or SCSI Core.  LLDDs who
> > implement their own error recovery MAY ignore the timeout event if
> > they generated scsi_req_abort_cmd.
> 
> In theory, the code to do this already exists: the current way to
> achieve this is supposed to be to return a status of DID_TIME_OUT to the
> command, which triggers error recovery.  The only difference between
> this and what you propose is that the eh_timed_out API won't get called
> (presumably OK since the LLD already knows it wishes to trigger the
> error handler) and that the error handler will begin at the device reset
> task management function (again, on the assumption that the LLD cleaned
> everything up before returning DID_TIME_OUT).  Is that sufficient for
> your purpose or do we really need another API?

No, it is not sufficient.
Yes, you really do need another API.

   Luben

