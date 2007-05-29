From: Swen Schillig <swen@vnet.ibm.com>
Subject: [PATCH 2/3] zfcp: clear adapter status flags during adapter shutdown
Date: Tue, 29 May 2007 15:29:49 +0200
Message-ID: <200705291529.50169.swen@vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:38203 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762326AbXE2N0l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 May 2007 09:26:41 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, sameske@de.ibm.com

From: Volker Sameske <sameske@de.ibm.com>

zfcp: clear adapter status flags during adapter shutdown

In some cases we did not reset some adapter status flags properly.
This patch clears these flags during FCP adapter shutdown.

Signed-off-by: Volker Sameske <sameske@de.ibm.com>
Signed-off-by: Swen Schillig <swen@vnet.ibm.com>

---

 drivers/s390/scsi/zfcp_erp.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux_jb_patched/drivers/s390/scsi/zfcp_erp.c
===================================================================
--- linux_jb_patched.orig/drivers/s390/scsi/zfcp_erp.c
+++ linux_jb_patched/drivers/s390/scsi/zfcp_erp.c
@@ -1986,6 +1986,10 @@ zfcp_erp_adapter_strategy_generic(struct
  failed_openfcp:
 	zfcp_close_fsf(erp_action->adapter);
  failed_qdio:
+	atomic_clear_mask(ZFCP_STATUS_ADAPTER_XCONFIG_OK |
+			  ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED |
+			  ZFCP_STATUS_ADAPTER_XPORT_OK,
+			  &erp_action->adapter->status);
  out:
 	return retval;
 }
@@ -2167,6 +2171,9 @@ zfcp_erp_adapter_strategy_open_fsf_xconf
 		sleep *= 2;
 	}
 
+	atomic_clear_mask(ZFCP_STATUS_ADAPTER_HOST_CON_INIT,
+			  &adapter->status);
+
 	if (!atomic_test_mask(ZFCP_STATUS_ADAPTER_XCONFIG_OK,
 			      &adapter->status)) {
 		ZFCP_LOG_INFO("error: exchange of configuration data for "
