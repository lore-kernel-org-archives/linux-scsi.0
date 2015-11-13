From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target updates for v4.4-rc1 (-v2)
Date: Fri, 13 Nov 2015 13:56:30 -0800
Message-ID: <1447451790.23126.142.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Joel Becker <jlbec@evilplan.org>, Linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrzej Pietrasiewicz <andrzej.p@samsung.com>, Felipe Balbi <balbi@ti.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>
List-Id: linux-scsi@vger.kernel.org

Hi Linus,

Here is the (late) target-updates for v4.4-rc1.

There is one build failure as reported by linux-next in hwtracing/stm to
expect after merging:

https://lkml.org/lkml/2015/10/6/1016

That has been fixed-up to use the new configfs attribute API by
Alexander (CC'ed) here:

[PATCH] stm class: Use per-attribute show and store methods in configfs policy
https://lkml.org/lkml/2015/10/7/300

Also, there was a note on linux-next earlier today about the scsi tree
including a newer version of these patches, but looking now I don't see
any of them in scsi.git/for-next.

http://marc.info/?l=linux-next&m=144737680908416&w=2

I'll assume they where dropped from there, unless someone states
otherwise.

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-next

This series contains HCH's changes to absorb configfs attribute ->show()
+ ->store() function pointer usage from it's original tree-wide
consumers, into common configfs code.

It includes usb-gadget, target w/ drivers, netconsole and ocfs2 changes
to realize the improved simplicity, that now renders the original
include/target/configfs_macros.h CPP magic for fabric drivers and
others, unnecessary and obsolete.

And with common code in place, new configfs attributes can be added
easier than ever before.

Note, there are further improvements in-flight from other folks for v4.5
code in configfs land, plus number of target fixes for post -rc1 code.

Thank you,

--nab

Christoph Hellwig (23):
  configfs: add show and store methods to struct configfs_attribute
  usb-gadget: use per-attribute show and store methods
  usb-gadget/uvc: use per-attribute show and store methods
  usb-gadget/f_hid: use per-attribute show and store methods
  usb-gadget/f_acm: use per-attribute show and store methods
  usb-gadget/ether: use per-attribute show and store methods
  usb-gadget/f_loopback: use per-attribute show and store methods
  usb-gadget/f_midi: use per-attribute show and store methods
  usb-gadget/f_printer: use per-attribute show and store methods
  usb-gadget/f_sourcesink: use per-attribute show and store methods
  usb-gadget/f_mass_storage: use per-attribute show and store methods
  usb-gadget/f_uac1: use per-attribute show and store methods
  usb-gadget/f_uac2: use per-attribute show and store methods
  usb-gadget/f_obex: use per-attribute show and store methods
  usb-gadget/f_phonet: use per-attribute show and store methods
  usb-gadget/f_serial: use per-attribute show and store methods
  dlm: use per-attribute show and store methods
  spear13xx_pcie_gadget: use per-attribute show and store methods
  target: use per-attribute show and store methods
  netconsole: use per-attribute show and store methods
  ocfs2/cluster: move locking into attribute store methods
  ocfs2/cluster: use per-attribute show and store methods
  configfs: remove old API

 Documentation/filesystems/Makefile                 |    2 -
 Documentation/filesystems/configfs/Makefile        |    3 -
 Documentation/filesystems/configfs/configfs.txt    |   38 +-
 .../configfs/configfs_example_explicit.c           |  483 --------
 Documentation/target/tcm_mod_builder.py            |   17 -
 drivers/infiniband/ulp/srpt/ib_srpt.c              |   78 +-
 drivers/misc/spear13xx_pcie_gadget.c               |  216 ++--
 drivers/net/netconsole.c                           |  271 +++--
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                 |  153 +--
 drivers/target/iscsi/iscsi_target_configfs.c       |  791 +++++--------
 drivers/target/iscsi/iscsi_target_stat.c           |  666 +++++------
 drivers/target/loopback/tcm_loop.c                 |   60 +-
 drivers/target/sbp/sbp_target.c                    |   87 +-
 drivers/target/target_core_configfs.c              | 1209 +++++++-------------
 drivers/target/target_core_fabric_configfs.c       |  275 ++---
 drivers/target/target_core_internal.h              |    3 +
 drivers/target/target_core_stat.c                  |  918 ++++++---------
 drivers/target/tcm_fc/tfc_cmd.c                    |    1 -
 drivers/target/tcm_fc/tfc_conf.c                   |   44 +-
 drivers/target/tcm_fc/tfc_io.c                     |    1 -
 drivers/target/tcm_fc/tfc_sess.c                   |    1 -
 drivers/usb/gadget/configfs.c                      |  295 ++---
 drivers/usb/gadget/function/f_acm.c                |   26 +-
 drivers/usb/gadget/function/f_ecm.c                |    8 +-
 drivers/usb/gadget/function/f_eem.c                |    8 +-
 drivers/usb/gadget/function/f_hid.c                |   34 +-
 drivers/usb/gadget/function/f_loopback.c           |   31 +-
 drivers/usb/gadget/function/f_mass_storage.c       |  119 +-
 drivers/usb/gadget/function/f_midi.c               |   37 +-
 drivers/usb/gadget/function/f_ncm.c                |    8 +-
 drivers/usb/gadget/function/f_obex.c               |   26 +-
 drivers/usb/gadget/function/f_phonet.c             |   25 +-
 drivers/usb/gadget/function/f_printer.c            |   30 +-
 drivers/usb/gadget/function/f_rndis.c              |    8 +-
 drivers/usb/gadget/function/f_serial.c             |   26 +-
 drivers/usb/gadget/function/f_sourcesink.c         |   83 +-
 drivers/usb/gadget/function/f_subset.c             |    8 +-
 drivers/usb/gadget/function/f_uac1.c               |   39 +-
 drivers/usb/gadget/function/f_uac2.c               |   28 +-
 drivers/usb/gadget/function/u_ether_configfs.h     |   44 +-
 drivers/usb/gadget/function/uvc_configfs.c         |  387 +++----
 drivers/usb/gadget/legacy/tcm_usb_gadget.c         |   44 +-
 drivers/vhost/scsi.c                               |   41 +-
 drivers/xen/xen-scsiback.c                         |   32 +-
 fs/configfs/file.c                                 |   12 +-
 fs/dlm/config.c                                    |  288 ++---
 fs/ocfs2/cluster/heartbeat.c                       |  205 +---
 fs/ocfs2/cluster/nodemanager.c                     |  281 ++---
 include/linux/configfs.h                           |   97 +-
 include/linux/usb/gadget_configfs.h                |   19 +-
 include/target/configfs_macros.h                   |  147 ---
 include/target/target_core_base.h                  |   60 +
 include/target/target_core_fabric_configfs.h       |  122 --
 samples/Kconfig                                    |    6 +
 samples/Makefile                                   |    3 +-
 samples/configfs/Makefile                          |    2 +
 .../configfs/configfs_sample.c                     |  140 +--
 57 files changed, 2652 insertions(+), 5434 deletions(-)
 delete mode 100644 Documentation/filesystems/configfs/Makefile
 delete mode 100644 Documentation/filesystems/configfs/configfs_example_explicit.c
 delete mode 100644 include/target/configfs_macros.h
 delete mode 100644 include/target/target_core_fabric_configfs.h
 create mode 100644 samples/configfs/Makefile
 rename Documentation/filesystems/configfs/configfs_example_macros.c => samples/configfs/configfs_sample.c (74%)
