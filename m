From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix sector_div use in scsicam.c
Date: Sun, 27 Oct 2002 17:02:58 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021027170258.A15779@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

sector_div has the same slightly strange calling convention do_div has:
it's return value is the modulo of the two operators, the division
result is in the first parameter.  Also optimize one of the expensive
64bit division away (okay, okay - it's not exactly an fast-path :))


--- 1.11/drivers/scsi/scsicam.c	Fri Oct 25 13:31:53 2002
+++ edited/drivers/scsi/scsicam.c	Sun Oct 27 15:18:13 2002
@@ -80,11 +80,12 @@
 	if (ret || ip[0] > 255 || ip[1] > 63) {
 		ip[0] = 64;
 		ip[1] = 32;
-		if (sector_div(capacity, ip[0] * ip[1]) > 65534) {
+		sector_div(capacity, ip[0] * ip[1]);
+		if (capacity > 65534) {
 			ip[0] = 255;
 			ip[1] = 63;
 		}
-		ip[2] = sector_div(capacity, ip[0] * ip[1]);
+		ip[2] = capacity;
 	}
 
 	return 0;
