From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] make scsi_ioctl.h useable without including scsi.h
Date: Sun, 17 Nov 2002 16:32:10 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021117163210.A5467@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

*grr* - silly typedefs..


--- 1.1/include/scsi/scsi_ioctl.h	Tue Feb  5 12:39:50 2002
+++ edited/include/scsi/scsi_ioctl.h	Sun Nov 17 14:32:25 2002
@@ -17,6 +17,8 @@
 
 #ifdef __KERNEL__
 
+struct scsi_device;
+
 /*
  * Structures used for scsi_ioctl et al.
  */
@@ -33,19 +35,15 @@
 } Scsi_Idlun;
 
 /* Fibre Channel WWN, port_id struct */
-typedef struct scsi_fctargaddress
-{
+typedef struct scsi_fctargaddress {
 	__u32 host_port_id;
 	unsigned char host_wwn[8]; // include NULL term.
 } Scsi_FCTargAddress;
 
-extern int scsi_ioctl (Scsi_Device *dev, int cmd, void *arg);
-extern int kernel_scsi_ioctl (Scsi_Device *dev, int cmd, void *arg);
-extern int scsi_ioctl_send_command(Scsi_Device *dev,
-				   Scsi_Ioctl_Command *arg);
-
-#endif
-
-#endif
-
+extern int scsi_ioctl(struct scsi_device *, int, void *);
+extern int kernel_scsi_ioctl(struct scsi_device *, int , void *);
+extern int scsi_ioctl_send_command(struct scsi_device *,
+				   struct scsi_ioctl_command *);
 
+#endif /* __KERNEL__ */
+#endif /* _SCSI_IOCTL_H */
