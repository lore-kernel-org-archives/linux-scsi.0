From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] SCSI: ips: remove pointless #warning
Date: Tue, 13 Jan 2015 22:19:48 +0100
Message-ID: <1469112.NM94QHK9oc@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Adaptec OEM Raid Solutions <aacraid@adaptec.com>
List-Id: linux-scsi@vger.kernel.org

The ips driver contains

 #warning "This driver has only been tested on the x86/ia64/x86_64 platforms"

which gets printed by the compiler every time this driver gets
build for something other than those three architectures. The same
is true for most other drivers, but none of them prints a warning like
this.

Let's remove the warning now to reduce the amount of clutter.

FWIW, I've reviewed the driver and found a few oddities, but nothing
that needs to be fixed or that would be architecture specific.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index e5c28435d768..265ec482becc 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -206,10 +206,6 @@ module_param(ips, charp, 0);
 #define IPS_VERSION_HIGH        IPS_VER_MAJOR_STRING "." IPS_VER_MINOR_STRING
 #define IPS_VERSION_LOW         "." IPS_VER_BUILD_STRING " "
 
-#if !defined(__i386__) && !defined(__ia64__) && !defined(__x86_64__)
-#warning "This driver has only been tested on the x86/ia64/x86_64 platforms"
-#endif
-
 #define IPS_DMA_DIR(scb) ((!scb->scsi_cmd || ips_is_passthru(scb->scsi_cmd) || \
                          DMA_NONE == scb->scsi_cmd->sc_data_direction) ? \
                          PCI_DMA_BIDIRECTIONAL : \
