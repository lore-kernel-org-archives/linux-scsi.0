From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: [patch 6/8] mptfusion: fc transport
Date: Fri, 19 Nov 2004 08:39:11 -0700
Message-ID: <91888D455306F94EBD4D168954A9457C5468AD@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C4CE4D.EA7ADA60"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:34752 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261470AbUKSQMM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Nov 2004 11:12:12 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id iAJGAWcq006830
	for <linux-scsi@vger.kernel.org>; Fri, 19 Nov 2004 08:10:32 -0800 (PST)
Received: from nacos172.ad.lsil.com (cos1.co.lsil.com [172.21.35.122])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id iAJGC8Fs030509
	for <linux-scsi@vger.kernel.org>; Fri, 19 Nov 2004 08:12:08 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C4CE4D.EA7ADA60
Content-Type: text/plain;
	charset="iso-8859-1"

This provides fc_transport support, exporting
port_id, port_name, node_name.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>







------_=_NextPart_000_01C4CE4D.EA7ADA60
Content-Type: application/octet-stream;
	name="mptfusion-6.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="mptfusion-6.patch"

diff -uarN b/drivers/message/fusion/Kconfig =
a/drivers/message/fusion/Kconfig=0A=
--- b/drivers/message/fusion/Kconfig	2004-11-17 16:24:38.000000000 =
-0700=0A=
+++ a/drivers/message/fusion/Kconfig	2004-11-18 12:28:57.000000000 =
-0700=0A=
@@ -4,6 +4,7 @@=0A=
 config FUSION=0A=
 	tristate "Fusion MPT (base + ScsiHost) drivers"=0A=
 	depends on PCI && SCSI=0A=
+        select SCSI_FC_ATTRS=0A=
 	---help---=0A=
 	  LSI Logic Fusion(TM) Message Passing Technology (MPT) device =
support=0A=
 	  provides high performance SCSI host initiator, and LAN [1] =
interface=0A=
diff -uarN b/drivers/message/fusion/Makefile =
a/drivers/message/fusion/Makefile=0A=
--- b/drivers/message/fusion/Makefile	2004-11-18 12:18:18.000000000 =
-0700=0A=
+++ a/drivers/message/fusion/Makefile	2004-11-18 12:24:53.000000000 =
-0700=0A=
@@ -33,6 +33,7 @@=0A=
 #CFLAGS_mptscsih.o +=3D -DMPT_DEBUG_SCANDV=0A=
 #CFLAGS_mptscsih.o +=3D -DMPT_DEBUG_RESET=0A=
 #CFLAGS_mptscsih.o +=3D -DMPT_DEBUG_NEH=0A=
+CFLAGS_mptscsih.o +=3D -DMPTSCSIH_ENABLE_FC_TRANSPORT=0A=
 #=0A=
 #  For mptctl:=0A=
 #CFLAGS_mptctl.o +=3D -DMPT_DEBUG_IOCTL=0A=
diff -uarN b/drivers/message/fusion/mptscsih.c =
a/drivers/message/fusion/mptscsih.c=0A=
--- b/drivers/message/fusion/mptscsih.c	2004-11-18 14:54:27.000000000 =
-0700=0A=
+++ a/drivers/message/fusion/mptscsih.c	2004-11-18 14:54:45.000000000 =
-0700=0A=
@@ -83,6 +83,8 @@=0A=
 #include <scsi/scsi_device.h>=0A=
 #include <scsi/scsi_host.h>=0A=
 #include <scsi/scsi_tcq.h>=0A=
+#include <scsi/scsi_transport.h>=0A=
+#include <scsi/scsi_transport_fc.h>=0A=
 =0A=
 #include "mptbase.h"=0A=
 #include "mptscsih.h"=0A=
@@ -259,6 +261,10 @@=0A=
 static struct mptscsih_driver_setup driver_setup;=0A=
 static struct scsi_host_template driver_template;=0A=
 =0A=
+#if defined(MPTSCSIH_ENABLE_FC_TRANSPORT)=0A=
+static struct scsi_transport_template *mptscsih_transport_template =3D =
NULL;=0A=
+#endif=0A=
+=0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 /**=0A=
  *	mptscsih_add_sge - Place a simple SGE at address pAddr.=0A=
@@ -1129,7 +1135,13 @@=0A=
 	sh->max_lun =3D MPT_LAST_LUN + 1;=0A=
 	sh->max_channel =3D 0;=0A=
 	sh->this_id =3D ioc->pfacts[0].PortSCSIID;=0A=
-		=0A=
+	=0A=
+#if defined(MPTSCSIH_ENABLE_FC_TRANSPORT)=0A=
+	if (ioc->bus_type =3D=3D FC) {=0A=
+		BUG_ON(mptscsih_transport_template =3D=3D NULL);=0A=
+		sh->transportt =3D mptscsih_transport_template;=0A=
+	}=0A=
+#endif=0A=
 	/* Required entry.=0A=
 	 */=0A=
 	sh->unique_id =3D ioc->id;=0A=
