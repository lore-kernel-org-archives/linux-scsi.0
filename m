From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: BUG: CD driver sends command during host removal
Date: 29 Sep 2004 17:26:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096493170.2124.150.camel@mulgrave>
References: <Pine.LNX.4.44L0.0409291452120.1700-100000@ida.rowland.org><1096487461.2028.
	134.camel@mulgrave>
	<20040929203104.GB6179@us.ibm.com><1096490471.2028.140.camel@mulgrave>
	<20040929210751.GC6179@us.ibm.com> <1096492496.1762.148.camel@mulgrave>
	<415B271F.7080902@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:59590 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S269056AbUI2V0Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2004 17:26:25 -0400
In-Reply-To: <415B271F.7080902@adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Mike Anderson <andmike@us.ibm.com>, Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>, Mohammed Sameer <uniball@gmx.net>, USB users list <linux-usb-users@lists.sourceforge.net>

On Wed, 2004-09-29 at 17:20, Luben Tuikov wrote:
> Is it possible that there could be a slight race when
> the LLDD starts calling scsi_done() on pending commands,
> _after_ it has called scsi_remove_host()?

No, because it starts failing commmands *before* it calls
scsi_remove_host().

> BTW, why have/leave two alternate paths for this behavior?
> This may bite us back in the future when things get more
> complicated, i.e. dealing with more complicated devices,
> transports, etc.

Certain LLDs have no internal track of outstanding commands.

James


