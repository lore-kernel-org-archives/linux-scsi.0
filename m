From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH] Don't define empty struct bsg_class_device if !CONFIG_BLK_DEV_BSG
 (was: Re: block/bsg.c)
Date: Tue, 17 Jul 2007 14:04:54 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0707171359110.29326@pademelon.sonytel.be>
References: <20070716165706.348f6bbf.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-52744245-1184673894=:29326"
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752169AbXGQMFZ@vger.kernel.org>
In-Reply-To: <20070716165706.348f6bbf.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Development <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-52744245-1184673894=:29326
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

Don't define an empty struct bsg_class_device if !CONFIG_BLK_DEV_BSG.

It's embedded in struct request_queue, but there we have

#if defined(CONFIG_BLK_DEV_BSG)
	struct bsg_class_device bsg_dev;
#endif

anyway.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
At first I considered dropping the #ifdef around request_queue.bsg_dev, but
that would make the code more error-prone.

 include/linux/bsg.h |    1 -
 1 files changed, 1 deletion(-)

--- a/include/linux/bsg.h
+++ b/include/linux/bsg.h
@@ -60,7 +60,6 @@ struct bsg_class_device {
 extern int bsg_register_queue(struct request_queue *, const char *);
 extern void bsg_unregister_queue(struct request_queue *);
 #else
-struct bsg_class_device { };
 #define bsg_register_queue(disk, name)		(0)
 #define bsg_unregister_queue(disk)	do { } while (0)
 #endif

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
---584337861-52744245-1184673894=:29326--
