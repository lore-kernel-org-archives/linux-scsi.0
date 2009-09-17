From: Neil Brown <neilb@suse.de>
Subject: Re: MD/RAID time out writing superblock
Date: Thu, 17 Sep 2009 10:34:39 +1000
Message-ID: <19121.33823.893569.486518@notabene.brown>
References: <20090916222842.GB16053@arachsys.com>
	<4AB17905.90606@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33291 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755403AbZIQAdh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Sep 2009 20:33:37 -0400
In-Reply-To: message from Tejun Heo on Thursday September 17
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Chris Webb <chris@arachsys.com>, Ric Wheeler <rwheeler@redhat.com>, Andrei Tanas <andrei@tanas.ca>, linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>, Mark Lord <mlord@pobox.com>

On Thursday September 17, tj@kernel.org wrote:
> 
> > There are two more symptoms we are seeing on the same which may be
> > connected, or may be separate bugs in their own right:
> > 
> >   - 'cat /proc/mdstat' sometimes hangs before returning during normal
> >     operation, although most of the time it is fine. We have seen hangs of
> >     up to 15-20 seconds during resync. Might this be a less severe example
> >     of the lock-up which causes a timeout and reset after 30 seconds?
> > 
> >   - We've also had a few occasions of O_SYNC writes to raid arrays (from
> >     qemu-kvm via LVM2) completely deadlocking against resync writes when the
> >     maximum md resync speed is set sufficiently high, even where the minimum
> >     md resync speed is set to zero (although this certainly helps). However,
> >     I suspect this is an unrelated issue as I've seen this on other hardware
> >     running other kernel configs.
> 
> I think these two will be best answered by Neil Brown.  Neil?
> 

"cat /proc/mdstat" should only hang if the mddev reconfig_mutex is
held for an extended period of time.
The reconfig_mutex is held while superblocks are being written.

So yes, an extended device timeout while updating the md superblock
can cause "cat /proc/mdstat" to hang for the duration of the timeout.

For the O_SYNC:
  I think this is a RAID1 - is that correct?
  With RAID1, as soon as any IO request arrives, resync is suspended and
  as soon as all resync requests complete, the IO is permitted to
  proceed.
  So normal IO takes absolute precedence over resync IO.

  So I am very surprised to here that O_SYNC writes deadlock
  completed.
  As O_SYNC writes are serialised, there will be a moment between
  every pair when there is no IO pending.  This will allow resync to
  get one "window" of resync IO started between each pair of writes.
  So I can well believe that a sequence of O_SYNC writes are a couple
  of orders of magnitude slower when resync is happening than without.
  But it shouldn't deadlock completely.
  Once you get about 64 sectors of O_SYNC IO through, the resync
  should notice and back-off and resync IO will be limited to the
  'minimum' speed.

NeilBrown
