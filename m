From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [ANNOUNCE]: megaraid driver version 2.20.0.1
Date: 06 Jul 2004 15:56:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1089147398.2188.689.camel@mulgrave>
References: <0E3FA95632D6D047BA649F95DAB60E57033BC826@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:44461 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264492AbUGFU4v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Jul 2004 16:56:51 -0400
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57033BC826@exa-atlanta>
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <Atulm@lsil.com>
Cc: 'Christoph Hellwig' <hch@infradead.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

On Tue, 2004-07-06 at 13:32, Mukker, Atul wrote:
> > The biggest structural issue still seems to be the pending queue.  It
> > looks to me like the driver could be nicely simplified if you 
> > got rid of
> > it and simply relied on returning SCSI_MLQUEUE_HOST_BUSY from
> > queeucommand().  You'd still get the queue restart almost from the ISR
> This is a very good suggestion and I would be more than willing to include
> in the driver code. Only one concern though, there are other instances also
> when we need to stop sending commands to the controllers, but not
> necessarily stop getting commands from mid-layer. E.g., in case of delete
> drive operation, driver has to wait till all outstanding commands to the
> controller are complete, before issuing drive deletion command. In this
> situation, having a pending list seems natural.

We have this type of functionality already in the scsi_device_quiesce()
interface.  It will not return until all normal commands have completed
(specials and error handling are still allowed).  It was designed for
Domain Validation, but it sounds like you could use it as well.

James


