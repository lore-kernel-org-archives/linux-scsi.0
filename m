From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 10/10] mlx4_fc: Enable FC over Ethernet/Infiniband
	drivers
Date: Mon, 16 Aug 2010 15:17:05 -0700
Message-ID: <4C69B8E1.80702@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080500090200010304030206"
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Linux SCSI <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------080500090200010304030206
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



--------------080500090200010304030206
Content-Type: text/x-patch;
 name="0010-mlx4_fc-Enable-FC-over-Ethernet-Infiniband-drivers.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0010-mlx4_fc-Enable-FC-over-Ethernet-Infiniband-drivers.patc";
 filename*1="h"

>From 17b0c5412e085e1f288c05cb667ec36e4a05c59b Mon Sep 17 00:00:00 2001
From: Vu Pham <vu-OnC3O1emZK9LiOotz6YBiwC/G2K4zDHf@public.gmane.org>
Date: Mon, 16 Aug 2010 14:48:01 -0700
Subject: [PATCH 10/10] mlx4_fc: Enable FC over Ethernet/Infiniband drivers

Add entries in scsi's Kconfig and Makefile to enable mlx4_fc
(fcoe/fcoib offload driver) and mlx4_fcoib (FIP-alike discovery
driver)

Signed-off-by: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/scsi/Kconfig  |   22 ++++++++++++++++++++++
 drivers/scsi/Makefile |    2 ++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 158284f..3573cee 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -687,6 +687,28 @@ config FCOE_FNIC
 	  <file:Documentation/scsi/scsi.txt>.
 	  The module will be called fnic.
 
+config MLX4_FC
+	tristate "Mellanox FC module"
+	depends on MLX4_EN
+	select LIBFC
+	select LIBFCOE
+	help
+	  Fibre Channel over Ethernet/Infiniband module
+
+	  This is support for the Mellanox ConnectX/ConnectX-2 HCAs
+	  The module will be called mlx4_fc
+
+config MLX4_FCOIB
+	tristate "Mellanox FCoIB discovery module"
+	depends on INFINIBAND
+	select MLX4_FC
+	help
+	  Fibre Channel over Infiniband discovery module
+
+	  The module FIP-alike to discover BridgeX gateways in the
+	  Infiniband fabric
+	  The module will be called mlx4_fc
+
 config SCSI_DMX3191D
 	tristate "DMX3191D SCSI support"
 	depends on PCI && SCSI
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 2a3fca2..0d0dab7 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -40,6 +40,8 @@ obj-$(CONFIG_LIBFC)		+= libfc/
 obj-$(CONFIG_LIBFCOE)		+= fcoe/
 obj-$(CONFIG_FCOE)		+= fcoe/
 obj-$(CONFIG_FCOE_FNIC)		+= fnic/
+obj-$(CONFIG_MLX4_FC)		+= mlx4_fc/
+obj-$(CONFIG_MLX4_FCOIB)	+= mlx4_fc/
 obj-$(CONFIG_ISCSI_TCP) 	+= libiscsi.o	libiscsi_tcp.o iscsi_tcp.o
 obj-$(CONFIG_INFINIBAND_ISER) 	+= libiscsi.o
 obj-$(CONFIG_SCSI_A4000T)	+= 53c700.o	a4000t.o
-- 
1.6.3.3


--------------080500090200010304030206
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
ewg mailing list
ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg
--------------080500090200010304030206--
