From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: [PATCH] qla1280: fix section mismatch warnings
Date: Thu, 25 May 2006 10:39:32 -0700
Message-ID: <20060525103932.ca36a587.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:39393 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S1030294AbWEYRg6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 May 2006 13:36:58 -0400
Received: from midway.site ([71.245.102.105]) by xenotime.net for <linux-scsi@vger.kernel.org>; Thu, 25 May 2006 10:36:57 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ismail@pardus.org.tr, scsi <linux-scsi@vger.kernel.org>
Cc: akpm <akpm@osdl.org>, jejb <james.bottomley@steeleye.com>, jes@trained-monkey.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix section mismatch warnings:
WARNING: drivers/scsi/qla1280.o - Section mismatch: reference to
.init.data: from .text between 'qla1280_get_token' (at offset 0x2a16)
and 'qla1280_probe_one'
WARNING: drivers/scsi/qla1280.o - Section mismatch: reference to
.init.data: from .text between 'qla1280_get_token' (at offset 0x2a3c)
and 'qla1280_probe_one'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/scsi/qla1280.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

--- linux-2617-rc5.orig/drivers/scsi/qla1280.c
+++ linux-2617-rc5/drivers/scsi/qla1280.c
@@ -456,7 +456,7 @@ static void qla1280_remove_one(struct pc
  *  QLogic Driver Support Function Prototypes.
  */
 static void qla1280_done(struct scsi_qla_host *);
-static int qla1280_get_token(char *);
+static int qla1280_get_token(char *) __init;
 static int qla1280_setup(char *s) __init;
 
 /*
@@ -4234,7 +4234,7 @@ qla1280_setup(char *s)
 }
 
 
-static int
+static int __init
 qla1280_get_token(char *str)
 {
 	char *sep;


---
