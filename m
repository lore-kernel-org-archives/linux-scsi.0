From: James Bottomley <James.Bottomley@steeleye.com>
Subject: [BK PATCH] SCSI updates for 2.6.2
Date: 04 Feb 2004 13:27:00 -0500
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <1075919221.2028.94.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

These are all the pending SCSI updates I've been holding off until the
-rc phase was over.

they can be found at

bk://linux-scsi.bkbits.net/scsi-for-linus-2.6

The short changelog is:

Andrew Vasquez:
  o Updated qla2xxx driver

Douglas Gilbert:
  o sg driver update

James Bottomley:
  o scsi_mid_low_api.txt update to clarify queuecommand return values
  o minor mptfusion fix
  o SCSI: remove mac_NCR5380 driver
  o SCSI: Remove AM53c974 driver
  o SCSI: remove qlogicfc driver
  o SCSI: BusLogic update
  o scsi: scatter gather alignment constraints
  o qla2xxx: Resync with latest released firmware 3.02.21
  o Fix mptfusion to compile without CONFIG_PM
  o qla2xxx - Use RIO mode 4 for ISP2100/ISP2200 operation. [3/3]
  o qla2xxx - Remove unused GFT_ID code. [2/3]
  o qla2xxx - perform proper SNS scans with ISP2200 HBAs. [1/3]
  o Update qla2xxx to 8.00.00b9
  o Fusion update to 3.00.02
  o aha152x request region fix

J=FCrgen E. Fischer:
  o aha152x

Kai M=E4kisara:
  o SCSI tape cdev fixes for 2.6.2-rc1

Mike Anderson:
  o media change check fails for busy unplugged device

Patrick Mansfield:
  o add scsi_cmd_ioctl (SG_IO) support for st
  o change scsi_cmd_ioctl to take a gendisk instead of a queue
  o fix badness in scsi_single_lun_run

Randy Dunlap:
  o fix sym53c8xx_2 doc. location
  o aha1542: add kmalloc type
  o aha1542: queuecommand: change panic() to return

The diffstat (heavily skewed by the qla2xxx firmware updates) is

 Documentation/scsi/AM53C974.txt           |  246=20
 b/Documentation/scsi/BusLogic.txt         |   60=20
 b/Documentation/scsi/scsi_mid_low_api.txt |   46=20
 b/drivers/block/scsi_ioctl.c              |   27=20
 b/drivers/cdrom/cdrom.c                   |    2=20
 b/drivers/ide/ide.c                       |    2=20
 b/drivers/message/fusion/mptbase.c        |  417=20
 b/drivers/message/fusion/mptbase.h        |   19=20
 b/drivers/message/fusion/mptscsih.c       |  956 +-
 b/drivers/message/fusion/mptscsih.h       |   24=20
 b/drivers/scsi/BusLogic.c                 | 1370 ---
 b/drivers/scsi/BusLogic.h                 |  892 -
 b/drivers/scsi/FlashPoint.c               |   16=20
 b/drivers/scsi/Kconfig                    |   36=20
 b/drivers/scsi/Makefile                   |    2=20
 b/drivers/scsi/aha152x.c                  | 1192 +-
 b/drivers/scsi/aha152x.h                  |    7=20
 b/drivers/scsi/aha1542.c                  |    9=20
 b/drivers/scsi/pcmcia/aha152x_stub.c      |   11=20
 b/drivers/scsi/qla2xxx/Kconfig            |   36=20
 b/drivers/scsi/qla2xxx/Makefile           |   12=20
 b/drivers/scsi/qla2xxx/ql2300.c           |   78=20
 b/drivers/scsi/qla2xxx/ql2300_fw.c        |13465
+++++++++++++++---------------
 b/drivers/scsi/qla2xxx/ql2322.c           |  108=20
 b/drivers/scsi/qla2xxx/ql2322_fw.c        | 8019 +++++++++++++++++
 b/drivers/scsi/qla2xxx/ql6312.c           |   90=20
 b/drivers/scsi/qla2xxx/ql6312_fw.c        | 6773 +++++++++++++++
 b/drivers/scsi/qla2xxx/ql6322.c           |  108=20
 b/drivers/scsi/qla2xxx/ql6322_fw.c        | 7353 ++++++++++++++++
 b/drivers/scsi/qla2xxx/qla_dbg.c          |   79=20
 b/drivers/scsi/qla2xxx/qla_dbg.h          |  100=20
 b/drivers/scsi/qla2xxx/qla_def.h          |  200=20
 b/drivers/scsi/qla2xxx/qla_gbl.h          |   21=20
 b/drivers/scsi/qla2xxx/qla_gs.c           |  570 +
 b/drivers/scsi/qla2xxx/qla_init.c         |  194=20
 b/drivers/scsi/qla2xxx/qla_iocb.c         |   12=20
 b/drivers/scsi/qla2xxx/qla_isr.c          |   34=20
 b/drivers/scsi/qla2xxx/qla_mbx.c          |  348=20
 b/drivers/scsi/qla2xxx/qla_os.c           |  382=20
 b/drivers/scsi/qla2xxx/qla_settings.h     |    2=20
 b/drivers/scsi/qla2xxx/qla_sup.c          |   51=20
 b/drivers/scsi/qla2xxx/qla_version.h      |    4=20
 b/drivers/scsi/scsi_lib.c                 |   16=20
 b/drivers/scsi/sd.c                       |    2=20
 b/drivers/scsi/sg.c                       |   75=20
 b/drivers/scsi/st.c                       |  159=20
 b/fs/bio.c                                |   49=20
 b/include/linux/bio.h                     |    4=20
 b/include/linux/blkdev.h                  |    2=20
 drivers/scsi/AM53C974.c                   | 2463 -----
 drivers/scsi/AM53C974.h                   |   61=20
 drivers/scsi/mac_NCR5380.c                | 3127 ------
 drivers/scsi/qlogicfc.c                   | 2236 ----
 drivers/scsi/qlogicfc.h                   |   80=20
 drivers/scsi/qlogicfc_asm.c               | 9751 ---------------------
 55 files changed, 33078 insertions(+), 28320 deletions(-)

James
