From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: adding flag for 192 byte mode sense
Date: 22 Mar 2004 11:31:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1079973105.2072.42.camel@mulgrave>
References: <Pine.LNX.4.44L0.0403221105290.8035-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:746 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262080AbUCVQcl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Mar 2004 11:32:41 -0500
In-Reply-To: <Pine.LNX.4.44L0.0403221105290.8035-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Patrick Mansfield <patmans@us.ibm.com>, mdharm-usb@one-eyed-alien.net, SCSI Mailing List <linux-scsi@vger.kernel.org>, usb-storage@lists.one-eyed-alien.net

On Mon, 2004-03-22 at 11:16, Alan Stern wrote:
> Do they look good?  Should they be applied?  One suggestion for a change: 
> the flag could be renamed "use_192_bytes_for_ms" since we may end up 
> wanting to use it for both page 0x3f and 0x08.

They already are in the scsi-misc-2.6 repository.

> 	3. When a USB mass storage device enters a state that requires a
> device reset, what command completion code should the usb-storage driver
> return to invoke the SCSI error handler?  And is there any way to do this
> so that the error handler skips the initial TEST UNIT READY step and goes
> directly to the device reset?

Anything that maps to FAILED in scsi_decide_disposition()

What TEST UNIT READY?  The error handler only issues those *after*
recovery, not before.

James


