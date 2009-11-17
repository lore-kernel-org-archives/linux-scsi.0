From: akpm@linux-foundation.org
Subject: [patch 06/18] drivers/scsi/u14-34f.c: fix uffer overflow
Date: Tue, 17 Nov 2009 14:53:18 -0800
Message-ID: <200911172253.nAHMrIwA019787@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57458 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756658AbZKQWzt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2009 17:55:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, roel.kluin@gmail.com, ballabio_dario@emc.com

From: Roel Kluin <roel.kluin@gmail.com>

This allows i == MAX_INT_PARAM, which is out of range for ints[]

Found with Parfait, http://research.sun.com/projects/parfait/

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Dario Ballabio <ballabio_dario@emc.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/u14-34f.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/u14-34f.c~drivers-scsi-u14-34fc-fix-uffer-overflow drivers/scsi/u14-34f.c
--- a/drivers/scsi/u14-34f.c~drivers-scsi-u14-34fc-fix-uffer-overflow
+++ a/drivers/scsi/u14-34f.c
@@ -1070,7 +1070,7 @@ static int option_setup(char *str) {
    char *cur = str;
    int i = 1;
 
-   while (cur && isdigit(*cur) && i <= MAX_INT_PARAM) {
+   while (cur && isdigit(*cur) && i < MAX_INT_PARAM) {
       ints[i++] = simple_strtoul(cur, NULL, 0);
 
       if ((cur = strchr(cur, ',')) != NULL) cur++;
_
