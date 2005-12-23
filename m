From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [SCSI] Add support for braindead Cypress USB ATA passthrough
	CDBs
Date: Fri, 23 Dec 2005 11:59:29 -0600
Message-ID: <1135360770.3728.27.camel@mulgrave>
References: <20051221122442.GA16571@porkrind.org>
	 <1135353160.3728.10.camel@mulgrave>  <43AC36B5.3000209@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:34749 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1030601AbVLWSBX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Dec 2005 13:01:23 -0500
In-Reply-To: <43AC36B5.3000209@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: David Caldwell <david@porkrind.org>, linux-scsi@vger.kernel.org

On Fri, 2005-12-23 at 12:41 -0500, Jeff Garzik wrote:
> James Bottomley wrote:
> > 1) Simply don't mangle the LUN for SCSI_UNKNOWN and then have all the
> > subsystems lying about SCSI_2 compliance instead set their mangled level
> > to SCSI_UNKNOWN (which seems to be more truthful)
> 
> It is specified in MMC that ATAPI or USB may be SCSI level to zero. 
> Thus "lying" is not really accurate at all.  We need to update SCSI to 
> handle these devices as specified.

Isn't that what I proposed?

But it only fixes the devices whose SCSI level is correctly passed on to
the mid-layer.  There's still the problem of USB and other subsystems
mangling the level back to SCSI_2 which causes the LUN to be placed in
cdb[1] as per spec.  

> This is why I snoop INQUIRY for ATAPI devices in libata-scsi, and force 
> the SCSI version to 0x05, if SCSI version is returned from the device as 
> zero.  It is conditional because -- due to the wonderful world of 
> hardware -- some ATAPI devices (such as SCSI devices plugged into an 
> SPI<->ATA bridge) and some USB devices correctly report SCSI version.

Well, that's SCSI3 (SPC-3), which is fine, but does mean we try
REPORT_LUNS scanning.  The problem in other subsystems is that some
devices hang when they see a REPORT_LUNS command.

What problems do you see returning zero (apart from cdb[1] changes)?

James


