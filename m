From: Alexis Bruemmer <alexisb@us.ibm.com>
Subject: [PATCH 7/8] aic94xx: remove queue implementation comment
Date: Tue, 09 May 2006 14:39:42 -0700
Message-ID: <1147210782.11847.65.camel@localhost.localdomain>
References: <1147209211.11847.33.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:4566 "EHLO e36.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751161AbWEIVjo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 May 2006 17:39:44 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k49LdiVH029029
	for <linux-scsi@vger.kernel.org>; Tue, 9 May 2006 17:39:44 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k49Ldh7r175482
	for <linux-scsi@vger.kernel.org>; Tue, 9 May 2006 15:39:43 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id k49LdhWG009908
	for <linux-scsi@vger.kernel.org>; Tue, 9 May 2006 15:39:43 -0600
Received: from alexis.beaverton.ibm.com (alexis.beaverton.ibm.com [9.47.17.121])
	by d03av01.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id k49LdhIh009886
	for <linux-scsi@vger.kernel.org>; Tue, 9 May 2006 15:39:43 -0600
In-Reply-To: <1147209211.11847.33.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Remove the long queue implementation comment from sas_event.c that is no
longer valid

Signed-off-by: Alexis Bruemmer <alexisb@us.ibm.com>
Signed-off-by: Mike Anderson <andmike@us.ibm.com>

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



