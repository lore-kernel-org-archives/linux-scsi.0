From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] target/cxgbit: add INET dependency
Date: Mon, 29 Feb 2016 12:14:50 +0100
Message-ID: <1456744504-3011977-1-git-send-email-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>, Varun Prakash <varun@chelsio.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The newly added cxgbit driver directly calls functions of the
IPv4 network stack, which fails if that is disabled:

ERROR: "ip_route_output_flow" [drivers/target/iscsi/cxgbit/cxgbit.ko] undefined!
ERROR: "__ip_dev_find" [drivers/target/iscsi/cxgbit/cxgbit.ko] undefined!

This adds a Kconfig dependency to ensure we can't enable this
driver without the complete network stack it needs.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: b7ca3321e114 ("cxgbit: add Kconfig and Makefile")
---
 drivers/target/iscsi/cxgbit/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/target/iscsi/cxgbit/Kconfig b/drivers/target/iscsi/cxgbit/Kconfig
index cf335b4dbb4e..ce6f5cca315d 100644
--- a/drivers/target/iscsi/cxgbit/Kconfig
+++ b/drivers/target/iscsi/cxgbit/Kconfig
@@ -1,6 +1,7 @@
 config ISCSI_TARGET_CXGB4
 	tristate "Chelsio iSCSI target offload driver"
 	depends on ISCSI_TARGET && CHELSIO_T4
+	depends on INET
 	select CHELSIO_T4_UWIRE
 	---help---
 	To compile this driver as module, choose M here: the module
-- 
2.7.0
