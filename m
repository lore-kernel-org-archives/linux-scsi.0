From: Stephen Hemminger <shemminger@osdl.org>
Subject: SCSI enclosure black list
Date: 13 Nov 2002 14:15:13 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1037225713.16638.85.camel@dell_ss3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-scsi@vger.kernel.org


On Tue, 2002-11-12 at 14:44, Stephen Hemminger wrote:
> Our megaraid problems turned out to be a problem with probing the IBM
> EXP300 SCSI RAID enclosure.  The enclosure responds to the initial
> inquiry but does not respond to report LUN's adding it to the black
list
> fixes the problem.
> 
> Thanks to Matt Domsch and Mark Haverkamp. Don't give up the good work
> the megaraid driver still needs better error handling.

The HP disk enclosures have the same behavior so use this patch instead:

diff -urN -X dontdiff linux-2.5/drivers/scsi/scsi_scan.c
linux-2.5-megaraid/drivers/scsi/scsi_scan.c
--- linux-2.5/drivers/scsi/scsi_scan.c	2002-11-11 11:02:17.000000000
-0800
+++ linux-2.5-megaraid/drivers/scsi/scsi_scan.c	2002-11-12
15:10:38.000000000 -0800
@@ -183,6 +183,8 @@
 	{"COMPAQ", "MSA1000", NULL, BLIST_FORCELUN},
 	{"HP", "C1557A", NULL, BLIST_FORCELUN},
 	{"IBM", "AuSaV1S2", NULL, BLIST_FORCELUN},
+	{"HP", "SFTE", NULL, BLIST_NOLUN},
+	{"IBM", "EXP300", NULL, BLIST_NOLUN},
 };
 
 #define ALLOC_FAILURE_MSG	KERN_ERR "%s: Allocation failure during" \


