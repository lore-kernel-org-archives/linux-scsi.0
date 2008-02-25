From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH 2/2] ps3rom: Simplify fill_from_dev_buffer()
Date: Mon, 25 Feb 2008 14:24:31 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802251423470.31208@vixen.sonytel.be>
References: <1203895523-4009-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <Pine.LNX.4.64.0802251420270.31208@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-2050510550-1203945871=:31208"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:39077 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750813AbYBYNYc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Feb 2008 08:24:32 -0500
In-Reply-To: <Pine.LNX.4.64.0802251420270.31208@vixen.sonytel.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, tomof@acm.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-2050510550-1203945871=:31208
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

Subject: [PATCH] ps3rom: Simplify fill_from_dev_buffer()

As we no longer need to calculate the data length of the whole scatterlist,
we can abort the loop earlier and coalesce req_len and act_len into one
variable, making fill_from_dev_buffer() more similar to fetch_to_dev_buffer().

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 drivers/scsi/ps3rom.c |   30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

--- a/drivers/scsi/ps3rom.c
+++ b/drivers/scsi/ps3rom.c
@@ -95,7 +95,7 @@ static int ps3rom_slave_configure(struct
  */
 static int fill_from_dev_buffer(struct scsi_cmnd *cmd, const void *buf)
 {
-	int k, req_len, act_len, len, active;
+	int k, req_len, len, fin;
 	void *kaddr;
 	struct scatterlist *sgpnt;
 	unsigned int buflen;
@@ -107,24 +107,22 @@ static int fill_from_dev_buffer(struct s
 	if (!scsi_sglist(cmd))
 		return -1;
 
-	active = 1;
-	req_len = act_len = 0;
+	req_len = fin = 0;
 	scsi_for_each_sg(cmd, sgpnt, scsi_sg_count(cmd), k) {
-		if (active) {
-			kaddr = kmap_atomic(sg_page(sgpnt), KM_IRQ0);
-			len = sgpnt->length;
-			if ((req_len + len) > buflen) {
-				active = 0;
-				len = buflen - req_len;
-			}
-			memcpy(kaddr + sgpnt->offset, buf + req_len, len);
-			flush_kernel_dcache_page(sg_page(sgpnt));
-			kunmap_atomic(kaddr, KM_IRQ0);
-			act_len += len;
+		kaddr = kmap_atomic(sg_page(sgpnt), KM_IRQ0);
+		len = sgpnt->length;
+		if ((req_len + len) > buflen) {
+			len = buflen - req_len;
+			fin = 1;
 		}
-		req_len += sgpnt->length;
+		memcpy(kaddr + sgpnt->offset, buf + req_len, len);
+		flush_kernel_dcache_page(sg_page(sgpnt));
+		kunmap_atomic(kaddr, KM_IRQ0);
+		req_len += len;
+		if (fin)
+			break;
 	}
-	scsi_set_resid(cmd, buflen - act_len);
+	scsi_set_resid(cmd, buflen - req_len);
 	return 0;
 }
 
With kind regards,

Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

Sony Network and Software Technology Center Europe
A division of Sony Service Centre (Europe) N.V.
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium
VAT BE 0413.825.160 · RPR Brussels
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619
---584349381-2050510550-1203945871=:31208--
