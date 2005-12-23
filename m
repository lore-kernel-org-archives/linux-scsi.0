From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [SCSI] Add support for braindead Cypress USB ATA passthrough
 CDBs
Date: Fri, 23 Dec 2005 12:41:09 -0500
Message-ID: <43AC36B5.3000209@pobox.com>
References: <20051221122442.GA16571@porkrind.org> <1135353160.3728.10.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:25793 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1030583AbVLWRlU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Dec 2005 12:41:20 -0500
In-Reply-To: <1135353160.3728.10.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: David Caldwell <david@porkrind.org>, linux-scsi@vger.kernel.org

James Bottomley wrote:
> 1) Simply don't mangle the LUN for SCSI_UNKNOWN and then have all the
> subsystems lying about SCSI_2 compliance instead set their mangled level
> to SCSI_UNKNOWN (which seems to be more truthful)

It is specified in MMC that ATAPI or USB may be SCSI level to zero. 
Thus "lying" is not really accurate at all.  We need to update SCSI to 
handle these devices as specified.

This is why I snoop INQUIRY for ATAPI devices in libata-scsi, and force 
the SCSI version to 0x05, if SCSI version is returned from the device as 
zero.  It is conditional because -- due to the wonderful world of 
hardware -- some ATAPI devices (such as SCSI devices plugged into an 
SPI<->ATA bridge) and some USB devices correctly report SCSI version.

	Jeff


