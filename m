From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH] Set max_sectors for tmscsim
Date: Mon, 2 Oct 2006 00:54:25 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0610020028230.4088@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:50334 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S932453AbWJAWyX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Oct 2006 18:54:23 -0400
Received: from lyakh (helo=localhost)
	by poirot.grange with local-esmtp (Exim 3.36 #1 (Debian))
	id 1GUACX-0005DL-00
	for <linux-scsi@vger.kernel.org>; Mon, 02 Oct 2006 00:54:25 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi

The patch below depends on the previous one "enable clustering". I hope my 
calculations are correct, and 0x8000 is the correct value for tmscsim. 
Please, correct me if I am wrong. 16MiB are configured by setting all 24 
bits to 0. Don't know if this works though.

Thanks
Guennadi
---
Guennadi Liakhovetski

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

AM53C974A's Start Transfer Counter register has 24 bits, thus
maximum transfer length is 16MiB.

diff -u a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
--- a/drivers/scsi/tmscsim.c	2006-10-02 00:21:56.000000000 +0200
+++ b/drivers/scsi/tmscsim.c	2006-10-02 00:21:46.000000000 +0200
@@ -2304,6 +2304,7 @@
 	.sg_tablesize		= SG_ALL,
 	.cmd_per_lun		= 1,
 	.use_clustering		= ENABLE_CLUSTERING,
+	.max_sectors		= 0x8000, /* 16MiB = 32 * 1024 * 512 */
 };
 
 /***********************************************************************
