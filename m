From: Ilya Yanok <ilya.yanok@gmail.com>
Subject: MPT Fusion SAS dma alignment problem
Date: Wed, 28 May 2008 12:14:34 +0400
Message-ID: <483D146A.10301@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:51794 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbYE1IOk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 May 2008 04:14:40 -0400
Received: by ug-out-1314.google.com with SMTP id h2so66706ugf.16
        for <linux-scsi@vger.kernel.org>; Wed, 28 May 2008 01:14:39 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com

Hello, All.

We've experienced problem with MPT Fusion SAS driver: running smartctl
program from smartmontools package resulted in memory corruption after
ioctl(SG_IO) call. My investigation showed that problem was introduced by

Commit: 465ff3185e0cb76d46137335a4d21d0d9d3ac8a2
Author: James Bottomley <James.Bottomley@HansenPartnership.com> Tue, 01
Jan 2008

    [SCSI] relax scsi dma alignment

    This patch relaxes the default SCSI DMA alignment from 512 bytes to 4
    bytes.  I remember from previous discussions that usb and firewire have
    sector size alignment requirements, so I upped their alignments in the
    respective slave allocs.

    The reason for doing this is so that we don't get such a huge amount of
    copy overhead in bio_copy_user() for udev.  (basically all inquiries it
    issues can now be directly mapped).

    Acked-by: Alan Stern <stern@rowland.harvard.edu>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

so I've just added call to blk_queue_update_dma_alignment() (see patch
below) but I'm not sure that it'a right (or full) solution. Maybe
someone more familiar with this driver can comment?

--
Ilya

---
 drivers/message/fusion/mptsas.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/message/fusion/mptsas.c
b/drivers/message/fusion/mptsas.c
index 4684807..bbb6186 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1000,6 +1000,7 @@ mptsas_slave_alloc(struct scsi_device *sdev)
     return -ENXIO;
 
  out:
+    blk_queue_update_dma_alignment(sdev->request_queue, 511);
     vdevice->vtarget->num_luns++;
     sdev->hostdata = vdevice;
     return 0;
-- 
1.5.5.1

