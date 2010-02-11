From: Bernd Schubert <bs_lists@aakef.fastmail.fm>
Subject: Re: [PATCH 1/1] fusion: hold off error recovery while alternate ioc is initializing
Date: Thu, 11 Feb 2010 18:53:12 +0100
Message-ID: <201002111853.12306.bs_lists@aakef.fastmail.fm>
References: <4B7317C0.8080209@sgi.com> <1C9608B8A4CD534FB19C7C7543CBB24901291B5D32@inbmail02.lsi.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:51668 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755894Ab0BKRxO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Feb 2010 12:53:14 -0500
In-Reply-To: <1C9608B8A4CD534FB19C7C7543CBB24901291B5D32@inbmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: Michael Reed <mdr@sgi.com>, linux-scsi <linux-scsi@vger.kernel.org>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>, "Moore, Eric" <Eric.Moore@lsi.com>, Jeremy Higdon <jeremy@sgi.com>, Robin Holt <holt@sgi.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@hansenpartnership.com>

Shouldn't we create a similar patch for scsi and sas as well? This issue might 
explain why any hard-reset (for scsi systems of my former employer) always 
caused a complete failure of both ports.


Thanks,
Bernd

On Thursday 11 February 2010, Desai, Kashyap wrote:
> Please consider this patch as an ACKed.
> 
> Thanks,
> Kashyap
> 
> > -----Original Message-----
> > From: Michael Reed [mailto:mdr@sgi.com]
> > Sent: Thursday, February 11, 2010 2:02 AM
> > To: linux-scsi; Desai, Kashyap; Prakash, Sathya
> > Cc: Moore, Eric; Jeremy Higdon; Robin Holt
> > Subject: [PATCH 1/1] fusion: hold off error recovery while alternate
> > ioc is initializing
> >
> > After discussing this patch with LSI, I resubmitting with a recommended
> > 40 second wait for the alternate ioc's initialization to complete.
> > --
> > Fusion FC chips are two function with some shared resources.  During
> > initialization of one function its driver inhibits the ability of the
> > other function's driver to allocate message frames by clearing its
> > "active" flag.  Should mid-layer error recovery be initiated for a
> > scsi command during this initialization (which can take up to 40
> > seconds)
> > error recovery will escalate to the level of host reset.  This host
> > reset might fail (as the other function is resetting) resulting in
> > all connected targets being taken offline.
> >
> > This patch holds off mid-layer error recovery for up to 40 seconds
> > to permit initialization of the other function to complete.
> >
> > Applies to scsi-misc.
> >
> > Signed-off-by: Michael Reed <mdr@sgi.com>
> >
> > ==
> >
> > --- scsi-misc-2.6/drivers/message/fusion/mptfc.c	2010-02-08
> > 11:19:47.000000000 -0600
> > +++ scsi-misc-2.6-2010_02_08-modified/drivers/message/fusion/mptfc.c
> > 	2010-02-10 12:40:23.184510802 -0600
> > @@ -195,29 +195,34 @@ mptfc_block_error_handler(struct scsi_cm
> >  	unsigned long		flags;
> >  	int			ready;
> >  	MPT_ADAPTER 		*ioc;
> > +	int			loops = 40;	/* seconds */
> >
> >  	hd = shost_priv(SCpnt->device->host);
> >  	ioc = hd->ioc;
> >  	spin_lock_irqsave(shost->host_lock, flags);
> > -	while ((ready = fc_remote_port_chkready(rport) >> 16) ==
> > DID_IMM_RETRY) {
> > +	while ((ready = fc_remote_port_chkready(rport) >> 16) ==
> > DID_IMM_RETRY
> > +	 || (loops > 0 && ioc->active == 0)) {
> >  		spin_unlock_irqrestore(shost->host_lock, flags);
> >  		dfcprintk (ioc, printk(MYIOC_s_DEBUG_FMT
> >  			"mptfc_block_error_handler.%d: %d:%d, port status is
> > "
> > -			"DID_IMM_RETRY, deferring %s recovery.\n",
> > +			"%x, active flag %d, deferring %s recovery.\n",
> >  			ioc->name, ioc->sh->host_no,
> > -			SCpnt->device->id, SCpnt->device->lun, caller));
> > +			SCpnt->device->id, SCpnt->device->lun,
> > +			ready, ioc->active, caller));
> >  		msleep(1000);
> >  		spin_lock_irqsave(shost->host_lock, flags);
> > +		loops --;
> >  	}
> >  	spin_unlock_irqrestore(shost->host_lock, flags);
> >
> > -	if (ready == DID_NO_CONNECT || !SCpnt->device->hostdata) {
> > +	if (ready == DID_NO_CONNECT || !SCpnt->device->hostdata
> > +	 || ioc->active == 0) {
> >  		dfcprintk (ioc, printk(MYIOC_s_DEBUG_FMT
> >  			"%s.%d: %d:%d, failing recovery, "
> > -			"port state %d, vdevice %p.\n", caller,
> > +			"port state %x, active %d, vdevice %p.\n", caller,
> >  			ioc->name, ioc->sh->host_no,
> >  			SCpnt->device->id, SCpnt->device->lun, ready,
> > -			SCpnt->device->hostdata));
> > +			ioc->active, SCpnt->device->hostdata));
> >  		return FAILED;
> >  	}
> >  	dfcprintk (ioc, printk(MYIOC_s_DEBUG_FMT
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

