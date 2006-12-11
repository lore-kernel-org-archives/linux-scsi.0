From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH v2] libata: Simulate REPORT LUNS for ATAPI devices
Date: Mon, 11 Dec 2006 11:24:23 -0500
Message-ID: <457D8637.5070707@garzik.org>
References: <4574A90E.5010801@us.ibm.com> <4574AB78.40102@garzik.org> <4574B004.6030606@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:47280 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937017AbWLKQY1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Dec 2006 11:24:27 -0500
In-Reply-To: <4574B004.6030606@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Douglas Gilbert <dougg@torque.net>

Darrick J. Wong wrote:
> The Quantum GoVault SATAPI removable disk device returns ATA_ERR in
> response to a REPORT LUNS packet.  If this happens to an ATAPI device
> that is attached to a SAS controller (this is the case with sas_ata),
> the device does not load because SCSI won't touch a "SCSI device"
> that won't report its LUNs.  Since most ATAPI devices don't support
> multiple LUNs anyway, we might as well fake a response like we do for
> ATA devices.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

I'm leaning towards applying this, perhaps with a module option that 
allows experimenters to revert back to the older behavior.

Any chance you could be talked into tackling some of the SAT 
translation-related items Doug G mentioned?  I'm almost certain there 
are some info pages we should be returning, but are not, at the very least.

	Jeff



