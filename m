From: "Mukker, Atul" <Atulm@lsil.com>
Subject: RE: [ANNOUNCE]: megaraid driver version 2.20.0.1
Date: Tue, 6 Jul 2004 14:32:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57033BC826@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:39656 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S264260AbUGFSdY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jul 2004 14:33:24 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@SteelEye.com>
Cc: 'Christoph Hellwig' <hch@infradead.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

> The biggest structural issue still seems to be the pending queue.  It
> looks to me like the driver could be nicely simplified if you 
> got rid of
> it and simply relied on returning SCSI_MLQUEUE_HOST_BUSY from
> queeucommand().  You'd still get the queue restart almost from the ISR
This is a very good suggestion and I would be more than willing to include
in the driver code. Only one concern though, there are other instances also
when we need to stop sending commands to the controllers, but not
necessarily stop getting commands from mid-layer. E.g., in case of delete
drive operation, driver has to wait till all outstanding commands to the
controller are complete, before issuing drive deletion command. In this
situation, having a pending list seems natural.

> Something like
> 
> if (mbox->numstatus != 0xFF)
> 	goto out;
> udelay(25);
> for (i = 0; mbox->numstatus != 0xFF && i < 1000; i++)
> 	msleep(1);
> out:

Sounds good

-Atul Mukker
