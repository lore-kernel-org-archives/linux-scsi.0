From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: BUG: CD driver sends command during host removal
Date: 29 Sep 2004 17:14:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096492496.1762.148.camel@mulgrave>
References: <Pine.LNX.4.44L0.0409291452120.1700-100000@ida.rowland.org>
	<1096487461.2028.134.camel@mulgrave> <20040929203104.GB6179@us.ibm.com>
	<1096490471.2028.140.camel@mulgrave>  <20040929210751.GC6179@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:27840 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S269031AbUI2VPC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2004 17:15:02 -0400
In-Reply-To: <20040929210751.GC6179@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Luben Tuikov <luben_tuikov@adaptec.com>, SCSI development list <linux-scsi@vger.kernel.org>, Mohammed Sameer <uniball@gmx.net>, USB users list <linux-usb-users@lists.sourceforge.net>

On Wed, 2004-09-29 at 17:07, Mike Anderson wrote:
> ok, thanks for the clarification. Your previous statement seemed to imply
> once scsi_remove_host was called the LLDD had no responsibility for
> calling done on commands sent to the LLDDs queuecommand.

Hang on a minute, there are two cases:

Existing in-flight commands:

Here, either the LLD returns done on them or the mid-layer will cancel
them during the invocation of scsi_remove_host().  In the latter case,
the LLD doesn't need to call done on them.

New Commands going down into queuecommand:

These the LLD must error out (by returning done with an error status).

> So now that this thread and the other thread related to similar
> shutdown issues has grown long is the next step to see if we can get the
> usb queuecommand to return DID_NO_CONNECT in this shutdown case.

Yes, that sounds correct.

James


