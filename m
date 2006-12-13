From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH v2] libata: Simulate REPORT LUNS for ATAPI devices
Date: Wed, 13 Dec 2006 12:06:44 -0800
Message-ID: <45805D54.3070809@us.ibm.com>
References: <4574A90E.5010801@us.ibm.com> <4574AB78.40102@garzik.org>	<4574B004.6030606@us.ibm.com> <20061213185627.GA21535@us.ibm.com>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:50106 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965136AbWLMUHH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Dec 2006 15:07:07 -0500
In-Reply-To: <20061213185627.GA21535@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>

Patrick Mansfield wrote:
> On Mon, Dec 04, 2006 at 03:32:20PM -0800, Darrick J. Wong wrote:
>> The Quantum GoVault SATAPI removable disk device returns ATA_ERR in
>> response to a REPORT LUNS packet.  If this happens to an ATAPI device
>> that is attached to a SAS controller (this is the case with sas_ata),
>> the device does not load because SCSI won't touch a "SCSI device"
>> that won't report its LUNs.  Since most ATAPI devices don't support
>> multiple LUNs anyway, we might as well fake a response like we do for
>> ATA devices.
> 
> If the REPORT LUNS fails, we should fall back to a sequential scan.
> 
> Is (or why isn't) the error propagated back to scsi?

I believe the error is reported back to SCSI, which attempts to follow
up with TEST UNIT READY.  Unfortunately, for some reason the device then
gets dropped.  libata normally calls __scsi_add_device with lun=0, but
SAS calls scsi_scan_target with lun=SCAN_WILD_CARD, which is why SCSI
sends REPORT LUNs in the first place.

As an alternative I suppose we could detect ATA devices in sas_rphy_add
and change that SCAN_WILD_CARD to "0".

--D
