From: Sergey Vlasov <vsu@altlinux.ru>
Subject: Re: Atto UL5D: negotiates only up to FAST-40 SCSI
Date: Fri, 17 Nov 2006 22:35:06 +0300
Message-ID: <20061117223506.4ec56d04.vsu@altlinux.ru>
References: <xfku00y8gjn.fsf@uxrs53.drewag.de>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__17_Nov_2006_22_35_06_+0300_ZzLTIHJ.JlbGE1kI"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from master.altlinux.org ([62.118.250.235]:55314 "EHLO
	master.altlinux.org") by vger.kernel.org with ESMTP
	id S1752892AbWKQTfq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Nov 2006 14:35:46 -0500
In-Reply-To: <xfku00y8gjn.fsf@uxrs53.drewag.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sven Rudolph <Sven_Rudolph@drewag.de>
Cc: linux-scsi@vger.kernel.org

--Signature=_Fri__17_Nov_2006_22_35_06_+0300_ZzLTIHJ.JlbGE1kI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

On Fri, 17 Nov 2006 12:21:32 +0100 Sven Rudolph wrote:

> I try to use an Atto Dual-Channel Low-Profile PCIExpress SCSI HBA
> (<http://www.attotech.com/ultra5Dlowpro.html>) with Linux (2.6.18.1,
> 2.6.19rc6).
>
> (Atto provides a Linux driver on CD, but I prefer to use drivers
> included in the vanilla Linux kernel. It looks like their driver does
> not include all source code; but I might be wrong on this.)

They also provide a patch for the mptspi driver (apparently made for
2.6.14):

http://www.attotech.com/software/secure/lnx_drv_epciu320_2.6.14-15.patch

This patch still applies to 2.6.18 with some fuzz, resulting in the
following changes:

diff --git a/drivers/message/fusion/lsi/mpi_cnfg.h b/drivers/message/fusion/lsi/mpi_cnfg.h
index 47e13e3..6cb9c21 100644
--- a/drivers/message/fusion/lsi/mpi_cnfg.h
+++ b/drivers/message/fusion/lsi/mpi_cnfg.h
@@ -1440,6 +1440,30 @@ typedef struct _CONFIG_PAGE_SCSI_PORT_2
 } CONFIG_PAGE_SCSI_PORT_2, MPI_POINTER PTR_CONFIG_PAGE_SCSI_PORT_2,
   SCSIPortPage2_t, MPI_POINTER pSCSIPortPage2_t;

+typedef struct _ATTO_DEVICE_INFO
+{
+  U8      Offset;                                     /* 00h */
+  U8      Period;                                     /* 01h */
+  U16     ATTOFlags;                                  /* 02h */
+} ATTO_DEVICE_INFO, MPI_POINTER PTR_ATTO_DEVICE_INFO,
+  ATTODeviceInfo_t, MPI_POINTER pATTODeviceInfo_t;
+
+#define ATTOFLAG_DISC     0x0001
+#define ATTOFLAG_TAGGED   0x0002
+#define ATTOFLAG_WIDE_ENB 0x0008
+#define ATTOFLAG_ID_ENB   0x0010
+#define ATTOFLAG_LUN_ENB  0x0060
+
+typedef struct _ATTO_CONFIG_PAGE_SCSI_PORT_2
+{
+  CONFIG_PAGE_HEADER  Header;                         /* 00h */
+  U16                 PortFlags;                      /* 04h */
+  U16                 Unused1;                        /* 06h */
+  U32                 Unused2;                        /* 08h */
+  ATTO_DEVICE_INFO    DeviceSettings[16];             /* 0Ch */
+} fATTO_CONFIG_PAGE_SCSI_PORT_2, MPI_POINTER PTR_ATTO_CONFIG_PAGE_SCSI_PORT_2,
+  ATTO_SCSIPortPage2_t, MPI_POINTER pATTO_SCSIPortPage2_t;
+
 #define MPI_SCSIPORTPAGE2_PAGEVERSION                       (0x02)

 /* PortFlags values */
diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 29d0635..6b47fb0 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1357,6 +1357,7 @@ mpt_attach(struct pci_dev *pdev, const s
 		pci_disable_io_access(pdev);

 	sprintf(ioc->name, "ioc%d", ioc->id);
+	ioc->is_ATTO = (pdev->vendor == 0x117c);

 	spin_lock_init(&ioc->FreeQlock);

@@ -4607,6 +4608,37 @@ mpt_GetScsiPortSettings(MPT_ADAPTER *ioc
 				/* Nvram data is left with INVALID mark
 				 */
 				rc = 1;
+			} else if (ioc->is_ATTO) {
+			  /* This is an ATTO adapter, read Page2 accordingly
+			   */
+			  ATTO_SCSIPortPage2_t *pPP2 = (ATTO_SCSIPortPage2_t  *) pbuf;
+			  ATTODeviceInfo_t *pdevice = NULL;
+			  U16 ATTOFlags;
+
+			  /* Save the Port Page 2 data
+			   * (reformat into a 32bit quantity)
+			   */
+			  for (ii=0; ii < MPT_MAX_SCSI_DEVICES; ii++) {
+			    pdevice = &pPP2->DeviceSettings[ii];
+			    ATTOFlags = le16_to_cpu(pdevice->ATTOFlags);
+			    data = 0;
+
+			    /* Translate ATTO device flags to LSI format
+			     */
+			    if (ATTOFlags & ATTOFLAG_DISC)
+			      data |= (MPI_SCSIPORTPAGE2_DEVICE_DISCONNECT_ENABLE);
+			    if (ATTOFlags & ATTOFLAG_ID_ENB)
+			      data |= (MPI_SCSIPORTPAGE2_DEVICE_ID_SCAN_ENABLE);
+			    if (ATTOFlags & ATTOFLAG_LUN_ENB)
+			      data |= (MPI_SCSIPORTPAGE2_DEVICE_LUN_SCAN_ENABLE);
+			    if (ATTOFlags & ATTOFLAG_TAGGED)
+			      data |= (MPI_SCSIPORTPAGE2_DEVICE_TAG_QUEUE_ENABLE);
+			    if (!(ATTOFlags & ATTOFLAG_WIDE_ENB))
+			      data |= (MPI_SCSIPORTPAGE2_DEVICE_WIDE_DISABLE);
+
+			    data = (data << 16) | (pdevice->Period << 8) | 10;
+			    ioc->spi_data.nvram[ii] = data;
+			  }
 			} else {
 				SCSIPortPage2_t *pPP2 = (SCSIPortPage2_t  *) pbuf;
 				MpiDeviceInfo_t	*pdevice = NULL;
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index c537d71..dcf911a 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -601,6 +601,7 @@ typedef struct _MPT_ADAPTER
 	u16			 hs_reply[MPT_MAX_FRAME_SIZE/sizeof(u16)];
 	IOCFactsReply_t		 facts;
 	PortFactsReply_t	 pfacts[2];
+        int                      is_ATTO;
 	FCPortPage0_t		 fc_port_page0[2];
 	struct timer_list	 persist_timer;	/* persist table timer */
 	int			 persist_wait_done; /* persist completion flag */
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index e4cc3dd..3dc6193 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -775,6 +775,7 @@ static struct pci_device_id mptspi_pci_t
 		PCI_ANY_ID, PCI_ANY_ID },
 	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVID_53C1035,
 		PCI_ANY_ID, PCI_ANY_ID },
+	{ 0x117c, 0x0030, PCI_ANY_ID, PCI_ANY_ID }, /* ATTO UL4D */
 	{0}	/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(pci, mptspi_pci_table);


Apparently ATTO devices have a completely different NVRAM format -
maybe this causes the problem when a driver with just a PCI ID added
tries to interpret NVRAM data using the LSI format?

--Signature=_Fri__17_Nov_2006_22_35_06_+0300_ZzLTIHJ.JlbGE1kI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFFXg7tW82GfkQfsqIRAucPAJsGhU8eJXbWIx2eg0IcT5hHIOoPogCdES5O
f2aghp7illvcakfw6JEWmIU=
=6x8P
-----END PGP SIGNATURE-----

--Signature=_Fri__17_Nov_2006_22_35_06_+0300_ZzLTIHJ.JlbGE1kI--
