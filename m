From: akpm@osdl.org
Subject: [patch 21/28] drivers/scsi/gdth.c: make __gdth_execute() static
Date: Wed, 08 Mar 2006 00:14:37 -0800
Message-ID: <200603080816.k288GRkY002225@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:22189 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932511AbWCHITl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2006 03:19:41 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, bunk@stusta.de


From: Adrian Bunk <bunk@stusta.de>

I don't see any reason for __gdth_execute() being global.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/gdth.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/gdth.c~drivers-scsi-gdthc-make-__gdth_execute-static drivers/scsi/gdth.c
--- devel/drivers/scsi/gdth.c~drivers-scsi-gdthc-make-__gdth_execute-static	2006-03-08 00:13:05.000000000 -0800
+++ devel-akpm/drivers/scsi/gdth.c	2006-03-08 00:13:05.000000000 -0800
@@ -692,8 +692,8 @@ static void gdth_scsi_done(struct scsi_c
 		complete(scp->request->waiting);
 }
 
-int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
-		 int timeout, u32 *info)
+static int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd,
+			  char *cmnd, int timeout, u32 *info)
 {
 	struct scsi_request *scp = scsi_allocate_request(sdev, GFP_KERNEL);
 	unsigned bufflen = gdtcmd ? sizeof(gdth_cmd_str) : 0;
@@ -726,8 +726,8 @@ static void gdth_scsi_done(Scsi_Cmnd *sc
 		complete(scp->request.waiting);
 }
 
-int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
-		 int timeout, u32 *info)
+static int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd,
+			  char *cmnd, int timeout, u32 *info)
 {
 	Scsi_Cmnd *scp = scsi_allocate_device(sdev, 1, FALSE);
 	unsigned bufflen = gdtcmd ? sizeof(gdth_cmd_str) : 0;
_
