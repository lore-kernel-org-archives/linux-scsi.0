From: Alexis Bruemmer <alexisb@us.ibm.com>
Subject: [PATCH 5/7] aic94xx: remove queue comment
Date: Tue, 06 Jun 2006 16:50:25 -0700
Message-ID: <1149637825.25278.78.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:33004 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751375AbWFFXum
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Jun 2006 19:50:42 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k56NofTD006569
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jun 2006 19:50:41 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.6/NCO/VER7.0) with ESMTP id k56NofTY184462
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jun 2006 17:50:41 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k56NofNE004447
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jun 2006 17:50:41 -0600
Received: from alexis.beaverton.ibm.com (alexis.beaverton.ibm.com [9.47.17.62])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k56NoeVi004439
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jun 2006 17:50:41 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Remove the long queue implementation comment-- no longer valid

Signed-off-by: Alexis Bruemmer <alexisb@us.ibm.com>

---
 drivers/scsi/sas/sas_event.c |   40 ----------------------------------------
 1 files changed, 40 deletions(-)

Index: aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_event.c
===================================================================
--- aic94xx-sas-2.6-patched.orig/drivers/scsi/sas/sas_event.c
+++ aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_event.c
@@ -22,46 +22,6 @@
  *
  */
 
-/**
- * Implementation Of Priority Queue Without Duplication
- * Luben Tuikov 2005/07/11
- *
- * The SAS class implements priority queue without duplication for
- * handling ha/port/phy/discover events.  That is, we want to process
- * the last N unique/non-duplicating events, in the order they arrived.
- *
- * The requirement is that insertion is O(1), and ordered removal is O(1).
- *
- * Suppose events are identified by integers.  Then what is required
- * is that for a given sequence of any random integers R, to find a
- * sorted sequence E, where
- *     a) |E| <= |R|.  If the number of types of events is bounded,
- *        then E is also bounded by that number, from b).
- *     b) For all i and k, E[i] != E[k], except when i == k,
- *        this gives us uniqueness/non duplication.
- *     c) For all i < k, Order(E[i]) < Order(E[k]), this gives us
- *        ordering.
- *     d) If T(R) = E, then O(T) <= |R|, this ensures that insertion
- *        is O(1), and ordered removal is O(1) trivially, since we
- *        remove at the head of E.
- *
- * Example:
- * If R = {4, 5, 1, 2, 5, 3, 3, 4, 4, 3, 1}, then
- *    E = {2, 5, 4, 3, 1}.
- *
- * The algorithm, T, makes use of an array of list elements, indexed
- * by event type, and an event list head which is a linked list of the
- * elements of the array.  When the next event arrives, we index the
- * array by the event, and add that event to the tail of the event
- * list head, deleting it from its previous list position (if it had
- * one).
- *
- * Clearly insertion is O(1).
- *
- * E is given by the elements of the event list, traversed from head
- * to tail.
- */
-
 #include <scsi/scsi_host.h>
 #include "sas_internal.h"
 #include "sas_dump.h"


