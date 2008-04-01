From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: [PATCH] scsi: ch.c fix sparse shadowed variable warnings
Date: Mon, 31 Mar 2008 22:05:30 -0700
Message-ID: <1207026330.12466.12.camel@brick>
References: <200803282148.m2SLmdA5012246@imap1.linux-foundation.org>
	 <1206897715.4224.55.camel@localhost.localdomain>
	 <1206902620.6543.32.camel@brick>
	 <1206903356.4224.87.camel@localhost.localdomain>
	 <1206903583.6543.38.camel@brick>
	 <1207019451.3192.92.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.185]:22340 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbYDAFF3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Apr 2008 01:05:29 -0400
Received: by rv-out-0910.google.com with SMTP id k20so1122541rvb.1
        for <linux-scsi@vger.kernel.org>; Mon, 31 Mar 2008 22:05:28 -0700 (PDT)
In-Reply-To: <1207019451.3192.92.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org

Replace the global err array with ch_err.
drivers/scsi/ch.c:271:6: warning: symbol 'err' shadows an earlier one
drivers/scsi/ch.c:116:3: originally declared here

Replace the temporary cmd buffer with ch_err to avoid shadowing the cmd
function parameter.
drivers/scsi/ch.c:724:11: warning: symbol 'cmd' shadows an earlier one
drivers/scsi/ch.c:596:20: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
James, incorporated your comments.

 drivers/scsi/ch.c |   33 +++++++++++++++++----------------
 1 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 7aad154..92d1cb1 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -113,7 +113,7 @@ static const struct {
 	unsigned char  asc;
 	unsigned char  ascq;
 	int	       errno;
-} err[] = {
+} ch_err[] = {
 /* Just filled in what looks right. Hav'nt checked any standard paper for
    these errno assignments, so they may be wrong... */
 	{
@@ -155,11 +155,11 @@ static int ch_find_errno(struct scsi_sense_hdr *sshdr)
 	/* Check to see if additional sense information is available */
 	if (scsi_sense_valid(sshdr) &&
 	    sshdr->asc != 0) {
-		for (i = 0; err[i].errno != 0; i++) {
-			if (err[i].sense == sshdr->sense_key &&
-			    err[i].asc   == sshdr->asc &&
-			    err[i].ascq  == sshdr->ascq) {
-				errno = -err[i].errno;
+		for (i = 0; ch_err[i].errno != 0; i++) {
+			if (ch_err[i].sense == sshdr->sense_key &&
+			    ch_err[i].asc   == sshdr->asc &&
+			    ch_err[i].ascq  == sshdr->ascq) {
+				errno = -ch_err[i].errno;
 				break;
 			}
 		}
@@ -721,8 +721,8 @@ static long ch_ioctl(struct file *file,
 	case CHIOGELEM:
 	{
 		struct changer_get_element cge;
-		u_char  cmd[12];
-		u_char  *buffer;
+		u_char ch_cmd[12];
+		u_char *buffer;
 		unsigned int elem;
 		int     result,i;
 
@@ -739,17 +739,18 @@ static long ch_ioctl(struct file *file,
 		mutex_lock(&ch->lock);
 
 	voltag_retry:
-		memset(cmd,0,sizeof(cmd));
-		cmd[0] = READ_ELEMENT_STATUS;
-		cmd[1] = (ch->device->lun << 5) |
+		memset(ch_cmd, 0, sizeof(ch_cmd));
+		ch_cmd[0] = READ_ELEMENT_STATUS;
+		ch_cmd[1] = (ch->device->lun << 5) |
 			(ch->voltags ? 0x10 : 0) |
 			ch_elem_to_typecode(ch,elem);
-		cmd[2] = (elem >> 8) & 0xff;
-		cmd[3] = elem        & 0xff;
-		cmd[5] = 1;
-		cmd[9] = 255;
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
-- 
1.5.5.rc1.135.g8527



