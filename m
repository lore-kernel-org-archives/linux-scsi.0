From: Or Gerlitz <ogerlitz@mellanox.com>
Subject: [PATCH 0/3] SCSI/libiscsi: Reduce locking contention in fast path
Date: Sun, 27 Oct 2013 15:23:23 +0200
Message-ID: <1382880206-2789-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailp.voltaire.com ([193.47.165.129]:44009 "EHLO mellanox.co.il"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753994Ab3J0NXe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Oct 2013 09:23:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, MChristie@fusionio.com, shlomop@mellanox.com, Or Gerlitz <ogerlitz@mellanox.com>

Hi James, 

This series is about reducing locking contention in the IO submission/response processing 
fast path of libiscsi and the various iscsi transports usage of libiscsi code.

We replace the session lock with two locks, a forward lock and a backwards lock 
named frwd_lock and back_lock respectively.

The forward lock protects resources that change while sending a request to the 
target, such as cmdsn, queued_cmdsn, and allocating task from the commands' 
pool with kfifo_out.

The backward lock protects resources that change while processing a response or 
in error path, such as cmdsn_exp, cmdsn_max, and returning tasks to the commands' 
pool with kfifo_in. 

The 1st patch in the series is a restructuring patch for iscsi_tcp r2t response
logic, the 2nd is the main patch and the 3rd is cleanup asked by Mike who reviewed
the whole series when we posted in over the open-iscsi mailing list.

Under a "steady state" fast-path situation, that is when one or more processes/threads 
submit IO to an iscsi device and a single kernel upcall (e.g softirq) is dealing 
with processing  of responses without errors, this patch eliminates the contention
between the queuecommand()/request response/scsi_done() associated with iscsi sessions.

Or and Shlomo.

Shlomo Pongratz (3):
  SCSI/libiscsi: Restructure iscsi_tcp r2t response logic
  SCSI/libiscsi: Reduce locking contention in fast path
  SCSI/libiscsi: Remove unneeded code

 drivers/scsi/be2iscsi/be_main.c  |   26 ++--
 drivers/scsi/bnx2i/bnx2i_hwi.c   |   46 ++++----
 drivers/scsi/bnx2i/bnx2i_iscsi.c |    8 +-
 drivers/scsi/iscsi_tcp.c         |   22 ++--
 drivers/scsi/libiscsi.c          |  226 ++++++++++++++++++++------------------
 drivers/scsi/libiscsi_tcp.c      |   71 +++++++-----
 drivers/scsi/qla4xxx/ql4_isr.c   |    4 +-
 include/scsi/libiscsi.h          |   17 ++-
 include/scsi/libiscsi_tcp.h      |    2 +
 9 files changed, 228 insertions(+), 194 deletions(-)

