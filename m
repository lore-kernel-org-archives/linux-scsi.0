From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: TYPE_RBC cache fixes (sbp2.c affected)
Date: Sat, 21 May 2005 11:00:56 -0500
Message-ID: <1116691256.4999.16.camel@mulgrave>
References: <20050516015955.GL1150@parcelfarce.linux.theplanet.co.uk>
	 <1116687698.4999.3.camel@mulgrave>  <428F55F1.3090006@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:35541 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261744AbVEUQBV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 May 2005 12:01:21 -0400
In-Reply-To: <428F55F1.3090006@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux1394-devel@lists.sourceforge.net

On Sat, 2005-05-21 at 11:38 -0400, Jeff Garzik wrote:
> That's why its in sbp2-specific code...
> 
> The above code certainly applies to real-world cases, at least.  Just 
> look at the code that was removed...  MS(10) handling.

I know that; and I know it has the effect of the replaced code.
However, I don't understand why SBC2 feels entitled to ignore the RBC
standard here ... that standard was primarily created for SBC2 devices.

So was the code in sbc2 because non-RBC devices needed the 10 byte
command and RBC ones just happened not to reject it?  My sense here is
that we should have code in scsi_scan.c to set sdev->use_10_for_rw and
reset sdev->use_10_for_ms before the slave configure predicated on
TYPE_RBC.

Does anyone actually have one of these RBC devices and does it reject
the six byte mode sense commands?

James


