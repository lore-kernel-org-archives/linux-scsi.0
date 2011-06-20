From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH v2 01/12] tcm_fc: Fix warning in file tfc_io
Date: Mon, 20 Jun 2011 16:58:53 -0700
Message-ID: <20110620235853.1777.39728.stgit@localhost6.localdomain6>
References: <20110620235848.1777.5168.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:39660 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756135Ab1FTX6y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2011 19:58:54 -0400
In-Reply-To: <20110620235848.1777.5168.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Kiran Patil <kiran.patil@intel.com>

From: Kiran Patil <kiran.patil@intel.com>

Printk causing warning, trying to print size_t as %x.

Fix the printk statement, to print it as %zd instead of explictly casting to (unsigned int)

Signed-off-by: Kiran Patil <kiran.patil@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/target/tcm_fc/tfc_io.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/target/tcm_fc/tfc_io.c b/drivers/target/tcm_fc/tfc_io.c
index 4c3c0ef..702d4b8 100644
--- a/drivers/target/tcm_fc/tfc_io.c
+++ b/drivers/target/tcm_fc/tfc_io.c
@@ -203,7 +203,7 @@ int ft_queue_data_in(struct se_cmd *se_cmd)
 			/* XXX For now, initiator will retry */
 			if (printk_ratelimit())
 				printk(KERN_ERR "%s: Failed to send frame %p, "
-						"xid <0x%x>, remaining <0x%x>, "
+						"xid <0x%x>, remaining <%zd>, "
 						"lso_max <0x%x>\n",
 						__func__, fp, ep->xid,
 						remaining, lport->lso_max);

