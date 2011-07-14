From: giridhar.malavali@qlogic.com
Subject: [PATCH 0/5] qla2xxx: Updates for scsi misc 3.0.
Date: Thu, 14 Jul 2011 12:00:11 -0700
Message-ID: <1310670016-30216-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:42427 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753151Ab1GNTJK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Jul 2011 15:09:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

James,

Please apply these patches.

Resubmitting the patches after splitting further (02/05, 03/05 and 04/05).

The patch 1/5 has couple of warnings w.r.t KERN_facility level with printk.

WARNING: printk() should include KERN_ facility level

Using KERN facility in printk will print each buffer information in new line causing
unreadable log messages.

Here is an example

With KERN facility
Mar 23 10:05:37 linux-dcaw kernel: qla2xxx [0000:18:00.6]4:1102:
Mar 23 10:05:37 linux-dcaw kernel: 42
Mar 23 10:05:37 linux-dcaw kernel:
Mar 23 10:05:37 linux-dcaw kernel: 00

Without KERN facility
Mar 21 13:07:35 linux-dcaw kernel: qla2xxx [0000:18:00.7]37:1102: 48  00  00  00  5b  f2  00

Hope this should be fine since this is not an error.

-- Giridhar

Saurav Kashyap (5):
  qla2xxx: Basic infrastructure for dynamic logging.
  qla2xxx: Code changes to support new dynamic logging infrastructure.
  qla2xxx: Code changes to support new dynamic logging infrastructure
    (contd..)
  qla2xxx: Code changes to support new dynamic logging infrastructure
    (contd..)
  qla2xxx: Cleanup of previous infrastructure.

 drivers/scsi/qla2xxx/qla_attr.c   |  183 ++++---
 drivers/scsi/qla2xxx/qla_bsg.c    |  441 ++++++++-------
 drivers/scsi/qla2xxx/qla_dbg.c    |  396 ++++++++++----
 drivers/scsi/qla2xxx/qla_dbg.h    |  187 ++-----
 drivers/scsi/qla2xxx/qla_dfs.c    |   16 +-
 drivers/scsi/qla2xxx/qla_gbl.h    |    8 +-
 drivers/scsi/qla2xxx/qla_gs.c     |  371 +++++++-------
 drivers/scsi/qla2xxx/qla_init.c   |  856 +++++++++++++++--------------
 drivers/scsi/qla2xxx/qla_inline.h |    8 +-
 drivers/scsi/qla2xxx/qla_iocb.c   |  120 ++---
 drivers/scsi/qla2xxx/qla_isr.c    |  663 +++++++++++------------
 drivers/scsi/qla2xxx/qla_mbx.c    | 1091 ++++++++++++++++++-------------------
 drivers/scsi/qla2xxx/qla_mid.c    |  160 ++++--
 drivers/scsi/qla2xxx/qla_nx.c     |  556 +++++++++++--------
 drivers/scsi/qla2xxx/qla_os.c     |  747 ++++++++++++++++---------
 drivers/scsi/qla2xxx/qla_sup.c    |  275 ++++++----
 16 files changed, 3258 insertions(+), 2820 deletions(-)

