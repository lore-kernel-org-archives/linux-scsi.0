From: Mark Lord <lkml@rtr.ca>
Subject: [PATCH] Fix incorrect pointer in megaraid.c MODE_SENSE emulation
Date: Wed, 07 Dec 2005 17:46:57 -0500
Message-ID: <43976661.1030004@rtr.ca>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000708050106030802060008"
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750861AbVLGWq7@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------000708050106030802060008
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

The SCSI megaraid drive goes to great effort to kmap
the scatterlist buffer (if used), but then uses the
wrong pointer when copying to it afterward.

Signed-off-by:  Mark Lord <lkml@rtr.ca>

--------------000708050106030802060008
Content-Type: text/x-patch;
 name="megaraid.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="megaraid.patch"

--- linux-2.6.15-rc5/drivers/scsi/megaraid.c.orig	2005-12-04 00:10:42.000000000 -0500
+++ linux/drivers/scsi/megaraid.c	2005-12-07 17:41:30.000000000 -0500
@@ -664,7 +664,7 @@
 					sg->offset;
 			} else
 				buf = cmd->request_buffer;
-			memset(cmd->request_buffer, 0, cmd->cmnd[4]);
+			memset(buf, 0, cmd->cmnd[4]);
 			if (cmd->use_sg) {
 				struct scatterlist *sg;
 

--------------000708050106030802060008--
