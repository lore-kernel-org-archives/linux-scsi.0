From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH v4 22/23] mac_scsi: Fix pseudo DMA implementation
Date: Thu, 19 May 2016 22:02:45 +1000 (AEST)
Message-ID: <alpine.LNX.2.00.1605192148110.12845@nippy.intranet>
References: <20160323101009.341929635@telegraphics.com.au> <20160323101014.931733618@telegraphics.com.au> <CAMuHMdULODOJH7ozh3Qp=cSnuU=VrZr_CeSaDUJNdjjGf7s=zw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:50365 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754430AbcESMDr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 May 2016 08:03:47 -0400
In-Reply-To: <CAMuHMdULODOJH7ozh3Qp=cSnuU=VrZr_CeSaDUJNdjjGf7s=zw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>


On Thu, 19 May 2016, Geert Uytterhoeven wrote:

> 
> In file included from drivers/scsi/mac_scsi.c:335:
> drivers/scsi/NCR5380.h:295: warning: `NCR5380_poll_politely' declared inline after being called
> drivers/scsi/NCR5380.h:295: warning: previous declaration of `NCR5380_poll_politely' was here

Thanks for letting me know. My compiler (v4.4.6) doesn't warn about this. 
What GCC version are you using? Does this (untested) patch help?

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-05-19 21:31:05.000000000 +1000
+++ linux/drivers/scsi/NCR5380.c	2016-05-19 21:39:08.000000000 +1000
@@ -230,13 +230,6 @@ static int NCR5380_poll_politely2(struct
 	return -ETIMEDOUT;
 }
 
-static inline int NCR5380_poll_politely(struct Scsi_Host *instance,
-                                        int reg, int bit, int val, int wait)
-{
-	return NCR5380_poll_politely2(instance, reg, bit, val,
-	                                        reg, bit, val, wait);
-}
-
 #if NDEBUG
 static struct {
 	unsigned char mask;
Index: linux/drivers/scsi/NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/NCR5380.h	2016-05-19 19:47:06.000000000 +1000
+++ linux/drivers/scsi/NCR5380.h	2016-05-19 21:40:15.000000000 +1000
@@ -292,8 +292,10 @@ static void NCR5380_reselect(struct Scsi
 static struct scsi_cmnd *NCR5380_select(struct Scsi_Host *, struct scsi_cmnd *);
 static int NCR5380_transfer_dma(struct Scsi_Host *instance, unsigned char *phase, int *count, unsigned char **data);
 static int NCR5380_transfer_pio(struct Scsi_Host *instance, unsigned char *phase, int *count, unsigned char **data);
-static int NCR5380_poll_politely(struct Scsi_Host *, int, int, int, int);
 static int NCR5380_poll_politely2(struct Scsi_Host *, int, int, int, int, int, int, int);
 
+#define NCR5380_poll_politely(instance, reg, bit, val, wait) \
+        NCR5380_poll_politely2(instance, reg, bit, val, reg, bit, val, wait)
+
 #endif				/* __KERNEL__ */
 #endif				/* NCR5380_H */

-- 
