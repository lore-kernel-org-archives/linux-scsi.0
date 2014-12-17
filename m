From: Praveen Madhavan <praveenm@chelsio.com>
Subject: Using common code for csiostor.
Date: Wed, 17 Dec 2014 15:51:44 +0000
Message-ID: <24C222ADD7729F4FB5113B41FF0028A1BC8C12@nice.asicdesigners.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([67.207.112.58]:10783 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaLQPxF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Dec 2014 10:53:05 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi Christoph,
csiostor is chelsio full offload FCoE physical function driver. I would like to reuse common hardware interface functions defined in t4_hw.c of chelsio networking driver(cxgb4). Below is makefile change that creates softlink to t4_hw.c and builds the same. Is this change is acceptable? Please suggest if there is any better way of doing this.

diff --git a/drivers/scsi/csiostor/Makefile b/drivers/scsi/csiostor/Makefile
index 913b9a9..74117f3 100644
--- a/drivers/scsi/csiostor/Makefile
+++ b/drivers/scsi/csiostor/Makefile
@@ -5,8 +5,9 @@

 ccflags-y += -I$(srctree)/drivers/net/ethernet/chelsio/cxgb4

 obj-$(CONFIG_SCSI_CHELSIO_FCOE) := csiostor.o
 csiostor-objs := csio_attr.o csio_init.o csio_lnode.o csio_scsi.o \
                csio_hw.o csio_hw_t4.o csio_hw_t5.o csio_isr.o \
-               csio_mb.o csio_rnode.o csio_wr.o
+               csio_mb.o csio_rnode.o csio_wr.o t4_hw.o
+$(obj)/t4_hw.c:
+       ln -sf $(srctree)/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c $(obj)/t4_hw.c
