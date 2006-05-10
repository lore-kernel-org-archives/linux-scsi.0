From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH/RFC] Allowing REQ_FAILFAST to be set from SG_IO
Date: Wed, 10 May 2006 15:51:12 +0200
Message-ID: <4461EFD0.50902@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070805040909000406000407"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:11724 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S964958AbWEJNvS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 May 2006 09:51:18 -0400
Received: from Relay2.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id 13EC7EF19
	for <linux-scsi@vger.kernel.org>; Wed, 10 May 2006 15:51:16 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------070805040909000406000407
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Hi all,

this patch allows to set the REQ_FAILFAST flag to be set from SG_IO
commands. With it one can send generic SCSI commands which behave
exactly like normal requests send via the block layer.

Comments etc welcome.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstraße 5				+49 911 74053 688
90409 Nürnberg				http://www.suse.de

--------------070805040909000406000407
Content-Type: text/plain;
 name="sg-failfast-request"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sg-failfast-request"

Allow FAILFAST flag to be set for SG_IO commands

This patch allows the FAILFAST flag to be set for SG_IO commands.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index b33eda2..658b1b5 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -295,6 +295,8 @@ static int sg_io(struct file *file, requ
 	rq->sense_len = 0;
 
 	rq->flags |= REQ_BLOCK_PC;
+	if (hdr->flags & SG_FLAGS_FAILFAST)
+		rq->flags |= REQ_FAILFAST;
 	bio = rq->bio;
 
 	/*
diff --git a/include/scsi/sg.h b/include/scsi/sg.h
index 0a487fe..9cc466a 100644
--- a/include/scsi/sg.h
+++ b/include/scsi/sg.h
@@ -142,6 +142,7 @@ typedef struct sg_io_hdr
 #define SG_FLAG_UNUSED_LUN_INHIBIT 2   /* default is overwrite lun in SCSI */
 				/* command block (when <= SCSI_2) */
 #define SG_FLAG_MMAP_IO 4       /* request memory mapped IO */
+#define SG_FLAG_FAILFAST 8      /* request should set FAILFAST flag */
 #define SG_FLAG_NO_DXFER 0x10000 /* no transfer of kernel buffers to/from */
 				/* user space (debug indirect IO) */
 

--------------070805040909000406000407--
