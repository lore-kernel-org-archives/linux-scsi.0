From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] RESEND: SCSI, libata: add support for ATA_16 commands
 to libata ATAPI devices
Date: Thu, 01 Feb 2007 03:28:45 -0500
Message-ID: <45C1A4BD.3030909@garzik.org>
References: <200701021935.07840.liml@rtr.ca> <200701311346.26644.liml@rtr.ca> <45C1356B.6000907@gmail.com> <45C1377F.6070001@rtr.ca> <45C138E8.1040706@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:37041 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422665AbXBAI2s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Feb 2007 03:28:48 -0500
In-Reply-To: <45C138E8.1040706@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Mark Lord <liml@rtr.ca>, Linux IDE <linux-ide@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

Tejun Heo wrote:
> SCSI always uses the smallest command it can use, so we're safe.  Most
> other commands are issued directly from the userland and it's their
> responsibility not to feed disallowed commands to a device (or we need
> more advanced filter).  Anyways, this has never been guaranteed because
> the limit is host wide.
> 
> So, I'm for setting it to 16.  Jeff, what do you think?


Like I just noted in another email, the limit is really on the /device/ 
side.  In theory the user could plug in a 16-byte ATAPI device and a 
12-byte ATAPI device to the same host.

We should be able to safely raise the limit to 16-byte for most host 
controllers.  Note I said "most".  The bitch will be figuring out which 
host controllers do not like 16-byte CDBs.

	Jeff


