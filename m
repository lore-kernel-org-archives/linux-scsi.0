From: Willem Riede <wrlk@riede.org>
Subject: Re: sense buffer not cleaned when retrying failed command by the eh
Date: Tue, 13 Jan 2004 17:56:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040113225609.GE4339@linnie.riede.org>
References: <40028A1A.2030609@il.marvell.com> <20040113002656.GW4339@linnie.riede.org> <20040113074048.GA1280@beaverton.ibm.com>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rwcrmhc11.comcast.net ([204.127.198.35]:3502 "EHLO
	rwcrmhc11.comcast.net") by vger.kernel.org with ESMTP
	id S265848AbUAMW4R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jan 2004 17:56:17 -0500
Received: from linnie.riede.org (localhost.localdomain [127.0.0.1])
	by linnie.riede.org (8.12.10/8.12.10) with ESMTP id i0DMuAEM018505
	for <linux-scsi@vger.kernel.org>; Tue, 13 Jan 2004 17:56:12 -0500
Content-Disposition: inline
In-Reply-To: <20040113074048.GA1280@beaverton.ibm.com> (from andmike@us.ibm.com on Tue, Jan 13, 2004 at 02:40:48 -0500)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On 2004.01.13 02:40, Mike Anderson wrote:
> Willem Riede [wrlk@riede.org] wrote:
> > On 2004.01.12 06:50, Saeed Bishara wrote:
> > What about in the 2.6 kernel:
> > 
> > --- drivers/scsi/scsi_lib.c.orig	2004-01-12 18:40:28.000000000 -0500
> > +++ drivers/scsi/scsi_lib.c	2004-01-12 18:50:22.000000000 -0500
> > @@ -302,6 +302,7 @@
> >  void scsi_setup_cmd_retry(struct scsi_cmnd *cmd)
> >  {
> >  	memcpy(cmd->cmnd, cmd->data_cmnd, sizeof(cmd->data_cmnd));
> > +	memset(cmd->sense_buffer, 0, sizeof(cmd->sense_buffer));
> >  	cmd->request_buffer = cmd->buffer;
> >  	cmd->request_bufflen = cmd->bufflen;
> >  	cmd->use_sg = cmd->old_use_sg;
> > 
> 
> In the 2.6 kernel this is cleared in scsi_retry_command. 

So it is. But scsi_retry_command is not called by the error handler --
not referenced from scsi_error.c at all. And the memset to zero could
trivially be dropped from scsi_retry_command.

>                                                          The other
> callers of scsi_setup_cmd_retry do not want the sense_buffer cleared as
> it has been set prior to calling scsi_setup_cmd_retry. 
              ^^^
Set? To what? Is there any case where the sense buffer is supposed to 
reflect anything else than the result of the retry once it is completed?

If there is, I would not consider that good programming practice...
If there isn't, then clearing the sense buffer before the retry is
perfectly OK.

Regards, Willem Riede.

