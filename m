From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 1/2] scsi: Add scsi_device max_cmd_len (resend)
Date: Fri, 28 Apr 2006 15:56:43 -0500
Message-ID: <1146257803.5251.82.camel@mulgrave.il.steeleye.com>
References: <200604172240.k3HMes2V010154@d01av01.pok.ibm.com>
	 <44522672.5010607@us.ibm.com>
	 <1146237433.5251.7.camel@mulgrave.il.steeleye.com>
	 <44525CBE.1030409@us.ibm.com>
	 <1146249006.5251.64.camel@mulgrave.il.steeleye.com>
	 <44526702.1010400@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:6083 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751807AbWD1U4q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Apr 2006 16:56:46 -0400
In-Reply-To: <44526702.1010400@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@us.ibm.com
Cc: linux-scsi@vger.kernel.org, jgarzik@pobox.com, linux-ide@vger.kernel.org

On Fri, 2006-04-28 at 14:03 -0500, Brian King wrote:
> > Perhaps you could tell me what the actual failure case is?  
> 
> I don't have any data on how ATA/ATAPI devices respond if they receive
> too large of a CDB, but my guess is they probably don't react nicely.
> Today libata uses the hosts's max_cmd_len for some protection against
> this, I was merely trying to continue with a similar level of
> protection in my new usage of libata.

But how would they receive too large a CDB?  This is identical to the
situation today with a legacy SPI drive and a huge array on the same
HBA.  The sd driver is designed to cope with this by not issuing 16 byte
commands until you go over the 32 byte block limit.  This should work
identically for SATA devices, shouldn't it?

James


