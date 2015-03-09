From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH] sym53c416: Fix nasty memory corruption
Date: Mon,  9 Mar 2015 23:36:48 +0100
Message-ID: <1425940608-882-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:53518 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbbCIWhD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Mar 2015 18:37:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Kernel development list <linux-kernel@vger.kernel.org>

In sym53c416_read(), the chip can (and does sometimes) return more bytes in
the FIFO than we want to read. This causes buffer overflow, resulting in nasty
memory and data corruption and oopses. I couldn't even read filesystem's root
directory properly (and a simple dd with 1M blocksize crashed the system)
without this patch.

Add a check to make sure we never read more bytes than required.
sym53c416_write() already contains similar check.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/sym53c416.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/sym53c416.c b/drivers/scsi/sym53c416.c
index 0b7819f..76e9715 100644
--- a/drivers/scsi/sym53c416.c
+++ b/drivers/scsi/sym53c416.c
@@ -253,6 +253,8 @@ static __inline__ unsigned int sym53c416_read(int base, unsigned char *buffer, u
 	while(len && timeout)
 	{
 		bytes_left = inb(base + PIO_FIFO_CNT); /* Number of bytes in the PIO FIFO */
+		if (bytes_left > len)
+			bytes_left = len;
 		if(fastpio && bytes_left > 3)
 		{
 			insl(base + PIO_FIFO_1, buffer, bytes_left >> 2);
-- 
Ondrej Zary

