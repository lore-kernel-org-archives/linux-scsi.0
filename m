From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/6] tcm: Add TFO->new_cmd_map() and TFO->task_sg_chaining=1
Date: Mon,  6 Sep 2010 14:36:50 -0700
Message-ID: <1283809010-13619-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp103.sbc.mail.re3.yahoo.com ([66.196.96.86]:42879 "HELO
	smtp103.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755180Ab0IFVg4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2010 17:36:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Boaz Harrosh <bharrosh@panasas.com>, Richard Sharpe <realrichardsharpe@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings all,

This patch series adds two new features to the TCM v4 data I/O path that
will be included in v4.0.0-rc4 for TCM_Loop (included below in patch #5)
and other WIP HW target mode drivers.

The first patch adds support for TFO->new_cmd_map() / TRANSPORT_NEW_CMD_MAP
which allows fabric modules to use a callback in TCM backstore processing
thread context when doing the second stage setup of a new struct se_cmd
descriptor.

The second patch adds support for greating a struct se_cmd wide
SGL array chain using include/linux/scatterlist.h:sg_chain() from
contigiously allocated struct se_task->task_sg[] arrays.  This includes
the use of a trailing padding SGL within struct se_task->task_sg[] to hold
the SGL link to the next struct se_task->task_sg[].

The third and forth patches involve the conversion of two spinlocks 
which now may used in interrupt context from __transport_get_lun_for_cmd(),
and makes them use spin_lock_irq() and spin_unlock_irq() and handles a
couple of special cases in target_core_mib.c for reference counting.

And finally the fifth path converts the TCM_Loop virtual SCSI LLD
module to use the new TFO->new_cmd_map() / TRANSPORT_NEW_CMD_MAP, and
removes the original per struct tcm_loop_hba->tl_hba_qobj.  This will give
us a nice reduction in context-switches per TCM_Loop I/O now that this
patch removes the original per HBA tcm_loop_processing_thread() overhead
in TCM_Loop v4 code!

Comments are welcome,

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (6):
  tcm: Add support for TRANSPORT_NEW_CMD_MAP
  tcm: Add support for struct target_core_fabric_ops->task_sg_chaining
  tcm/ramdisk: Add special case for TFO->task_sg_chaining=1 with
    RAMDISK_DR
  tcm: Convert struct se_node_acl->device_list_lock to spin_*lock_irq()
  tcm: Convert struct se_device->dev_status_lock to spin_*lock_irq()
  tcm_loop: Convert to use new optimized TFO->new_cmd_map() caller

 drivers/target/target_core_device.c            |   94 +++++---------
 drivers/target/target_core_fabric_configfs.c   |    8 +-
 drivers/target/target_core_mib.c               |   28 ++++-
 drivers/target/target_core_rd.c                |   45 ++++++-
 drivers/target/target_core_tpg.c               |   18 ++-
 drivers/target/target_core_transport.c         |  160 ++++++++++++++++++++++--
 drivers/target/target_core_ua.c                |   20 ++--
 drivers/target/tcm_loop/tcm_loop_configfs.c    |   35 +-----
 drivers/target/tcm_loop/tcm_loop_core.h        |    2 -
 drivers/target/tcm_loop/tcm_loop_fabric.c      |   61 ---------
 drivers/target/tcm_loop/tcm_loop_fabric.h      |    2 -
 drivers/target/tcm_loop/tcm_loop_fabric_scsi.c |  100 +++++-----------
 drivers/target/tcm_loop/tcm_loop_fabric_scsi.h |    2 +-
 include/target/target_core_base.h              |   11 ++-
 include/target/target_core_device.h            |    1 -
 include/target/target_core_fabric_ops.h        |   12 ++
 include/target/target_core_tpg.h               |    1 +
 include/target/target_core_transport.h         |    3 +-
 18 files changed, 332 insertions(+), 271 deletions(-)

