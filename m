From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Fix for aic7xxx problems in BK latest
Date: 23 Nov 2003 23:53:20 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1069653204.2066.25.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:16390 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262425AbTKXFxZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2003 00:53:25 -0500
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, Pete Clements <clem@clem.clem-digital.net>, Fabio Coatti <cova@ferrara.linux.it>, Zwane Mwaikambo <zwane@arm.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>

It turns out the scsi_device refcounting and list lockdown altered the
conditions under which scsi_report_bus_reset() works, since it calls
shost_for_each_device, which now takes the host lock, that lock cannot
be held while calling the report functions.  However, the assumption by
aic is that it can.

I fixed the problem by using the no lock version of the iterator.

James

===== drivers/scsi/scsi_error.c 1.65 vs edited =====
--- 1.65/drivers/scsi/scsi_error.c	Sun Sep 21 12:49:36 2003
+++ edited/drivers/scsi/scsi_error.c	Sun Nov 23 23:39:09 2003
@@ -1622,7 +1622,7 @@
 {
 	struct scsi_device *sdev;
 
-	shost_for_each_device(sdev, shost) {
+	__shost_for_each_device(sdev, shost) {
 		if (channel == sdev->channel) {
 			sdev->was_reset = 1;
 			sdev->expecting_cc_ua = 1;
@@ -1656,7 +1656,7 @@
 {
 	struct scsi_device *sdev;
 
-	shost_for_each_device(sdev, shost) {
+	__shost_for_each_device(sdev, shost) {
 		if (channel == sdev->channel &&
 		    target == sdev->id) {
 			sdev->was_reset = 1;

