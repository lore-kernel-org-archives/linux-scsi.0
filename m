From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [patch 5/6] ps3: BD/DVD/CD-ROM Storage Driver
Date: Mon, 16 Jul 2007 13:43:24 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0707161338230.1072@pademelon.sonytel.be>
References: <20070704132212.726923000@pademelon.sonytel.be>
 <Pine.LNX.4.62.0707131541150.18802@pademelon.sonytel.be>
 <1184335333.3402.20.camel@localhost.localdomain> <200707131619.54898.arnd@arndb.de>
 <Pine.LNX.4.62.0707131707290.18802@pademelon.sonytel.be>
 <1184340528.3402.32.camel@localhost.localdomain>
 <Pine.LNX.4.62.0707132212520.23000@chinchilla.sonytel.be>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-1167875890-1184586204=:1072"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:40603 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755009AbXGPLn0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2007 07:43:26 -0400
In-Reply-To: <Pine.LNX.4.62.0707132212520.23000@chinchilla.sonytel.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-scsi@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>, Alessandro Rubini <rubini@vision.unipv.it>, Linux/PPC Development <linuxppc-dev@ozlabs.org>, Paul Mackerras <paulus@samba.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-1167875890-1184586204=:1072
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 13 Jul 2007, Geert Uytterhoeven wrote:
> Ah, that explains it. flush_dcache_page() is used in some drivers.
> I'll update my patches. Thanks for the comments!

Does this look OK?
  - Replaced KM_USER0 by KM_IRQ0 (all routines are either called from an
    interrupt handler, from .request_fn (ps3disk), or from .queuecommand
    (ps3rom))
  - Add a call to flush_kernel_dcache_page() in routines that write to buffers

If this is OK, I'll fold it into my original patch series and will resend.

Thanks!

---
 drivers/block/ps3disk.c |    5 +++--
 drivers/scsi/ps3rom.c   |    9 +++++----
 2 files changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/block/ps3disk.c
+++ b/drivers/block/ps3disk.c
@@ -109,13 +109,14 @@ static void ps3disk_scatter_gather(struc
 			bio_sectors(bio), sector);
 		bio_for_each_segment(bvec, bio, j) {
 			size = bio_cur_sectors(bio)*KERNEL_SECTOR_SIZE;
-			buf = __bio_kmap_atomic(bio, j, KM_USER0);
+			buf = __bio_kmap_atomic(bio, j, KM_IRQ0);
 			if (gather)
 				memcpy(dev->bounce_buf+offset, buf, size);
 			else
 				memcpy(buf, dev->bounce_buf+offset, size);
 			offset += size;
-			__bio_kunmap_atomic(bio, KM_USER0);
+			flush_kernel_dcache_page(bio_iovec_idx(bio, j)->bv_page);
+			__bio_kunmap_atomic(bio, KM_IRQ0);
 		}
 		sectors += bio_sectors(bio);
 		i++;
--- a/drivers/scsi/ps3rom.c
+++ b/drivers/scsi/ps3rom.c
@@ -112,7 +112,7 @@ static int fill_from_dev_buffer(struct s
 	active = 1;
 	for (k = 0, req_len = 0, act_len = 0; k < cmd->use_sg; ++k, ++sgpnt) {
 		if (active) {
-			kaddr = kmap_atomic(sgpnt->page, KM_USER0);
+			kaddr = kmap_atomic(sgpnt->page, KM_IRQ0);
 			if (!kaddr)
 				return -1;
 			len = sgpnt->length;
@@ -121,7 +121,8 @@ static int fill_from_dev_buffer(struct s
 				len = buflen - req_len;
 			}
 			memcpy(kaddr + sgpnt->offset, buf + req_len, len);
-			kunmap_atomic(kaddr, KM_USER0);
+			flush_kernel_dcache_page(sgpnt->page);
+			kunmap_atomic(kaddr, KM_IRQ0);
 			act_len += len;
 		}
 		req_len += sgpnt->length;
@@ -149,7 +150,7 @@ static int fetch_to_dev_buffer(struct sc
 
 	sgpnt = cmd->request_buffer;
 	for (k = 0, req_len = 0, fin = 0; k < cmd->use_sg; ++k, ++sgpnt) {
-		kaddr = kmap_atomic(sgpnt->page, KM_USER0);
+		kaddr = kmap_atomic(sgpnt->page, KM_IRQ0);
 		if (!kaddr)
 			return -1;
 		len = sgpnt->length;
@@ -158,7 +159,7 @@ static int fetch_to_dev_buffer(struct sc
 			fin = 1;
 		}
 		memcpy(buf + req_len, kaddr + sgpnt->offset, len);
-		kunmap_atomic(kaddr, KM_USER0);
+		kunmap_atomic(kaddr, KM_IRQ0);
 		if (fin)
 			return req_len + len;
 		req_len += sgpnt->length;

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
---584337861-1167875890-1184586204=:1072--
