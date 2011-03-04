From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC-v2 0/3] qla2xxx LLD target mode + tcm_qla2xxx fabric module
Date: Thu,  3 Mar 2011 19:25:18 -0800
Message-ID: <1299209121-32174-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Madhu Iyengar <madhu.iyengar@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Ruediger Oertel <ro@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

<quick resend to fix vger subject filtering..>

Greetings all,

Attached is the second RFC series for adding QLA2XXX LLD target mode support
into v8.03.05-k0 from >= .38-rc6, along with the accompanying tcm_qla2xxx.ko
fabric module for mainline target v4.0 infrastructure.  This series has been
broken up into reviewable sections and should be considered a 'for-39'
EXPERIMENTAL item.

The QLA2xxx LLD changes and tcm_qla2xxx.ko code should currently be considered
BETA status, and currently physical mode (non NPIV) is functioning.  Thus far
target mode has been run using both PCIe device passthrough into KVM guest and
bare-metal HW together with TCM IBLOCK/FILEIO/RAMDISK_MCP backends.  Running
heavy multi-threaded LTP disktest runs with large block (~1000 MB/sec @ 256K)
and small I/O block (~100K IOPs @ 512 byte) traffic to multi-lun configurations
is able to run sustained on the order of days with the latest tests.

An overview of the current status, todo list, mini-howto and running layout
from /sys/kernel/config/target/qla2xxx/ are available here:

http://www.linux-iscsi.org/index.php/Qlogic
http://www.linux-iscsi.org/wiki/QLogic/configFS

There have been a number of important bugfixes, improvements, and cleanups
since this was originally posted in December, including changes to address
a number of naming conventions to follow existing qla2xxx LLD code.  Many
thanks to Madhu Iyengar and the Qlogic team for their review and feedback.
Also thanks to Ruediger Oertel (and others) for testing with the lastest BETA
lio-core-2.6.git/tcm_qla2xxx-38 code and providing their helpful feedback.

There are a few specific items that we (Madhu+myself) have been discussing
off-list, from which we would like to get input from the larger set of
Linux/SCSI devels (James, Christoph) as well as distro folks (Hannes and Mike)
before larger re-org changes to the current functioning code are considered.

The biggest item up for discussion is that currently qla_target.c is built
directly into qla2xxx.ko, and qla2xxx LLD control plane and I/O codepaths have
been modified to make function calls into qla_target.c logic.  There are currently
some a handful of locations where target mode is incorrectly assumed to be enabled
for all cases (this will be addressed for RFC-v3), as we do require the ability to
run in target only mode, initiator only mode, and mixed T/I modes.

So one of the questions we have is how qla_target.c and associated LLD changes
can best be integrated into the mainline and distro qla2xxx drivers so that they
cause as minimal disruption to existing initiator mode operation as possible.

We had an idea to split the main qla_target.c logic into an external module
(eg: into tcm_qla2xxx.ko) and only keep the basic target mode definitions in
qla2xxx LLD, and communicate to external qla_target.c/tcm_qla2xxx code through
a series of LLD specific callbacks setup during the tcm_qla2xxx_lport
initialization and association to the scsi_qla_host_t being configured to run
in target mode.  This would move a great deal of QLA2XXX target mode specific
logic into tcm_qla2xxx, but would still require some level of target mode setup
logic within the existing qla2xxx LLD to allow tcm_qla2xxx to function properly.

(jejb, hch, hare, mnc, please add your comments here)

A list of the changes to existing qla2xxx LLD code is available here:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=blob_plain;f=Documentation/target/tcm_qla2xxx_arch_doc.txt;hb=refs/heads/tcm_qla2xxx-38

So wrt to the current RFC-v2 series, things are broken up into three individual patches:

The qla2xxx LLD changes in patch #1 and #2 where originally based on qla2x00t
v8.02.01-k4 / .26 and qla2x00t-target.ko from the SCST project, and are a modern
refactoring -> forward port of this logic to recent mainline target and qla2xxx
LLD code.

Patch #1 adds the main qla2x_target.c logic and associated headers into the
qla2xxx LLD, including the main struct qla_target_template API for interaction
with tcm_qla2xxx.

Patch #2 adds the various callbacks into struct qla_hw_data->qla2x_tmpl and
qla2x_target.c logic within the qla2xxx LLD proper.  Please see the above
tcm_qla2xxx_arch_doc.txt for info.

Patch #3 adds the seperate tcm_qla2xxx fabric module using a generic configfs
control plane on modern v4 target mode code.  This module defines it's own set
of struct qla_target_template callers for interaction with qla2x_target.c ->
qla2xxx LLD code.

The first RFC series is available here:

http://marc.info/?l=linux-scsi&m=129244523223528&w=2

Please have a look and add your comments.

Thanks!

--nab

Nicholas Bellinger (3):
  qla2xxx: Add target mode support into 2xxx series LLD code
  qla2xxx: Enable 2xxx series LLD target mode support
  tcm_qla2xxx: Add HW target mode I/O, control and TMR path code

 drivers/scsi/qla2xxx/Makefile                     |    4 +-
 drivers/scsi/qla2xxx/qla_attr.c                   |   13 +-
 drivers/scsi/qla2xxx/qla_dbg.h                    |   34 +
 drivers/scsi/qla2xxx/qla_def.h                    |   68 +-
 drivers/scsi/qla2xxx/qla_fw.h                     |   10 +
 drivers/scsi/qla2xxx/qla_gbl.h                    |   11 +
 drivers/scsi/qla2xxx/qla_gs.c                     |   13 +-
 drivers/scsi/qla2xxx/qla_init.c                   |  249 +-
 drivers/scsi/qla2xxx/qla_iocb.c                   |  106 +-
 drivers/scsi/qla2xxx/qla_isr.c                    |  229 +-
 drivers/scsi/qla2xxx/qla_mbx.c                    |  173 +-
 drivers/scsi/qla2xxx/qla_mid.c                    |   34 +-
 drivers/scsi/qla2xxx/qla_os.c                     |  168 +-
 drivers/scsi/qla2xxx/qla_target.c                 | 5185 +++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_target.h                 | 1107 +++++
 drivers/target/Kconfig                            |    1 +
 drivers/target/Makefile                           |    2 +
 drivers/target/tcm_qla2xxx/Kconfig                |    7 +
 drivers/target/tcm_qla2xxx/Makefile               |    6 +
 drivers/target/tcm_qla2xxx/tcm_qla2xxx_base.h     |  102 +
 drivers/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c | 1439 ++++++
 drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c   |  853 ++++
 drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.h   |   53 +
 23 files changed, 9809 insertions(+), 58 deletions(-)
 create mode 100644 drivers/scsi/qla2xxx/qla_target.c
 create mode 100644 drivers/scsi/qla2xxx/qla_target.h
 create mode 100644 drivers/target/tcm_qla2xxx/Kconfig
 create mode 100644 drivers/target/tcm_qla2xxx/Makefile
 create mode 100644 drivers/target/tcm_qla2xxx/tcm_qla2xxx_base.h
 create mode 100644 drivers/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c
 create mode 100644 drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c
 create mode 100644 drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.h

-- 
1.7.4.1
