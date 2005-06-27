From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Fw: 2.6.12-mm2: 3ware SATA RAID inaccessible
Date: Mon, 27 Jun 2005 09:22:28 -0500
Message-ID: <1119882148.5175.13.camel@mulgrave>
References: <20050626153941.456543d6.akpm@osdl.org>
	 <1119829031.5038.15.camel@mulgrave>  <20050627075255.GK19550@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:4569 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262075AbVF0OWw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Jun 2005 10:22:52 -0400
In-Reply-To: <20050627075255.GK19550@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, aradford@amcc.com, Nick Orlov <bugfixer@list.ru>

On Mon, 2005-06-27 at 09:52 +0200, Jens Axboe wrote:
> This wont work at all, I'm afraid. You cannot atomically kmap() the
> buffer for queueing, and unmap it from interrupt context. The type
> probably isn't correct, and you are not guaranteed to be on the same
> CPU when doing the unmap. Thus you end up with corrupted maps and
> preemption counts.

Actually, it's a lot simpler than that.  We're generating the data for
the command, so all we do is send an equivalent command to the array (if
any) and then in the irq routine, kmap_atomic the buffer, copy the array
data into the buffer in the right order for the command then kunmap the
buffer again.  This should work fine, I think.

James


