From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 0/3] Add uapi/scsi/scsi.h
Date: Thu,  8 Jan 2015 11:47:56 -0800
Message-ID: <1420746479-25949-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbbAHTsG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jan 2015 14:48:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, hch@lst.de

Hi James,

This patchset against scsi/for-next moves SCSI opcodes and other
useful defines into a user-available header. This should help projects
like tgt and glibc that have copied these opcode definitions and then
experience bitrot.  (e.g. glibc-headers provides
/usr/include/scsi/scsi.h on my system, it's from 1999.)

The uapi header is also where SCSI ioctls should go, so patch 3 moves
the contents of scsi_ioctl.h into it, and removes scsi_ioctl.h since
its kernel-specific contents aren't really enough to justify a
separate file from scsi/scsi.h.

The first patch adds a missing opcode.

Builds with allmodconfig.

Thanks -- Andy

Andy Grover (3):
  scsi: add WRITE_VERIFY_16 to scsi.h
  scsi: Move user-shareable stuff in scsi/scsi.h to uapi/scsi/scsi.h
  scsi: Remove scsi_ioctl.h

 block/bsg.c                        |   1 -
 block/scsi_ioctl.c                 |   1 -
 drivers/block/cciss.c              |   1 -
 drivers/block/pktcdvd.c            |   1 -
 drivers/ide/ide-floppy.c           |   2 -
 drivers/ide/ide-floppy_ioctl.c     |   2 +-
 drivers/scsi/ch.c                  |   1 -
 drivers/scsi/fdomain.c             |   1 -
 drivers/scsi/nsp32.c               |   1 -
 drivers/scsi/osd/osd_uld.c         |   1 -
 drivers/scsi/osst.c                |   1 -
 drivers/scsi/pcmcia/aha152x_stub.c |   1 -
 drivers/scsi/pcmcia/fdomain_stub.c |   1 -
 drivers/scsi/pcmcia/nsp_cs.c       |   1 -
 drivers/scsi/pcmcia/qlogic_stub.c  |   1 -
 drivers/scsi/pcmcia/sym53c500_cs.c |   1 -
 drivers/scsi/scsi_error.c          |   1 -
 drivers/scsi/scsi_ioctl.c          |   1 -
 drivers/scsi/sd.c                  |   1 -
 drivers/scsi/sd_dif.c              |   1 -
 drivers/scsi/sg.c                  |   1 -
 drivers/scsi/sr.c                  |   1 -
 drivers/scsi/sr_ioctl.c            |   1 -
 drivers/scsi/sr_vendor.c           |   1 -
 drivers/scsi/st.c                  |   1 -
 fs/compat_ioctl.c                  |   1 -
 include/scsi/scsi.h                | 523 +---------------------------------
 include/scsi/scsi_ioctl.h          |  48 ----
 include/uapi/scsi/Kbuild           |   1 +
 include/uapi/scsi/scsi.h           | 560 +++++++++++++++++++++++++++++++++++++
 30 files changed, 569 insertions(+), 591 deletions(-)
 delete mode 100644 include/scsi/scsi_ioctl.h
 create mode 100644 include/uapi/scsi/scsi.h

-- 
2.1.0

