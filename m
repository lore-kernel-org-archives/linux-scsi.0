From: "Dupuis, Chad" <chad.dupuis@hp.com>
Subject: patch for scsi_devinfo.c
Date: Mon, 21 Jun 2004 16:07:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A8B003DDA3332A479C0ECCA641F47E6503BE69F9@tayexc13.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zmamail04.zma.compaq.com ([161.114.64.104]:47374 "EHLO
	zmamail04.zma.compaq.com") by vger.kernel.org with ESMTP
	id S266444AbUFUUHG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Jun 2004 16:07:06 -0400
Received: from tayexg12.americas.cpqcorp.net (tayexg12.americas.cpqcorp.net [16.103.130.103])
	by zmamail04.zma.compaq.com (Postfix) with ESMTP id 74409623A
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jun 2004 16:07:06 -0400 (EDT)
Content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The entries for HP and Compaq HSV110 are incorrect.  The HSV110
controllers report themselves as SCSI 2 devices and therefore need the
BLIST_LARGELUN flag to see LUNs passed 7.

----------------------------------------
--- scsi_devinfo.c      2004-06-21 16:06:14.000000000 -0400
+++ scsi_devinfo.c.new  2004-06-21 16:01:43.000000000 -0400
@@ -126,7 +126,7 @@ static struct {
        {"COMPAQ", "CR3500", NULL, BLIST_FORCELUN},
        {"COMPAQ", "MSA1000", NULL, BLIST_SPARSELUN |
BLIST_NOSTARTONADD},
        {"COMPAQ", "MSA1000 VOLUME", NULL, BLIST_SPARSELUN |
BLIST_NOSTARTONADD},
-       {"COMPAQ", "HSV110", NULL, BLIST_SPARSELUN |
BLIST_NOSTARTONADD},
+       {"COMPAQ", "HSV110", NULL, BLIST_SPARSELUN | BLIST_LARGELUN |
BLIST_NOSTARTONADD},
        {"DDN", "SAN DataDirector", "*", BLIST_SPARSELUN},
        {"DEC", "HSG80", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
        {"DELL", "PV660F", NULL, BLIST_SPARSELUN},
@@ -147,7 +147,7 @@ static struct {
        {"HP", "A6189A", NULL, BLIST_SPARSELUN | BLIST_LARGELUN},
/* HP VA7400 */
        {"HP", "OPEN-", "*", BLIST_SPARSELUN | BLIST_LARGELUN}, /* HP XP
Arrays */
        {"HP", "NetRAID-4M", NULL, BLIST_FORCELUN},
-       {"HP", "HSV100", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
+       {"HP", "HSV100", NULL, BLIST_SPARSELUN | BLIST_LARGELUN |
BLIST_NOSTARTONADD},
        {"HP", "C1557A", NULL, BLIST_FORCELUN},
        {"IBM", "AuSaV1S2", NULL, BLIST_FORCELUN},
        {"IBM", "ProFibre 4000R", "*", BLIST_SPARSELUN |
BLIST_LARGELUN},
