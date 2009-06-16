From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH -next] bnx2i/cnic: more kconfig dependencies
Date: Tue, 16 Jun 2009 10:25:45 -0700
Message-ID: <4A37D599.5080701@oracle.com>
References: <20090616165923.8ca4ddcb.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20090616165923.8ca4ddcb.sfr@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>
List-Id: linux-scsi@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

BNX2I selects CNIC, CNIC selects UIO.
It looks like BNX2I also needs to select UIO.

BTW, CNIC is under NETDEV_1000, which is not enabled.
I don't see any need to enable (select) it in this case,
but I could be wrong(?).  Should BNX2I also select NETDEV_1000?

cnic.c:(.text+0x17990b): undefined reference to `uio_event_notify'
cnic.c:(.text+0x17a197): undefined reference to `uio_unregister_device'
cnic.c:(.text+0x17c618): undefined reference to `__uio_register_device'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/bnx2i/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20090616.orig/drivers/scsi/bnx2i/Kconfig
+++ linux-next-20090616/drivers/scsi/bnx2i/Kconfig
@@ -2,6 +2,7 @@ config SCSI_BNX2_ISCSI
 	tristate "Broadcom NetXtreme II iSCSI support"
 	select SCSI_ISCSI_ATTRS
 	select CNIC
+	select UIO
 	depends on PCI
 	---help---
 	This driver supports iSCSI offload for the Broadcom NetXtreme II


-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
