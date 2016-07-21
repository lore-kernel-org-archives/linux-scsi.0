From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH 11/28] be2iscsi: Handle only NET_PARAM in iface_get_param
Date: Thu, 21 Jul 2016 14:37:48 +0530
Message-ID: <1469092085-14311-12-git-send-email-jitendra.bhivare@broadcom.com>
References: <1469092085-14311-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:38319 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbcGUJJA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jul 2016 05:09:00 -0400
Received: by mail-wm0-f53.google.com with SMTP id o80so16901183wme.1
        for <linux-scsi@vger.kernel.org>; Thu, 21 Jul 2016 02:09:00 -0700 (PDT)
In-Reply-To: <1469092085-14311-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: mchristi@redhat.com, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

Wrong settings displayed for iface:
iface.header_digest = 192.168.197.22
iface.data_digest = 255.255.255.0
iface.immediate_data = 192.168.197.1

Process ISCSI_NET_PARAM only in beiscsi_iface_get_param.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
---
 drivers/scsi/be2iscsi/be_iscsi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 1fe273d..fa415c4 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -574,6 +574,8 @@ int beiscsi_iface_get_param(struct iscsi_iface *iface,
 	struct be_cmd_get_def_gateway_resp gateway;
 	int len = -EPERM;
 
+	if (param_type != ISCSI_NET_PARAM)
+		return 0;
 	if (phba->state & BE_ADAPTER_PCI_ERR) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
 			    "BS_%d : In PCI_ERROR Recovery\n");
-- 
1.9.1

