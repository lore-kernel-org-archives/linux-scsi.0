From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH -next v2] cxgb3i: use same dependencies & selects as
 CHELSIO_T3
Date: Mon, 29 Dec 2008 13:23:12 -0800
Message-ID: <20081229132312.10934479.randy.dunlap@oracle.com>
References: <20081230031621.60acd90b.sfr@canb.auug.org.au>
	<20081229130110.67d5271a.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20081229130110.67d5271a.randy.dunlap@oracle.com>
Sender: linux-next-owner@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, kxie@chelsio.com, akpm <akpm@linux-foundation.org>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, jejb <James.Bottomley@hansenpartnership.com>
List-Id: linux-scsi@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Make the CXGB iSCSI driver (that selects the CXGB net driver) have the same
dependencies as the net driver, since kconfig doesn't do that automatically.
Also make it select INET_LRO & FW_LOADER like the net driver does.

drivers/net/cxgb3/cxgb3_main.c:269: error: implicit declaration of function 'pci_disable_msix'
drivers/net/cxgb3/cxgb3_main.c:272: error: implicit declaration of function 'pci_disable_msi'
drivers/net/cxgb3/cxgb3_main.c:2778: error: array type has incomplete element type
drivers/net/cxgb3/cxgb3_main.c:2781: warning: type defaults to 'int' in declaration of 'type name'
drivers/net/cxgb3/cxgb3_main.c:2781: warning: type defaults to 'int' in declaration of 'type name'
drivers/net/cxgb3/cxgb3_main.c:2781: error: size of array 'type name' is negative
drivers/net/cxgb3/cxgb3_main.c:2784: error: implicit declaration of function 'pci_enable_msix'
drivers/net/cxgb3/cxgb3_main.c:2784: warning: type defaults to 'int' in declaration of 'type name'
drivers/net/cxgb3/cxgb3_main.c:2784: warning: type defaults to 'int' in declaration of 'type name'
drivers/net/cxgb3/cxgb3_main.c:2784: error: size of array 'type name' is negative
drivers/net/cxgb3/cxgb3_main.c:2786: warning: type defaults to 'int' in declaration of 'type name'
drivers/net/cxgb3/cxgb3_main.c:2786: warning: type defaults to 'int' in declaration of 'type name'
drivers/net/cxgb3/cxgb3_main.c:2786: error: size of array 'type name' is negative
drivers/net/cxgb3/cxgb3_main.c:2778: warning: unused variable 'entries'
drivers/net/cxgb3/cxgb3_main.c:3011: error: implicit declaration of function 'pci_enable_msi'

and from a different build:

ERROR: "lro_vlan_hwaccel_receive_frags" [drivers/net/cxgb3/cxgb3.ko] undefined!
ERROR: "lro_receive_frags" [drivers/net/cxgb3/cxgb3.ko] undefined!
ERROR: "lro_receive_skb" [drivers/net/cxgb3/cxgb3.ko] undefined!
ERROR: "lro_vlan_hwaccel_receive_skb" [drivers/net/cxgb3/cxgb3.ko] undefined!
ERROR: "lro_flush_all" [drivers/net/cxgb3/cxgb3.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/cxgb3i/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

--- linux-next-20081229.orig/drivers/scsi/cxgb3i/Kconfig
+++ linux-next-20081229/drivers/scsi/cxgb3i/Kconfig
@@ -1,6 +1,9 @@
 config SCSI_CXGB3_ISCSI
 	tristate "Chelsio S3xx iSCSI support"
+	depends on PCI && INET
 	select CHELSIO_T3
 	select SCSI_ISCSI_ATTRS
+	select INET_LRO
+	select FW_LOADER
 	---help---
 	This driver supports iSCSI offload for the Chelsio S3 series devices.
