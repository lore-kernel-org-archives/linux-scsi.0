From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH] update some devinfo entries
Date: Tue, 15 Aug 2006 17:00:28 -0400
Message-ID: <1155675629.16063.9.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:59330 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1750746AbWHOWAK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Aug 2006 18:00:10 -0400
Received: from [192.168.0.5] (CPE-70-92-133-61.mn.res.rr.com [70.92.133.61])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id k7FM08gb028207
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 15 Aug 2006 17:00:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

The RHEL4 kernel contains some devinfo entries that
upstream does not so I thought I should try and update
upstream.

Most of them are new entries or pretty straight forward,
except this one:

-       {"HITACHI", "OPEN-E", "*", BLIST_ATTACH_PQ3 | BLIST_SPARSELUN | BLIST_LARGELUN},
+       {"HITACHI", "OPEN-", "*", BLIST_ATTACH_PQ3 | BLIST_SPARSELUN | BLIST_LARGELUN},

In RHEL we used to have OPEN-V, OPEN-L and OPEN-V and those used
BLIST_SPARSELUN | BLIST_LARGELUN. We consolidated those to just
OPEN-.

Upstream has "OPEN-E" with
BLIST_ATTACH_PQ3 | BLIST_SPARSELUN | BLIST_LARGELUN

So I am not sure if consolidating that one into OPEN- is ok
since I am not adding BLIST_ATTACH_PQ3 for all OPEN-.

I do not have any of this HW. I have only compile tested
the patch. It was built over scsi-rc-fixes.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 3d0429b..54a3f3d 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -141,7 +141,9 @@ static struct {
 	{"COMPAQ", "MSA1000", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
 	{"COMPAQ", "MSA1000 VOLUME", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
 	{"COMPAQ", "HSV110", NULL, BLIST_REPORTLUN2 | BLIST_NOSTARTONADD},
-	{"DDN", "SAN DataDirector", "*", BLIST_SPARSELUN},
+	{"DDN", "SAN DataDirector", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
+	{"DDN", "S2A 8400", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
+	{"DDN", "S2A 8500", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"DEC", "HSG80", NULL, BLIST_REPORTLUN2 | BLIST_NOSTARTONADD},
 	{"DELL", "PV660F", NULL, BLIST_SPARSELUN},
 	{"DELL", "PV660F   PSEUDO", NULL, BLIST_SPARSELUN},
@@ -150,6 +152,7 @@ static struct {
 	{"DELL", "PERCRAID", NULL, BLIST_FORCELUN},
 	{"DGC", "RAID", NULL, BLIST_SPARSELUN},	/* Dell PV 650F, storage on LUN 0 */
 	{"DGC", "DISK", NULL, BLIST_SPARSELUN},	/* Dell PV 650F, no storage on LUN 0 */
+	{"EMC",  "Invista", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"EMC", "SYMMETRIX", NULL, BLIST_SPARSELUN | BLIST_LARGELUN | BLIST_FORCELUN},
 	{"EMULEX", "MD21/S2     ESDI", NULL, BLIST_SINGLELUN},
 	{"FSC", "CentricStor", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
@@ -160,9 +163,9 @@ static struct {
 	{"HITACHI", "DF500", "*", BLIST_SPARSELUN},
 	{"HITACHI", "DF600", "*", BLIST_SPARSELUN},
 	{"HITACHI", "DISK-SUBSYSTEM", "*", BLIST_ATTACH_PQ3 | BLIST_SPARSELUN | BLIST_LARGELUN},
-	{"HITACHI", "OPEN-E", "*", BLIST_ATTACH_PQ3 | BLIST_SPARSELUN | BLIST_LARGELUN},
+	{"HITACHI", "OPEN-", "*", BLIST_ATTACH_PQ3 | BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"HP", "A6189A", NULL, BLIST_SPARSELUN | BLIST_LARGELUN},	/* HP VA7400 */
-	{"HP", "OPEN-", "*", BLIST_REPORTLUN2}, /* HP XP Arrays */
+	{"HP", "OPEN-", "*", BLIST_REPORTLUN2 | BLIST_SPARSELUN | BLIST_LARGELUN}, /* HP XP Arrays */
 	{"HP", "NetRAID-4M", NULL, BLIST_FORCELUN},
 	{"HP", "HSV100", NULL, BLIST_REPORTLUN2 | BLIST_NOSTARTONADD},
 	{"HP", "C1557A", NULL, BLIST_FORCELUN},
@@ -188,6 +191,7 @@ static struct {
 	{"NAKAMICH", "MJ-4.8S", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"NAKAMICH", "MJ-5.16S", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"NEC", "PD-1 ODX654P", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
+	{"NEC", "iStorage", NULL, BLIST_REPORTLUN2},
 	{"NRC", "MBR-7", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"NRC", "MBR-7.4", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"PIONEER", "CD-ROM DRM-600", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
@@ -210,6 +214,7 @@ static struct {
 	{"SUN", "T300", "*", BLIST_SPARSELUN},
 	{"SUN", "T4", "*", BLIST_SPARSELUN},
 	{"TEXEL", "CD-ROM", "1.06", BLIST_BORKEN},
+	{"Tornado-", "F4", "*", BLIST_NOREPORTLUN},
 	{"TOSHIBA", "CDROM", NULL, BLIST_ISROM},
 	{"TOSHIBA", "CD-ROM", NULL, BLIST_ISROM},
 	{"USB2.0", "SMARTMEDIA/XD", NULL, BLIST_FORCELUN | BLIST_INQUIRY_36},


