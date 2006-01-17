From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/8] fusion - spi bus reset when driver loads
Date: Tue, 17 Jan 2006 13:42:29 +0000
Message-ID: <20060117134229.GA9152@infradead.org>
References: <F331B95B72AFFB4B87467BE1C8E9CF5F1AAC7D@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:4808 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932479AbWAQNmf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jan 2006 08:42:35 -0500
Content-Disposition: inline
In-Reply-To: <F331B95B72AFFB4B87467BE1C8E9CF5F1AAC7D@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org

On Mon, Jan 16, 2006 at 06:53:06PM -0700, Moore, Eric wrote:
> This patch is for spi.  This issues bus reset when driver
> loads. Handling cases when initator has negotiated for packetized,
> and target negotiated for non-packetized; effectly this bus reset
> is getting both target and initiator on the same sheet of music.

looks good.  but we don't need the prototype for mptscsih_TMHandler in
mptscsih.c (and didn't need it before).  Here's a patch with that one
hunk updated.



diff -uarN b/drivers/message/fusion/mptbase.c a/drivers/message/fusion/mptbase.c
--- b/drivers/message/fusion/mptbase.c	2006-01-16 14:21:36.000000000 -0700
+++ a/drivers/message/fusion/mptbase.c	2006-01-16 17:57:31.083900328 -0700
@@ -4598,6 +4598,14 @@
 				SCSIPortPage2_t *pPP2 = (SCSIPortPage2_t  *) pbuf;
 				MpiDeviceInfo_t	*pdevice = NULL;
 
+				/*
+				 * Save "Set to Avoid SCSI Bus Resets" flag
+				 */
+				ioc->spi_data.bus_reset =
+				    (le32_to_cpu(pPP2->PortFlags) &
+			        MPI_SCSIPORTPAGE2_PORT_FLAGS_AVOID_SCSI_RESET) ?
+				    0 : 1 ;
+
 				/* Save the Port Page 2 data
 				 * (reformat into a 32bit quantity)
 				 */
diff -uarN b/drivers/message/fusion/mptscsih.c a/drivers/message/fusion/mptscsih.c
--- b/drivers/message/fusion/mptscsih.c	2006-01-16 14:21:36.000000000 -0700
+++ a/drivers/message/fusion/mptscsih.c	2006-01-16 17:59:03.665825736 -0700
@@ -144,7 +144,8 @@
 static int	mptscsih_tm_wait_for_completion(MPT_SCSI_HOST * hd, ulong timeout );
 static u32	SCPNT_TO_LOOKUP_IDX(struct scsi_cmnd *sc);
 
-static int	mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 target, u8 lun, int ctx2abort, ulong timeout);
+int		mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8 type, u8 channel,
+    u8 target, u8 lun, int ctx2abort, ulong timeout);
 static int	mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 target, u8 lun, int ctx2abort, ulong timeout);
 
 int		mptscsih_ioc_reset(MPT_ADAPTER *ioc, int post_reset);
@@ -1530,7 +1531,7 @@
  *
  *	Returns 0 for SUCCESS or -1 if FAILED.
  */
-static int
+int
 mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 target, u8 lun, int ctx2abort, ulong timeout)
 {
 	MPT_ADAPTER	*ioc;
@@ -5620,5 +5621,5 @@
 EXPORT_SYMBOL(mptscsih_ioc_reset);
 EXPORT_SYMBOL(mptscsih_change_queue_depth);
 EXPORT_SYMBOL(mptscsih_timer_expired);
-
+EXPORT_SYMBOL(mptscsih_TMHandler);
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
diff -uarN b/drivers/message/fusion/mptscsih.h a/drivers/message/fusion/mptscsih.h
--- b/drivers/message/fusion/mptscsih.h	2006-01-16 14:21:36.000000000 -0700
+++ a/drivers/message/fusion/mptscsih.h	2006-01-16 17:59:21.522111168 -0700
@@ -106,5 +106,7 @@
 extern int mptscsih_scandv_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *r);
 extern int mptscsih_event_process(MPT_ADAPTER *ioc, EventNotificationReply_t *pEvReply);
 extern int mptscsih_ioc_reset(MPT_ADAPTER *ioc, int post_reset);
+extern int mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8 type, u8 channel,
+    u8 target, u8 lun, int ctx2abort, ulong timeout);
 extern int mptscsih_change_queue_depth(struct scsi_device *sdev, int qdepth);
 extern void mptscsih_timer_expired(unsigned long data);
diff -uarN b/drivers/message/fusion/mptspi.c a/drivers/message/fusion/mptspi.c
--- b/drivers/message/fusion/mptspi.c	2006-01-16 14:21:36.000000000 -0700
+++ a/drivers/message/fusion/mptspi.c	2006-01-16 18:03:31.392125152 -0700
@@ -384,6 +384,14 @@
 		goto out_mptspi_probe;
 	}
 
+	/*
+	 * issue internal bus reset
+	 */
+	if (ioc->spi_data.bus_reset)
+		mptscsih_TMHandler(hd,
+		    MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS,
+		    0, 0, 0, 0, 5);
+
 	scsi_scan_host(sh);
 	return 0;
 
@@ -445,7 +453,7 @@
 mptspi_exit(void)
 {
 	pci_unregister_driver(&mptspi_driver);
-	
+
 	mpt_reset_deregister(mptspiDoneCtx);
 	dprintk((KERN_INFO MYNAM
 	  ": Deregistered for IOC reset notifications\n"));
