From: Chris Webb <chris@arachsys.com>
Subject: Re: MD/RAID time out writing superblock
Date: Thu, 17 Sep 2009 13:00:30 +0100
Message-ID: <20090917120030.GB13854@arachsys.com>
References: <20090916222842.GB16053@arachsys.com>
 <4AB17905.90606@kernel.org>
 <19121.33823.893569.486518@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alpha.arachsys.com ([91.203.57.7]:40589 "EHLO
	alpha.arachsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757048AbZIQMBJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Sep 2009 08:01:09 -0400
Content-Disposition: inline
In-Reply-To: <19121.33823.893569.486518@notabene.brown>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Tejun Heo <tj@kernel.org>, Ric Wheeler <rwheeler@redhat.com>, Andrei Tanas <andrei@tanas.ca>, linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>, Mark Lord <mlord@pobox.com>

Neil Brown <neilb@suse.de> writes:

> For the O_SYNC:
>   I think this is a RAID1 - is that correct?

Hi Neil. It's a RAID10n2 of six disks, but I've also seen the behaviour on a
RAID1 of two disks around the time of 2.6.27.

>   With RAID1, as soon as any IO request arrives, resync is suspended and
>   as soon as all resync requests complete, the IO is permitted to
>   proceed.
>   So normal IO takes absolute precedence over resync IO.
> 
>   So I am very surprised to here that O_SYNC writes deadlock
>   completed.
>   As O_SYNC writes are serialised, there will be a moment between
>   every pair when there is no IO pending.  This will allow resync to
>   get one "window" of resync IO started between each pair of writes.
>   So I can well believe that a sequence of O_SYNC writes are a couple
>   of orders of magnitude slower when resync is happening than without.
>   But it shouldn't deadlock completely.
>   Once you get about 64 sectors of O_SYNC IO through, the resync
>   should notice and back-off and resync IO will be limited to the
>   'minimum' speed.

The symptoms seem to be that I can't read or write to /dev/mdX but I can
read from the underlying /dev/sd* devices fine, at pretty much full speed. I
didn't try writing to them as there's lots of live customer data on the RAID
arrays!

The configuration is lvm2 (i.e. device-mapper linear targets) on top of md
on top of sd, and we've seen the symptoms with the virtual machines
accessing the logical volumes configured to open in O_SYNC mode, and with
them configured to open in O_DIRECT mode. During the deadlock, cat
/proc/mdstat does return promptly (i.e. not blocked), and shows a slow and
gradually falling sync rate---I think that there's no sync writing going on
either and the drives are genuinely idle. We have to reset the machine to
bring it back to life and a graceful reboot fails.

Anyway, I see this relatively infrequently, so what I'll try to do is to
create a reproducible test case and then follow up to you and the RAID list
with that. At the moment, I understand that my reports is a bit anecdotal,
and without a proper idea of what conditions are needed to make it happen
its pretty much impossible to diagnose or work on!

Cheers,

Chris.
