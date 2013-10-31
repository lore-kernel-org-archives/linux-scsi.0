From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH v6 0/2] block,scsi: fixup blk_get_request dead queue scenarios
Date: Thu, 31 Oct 2013 09:50:32 -0400
Message-ID: <1383227434-4536-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p01c11o143.mxlogic.net ([208.65.144.66]:39006 "EHLO
	p01c11o143.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853Ab3JaN5a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Oct 2013 09:57:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, "James E.J. Bottomley" <JBottomley@parallels.com>, =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>, Benny Halevy <bhalevy@tonian.com>, Boaz Harrosh <bharrosh@panasas.com>, Doug Gilbert <dgilbert@interlog.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <axboe@kernel.dk>, Jiri Kosina <jkosina@suse.cz>, Paolo Bonzini <pbonzini@redhat.com>, Tim Waugh <tim@cyberelk.net>, Willem Riede <osst@riede.org>, Joe Lawrence <joe.lawrence@stratus.com>

This is a patchset rebased to the latest Jens linux-block tree,
for-3.13/core branch to 1) protect blk_get_request __GFP_WAIT callers
from dead queues and then 2) convert blk_get_request to return ERR_PTR
to distinguish between dead queues and low-memory scenarios [1].  A
similar bug report appeared on LKML in June [2], as well as Red Hat
bugzilla #975287.

>From the RHBZ, Paolo Bonzini provided me an easy repro program via
fellow Red Hat customer.  The bug reporter said:

1. Connect a USB CD drive to the server.  (It will be recognized as /dev/sr1.)
2. Run the following program with gdb, and break on line 11.

    1 #include <stdio.h>
    2 #include <unistd.h>
    3 #include <sys/ioctl.h>
    4 #include <fcntl.h>
    5 #include <linux/cdrom.h>
    6
    7 int main(int argc, char *argv[])
    8 {
    9     int fd;
   10     if ((fd = open("/dev/sr1", O_RDONLY | O_NONBLOCK)) < 0) perror("open");
   11     if (ioctl(fd, CDROMEJECT, 0) < 0) perror("ioctl");
   12     close(fd);
   13     return(0);
   14 }

3. Disconnect the USB CD drive.
4. Continue to execute the program.  Then, kernel panic occurs.

I verified the repro with an unpatched for-3.13/core kernel.  When
testing with the patchset, the ioctl fails and returns ENODEV.

Changes from v6:
 - rebase to latest linux-block, for-3.13/core branch
 - provide bug repro

Regards,

[1] http://thread.gmane.org/gmane.linux.scsi/80934
[2] http://thread.gmane.org/gmane.linux.kernel/1502882

Joe Lawrence (2):
  block,scsi: verify return pointer from blk_get_request
  block,scsi: convert and handle ERR_PTR from blk_get_request

 block/blk-core.c                            | 34 ++++++++++++++---------------
 block/bsg.c                                 |  8 +++----
 block/scsi_ioctl.c                          | 13 ++++++++---
 drivers/block/paride/pd.c                   |  2 ++
 drivers/block/pktcdvd.c                     |  2 ++
 drivers/block/sx8.c                         |  2 +-
 drivers/cdrom/cdrom.c                       |  4 ++--
 drivers/ide/ide-park.c                      |  2 +-
 drivers/scsi/device_handler/scsi_dh_alua.c  |  2 +-
 drivers/scsi/device_handler/scsi_dh_emc.c   |  2 +-
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |  4 ++--
 drivers/scsi/device_handler/scsi_dh_rdac.c  |  2 +-
 drivers/scsi/osd/osd_initiator.c            |  4 ++--
 drivers/scsi/osst.c                         |  2 +-
 drivers/scsi/scsi_error.c                   |  2 ++
 drivers/scsi/scsi_lib.c                     |  2 +-
 drivers/scsi/scsi_tgt_lib.c                 |  2 +-
 drivers/scsi/sg.c                           |  4 ++--
 drivers/scsi/st.c                           |  2 +-
 drivers/target/target_core_pscsi.c          |  2 +-
 20 files changed, 55 insertions(+), 42 deletions(-)

-- 
1.8.3.1

