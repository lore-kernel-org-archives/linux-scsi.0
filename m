From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] SCSI and FibreChannel Hotswap for linux 2.5.44-bk2
Date: Wed, 30 Oct 2002 20:18:34 +0000
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20021030201834.A4815@infradead.org>
References: <3DC02AF7.6020209@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3DC02AF7.6020209@mvista.com>; from sdake@mvista.com on Wed, Oct 30, 2002 at 11:54:47AM -0700
To: Steven Dake <sdake@mvista.com>
Cc: torvalds@transmeta.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Umm, stop.

Scsi midlayer patches don't go directly to Linus, but through the linux-scsi
list and James into the linux-scsi bk repository first.

The patch still has a bunch of problem not solved, and contains two things
that should be independant patches.

The first patch should be the host_queue locking you added, this one currently
has the following issues:

* you call spin_lock on a semaphore once!
* you take semaphores inside spinlocks and with interrupts disabled
* the coding style needs some imnprovements (you adds lots of empty lines,
  and there's a space before the opening brakes of function calls).

the actual driver still has other issues:

* you still duplicated lots of code from scsi.c
* your header is still in include/linux instead of include/scsi,
  but imho it should be merged into scsi.h anyway
* you still havent explain why wwn -> host id translation can't
  be done in userspace
* you still have useage information in the driverfs files.
