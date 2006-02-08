From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Regarding ordered-tag support.
Date: Wed, 08 Feb 2006 14:50:26 -0600
Message-ID: <1139431826.2979.8.camel@mulgrave.il.steeleye.com>
References: <43E99248.7090505@gmail.com>
	 <1139413766.3003.19.camel@mulgrave.il.steeleye.com>
	 <43EA1AD4.8010402@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:47839 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750765AbWBHUuh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Feb 2006 15:50:37 -0500
In-Reply-To: <43EA1AD4.8010402@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: Tejun Heo <htejun@gmail.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2006-02-08 at 11:22 -0500, James Smart wrote:
> James is also not disclosing other areas that may fail...
> 
> - How does multipathing affect this (maybe not dm, but others that exist).

Hey, with block level multi-path that's now officially Someone Else's
Problem. (And it's also a problem for software RAID as well).

> - The implicit expectation of the LLDD and the hardware is that commands are
>    placed on the wire in the same order given to queuecommand. However, no
>    where is this mandated. In general, they do keep order. However, I've seen
>    driver implementations that don't dispatch directly to hardware in
>    queuecommand, allowing the intermediate steps to fail and perhaps disrupt
>    ordering.

OK ... this acceptance problem is pretty much identical to the
BUSY/QUEUE_FULL one.

> - Some adapters may actually be multipath/raid cards, thus affecting command
>    delivery.

This shouldn't be more of a problem than SCSI devices.  The issue here
is caching.  A raid controller with a non-battery backed cache may
decide to ack commands before they hit the medium.  However, as long as
they expose this in the caching mode page and support the FUA bit of 10
byte commands, we should be able to cope (and yes, I know there are
drivers that currently don't get this right).

> - SCSI Transports are not 100% reliable, affecting ordering. For FC,
>    a single Frame corruption could cause a command frame to be dropped thus
>    the next command received and executed out of order. You would not notice
>    an issue until the scsi i/o timeout fires and aborts the i/o. The subsequent
>    i/o may have already completed by that time. Some transports due have
>    command sequence numbering to avoid this, but it's an optional feature.

Yes, but again, this is identical to BUSY/QUEUE_FULL.  As long as you
can get status return from the command in-line you can still preserve
ordering.

James


