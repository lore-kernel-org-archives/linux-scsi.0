From: "Ed Lin" <ed.lin@promise.com>
Subject: RE: [PATCH 4/4] [SCSI]stex: minor cleanup and version update
Date: Mon, 2 Apr 2007 11:21:08 -0700
Message-ID: <B70A50D07063384EB9BCE3330D18414F0327EBC8@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 67.111.72.3.ptr.us.xo.net ([67.111.72.3]:54303 "EHLO
	nonameb.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965650AbXDBSTe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Apr 2007 14:19:34 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "james.Bottomley" <james.Bottomley@SteelEye.com>, jeff <jeff@garzik.org>, Promise_Linux <Promise_Linux@promise.com>



> -----Original Message-----
> From: Brian King [mailto:brking@us.ibm.com] 
> Sent: Monday, April 02, 2007 9:05 AM
> To: Ed Lin
> Cc: linux-scsi; linux-kernel; james.Bottomley; jeff; Promise_Linux
> Subject: Re: [PATCH 4/4] [SCSI]stex: minor cleanup and version update
> 
> 
> Ed Lin wrote:
> > @@ -1007,6 +1008,11 @@ static int stex_abort(struct scsi_cmnd *
> >  	u32 data;
> >  	int result = SUCCESS;
> >  	unsigned long flags;
> > +
> > +	printk(KERN_INFO DRV_NAME
> > +		"(%s): aborting command\n", pci_name(hba->pdev));
> > +	scsi_print_command(cmd);
> > +
> 
> scmd_printk is probably what you want here rather than just a printk.
> 
> scmd_printk(KERN_ERR, cmd, "aborting command\n");
> 
> 
> > @@ -1092,6 +1098,10 @@ static int stex_reset(struct scsi_cmnd *
> >  	unsigned long before;
> >  	hba = (struct st_hba *) &cmd->device->host->hostdata[0];
> > 
> > +	printk(KERN_INFO DRV_NAME
> > +		"(%s): resetting host\n", pci_name(hba->pdev));
> > +	scsi_print_command(cmd);
> > +
> 
> Same here.

Well it's just because printk with pci_name stuff is used across
the driver, and I didn't want to break the rule... 
