From: Steve Wilcox <spwilcox@att.com>
Subject: [PATCH]  DEC hsg80 needs BLIST_REPORTLUN2
Date: Tue, 09 Aug 2005 13:26:57 -0400
Message-ID: <1123608417.30193.23.camel@aptis101.cqtel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail121.messagelabs.com ([216.82.241.195]:59109 "HELO
	mail121.messagelabs.com") by vger.kernel.org with SMTP
	id S932550AbVHIR1A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Aug 2005 13:27:00 -0400
Received: from OCCLUST04EVS1.ugd.att.com (135.38.164.12) by attrh3i.attrh.att.com (7.2.052)
        id 42E3BC2B00445C9E for linux-scsi@vger.kernel.org; Tue, 9 Aug 2005 13:26:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi mailing list <linux-scsi@vger.kernel.org>

In order to properly report LUN's > 7, the DEC HSG80 definition in
scsi_devinfo.c needs to include BLIST_REPORTLUN2 rather than
BLIST_SPARSELUN.  I've tested this change with several HSG firmware
revisions and with both Emulex and Qlogic HBA's.

-Steve


--- /drivers/scsi/scsi_devinfo.c 2005-05-09 12:28:15.000000000 -0400
+++ /drivers/scsi/scsi_devinfo.c 2005-05-09 12:29:03.000000000 -0400
@@ -135,7 +135,7 @@ static struct {
	{"COMPAQ", "MSA1000 VOLUME", NULL, BLIST_SPARSELUN |
BLIST_NOSTARTONADD},
	{"COMPAQ", "HSV110", NULL, BLIST_REPORTLUN2 | BLIST_NOSTARTONADD},
	{"DDN", "SAN DataDirector", "*", BLIST_SPARSELUN},
-	{"DEC", "HSG80", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
+	{"DEC", "HSG80", NULL, BLIST_REPORTLUN2 | BLIST_NOSTARTONADD},
	{"DELL", "PV660F", NULL, BLIST_SPARSELUN},
	{"DELL", "PV660F PSEUDO", NULL, BLIST_SPARSELUN},
	{"DELL", "PSEUDO DEVICE .", NULL, BLIST_SPARSELUN}, /* Dell PV 530F */
