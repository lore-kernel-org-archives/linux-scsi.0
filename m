From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch v2] [SCSI] qla2xxx: fix incorrect debug printk
Date: Mon, 5 May 2014 12:47:57 +0300
Message-ID: <20140505094757.GA22383@mwanda>
References: <20140505094506.GM4963@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23791 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585AbaEEJsH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 May 2014 05:48:07 -0400
Content-Disposition: inline
In-Reply-To: <20140505094506.GM4963@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: qla2xxx-upstream@qlogic.com
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

There are missing curly braces here so it prints that the recovery
failed even when it succeeded.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: version 1 patch was corrupted in sending somehow.

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index afc8481..00754a2 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4913,12 +4913,13 @@ qla2x00_do_dpc(void *data)
 				if (qlafx00_reset_initialize(base_vha)) {
 					/* Failed. Abort isp later. */
 					if (!test_bit(UNLOADING,
-					    &base_vha->dpc_flags))
+					    &base_vha->dpc_flags)) {
 						set_bit(ISP_UNRECOVERABLE,
 						    &base_vha->dpc_flags);
 						ql_dbg(ql_dbg_dpc, base_vha,
 						    0x4021,
 						    "Reset Recovery Failed\n");
+					}
 				}
 			}
 
