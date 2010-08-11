From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH -next] firmware: ibft depends on SCSI
Date: Wed, 11 Aug 2010 10:36:20 -0700
Message-ID: <20100811103620.2d25d573.randy.dunlap@oracle.com>
References: <20100811140009.6ff33109.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100811140009.6ff33109.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>, Peter Jones <pjones@redhat.com>, Konrad Rzeszutek Wilk <konrad@kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Prevent build errors when SCSI is not enabled:

iscsi_ibft.c:(.init.text+0x548d): undefined reference to `iscsi_boot_create_initiator'
iscsi_ibft.c:(.init.text+0x54a9): undefined reference to `iscsi_boot_create_ethernet'
iscsi_ibft.c:(.init.text+0x54c5): undefined reference to `iscsi_boot_create_target'
iscsi_ibft.c:(.init.text+0x55ff): undefined reference to `iscsi_boot_destroy_kset'
iscsi_ibft.c:(.init.text+0x561e): undefined reference to `iscsi_boot_create_kset'
iscsi_ibft.c:(.exit.text+0xe2c): undefined reference to `iscsi_boot_destroy_kset'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc:	Peter Jones <pjones@redhat.com>
Cc:	Konrad Rzeszutek Wilk <konrad@kernel.org>
---
 drivers/firmware/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20100811.orig/drivers/firmware/Kconfig
+++ linux-next-20100811/drivers/firmware/Kconfig
@@ -125,7 +125,7 @@ config ISCSI_IBFT_FIND
 config ISCSI_IBFT
 	tristate "iSCSI Boot Firmware Table Attributes module"
 	select ISCSI_BOOT_SYSFS
-	depends on ISCSI_IBFT_FIND
+	depends on ISCSI_IBFT_FIND && SCSI
 	default	n
 	help
 	  This option enables support for detection and exposing of iSCSI
