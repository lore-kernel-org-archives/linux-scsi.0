From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] RESEND: SCSI, libata: add support for ATA_16 commands
	to libata ATAPI devices
Date: Wed, 31 Jan 2007 18:48:27 -0600
Message-ID: <1170290907.3402.90.camel@mulgrave.il.steeleye.com>
References: <200701021935.07840.liml@rtr.ca>
	 <200701311346.26644.liml@rtr.ca> <45C1356B.6000907@gmail.com>
	 <45C1377F.6070001@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <45C1377F.6070001@rtr.ca>
Sender: linux-ide-owner@vger.kernel.org
To: Mark Lord <liml@rtr.ca>
Cc: Tejun Heo <htejun@gmail.com>, Linux IDE <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2007-01-31 at 19:42 -0500, Mark Lord wrote:
> Sure thing, if you and Jeff are happy with that, then lets do it.
> 
> I just kind of assumed that the complexity in
> ata_set_port_max_cmd_len()
> was there for some kind of reason.
> 
> For example, I think all existing ATAPI drives only speak 12-byte
> packet
> protocols, and so if we tell SCSI we're good for 16-byte, then won't
> the
> SCSI layer suddenly start sending us READ_16 and the like?

The SCSI parameter max_cdb is supposed to reflect the host, not the
device.  This is for the nutcase of connecting a > 2TB array to say a
qla1280 ... the mid-layer and the device can both go beyond 2TB but the
HBA can't (being limited to 12 byte commands).

In SCSI, we're very careful only to use large commands where necessary,
so even for a >2TB array, you only see 16 byte commands for sectors
beyond 2TB.  This essentially means that the capacity (and we do a
careful READ_CAPACITY(10) and only move on to READ_CAPACITY(16) if we're
told to) limits the command size.

James


