From: Adrian Bunk <bunk@fs.tum.de>
Subject: [2.4 patch] remove REPORT_LUNS from cpqfcTSstructs.h
Date: Wed, 7 Jan 2004 15:34:20 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040107143420.GZ11523@fs.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hermes.fachschaften.tu-muenchen.de ([129.187.202.12]:33011 "HELO
	hermes.fachschaften.tu-muenchen.de") by vger.kernel.org with SMTP
	id S266208AbUAGOe0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Jan 2004 09:34:26 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Marcelo Tosatti <marcelo.tosatti@cyclades.com>
Cc: linux-kernel@vger.kernel.org, jgarzik@pobox.com, linux-scsi@vger.kernel.org

Jeff Garzik added a #define REPORT_LUNS to scsi.h resulting in the 
following compile warnings for a similar #deine in cpqfcTSstructs.h:

<--  snip  -->

gcc-2.95 -D__KERNEL__ -I/home/bunk/linux/kernel-2.4/linux-2.4.25-pre4-full/include -Wall -Wstrict-prototypes -Wno-trigraphs -O2 -fno-strict-aliasing 
-fno-common -fomit-frame-pointer -pipe -mpreferred-stack-boundary=2 -march=k6   
-nostdinc -iwithprefix include -DKBUILD_BASENAME=cpqfcTSinit  -c -o cpqfcTSinit.o 
cpqfcTSinit.c
In file included from cpqfcTSinit.c:57:
cpqfcTSstructs.h:222: warning: `REPORT_LUNS' redefined
/home/bunk/linux/kernel-2.4/linux-2.4.25-pre4-full/include/scsi/scsi.h:81: 
warning: this is the location of the previous definition
gcc-2.95 -D__KERNEL__ -I/home/bunk/linux/kernel-2.4/linux-2.4.25-pre4-full/inclu
de -Wall -Wstrict-prototypes -Wno-trigraphs -O2 -fno-strict-aliasing 
-fno-common -fomit-frame-pointer -pipe -mpreferred-stack-boundary=2 -march=k6   
-nostdinc -iwithprefix include -DKBUILD_BASENAME=cpqfcTScontrol  -c -o 
cpqfcTScontrol.o cpqfcTScontrol.c
In file included from cpqfcTScontrol.c:48:
cpqfcTSstructs.h:222: warning: `REPORT_LUNS' redefined
/home/bunk/linux/kernel-2.4/linux-2.4.25-pre4-full/include/scsi/scsi.h:81: 
warning: this is the location of the previous definition
...
gcc-2.95 -D__KERNEL__ -I/home/bunk/linux/kernel-2.4/linux-2.4.25-pre4-full/include -Wall -Wstrict-prototypes -Wno-trigraphs -O2 -fno-strict-aliasing 
-fno-common -fomit-frame-pointer -pipe -mpreferred-stack-boundary=2 -march=k6   
-nostdinc -iwithprefix include -DKBUILD_BASENAME=cpqfcTSworker  -c -o 
cpqfcTSworker.o cpqfcTSworker.c
In file included from cpqfcTSworker.c:49:
cpqfcTSstructs.h:222: warning: `REPORT_LUNS' redefined
...

<--  snip  -->


REPORT_LUNS is already removed from cpqfcTSstructs.h in 2.6 and the 
patch below removes it from 2.4, too.

I've tested the compilation with 2.4.25-pre4.


Please apply
Adrian


--- linux-2.4.25-pre4-full/drivers/scsi/cpqfcTSstructs.h.old	2004-01-06 20:46:24.000000000 +0100
+++ linux-2.4.25-pre4-full/drivers/scsi/cpqfcTSstructs.h	2004-01-06 20:46:43.000000000 +0100
@@ -219,7 +219,6 @@
 #define ELS_PRLI_ACC		0x22		// {FCP-SCSI} Process Login Accept
 #define ELS_RJT			0x1000000
 #define SCSI_REPORT_LUNS	0x0A0
-#define REPORT_LUNS		0xA0		// SCSI-3 command op-code
 #define FCP_TARGET_RESET	0x200
 
 #define ELS_LILP_FRAME		0x00000711	// 1st payload word of LILP frame
