From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: [PATCH] Aic7xxx driver version 6.2.6
Date: Thu, 11 Apr 2002 22:22:58 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200204120422.g3C4Mw950533@aslan.scsiguy.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Marcelo Tosatti <marcelo@conectiva.com.br>, Alan Cox <alan@redhat.com>

Patches against marcelo_2.4 as of yesturday can be found here:

http://people.FreeBSD.org/~gibbs/linux/aic7xxx-6.2.6-marcelo_2.4.patch.gz

6.2.6 corrects the following issues:

1) Correctly deregister our pci_driver entry points on hot-eject.
   This should allow you to hot-plug the APA1480 again.

2) Set max_sectors to a sane value.  The aic7xxx driver was not
   updated when this value was added to the host template structure.
   In more recent kernels, the default setting for this field, 255,
   can limit our transaction size to 127K.  This often causes the
   scsi_merge routines to generate 127k followed by 1k I/Os to complete
   a client transaction.  The command overhead of such small transactions
   can severely impact performance.  The driver now sets max_sectors to
   8192 which equates to the 16MB S/G element limit for these cards as
   expressed in 2K sectors.  Many thanks to Radio Free Asia for
   loaning me a box to diagnose this issue.

This version also adds the ability to read and write the contents of
the seeprom from /proc/scsi/aic7xxx/#.

Marcelo.  The Makefile has been returned to a format conducive
to adding a second target.  This is in anticipation of the addition
of the U320 driver in 2-3 weeks time.  I believe this follows the
template that Keith Owens proposed for a multi-target Makefile,
but if you have questions about this, feel free to ignore that
hunk of the patch.  Keith's Makefile version will work with 6.2.6
as is.

--
Justin
