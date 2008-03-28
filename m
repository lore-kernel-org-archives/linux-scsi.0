From: akpm@linux-foundation.org
Subject: [patch 11/17] scsi: ch.c fix shadowed variable warnings
Date: Fri, 28 Mar 2008 14:48:39 -0700
Message-ID: <200803282148.m2SLmdA5012246@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52580 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756611AbYC1VtO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Mar 2008 17:49:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, harvey.harrison@gmail.com

From: Harvey Harrison <harvey.harrison@gmail.com>

err shadows the array of errors in this driver, switch to ch_err
drivers/scsi/ch.c:271:6: warning: symbol 'err' shadows an earlier one
drivers/scsi/ch.c:116:3: originally declared here

cmd shadows the argument to this function, switch to ch_cmd
drivers/scsi/ch.c:724:11: warning: symbol 'cmd' shadows an earlier one
drivers/scsi/ch.c:596:20: originally declared here

Small code cleanup as well in if() statement.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ch.c |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff -puN drivers/scsi/ch.c~scsi-chc-fix-shadowed-variable-warnings drivers/scsi/ch.c
--- a/drivers/scsi/ch.c~scsi-chc-fix-shadowed-variable-warnings
+++ a/drivers/scsi/ch.c
@@ -268,16 +268,16 @@ ch_read_element_status(scsi_changer *ch,
 static int
 ch_init_elem(scsi_changer *ch)
 {
-	int err;
+	int ch_err;
 	u_char cmd[6];
 
 	vprintk("INITIALIZE ELEMENT STATUS, may take some time ...\n");
 	memset(cmd,0,sizeof(cmd));
 	cmd[0] = INITIALIZE_ELEMENT_STATUS;
 	cmd[1] = ch->device->lun << 5;
-	err = ch_do_scsi(ch, cmd, NULL, 0, DMA_NONE);
+	ch_err = ch_do_scsi(ch, cmd, NULL, 0, DMA_NONE);
 	vprintk("... finished\n");
-	return err;
+	return ch_err;
 }
 
 static int
@@ -721,7 +721,7 @@ static long ch_ioctl(struct file *file,
 	case CHIOGELEM:
 	{
 		struct changer_get_element cge;
-		u_char  cmd[12];
+		u_char  ch_cmd[12];
 		u_char  *buffer;
 		unsigned int elem;
 		int     result,i;
@@ -739,17 +739,18 @@ static long ch_ioctl(struct file *file,
 		mutex_lock(&ch->lock);
 
 	voltag_retry:
-		memset(cmd,0,sizeof(cmd));
-		cmd[0] = READ_ELEMENT_STATUS;
-		cmd[1] = (ch->device->lun << 5) |
-			(ch->voltags ? 0x10 : 0) |
-			ch_elem_to_typecode(ch,elem);
-		cmd[2] = (elem >> 8) & 0xff;
-		cmd[3] = elem        & 0xff;
-		cmd[5] = 1;
-		cmd[9] = 255;
+		memset(ch_cmd, 0, sizeof(ch_cmd));
+		ch_cmd[0] = READ_ELEMENT_STATUS;
+		ch_cmd[1] = (ch->device->lun << 5) |
+			    (ch->voltags ? 0x10 : 0) |
+			    ch_elem_to_typecode(ch, elem);
+		ch_cmd[2] = (elem >> 8) & 0xff;
+		ch_cmd[3] = elem        & 0xff;
+		ch_cmd[5] = 1;
+		ch_cmd[9] = 255;
 
-		if (0 == (result = ch_do_scsi(ch, cmd, buffer, 256, DMA_FROM_DEVICE))) {
+		result = ch_do_scsi(ch, ch_cmd, buffer, 256, DMA_FROM_DEVICE);
+		if (!result) {
 			cge.cge_status = buffer[18];
 			cge.cge_flags = 0;
 			if (buffer[18] & CESTATUS_EXCEPT) {
_
