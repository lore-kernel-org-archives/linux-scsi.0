From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [SCSI] Add support for braindead Cypress USB ATA passthrough
	CDBs
Date: Fri, 23 Dec 2005 09:52:40 -0600
Message-ID: <1135353160.3728.10.camel@mulgrave>
References: <20051221122442.GA16571@porkrind.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:16571 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932211AbVLWPw4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Dec 2005 10:52:56 -0500
In-Reply-To: <20051221122442.GA16571@porkrind.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Caldwell <david@porkrind.org>
Cc: linux-scsi@vger.kernel.org

On Wed, 2005-12-21 at 04:24 -0800, David Caldwell wrote:
> This patch does 2 things. It reimplements the SG_FLAG_LUN_INHIBIT flag
> in the SG_IO ioctl which stops the scsi subsystem from overwriting the
> 2nd byte of the CDB with the LUN. It also doesn't guess the CDB length
> when sending the SG_IO ioctl to the sg device (the main scsi_ioctl
> already did this).
> 
> This is for the Cypress CY7C68310 USB to ATA bridge chip (and most
> likely other USB to ATA chips from Cypress), which implements an ATA
> passthrough command that is 16 bytes long and starts with the bytes
> 0x24 0x24. (Not vendor unique, weird length for opcode 0x24, and
> misuse of the LUN area all at the same time--Lovely).

I think this approach is too invasive to the stack.  When this was
discussed in november, there wasn't much enthusiasm for resurrecting the
long dead LUN_INHIBIT flag.  The two suggested mechanisms are

1) Simply don't mangle the LUN for SCSI_UNKNOWN and then have all the
subsystems lying about SCSI_2 compliance instead set their mangled level
to SCSI_UNKNOWN (which seems to be more truthful)

2) If 1) doesn't work, then use a blacklist entry which the subsystems
would also have access to.

James




