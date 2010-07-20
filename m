From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 28/28] fcoe: remove check for zero fabric name
Date: Tue, 20 Jul 2010 15:21:33 -0700
Message-ID: <20100720222133.17116.1855.stgit@localhost.localdomain>
References: <20100720221904.17116.78553.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:35226 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932843Ab0GTWVd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2010 18:21:33 -0400
In-Reply-To: <20100720221904.17116.78553.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Vasu Dev <vasu.dev@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

This check prevents FCF selection in NPV mode due to zero fabric name
in that case and in turn flogi fails. Though NPV mode should not have
this zero and should be fixed there also but spec also does not require
initiator to ensure that fabric name must be non-zero, therefore dropping
this check to get flogi working in NPV mode.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/libfcoe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 2c265fe..aa503d8 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -845,7 +845,7 @@ static int fcoe_ctlr_parse_adv(struct fcoe_ctlr *fip,
 	}
 	if (!fcf->fc_map || (fcf->fc_map & 0x10000))
 		return -EINVAL;
-	if (!fcf->switch_name || !fcf->fabric_name)
+	if (!fcf->switch_name)
 		return -EINVAL;
 	if (desc_mask) {
 		LIBFCOE_FIP_DBG(fip, "adv missing descriptors mask %x\n",

