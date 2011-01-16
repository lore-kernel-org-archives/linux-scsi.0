From: David Dillow <dillowda@ornl.gov>
Subject: scsi: include linux/scatterlist.h to pick up ARCH_HAS_SG_CHAIN
Date: Sun, 16 Jan 2011 15:12:39 -0500
Message-ID: <1295208759.2574.14.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, James.Bottomley@suse.de
List-Id: linux-scsi@vger.kernel.org

If the compiled object doesn't include linux/scatterlist.h before
scsi/scsi.h, it will get an incorrect definition of
SCSI_MAX_SG_CHAIN_SEGMENTS.

Signed-off-by: David Dillow <dillowda@ornl.gov>
--
This fixes an issue I found while working on the SRP initiator, where
linux/scatterlist.h was being pulled in by scsi/scsi_device.h. It's not
clear if I'm supposed to include linux/scatterlist.h myself, or if I'm
including the scsi headers in the wrong order. It makes sense for me
that scsi.h would pickup the needed headers itself to prevent confusion.

Another option is to potentially get rid of the ARCH_HAS_SG_CHAIN define
as all archs have it save m68knommu.


diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 648d233..b76d400 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -9,6 +9,7 @@
 #define _SCSI_SCSI_H
 
 #include <linux/types.h>
+#include <linux/scatterlist.h>
 
 struct scsi_cmnd;
 
