From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Fw: [BUG] USB Storage OOPS and a D state process in 2.6.10
Date: Wed, 05 Jan 2005 08:17:45 -0600
Message-ID: <1104934665.3852.7.camel@mulgrave>
References: <20050105001420.5f4c8623.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:24964 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262435AbVAEOSJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Jan 2005 09:18:09 -0500
In-Reply-To: <20050105001420.5f4c8623.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2005-01-05 at 00:14 -0800, Andrew Morton wrote:
> Looks like the scsi-vs-usb-storage bunfight isn't yet settled...

Actually, this one looks pretty clear cut:

According to the trace, we get into error handling for a removed device.
This:

> RIP <ffffffffa0108252>{:usb_storage:bus_reset+66} RSP <000001002f9a7e68>

says that the usb_storage bus_reset routine never returns.

So the system is hung in error handling and the kernel is waiting for
everything to return to normal.  The fix is to work out why usb_storage
hung there instead of returning success or fail.

James


