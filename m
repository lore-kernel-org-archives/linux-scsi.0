From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH -next] scsi: be2iscsi needs ISCSI_BOOT_SYSFS
Date: Thu, 29 Jul 2010 10:16:09 -0700
Message-ID: <20100729101609.965dbe48.randy.dunlap@oracle.com>
References: <20100729143211.9e7edaed.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20100729143211.9e7edaed.sfr@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>, scsi <linux-scsi@vger.kernel.org>, Jayamohan Kallickal <jayamohank@serverengines.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, jejbscsi <james.bottomley@suse.de>
List-Id: linux-scsi@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

be2iscsi uses iscsi_boot_*() interfaces, so it should ensure that
ISCSI_BOOT_SYSFS is enabled.

ERROR: "iscsi_boot_create_target" [drivers/scsi/be2iscsi/be2iscsi.ko] undefined!
ERROR: "iscsi_boot_create_ethernet" [drivers/scsi/be2iscsi/be2iscsi.ko] undefined!
ERROR: "iscsi_boot_create_host_kset" [drivers/scsi/be2iscsi/be2iscsi.ko] undefined!
ERROR: "iscsi_boot_create_initiator" [drivers/scsi/be2iscsi/be2iscsi.ko] undefined!
ERROR: "iscsi_boot_destroy_kset" [drivers/scsi/be2iscsi/be2iscsi.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/be2iscsi/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20100729.orig/drivers/scsi/be2iscsi/Kconfig
+++ linux-next-20100729/drivers/scsi/be2iscsi/Kconfig
@@ -2,6 +2,7 @@ config BE2ISCSI
 	tristate "ServerEngines' 10Gbps iSCSI - BladeEngine 2"
 	depends on PCI && SCSI && NET
 	select SCSI_ISCSI_ATTRS
+	select ISCSI_BOOT_SYSFS
 
 	help
 	This driver implements the iSCSI functionality for ServerEngines'
---
