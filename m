From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] zfcp: kfree patch
Date: Mon, 10 Jan 2005 09:19:51 -0600
Message-ID: <1105370391.4477.3.camel@mulgrave>
References: <OFF5A7977B.6DEBE53D-ONC1256F85.00246A36-C1256F85.0024C19A@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:54480 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262301AbVAJPvP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jan 2005 10:51:15 -0500
In-Reply-To: <OFF5A7977B.6DEBE53D-ONC1256F85.00246A36-C1256F85.0024C19A@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Heiko Carstens <Heiko.Carstens@de.ibm.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Greg Kroah-Hartman <greg@kroah.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2005-01-10 at 07:41 +0100, Heiko Carstens wrote:
> What would keep the two release functions defined in
> scsi_transport_fc.c from being called _after_ the fc transport class
> module was unloaded? As usual I might be wrong but this looks like
> the same problem to me.

Object lifetime rules:  devices which are attached to transport classes
must be serviced by HBAs which do the attachment.  This makes the
transport class a required module for the HBA.  So the transport class
can't be removed until all of the HBAs have been removed (which means
that all the objects they service have also been removed).

If you're asking how SCSI ensures that all the scsi_devices are
destroyed before the HBA driver is removed, we have a module reference
count system that means the HBA unload waits until everything
relinquishes the devices.

James


