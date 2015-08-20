From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH v2 8/10] megaraid_sas : Fix validHandles check in io path
Date: Thu, 20 Aug 2015 18:44:59 +0530
Message-ID: <201508201320.t7KDKXQn028828@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sgpsmtp1.avagotech.com ([202.86.248.61]:46511 "EHLO
	sgpsmtp1.avagotech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbbHTNPM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Aug 2015 09:15:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, kiran-kumar.kasturi@avagotech.com
Cc: uday.lingala@avagotech.com

Syncro firmware supports round robin IO switch on dual path. For this driver 
use validHandles as a check for dual path. This check suppose to be > 1 (not > 2)

Without this patch, earlier driver code does not use dual path functionality.

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 9f39859..64e27e6 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1686,7 +1686,7 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
 			scp->SCp.Status &= ~MEGASAS_LOAD_BALANCE_FLAG;
 
 		if ((raidLUN[0] == 1) &&
-			(local_map_ptr->raidMap.devHndlInfo[io_info.pd_after_lb].validHandles > 2)) {
+			(local_map_ptr->raidMap.devHndlInfo[io_info.pd_after_lb].validHandles > 1)) {
 			instance->dev_handle = !(instance->dev_handle);
 			io_info.devHandle =
 				local_map_ptr->raidMap.devHndlInfo[io_info.pd_after_lb].devHandle[instance->dev_handle];
-- 
1.7.1

