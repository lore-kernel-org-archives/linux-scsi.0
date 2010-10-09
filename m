From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 4/8] fcoe: set default FIP mode as FIP_MODE_FABRIC
Date: Fri, 08 Oct 2010 17:12:25 -0700
Message-ID: <20101009001225.7744.69433.stgit@localhost.localdomain>
References: <20101009001204.7744.21642.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:18948 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063Ab0JIAM0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Oct 2010 20:12:26 -0400
In-Reply-To: <20101009001204.7744.21642.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Vasu Dev <vasu.dev@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

Since sometimes current FIP_MODE_AUTO mode falls back to non-FIP
mode while DCB link still getting ready in fabric mode with
its peer switch, it falls back after few libfc flogi retries
and that is not we want while working with FIP enabled
switches in FABRIC mode, therefore sets default as FIP_MODE_FABRIC
as discussed and agreed before in this mail thread
http://www.open-fcoe.org/pipermail/devel/2010-August/010511.html

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 844d618..8225b82 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -117,7 +117,7 @@ static void fcoe_recv_frame(struct sk_buff *skb);
 
 static void fcoe_get_lesb(struct fc_lport *, struct fc_els_lesb *);
 
-module_param_call(create, fcoe_create, NULL, (void *)FIP_MODE_AUTO, S_IWUSR);
+module_param_call(create, fcoe_create, NULL, (void *)FIP_MODE_FABRIC, S_IWUSR);
 __MODULE_PARM_TYPE(create, "string");
 MODULE_PARM_DESC(create, " Creates fcoe instance on a ethernet interface");
 module_param_call(create_vn2vn, fcoe_create, NULL,

