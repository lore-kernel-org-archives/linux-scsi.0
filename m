From: Andrew Morton <akpm@digeo.com>
Subject: Making sym-2 do 160 MB/sec
Date: Wed, 19 Feb 2003 12:06:39 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030219120639.3df58497.akpm@digeo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from digeo-nav01.digeo.com (digeo-nav01.digeo.com [192.168.1.233])
	by packet.digeo.com (8.9.3+Sun/8.9.3) with SMTP id MAA19590
	for <linux-scsi@vger.kernel.org>; Wed, 19 Feb 2003 12:08:54 -0800 (PST)
Received: from digeo-e2k04.digeo.com ([192.168.2.24])
 by digeo-nav01.digeo.com (NAVGW 2.5.2.12) with SMTP id M2003021912104832280
 for <linux-scsi@vger.kernel.org>; Wed, 19 Feb 2003 12:10:48 -0800
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


I have a machine here in which both the controller (53c1010) and the disk
(IBM IC35L036UCD210-0) can do FAST-80, but the sym2 driver only does FAST-40.

The below patch fixes it up, and has been fearsomely tested.

Can anyone tell me whether it is right, and what is generally going on in
there?


diff -puN drivers/scsi/sym53c8xx_2/sym_hipd.c~sym-do-160 drivers/scsi/sym53c8xx_2/sym_hipd.c
--- 25-power4/drivers/scsi/sym53c8xx_2/sym_hipd.c~sym-do-160	2003-02-19 01:04:59.000000000 -0800
+++ 25-power4-akpm/drivers/scsi/sym53c8xx_2/sym_hipd.c	2003-02-19 01:05:13.000000000 -0800
@@ -800,7 +800,8 @@ static int sym_prepare_setting(hcb_p np,
 	 * Btw, 'period' is in tenths of nanoseconds.
 	 */
 	period = (4 * div_10M[0] + np->clock_khz - 1) / np->clock_khz;
-	if	(period <= 250)		np->minsync = 10;
+	if	(period == 250)		np->minsync = 9;
+	else if	(period <= 250)		np->minsync = 10;
 	else if	(period <= 303)		np->minsync = 11;
 	else if	(period <= 500)		np->minsync = 12;
 	else				np->minsync = (period + 40 - 1) / 40;

_
  
