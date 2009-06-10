From: "Michael Chan" <mchan@broadcom.com>
Subject: [PATCH] cnic, bnx2i: Fix build failure when CONFIG_PCI is not
 set.
Date: Wed, 10 Jun 2009 13:35:28 -0700
Message-ID: <1244666128-7685-1-git-send-email-mchan@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1639 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753256AbZFJVZy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Jun 2009 17:25:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu, davem@davemloft.net
Cc: linux-scsi@vger.kernel.org, Michael Chan <mchan@broadcom.com>

CNIC and BNX2I must depend on PCI.  Dependencies do not get
propagated through select.

Signed-off-by: Michael Chan <mchan@broadcom.com>
---
 drivers/net/Kconfig        |    5 +++--
 drivers/scsi/bnx2i/Kconfig |    1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index f3c4a3b..f690314 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -2266,8 +2266,9 @@ config BNX2
 
 config CNIC
 	tristate "Broadcom CNIC support"
-	depends on BNX2
-	depends on UIO
+	depends on PCI
+	select BNX2
+	select UIO
 	help
 	  This driver supports offload features of Broadcom NetXtremeII
 	  gigabit Ethernet cards.
diff --git a/drivers/scsi/bnx2i/Kconfig b/drivers/scsi/bnx2i/Kconfig
index 820d428..b62b482 100644
--- a/drivers/scsi/bnx2i/Kconfig
+++ b/drivers/scsi/bnx2i/Kconfig
@@ -2,6 +2,7 @@ config SCSI_BNX2_ISCSI
 	tristate "Broadcom NetXtreme II iSCSI support"
 	select SCSI_ISCSI_ATTRS
 	select CNIC
+	depends on PCI
 	---help---
 	This driver supports iSCSI offload for the Broadcom NetXtreme II
 	devices.
-- 
1.5.6.GIT


