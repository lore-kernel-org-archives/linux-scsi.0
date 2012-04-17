From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: linux-next 20120416 + target for-next/for-next-merge
Date: Mon, 16 Apr 2012 19:29:52 -0700
Message-ID: <1334629792.12540.160.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-usb <linux-usb@vger.kernel.org>, linux1394-devel <linux1394-devel@lists.sourceforge.net>, LKML <linux-kernel@vger.kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Chris Boot <bootc@bootc.net>, Arun Easi <arun.easi@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Roland Dreier <roland@kernel.org>, Christoph Hellwig <hch@lst.de>, Greg KH <gregkh@linuxfoundation.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andy Grover <agrover@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Hi folks,

Just a brief post-mortem on today's linux-next 20120416 build with
the current set of v3.5-rc target updates, the current qla2xxx target
merge candidate, and the new usb-gadget + sbp target code that's now
pending in for-next-merge.

Here is how the for-next branch is taking shape:

*) Changes from hch that begin to stop splitting commands into multiple 
   tasks + make pSCSI backends enforce physical SCSI max_sectors
*) Changes from roland to drop legacy transport_do_task_sg_chain() usage
   in core + upstream tcm_fc/ib_srpt code
*) Cleanups + refactoring from agrover for iscsi-target towards an 
   eventual target_submit_cmd() conversion

and the diffstat from Next/merge.log:

$ git merge target-updates/for-next
Auto-merging drivers/infiniband/ulp/srpt/ib_srpt.c
Merge made by the 'recursive' strategy.
 drivers/infiniband/ulp/srpt/ib_srpt.c             |   10 +-
 drivers/target/iscsi/iscsi_target.c               |  821 ++++++++++-----------
 drivers/target/iscsi/iscsi_target.h               |    3 +-
 drivers/target/iscsi/iscsi_target_configfs.c      |    2 +-
 drivers/target/iscsi/iscsi_target_core.h          |   12 +-
 drivers/target/iscsi/iscsi_target_datain_values.c |   35 +-
 drivers/target/iscsi/iscsi_target_erl0.c          |   31 +-
 drivers/target/iscsi/iscsi_target_erl1.c          |   23 +-
 drivers/target/iscsi/iscsi_target_erl2.c          |   28 +-
 drivers/target/iscsi/iscsi_target_parameters.c    |    8 -
 drivers/target/iscsi/iscsi_target_seq_pdu_list.c  |  125 ++--
 drivers/target/iscsi/iscsi_target_seq_pdu_list.h  |    2 +-
 drivers/target/iscsi/iscsi_target_tmr.c           |   15 +-
 drivers/target/iscsi/iscsi_target_util.c          |  192 +----
 drivers/target/iscsi/iscsi_target_util.h          |    3 -
 drivers/target/loopback/tcm_loop.c                |    4 +-
 drivers/target/target_core_cdb.c                  |    5 +-
 drivers/target/target_core_device.c               |    9 +-
 drivers/target/target_core_file.c                 |   11 +-
 drivers/target/target_core_pr.c                   |   31 +-
 drivers/target/target_core_rd.c                   |  154 ++--
 drivers/target/target_core_rd.h                   |   20 -
 drivers/target/target_core_tpg.c                  |    5 +-
 drivers/target/target_core_transport.c            |  242 ++----
 drivers/target/tcm_fc/tfc_cmd.c                   |   18 +-
 drivers/target/tcm_fc/tfc_conf.c                  |    3 -
 drivers/target/tcm_fc/tfc_io.c                    |    2 +-
 include/target/target_core_base.h                 |    9 +-
 include/target/target_core_fabric.h               |    9 +-
 29 files changed, 693 insertions(+), 1139 deletions(-)

--
With the new set of v3.5-rc1 target fabric merge candidates thus far we've
not gotten any reported next build issues for archs supporting allmod
configs.  Great work by new target fabric maintainers Sebastian + Chris
to make their code go smoothly into next !

