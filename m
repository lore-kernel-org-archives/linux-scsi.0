From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: 100% repeatable way to send firewire out to lunch permanently
 on 2.6.8.1
Date: Mon, 1 Aug 2005 01:14:57 +0200 (CEST)
Message-ID: <200507312315.j6VNEw6B008896@einhorn.in-berlin.de>
References: <20050731191658.GC19681@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:1768 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S262038AbVGaXSM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 31 Jul 2005 19:18:12 -0400
In-Reply-To: <20050731191658.GC19681@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Cc: goemon@anime.net, James.Bottomley@SteelEye.com, bcollins@debian.org, olh@suse.de

On 31 Jul, Olaf Hering wrote:
>  On Sun, Jul 31, Dan Hollis wrote:
>> On Sun, 24 Oct 2004, Olaf Hering wrote:
>> >  On Sun, Oct 24, James Bottomley wrote:
>> > > The trace doesn't show any error handler activity at all.  Are there no
>> > > messages in the log about offlining the device?  If not, it sounds like
>> > > there's a problem somewhere in the firewire system.
>> > How should sbp2_remove_device get rid of the device? It calls
>> > scsi_remove_host, which calls scsi_remove_device, which sets the mode to
>> > SDEV_CANCEL, then calls to device_del. sr_do_ioctl expects SDEV_OFFLINE.
>> 
>> Has there been any progress on this issue? I just got my _entire scsi 
>> subsystem_ sent out to lunch because a firewire device lost power.

_Now_ there has been progress. :-) The patch I just posted should fix
it. I tested it with a CD-R/W as well as with a harddisk that was
affected. The patch applies to the latest sbp2 revision at linux1394.org
which is not yet merged into mainline.

> I cant help you with that, sr_mod is likely still broken with MRW
> capable drives. But sbp2 is still the culprit, incomplete error
> handling.

Sbp2 was one of the very few LDDs that uses scsi_block_requests(). It is
called whenever the FireWire bus is reset, e.g. when a node was
attached, detached, or switched off. The patch simply unblocks sbp2's
host before device removal is attempted in the upper scsi layers. It
also takes care of how commands are enqueued after a FireWire node was
detached. (I think we could get rid of scsi_block_requests() altogether
if we get the .queuecommand and .eh_*_handler right.)

So sbp2 was indeed the culprit, although the fault was not in its error
handling.
-- 
Stefan Richter
-=====-=-=-= =--- ----=
http://arcgraph.de/sr/

