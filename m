From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: PS3 Storage Driver O_DIRECT issue
Date: Wed, 18 Jul 2007 18:12:34 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0707181808030.15632@pademelon.sonytel.be>
References: <20070704132212.726923000@pademelon.sonytel.be>
 <20070713122752.GA854@aepfle.de>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-1037303210-1184774900=:15632"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:33803 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758282AbXGRQMg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Jul 2007 12:12:36 -0400
In-Reply-To: <20070713122752.GA854@aepfle.de>
Content-ID: <Pine.LNX.4.62.0707181808410.15632@pademelon.sonytel.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olaf Hering <olaf@aepfle.de>
Cc: Paul Mackerras <paulus@samba.org>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, Alessandro Rubini <rubini@ipvvis.unipv.it>, Geoff Levand <geoffrey.levand@am.sony.com>, Linux/PPC Development <linuxppc-dev@ozlabs.org>, Linux Kernel Development <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-1037303210-1184774900=:15632
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.62.0707181808411.15632@pademelon.sonytel.be>

On Fri, 13 Jul 2007, Olaf Hering wrote:
> This driver (or the generic PS3 code) has appearently problems with
> O_DIRECT. 
> glibc aborts parted because the malloc metadata get corrupted. While it
> is reproducible, the place where it crashes changes with every version
> of the debug attempt.
> I dont have a handle right now, all I know is that the metadata after a
> malloc area get overwritten with zeros.
> 
> 
> Can you have a look at this? 
> parted /dev/ps3da
> print (a few times)

I could reproduce it with parted 1.8.0 and later.

The patch below fixes it (tested with 1.8.0, 1.8.2 (FC6), 1.9.0 (git)).

Apparently sometimes bio_cur_sectors(bio)*KERNEL_SECTOR_SIZE != bvec->bv_len
when using O_DIRECT. Is that true (or a bug?)?

If it's OK, I'll fold this patch into the main ps3disk patch.
---
 drivers/block/ps3disk.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/ps3disk.c
+++ b/drivers/block/ps3disk.c
@@ -108,7 +108,7 @@ static void ps3disk_scatter_gather(struc
 			__func__, __LINE__, i, bio_segments(bio),
 			bio_sectors(bio), sector);
 		bio_for_each_segment(bvec, bio, j) {
-			size = bio_cur_sectors(bio)*KERNEL_SECTOR_SIZE;
+			size = bvec->bv_len;
 			buf = __bio_kmap_atomic(bio, j, KM_IRQ0);
 			if (gather)
 				memcpy(dev->bounce_buf+offset, buf, size);

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
---584337861-1037303210-1184774900=:15632--
