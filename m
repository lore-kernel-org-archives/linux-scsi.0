From: "Martin K. Petersen" <mkp@mkp.net>
Subject: Re: [PATCH V2] scsi_debug: add LBPRZ support
Date: Thu, 08 Mar 2012 10:48:29 -0500
Message-ID: <yq1ty1zf60i.fsf@sermon.lab.mkp.net>
References: <4F57C061.9020807@redhat.com> <4F58049C.5010505@interlog.com>
	<4F584BCF.7030803@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mojo.mkp.net ([70.38.64.14]:60593 "EHLO mojo.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757980Ab2CHQLN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Mar 2012 11:11:13 -0500
In-Reply-To: <4F584BCF.7030803@redhat.com> (Eric Sandeen's message of "Thu, 08
	Mar 2012 00:03:59 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Cc: dgilbert@interlog.com, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>

>>>>> "Eric" == Eric Sandeen <sandeen@redhat.com> writes:

Eric> note, I didn't change the return value of inquiry_evpd_b2(); that
Eric> seems unrelated to this change, and should be a separate patch,
Eric> no?


scsi_debug: Fix incorrect page length in logical block provisioning VPD

The page length for the 0xb2 VPD page is defined to be 4 bytes when no
provisioning descriptors are provided (DP=0).

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 6888b2c..a393a61 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -777,7 +777,7 @@ static int inquiry_evpd_b1(unsigned char *arr)
 /* Thin provisioning VPD page (SBC-3) */
 static int inquiry_evpd_b2(unsigned char *arr)
 {
-	memset(arr, 0, 0x8);
+	memset(arr, 0, 0x4);
 	arr[0] = 0;			/* threshold exponent */
 
 	if (scsi_debug_lbpu)
@@ -789,7 +789,7 @@ static int inquiry_evpd_b2(unsigned char *arr)
 	if (scsi_debug_lbpws10)
 		arr[1] |= 1 << 5;
 
-	return 0x8;
+	return 0x4;
 }
 
 #define SDEBUG_LONG_INQ_SZ 96
