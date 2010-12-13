From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/2] target: Updates for HW target mode
Date: Mon, 13 Dec 2010 15:58:41 -0800
Message-ID: <1292284723-6806-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm7.bullet.mail.sp2.yahoo.com ([98.139.91.77]:40426 "HELO
	nm7.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757027Ab0LMX6v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Dec 2010 18:58:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Bottomley <James.Bottomley@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings folks,

This short series fixes two issues found in target core code during recent
HW target mode module development and validation.  These two patches have been
merged into lio-core-2.6.git/lio-4.0 and master, and now allow generic HW target
mode to function using TCM code for the upcoming v4.0.0-rc6 release.

Patch #1 involves changing transport_generic_write_pending() to make sure
that transport_generic_handle_data() will never have to sleep waiting for
the struct target_core_fabric_ops->write_pending() callback to complete.

Patch #2 changes locking access to the struct se_nacl->nacl_sess_lock to
disable interrupts using spin_lock_irq(), and handles the special case for
target_core_pr.c: core_scsi3_pri_read_full_status() so that
transport_deregister_session_configfs() can be called directly from interrupt
context during HW target mode NEXUS -> TCM session shutdown and reset.

So far these have been tested using FC HW target mode via PCIe device-passthrough
from within KVM guest on .37-rc3 code.  This FC HW target module code will be
posted seperately to linux-scsi for review.

Thanks,

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (2):
  target: Fix tfo->write_pending() fabric callback ordering
  target: Convert se_nacl->nacl_sess_lock to use spin_lock_irq()

 drivers/target/target_core_fabric_lib.c |    8 +++---
 drivers/target/target_core_pr.c         |   11 ++++++++
 drivers/target/target_core_transport.c  |   39 ++++++++++++++++---------------
 3 files changed, 35 insertions(+), 23 deletions(-)

