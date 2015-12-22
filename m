From: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Subject: [PATCH v2 08/17] be2iscsi: Fix VLAN support for IPv6 network
Date: Tue, 22 Dec 2015 22:45:53 +0530
Message-ID: <1450804562-11980-9-git-send-email-jitendra.bhivare@avagotech.com>
References: <1450804562-11980-1-git-send-email-jitendra.bhivare@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmrelayp1.emulex.com ([138.239.112.140]:49452 "EHLO
	CMRELAYP1.ad.emulex.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754183AbbLVRQd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Dec 2015 12:16:33 -0500
In-Reply-To: <1450804562-11980-1-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jitendra Bhivare <jitendra.bhivare@avagotech.com>

Configuring VLAN parameters through IPv6 interface was not supported in driver.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/be2iscsi/be_iscsi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 188d83f..c89a025 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -466,6 +466,10 @@ beiscsi_set_ipv6(struct Scsi_Host *shost,
 		ret = mgmt_set_ip(phba, iface_param, NULL,
 				  ISCSI_BOOTPROTO_STATIC);
 		break;
+	case ISCSI_NET_PARAM_VLAN_ENABLED:
+	case ISCSI_NET_PARAM_VLAN_TAG:
+		ret = beiscsi_set_vlan_tag(shost, iface_param);
+		break;
 	default:
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
 			    "BS_%d : Param %d not supported\n",
-- 
1.9.1

