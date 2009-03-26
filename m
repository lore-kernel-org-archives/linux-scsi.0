From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] cumana: Fix a long standing bogon
Date: Thu, 26 Mar 2009 20:53:49 +0000
Message-ID: <20090326205344.5379.38993.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34959 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752505AbZCZUwt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Mar 2009 16:52:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Should be using strncmp as the data from user space may be unterminated

(Bug #8004)

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk
---

 drivers/scsi/arm/cumana_2.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/scsi/arm/cumana_2.c b/drivers/scsi/arm/cumana_2.c
index 68a6412..ed502b7 100644
--- a/drivers/scsi/arm/cumana_2.c
+++ b/drivers/scsi/arm/cumana_2.c
@@ -318,7 +318,7 @@ cumanascsi_2_set_proc_info(struct Scsi_Host *host, char *buffer, int length)
 {
 	int ret = length;
 
-	if (length >= 11 && strcmp(buffer, "CUMANASCSI2") == 0) {
+	if (length >= 11 && strncmp(buffer, "CUMANASCSI2", 11) == 0) {
 		buffer += 11;
 		length -= 11;
 

