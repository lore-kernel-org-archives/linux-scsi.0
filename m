From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] SCSI: Fix potential out-of-bounds access in drivers/scsi/sd.c
Date: Fri, 6 Sep 2013 11:49:51 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1309061054390.1165-100000@iolanthe.rowland.org>
References: <52288938.30102@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:33161 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755652Ab3IFPtw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Sep 2013 11:49:52 -0400
In-Reply-To: <52288938.30102@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, Dmitry Vyukov <dvyukov@google.com>, richard@r-senior.demon.co.uk, ltuikov@yahoo.com, Andrey Konovalov <andreyknvl@google.com>, Kostya Serebryany <kcc@google.com>

This patch fixes an out-of-bounds error in sd_read_cache_type(), found
by Google's AddressSanitizer tool.  When the loop ends, we know that
"offset" lies beyond the end of the data in the buffer, so no Caching
mode page was found.  In theory it may be present, but the buffer size
is limited to 512 bytes.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Dmitry Vyukov <dvyukov@google.com>
CC: <stable@vger.kernel.org>

---


[as1709]


 drivers/scsi/sd.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

Index: usb-3.11/drivers/scsi/sd.c
===================================================================
--- usb-3.11.orig/drivers/scsi/sd.c
+++ usb-3.11/drivers/scsi/sd.c
@@ -2419,14 +2419,9 @@ sd_read_cache_type(struct scsi_disk *sdk
 			}
 		}
 
-		if (modepage == 0x3F) {
-			sd_printk(KERN_ERR, sdkp, "No Caching mode page "
-				  "present\n");
-			goto defaults;
-		} else if ((buffer[offset] & 0x3f) != modepage) {
-			sd_printk(KERN_ERR, sdkp, "Got wrong page\n");
-			goto defaults;
-		}
+		sd_printk(KERN_ERR, sdkp, "No Caching mode page found\n");
+		goto defaults;
+
 	Page_found:
 		if (modepage == 8) {
 			sdkp->WCE = ((buffer[offset + 2] & 0x04) != 0);

