From: Andy Grover <agrover@redhat.com>
Subject: [PATCHv2 0/5] Move headers to uapi/linux
Date: Thu, 29 Jan 2015 16:56:32 -0800
Message-ID: <1422579397-18696-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424AbbA3A4o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jan 2015 19:56:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, hch@lst.de

Hi James and hch, here's v2 with the headers exported in uapi/linux/*
instead of uapi/scsi/*, based upon your feedback. v2 also additionally
moves sg.h.

Also, you mentioned dropping obsolete SPC-2 opcodes from these
headers, but I wasn't sure what was safe to drop. Candidates?

Against scsi/for-next.

Summary:

Moving SCSI opcodes and other useful defines into user-available
headers should help projects like tgt and glibc that have copied
these opcode definitions, and then fall out of date. Unfortunately we
cannot move them to scsi/* because of conflicts with glibc.

The first patch adds a missing opcode.

Builds with allmodconfig. Thanks for taking a look, and any
suggestions for further improvement.

Regards -- Andy

Andy Grover (5):
  scsi: add WRITE_VERIFY_16 to scsi.h
  scsi: Move ioctl defs from scsi/scsi.h to scsi/scsi_ioctl.h
  scsi: Move user-shareable stuff in scsi/scsi.h to uapi/linux/scsi.h
  scsi: Move scsi/scsi_ioctl.h to uapi/linux/scsi_ioctl.h
  scsi: move scsi/sg.h to uapi/linux/sg.h

 block/bio.c                        |   2 +-
 block/blk-map.c                    |   2 +-
 block/bsg.c                        |   4 +-
 block/scsi_ioctl.c                 |   4 +-
 drivers/block/aoe/aoeblk.c         |   2 +-
 drivers/block/cciss.c              |   4 +-
 drivers/block/nvme-core.c          |   2 +-
 drivers/block/nvme-scsi.c          |   2 +-
 drivers/block/pktcdvd.c            |   2 +-
 drivers/block/skd_main.c           |   2 +-
 drivers/ide/ide-floppy.c           |   2 +-
 drivers/ide/ide-floppy_ioctl.c     |   2 +-
 drivers/message/i2o/i2o_scsi.c     |   2 +-
 drivers/scsi/ch.c                  |   2 +-
 drivers/scsi/fdomain.c             |   2 +-
 drivers/scsi/ips.c                 |   2 +-
 drivers/scsi/nsp32.c               |   2 +-
 drivers/scsi/osd/osd_uld.c         |   2 +-
 drivers/scsi/osst.c                |   2 +-
 drivers/scsi/pcmcia/aha152x_stub.c |   2 +-
 drivers/scsi/pcmcia/fdomain_stub.c |   2 +-
 drivers/scsi/pcmcia/nsp_cs.c       |   2 +-
 drivers/scsi/pcmcia/qlogic_stub.c  |   2 +-
 drivers/scsi/pcmcia/sym53c500_cs.c |   2 +-
 drivers/scsi/scsi_error.c          |   4 +-
 drivers/scsi/scsi_ioctl.c          |   4 +-
 drivers/scsi/sd.c                  |   2 +-
 drivers/scsi/sd_dif.c              |   2 +-
 drivers/scsi/sg.c                  |   4 +-
 drivers/scsi/sr.c                  |   2 +-
 drivers/scsi/sr_ioctl.c            |   2 +-
 drivers/scsi/sr_vendor.c           |   2 +-
 drivers/scsi/st.c                  |   4 +-
 fs/compat_ioctl.c                  |   4 +-
 include/scsi/scsi.h                | 517 +------------------------------------
 include/scsi/scsi_ioctl.h          |  48 ----
 include/scsi/sg.h                  | 274 --------------------
 include/uapi/linux/Kbuild          |   3 +
 include/uapi/linux/scsi.h          | 506 ++++++++++++++++++++++++++++++++++++
 include/uapi/linux/scsi_ioctl.h    |  72 ++++++
 include/uapi/linux/sg.h            | 274 ++++++++++++++++++++
 kernel/sysctl.c                    |   2 +-
 42 files changed, 901 insertions(+), 879 deletions(-)
 delete mode 100644 include/scsi/scsi_ioctl.h
 delete mode 100644 include/scsi/sg.h
 create mode 100644 include/uapi/linux/scsi.h
 create mode 100644 include/uapi/linux/scsi_ioctl.h
 create mode 100644 include/uapi/linux/sg.h

-- 
2.1.0

