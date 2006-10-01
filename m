From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH] scsi: device_reprobe() can fail
Date: Sat, 30 Sep 2006 21:23:44 -0400
Message-ID: <20061001012344.GA24609@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751887AbWJABXr@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


[This has been sitting in James Bottomley's scsi-misc for five days.
 With SCSI outputting a warning for almost -every- file, let's go ahead
 and get the patch in.]

From: Andrew Morton <akpm@osdl.org>

device_reprobe() should return an error code.  When it does so,
scsi_device_reprobe() should propagate it back.

Acked-by: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

---

 include/scsi/scsi_device.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

8350a348e97c2f8aa3e91c025c0e040c90146414
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 895d212..b401c82 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -298,9 +298,9 @@ extern int scsi_execute_async(struct scs
 			      void (*done)(void *, char *, int, int),
 			      gfp_t gfp);
 
-static inline void scsi_device_reprobe(struct scsi_device *sdev)
+static inline int __must_check scsi_device_reprobe(struct scsi_device *sdev)
 {
-	device_reprobe(&sdev->sdev_gendev);
+	return device_reprobe(&sdev->sdev_gendev);
 }
 
 static inline unsigned int sdev_channel(struct scsi_device *sdev)
