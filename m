From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: SCSI breaks 'make allyesconfig'
Date: Wed, 17 Nov 2004 09:05:22 -0500
Message-ID: <419B5AA2.7030801@pobox.com>
References: <419B5292.7080305@pobox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040602020805090908070301"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:5093 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262324AbUKQOFg
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Nov 2004 09:05:36 -0500
In-Reply-To: <419B5292.7080305@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

This is a multi-part message in MIME format.
--------------040602020805090908070301
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Jeff Garzik wrote:
> [jgarzik@pretzel linux-2.6]$ make
>   CHK     include/linux/version.h
> make[1]: `arch/i386/kernel/asm-offsets.s' is up to date.
>   CHK     include/linux/compile.h
>   CHK     usr/initramfs_list
>   LD      drivers/scsi/built-in.o
> drivers/scsi/osst.o(.bss+0x0): In function `exit_osst':
> drivers/scsi/osst.c:195: multiple definition of `ST_partstat'
> drivers/scsi/st.o(.bss+0x0):drivers/scsi/st.c:244: first defined here
> make[2]: *** [drivers/scsi/built-in.o] Error 1
> make[1]: *** [drivers/scsi] Error 2
> make: *** [drivers] Error 2


  ...and the attached patch fixes it.  'ST_partstat' is defined in 
drivers/scsi/st.h, but never used.

	Jeff



--------------040602020805090908070301
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

===== drivers/scsi/st.h 1.20 vs edited =====
--- 1.20/drivers/scsi/st.h	2004-10-25 14:32:30 -04:00
+++ edited/drivers/scsi/st.h	2004-11-17 08:36:22 -05:00
@@ -67,7 +67,7 @@
 	u32 last_block_visited;
 	int drv_block;		/* The block where the drive head is */
 	int drv_file;
-} ST_partstat;
+};
 
 #define ST_NBR_PARTITIONS 4
 

--------------040602020805090908070301--
