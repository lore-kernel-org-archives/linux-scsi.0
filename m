From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v1 10/10] mlx4_fc: Enable FC over
 Ethernet/Infiniband drivers
Date: Wed, 18 Aug 2010 09:55:50 -0700
Message-ID: <4C6C1096.9090900@mellanox.com>
References: <4C69B8E1.80702@mellanox.com>
	<20100816165137.d006efd0.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
In-Reply-To: <20100816165137.d006efd0.randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: Randy Dunlap <randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, OpenFabrics EWG <ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org>, Linux SCSI <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org


> 	depends on 
> +	select LIBFC
> +	select LIBFCOE
> +	help
> +	  Fibre Channel over Ethernet/Infiniband module
> +
> +	  This is support for the Mellanox ConnectX/ConnectX-2 HCAs
> +	  The module will be called mlx4_fc
> 
> End both lines above with periods (".").
> 
> +
> +	  The module FIP-alike to discover BridgeX gateways in the
> +	  Infiniband fabric
> 
> end sentence with ".".
> 
> What does "FIP-alike" mean?  and fix grammar:
> 
> 	  This module attempts to discover BridgeX gateways in the
> 	  Infiniband fabric.
> ?

> 
> end sentence with ".".

Thanks for you comments.

>From 54041f56fa1896388a52f503e43e21aa11cc9a2a Mon Sep 17 00:00:00 2001
From: Vu Pham <vu-OnC3O1emZK9LiOotz6YBiwC/G2K4zDHf@public.gmane.org>
Date: Tue, 17 Aug 2010 15:40:42 -0700
Subject: [PATCH 10/10] mlx4_fc: Enable FC over Ethernet/Infiniband drivers

Add entries in scsi's Kconfig and Makefile to enable mlx4_fc
(fcoe/fcoib offload driver) and mlx4_fcoib (FIP-alike discovery
driver)

Signed-off-by: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/scsi/Kconfig  |   23 +++++++++++++++++++++++
 drivers/scsi/Makefile |    2 ++
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 158284f..e3d2850 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -687,6 +687,29 @@ config FCOE_FNIC
 	  <file:Documentation/scsi/scsi.txt>.
 	  The module will be called fnic.
 
+config MLX4_FC
+	tristate "Mellanox FC module"
+	select MLX4_EN
+	select LIBFC
+	select LIBFCOE
+	help
+	  Fibre Channel over Ethernet/Infiniband module
+
+	  This is support for the Mellanox ConnectX/ConnectX-2 HCAs.
+	  The module will be called mlx4_fc.
+
+config MLX4_FCOIB
+	tristate "Mellanox FCoIB discovery module"
+	depends on INFINIBAND
+	select MLX4_FC
+	help
+	  Fibre Channel over Infiniband discovery module
+
+	  The module attempts to discover BridgeX gateways in the
+	  Infiniband fabric by implementing FIP protocol (FCoE
+	  Initialization protocol) over Infiniband.
+	  The module will be called mlx4_fcoib.
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
