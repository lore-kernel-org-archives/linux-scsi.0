From: Petr Vandrovec <petr@vmware.com>
Subject: Re: [PATCH 2/5] fusion: vmware bug fix prevent inifinite retries
Date: Tue, 09 Jan 2007 12:55:43 -0800
Message-ID: <45A4014F.7070203@vmware.com>
References: <65B5F504434AD3469DC12E5564E3794D01EAB81D@PA-EXCH02.vmware.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050103080401010600010506"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout1.vmware.com ([65.113.40.130]:34876 "EHLO
	mailout1.vmware.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932433AbXAIU4F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jan 2007 15:56:05 -0500
In-Reply-To: <65B5F504434AD3469DC12E5564E3794D01EAB81D@PA-EXCH02.vmware.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adam Zimman <azimman@vmware.com>
Cc: Manon Goo <manon@manon.de>, Michael Reed <mdr@sgi.com>, "Moore, Eric" <Eric.Moore@lsi.com>, David Berghoff <david@dg-i.net>, Vicky Xu <vgxu@vmware.com>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, "Shirron, Stephen" <Stephen.Shirron@lsi.com>

This is a multi-part message in MIME format.
--------------050103080401010600010506
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Adam Zimman wrote:
> Adding VMware engineering... 
> 
> -----Original Message-----
> From: Manon Goo [mailto:manon@manon.de] 
> Sent: Tuesday, January 09, 2007 9:49 AM
> To: Michael Reed; Moore, Eric; David Berghoff
> Cc: James Bottomley; Adam Zimman; linux-scsi@vger.kernel.org; Shirron, Stephen
> Subject: Re: [PATCH 2/5] fusion: vmware bug fix prevent inifinite retries
> 
> Hmm .... why don't w make the whole thing configurable (david implemented this for us)

In that case I would prefer going on with automatic detection of our 
implementation - see first part of attached mpt-patch.diff I offered 
when this all started.  As passing options to modules loaded by initrd 
is not exactly trivial and varies across distributions, I would prefer 
this runtime detection...
				Thanks,
					Petr Vandrovec

