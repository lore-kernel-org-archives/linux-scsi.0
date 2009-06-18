From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH -next] bnx2i/cnic: kconfig interactions
Date: Thu, 18 Jun 2009 09:55:17 -0700
Message-ID: <4A3A7175.8080006@oracle.com>
References: <20090618145949.d933719a.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20090618145949.d933719a.sfr@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>, Anil Veerabhadrappa <anilgv@broadcom.com>, Michael Chan <mchan@broadcom.com>, scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
List-Id: linux-scsi@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

NETDEVICES + NETDEV_1000 need to be enabled so that kconfig will check
those branches for selects and enforce "select UIO" under CNIC.
Otherwise the build fails with:

ERROR: "uio_unregister_device" [drivers/net/cnic.ko] undefined!
ERROR: "uio_event_notify" [drivers/net/cnic.ko] undefined!
ERROR: "__uio_register_device" [drivers/net/cnic.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Anil Veerabhadrappa <anilgv@broadcom.com>
Cc: Michael Chan <mchan@broadcom.com>
---
 drivers/scsi/bnx2i/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- linux-next-20090618.orig/drivers/scsi/bnx2i/Kconfig
+++ linux-next-20090618/drivers/scsi/bnx2i/Kconfig
@@ -1,6 +1,8 @@
 config SCSI_BNX2_ISCSI
 	tristate "Broadcom NetXtreme II iSCSI support"
 	select SCSI_ISCSI_ATTRS
+	select NETDEVICES
+	select NETDEV_1000
 	select CNIC
 	depends on PCI
 	---help---



-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
