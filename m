From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH v2] libata: Simulate REPORT LUNS for ATAPI devices
Date: Thu, 07 Dec 2006 12:09:43 -0600
Message-ID: <1165514983.4698.21.camel@mulgrave.il.steeleye.com>
References: <4574A90E.5010801@us.ibm.com> <4574AB78.40102@garzik.org>
	 <4574B004.6030606@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4574B004.6030606@us.ibm.com>
Sender: linux-ide-owner@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2006-12-04 at 15:32 -0800, Darrick J. Wong wrote:
> The Quantum GoVault SATAPI removable disk device returns ATA_ERR in
> response to a REPORT LUNS packet.  If this happens to an ATAPI device
> that is attached to a SAS controller (this is the case with sas_ata),
> the device does not load because SCSI won't touch a "SCSI device"
> that won't report its LUNs.  Since most ATAPI devices don't support
> multiple LUNs anyway, we might as well fake a response like we do for
> ATA devices.

Actually, there may be a standards conflict here.  SPC says that all
devices reporting compliance with this standard (as the inquiry data for
this device claims) shall support REPORT LUNS.  On the other hand, MMC
doesn't list REPORT LUNS in its table of mandatory commands.

I'm starting to think that even if they report a SCSI compliance level
of 3 or greater, we still shouldn't send REPORT LUNS to devices that
return MMC type unless we have a white list override.

James


