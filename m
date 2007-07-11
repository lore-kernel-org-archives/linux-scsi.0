From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH 6/6] tgt: convert ibmvstgt to use transport
 tsk_mgmt_response callback
Date: Wed, 11 Jul 2007 15:08:24 +0900
Message-ID: <20070711150824P.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:57444 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760057AbXGKGMK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jul 2007 02:12:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, fujita.tomonori@lab.ntt.co.jp

This converts ibmvstgt to use transport tsk_mgmt_response callback.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/ibmvscsi/ibmvstgt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvstgt.c b/drivers/scsi/ibmvscsi/ibmvstgt.c
index 4ee6e41..3db03dd 100644
--- a/drivers/scsi/ibmvscsi/ibmvstgt.c
+++ b/drivers/scsi/ibmvscsi/ibmvstgt.c
@@ -818,7 +818,6 @@ static struct scsi_host_template ibmvstg
 	.max_sectors		= DEFAULT_MAX_SECTORS,
 	.transfer_response	= ibmvstgt_cmd_done,
 	.eh_abort_handler	= ibmvstgt_eh_abort_handler,
-	.tsk_mgmt_response	= ibmvstgt_tsk_mgmt_response,
 	.shost_attrs		= ibmvstgt_attrs,
 	.proc_name		= TGT_NAME,
 };
@@ -945,6 +944,7 @@ static int get_system_info(void)
 }
 
 static struct srp_function_template ibmvstgt_transport_functions = {
+	.tsk_mgmt_response = ibmvstgt_tsk_mgmt_response,
 	.it_nexus_response = ibmvstgt_it_nexus_response,
 };
 
-- 
1.4.3.2

