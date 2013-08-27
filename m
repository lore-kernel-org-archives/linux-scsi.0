From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 00/29] Update driver to 8.06.00.08-k
Date: Tue, 27 Aug 2013 01:37:26 -0400
Message-ID: <1377581875-8574-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:51743 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752002Ab3H0GGd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Aug 2013 02:06:33 -0400
Received: from pps.filterd (m0000643.ppops.net [127.0.0.1])
	by mx0b-0016ce01.pphosted.com (8.14.5/8.14.5) with SMTP id r7R63vVe012060
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 23:06:32 -0700
Received: from avcashub1.qlogic.com (avcashub2.qlogic.com [198.70.193.116])
	by mx0b-0016ce01.pphosted.com with ESMTP id 1e5gq13pa4-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 23:06:32 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Hi James,

Please apply the following patches to the scsi tree, misc branch at your
earliest convenience.

Thanks,
~Saurav


Andrew Vasquez (1):
  qla2xxx: Correct multiqueue offset calculations.

Andy Shevchenko (1):
  qla2xxx: print MAC via %pMR.

Armen Baloyan (12):
  qla2xxx: Set factory reset recovery timeout to 10 min. for ISPFX00.
  qla2xxx: Perform warm reset every 2 minutes if firmware load fails
    for ISPFX00.
  qla2xxx: Add ISPFX00 specific bus reset routine.
  qla2xxx: Notify ISPFX00 firmware when driver is unloaded or system is
    shut down.
  qla2xxx: Add critical temperature handling for ISPFX00.
  qla2xxx: Add changes to support extended IOs for ISPFX00
  qla2xxx: Add changes in initialization for ISPFX00 cards with BIOS
  qla2xxx: Send all AENs for ISPFx00 to above layers.
  qla2xxx: Remove handling of Shutdown Requested AEN from
    qlafx00_process_aen().
  qla2xxx: Correct Interrupt Register offset for ISPFX00
  qla2xxx: QLAFX00 make over temperature AEN handling informational,
    add log for normal temperature AEN
  qla2xxx: Set default critical temperature value in cases when ISPFX00
    firmware doesn't provide it

Atul Deshmukh (1):
  qla2xxx: Add support for ISP8044.

Chad Dupuis (3):
  qla2xxx: Remove QL_DEBUG_LEVEL_17 defines from qla_nx.c.
  qla2xxx: Make log message that prints when a completion status
    requires a port down more readable.
  qla2xxx: Move queue depth ramp down message to i/o debug level.

Joe Carnuccio (6):
  qla2xxx: Fix incorrect test after list_for_each_entry() exits.
  qla2xxx: Add setting of driver version string for vendor application.
  qla2xxx: Reconfigure thermal temperature.
  qla2xxx: Add missing FCP statistics to sysfs interface.
  qla2xxx: Select link initialization option bits from current
    operating mode.
  qla2xxx: Correctly print out/in mailbox registers.

Oleksandr Khoshaba (1):
  qla2xxx: Print some variables to hexadecimal string via %*phN format

Santosh Vernekar (1):
  qla2xxx: Add loopback IDC-TIME-EXTEND aen handling support.

Saurav Kashyap (2):
  qla2xxx: Correction to message ids.
  qla2xxx: Update the driver version to 8.06.00.08-k.

Sawan Chandak (1):
  qla2xxx: Add a new interface to update versions.

 drivers/scsi/qla2xxx/Makefile      |    2 +-
 drivers/scsi/qla2xxx/qla_attr.c    |   79 +-
 drivers/scsi/qla2xxx/qla_bsg.c     |   43 +-
 drivers/scsi/qla2xxx/qla_dbg.c     |   58 +-
 drivers/scsi/qla2xxx/qla_def.h     |   39 +-
 drivers/scsi/qla2xxx/qla_fw.h      |    2 +
 drivers/scsi/qla2xxx/qla_gbl.h     |   40 +
 drivers/scsi/qla2xxx/qla_gs.c      |   97 +-
 drivers/scsi/qla2xxx/qla_init.c    |   86 +-
 drivers/scsi/qla2xxx/qla_inline.h  |    2 +-
 drivers/scsi/qla2xxx/qla_iocb.c    |   17 +-
 drivers/scsi/qla2xxx/qla_isr.c     |   91 +-
 drivers/scsi/qla2xxx/qla_mbx.c     |  297 +++-
 drivers/scsi/qla2xxx/qla_mid.c     |    2 +
 drivers/scsi/qla2xxx/qla_mr.c      |  164 ++-
 drivers/scsi/qla2xxx/qla_mr.h      |   35 +-
 drivers/scsi/qla2xxx/qla_nx.c      |  117 +-
 drivers/scsi/qla2xxx/qla_nx.h      |   10 +
 drivers/scsi/qla2xxx/qla_nx2.c     | 3716 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_nx2.h     |  551 ++++++
 drivers/scsi/qla2xxx/qla_os.c      |  213 ++-
 drivers/scsi/qla2xxx/qla_sup.c     |  162 ++-
 drivers/scsi/qla2xxx/qla_target.c  |   69 +-
 drivers/scsi/qla2xxx/qla_version.h |    4 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |   14 +-
 25 files changed, 5427 insertions(+), 483 deletions(-)
 create mode 100644 drivers/scsi/qla2xxx/qla_nx2.c
 create mode 100644 drivers/scsi/qla2xxx/qla_nx2.h

-- 
1.7.7

