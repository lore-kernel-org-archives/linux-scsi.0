From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [RFC 0/2] target: Add TFO->complete_irq queue_work bypass
Date: Fri, 22 May 2015 07:57:24 +0000
Message-ID: <1432281446-31080-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi HCH & Co,

Here is RFC code for adding target_core_fabric_ops->complete_irq
bypass that allows fabrics to invoke response callbacks directly
from target_complete_cmd() IRQ context.

It breaks up existing target_complete_ok_work() code into three
pieces:

  - transport_complete_task_attr()
  - target_complete_ok_pre()
  - target_complete_irq()

and allows target_complete_irq() be called directly from IRQ context
if no special case se_cmd handling requirements exist.

The three cases that trigger queue_work() process context are:

  - non GOOD status
  - ORDERED task sync
  - non NULL se_cmd->transport_complete_callback()

It also includes converting target_restart_delayed_cmds() to use
llist_head, and checking within transport_complete_task_attr() to
determine if dev_ordered_sync is non zero, ahead of doing the
llist_del_all() -> cmpxchg of outstanding ordered tags.

This allows loopback LLD code to bypass the extra queue_work, and
invoke it's ->scsi_done() callback directly from IRQ context.

WDYT..?

--nab

Nicholas Bellinger (2):
  target: Add support for fabric IRQ completion
  loopback: Enable TFO->complete_irq for fast-path ->scsi_done

 drivers/target/loopback/tcm_loop.c     |   1 +
 drivers/target/target_core_device.c    |   2 +-
 drivers/target/target_core_tpg.c       |   1 +
 drivers/target/target_core_transport.c | 165 ++++++++++++++++++++++++---------
 include/target/target_core_base.h      |   5 +-
 include/target/target_core_fabric.h    |   1 +
 6 files changed, 127 insertions(+), 48 deletions(-)

-- 
1.9.1
