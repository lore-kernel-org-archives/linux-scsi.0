From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: bytes/CDB of SCSI pass thru grossly limited maybe
Date: 28 Aug 2004 13:51:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1093715498.3682.4.camel@mulgrave>
References: <A8E06BE4-F7BA-11D8-AC6B-00039398BB5E@ieee.org>
	<Pine.LNX.4.44L0.0408271100590.1238-100000@ida.rowland.org>
	<20040828143124.GB2518@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:56461 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266271AbUH1Rvu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Aug 2004 13:51:50 -0400
In-Reply-To: <20040828143124.GB2518@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, Pat LaVarre <p.lavarre@ieee.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Sat, 2004-08-28 at 10:31, Jens Axboe wrote:
> > usb-storage, for example, where the protocol only limits us to 4 GB per
> > transfer, there would be no problem allowing max_sectors to go as high as
> > 65535?
> 
> If the hardware and driver can handle it, there's no other limit.

Actually, if you go through the SCSI stack, you're limited by our SG
list slot allocation which we use a mempool for.  The default maximum is
128, although there's an option to increase this to 256.

These slots are the number of entries in the SG list we allow.  If your
driver disables clustering, and you havea no IOMMU, this limits you to
128*<page size> = 512kb on x86 bytes.  Otherwise, it can go higher
depending on the HW capabilities.  Remember too that a lot of HW limits
the number of SG slots (see the sg_tablesize entry for each driver).

James