> 
> +/*
> + *  cmd line parameters
> + */
> +static int mpt_mpi_busy;
> +module_param(mpt_mpi_busy, int, 0);
> +MODULE_PARM_DESC(mpt_mpi_busy, " MPT MPI busy workaround for VMWare ESX 
> (default=0)");
> +
>  /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
> 
>  typedef struct _BIG_SENSE_BUF {
> @@ -704,10 +711,13 @@
>                         sc->resid=0;
>                 case MPI_IOCSTATUS_SCSI_RECOVERED_ERROR:        /* 0x0040 */
>                 case MPI_IOCSTATUS_SUCCESS:                     /* 0x0000 */
> -                       if (scsi_status == MPI_SCSI_STATUS_BUSY)
> +                       if ((scsi_status == MPI_SCSI_STATUS_BUSY) && 
> !mpt_mpi_busy)
>                                 sc->result = (DID_BUS_BUSY << 16) | 
> scsi_status;
> -                       else
> +                       else {
> +                                if (mpt_mpi_busy)
> +                                        printk(KERN_INFO "MPT MPI ESX busy 
> hack enabled ... waiting\n");
>                                 sc->result = (DID_OK << 16) | scsi_status;
> +                        }
>                         if (scsi_state == 0) {
>                                 ;
>                         } else if (scsi_state & 
> MPI_SCSI_STATE_AUTOSENSE_VALID) {

--------------050103080401010600010506
Content-Type: text/plain;
 name="mpt-patch.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mpt-patch.diff"

Patch to fix timeouts during multi-path failover with LSILogic adapter on RedHat 4.0 Update 3 & 4.
Patch is needed for other distributions as well - for example current Linus's 2.6.19 kernel needs it.


diff -urN linux-2.6.9.orig/drivers/message/fusion/mptbase.c linux-2.6.9/drivers/message/fusion/mptbase.c
--- linux-2.6.9.orig/drivers/message/fusion/mptbase.c	2006-12-15 11:13:47.000000000 -0800
+++ linux-2.6.9/drivers/message/fusion/mptbase.c	2006-12-15 11:43:01.000000000 -0800
@@ -1435,12 +1435,21 @@
 		ioc->bus_type = SPI;
 		/* 1030 Chip Fix. Disable Split transactions
 		 * for PCIX. Set MOST bits to zero if Rev < C0( = 8).
+		 *
+		 * Also detect VMware's LSILogic emulation - it does
+		 * not have PCI-X capability at offset 0x68 (and does
+		 * not need disabling split transactions although it
+		 * reports itself as revision 1).
 		 */
 		pci_read_config_byte(pdev, PCI_CLASS_REVISION, &revision);
 		if (revision < C0_1030) {
-			pci_read_config_byte(pdev, 0x6a, &pcixcmd);
-			pcixcmd &= 0x8F;
-			pci_write_config_byte(pdev, 0x6a, pcixcmd);
+			if (pci_find_capability(pdev, PCI_CAP_ID_PCIX) == 0x68) {
+				pci_read_config_byte(pdev, 0x6a, &pcixcmd);
+				pcixcmd &= 0x8F;
+				pci_write_config_byte(pdev, 0x6a, pcixcmd);
+			} else {
+				ioc->isVMware = 1;
+			}
 		}
 	}
 	else if (pdev->device == MPI_MANUFACTPAGE_DEVID_1030_53C1035) {
diff -urN linux-2.6.9.orig/drivers/message/fusion/mptbase.h linux-2.6.9/drivers/message/fusion/mptbase.h
--- linux-2.6.9.orig/drivers/message/fusion/mptbase.h	2006-12-15 11:13:47.000000000 -0800
+++ linux-2.6.9/drivers/message/fusion/mptbase.h	2006-12-15 11:40:47.000000000 -0800
@@ -673,7 +673,8 @@
 	u8			 upload_fw;	/* If set, do a fw upload */
 	u8			 reload_fw;	/* Force a FW Reload on next reset */
 	u8			 NBShiftFactor;  /* NB Shift Factor based on Block Size (Facts)  */
-	u8			 pad1[4];
+	u8			 isVMware;
+	u8			 pad1[3];
 	int			 DoneCtx;
 	int			 TaskCtx;
 	int			 InternalCtx;
diff -urN linux-2.6.9.orig/drivers/message/fusion/mptscsi.c linux-2.6.9/drivers/message/fusion/mptscsi.c
--- linux-2.6.9.orig/drivers/message/fusion/mptscsi.c	2006-12-15 11:13:47.000000000 -0800
+++ linux-2.6.9/drivers/message/fusion/mptscsi.c	2006-12-15 11:49:18.000000000 -0800
@@ -773,7 +773,12 @@
 			sc->resid=0;
 		case MPI_IOCSTATUS_SCSI_RECOVERED_ERROR:	/* 0x0040 */
 		case MPI_IOCSTATUS_SUCCESS:			/* 0x0000 */
-			if (scsi_status == MPI_SCSI_STATUS_BUSY)
+			/*
+			 * In the case of emulated adapter busy status may be reported 
+			 * for minutes when storage path switch occurs in the firmware.
+			 * We definitely do not want to give up after standard timeout.
+			 */
+			if (scsi_status == MPI_SCSI_STATUS_BUSY && !ioc->isVMware)
 				sc->result = (DID_BUS_BUSY << 16) | scsi_status;
 			else
 				sc->result = (DID_OK << 16) | scsi_status;
@@ -810,6 +815,7 @@
 				 * Not real sure here either so do nothing...  */
 			}
 
+			/* Perhaps this wanted to test scsi_status and not sc->result? */
 			if (sc->result == MPI_SCSI_STATUS_TASK_SET_FULL)
 				mptscsih_report_queue_full(sc, pScsiReply, pScsiReq);
 

--------------050103080401010600010506--
