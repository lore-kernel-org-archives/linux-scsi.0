From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Patch: change the serial_number for error-handler commands
Date: Tue, 20 May 2003 21:19:27 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0305202110520.4914-100000@netrider.rowland.org>
References: <3ECA9D46.7010301@rogers.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeus.kernel.org ([204.152.189.113]:43651 "EHLO zeus.kernel.org")
	by vger.kernel.org with ESMTP id S261702AbTEUI4U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2003 04:56:20 -0400
Received: from netrider.rowland.org (netrider.rowland.org [192.131.102.5])
	by zeus.kernel.org (8.11.6/8.11.6) with SMTP id h4L1JS618918
	for <linux-scsi@vger.kernel.org>; Tue, 20 May 2003 18:19:28 -0700
In-Reply-To: <3ECA9D46.7010301@rogers.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <tluben@rogers.com>
Cc: Mike Anderson <andmike@us.ibm.com>, linux-scsi@vger.kernel.org

On Tue, 20 May 2003, Luben Tuikov wrote:

> Alan Stern wrote:
> > ===== scsi_error.c 1.27 vs edited =====
> > --- 1.27/drivers/scsi/scsi_error.c	Sun May  4 12:50:44 2003
> > +++ edited/drivers/scsi/scsi_error.c	Mon May 19 14:17:04 2003
> > @@ -753,6 +753,8 @@
> >  	scmd->cmd_len = COMMAND_SIZE(scmd->cmnd[0]);
> >  	scmd->underflow = 0;
> >  	scmd->sc_data_direction = SCSI_DATA_NONE;
> > +	if ((scmd->serial_number -= 999999) == 0)
> > +		scmd->serial_number -= 999999;
> >  
> >  	rtn = scsi_send_eh_cmnd(scmd, SENSE_TIMEOUT);
> 
> Alan, could you please explain this patch?

It's just to insure that when the error handler sends a TEST-UNIT-READY,
the serial number is different from that of the immediately-prior failed
command (or from that of any command issued recently or likely to be
issued in the near future).

> This looks like:
> 	if (sn == 999999)
> 		sn = -sn;
> 
> for _that_ particular command, but scsi_core->sn stays unchanged...

Well, the patch changes the serial number regardless of its initial value,
but otherwise yes.  It would be okay with me to change scsi_core->sn.  
But the global serial number is currently a static variable defined in
scsi.c and my change was to scsi_error.c -- I didn't want to export the
variable needlessly.

> Q: Which value does USB Storage reserve for cmdsn, 0 or MAX?

It doesn't reserve any values.  (I avoided 0 only because I noticed that
the scsi core uses 0 as a reserved value.)  Usb-storage just requires that
serial numbers not be repeated.

Alan Stern

