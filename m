From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] get rid of ->init in osst
Date: Sun, 3 Nov 2002 21:54:08 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021103215408.A8045@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, osst@riede.org
Cc: linux-scsi@vger.kernel.org

Since osst is the last driver still implementing ->init and Willem said
he's gonna do a major update including a resync with st anyway I think
it's okay to put this hack in for now.  Instead of ->init beeing
directly called from the midlayer osst_attach now calls in in the
beginning - it has an internal protection so that the initialization
will be called only one anyway.


--- 1.22/drivers/scsi/osst.c	Fri Nov  1 07:28:19 2002
+++ edited/drivers/scsi/osst.c	Sun Nov  3 20:08:25 2002
@@ -163,7 +163,6 @@
        tag:		"osst",
        scsi_type:	TYPE_TAPE,
        detect:		osst_detect,
-       init:		osst_init,
        attach:		osst_attach,
        detach:		osst_detach
 };
@@ -5410,6 +5409,8 @@
 
 	if (SDp->type != TYPE_TAPE || !osst_supports(SDp))
 		 return 1;
+
+	osst_init();
 
 	disk = alloc_disk(1);
 	if (!disk)
