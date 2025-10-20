Received: from mail-m49208.qiye.163.com (mail-m49208.qiye.163.com [45.254.49.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B07F78F5D;
	Mon, 20 Oct 2025 07:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760944190; cv=none; b=bZU20ir7GIF0Pu/UnUse1kQY/L2aSx8Kux6SgUvkyENqISin45QBRARFRgvLc4xSQ5Zbp64aiDCATXPVIFS0OAg35SYX8i6cHbmQCz6/c8eC+cQFURcQbtOtK0SXoEkaBv0GcDSMq2bcIYlvfb5nt3CQe9GXGafiF0sb8bFIgbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760944190; c=relaxed/simple;
	bh=GxGrFcStbn+NZe+QS0DsHoiZjsogPuV+aqz+aGbdPFo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oQX9HqMmFl9+DOsd7d9q+p7haLoRQUQw4jFV23KFv2fJmkejnW1LdeMGZIJTgOuI9npRzC4BqGNiCQPzdRiE8jrxBfLsQ6as12oytxs7GMavznAPDMEXyUs/keXRT10l2f3GJYdyETV5zhwqmOI+ZWzZzeBCJ6DgjROTBgvZE8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=winhong.com; spf=pass smtp.mailfrom=winhong.com; arc=none smtp.client-ip=45.254.49.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=winhong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=winhong.com
Received: from localhost.localdomain (unknown [183.6.116.60])
	by smtp.qiye.163.com (Hmail) with ESMTP id 267aef26c;
	Mon, 20 Oct 2025 15:04:26 +0800 (GMT+08:00)
From: yili <yili@winhong.com>
To: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yili@winhong.com
Cc: megaraidlinux.pdl@broadcom.com,
	kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com,
	shivasharan.srikanteshwara@broadcom.com,
	chandrakanth.patil@broadcom.com
Subject: [PATCH] scsi: megaraid_sas: Use local scmd_local variable consistently
Date: Mon, 20 Oct 2025 15:04:07 +0800
Message-ID: <20251020070407.245889-1-yili@winhong.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9a006f03a703ackunmf1389200dc8258
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlDT00eVh5MTx4eT05ITk9NHlYVFAkWGhdVEwETFh
	oSFyQUDg9ZV1kYEgtZQVlKQ0hVTVVKSk1VTUtZV1kWGg8SFR0UWUFZT0tIVUpLSU9PT0hVSktLVU
	pCS0tZBg++

From: Yi Li <yili@winhong.com>

This is a code refactoring patch that replaces multiple instances of
'cmd_fusion->scmd' with the local variable 'scmd_local' in two functions:

The changes improve code consistency and maintainability by using the
already available local variable instead of repeatedly dereferencing
the command structure. No functional changes are introduced.

Signed-off-by: Yi Li <yili@winhong.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index a6794f49e9fa..76120e9cdd89 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -3616,12 +3616,12 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex,
 		case MPI2_FUNCTION_SCSI_IO_REQUEST:  /*Fast Path IO.*/
 			/* Update load balancing info */
 			if (fusion->load_balance_info &&
-			    (megasas_priv(cmd_fusion->scmd)->status &
+			    (megasas_priv(scmd_local)->status &
 			    MEGASAS_LOAD_BALANCE_FLAG)) {
 				device_id = MEGASAS_DEV_INDEX(scmd_local);
 				lbinfo = &fusion->load_balance_info[device_id];
 				atomic_dec(&lbinfo->scsi_pending_cmds[cmd_fusion->pd_r1_lb]);
-				megasas_priv(cmd_fusion->scmd)->status &=
+				megasas_priv(scmd_local)->status &=
 					~MEGASAS_LOAD_BALANCE_FLAG;
 			}
 			fallthrough;	/* and complete IO */
@@ -5000,12 +5000,12 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
 				megasas_return_cmd_fusion(instance, r1_cmd);
 			}
 			scmd_local = cmd_fusion->scmd;
-			if (cmd_fusion->scmd) {
+			if (scmd_local) {
 				if (megasas_dbg_lvl & OCR_DEBUG) {
 					sdev_printk(KERN_INFO,
-						cmd_fusion->scmd->device, "SMID: 0x%x\n",
+						scmd_local->device, "SMID: 0x%x\n",
 						cmd_fusion->index);
-					megasas_dump_fusion_io(cmd_fusion->scmd);
+					megasas_dump_fusion_io(scmd_local);
 				}
 
 				if (cmd_fusion->io_request->Function ==
-- 
2.43.0

