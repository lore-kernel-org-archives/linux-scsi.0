From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] scsi: fix overlapping snprintf users
Date: Tue, 09 Jun 2009 13:44:02 +0100
Message-ID: <20090609124357.9957.95174.stgit@t61.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49753 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755123AbZFILsZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2009 07:48:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Closes-bug: http://bugzilla.kernel.org/show_bug.cgi?id=13438
Closes-bug: http://bugzilla.kernel.org/show_bug.cgi?id=13437
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/scsi/gdth_proc.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)


diff --git a/drivers/scsi/gdth_proc.c b/drivers/scsi/gdth_proc.c
index 59349a3..1258da3 100644
--- a/drivers/scsi/gdth_proc.c
+++ b/drivers/scsi/gdth_proc.c
@@ -152,6 +152,7 @@ static int gdth_get_info(char *buffer,char **start,off_t offset,int length,
                          struct Scsi_Host *host, gdth_ha_str *ha)
 {
     int size = 0,len = 0;
+    int hlen;
     off_t begin = 0,pos = 0;
     int id, i, j, k, sec, flag;
     int no_mdrv = 0, drv_no, is_mirr;
@@ -192,11 +193,11 @@ static int gdth_get_info(char *buffer,char **start,off_t offset,int length,
     if (reserve_list[0] == 0xff)
         strcpy(hrec, "--");
     else {
-        sprintf(hrec, "%d", reserve_list[0]);
+        hlen = sprintf(hrec, "%d", reserve_list[0]);
         for (i = 1;  i < MAX_RES_ARGS; i++) {
             if (reserve_list[i] == 0xff) 
                 break;
-            sprintf(hrec,"%s,%d", hrec, reserve_list[i]);
+            hlen += snprintf(hrec + hlen , 161 - hlen, ",%d", reserve_list[i]);
         }
     }
     size = sprintf(buffer+len,

