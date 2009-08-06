From: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 0/3]: blk-iopoll, a polled completion API for block devices
Date: Thu,  6 Aug 2009 21:58:02 +0200
Message-ID: <1249588685-4662-1-git-send-email-jens.axboe@oracle.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756631AbZHFT6J@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Eric.Moore@lsi.com, jeff@garzik.org
List-Id: linux-scsi@vger.kernel.org

Hi,

This is something I've been playing around and I have hopes of merging
the core for 2.6.32, so I thought I'd send it out for some review and
inspection.

Basically this implements NAPI for block devices, and much of the core
is essentially lifted from there. Since NAPI is already generic, there's
a possibility for some code reuse too. It's pretty small though and
there are a few small differences, so I just left it as-is for this
posting.

I've gotten good results with this on SSD devices, reducing the
interrupt rate a lot. And that's just for single disks, if you had
a bunch of those hanging off several controllers, it would look more
interesting I'm sure.

Apart from the core, I did patches for ahci and mpt. The former mostly
as a proof of concept, it's been running my laptop and test box for
months. There may be a problem with the ack part, as per the comment at
the end of ahci_interrupt(). So far I haven't observed any bad behaviour.
mpt is more interesting, as it's more geared at the market where this
should make some impact. The mpt patch should also be fully stable,
I've tested it on several platforms and adapters.

As to results, they vary. On a faster box, I can reduce the interrupt
rate by ~28% at only 50k IOPS. On a slower box, at 30k IOPS it'll drop
by as much as 95%. Latencies numbers are as good (or better). On
the faster box, the mpt controller even had interrupt coalescing enabled
and it still made a big difference.

Anyway, YMMV, I would appreciate some test results (and as usual, that
even includes just saying that it boots and functions for you). If
people feel adventurous, patches for other controllers will be happily
queued up for testing. I may even be convinced to implement support
for your controller of choice, if you have some fast storage hooked up
and would like to experiment. Generally, adding support to a driver is
not very hard and the two conversions included were also meant to serve
as an inspiration.

Patches are against current -git. You can also pull them from

  git://git.kernel.dk/linux-2.6-block.git blk-iopoll


 block/Makefile                   |    2 
 block/blk-iopoll.c               |  227 +++++++++++++++++++++++++++++++
 drivers/ata/ahci.c               |   53 ++++++-
 drivers/message/fusion/mptbase.c |   99 +++++++++++--
 drivers/message/fusion/mptbase.h |    3 
 include/linux/blk-iopoll.h       |   41 +++++
 include/linux/interrupt.h        |    1 
 include/linux/libata.h           |    2 
 kernel/sysctl.c                  |   10 +
 9 files changed, 419 insertions(+), 19 deletions(-)

-- 
Jens Axboe