Also, the current qla2xxx/tcm_qla2xxx merge candidate has been updated
to drop legacy usage of transport_do_task_sg_chain() within for-next
(roland), while testing continues with qla2xxx LLD target specific
changes in initiator mode function to avoid any potential regression
issues for an initial v3.5-rc1 merge. (arun + Co.)

Here is how the diffstat is looking:

Merging target-merge/for-next-merge (3e6e9e9 sbp-target: Initial merge of firewire/ieee-1394 target mode support)
$ git merge target-merge/for-next-merge
Merge made by the 'recursive' strategy.
 drivers/firewire/core-card.c           |    1 +
 drivers/firewire/core-transaction.c    |    9 +
 drivers/firewire/core.h                |   15 -
 drivers/scsi/qla2xxx/Kconfig           |    8 +
 drivers/scsi/qla2xxx/Makefile          |    3 +-
 drivers/scsi/qla2xxx/qla_attr.c        |    5 +-
 drivers/scsi/qla2xxx/qla_dbg.c         |    5 +
 drivers/scsi/qla2xxx/qla_dbg.h         |    5 +
 drivers/scsi/qla2xxx/qla_def.h         |   69 +-
 drivers/scsi/qla2xxx/qla_gbl.h         |    7 +
 drivers/scsi/qla2xxx/qla_gs.c          |    4 +-
 drivers/scsi/qla2xxx/qla_init.c        |   82 +-
 drivers/scsi/qla2xxx/qla_iocb.c        |  102 +-
 drivers/scsi/qla2xxx/qla_isr.c         |   83 +-
 drivers/scsi/qla2xxx/qla_mbx.c         |  101 +
 drivers/scsi/qla2xxx/qla_mid.c         |   17 +-
 drivers/scsi/qla2xxx/qla_os.c          |  133 +-
 drivers/scsi/qla2xxx/qla_target.c      | 4724 ++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_target.h      |  986 +++++++
 drivers/scsi/qla2xxx/tcm_qla2xxx.c     | 1969 +++++++++++++
 drivers/scsi/qla2xxx/tcm_qla2xxx.h     |  149 +
 drivers/target/Kconfig                 |    2 +
 drivers/target/Makefile                |    2 +
 drivers/target/sbp/Kconfig             |   11 +
 drivers/target/sbp/Makefile            |    1 +
 drivers/target/sbp/sbp_target.c        | 2621 ++++++++++++++++++
 drivers/target/sbp/sbp_target.h        |  251 ++
 drivers/target/usb-gadget/Kconfig      |    9 +
 drivers/target/usb-gadget/Makefile     |    3 +
 drivers/target/usb-gadget/usb_gadget.c | 2480 +++++++++++++++++
 drivers/target/usb-gadget/usb_gadget.h |  146 +
 include/linux/firewire.h               |   15 +
 32 files changed, 13968 insertions(+), 50 deletions(-)
 create mode 100644 drivers/scsi/qla2xxx/qla_target.c
 create mode 100644 drivers/scsi/qla2xxx/qla_target.h
 create mode 100644 drivers/scsi/qla2xxx/tcm_qla2xxx.c
 create mode 100644 drivers/scsi/qla2xxx/tcm_qla2xxx.h
 create mode 100644 drivers/target/sbp/Kconfig
 create mode 100644 drivers/target/sbp/Makefile
 create mode 100644 drivers/target/sbp/sbp_target.c
 create mode 100644 drivers/target/sbp/sbp_target.h
 create mode 100644 drivers/target/usb-gadget/Kconfig
 create mode 100644 drivers/target/usb-gadget/Makefile
 create mode 100644 drivers/target/usb-gadget/usb_gadget.c
 create mode 100644 drivers/target/usb-gadget/usb_gadget.h

--
As usual, please let myself and/or individual fabric maintainers know if
anyone has any additional review comments+feedback on this new fabric
code.

Thanks!

--nab
