From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [BK PATCH] SCSI -rc fixes for 2.6.10-rc2
Date: 19 Nov 2004 18:27:33 -0600
Message-ID: <1100910458.1677.141.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:50385 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262743AbUKTA1u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Nov 2004 19:27:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

This one is basically a set of small and self contained driver and
system fixes.

The patch is available here:

bk://linux-scsi.bkbits.net/scsi-for-linus-2.6

The short changelog is:

<bunk:stusta.de>:
  o SCSI qla1280: some firmware files cleanups
  o SCSI: fdomain.c: make a struct static
  o SCSI dc395x.c: make a function static
  o SCSI atp870u.c: make a needlessly global function
  o SCSI: aha1542.c: make some code static
  o SCSI_QLOGIC_1280_1040 dependencies

<jejb:titanic.il.steeleye.com>:
  o SCSI: Fix Bug 3753 (multiple definition of ST_partstat)

Alan Stern:
  o sd.c: adjust READ_CAPACITY for broken devices

Bob Tracy:
  o sym53c500_cs driver update

Brian King:
  o sg: Fix oops of sg_cmd_done and sg_release race

Cal Peake:
  o Documentation/kernel-parameters.txt: scsi param updates

Guennadi Liakhovetski:
  o refactor tmscsim inititalization code
  o tmascsim: (resend updated) track_queue_full

James Bottomley:
  o SCSI: fix USB forced remove oops

Jamie Lenehan:
  o SCSI dc395x.c: Call pci_disable during cleanup
  o SCSI dc395x.c: Fix type for irq and io ports
  o SCSI dc395x.c: store pci device pointer

Jens Axboe:
  o nsp_cs bad queuecommand return
  o megaraid2 bad queuecommand return
  o aacraid bad queuecommand return
  o nsp32 bad queuecommand return
  o ncr53c8xx bad queuecommand return
  o megaraid bad queuecommand return
  o ide-scsi bad queuecommand return
  o 3ware bad queuecommand returns

Kai M=E4kisara:
  o "mt-st tell" fails in 2.6.10-rc1

Mark Haverkamp:
  o 2.6 aacraid: rx check health function update
  o 2.6 aacraid: Interrupt function cleanup

Mike Christie:
  o Fix badness in scsi_lib.c

Miles Bader:
  o Remove duplicate safe_for_read(READ_BUFFER)

Sreenivas Bagalkote:
  o megaraid 2.20.4.1 Driver

Thomas Gleixner:
  o Lock initializer unifying Batch 2 (SCSI)

The diffstat is:

 Documentation/kernel-parameters.txt    |    5=20
 Documentation/scsi/ChangeLog.megaraid  |   11 +
 drivers/block/scsi_ioctl.c             |    1=20
 drivers/scsi/3w-9xxx.c                 |    1=20
 drivers/scsi/3w-xxxx.c                 |    1=20
 drivers/scsi/Kconfig                   |    1=20
 drivers/scsi/a100u2w.c                 |    2=20
 drivers/scsi/aacraid/aachba.c          |    6=20
 drivers/scsi/aacraid/aacraid.h         |   13 -
 drivers/scsi/aacraid/rkt.c             |  129 +++---------
 drivers/scsi/aacraid/rx.c              |   96 ++-------
 drivers/scsi/aacraid/sa.c              |   64 ------
 drivers/scsi/advansys.c                |    2=20
 drivers/scsi/aha1542.c                 |    6=20
 drivers/scsi/atp870u.c                 |    2=20
 drivers/scsi/cpqfcTSinit.c             |    2=20
 drivers/scsi/dc395x.c                  |   63 +++--
 drivers/scsi/fdomain.c                 |    2=20
 drivers/scsi/hosts.c                   |   12 -
 drivers/scsi/ibmvscsi/rpa_vscsi.c      |    2=20
 drivers/scsi/ide-scsi.c                |    2=20
 drivers/scsi/initio.c                  |    4=20
 drivers/scsi/megaraid.c                |   20 -
 drivers/scsi/megaraid/megaraid_ioctl.h |    6=20
 drivers/scsi/megaraid/megaraid_mbox.c  |    9=20
 drivers/scsi/megaraid/megaraid_mbox.h  |    4=20
 drivers/scsi/megaraid/megaraid_mm.c    |   64 +++++-
 drivers/scsi/megaraid/megaraid_mm.h    |    4=20
 drivers/scsi/ncr53c8xx.c               |    1=20
 drivers/scsi/nsp32.c                   |   10=20
 drivers/scsi/pcmcia/nsp_cs.c           |    4=20
 drivers/scsi/pcmcia/sym53c500_cs.c     |    6=20
 drivers/scsi/ql1040_fw.h               |   10=20
 drivers/scsi/ql12160_fw.h              |   22 --
 drivers/scsi/ql1280_fw.h               |   22 --
 drivers/scsi/scsi.c                    |    1=20
 drivers/scsi/sd.c                      |    5=20
 drivers/scsi/sg.c                      |   25 +-
 drivers/scsi/st.c                      |    3=20
 drivers/scsi/st.h                      |    2=20
 drivers/scsi/tmscsim.c                 |  351 ++++++++++++++----------=
---------
 drivers/scsi/tmscsim.h                 |    6=20
 include/scsi/scsi_device.h             |    1=20
 43 files changed, 419 insertions(+), 584 deletions(-)

James


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