@@ -1301,6 +1313,145 @@=0A=
 =0A=
 }=0A=
 =0A=
+#if defined(MPTSCSIH_ENABLE_FC_TRANSPORT)=0A=
+/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
+/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
+/*=0A=
+ *	GetFcDevicePage0 - returns FC Device Page 0 data=0A=
+ *	@ioc: Pointer to MPT_ADAPTER structure=0A=
+ *	@bus: bus id=0A=
+ *	@targetId: target id=0A=
+ *	@fcDevicePage: FC Device Page 0 data=0A=
+ *=0A=
+ *	Returns count of number bytes copied into @fcDevicePage=0A=
+ *=0A=
+ */=0A=
+=0A=
+static int=0A=
+GetFcDevicePage0(MPT_ADAPTER *ioc, u8 bus, u8 targetId, =
pFCDevicePage0_t fcDevicePage)=0A=
+{=0A=
+	ConfigPageHeader_t	 hdr;=0A=
+	CONFIGPARMS		 cfg;=0A=
+	pFCDevicePage0_t	 ppage0_alloc;=0A=
+	dma_addr_t		 page0_dma;=0A=
+	int			 data_sz;=0A=
+	int			 copy_sz=3D0;=0A=
+	int			 rc;=0A=
+=0A=
+	/* Get FCPort Page 0 header */=0A=
+	hdr.PageVersion =3D 0;=0A=
+	hdr.PageLength =3D 0;=0A=
+	hdr.PageNumber =3D 0;=0A=
+	hdr.PageType =3D MPI_CONFIG_PAGETYPE_FC_DEVICE;=0A=
+	cfg.hdr =3D &hdr;=0A=
+	cfg.physAddr =3D -1;=0A=
+	cfg.action =3D MPI_CONFIG_ACTION_PAGE_HEADER;=0A=
+	cfg.dir =3D 0;=0A=
+=0A=
+	cfg.pageAddr =3D (bus << 8) + targetId + =
MPI_FC_DEVICE_PGAD_FORM_BUS_TID;=0A=
+	cfg.timeout =3D 0;=0A=
+=0A=
+	if ((rc =3D mpt_config(ioc, &cfg)) !=3D 0)=0A=
+		return 0;=0A=
+=0A=
+	if (hdr.PageLength =3D=3D 0)=0A=
+		return 0;=0A=
+=0A=
+	data_sz =3D hdr.PageLength * 4;=0A=
+	rc =3D -ENOMEM;=0A=
+	ppage0_alloc =3D (pFCDevicePage0_t ) =
pci_alloc_consistent(ioc->pcidev,=0A=
+	    data_sz, &page0_dma);=0A=
+	if (ppage0_alloc) {=0A=
+		memset((u8 *)ppage0_alloc, 0, data_sz);=0A=
+		cfg.physAddr =3D page0_dma;=0A=
+		cfg.action =3D MPI_CONFIG_ACTION_PAGE_READ_CURRENT;=0A=
+=0A=
+		if ((rc =3D mpt_config(ioc, &cfg)) =3D=3D 0) {=0A=
+			/* save the data */=0A=
+			copy_sz =3D min_t(int, sizeof(FCDevicePage0_t), data_sz);=0A=
+			memcpy(fcDevicePage, ppage0_alloc, copy_sz);=0A=
+		}=0A=
+=0A=
+		pci_free_consistent(ioc->pcidev, data_sz, (u8 *) ppage0_alloc,=0A=
+		    page0_dma);=0A=
+	}=0A=
+=0A=
+	return copy_sz;=0A=
+}=0A=
+=0A=
+static void=0A=
+mptscsih_get_port_id(struct scsi_target *starget)=0A=
+{=0A=
+	struct Scsi_Host *host =3D dev_to_shost(starget->dev.parent);=0A=
+	MPT_SCSI_HOST	*hd;=0A=
+	MPT_ADAPTER 	*ioc;=0A=
+	FCDevicePage0_t fcDevicePage;=0A=
+	int rc;=0A=
+=0A=
+	fc_starget_port_id(starget) =3D -1;=0A=
+	hd =3D (MPT_SCSI_HOST *)host->hostdata;=0A=
+	if (hd=3D=3DNULL)=0A=
+		return;=0A=
+	ioc =3D hd->ioc;=0A=
+	rc =3D GetFcDevicePage0(ioc, starget->channel, starget->id, =
&fcDevicePage);=0A=
+	if (rc > offsetof(FCDevicePage0_t,Protocol))=0A=
+		fc_starget_port_id(starget) =3D =
le64_to_cpu(fcDevicePage.PortIdentifier);=0A=
+}=0A=
+=0A=
+static void=0A=
+mptscsih_get_port_name(struct scsi_target *starget)=0A=
+{=0A=
+	struct Scsi_Host *host =3D dev_to_shost(starget->dev.parent);=0A=
+	MPT_SCSI_HOST	*hd;=0A=
+	MPT_ADAPTER 	*ioc;=0A=
+	FCDevicePage0_t fcDevicePage;=0A=
+	int rc;=0A=
+=0A=
+	fc_starget_port_name(starget) =3D -1;=0A=
+	hd =3D (MPT_SCSI_HOST *)host->hostdata;=0A=
+	if (hd=3D=3DNULL)=0A=
+		return;=0A=
+	ioc =3D hd->ioc;=0A=
+	rc =3D GetFcDevicePage0(ioc, starget->channel, starget->id, =
&fcDevicePage);=0A=
+	if (rc > offsetof(FCDevicePage0_t,PortIdentifier)) {=0A=
+		memcpy(&fc_starget_port_name(starget),&fcDevicePage.WWPN,=0A=
+		    sizeof(fcDevicePage.WWPN));=0A=
+		le64_to_cpus(&fc_starget_port_name(starget));=0A=
+	}=0A=
+}=0A=
+=0A=
+static void=0A=
+mptscsih_get_node_name(struct scsi_target *starget)=0A=
+{=0A=
+	struct Scsi_Host *host =3D dev_to_shost(starget->dev.parent);=0A=
+	MPT_SCSI_HOST	*hd;=0A=
+	MPT_ADAPTER 	*ioc;=0A=
+	FCDevicePage0_t fcDevicePage;=0A=
+	int rc;=0A=
+=0A=
+	fc_starget_node_name(starget) =3D -1;=0A=
+	hd =3D (MPT_SCSI_HOST *)host->hostdata;=0A=
+	if (hd=3D=3DNULL)=0A=
+		return;=0A=
+	ioc =3D hd->ioc;=0A=
+	rc =3D GetFcDevicePage0(ioc, starget->channel, starget->id, =
&fcDevicePage);=0A=
+	if (rc > offsetof(FCDevicePage0_t,WWPN)) {=0A=
+		memcpy(&fc_starget_node_name(starget),&fcDevicePage.WWNN,=0A=
+		    sizeof(fcDevicePage.WWNN));=0A=
+		le64_to_cpus(&fc_starget_node_name(starget));=0A=
+	}=0A=
+}=0A=
+=0A=
+static struct fc_function_template mptscsih_transport_functions =3D =
{=0A=
+	.get_starget_port_id =3D mptscsih_get_port_id,=0A=
+	.show_starget_port_id =3D 1,=0A=
+	.get_starget_port_name =3D mptscsih_get_port_name,=0A=
+	.show_starget_port_name =3D 1,=0A=
+	.get_starget_node_name =3D mptscsih_get_node_name,=0A=
+	.show_starget_node_name =3D 1,=0A=
+};=0A=
+#endif=0A=
+=0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 /*=0A=
  *	mptscsih_remove - Removed scsi devices=0A=
@@ -1481,6 +1632,13 @@=0A=
 =0A=
 	show_mptmod_ver(my_NAME, my_VERSION);=0A=
 =0A=
+#if defined(MPTSCSIH_ENABLE_FC_TRANSPORT)=0A=
+	mptscsih_transport_template =3D =0A=
+	    fc_attach_transport(&mptscsih_transport_functions);=0A=
+	if (!mptscsih_transport_template)=0A=
+		return -ENODEV;=0A=
+#endif=0A=
+	=0A=
 	ScsiDoneCtx =3D mpt_register(mptscsih_io_done, MPTSCSIH_DRIVER);=0A=
 	ScsiTaskCtx =3D mpt_register(mptscsih_taskmgmt_complete, =
MPTSCSIH_DRIVER);=0A=
 	ScsiScanDvCtx =3D mpt_register(mptscsih_scandv_complete, =
MPTSCSIH_DRIVER);=0A=
@@ -1528,6 +1686,9 @@=0A=
 {=0A=
 	mpt_device_driver_deregister(MPTSCSIH_DRIVER);=0A=
 =0A=
+#if defined(MPTSCSIH_ENABLE_FC_TRANSPORT)=0A=
+	fc_release_transport(mptscsih_transport_template);=0A=
+#endif=0A=
 	mpt_reset_deregister(ScsiDoneCtx);=0A=
 	dprintk((KERN_INFO MYNAM=0A=
 	  ": Deregistered for IOC reset notifications\n"));=0A=

------_=_NextPart_000_01C4CE4D.EA7ADA60--
